import { REVIEWS_THRESHOLD } from '~/common/constants';
import { isValidLocale, validateBody } from '~/common/validation';
import { GONE_PAYLOAD, type GonePayload } from '~/common/gone';
import type { DoctorData } from '~/interfaces/doctor';
import { getCurrentUser } from '~/server/common/auth';
import {
	isDoctorHiddenByAdmin,
	isDoctorPublic,
} from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { getConnection } from '~/server/common/db-mysql';
import { fetchRating, fetchReviews } from '~/server/common/reviews';
import {
	getServicesByClinicAndSpecialty,
	type ClinicServicesMap,
} from '~/server/common/services';
import {
	processLocalizedDescription,
	processLocalizedNameForClinicOrDoctor,
} from '~/server/common/utils';

export default defineEventHandler(
	async (event): Promise<DoctorData | GonePayload | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/doctors/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid doctor slug');
				return null;
			}

			const locale = isValidLocale(body.locale) ? body.locale : 'en';
			const includeServices = body.includeServices || false;

			const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.slug,
				d.user_id,
				d.hidden,
				d.hidden_by_admin,
				d.is_draft,
				d.name_sr,
				d.name_sr_cyrl,
				d.name_ru,
				d.name_en,
				d.description_sr,
				d.description_sr_cyrl,
				d.description_ru,
				d.description_en,
				d.description_de,
				d.description_tr,
				d.professional_title as professionalTitle,
				d.photo_url as photoUrl,
				d.phone,
				d.email,
				d.facebook,
				d.instagram,
				d.telegram,
				d.whatsapp,
				d.viber,
				d.website,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialtyIds,
				GROUP_CONCAT(DISTINCT languages.id ORDER BY languages.id) as languageIds,
				-- только публичные клиники: черновики и скрытые админом не должны
				-- утекать ни в блок клиник врача, ни в его прайс по услугам
				COALESCE(GROUP_CONCAT(DISTINCT c.id ORDER BY c.id), '') as clinicIds
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages ON dl.language_id = languages.id
			LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
			LEFT JOIN clinics c ON c.id = dc.clinic_id AND ${clinicIsPublicSql('c')}
			WHERE d.slug = ?
			GROUP BY d.id;
		`;

			const connection = await getConnection();
			const [doctorRows] = await connection.execute(doctorsQuery, [body.slug]);

			const doctor = (doctorRows as any[])[0];
			if (!doctor) {
				await connection.end();
				return null;
			}

			const currentUser = await getCurrentUser(event);
			const isOwner =
				!!currentUser && !!doctor.user_id && currentUser.id === doctor.user_id;

			// Непубличный профиль виден владельцу и админу: страница рисует его
			// как неопубликованный с баннером-объяснением наверху. Остальным —
			// 410 при скрытии админом (намеренное удаление) и 404 при черновике
			// и самоскрытии, они обратимы (см. common/gone.ts).
			if (!isDoctorPublic(doctor) && !isOwner && !currentUser?.is_admin) {
				await connection.end();
				return isDoctorHiddenByAdmin(doctor) ? GONE_PAYLOAD : null;
			}

			// Загружаем услуги, если требуется
			let clinicServices: ClinicServicesMap | undefined;
			if (includeServices && doctor.clinicIds && doctor.specialtyIds) {
				const clinicIds = doctor.clinicIds.split(',').map(Number);
				const specialtyIds = doctor.specialtyIds.split(',').map(Number);
				clinicServices = await getServicesByClinicAndSpecialty(
					connection,
					clinicIds,
					specialtyIds,
					locale,
					doctor.id, // Передаём ID врача для получения индивидуальных цен
				);
			}

			// Загружаем рейтинг и отзывы врача
			const processedRating = await fetchRating(
				connection,
				'doctor',
				doctor.id,
			);
			// limit как у клиник (server/api/clinics/details.ts): страница врача
			// всё равно показывает только первые REVIEWS_THRESHOLD отзывов, а
			// остальные уводит на /doctors/<slug>/reviews. Без лимита сюда
			// приезжали все отзывы врача (до 59) — с шестисторонним OAuth-join,
			// с EXISTS на строку в сортировке и со всеми ответами, — и всё это
			// ещё уезжало в SSR-payload, чтобы на клиенте быть обрезанным до пяти.
			//
			// Порядок не трогаем: сортировка по умолчанию (rank) та же, лимит
			// лишь отсекает хвост, который страница и так выбрасывала. Ссылку на
			// подстраницу отзывов страница считает по rating.totalReviews, а он
			// приходит отдельным запросом (fetchRating) и от лимита не зависит.
			const { reviews: reviewsRows, ownReview: ownDoctorReview } =
				await fetchReviews(connection, 'doctor', doctor.id, locale, {
					limit: REVIEWS_THRESHOLD,
					currentUserId: currentUser?.id,
				});

			await connection.end();

			// Обрабатываем локализованные имена
			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				doctor,
				locale,
			);

			// Обрабатываем локализованное описание
			const description = processLocalizedDescription(doctor, locale);

			// Сортируем clinicIds по количеству услуг (больше услуг — выше)
			let sortedClinicIds = doctor.clinicIds;
			if (clinicServices && doctor.clinicIds) {
				const clinicIdsList = doctor.clinicIds.split(',').map(Number);
				clinicIdsList.sort((a: number, b: number) => {
					const aCount = clinicServices[a]?.length || 0;
					const bCount = clinicServices[b]?.length || 0;
					return bCount - aCount;
				});
				sortedClinicIds = clinicIdsList.join(',');
			}
			const {
				hidden: _hidden,
				hidden_by_admin: _hiddenByAdmin,
				hidden_by_admin_reason: _hiddenReason,
				is_draft: _isDraft,
				user_id: _userId,
				name_sr,
				name_sr_cyrl,
				name_ru,
				name_en,
				description_sr,
				description_sr_cyrl,
				description_ru,
				description_en,
				description_de,
				description_tr,
				...rest
			} = doctor;

			return {
				...rest,
				name,
				localName,
				description,
				clinicIds: sortedClinicIds,
				clinicServices,
				isOwner,
				// Флаги непубличности доезжают только до владельца и админа —
				// остальные до этой строки не доходят. Причина скрытия нужна
				// врачу в баннере наверху страницы.
				isDraft: Boolean(doctor.is_draft),
				hidden: Boolean(doctor.hidden),
				hiddenByAdmin: Boolean(doctor.hidden_by_admin),
				hiddenReason: doctor.hidden_by_admin_reason || '',
				rating: processedRating,
				reviews: ownDoctorReview
					? [ownDoctorReview, ...reviewsRows]
					: reviewsRows,
			};
		} catch (error) {
			console.error('API Error - doctor data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch doctor data',
			});
		}
	},
);
