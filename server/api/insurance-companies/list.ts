import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
} from '~/server/common/utils';
import { validateCityIds, validateName } from '~/common/validation';
import type { InsuranceCompanyListItem } from '~/interfaces/insurance-company';

export default defineEventHandler(
	async (event): Promise<InsuranceCompanyListItem[]> => {
		try {
			const body = (await readBody(event).catch(() => ({}))) || {};
			const locale = body.locale || 'en';

			if (body.cityIds && !validateCityIds(body, 'api/insurance-companies/list')) {
				setResponseStatus(event, 400, 'Invalid city');
				return [];
			}
			if (body.name && !validateName(body, 'api/insurance-companies/list')) {
				setResponseStatus(event, 400, 'Invalid name');
				return [];
			}

			const cityIds: number[] = Array.isArray(body.cityIds) ? body.cityIds : [];
			const hasCityFilter = cityIds.length > 0;

			const companyWhere: string[] = [];
			const companyParams: Array<number | string> = [];

			if (hasCityFilter) {
				companyWhere.push(
					`EXISTS (SELECT 1 FROM insurance_company_branches icb_f
						WHERE icb_f.insurance_company_id = ic.id
						AND icb_f.city_id IN (${cityIds.map(() => '?').join(',')}))`,
				);
				companyParams.push(...cityIds);
			}

			if (body.name && validateName(body, 'api/insurance-companies/list')) {
				const namePattern = `%${body.name}%`;
				companyWhere.push(
					`(ic.name_sr LIKE ? OR ic.name_sr_cyrl LIKE ? OR ic.name_ru LIKE ?)`,
				);
				companyParams.push(namePattern, namePattern, namePattern);
			}

			const whereClause =
				companyWhere.length > 0 ? `WHERE ${companyWhere.join(' AND ')}` : '';

			const connection = await getConnection();

			const [companyRows] = await connection.execute(
				`SELECT ic.id, ic.slug, ic.name_sr, ic.name_ru, ic.name_sr_cyrl,
					ic.website, ic.phone, ic.logo_url as logoUrl
				FROM insurance_companies ic
				${whereClause}
				ORDER BY ic.name_sr ASC;`,
				companyParams,
			);

			const companies = companyRows as any[];
			if (companies.length === 0) {
				await connection.end();
				return [];
			}

			const companyIds = companies.map((c) => c.id);
			const branchWhere: string[] = [
				`icb.insurance_company_id IN (${companyIds.map(() => '?').join(',')})`,
			];
			const branchParams: Array<number | string> = [...companyIds];

			// Отфильтровано по городу — на карте/в счётчике показываем только
			// офисы в выбранных городах, а не весь список филиалов компании
			if (hasCityFilter) {
				branchWhere.push(`icb.city_id IN (${cityIds.map(() => '?').join(',')})`);
				branchParams.push(...cityIds);
			}

			const [branchRows] = await connection.execute(
				`SELECT id, insurance_company_id as companyId, city_id as cityId,
					address_sr, address_sr_cyrl, town_sr, town_sr_cyrl,
					postal_code as postalCode, latitude, longitude, phone, email
				FROM insurance_company_branches icb
				WHERE ${branchWhere.join(' AND ')}
				ORDER BY city_id ASC, id ASC;`,
				branchParams,
			);
			await connection.end();

			const branchesByCompany = new Map<number, any[]>();
			for (const branch of branchRows as any[]) {
				const localizedBranch = {
					id: branch.id,
					cityId: branch.cityId,
					address: processLocalizedFieldForClinic(branch, 'address', locale),
					town: processLocalizedFieldForClinic(branch, 'town', locale),
					postalCode: branch.postalCode,
					latitude: branch.latitude,
					longitude: branch.longitude,
					phone: branch.phone || undefined,
					email: branch.email || undefined,
				};
				const list = branchesByCompany.get(branch.companyId) || [];
				list.push(localizedBranch);
				branchesByCompany.set(branch.companyId, list);
			}

			return companies.map((row) => {
				const { name, localName } = processLocalizedNameForClinicOrDoctor(
					row,
					locale,
				);
				const branches = branchesByCompany.get(row.id) || [];
				return {
					id: row.id,
					slug: row.slug,
					name,
					localName,
					logoUrl: row.logoUrl || '',
					website: row.website,
					phone: row.phone,
					branchCount: branches.length,
					branches,
				};
			});
		} catch (error) {
			console.error('API Error - insurance companies list:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch insurance companies',
			});
		}
	},
);
