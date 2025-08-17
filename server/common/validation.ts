import { ArticleCategory } from '~/enums/article-category';
import { Currency } from '~/enums/currency';
import { locales, type Locale } from '~/composables/use-locale';

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

export function validateCountry(
	{ country }: { country: string },
	from: string,
) {
	if (country?.length > 0) {
		return true;
	} else {
		showError(from, 'Invalid country: ' + country);
		return false;
	}
}

export function validatePageNumber(
	{
		pageNumber,
	}: {
		pageNumber: string | number;
	},
	from: string,
) {
	const parsedPageNumber = +pageNumber;
	if (!isNaN(parsedPageNumber) && parsedPageNumber >= 0) {
		return true;
	} else {
		showError(from, 'Invalid page number: ' + pageNumber);
		return false;
	}
}

export function validateLang({ lang }: { lang: string }, from: string) {
	if (typeof lang === 'string' && locales.includes(lang as Locale)) {
		return true;
	} else {
		showError(from, 'Invalid language: ' + lang);
		return false;
	}
}
