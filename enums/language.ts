export enum Language {
	SR = 'sr',
	BA = 'ba',
	ME = 'me',
	EN = 'en',
	RU = 'ru',
	DE = 'de',
	TR = 'tr',
}

// ID из базы данных
export enum LanguageId {
	SR = 1,
	RU = 2,
	EN = 3,
}

export function isDoctorLanguage(lang: string): boolean {
	return Object.values(LanguageId).filter(Number).includes(+lang);
}
