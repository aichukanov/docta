import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { priceRowIsActiveSql } from '../../server/common/price-row-visibility';

// Строка прайса с is_obsolete = 1 — позиция, которой клиника больше не
// публикует. Из поиска, листингов, счётчиков, ранжирования и sitemap она
// исчезает; страница услуги/анализа по прямой ссылке показывает её с
// пометкой. Каждый файл, читающий clinic_medical_services / clinic_lab_tests,
// обязан явно решить, к какой группе он относится, — иначе новый запрос
// молча вернёт устаревшие строки в выдачу.

const HERE = dirname(fileURLToPath(import.meta.url));
const SERVER_DIR = resolve(HERE, '../../server');

// Публичные выборки: фильтр priceRowIsActiveSql() обязателен.
const PUBLIC_FILTERED = [
	'api/clinics/list.ts',
	'api/labtests/list.ts',
	'api/services/list.ts',
	'common/clinic-items-summary.ts',
	'common/services.ts',
	'common/sitemap/filters/clinic-subpages.ts',
	'common/sitemap/filters/labtests.ts',
	'common/sitemap/filters/services.ts',
	'utils/entity-ranking.ts',
];
// Прямая ссылка: устаревшие строки отдаются, но с флагом is_obsolete.
const PUBLIC_FLAGGED = ['api/labtests/details.ts', 'api/services/details.ts'];
// Админка и обслуживание: видят всё, флаг переносят при слиянии.
const ADMIN = [
	'api/clinics/remove.ts',
	'api/labtests/add.ts',
	'api/labtests/admin-details.ts',
	'api/labtests/duplicates/queue.get.ts',
	'api/labtests/merge.ts',
	'api/labtests/remove.ts',
	'api/labtests/update.ts',
	'api/services/add.ts',
	'api/services/admin-details.ts',
	'api/services/duplicates/queue.get.ts',
	'api/services/merge.ts',
	'api/services/remove.ts',
	'api/services/update.ts',
];

// Таблицы упомянуты только в комментариях — запросов нет.
const COMMENTS_ONLY = ['common/price-row-visibility.ts', 'common/utils.ts'];

function tsFiles(dir: string): string[] {
	return readdirSync(dir).flatMap((entry) => {
		const path = join(dir, entry);
		if (statSync(path).isDirectory()) return tsFiles(path);
		return path.endsWith('.ts') ? [path] : [];
	});
}
const rel = (path: string) => relative(SERVER_DIR, path).split('\\').join('/');
const read = (file: string) => readFileSync(resolve(SERVER_DIR, file), 'utf8');

test('предикат — одна колонка в скобках', () => {
	expect(priceRowIsActiveSql('cms')).toBe('(cms.is_obsolete = 0)');
});

test('каждый файл с таблицами цен клиник отнесён к одной из групп', () => {
	const known = new Set([
		...PUBLIC_FILTERED,
		...PUBLIC_FLAGGED,
		...ADMIN,
		...COMMENTS_ONLY,
	]);
	const unknown = tsFiles(SERVER_DIR)
		.filter((path) => /clinic_(medical_services|lab_tests)\b/.test(readFileSync(path, 'utf8')))
		.map(rel)
		.filter((file) => !known.has(file));
	expect(
		unknown,
		'Новый запрос к прайсам клиник: решите, публичный ли он, и добавьте файл ' +
			'в список (публичный — с priceRowIsActiveSql)',
	).toEqual([]);
});

for (const file of PUBLIC_FILTERED) {
	test(`${file}: публичная выборка фильтрует устаревшие строки`, () => {
		expect(read(file)).toContain('priceRowIsActiveSql(');
	});
}

for (const file of PUBLIC_FLAGGED) {
	test(`${file}: прямая ссылка отдаёт флаг и ставит устаревшие в конец`, () => {
		const src = read(file);
		expect(src).toMatch(/is_price_outdated, ':', \w+\.is_obsolete\)/);
		expect(src).toMatch(/\w+\.is_obsolete ASC, /);
	});
}

for (const file of ['api/labtests/merge.ts', 'api/services/merge.ts']) {
	test(`${file}: слияние не теряет флаг`, () => {
		expect(read(file)).toMatch(/is_price_outdated, is_obsolete\)\s*\n\s*SELECT \?, [^\n]*is_obsolete/);
	});
}
