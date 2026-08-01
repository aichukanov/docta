import { test, expect } from '@playwright/test';
import { readdirSync, readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Пункты 7d/7e в docs/audit/seo-2026-07.md.
//
// Оба дефекта одного вида: параметр в URL не проходит валидацию, приложение
// молча делает вид, что параметра не было, и отдаёт ПОЛНЫЙ список с 200 и
// self-canonical на мусорный URL. Значение может быть любым, поэтому это
// неограниченная поверхность дублей.
//
// Защита размазана по 11 файлам (7 листингов + 4 подстраницы клиник), и цена
// забытого места — новый раздел тихо заводится без noindex. Проверять это
// вживую дорого, поэтому тест сторожит сами исходники: он падает, когда
// появляется страница без проводки.

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');
const PAGES = resolve(ROOT, 'pages');

function read(path: string) {
	return readFileSync(path, 'utf-8');
}

test.describe('7d: листинги передают filterNamespace в ListPage', () => {
	// Проп в list-page.vue обязательный, поэтому забыть его = падение
	// typecheck. Тест ловит второй сценарий: страницу добавили, typecheck
	// прошёл (проп передали), но передали пустое/чужое значение.
	const listingPages = readdirSync(PAGES, { withFileTypes: true })
		.filter((e) => e.isDirectory())
		.map((e) => resolve(PAGES, e.name, 'index.vue'))
		.filter((p) => {
			try {
				return read(p).includes('<ListPage');
			} catch {
				return false;
			}
		});

	test('найдены все страницы со ListPage', () => {
		// На 2026-07-31 их 7: clinics, doctors, insurance-companies, labtests,
		// medications, medicines, services.
		expect(listingPages.length).toBeGreaterThanOrEqual(7);
	});

	for (const page of listingPages) {
		const name = page.replace(ROOT, '').replace(/\\/g, '/');
		test(`${name} передаёт filter-namespace`, () => {
			const source = read(page);
			expect(source).toMatch(/filter-namespace="[a-z-]+"/);
		});
	}
});

test.describe('7d: robots в list-page учитывает невалидные фильтры', () => {
	const source = read(resolve(ROOT, 'components/list-page.vue'));

	test('robotsMeta спрашивает стор про невалидные фильтры', () => {
		expect(source).toContain('hasInvalidFilters');
	});

	test('пустой список по-прежнему даёт noindex', () => {
		expect(source).toContain("'noindex, follow'");
	});
});

test.describe('7d: стор помечает невалидные значения, а не только гасит их', () => {
	const source = read(resolve(ROOT, 'stores/filters.ts'));

	test('updateFromRoute наполняет invalidFilterKeys', () => {
		expect(source).toContain('invalid.add(');
	});

	test('hasInvalidFilters экспортируется', () => {
		expect(source).toMatch(/hasInvalidFilters,/);
	});
});

test.describe('7e: подстраницы клиник не индексируют дубли', () => {
	const subpages = ['services', 'labtests', 'medications', 'doctors'].map(
		(name) => ({
			name,
			path: resolve(PAGES, 'clinics/[clinicSlug]', name, 'index.vue'),
		}),
	);

	for (const { name, path } of subpages) {
		test(`${name}: robotsMeta учитывает hasRedundantQuery`, () => {
			const source = read(path);
			// Именно в robots, а не в isFiltered: последний управляет счётчиком
			// и пропом дочернего компонента, сортировка не должна менять UI.
			expect(source).toMatch(
				/robotsMeta\s*=\s*computed\([\s\S]{0,200}hasRedundantQuery/,
			);
		});
	}

	test('hasRedundantQuery закрывает sort, мусорный category и page=1', () => {
		const source = read(resolve(ROOT, 'composables/use-clinic-items-route.ts'));
		expect(source).toContain("raw('sort')");
		expect(source).toContain("raw('category')");
		expect(source).toContain("raw('page')");
	});
});
