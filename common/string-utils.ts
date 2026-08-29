/**
 * Первая буква — заглавная. `locale` обязателен там, где строка приходит из
 * i18n: в турецком `i` даёт `İ`, а не `I` (`iltihap giderici` → `İltihap...`).
 */
export function capitalizeFirstLetter(s: string, locale?: string) {
	if (!s) return s;
	return (locale ? s[0].toLocaleUpperCase(locale) : s[0].toUpperCase()) + s.slice(1);
}
