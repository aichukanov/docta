import { getConnection } from '~/server/common/db-mysql';
import { getCurrentUser } from '~/server/common/auth';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';

export interface DoctorMyProfile {
	id: number;
	hidden: boolean;
	isDraft: boolean;
	name: string;
	localName: string;
	nameSr: string;
	nameSrCyrl: string;
	nameRu: string;
	nameEn: string;
	professionalTitle: string;
	photoUrl: string;
	descriptionSr: string;
	descriptionSrCyrl: string;
	descriptionRu: string;
	descriptionEn: string;
	descriptionDe: string;
	descriptionTr: string;
	specialtyIds: string;
	languageIds: string;
	clinicIds: string;
}

export default defineEventHandler(
	async (event): Promise<DoctorMyProfile | null> => {
		const user = await getCurrentUser(event);
		if (!user) {
			throw createError({
				statusCode: 401,
				statusMessage: 'Unauthorized',
			});
		}

		const connection = await getConnection();
		try {
			const [rows]: any = await connection.execute(
				`SELECT 
				d.id, d.hidden, d.is_draft,
				d.name_sr, d.name_sr_cyrl, d.name_ru, d.name_en,
				d.professional_title, d.photo_url,
				d.description_sr, d.description_sr_cyrl, d.description_ru,
				d.description_en, d.description_de, d.description_tr,
				(SELECT GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) FROM doctor_specialties ds WHERE ds.doctor_id = d.id) as specialtyIds,
				(SELECT GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) FROM doctor_languages dl WHERE dl.doctor_id = d.id) as languageIds,
				(SELECT GROUP_CONCAT(DISTINCT dc.clinic_id ORDER BY dc.clinic_id) FROM doctor_clinics dc WHERE dc.doctor_id = d.id) as clinicIds
			FROM doctors d
			WHERE d.user_id = ?`,
				[user.id],
			);

			if (!rows.length) {
				return null;
			}

			const doctor = rows[0];
			const locale =
				getCookie(event, 'locale') ||
				getHeader(event, 'accept-language')?.slice(0, 2) ||
				'en';
			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				doctor,
				locale,
			);

			return {
				id: doctor.id,
				hidden: Boolean(doctor.hidden),
				isDraft: Boolean(doctor.is_draft),
				name,
				localName,
				nameSr: doctor.name_sr || '',
				nameSrCyrl: doctor.name_sr_cyrl || '',
				nameRu: doctor.name_ru || '',
				nameEn: doctor.name_en || '',
				professionalTitle: doctor.professional_title || '',
				photoUrl: doctor.photo_url || '',
				descriptionSr: doctor.description_sr || '',
				descriptionSrCyrl: doctor.description_sr_cyrl || '',
				descriptionRu: doctor.description_ru || '',
				descriptionEn: doctor.description_en || '',
				descriptionDe: doctor.description_de || '',
				descriptionTr: doctor.description_tr || '',
				specialtyIds: doctor.specialtyIds || '',
				languageIds: doctor.languageIds || '',
				clinicIds: doctor.clinicIds || '',
			};
		} finally {
			await connection.end();
		}
	},
);
