import { REVIEWS_THRESHOLD } from '~/common/constants';
import { getCurrentUser } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import { fetchRating, fetchReviews } from '~/server/common/reviews';
import { fetchClinicItemsSummary } from '~/server/common/clinic-items-summary';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
import type { ClinicData } from '~/interfaces/clinic';
import { validateBody } from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicData | null> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid clinic slug');
			return null;
		}

		const locale = body.locale || 'en';

		const clinicsQuery = `
			SELECT
				c.id,
				c.slug,
				c.status,
				c.created_by,
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
				c.description_sr,
				c.description_sr_cyrl,
				c.description_en,
				c.description_ru,
				c.description_de,
				c.description_tr,
				c.logo_url as logoUrl,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id), '') as clinicTypeIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN clinic_clinic_types cct ON c.id = cct.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			WHERE c.slug = ?
			GROUP BY c.id;
		`;

		const connection = await getConnection();
		const [clinicRows] = await connection.execute(clinicsQuery, [body.slug]);

		const clinic = (clinicRows as any[])[0];
		if (!clinic) {
			await connection.end();
			return null;
		}

		const currentUser = await getCurrentUser(event);

		// Непубличная клиника (draft и т.п.) видна только владельцу или админу,
		// остальным — 404 (как для несуществующей).
		const isOwner =
			!!currentUser &&
			clinic.created_by != null &&
			currentUser.id === clinic.created_by;
		if (
			clinic.status !== 'published' &&
			!isOwner &&
			!currentUser?.is_admin
		) {
			await connection.end();
			return null;
		}

		// Загружаем рейтинг и отзывы клиники
		const rating = await fetchRating(connection, 'clinic', clinic.id);
		const { reviews, ownReview } = await fetchReviews(
			connection,
			'clinic',
			clinic.id,
			locale,
			{
				boostMinRating: 4,
				limit: REVIEWS_THRESHOLD,
				currentUserId: currentUser?.id,
			},
		);
		const allReviews = ownReview ? [ownReview, ...reviews] : reviews;

		await connection.end();

		const itemsSummary = await fetchClinicItemsSummary(clinic.id, locale);

		// Обрабатываем локализованные имена
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);

		// Обрабатываем локализованные town и address
		const address = processLocalizedFieldForClinic(clinic, 'address', locale);
		const town = processLocalizedFieldForClinic(clinic, 'town', locale);

		// Обрабатываем локализованное description
		const description = processLocalizedDescription(clinic, locale);
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
			name,
			localName,
			address,
			town,
			logoUrl: clinic.logoUrl || '',
			rating,
			reviews: allReviews,
			itemsSummary,
			status: clinic.status,
			isOwner,
		};
	} catch (error) {
		console.error('API Error - clinic data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinic data',
		});
	}
});
