import { getConnection } from '~/server/common/db-mysql';
import { doctorIsPublicSql } from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { DoctorSpecialty } from '~/enums/specialty';

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

function getSpecialtyIds() {
	return getEnumValues(DoctorSpecialty);
}

export async function getSpecialtyCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ds.specialty_id as specialtyId, clinics.city_id as cityId
		FROM doctors d
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN clinics ON dc.clinic_id = clinics.id
			AND ${clinicIsPublicSql('clinics')}
		WHERE ${doctorIsPublicSql('d')}
		ORDER BY ds.specialty_id, clinics.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ specialtyId: number; cityId: number }>;
}

async function getSpecialtyLanguageCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT specialty_id as specialtyId, lang_id as languageId
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1 AND ${doctorIsPublicSql('d')}
			UNION
			SELECT ds.specialty_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics c ON c.id = dc.clinic_id
				AND ${clinicIsPublicSql('c')}
			WHERE cl.language_id != 1 AND ${doctorIsPublicSql('d')}
		) as combined
		ORDER BY specialty_id, lang_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ specialtyId: number; languageId: number }>;
}

export async function getSitemapFilters() {
	return {
		specialtyIds: getSpecialtyIds(),
		specialtyCityCombinations: await getSpecialtyCityCombinations(),
		specialtyLanguageCombinations: await getSpecialtyLanguageCombinations(),
	};
}
