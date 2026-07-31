import { validateBody } from '~/common/validation';
import { GONE_PAYLOAD } from '~/common/gone';
import { REVIEWS_PAGE_SIZE, REVIEWS_THRESHOLD } from '~/common/constants';
import {
	isDoctorHiddenByAdmin,
	isDoctorPublic,
} from '~/server/common/doctor-visibility';
import { getCurrentUser } from '~/server/common/auth';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import {
	fetchRating,
	fetchReviews,
	isValidSort,
} from '~/server/common/reviews';
import type { Rating } from '~/interfaces/review';

export default defineEventHandler(async (event) => {
	try {
		const currentUser = await getCurrentUser(event);
		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/reviews')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid doctor slug');
			return null;
		}

		const locale = body.locale || 'en';
		const page = Math.max(1, parseInt(body.page) || 1);
		const sort = isValidSort(body.sort) ? body.sort : 'rank';
		const pageSize = REVIEWS_PAGE_SIZE;
		const offset = (page - 1) * pageSize;

		const connection = await getConnection();

		// Загружаем базовую информацию о враче
		const doctorQuery = `
			SELECT
				d.id,
				d.slug,
				d.name_sr,
				d.name_sr_cyrl,
				d.name_ru,
				d.name_en,
				d.professional_title as professionalTitle,
				d.photo_url as photoUrl,
				d.hidden,
				d.hidden_by_admin,
				d.is_draft,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialtyIds,
				-- только публичные клиники (см. doctors/details.ts)
				COALESCE(GROUP_CONCAT(DISTINCT c.id ORDER BY c.id), '') as clinicIds
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
			LEFT JOIN clinics c ON c.id = dc.clinic_id AND ${clinicIsPublicSql('c')}
			WHERE d.slug = ?
			GROUP BY d.id
		`;
		const [doctorRows] = await connection.execute(doctorQuery, [body.slug]);
		const doctor = (doctorRows as any[])[0];

		if (!doctor || !isDoctorPublic(doctor)) {
			await connection.end();
			return doctor && isDoctorHiddenByAdmin(doctor) ? GONE_PAYLOAD : null;
		}

		const rating: Rating = await fetchRating(connection, 'doctor', doctor.id);

		// Если отзывов <= порога, возвращаем флаг для редиректа
		if (rating.totalReviews <= REVIEWS_THRESHOLD) {
			await connection.end();
			return { shouldRedirect: true as const, slug: doctor.slug as string };
		}

		const { reviews, ownReview, totalCount } = await fetchReviews(
			connection,
			'doctor',
			doctor.id,
			locale,
			{
				sort,
				limit: pageSize,
				offset,
				currentUserId: currentUser?.id,
			},
		);

		await connection.end();

		const totalPages = Math.ceil(totalCount / pageSize) || 1;

		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			doctor,
			locale,
		);

		return {
			shouldRedirect: false as const,
			doctor: {
				id: doctor.id as number,
				slug: doctor.slug as string,
				name,
				localName,
				professionalTitle: doctor.professionalTitle as string | undefined,
				photoUrl: doctor.photoUrl as string | undefined,
				specialtyIds: doctor.specialtyIds as string,
				clinicIds: doctor.clinicIds as string,
			},
			rating,
			reviews,
			ownReview,
			pagination: {
				page,
				pageSize,
				totalReviews: totalCount,
				totalPages,
			},
		};
	} catch (error) {
		console.error('API Error - doctor reviews:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctor reviews',
		});
	}
});
