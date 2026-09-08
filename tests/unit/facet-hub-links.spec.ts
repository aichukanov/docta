import { test, expect } from '@playwright/test';
import { readFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Хабы перелинковки фасетов (components/*/related-filters.vue).
//
// Два требования тянут в разные стороны, и оба легко нарушить правкой в одном
// файле из четырёх:
//
// 1. С НЕфильтрованного листинга обязан быть вход в фасетную сеть. Пока хаб
//    показывался только при уже выбранном фасете, в него неоткуда было войти:
//    панель фильтров — чекбоксы, а не ссылки. Фасетные URL стояли в sitemap без
//    единой входящей HTML-ссылки (docs/audit/seo-2026-07.md, пункт 1b).
// 2. Ссылаться можно ТОЛЬКО на комбинации, которые есть в sitemap. Обратная
//    ошибка не менее дорогая: ссылка на комбинацию вне sitemap заводит
//    индексируемую поверхность, которую никто не планировал.
//
// Второе требование несимметрично по разделам, и это главная ловушка при
// копировании кода между четырьмя почти одинаковыми компонентами:
// `/clinics?cityIds=N` в sitemap ЕСТЬ (buildClinicFiltersSection), а
// `/doctors?cityIds=N`, `/services?cityIds=N` и `/labtests?cityIds=N` — НЕТ,
// там в sitemap только одиночная категория и пара «категория + город».

const HERE = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(HERE, '../..');

interface HubSpec {
	file: string;
	/** Имя фасета раздела в query-строке. */
	facetKey: string;
	/** Наборы query-ключей, которые разделу разрешено собирать в ссылку. */
	allowedQueries: string[][];
}

const HUBS: HubSpec[] = [
	{
		file: 'components/doctor/related-filters.vue',
		facetKey: 'specialtyIds',
		// Язык — второй парный фасет и только у врачей: в sitemap есть
		// `?specialtyIds=X&languageIds=L` (specialtyLanguageCombinations), но нет
		// ни одиночного `?languageIds=L`, ни тройки с городом.
		allowedQueries: [
			['specialtyIds'],
			['specialtyIds', 'cityIds'],
			['specialtyIds', 'languageIds'],
		],
	},
	{
		file: 'components/service/related-filters.vue',
		facetKey: 'serviceCategoryIds',
		allowedQueries: [['serviceCategoryIds'], ['serviceCategoryIds', 'cityIds']],
	},
	{
		file: 'components/lab-test/related-filters.vue',
		facetKey: 'categoryIds',
		allowedQueries: [['categoryIds'], ['categoryIds', 'cityIds']],
	},
	{
		file: 'components/clinic/related-filters.vue',
		facetKey: 'clinicTypeIds',
		// Единственный раздел, где город — самостоятельный URL в sitemap.
		allowedQueries: [
			['clinicTypeIds'],
			['cityIds'],
			['clinicTypeIds', 'cityIds'],
		],
	},
];

/**
 * Наборы query-ключей всех ссылок, которые собирает компонент.
 *
 * Ссылки строятся объектными литералами `query: { ...getRegionalQuery(locale),
 * facetIds: String(id) }`, поэтому достаточно вырезать каждый такой литерал и
 * собрать имена ключей со `String(`. `getRegionalQuery` даёт только `lang` и на
 * состав фасета не влияет.
 */
function queryShapes(source: string): string[][] {
	const shapes: string[][] = [];
	const re = /query:\s*\{([\s\S]*?)\n\t\},/g;
	let match: RegExpExecArray | null;
	while ((match = re.exec(source)) !== null) {
		const keys = [...match[1].matchAll(/(\w+):\s*String\(/g)].map((m) => m[1]);
		if (keys.length) shapes.push(keys);
	}
	return shapes;
}

for (const hub of HUBS) {
	const source = readFileSync(resolve(ROOT, hub.file), 'utf-8');

	test.describe(hub.file, () => {
		test('нефильтрованный листинг тоже показывает хаб', () => {
			// Признак режима «ничего не выбрано»: без него блок снова станет
			// достижим только с уже отфильтрованной страницы, то есть ниоткуда.
			expect(source).toContain('isUnfiltered');
			expect(source).toMatch(/const hasHub = computed\(/);
			expect(source).toMatch(/top[A-Z]\w*\.value\.length > 0/);
		});

		test('есть ссылка на одиночный фасет без города', () => {
			// Она же вход на `?<facet>=N` с парной страницы: без неё одиночные
			// фасеты вне топа остаются без единой входящей ссылки.
			expect(queryShapes(source)).toContainEqual([hub.facetKey]);
		});

		test('разобраны все сборщики ссылок, а не часть', () => {
			// Проверки ниже смотрят на вырезанные `query: {...}`. Если ссылку
			// соберут иначе и регулярка её не поймает, тест станет пустым и
			// перестанет что-либо стеречь — поэтому сверяем счётчики.
			const builders = (source.match(/\n\tname: '/g) ?? []).length;
			expect(queryShapes(source).length).toBe(builders);
		});

		test('не собирает комбинаций за пределами sitemap', () => {
			const allowed = new Set(
				hub.allowedQueries.map((keys) => [...keys].sort().join('+')),
			);
			for (const shape of queryShapes(source)) {
				expect(
					allowed.has([...shape].sort().join('+')),
					`ссылка с query ${shape.join('+')} не описана в sitemap-генераторе`,
				).toBe(true);
			}
		});
	});
}

test('только /clinics ссылается на город отдельным URL', () => {
	// Прямая защита от копирования блока «города» в соседний хаб: у остальных
	// разделов такого URL в sitemap нет, и ссылка завела бы новую
	// индексируемую поверхность.
	for (const hub of HUBS) {
		const source = readFileSync(resolve(ROOT, hub.file), 'utf-8');
		const cityOnly = queryShapes(source).some(
			(shape) => shape.length === 1 && shape[0] === 'cityIds',
		);
		expect(cityOnly).toBe(hub.file.includes('components/clinic/'));
	}
});
