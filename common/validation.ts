import { locales, type Locale } from '~/composables/use-locale';
import { Language, isDoctorLanguage } from '~/enums/language';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';
import { LabTestCategory } from '~/enums/labtest-category';
import { MedicalServiceCategory } from '~/enums/medical-service-category';
import { ClinicType } from '~/enums/clinic-type';

function showError(from: string, message: string) {
	console.error('Error in ' + from + ';\n' + message);
}

export function validateBody(body: any, from: string) {
	if (!body) {
		showError(from, 'Not provided parameters');
		return false;
	}

	return true;
}

export function validateName({ name }: { name?: unknown }, from: string) {
	if (typeof name !== 'string') {
		showError(from, 'Invalid name: must be a string');
		return false;
	}

	const trimmed = name.trim();

	if (trimmed === '') {
		return true;
	}

	// Allow only letters (any locale), digits, spaces, hyphens, dots and commas
	const allowedPattern = /^[\p{L}\d\s.,-]+$/u;
	if (!allowedPattern.test(trimmed)) {
		showError(
			from,
			`Invalid name: only letters, digits, spaces, hyphens, dots and commas allowed. Received: "${trimmed}"`,
		);
		return false;
	}

	return true;
}

export function validateSpecialtyIds(
	{ specialtyIds }: { specialtyIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(specialtyIds) ||
		specialtyIds.some(
			(specialty) =>
				DoctorSpecialty[specialty as keyof typeof DoctorSpecialty] == null,
		)
	) {
		showError(from, 'Invalid doctor specialty: ' + specialtyIds);
		return false;
	}

	return true;
}

export function validateCityIds(
	{ cityIds }: { cityIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(cityIds) ||
		cityIds.some((city) => CityId[city as keyof typeof CityId] == null)
	) {
		showError(from, 'Invalid doctor city: ' + cityIds);
		return false;
	}

	return true;
}

export function validateDoctorLanguageIds(
	{ languageIds }: { languageIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(languageIds) ||
		!languageIds.every((lang) => isDoctorLanguage(String(lang)))
	) {
		showError(from, 'Invalid doctor language: ' + languageIds);
		return false;
	}

	return true;
}

export function validateCityId({ cityId }: { cityId?: unknown }, from: string) {
	if (CityId[cityId as keyof typeof CityId] == null) {
		showError(from, 'Invalid city: ' + cityId);
		return false;
	}

	return true;
}

export function validateClinicIds(
	{ clinicIds }: { clinicIds?: unknown },
	from: string,
	required = false,
) {
	if (!Array.isArray(clinicIds) || (required && clinicIds.length === 0)) {
		showError(from, 'Invalid clinic ids: must be a non-empty array');
		return false;
	}

	if (!clinicIds.every((id) => validateNonNegativeInteger(id as string))) {
		showError(from, 'Invalid clinic id values: ' + String(clinicIds));
		return false;
	}

	return true;
}

export function validateNonNegativeNumber(value: string | number): boolean {
	if (value == null) {
		return false;
	}

	const num = +value;
	return !isNaN(num) && num >= 0;
}

export function validateNonNegativeInteger(value: string | number): boolean {
	if (value == null) {
		return false;
	}

	const num = +value;
	return Number.isInteger(num) && num >= 0;
}

export function validateNonNegativeIntegerArray(arr: string[]): boolean {
	return (
		Array.isArray(arr) &&
		arr.length > 0 &&
		arr.every((v) => validateNonNegativeInteger(v))
	);
}

// Минимальный рейтинг для фильтра клиник: 1..5 с шагом 0.5
export function validateMinRating(
	{ minRating }: { minRating?: unknown },
	from?: string,
) {
	const num = Number(minRating);

	if (!Number.isFinite(num) || num < 1 || num > 5 || (num * 2) % 1 !== 0) {
		if (from) {
			showError(from, 'Invalid min rating: ' + minRating);
		}
		return false;
	}

	return true;
}

export function validateUserCoordinates(
	{
		userLatitude,
		userLongitude,
	}: { userLatitude?: unknown; userLongitude?: unknown },
	from: string,
) {
	const lat = Number(userLatitude);
	const lng = Number(userLongitude);

	if (
		!Number.isFinite(lat) ||
		lat < -90 ||
		lat > 90 ||
		!Number.isFinite(lng) ||
		lng < -180 ||
		lng > 180
	) {
		showError(
			from,
			`Invalid user coordinates: ${userLatitude}, ${userLongitude}`,
		);
		return false;
	}

	return true;
}

export function validateCategoryIds(
	{ categoryIds }: { categoryIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(categoryIds) ||
		categoryIds.some(
			(category) =>
				LabTestCategory[category as keyof typeof LabTestCategory] == null,
		)
	) {
		showError(from, 'Invalid lab test category: ' + categoryIds);
		return false;
	}

	return true;
}

export function validateClinicTypeIds(
	{ clinicTypeIds }: { clinicTypeIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(clinicTypeIds) ||
		clinicTypeIds.some(
			(type) => ClinicType[type as keyof typeof ClinicType] == null,
		)
	) {
		showError(from, 'Invalid clinic type: ' + clinicTypeIds);
		return false;
	}

	return true;
}

export function validateServiceCategoryIds(
	{ serviceCategoryIds }: { serviceCategoryIds?: unknown },
	from: string,
) {
	if (
		!Array.isArray(serviceCategoryIds) ||
		serviceCategoryIds.some(
			(category) =>
				MedicalServiceCategory[
					category as keyof typeof MedicalServiceCategory
				] == null,
		)
	) {
		showError(from, 'Invalid medical service category: ' + serviceCategoryIds);
		return false;
	}

	return true;
}
