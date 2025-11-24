export enum Language {
	SR = 'sr',
	BA = 'ba',
	ME = 'me',
	EN = 'en',
	RU = 'ru',
	DE = 'de',
	TR = 'tr',
	IT = 'it',
	FR = 'fr',
}

// ID из базы данных
export enum LanguageId {
	SR = 1,
	RU = 2,
	EN = 3,
	// BA = 4, // unused
	// ME = 5, // unused
	DE = 6,
	TR = 7,
	IT = 8,
	FR = 9,
}

export function isDoctorLanguage(lang: string): boolean {
	return Object.values(LanguageId).filter(Number).includes(+lang);
}
