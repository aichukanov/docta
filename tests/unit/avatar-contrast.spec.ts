import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Аватар-заглушка — цветной квадрат с инициалами, и цвет фона зависит от хеша
// имени. Значит нечитаемым может оказаться любой цвет палитры, а увидит это
// только тот, кому не повезло с именем: на проде так и вышло —
// «Aleksandar Vidić» получил цвет с контрастом 3.97:1.
//
// Инициалы всегда белые, поэтому требование к палитре ровно одно, и проверять
// его надо не глазами.
//
// Палитра ЧИТАЕТСЯ КАК ТЕКСТ, а не импортируется. Причина: пакет отдаётся
// исходниками на TypeScript, а Node отказывается снимать типы с файлов внутри
// node_modules («Stripping types is currently unsupported for files under
// node_modules»). Пока пакет подменён `npm link`, импорт работает — реальный
// путь лежит вне node_modules, — а на обычной установке падает. Разбор текстом
// от способа установки не зависит и проверяет ровно тот файл, который уехал
// в сборку. Тот же приём, что в article-slugs.spec.ts.

const HERE = dirname(fileURLToPath(import.meta.url));
const PALETTE_FILE = resolve(
	HERE,
	'../../node_modules/@ach/ui-kit/src/avatar-colors.ts',
);

/** Инициалы крупные и bold, но планку берём строгую, для обычного текста. */
const MIN_RATIO = 4.5;
const TEXT_COLOR = '#ffffff';

function readPalette(): { colors: string[]; textColor: string } {
	const source = readFileSync(PALETTE_FILE, 'utf-8');

	const block = source.match(
		/export const AVATAR_COLORS = \[([\s\S]*?)\] as const;/,
	);
	if (!block) throw new Error(`не нашёл AVATAR_COLORS в ${PALETTE_FILE}`);

	const textMatch = source.match(
		/export const AVATAR_TEXT_COLOR = '(#[0-9a-fA-F]{6})'/,
	);
	if (!textMatch) throw new Error('не нашёл AVATAR_TEXT_COLOR');

	return {
		colors: [...block[1].matchAll(/'(#[0-9a-fA-F]{6})'/g)].map((m) => m[1]),
		textColor: textMatch[1],
	};
}

/** Относительная яркость sRGB по WCAG 2.1 */
function relativeLuminance(hex: string): number {
	const channels = [1, 3, 5].map((offset) => {
		const value = parseInt(hex.substring(offset, offset + 2), 16) / 255;
		return value <= 0.03928
			? value / 12.92
			: Math.pow((value + 0.055) / 1.055, 2.4);
	});
	return 0.2126 * channels[0] + 0.7152 * channels[1] + 0.0722 * channels[2];
}

function contrastRatio(a: string, b: string): number {
	const la = relativeLuminance(a);
	const lb = relativeLuminance(b);
	return (Math.max(la, lb) + 0.05) / (Math.min(la, lb) + 0.05);
}

test('палитра аватаров разбирается и не пуста', () => {
	const { colors, textColor } = readPalette();
	// Если разбор молча вернёт пустой список, остальные тесты пройдут вхолостую
	expect(
		colors.length,
		'палитра пуста — сломался разбор файла',
	).toBeGreaterThan(8);
	expect(textColor, 'цвет инициалов должен быть белым').toBe(TEXT_COLOR);
});

test('каждый цвет палитры читается с белым текстом', () => {
	const { colors, textColor } = readPalette();
	const failures = colors
		.map((c) => ({ c, ratio: contrastRatio(textColor, c) }))
		.filter(({ ratio }) => ratio < MIN_RATIO)
		.map(({ c, ratio }) => `${c}: ${ratio.toFixed(2)}:1`);

	expect(
		failures,
		`Цвета не дают ${MIN_RATIO}:1 с белым текстом.\n` +
			`Возьмите более тёмный оттенок того же тона.\n` +
			failures.join('\n'),
	).toEqual([]);
});

test('цвета палитры не повторяются', () => {
	// Дубликат съедает разнообразие незаметно: в прежней, подобранной вручную
	// палитре так уже было (два одинаковых оранжевых).
	const { colors } = readPalette();
	expect(new Set(colors).size, 'в палитре есть повторяющиеся цвета').toBe(
		colors.length,
	);
});

test('замеры в комментариях палитры совпадают с расчётом', () => {
	// Комментарии рядом с цветами — единственная подсказка тому, кто будет
	// править палитру. Разъехавшись с реальностью, они станут вреднее, чем
	// их отсутствие.
	const source = readFileSync(PALETTE_FILE, 'utf-8');
	const rows = [
		...source.matchAll(/'(#[0-9a-fA-F]{6})',\s*\/\/[^\n]*?(\d+\.\d+):1/g),
	];
	expect(
		rows.length,
		'ни у одного цвета нет замера в комментарии',
	).toBeGreaterThan(8);

	const drifted: string[] = [];
	for (const [, hex, claimed] of rows) {
		const real = contrastRatio(TEXT_COLOR, hex);
		if (Math.abs(real - Number(claimed)) > 0.02) {
			drifted.push(
				`${hex}: в комментарии ${claimed}, на самом деле ${real.toFixed(2)}`,
			);
		}
	}
	expect(drifted, drifted.join('\n')).toEqual([]);
});
