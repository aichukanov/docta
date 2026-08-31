import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { isValidLocale } from '../../common/validation';

// Локаль — недоверенный ввод: она приходит в теле запроса (`body.locale`) и в
// `?lang=`, то есть её задаёт кто угодно.
//
// В server/common/reviews.ts она подставлялась прямо в текст SQL внутри
// одинарных кавычек (`WHEN '${locale}' = 'sr' THEN ...`). Апостроф в значении
// закрывал строковый литерал, и `connection.execute` уже не спасал — запрос к
// этому моменту собран. Эндпоинты отзывов публичные, без авторизации.
//
// Починка двухслойная, и тест сторожит оба слоя:
//   1) колонка перевода выбирается по ключу из фиксированной таблицы, а не
//      склейкой (server/common/reviews.ts, server/common/utils.ts);
//   2) `body.locale` проходит через isValidLocale в эндпоинтах.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

function read(path: string) {
	return readFileSync(path, 'utf-8');
}

function walk(dir: string, out: string[] = []): string[] {
	for (const entry of readdirSync(dir)) {
		const full = resolve(dir, entry);
		if (statSync(full).isDirectory()) {
			walk(full, out);
		} else if (full.endsWith('.ts')) {
			out.push(full);
		}
	}
	return out;
}

test.describe('локаль не попадает в текст SQL', () => {
	const serverFiles = walk(resolve(ROOT, 'server'));

	test('нашлись серверные исходники', () => {
		expect(serverFiles.length).toBeGreaterThan(50);
	});

	test('нигде нет подстановки локали в SQL-литерал', () => {
		// Ровно та форма, которой была инъекция: значение локали внутри кавычек.
		const interpolated = /'\$\{\s*locale\s*\}'/;

		const offenders = serverFiles
			.filter((file) => interpolated.test(read(file)))
			.map((file) => relative(ROOT, file));

		expect(offenders).toEqual([]);
	});

	test('текст отзыва берётся из таблицы колонок, а не склейкой', () => {
		const source = read(resolve(ROOT, 'server/common/reviews.ts'));

		// Таблица «локаль → колонка» на месте.
		expect(source).toContain('LOCALE_TEXT_COLUMNS');
		// И локаль используется как ключ, а не как кусок запроса.
		expect(source).toMatch(/LOCALE_TEXT_COLUMNS\[\s*locale\s*\]/);
	});
});

test.describe('эндпоинты валидируют body.locale', () => {
	const apiFiles = walk(resolve(ROOT, 'server/api'));

	test('нет ни одного `body.locale || ...` без проверки', () => {
		// Сырой фолбэк принимал любую строку и делал фолбэки непредсказуемыми:
		// неизвестная локаль молча уводила выдачу на другой язык.
		const raw = /body\.locale\s*\|\|/;

		const offenders = apiFiles
			.filter((file) => raw.test(read(file)))
			.map((file) => relative(ROOT, file));

		expect(offenders).toEqual([]);
	});

	test('места, где читается body.locale, зовут isValidLocale', () => {
		const offenders = apiFiles
			.filter((file) => {
				const source = read(file);
				return (
					source.includes('body.locale') && !source.includes('isValidLocale')
				);
			})
			.map((file) => relative(ROOT, file));

		expect(offenders).toEqual([]);
	});
});

test.describe('isValidLocale', () => {
	test('пропускает все поддерживаемые локали', () => {
		for (const locale of ['sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr']) {
			expect(isValidLocale(locale)).toBe(true);
		}
	});

	test('отсекает инъекцию, мусор и не-строки', () => {
		const rejected: unknown[] = [
			"' OR 1=1 -- ",
			"sr' UNION SELECT 1 -- ",
			'RU',
			'',
			'it',
			null,
			undefined,
			42,
			['ru'],
			{ toString: () => 'ru' },
		];

		for (const value of rejected) {
			expect(isValidLocale(value)).toBe(false);
		}
	});
});
