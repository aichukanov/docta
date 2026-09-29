import { isValidLocale, validateBody } from '~/common/validation';
import { REVIEWS_PAGE_SIZE, REVIEWS_THRESHOLD } from '~/common/constants';
import { getCurrentUser } from '~/server/common/auth';
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

		if (!validateBody(body, 'api/insurance-companies/reviews')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid insurance company slug');
			return null;
		}

		const locale = isValidLocale(body.locale) ? body.locale : 'en';
		const page = Math.max(1, parseInt(body.page) || 1);
		const sort = isValidSort(body.sort) ? body.sort : 'rank';
		const pageSize = REVIEWS_PAGE_SIZE;
		const offset = (page - 1) * pageSize;

		const connection = await getConnection();

		// У страховых нет черновиков и админского скрытия — только 404
		const [companyRows] = await connection.execute(
			`SELECT id, slug, name_sr, name_ru, name_sr_cyrl, logo_url as logoUrl
			FROM insurance_companies WHERE slug = ?`,
			[body.slug],
		);
		const company = (companyRows as any[])[0];
		if (!company) {
			await connection.end();
			return null;
		}

		const rating: Rating = await fetchRating(
			connection,
			'insurance_company',
			company.id,
		);

		// Если отзывов <= порога, возвращаем флаг для редиректа
		if (rating.totalReviews <= REVIEWS_THRESHOLD) {
			await connection.end();
			return { shouldRedirect: true as const, slug: company.slug as string };
		}

		const { reviews, ownReview, totalCount } = await fetchReviews(
			connection,
			'insurance_company',
			company.id,
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
			company,
			locale,
		);

		return {
			shouldRedirect: false as const,
			company: {
				id: company.id as number,
				slug: company.slug as string,
				name,
				localName,
				logoUrl: company.logoUrl as string | undefined,
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
		console.error('API Error - insurance company reviews:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch insurance company reviews',
		});
	}
});
