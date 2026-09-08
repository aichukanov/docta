import { getConnection } from '~/server/common/db-mysql';
import { doctorIsPublicSql } from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { lastmodSql, toLastmod } from '~/server/common/sitemap/lastmod';
import { DoctorSpecialty } from '~/enums/specialty';

/**
 * Фасетный URL для sitemap: сам фасет плюс дата изменения.
 *
 * Дата — МАКСИМУМ `updated_at` по участникам выборки: страница «кардиологи в
 * Будве» меняется ровно тогда, когда меняется хоть один врач из неё. Поэтому
 * `DISTINCT` в запросах ниже заменён на `GROUP BY` с `MAX(...)` — набор строк
 * тот же, добавилась только агрегация.
 */
export interface SpecialtyFacet {
	specialtyId: number;
	lastmod?: Date;
}

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

/**
 * Специальности, у которых реально есть хотя бы один публичный врач.
 *
 * Раньше в sitemap уезжал весь enum (78 значений). Листинг на пустой выборке
 * отдаёт `noindex, follow` (components/list-page.vue), то есть sitemap просил
 * индексировать страницу, которая сама просит этого не делать. Расхождение
 * росло молча: новое значение enum'а появляется в sitemap в тот же день, а
 * первый врач с этой специальностью — когда-нибудь.
 *
 * Результат пересекаем с enum'ом: id вне enum'а не проходит
 * `validateSpecialtyIds`, листинг молча покажет полный каталог и отдаст
 * `noindex` — такой URL в sitemap не нужен тем более.
 */
async function getSpecialtyIdsWithDoctors(): Promise<SpecialtyFacet[]> {
	const lastmod = await lastmodSql('doctors', 'MAX(d.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT ds.specialty_id as specialtyId, ${lastmod} as lastmod
		FROM doctor_specialties ds
		INNER JOIN doctors d ON d.id = ds.doctor_id
			AND ${doctorIsPublicSql('d')}
		GROUP BY ds.specialty_id
		ORDER BY ds.specialty_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	const knownIds = new Set(getEnumValues(DoctorSpecialty));

	return (rows as Array<{ specialtyId: number; lastmod: unknown }>)
		.filter((row) => knownIds.has(row.specialtyId))
		.map((row) => ({
			specialtyId: row.specialtyId,
			lastmod: toLastmod(row.lastmod),
		}));
}

export async function getSpecialtyCityCombinations() {
	const lastmod = await lastmodSql('doctors', 'MAX(d.updated_at)');
	const connection = await getConnection();

	const query = `
		SELECT ds.specialty_id as specialtyId, clinics.city_id as cityId,
			${lastmod} as lastmod
		FROM doctors d
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN clinics ON dc.clinic_id = clinics.id
			AND ${clinicIsPublicSql('clinics')}
		WHERE ${doctorIsPublicSql('d')}
		GROUP BY ds.specialty_id, clinics.city_id
		ORDER BY ds.specialty_id, clinics.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (
		rows as Array<{ specialtyId: number; cityId: number; lastmod: unknown }>
	).map((row) => ({
		specialtyId: row.specialtyId,
		cityId: row.cityId,
		lastmod: toLastmod(row.lastmod),
	}));
}

/**
 * Пары (специальность, язык приёма) — `/doctors?specialtyIds=X&languageIds=L`.
 *
 * Экспортируется не только ради sitemap: тот же набор нужен хабу перелинковки
 * (`components/doctor/related-filters.vue`). Пока эти URL публиковал только
 * sitemap, все 127 пар не имели ни одной входящей HTML-ссылки — краулер узнавал
 * о них из файла и больше ниоткуда. Второго запроса под хаб не заводим: набор
 * ссылок обязан быть ПОДМНОЖЕСТВОМ sitemap, а гарантировать это надёжнее всего
 * общим источником, а не двумя запросами, которые однажды разъедутся.
 *
 * Сербский (id 1) исключён намеренно: он у подавляющего большинства врачей,
 * фасет по нему повторял бы базовый листинг.
 */
export async function getSpecialtyLanguageCombinations() {
	// Внутри UNION дата тоже подставляется через lastmodSql: если колонки нет,
	// сломается уже подзапрос, а не только внешний MAX.
	const updatedAt = await lastmodSql('doctors', 'd.updated_at');
	const connection = await getConnection();

	// UNION ALL вместо UNION: дедупликацию всё равно делает внешний GROUP BY,
	// а с добавленной датой строки перестали совпадать побайтово, и дедупликация
	// внутри UNION только зря сортировала бы промежуточный набор.
	const query = `
		SELECT specialty_id as specialtyId, lang_id as languageId,
			MAX(updated_at) as lastmod
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id,
				${updatedAt} as updated_at
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1 AND ${doctorIsPublicSql('d')}
			UNION ALL
			SELECT ds.specialty_id, cl.language_id as lang_id,
				${updatedAt} as updated_at
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics c ON c.id = dc.clinic_id
				AND ${clinicIsPublicSql('c')}
			WHERE cl.language_id != 1 AND ${doctorIsPublicSql('d')}
		) as combined
		GROUP BY specialty_id, lang_id
		ORDER BY specialty_id, lang_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return (
		rows as Array<{ specialtyId: number; languageId: number; lastmod: unknown }>
	).map((row) => ({
		specialtyId: row.specialtyId,
		languageId: row.languageId,
		lastmod: toLastmod(row.lastmod),
	}));
}

export async function getSitemapFilters() {
	return {
		specialtyIds: await getSpecialtyIdsWithDoctors(),
		specialtyCityCombinations: await getSpecialtyCityCombinations(),
		specialtyLanguageCombinations: await getSpecialtyLanguageCombinations(),
	};
}
