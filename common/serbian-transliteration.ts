/**
 * Транслитерация сербского языка: латиница ↔ кириллица
 * Сербский язык уникален — между латиницей и кириллицей существует
 * однозначное соответствие (1:1)
 */

// Диграфы должны обрабатываться первыми (порядок важен!)
const digraphs: [string, string][] = [
	['Nj', 'Њ'],
	['NJ', 'Њ'],
	['nj', 'њ'],
	['Lj', 'Љ'],
	['LJ', 'Љ'],
	['lj', 'љ'],
	['Dž', 'Џ'],
	['DŽ', 'Џ'],
	['dž', 'џ'],
];

const latinToCyrillicMap: Record<string, string> = {
	A: 'А',
	a: 'а',
	B: 'Б',
	b: 'б',
	V: 'В',
	v: 'в',
	G: 'Г',
	g: 'г',
	D: 'Д',
	d: 'д',
	Đ: 'Ђ',
	đ: 'ђ',
	E: 'Е',
	e: 'е',
	Ž: 'Ж',
	ž: 'ж',
	Z: 'З',
	z: 'з',
	I: 'И',
	i: 'и',
	J: 'Ј',
	j: 'ј',
	K: 'К',
	k: 'к',
	L: 'Л',
	l: 'л',
	M: 'М',
	m: 'м',
	N: 'Н',
	n: 'н',
	O: 'О',
	o: 'о',
	P: 'П',
	p: 'п',
	R: 'Р',
	r: 'р',
	S: 'С',
	s: 'с',
	T: 'Т',
	t: 'т',
	Ć: 'Ћ',
	ć: 'ћ',
	U: 'У',
	u: 'у',
	F: 'Ф',
	f: 'ф',
	H: 'Х',
	h: 'х',
	C: 'Ц',
	c: 'ц',
	Č: 'Ч',
	č: 'ч',
	Š: 'Ш',
	š: 'ш',
};

const cyrillicToLatinMap: Record<string, string> = Object.fromEntries(
	Object.entries(latinToCyrillicMap).map(([lat, cyr]) => [cyr, lat]),
);

// Добавляем диграфы в обратную карту
const digraphsCyrToLat: Record<string, string> = {
	Њ: 'Nj',
	њ: 'nj',
	Љ: 'Lj',
	љ: 'lj',
	Џ: 'Dž',
	џ: 'dž',
};

/**
 * Преобразует сербский текст с латиницы в кириллицу
 * Сохраняет placeholder'ы i18n вида {variable} без изменений
 */
export function toCyrillic(text: string): string {
	if (!text) return text;

	// Извлекаем placeholder'ы {variable} и заменяем на временные метки
	const placeholders: string[] = [];
	let result = text.replace(/\{[^}]+\}/g, (match) => {
		placeholders.push(match);
		return `\x00${placeholders.length - 1}\x00`;
	});

	// Обрабатываем диграфы
	for (const [latin, cyrillic] of digraphs) {
		result = result.replaceAll(latin, cyrillic);
	}

	// Затем отдельные буквы
	result = result
		.split('')
		.map((char) => latinToCyrillicMap[char] || char)
		.join('');

	// Возвращаем placeholder'ы обратно
	return result.replace(/\x00(\d+)\x00/g, (_, index) => placeholders[+index]);
}

/**
 * Преобразует сербский текст с кириллицы в латиницу
 */
export function toLatin(text: string): string {
	if (!text) return text;

	return text
		.split('')
		.map((char) => digraphsCyrToLat[char] || cyrillicToLatinMap[char] || char)
		.join('');
}

/**
 * Проверяет, содержит ли текст кириллицу
 */
export function hasCyrillic(text: string): boolean {
	return /[а-яА-ЯЂђЈјЉљЊњЋћЏџ]/.test(text);
}

/**
 * Проверяет, содержит ли текст сербскую латиницу
 */
export function hasSerbianLatin(text: string): boolean {
	return /[čćžšđČĆŽŠĐ]/.test(text) || /[a-zA-Z]/.test(text);
}
