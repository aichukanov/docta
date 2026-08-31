import { getConnection } from '~/server/common/db-mysql';
import { doctorIsPublicSql } from '~/server/common/doctor-visibility';
import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { DoctorSpecialty } from '~/enums/specialty';

function getEnumValues(enumType: Record<string, string | number>): number[] {
	return Object.values(enumType).filter(
		(value): value is number => !Number.isNaN(Number(value)),
	);
}

/**
 * Специальности, у которых реально есть хотя бы один публичный врач.
 *
 * Раньше в sitemap уезжал весь enum (78 значений). Листинг на пустой выборке
 * отдаёт `noindex, follow` (components/list-page.vue), то есть sitemap просил
 * индексировать страницу, которая сама просит этого не делать. Расхождение
 * росло молча: новое значение enum'а появляется в sitemap в тот же день, а
 * первый врач с этой специальностью — когда-нибудь.
 *
 * Результат пересекаем с enum'ом: id вне enum'а не проходит
 * `validateSpecialtyIds`, листинг молча покажет полный каталог и отдаст
 * `noindex` — такой URL в sitemap не нужен тем более.
 */
async function getSpecialtyIdsWithDoctors() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ds.specialty_id as specialtyId
		FROM doctor_specialties ds
		INNER JOIN doctors d ON d.id = ds.doctor_id
			AND ${doctorIsPublicSql('d')}
		ORDER BY ds.specialty_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	const knownIds = new Set(getEnumValues(DoctorSpecialty));

	return (rows as Array<{ specialtyId: number }>)
		.map((row) => row.specialtyId)
		.filter((specialtyId) => knownIds.has(specialtyId));
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
		specialtyIds: await getSpecialtyIdsWithDoctors(),
		specialtyCityCombinations: await getSpecialtyCityCombinations(),
		specialtyLanguageCombinations: await getSpecialtyLanguageCombinations(),
	};
}
