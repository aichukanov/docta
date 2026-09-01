import { getConnection } from '~/server/common/db-mysql';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';

// Отдельным блоком, чтобы справочный режим мог его не запрашивать.
const DESCRIPTION_COLUMNS = `
				c.description_sr,
				c.description_sr_cyrl,
				c.description_en,
				c.description_ru,
				c.description_de,
				c.description_tr,`;

import { fetchClinicCoupons } from '~/server/common/clinic-coupons';
import { getCurrentUser } from '~/server/common/auth';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
import type { ClinicList } from '~/interfaces/clinic';
import type {
	DayOfWeek,
	DaySchedule,
	WorkingHours,
} from '~/interfaces/clinic-working-hours';
import {
	DAYS_OF_WEEK,
	DEFAULT_DAY_SCHEDULE,
} from '~/interfaces/clinic-working-hours';
import {
	isValidLocale,
	validateCityIds,
	validateClinicTypeIds,
	validateDoctorLanguageIds,
	validateMinRating,
	validateName,
	validateSpecialtyIds,
	validateUserCoordinates,
} from '~/common/validation';
import { PROXIMITY_WEIGHT, PROXIMITY_HALF_DISTANCE_KM } from '~/common/ranking';
import { LIST_PAGE_SIZE } from '~/common/constants';
import { foldedLikeAny } from '~/server/common/search-collation';

function parseDaySchedule(value: unknown): DaySchedule {
	if (!value) return DEFAULT_DAY_SCHEDULE;
	if (typeof value === 'string') {
		try {
			return JSON.parse(value) as DaySchedule;
		} catch {
			return DEFAULT_DAY_SCHEDULE;
		}
	}
	return value as DaySchedule;
}

function buildWorkingHours(
	row: any,
): Omit<WorkingHours, 'clinicId'> | undefined {
	if (!row) return undefined;
	const hasAnyDay = DAYS_OF_WEEK.some((day) => row[day] != null);
	if (!hasAnyDay) return undefined;
	return {
		monday: parseDaySchedule(row.monday),
		tuesday: parseDaySchedule(row.tuesday),
		wednesday: parseDaySchedule(row.wednesday),
		thursday: parseDaySchedule(row.thursday),
		friday: parseDaySchedule(row.friday),
		saturday: parseDaySchedule(row.saturday),
		sunday: parseDaySchedule(row.sunday),
	};
}

// Клиники всегда в Черногории, сервер — в UTC. Та же константа, что в
// common/clinic-working-hours.ts:13; оттуда она не экспортируется, поэтому
// продублирована — менять надо в обоих местах.
const CLINIC_TIMEZONE = 'Europe/Podgorica';

// Сколько интервалов в одном дне может быть: зеркало MAX_INTERVALS_PER_DAY из
// валидатора common/clinic-working-hours.ts (в экспорт он не вынесен).
// Условие ниже разворачивается по индексам интервалов именно потому, что
// коррелированный JSON_TABLE в MySQL 8.0.45 внутри EXISTS молча возвращает
// пусто (0 строк там, где кросс-джойн той же JSON_TABLE даёт 99).
const MAX_INTERVALS_PER_DAY = 3;

/**
 * SQL-условие «клиника открыта прямо сейчас».
 *
 * Раньше это считалось в JS поверх уже полученной выдачи, и ради одного
 * фильтра ОТКЛЮЧАЛАСЬ пагинация в БД: выбирался весь список клиник и резался
 * в памяти. В SQL условие выражается без таблиц часовых поясов MySQL — день
 * недели и время в Europe/Podgorica считает Node, в запрос уезжают готовые
 * значения.
 *
 * Время сравнивается как строка: формат строго «HH:mm» с ведущим нулём
 * (TIME_REGEX в валидаторе), поэтому лексикографический порядок совпадает
 * с числовым и отдельная конвертация в минуты не нужна.
 *
 * Совпадение с calculateStatus(): открыто ⇔ день типа '24/7' либо 'regular'
 * с интервалом start <= now < end. Типы closed / on_demand / not_specified,
 * отсутствующая строка расписания и NULL-день дают «закрыто» — ровно как
 * parseDaySchedule + calculateStatus в JS.
 */
