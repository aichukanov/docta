import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import type { ContactList } from '~/interfaces/contacts';

interface DoctorServicePrice {
	clinicId: number;
	serviceId: number;
	price: number | null;
	priceMax: number | null;
}

interface DoctorAdminDetails extends ContactList {
	id: number;
	name: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_en: string;
	description_sr: string;
	description_sr_cyrl: string;
	description_ru: string;
	description_en: string;
	description_de: string;
	description_tr: string;
	specialtyIds: number[];
	languageIds: number[];
	clinicIds: number[];
	professionalTitle: string;
	photoUrl: string;
	servicePrices: DoctorServicePrice[];
}

export default defineEventHandler(
	async (event): Promise<DoctorAdminDetails | null> => {
		try {
			requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/doctors/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.doctorId)) {
				setResponseStatus(event, 400, 'Invalid doctor id');
				return null;
			}

			const connection = await getConnection();

			// Получаем основные данные врача
			const [doctorRows]: any = await connection.execute(
				`SELECT id, name_sr, name_sr_cyrl, name_ru, name_en, 
				        description_sr, description_sr_cyrl, description_ru, description_en, description_de, description_tr,
				        professional_title, photo_url, phone, email, facebook, instagram, telegram, whatsapp, viber, website 
				 FROM doctors WHERE id = ?`,
				[body.doctorId],
			);

			if (!doctorRows.length) {
				await connection.end();
				return null;
			}

			const doctor = doctorRows[0];

			// Получаем специальности
			const [specialtyRows]: any = await connection.execute(
				`SELECT specialty_id FROM doctor_specialties WHERE doctor_id = ?`,
				[body.doctorId],
			);

			// Получаем языки
			const [languageRows]: any = await connection.execute(
				`SELECT language_id FROM doctor_languages WHERE doctor_id = ?`,
				[body.doctorId],
			);

			// Получаем клиники
			const [clinicRows]: any = await connection.execute(
				`SELECT clinic_id FROM doctor_clinics WHERE doctor_id = ?`,
				[body.doctorId],
			);

			// Получаем услуги врача с ценами по клиникам
			const [servicePriceRows]: any = await connection.execute(
				`SELECT clinic_id, medical_service_id, price, price_max 
				 FROM clinic_medical_service_doctors 
				 WHERE doctor_id = ? 
				 ORDER BY clinic_id, medical_service_id`,
				[body.doctorId],
			);

			await connection.end();

			const servicePrices: DoctorServicePrice[] = servicePriceRows.map(
				(r: any) => ({
					clinicId: r.clinic_id,
					serviceId: r.medical_service_id,
					price: r.price,
					priceMax: r.price_max,
				}),
			);

			return {
				id: doctor.id,
				name: doctor.name_sr || '',
				name_sr_cyrl: doctor.name_sr_cyrl || '',
				name_ru: doctor.name_ru || '',
				name_en: doctor.name_en || '',
				description_sr: doctor.description_sr || '',
				description_sr_cyrl: doctor.description_sr_cyrl || '',
				description_ru: doctor.description_ru || '',
				description_en: doctor.description_en || '',
				description_de: doctor.description_de || '',
				description_tr: doctor.description_tr || '',
				specialtyIds: specialtyRows.map((r: any) => r.specialty_id),
				languageIds: languageRows.map((r: any) => r.language_id),
				clinicIds: clinicRows.map((r: any) => r.clinic_id),
				professionalTitle: doctor.professional_title || '',
				photoUrl: doctor.photo_url || '',
				phone: doctor.phone || '',
				email: doctor.email || '',
				facebook: doctor.facebook || '',
				instagram: doctor.instagram || '',
				telegram: doctor.telegram || '',
				whatsapp: doctor.whatsapp || '',
				viber: doctor.viber || '',
				website: doctor.website || '',
				servicePrices,
			};
		} catch (error) {
			console.error('API Error - doctor admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch doctor details',
			});
		}
	},
);
