import { locales, type Locale } from '~/composables/use-locale';
import { Language } from '~/enums/language';
import { DoctorSpecialty } from '~/enums/specialty';
import { CityId } from '~/enums/cities';

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

export function validateSpecialtyIds(
	{ specialtyIds }: { specialtyIds: unknown },
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
	{ cityIds }: { cityIds: unknown },
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
	{ languageIds }: { languageIds: unknown },
	from: string,
) {
	if (
		!Array.isArray(languageIds) ||
		languageIds.some((lang) => Language[lang as keyof typeof Language] == null)
	) {
		showError(from, 'Invalid doctor language: ' + languageIds);
		return false;
	}

	return true;
}

export function validateNonNegativeNumber(value: string): boolean {
	if (value == null) {
		return false;
	}

	const num = +value;
	return !isNaN(num) && num >= 0;
}

export function validateNonNegativeInteger(value: string): boolean {
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