function buildOpenNowFilter(now: Date = new Date()): {
	sql: string;
	params: string[];
} {
	const parts = new Intl.DateTimeFormat('en-US', {
		timeZone: CLINIC_TIMEZONE,
		weekday: 'long',
		hour: '2-digit',
		minute: '2-digit',
		hour12: false,
	}).formatToParts(now);
	const get = (type: string) => parts.find((p) => p.type === type)!.value;

	const weekday = get('weekday').toLowerCase();
	// Имя колонки уезжает в SQL конкатенацией, поэтому берётся только из
	// белого списка. Intl всегда отдаёт полное английское имя дня, так что
	// запасная ветка недостижима — она страхует сам факт конкатенации.
	const day: DayOfWeek = (DAYS_OF_WEEK as string[]).includes(weekday)
		? (weekday as DayOfWeek)
		: 'monday';
	// hour12:false отдаёт полночь как «24» — тот же %24, что в getClinicLocalTime
	const hhmm = `${String(Number(get('hour')) % 24).padStart(2, '0')}:${get(
		'minute',
	)}`;

	const typeExpr = `JSON_UNQUOTE(JSON_EXTRACT(cwh_open.${day}, '$.type'))`;
	const intervalChecks: string[] = [];
	const params: string[] = [];
	for (let i = 0; i < MAX_INTERVALS_PER_DAY; i++) {
		intervalChecks.push(
			`(JSON_UNQUOTE(JSON_EXTRACT(cwh_open.${day}, '$.intervals[${i}].start')) <= ? AND JSON_UNQUOTE(JSON_EXTRACT(cwh_open.${day}, '$.intervals[${i}].end')) > ?)`,
		);
		params.push(hhmm, hhmm);
	}

	return {
		sql: `EXISTS (
				SELECT 1 FROM clinic_working_hours cwh_open
				WHERE cwh_open.clinic_id = c.id AND (
					${typeExpr} = '24/7'
					OR (${typeExpr} = 'regular' AND (${intervalChecks.join(' OR ')}))
				)
			)`,
		params,
	};
}

