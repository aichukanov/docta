import { validateBody } from '~/common/validation';
import { REVIEWS_PAGE_SIZE, REVIEWS_THRESHOLD } from '~/common/constants';
import { getCurrentUser } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import { fetchRating, fetchReviews, isValidSort } from '~/server/common/reviews';
import type { Rating } from '~/interfaces/review';

export default defineEventHandler(async (event) => {
	try {
		const currentUser = await getCurrentUser(event);
		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/reviews')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid clinic slug');
			return null;
		}

		const locale = body.locale || 'en';
		const page = Math.max(1, parseInt(body.page) || 1);
		const sort = isValidSort(body.sort) ? body.sort : 'rank';
		const pageSize = REVIEWS_PAGE_SIZE;
		const offset = (page - 1) * pageSize;

		const connection = await getConnection();

		// Загружаем базовую информацию о клинике
		const clinicQuery = `
			SELECT
				c.id,
				c.slug,
				c.name_sr,
				c.name_ru,
				c.name_sr_cyrl,
				c.city_id as cityId,
				c.logo_url as logoUrl,
				COALESCE(GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id), '') as clinicTypeIds
			FROM clinics c
			LEFT JOIN clinic_clinic_types cct ON c.id = cct.clinic_id
			WHERE c.slug = ?
			GROUP BY c.id
		`;
		const [clinicRows] = await connection.execute(clinicQuery, [body.slug]);
		const clinic = (clinicRows as any[])[0];

		if (!clinic) {
			await connection.end();
			return null;
		}

		const rating: Rating = await fetchRating(connection, 'clinic', clinic.id);

		// Если отзывов <= порога, возвращаем флаг для редиректа
		if (rating.totalReviews <= REVIEWS_THRESHOLD) {
			await connection.end();
			return { shouldRedirect: true as const, slug: clinic.slug as string };
		}

		const allReviews = await fetchReviews(
			connection,
			'clinic',
			clinic.id,
			locale,
			sort,
			currentUser?.id,
		);

		await connection.end();

		// Отделяем свой отзыв от общего списка
		const ownReview = allReviews.find((r: any) => r.isOwn) || null;
		const otherReviews = allReviews.filter((r: any) => !r.isOwn);

		// Пагинация только чужих отзывов
		const paginatedReviews = otherReviews.slice(offset, offset + pageSize);
		const totalPages = Math.ceil(otherReviews.length / pageSize) || 1;

		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);

		return {
			shouldRedirect: false as const,
			clinic: {
				id: clinic.id as number,
				slug: clinic.slug as string,
				name,
				localName,
				cityId: clinic.cityId as number,
				logoUrl: clinic.logoUrl as string | undefined,
				clinicTypeIds: clinic.clinicTypeIds as string,
			},
			rating,
			reviews: paginatedReviews,
			ownReview,
			pagination: {
				page,
				pageSize,
				totalReviews: otherReviews.length,
				totalPages,
			},
		};
	} catch (error) {
		console.error('API Error - clinic reviews:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinic reviews',
		});
	}
});
