import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Часть каталога переехала между сущностями: импорты прайсов завели
// лабораторные позиции в medical_services, и миграция 029 перенесла их в
// lab_tests, удалив услуги. У этих услуг были живые проиндексированные адреса,
// поэтому /services/<slug> обязан отдавать 301 на /labtests/<slug>.
//
// Раньше checkSlugRedirect собирал адрес как `/${entityType}/${targetSlug}`,
// то есть редирект физически не мог выйти за пределы своего каталога: строка
// в slug_redirects нашлась бы, id взялся бы от анализа, а слаг искался бы
// среди услуг — и цель не нашлась бы вообще.
//
// Тест сторожит три места, где эта связка рвётся молча — без падения, просто
// 404 вместо 301 на сотне адресов:
//   1) адрес собирается по каталогу ЦЕЛИ, а не по исходному;
//   2) редирект срабатывает и когда слаг совпал, но каталог разный
//      (/services/urine-culture → /labtests/urine-culture — обычный случай,
//      слаги в двух таблицах независимы и часто одинаковы);
//   3) target_entity_type действительно читается из таблицы.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

const redirectSource = readFileSync(
	resolve(ROOT, 'server/common/redirect/slug-redirects.ts'),
	'utf-8',
);

const slugDbSource = readFileSync(
	resolve(ROOT, 'server/common/slug-db.ts'),
	'utf-8',
);

test.describe('кросс-каталожный 301', () => {
	test('target_entity_type читается из slug_redirects', () => {
		expect(redirectSource).toContain('target_entity_type');
		// Пустое значение означает «цель того же типа» — без фолбэка все
		// существующие строки (обычные переименования слага) сломались бы.
		expect(redirectSource).toMatch(
			/row\.target_entity_type \|\| row\.entity_type/,
		);
	});

	test('адрес собирается по каталогу цели', () => {
		// Без закрывающего апострофа: в исходнике за слагом идёт ещё
		// подстановка query-строки, и шаблон разбит переносами.
		expect(redirectSource).toContain('`/${targetEntityType}/${targetSlug}');
		expect(redirectSource).not.toContain('`/${entityType}/${targetSlug}');
	});

	test('смена каталога сама по себе повод для редиректа', () => {
		// Условие обязано пропускать случай targetSlug === param: иначе
		// переезд с совпадающим слагом молча не сработает.
		expect(redirectSource).toMatch(
			/targetSlug !== param \|\| targetEntityType !== entityType/,
		);
	});

	test('слаг цели ищется в таблице каталога цели', () => {
		// Если бы таблица бралась из config (каталог исходного адреса), слаг
		// анализа искался бы среди услуг и цель не нашлась бы.
		expect(redirectSource).toMatch(
			/targetConfig\.table.*WHERE id = \?|FROM \$\{targetConfig\.table\}/s,
		);
	});

	test('проверка занятости слага учитывает каталог цели', () => {
		// «Та же сущность» — это совпадение и id, и каталога: нумерации услуг
		// и анализов независимы, и сравнение одних id выдало бы новой записи
		// слаг, по которому уже стоит 301 на чужой каталог.
		expect(slugDbSource).toMatch(
			/COALESCE\(target_entity_type, entity_type\) = \?/,
		);
	});
});
