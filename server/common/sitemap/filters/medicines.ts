import { getConnection } from '~/server/common/db-mysql';
import { lastmodSql, toLastmod } from '~/server/common/sitemap/lastmod';
import { DispensingMode } from '~/enums/dispensing-mode';
import {
	MEDICINE_CATEGORY_IDS,
	getMedicineCategoryAtcPrefixes,
	type MedicineCategory,
} from '~/enums/medicine-category';

// Дата изменения фасета — максимум `updated_at` по лекарствам выборки, поэтому
// `DISTINCT` ниже заменён на `GROUP BY` с `MAX(...)`: набор строк тот же,
// добавилась агрегация.

export async function getSubstanceAtcCombinations(): Promise<
	Array<{ substanceId: string; atcGroupId: string; lastmod?: Date }>
> {
	const lastmod = await lastmodSql('med_medicines', 'MAX(m.updated_at)');
	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(
		`SELECT mms.substance_id as substanceId, m.atc_group_id as atcGroupId,
		 	${lastmod} as lastmod
		 FROM med_medicine_substances mms
		 INNER JOIN med_medicines m ON m.id = mms.medicine_id AND m.is_active = 1
		 WHERE m.atc_group_id IS NOT NULL
		 GROUP BY mms.substance_id, m.atc_group_id
		 ORDER BY mms.substance_id, m.atc_group_id`,
	);
	await connection.end();
	return rows.map((r) => ({
		substanceId: String(r.substanceId),
		atcGroupId: String(r.atcGroupId),
		lastmod: toLastmod(r.lastmod),
	}));
}

export interface MedicineCategoryFacet {
	categoryId: MedicineCategory;
	lastmod?: Date;
}

/**
 * Потребительские категории, за которыми реально что-то стоит — отдельно
 * целиком и отдельно в срезе «без рецепта».
 *
 * Декартово произведение категорий на режим отпуска строилось вслепую: из 21
 * пары `?medicineCategoryIds=N&dispensingModeIds=2` семь пустые (вакцины,
 * онкология, гормоны, антибиотики, астма, диабет, кости — рецептурные по
 * своей природе), а листинг на пустой выборке отдаёт `noindex, follow`.
 * Sitemap звал бота ровно туда, откуда страница его выгоняет.
 *
 * Проверяем не SQL-выражением на категорию, а выгрузкой различающихся пар
 * (ATC-код, режим отпуска) с последующим матчем через
 * `getMedicineCategoryAtcPrefixes`. Так критерий непустоты — ТА ЖЕ функция,
 * которой пользуется листинг (server/api/medicines/list.ts), и правка карты
 * префиксов не может разъехаться с sitemap. Строк тут порядка числа активных
 * лекарств (~2,5 тыс.), выгрузка дешёвая.
 */
export async function getMedicineCategoryFacets(): Promise<{
	categoryIds: MedicineCategoryFacet[];
	otcCategoryIds: MedicineCategoryFacet[];
}> {
	const lastmod = await lastmodSql('med_medicines', 'MAX(m.updated_at)');

	const sql = `
		SELECT m.atc_code as atcCode, m.dispensing_mode_id as dispensingModeId,
			${lastmod} as lastmod
		FROM med_medicines m
		WHERE m.is_active = 1 AND m.atc_code IS NOT NULL AND m.atc_code != ''
		GROUP BY m.atc_code, m.dispensing_mode_id
	`;

	const connection = await getConnection();
	const [rows] = await connection.execute<any[]>(sql);
	await connection.end();

	const codes = (
		rows as Array<{
			atcCode: string;
			dispensingModeId: number | null;
			lastmod: unknown;
		}>
	).map((row) => ({
		// LIKE в листинге сравнивает без учёта регистра (collation _ci),
		// startsWith — с учётом, поэтому приводим сами.
		atcCode: String(row.atcCode).toUpperCase(),
		dispensingModeId: Number(row.dispensingModeId),
		lastmod: toLastmod(row.lastmod),
	}));

	// Максимум по строкам среза: категория «устарела» тогда же, когда последнее
	// из вошедших в неё лекарств. Считаем в JS, потому что и сама принадлежность
	// к категории считается тут же — по префиксам ATC, той же функцией, что и в
	// листинге.
	const maxLastmod = (rows: Array<{ lastmod?: Date }>): Date | undefined =>
		rows.reduce<Date | undefined>(
			(max, row) =>
				row.lastmod && (!max || row.lastmod > max) ? row.lastmod : max,
			undefined,
		);

	const categoryIds: MedicineCategoryFacet[] = [];
	const otcCategoryIds: MedicineCategoryFacet[] = [];

	for (const categoryId of MEDICINE_CATEGORY_IDS) {
		const prefixes = getMedicineCategoryAtcPrefixes([categoryId]);
		const matches = codes.filter((row) =>
			prefixes.some((prefix) => row.atcCode.startsWith(prefix)),
		);

		if (matches.length > 0) {
			categoryIds.push({ categoryId, lastmod: maxLastmod(matches) });
		}

		const otcMatches = matches.filter(
			(row) => row.dispensingModeId === DispensingMode.OTC,
		);
		if (otcMatches.length > 0) {
			otcCategoryIds.push({ categoryId, lastmod: maxLastmod(otcMatches) });
		}
	}

	return { categoryIds, otcCategoryIds };
}

export async function getSitemapFilters() {
	// Одиночные ATC-фасеты в sitemap больше не публикуются — их место заняли
	// потребительские категории (sitemap.ts). Комбинации вещество×ATC остаются:
	// это уже проиндексированные и ранжирующиеся URL.
	return {
		...(await getMedicineCategoryFacets()),
		substanceAtcCombinations: await getSubstanceAtcCombinations(),
	};
}
