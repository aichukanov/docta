import { toLatin } from '~/common/serbian-transliteration';

// Сербская латиница с диакритикой → ASCII (после toLowerCase)
const DIACRITICS: Record<string, string> = {
	č: 'c',
	ć: 'c',
	š: 's',
	ž: 'z',
	đ: 'dj',
};

export function generateSlug(name: string): string {
	// Кириллица → сербская латиница проектной транслитерацией (1:1, с диграфами
	// љ→lj, џ→dž); русские буквы вне сербского алфавита (ё, ю, я…) не мапятся
	// и отсеются ниже — от вырожденного слага страхует ensureUniqueSlug.
	return toLatin(name)
		.toLowerCase()
		.replace(/[čćšžđ]/g, (char) => DIACRITICS[char])
		.replace(/[^a-z0-9\s-]/g, '')
		.replace(/[\s]+/g, '-')
		.replace(/-+/g, '-')
		.replace(/^-|-$/g, '');
}
