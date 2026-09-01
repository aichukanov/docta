import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// LIMIT/OFFSET подставлялись в ТЕКСТ SQL: `LIMIT ${pageSize} OFFSET ${offset}`.
// Это не дыра в безопасности (значения числовые и уже нормализованы), а износ
// кэша подготовленных выражений: каждое смещение даёт НОВЫЙ текст запроса, то
// есть новое подготовленное выражение. При 5237 услугах это ~262 смещения на
// LRU в 200 записей на соединение (maxPreparedStatements в
// server/common/db-mysql.ts, поставлен осознанно после инцидента с
// max_prepared_stmt_count=16382). Замер на живой БД: 262 страницы подряд —
// 262 COM_STMT_PREPARE и 62 COM_STMT_CLOSE против 1 и 0 с плейсхолдерами.
//
// Тест сторожит форму: во всех списочных эндпоинтах пагинация — связанные
// параметры. Регрессия здесь ничего не ломает наблюдаемо и потому иначе
// прошла бы незамеченной.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

const LIST_ENDPOINTS = [
	'server/api/services/list.ts',
	'server/api/clinics/list.ts',
	'server/api/doctors/list.ts',
	'server/api/labtests/list.ts',
	'server/api/medicines/list.ts',
	'server/api/medications/list.ts',
];

function read(path: string) {
	return readFileSync(resolve(ROOT, path), 'utf-8');
}

test.describe('пагинация уходит связанными параметрами', () => {
	for (const endpoint of LIST_ENDPOINTS) {
		test(`${endpoint}: LIMIT ? OFFSET ?`, () => {
			const source = read(endpoint);

			expect(source).toContain('LIMIT ? OFFSET ?');

			// Параметры передаются строками: mysql2 в execute() кодирует
			// JS-числа так, что MySQL отвечает «Incorrect arguments to
			// mysqld_stmt_execute» именно на LIMIT/OFFSET (проверено на 8.0.45).
			expect(source).toContain('String(pageSize)');
			expect(source).toContain('String(offset)');
		});
	}

	test('в списочных эндпоинтах не осталось инлайнового LIMIT/OFFSET', () => {
		// Ровно та форма, которая изнашивала кэш: значение в тексте запроса.
		// Проверяем только списочные эндпоинты: `LIMIT ${CONST}` с константой
		// модуля даёт один текст запроса на всё приложение и кэш не изнашивает,
		// изнашивает именно меняющийся OFFSET. Оставшийся такой случай в
		// публичном трафике — server/common/reviews.ts:235 (пагинация отзывов),
		// он вне этой правки.
		const interpolated = /(LIMIT|OFFSET)\s+\$\{/;

		const offenders = LIST_ENDPOINTS.filter((endpoint) =>
			interpolated.test(read(endpoint)),
		);

		expect(offenders).toEqual([]);
	});
});
