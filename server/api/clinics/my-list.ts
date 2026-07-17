import { getConnection } from '~/server/common/db-mysql';
import { requireUser } from '~/server/common/clinic-cabinet';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import type { ClinicStatus } from '~/interfaces/clinic';

export interface ClinicMyListItem {
	id: number;
	slug: string;
	status: ClinicStatus;
	name: string;
	localName: string;
	nameSr: string;
	nameSrCyrl: string;
	nameRu: string;
	cityId: number;
	addressSr: string;
	addressSrCyrl: string;
	townSr: string;
	townSrCyrl: string;
	postalCode: string;
	latitude: number | null;
	longitude: number | null;
	phone: string;
	email: string;
	website: string;
	facebook: string;
	instagram: string;
	telegram: string;
	whatsapp: string;
	viber: string;
	descriptionSr: string;
	descriptionSrCyrl: string;
	descriptionRu: string;
	descriptionEn: string;
	descriptionDe: string;
	descriptionTr: string;
	logoUrl: string;
	languageIds: string;
	clinicTypeIds: string;
}

export default defineEventHandler(
	async (event): Promise<ClinicMyListItem[]> => {
		const user = await requireUser(event);

		const connection = await getConnection();
		try {
			const [rows]: any = await connection.execute(
				`SELECT
					c.id, c.slug, c.status,
					c.name_sr, c.name_sr_cyrl, c.name_ru,
					c.city_id, c.address_sr, c.address_sr_cyrl,
					c.town_sr, c.town_sr_cyrl, c.postal_code,
					c.latitude, c.longitude,
					c.phone, c.email, c.website, c.facebook, c.instagram,
					c.telegram, c.whatsapp, c.viber,
					c.description_sr, c.description_sr_cyrl, c.description_ru,
					c.description_en, c.description_de, c.description_tr,
					c.logo_url,
					(SELECT GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id)
						FROM clinic_languages cl WHERE cl.clinic_id = c.id) as languageIds,
					(SELECT GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id)
						FROM clinic_clinic_types cct WHERE cct.clinic_id = c.id) as clinicTypeIds
				FROM clinics c
				WHERE c.created_by = ?
				ORDER BY c.created_at DESC, c.id DESC`,
				[user.id],
			);

			const locale =
				getCookie(event, 'locale') ||
				getHeader(event, 'accept-language')?.slice(0, 2) ||
				'en';

			return (rows as any[]).map((clinic) => {
				const { name, localName } = processLocalizedNameForClinicOrDoctor(
					clinic,
					locale,
				);

				return {
					id: clinic.id,
					slug: clinic.slug || '',
					status: clinic.status as ClinicStatus,
					name,
					localName,
					nameSr: clinic.name_sr || '',
					nameSrCyrl: clinic.name_sr_cyrl || '',
					nameRu: clinic.name_ru || '',
					cityId: clinic.city_id,
					addressSr: clinic.address_sr || '',
					addressSrCyrl: clinic.address_sr_cyrl || '',
					townSr: clinic.town_sr || '',
					townSrCyrl: clinic.town_sr_cyrl || '',
					postalCode: clinic.postal_code || '',
					latitude: clinic.latitude != null ? Number(clinic.latitude) : null,
					longitude: clinic.longitude != null ? Number(clinic.longitude) : null,
					phone: clinic.phone || '',
					email: clinic.email || '',
					website: clinic.website || '',
					facebook: clinic.facebook || '',
					instagram: clinic.instagram || '',
					telegram: clinic.telegram || '',
					whatsapp: clinic.whatsapp || '',
					viber: clinic.viber || '',
					descriptionSr: clinic.description_sr || '',
					descriptionSrCyrl: clinic.description_sr_cyrl || '',
					descriptionRu: clinic.description_ru || '',
					descriptionEn: clinic.description_en || '',
					descriptionDe: clinic.description_de || '',
					descriptionTr: clinic.description_tr || '',
					logoUrl: clinic.logo_url || '',
					languageIds: clinic.languageIds || '',
					clinicTypeIds: clinic.clinicTypeIds || '',
				};
			});
		} finally {
			await connection.end();
		}
	},
);