export default defineEventHandler(async (event): Promise<ClinicList> => {
	try {
		const body = (await readBody(event)) || {};

		if (body.cityIds && !validateCityIds(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { clinics: [], totalCount: 0 };
		}
		if (
			body.languageIds &&
			!validateDoctorLanguageIds(
				{ languageIds: body.languageIds },
				'api/clinics/list',
			)
		) {
			setResponseStatus(event, 400, 'Invalid clinic language');
			return { clinics: [], totalCount: 0 };
		}
		if (body.name && !validateName(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid name');
			return { clinics: [], totalCount: 0 };
		}
		if (
			body.clinicTypeIds &&
			!validateClinicTypeIds(body, 'api/clinics/list')
		) {
			setResponseStatus(event, 400, 'Invalid clinic type');
			return { clinics: [], totalCount: 0 };
		}
		if (
			body.sortByDistance &&
			!validateUserCoordinates(body, 'api/clinics/list')
		) {
			setResponseStatus(event, 400, 'Invalid user coordinates');
			return { clinics: [], totalCount: 0 };
		}
		if (body.specialtyIds && !validateSpecialtyIds(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid specialty');
			return { clinics: [], totalCount: 0 };
		}
		if (body.minRating && !validateMinRating(body, 'api/clinics/list')) {
			setResponseStatus(event, 400, 'Invalid min rating');
			return { clinics: [], totalCount: 0 };
		}

		// Админ видит клиники во всех статусах: админка (поиск клиник,
		// селекторы в редакторах) ходит этим же эндпоинтом
		const currentUser = await getCurrentUser(event);
		return getClinicList(body, {
			includeUnpublished: !!currentUser?.is_admin,
		});
	} catch (error) {
		console.error('API Error - clinics:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinics',
		});
	}
});

export async function getClinicList(
	body: {
		cityIds?: number[];
		languageIds?: number[];
		clinicTypeIds?: number[];
		specialtyIds?: number[];
		name?: string;
		locale?: string;
		/** 'directory' — ответ без описаний, см. directoryOnly ниже. */
		fields?: 'directory';
		page?: number;
		openNow?: boolean;
		minRating?: number;
		userLatitude?: number;
		userLongitude?: number;
		sortByDistance?: boolean;
	} = {},
	opts: { includeUnpublished?: boolean } = {},
) {
	// Публичные списки показывают только опубликованные клиники
	// (draft/pending_verification/rejected доступны лишь владельцу в кабинете
	// и админу — как на детальной странице).
	const whereFilters: string[] = opts.includeUnpublished
		? []
		: [clinicIsPublicSql('c')];
	const queryParams: Array<number | string> = [];
	const locale = isValidLocale(body.locale) ? body.locale : 'en';

	// Справочный режим: клиника нужна как карточка в списке и точка на карте,
	// а не как страница. Описание живёт в шести локализованных колонках и
	// составляет основную массу ответа — при выборке без пагинации (её просит
	// стор клиник) это сотни килобайт, уезжающих в payload каждой страницы
	// листинга. Всё остальное — имя, адрес, координаты, рейтинг, расписание,
	// купон — карточкам нужно, поэтому режим срезает только описания.
	const directoryOnly = body.fields === 'directory';
	const usePagination = body.page != null;
	const openNow = body.openNow === true;
	const sortByDistance =
		body.sortByDistance === true &&
		typeof body.userLatitude === 'number' &&
		typeof body.userLongitude === 'number';
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);
	const buildInPlaceholders = (values: Array<number | string>) => {
		const arr = Array.isArray(values) ? values : [values];
		queryParams.push(...arr);
		return arr.map(() => '?').join(',');
	};

	// «Открыто сейчас» — теперь условие SQL, поэтому пагинация в БД работает и
	// с этим фильтром. Раньше он отключал LIMIT целиком: список выбирался весь
	// (142 КБ, 0,11 с на 138 клиниках) и резался в памяти уже после выборки.
	//
	// Порядок важен: whereFilters и queryParams заполняются синхронно, параметры
	// позиционные — условие и его параметры добавляются одной операцией.
	if (openNow) {
		const openNowFilter = buildOpenNowFilter();
		whereFilters.push(openNowFilter.sql);
		queryParams.push(...openNowFilter.params);
	}

	if (body.cityIds != null && body.cityIds.length > 0) {
		whereFilters.push(`c.city_id IN (${buildInPlaceholders(body.cityIds)})`);
	}

	if (body.languageIds != null && body.languageIds.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_languages cl_f WHERE cl_f.clinic_id = c.id AND cl_f.language_id IN (${buildInPlaceholders(
				body.languageIds,
			)}))`,
		);
	}

	if (body.clinicTypeIds != null && body.clinicTypeIds.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_clinic_types cct_f WHERE cct_f.clinic_id = c.id AND cct_f.clinic_type_id IN (${buildInPlaceholders(
				body.clinicTypeIds,
			)}))`,
		);
	}

	// Специализация клиники: либо в ней принимает врач этой специальности,
	// либо она оказывает услуги, привязанные к специальности
	if (body.specialtyIds != null && body.specialtyIds.length > 0) {
		const doctorPlaceholders = buildInPlaceholders(body.specialtyIds);
		const servicePlaceholders = buildInPlaceholders(body.specialtyIds);
		whereFilters.push(
			`(EXISTS (
				SELECT 1 FROM doctor_clinics dc_f
				JOIN doctor_specialties ds_f ON ds_f.doctor_id = dc_f.doctor_id
				WHERE dc_f.clinic_id = c.id AND ds_f.specialty_id IN (${doctorPlaceholders})
			) OR EXISTS (
				SELECT 1 FROM clinic_medical_services cms_f
				JOIN medical_services_specialties mss_f ON mss_f.medical_service_id = cms_f.medical_service_id
				WHERE cms_f.clinic_id = c.id AND mss_f.specialty_id IN (${servicePlaceholders})
			))`,
		);
	}

	// Тот же подзапрос, что считает averageRating в SELECT — фильтр одинаково
	// влияет на count- и data-запросы. ROUND обязателен: карточка показывает
	// округлённый рейтинг, и клиника с видимыми «4.0» (сырые 3.96) обязана
	// проходить фильтр «4+»
	if (body.minRating != null && validateMinRating(body)) {
		whereFilters.push(
			`(SELECT ROUND(AVG(r.rating), 1) FROM reviews r WHERE r.clinic_id = c.id AND r.rating IS NOT NULL AND r.status != 'rejected') >= ?`,
		);
		queryParams.push(body.minRating);
	}

	if (body.name && validateName(body, 'api/clinics/list')) {
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(${foldedLikeAny(['c.name_sr', 'c.name_sr_cyrl', 'c.name_ru'])})`,
		);
		queryParams.push(namePattern, namePattern, namePattern);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	// LIMIT/OFFSET — связанными параметрами: с инлайном каждое смещение давало
	// НОВОЕ подготовленное выражение и вытесняло LRU в 200 записей на
	// соединение (maxPreparedStatements, db-mysql.ts), то есть пагинирующий
	// трафик платил лишние COM_STMT_PREPARE + COM_STMT_CLOSE почти на каждом
	// запросе. Значения СТРОКАМИ: mysql2 в execute() кодирует числа так, что
	// MySQL отвечает «Incorrect arguments to mysqld_stmt_execute» именно на
	// LIMIT/OFFSET, а строку приводит к целому сам.
	const paginationClause = usePagination ? 'LIMIT ? OFFSET ?' : '';
	const paginationParams: string[] = usePagination
		? [String(pageSize), String(offset)]
		: [];

	// Haversine (км) от точки пользователя. Это сортировка, НЕ фильтр:
	// все клиники остаются в выдаче, без координат — без бонуса близости.
	// LEAST/GREATEST страхуют ACOS от выхода аргумента за [-1, 1].
	const distanceSelect = sortByDistance
		? `,
				(6371 * ACOS(LEAST(1, GREATEST(-1,
					COS(RADIANS(?)) * COS(RADIANS(c.latitude)) *
					COS(RADIANS(c.longitude) - RADIANS(?)) +
					SIN(RADIANS(?)) * SIN(RADIANS(c.latitude))
				)))) as distance`
		: '';
	const distanceParams: number[] = sortByDistance
		? [body.userLatitude!, body.userLongitude!, body.userLatitude!]
		: [];
	// Композитный скор: rank_score + вклад близости (зеркало common/ranking.ts).
	// Расстояние — компонент рейтинга, а не его замена: пустой профиль в 500 м
	// не должен перекрывать заполненную клинику с отзывами чуть дальше.
	const orderByClause = sortByDistance
		? `ORDER BY (c.rank_score + CASE WHEN distance IS NULL THEN 0 ELSE ${PROXIMITY_WEIGHT} * POW(2, -distance / ${PROXIMITY_HALF_DISTANCE_KM}) END) DESC, c.name_sr ASC`
		: 'ORDER BY c.rank_score DESC, c.name_sr ASC';

	const totalCountQuery = `
			SELECT COUNT(DISTINCT c.id) as totalCount
			FROM clinics c
			${whereFiltersString};
		`;
	const clinicsQuery = `
			SELECT
				c.id,
				c.slug,
				c.name_sr,
				c.name_ru,
				c.name_sr_cyrl,
				c.city_id as cityId,
				c.address_sr,
				c.address_sr_cyrl,
				c.town_sr,
				c.town_sr_cyrl,
				c.postal_code as postalCode,
				c.latitude,
				c.longitude,
				c.phone,
				c.email,
				c.facebook,
				c.instagram,
				c.telegram,
				c.whatsapp,
				c.viber,
				c.website,
				${directoryOnly ? '' : DESCRIPTION_COLUMNS}
				c.logo_url as logoUrl,
				c.rank_score as rankScore,
				ANY_VALUE(cwh.monday) as monday,
				ANY_VALUE(cwh.tuesday) as tuesday,
				ANY_VALUE(cwh.wednesday) as wednesday,
				ANY_VALUE(cwh.thursday) as thursday,
				ANY_VALUE(cwh.friday) as friday,
				ANY_VALUE(cwh.saturday) as saturday,
				ANY_VALUE(cwh.sunday) as sunday,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id), '') as clinicTypeIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features,
				(SELECT ROUND(AVG(r.rating), 1) FROM reviews r WHERE r.clinic_id = c.id AND r.rating IS NOT NULL AND r.status != 'rejected') as averageRating,
				(SELECT COUNT(*) FROM reviews r WHERE r.clinic_id = c.id AND r.rating IS NOT NULL AND r.status != 'rejected') as totalReviews
				${distanceSelect}
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN clinic_clinic_types cct ON c.id = cct.clinic_id
			LEFT JOIN clinic_working_hours cwh ON c.id = cwh.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			${whereFiltersString}
			GROUP BY c.id
			${orderByClause}
			${paginationClause};
		`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(totalCountQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	// Плейсхолдеры расстояния стоят в SELECT — их параметры идут первыми
	const [clinics] = await connection.execute(clinicsQuery, [
		...distanceParams,
		...queryParams,
		...paginationParams,
	]);
	await connection.end();

	// Купоны — по всем клиникам сразу: их единицы, а стор всё равно тянет
	// справочник целиком (stores/clinics.ts)
	const coupons = await fetchClinicCoupons();

	// Обрабатываем локализованные имена, town, address и description
	const processedClinics = (clinics as any[]).map((clinic: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);
		const address = processLocalizedFieldForClinic(clinic, 'address', locale);
		const town = processLocalizedFieldForClinic(clinic, 'town', locale);
		const description = directoryOnly
			? undefined
			: processLocalizedDescription(clinic, locale);
		const features = clinic.features
			? clinic.features.split(',').map(Number)
			: [];

		return {
			id: clinic.id,
			slug: clinic.slug,
			clinicTypeIds: clinic.clinicTypeIds || '',
			cityId: clinic.cityId,
			postalCode: clinic.postalCode,
			latitude: clinic.latitude,
			longitude: clinic.longitude,
			phone: clinic.phone,
			email: clinic.email,
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
			whatsapp: clinic.whatsapp,
			viber: clinic.viber,
			website: clinic.website,
			description,
			languageIds: clinic.languageIds,
			features,
			coupon: coupons.get(clinic.id),
			name,
			localName,
			address,
			town,
			logoUrl: clinic.logoUrl || '',
			rankScore: clinic.rankScore != null ? Number(clinic.rankScore) : 0,
			rating: clinic.averageRating
				? {
						averageRating: parseFloat(clinic.averageRating),
						totalReviews: clinic.totalReviews,
					}
				: undefined,
			distance:
				clinic.distance != null
					? Math.round(Number(clinic.distance) * 10) / 10
					: undefined,
			workingHours: buildWorkingHours(clinic),
		};
	});

	if (!usePagination) {
		totalCount = processedClinics.length;
	}

	return {
		clinics: processedClinics,
		totalCount,
	};
}
