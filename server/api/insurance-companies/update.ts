import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import {
	downloadAndSaveImage,
	isExternalUrl,
} from '~/server/utils/image-processing';
import { generateSlug } from '~/common/slug-utils';
import { ensureUniqueSlug, saveSlugRedirect } from '~/server/common/slug-db';
import {
	validateBody,
	validateCityIds,
	validateNonNegativeInteger,
} from '~/common/validation';

interface BranchInput {
	id?: number | null;
	cityId: number;
	address_sr?: string;
	address_sr_cyrl?: string;
	town_sr?: string;
	town_sr_cyrl?: string;
	postalCode?: string;
	latitude?: number | string;
	longitude?: number | string;
	phone?: string;
	email?: string;
	workingHours?: string;
}

export default defineEventHandler(async (event): Promise<boolean | null> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/insurance-companies/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}
		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid insurance company id');
			return null;
		}

		const branches: BranchInput[] = Array.isArray(body.branches)
			? body.branches
			: [];

		if (
			branches.length > 0 &&
			!validateCityIds(
				{ cityIds: branches.map((b) => b.cityId) },
				'api/insurance-companies/update',
			)
		) {
			setResponseStatus(event, 400, 'Invalid branch city');
			return null;
		}

		if (body.logoUrl && isExternalUrl(body.logoUrl)) {
			body.logoUrl = await downloadAndSaveImage(
				body.logoUrl,
				'insurance-companies',
			);
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			const companyName = body.name_sr || '';
			const baseSlug = body.slug || generateSlug(companyName || 'insurance');
			const slug = await ensureUniqueSlug(
				connection,
				'insurance_companies',
				baseSlug,
				body.id,
			);

			await saveSlugRedirect(connection, 'insurance_companies', body.id, slug);

			await connection.execute(
				`UPDATE insurance_companies
				SET slug = ?, name_sr = ?, name_sr_cyrl = ?, name_ru = ?, website = ?,
					phone = ?, email = ?, facebook = ?, instagram = ?, telegram = ?,
					whatsapp = ?, viber = ?, logo_url = ?
				WHERE id = ?;`,
				[
					slug,
					body.name_sr || '',
					body.name_sr_cyrl || '',
					body.name_ru || '',
					body.website || '',
					body.phone || '',
					body.email || '',
					body.facebook || '',
					body.instagram || '',
					body.telegram || '',
					body.whatsapp || '',
					body.viber || '',
					body.logoUrl || '',
					body.id,
				],
			);

			// Ветки сохраняются по id, а не через delete-all-reinsert: их id —
			// стабильные якоря (#branch-{id}) на детальной странице, к которым
			// со временем привяжутся отзывы по офисам — пересоздавать их при
			// каждом сохранении компании нельзя.
			const [existingRows]: any = await connection.execute(
				'SELECT id FROM insurance_company_branches WHERE insurance_company_id = ?',
				[body.id],
			);
			const existingIds = new Set(
				(existingRows as any[]).map((row) => row.id),
			);
			const submittedIds = new Set(
				branches.filter((b) => b.id != null).map((b) => b.id),
			);

			const idsToRemove = [...existingIds].filter(
				(id) => !submittedIds.has(id),
			);
			if (idsToRemove.length > 0) {
				await connection.execute(
					`DELETE FROM insurance_company_branches WHERE id IN (${idsToRemove
						.map(() => '?')
						.join(',')})`,
					idsToRemove,
				);
			}

			for (const branch of branches) {
				if (branch.id != null && existingIds.has(branch.id)) {
					await connection.execute(
						`UPDATE insurance_company_branches
						SET city_id = ?, address_sr = ?, address_sr_cyrl = ?, town_sr = ?,
							town_sr_cyrl = ?, postal_code = ?, latitude = ?, longitude = ?,
							phone = ?, email = ?, working_hours = ?
						WHERE id = ?;`,
						[
							branch.cityId,
							branch.address_sr || '',
							branch.address_sr_cyrl || '',
							branch.town_sr || '',
							branch.town_sr_cyrl || '',
							branch.postalCode || '',
							branch.latitude || 0,
							branch.longitude || 0,
							branch.phone || '',
							branch.email || '',
							branch.workingHours || '',
							branch.id,
						],
					);
				} else {
					await connection.execute(
						`INSERT INTO insurance_company_branches
							(insurance_company_id, city_id, address_sr, address_sr_cyrl,
							town_sr, town_sr_cyrl, postal_code, latitude, longitude, phone, email, working_hours)
						VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);`,
						[
							body.id,
							branch.cityId,
							branch.address_sr || '',
							branch.address_sr_cyrl || '',
							branch.town_sr || '',
							branch.town_sr_cyrl || '',
							branch.postalCode || '',
							branch.latitude || 0,
							branch.longitude || 0,
							branch.phone || '',
							branch.email || '',
							branch.workingHours || '',
						],
					);
				}
			}

			await connection.commit();
			await connection.end();

			return true;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - insurance company update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update insurance company',
		});
	}
});
