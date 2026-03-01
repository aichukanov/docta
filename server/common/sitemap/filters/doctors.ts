import { getConnection } from '~/server/common/db-mysql';
import { DoctorSpecialty } from '~/enums/specialty';
import { LanguageId } from '~/enums/language';
import { CityId } from '~/enums/cities';

function getEnumValues(enumType: any) {
	return Object.values(enumType).filter(
		(value) => !Number.isNaN(Number(value)),
	);
}

// === Одиночные фильтры ===

export function getSpecialtyIds() {
	return getEnumValues(DoctorSpecialty);
}

export function getCityIds() {
	return getEnumValues(CityId);
}

export function getLanguageIds() {
	// Исключаем сербский язык (id = 1) — это язык по умолчанию
	return getEnumValues(LanguageId).filter((id) => id !== 1);
}

// === Комбинации фильтров из БД ===

export async function getSpecialtyCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT ds.specialty_id as specialtyId, clinics.city_id as cityId
		FROM doctors d
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN clinics ON dc.clinic_id = clinics.id
		WHERE d.hidden = FALSE AND d.is_draft = FALSE
		ORDER BY ds.specialty_id, clinics.city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ specialtyId: number; cityId: number }>;
}

export async function getSpecialtyLanguageCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT specialty_id as specialtyId, lang_id as languageId
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
			UNION
			SELECT ds.specialty_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
		) as combined
		ORDER BY specialty_id, lang_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ specialtyId: number; languageId: number }>;
}

export async function getLanguageCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT lang_id as languageId, city_id as cityId
		FROM (
			SELECT dl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE dl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
			UNION
			SELECT cl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE cl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
		) as combined
		ORDER BY lang_id, city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ languageId: number; cityId: number }>;
}

export async function getSpecialtyLanguageCityCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT specialty_id as specialtyId, lang_id as languageId, city_id as cityId
		FROM (
			SELECT ds.specialty_id, dl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE dl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
			UNION
			SELECT ds.specialty_id, cl.language_id as lang_id, clinics.city_id
			FROM doctors d
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			INNER JOIN clinics ON dc.clinic_id = clinics.id
			WHERE cl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
		) as combined
		ORDER BY specialty_id, lang_id, city_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{
		specialtyId: number;
		languageId: number;
		cityId: number;
	}>;
}

export async function getClinicCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT dc.clinic_id as clinicId
		FROM doctors d
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		WHERE d.hidden = FALSE AND d.is_draft = FALSE
		ORDER BY dc.clinic_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ clinicId: number }>;
}

export async function getClinicSpecialtyCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT dc.clinic_id as clinicId, ds.specialty_id as specialtyId
		FROM doctors d
		INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
		INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
		WHERE d.hidden = FALSE AND d.is_draft = FALSE
		ORDER BY dc.clinic_id, ds.specialty_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ clinicId: number; specialtyId: number }>;
}

export async function getClinicLanguageCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT clinic_id as clinicId, lang_id as languageId
		FROM (
			SELECT dc.clinic_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
			UNION
			SELECT dc.clinic_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
		) as combined
		ORDER BY clinic_id, lang_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{ clinicId: number; languageId: number }>;
}

export async function getClinicSpecialtyLanguageCombinations() {
	const connection = await getConnection();

	const query = `
		SELECT DISTINCT clinic_id as clinicId, specialty_id as specialtyId, lang_id as languageId
		FROM (
			SELECT dc.clinic_id, ds.specialty_id, dl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN doctor_languages dl ON d.id = dl.doctor_id
			WHERE dl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
			UNION
			SELECT dc.clinic_id, ds.specialty_id, cl.language_id as lang_id
			FROM doctors d
			INNER JOIN doctor_clinics dc ON d.id = dc.doctor_id
			INNER JOIN doctor_specialties ds ON d.id = ds.doctor_id
			INNER JOIN clinic_languages cl ON dc.clinic_id = cl.clinic_id
			WHERE cl.language_id != 1 AND d.hidden = FALSE AND d.is_draft = FALSE
		) as combined
		ORDER BY clinic_id, specialty_id, lang_id;
	`;
	const [rows] = await connection.execute<any[]>(query);
	await connection.end();

	return rows as Array<{
		clinicId: number;
		specialtyId: number;
		languageId: number;
	}>;
}

// === Фильтры для Sitemap (только ценные, без thin pages) ===

export async function getSitemapFilters() {
	return {
		// Одиночные
		specialtyIds: getSpecialtyIds(),
		// Комбинации
		specialtyCityCombinations: await getSpecialtyCityCombinations(),
		specialtyLanguageCombinations: await getSpecialtyLanguageCombinations(),
	};
}
