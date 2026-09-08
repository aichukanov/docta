import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Глобальный поиск живёт в первом экране главной, а справочники каталога
// (специальности, города, категории услуг и анализов, фасовки) нужны только
// после того, как в поле что-то ввели: до этого дропдаун закрыт, в том числе
// на SSR. Статический импорт клал их в чанк главной — около 150 КБ raw
// (20+ КБ gzip) на критическом пути. Тест сторожит, что они остались
// динамическими: обратно они возвращаются одной строкой import и молча.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

const read = (relativePath: string) =>
	readFileSync(resolve(ROOT, relativePath), 'utf-8');

// Словари, ради веса которых всё и затевалось (raw-размер исходника в скобках)
const LAZY_DICTIONARIES = [
	'~/i18n/specialty', // 81 КБ
	'~/i18n/packaging', // 22 КБ
	'~/i18n/labtest-category', // 22 КБ
	'~/i18n/medical-service-category', // 16 КБ
	'~/i18n/city', // 9 КБ
	'~/i18n/clinic-common',
	'~/i18n/search-match',
];

test.describe('справочники глобального поиска грузятся по требованию', () => {
	test('компонент не импортирует их статически', () => {
		const source = read('components/global-search.vue');

		for (const dictionary of LAZY_DICTIONARIES) {
			expect(
				source,
				`${dictionary} должен подтягиваться через loadSearchCatalogMessages()`,
			).not.toMatch(new RegExp(`^import .*from '${dictionary}';`, 'm'));
		}
	});

	test('загрузчик тянет их через динамический import()', () => {
		const source = read('composables/use-search-catalog-i18n.ts');

		for (const dictionary of LAZY_DICTIONARIES) {
			expect(source).toContain(`import('${dictionary}')`);
		}
	});

	test('фильтрация ждёт словари до первого t()', () => {
		const source = read('components/global-search.vue');

		// Без ожидания t('specialty_5') вернёт сырой ключ: специальности
		// перестанут находиться, а подписи в выдаче останутся ключами.
		const debounceBody = source.slice(
			source.indexOf('const debouncedSearch = debounce('),
			source.indexOf('filterSpecialties(query);', source.indexOf('debounce(')),
		);

		expect(debounceBody).toContain('await ensureCatalogMessages()');
	});
});
