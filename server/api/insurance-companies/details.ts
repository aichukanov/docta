import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
} from '~/server/common/utils';
import type { InsuranceCompanyData } from '~/interfaces/insurance-company';
import { validateBody } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<InsuranceCompanyData | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/insurance-companies/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid insurance company slug');
				return null;
			}

			const locale = body.locale || 'en';
			const connection = await getConnection();

			const [companyRows] = await connection.execute(
				`SELECT id, slug, name_sr, name_ru, name_sr_cyrl, website, phone, email,
					facebook, instagram, telegram, whatsapp, viber, logo_url as logoUrl
				FROM insurance_companies WHERE slug = ?;`,
				[body.slug],
			);
			const company = (companyRows as any[])[0];
			if (!company) {
				await connection.end();
				return null;
			}

			const [branchRows] = await connection.execute(
				`SELECT id, city_id as cityId, address_sr, address_sr_cyrl,
					town_sr, town_sr_cyrl, postal_code as postalCode,
					latitude, longitude, phone, email, working_hours as workingHours
				FROM insurance_company_branches
				WHERE insurance_company_id = ?
				ORDER BY city_id ASC, id ASC;`,
				[company.id],
			);
			await connection.end();

			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				company,
				locale,
			);

			const branches = (branchRows as any[]).map((branch) => ({
				id: branch.id,
				cityId: branch.cityId,
				address: processLocalizedFieldForClinic(branch, 'address', locale),
				town: processLocalizedFieldForClinic(branch, 'town', locale),
				postalCode: branch.postalCode,
				latitude: branch.latitude,
				longitude: branch.longitude,
				phone: branch.phone || undefined,
				email: branch.email || undefined,
				workingHours: branch.workingHours || undefined,
			}));

			return {
				id: company.id,
				slug: company.slug,
				name,
				localName,
				logoUrl: company.logoUrl || '',
				website: company.website,
				phone: company.phone,
				email: company.email,
				facebook: company.facebook,
				instagram: company.instagram,
				telegram: company.telegram,
				whatsapp: company.whatsapp,
				viber: company.viber,
				branches,
			};
		} catch (error) {
			console.error('API Error - insurance company details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch insurance company data',
			});
		}
	},
);
