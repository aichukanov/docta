import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export interface InsuranceCompanyBranchAdminData {
	id: number;
	cityId: number;
	address_sr: string;
	address_sr_cyrl: string;
	town_sr: string;
	town_sr_cyrl: string;
	postalCode: string;
	latitude: number;
	longitude: number;
	phone: string;
	email: string;
	workingHours: string;
}

export interface InsuranceCompanyAdminData {
	id: number;
	slug: string;
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	website: string;
	phone: string;
	email: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
	logoUrl: string;
	branches: InsuranceCompanyBranchAdminData[];
}

export default defineEventHandler(
	async (event): Promise<InsuranceCompanyAdminData | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/insurance-companies/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}
			if (!validateNonNegativeInteger(body.companyId)) {
				setResponseStatus(event, 400, 'Invalid insurance company id');
				return null;
			}

			const connection = await getConnection();

			const [companyRows] = await connection.execute(
				`SELECT id, slug, name_sr, name_sr_cyrl, name_ru, website, phone, email,
					facebook, instagram, telegram, whatsapp, viber, logo_url as logoUrl
				FROM insurance_companies WHERE id = ?;`,
				[body.companyId],
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
				[body.companyId],
			);
			await connection.end();

			return {
				id: company.id,
				slug: company.slug || '',
				name_sr: company.name_sr || '',
				name_sr_cyrl: company.name_sr_cyrl || '',
				name_ru: company.name_ru || '',
				website: company.website || '',
				phone: company.phone || '',
				email: company.email || '',
				facebook: company.facebook || '',
				instagram: company.instagram || '',
				telegram: company.telegram || '',
				whatsapp: company.whatsapp || '',
				viber: company.viber || '',
				logoUrl: company.logoUrl || '',
				branches: (branchRows as any[]).map((branch) => ({
					id: branch.id,
					cityId: branch.cityId,
					address_sr: branch.address_sr || '',
					address_sr_cyrl: branch.address_sr_cyrl || '',
					town_sr: branch.town_sr || '',
					town_sr_cyrl: branch.town_sr_cyrl || '',
					postalCode: branch.postalCode || '',
					latitude: branch.latitude || 0,
					longitude: branch.longitude || 0,
					phone: branch.phone || '',
					email: branch.email || '',
					workingHours: branch.workingHours || '',
				})),
			};
		} catch (error) {
			console.error('API Error - insurance company admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch insurance company admin details',
			});
		}
	},
);
