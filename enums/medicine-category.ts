/**
 * Потребительские категории лекарств — то, как человек ищет лекарство
 * («обезболивающие», «аллергия», «витамины»), в отличие от 14 официальных
 * ATC-групп («Respiratory system»), по которым непонятно, что внутри.
 *
 * Категория — это НАБОР ПРЕФИКСОВ ATC, а не отдельные данные: в реестре у
 * каждого лекарства уже есть `atc_code`, и `atc_code LIKE 'R06%'` идёт по
 * индексу. Поэтому категории не требуют ни миграции, ни пересчёта при
 * рескрейпе реестра.
 *
 * Единственный ручной вход — карта ниже (как 14 весов ATC-групп в миграции
 * 023-medicine-rank-score.sql). Правится без пересборки данных.
 *
 * Категории НЕ взаимоисключающие: глазные противоаллергические капли (S01G)
 * попадают и в «Аллергию», и в «Глаза и уши» — это ожидаемо, человек ищет их
 * и так, и так.
 *
 * ID стабильны и не переиспользуются: значения уходят в URL фасетов и в
 * sitemap, а снятому значению нужен 301, а не молчаливая подмена смысла.
 */
export enum MedicineCategory {
	PAIN = 1,
	ALLERGY = 2,
	COLD = 3,
	ASTHMA = 4,
	DIGESTION = 5,
	VITAMINS = 6,
	INFECTIONS = 7,
	VACCINES = 8,
	HEART = 9,
	BLOOD = 10,
	NERVOUS = 11,
	SKIN = 12,
	EYES_EARS = 13,
	DIABETES = 14,
	HORMONES = 15,
	UROGENITAL = 16,
	BONES = 17,
	ONCOLOGY = 18,
	NOSE = 19,
	COUGH = 20,
	THROAT = 21,
}

/**
 * Префиксы ATC на категорию. Уровень префикса выбран по смыслу, а не
 * единообразно: `R01A` целиком в одну категорию не годится — сосудосуживающие
 * капли (R01AA/R01AB) это простуда, а R01AC/R01AD — аллергия.
 *
 * Не покрыты сознательно: B05 (инфузионные растворы), V03/V07/V08 (диагностика,
 * контрасты, вспомогательное), N01 (анестетики), A08, A16 — это стационарный и
 * диагностический ассортимент, который обычный человек в каталоге не фильтрует.
 * Такие лекарства остаются в общем списке и находятся поиском.
 */
export const MEDICINE_CATEGORY_ATC: Record<MedicineCategory, string[]> = {
	[MedicineCategory.PAIN]: ['N02', 'M01', 'M02'],
	[MedicineCategory.ALLERGY]: ['R06', 'R01AC', 'R01AD', 'S01G', 'D04'],
	// Зонтик: комбинированные противопростудные (колдрексы, N02BE5) плюс всё,
	// что относится к симптомам простуды. Пересекается со своими «детьми»
	// (NOSE/COUGH/THROAT) намеренно: у аптек это дерево из двух уровней, у нас
	// фильтр плоский, и человек кликает либо зонтик, либо конкретный симптом.
	[MedicineCategory.COLD]: [
		'N02BE5',
		'R05',
		'R02',
		'R01AA',
		'R01AB',
		'A01',
	],
	[MedicineCategory.NOSE]: ['R01AA', 'R01AB'],
	[MedicineCategory.COUGH]: ['R05'],
	[MedicineCategory.THROAT]: ['R02', 'A01'],
	[MedicineCategory.ASTHMA]: ['R03'],
	[MedicineCategory.DIGESTION]: [
		'A02',
		'A03',
		'A04',
		'A05',
		'A06',
		'A07',
		'A09',
	],
	[MedicineCategory.VITAMINS]: ['A11', 'A12'],
	[MedicineCategory.INFECTIONS]: ['J01', 'J02', 'J04', 'J05', 'P01', 'P02'],
	[MedicineCategory.VACCINES]: ['J06', 'J07'],
	[MedicineCategory.HEART]: [
		'C01',
		'C02',
		'C03',
		'C05',
		'C07',
		'C08',
		'C09',
		'C10',
	],
	[MedicineCategory.BLOOD]: ['B01', 'B02', 'B03', 'B06'],
	[MedicineCategory.NERVOUS]: ['N03', 'N04', 'N05', 'N06', 'N07'],
	[MedicineCategory.SKIN]: [
		'D01',
		'D03',
		'D06',
		'D07',
		'D08',
		'D10',
		'D11',
	],
	[MedicineCategory.EYES_EARS]: ['S01', 'S02', 'S03'],
	[MedicineCategory.DIABETES]: ['A10'],
	[MedicineCategory.HORMONES]: ['H01', 'H02', 'H03', 'H04', 'H05'],
	[MedicineCategory.UROGENITAL]: ['G01', 'G02', 'G03', 'G04'],
	[MedicineCategory.BONES]: ['M03', 'M04', 'M05', 'M09'],
	[MedicineCategory.ONCOLOGY]: ['L01', 'L02', 'L03', 'L04'],
};

/**
 * Порядок показа в фильтре — от бытового к специализированному, а не по id и не
 * по алфавиту (в каждой локали он свой). «Простуда» идёт зонтиком, сразу за ней
 * её симптомные категории — так же, как второй уровень устроен у аптек.
 */
export const MEDICINE_CATEGORY_IDS: MedicineCategory[] = [
	MedicineCategory.PAIN,
	MedicineCategory.COLD,
	MedicineCategory.NOSE,
	MedicineCategory.COUGH,
	MedicineCategory.THROAT,
	MedicineCategory.ALLERGY,
	MedicineCategory.DIGESTION,
	MedicineCategory.VITAMINS,
	MedicineCategory.SKIN,
	MedicineCategory.EYES_EARS,
	MedicineCategory.INFECTIONS,
	MedicineCategory.ASTHMA,
	MedicineCategory.NERVOUS,
	MedicineCategory.HEART,
	MedicineCategory.DIABETES,
	MedicineCategory.UROGENITAL,
	MedicineCategory.HORMONES,
	MedicineCategory.BONES,
	MedicineCategory.BLOOD,
	MedicineCategory.VACCINES,
	MedicineCategory.ONCOLOGY,
];

export function isMedicineCategory(value: unknown): value is MedicineCategory {
	return (
		typeof value === 'number' &&
		MEDICINE_CATEGORY_IDS.includes(value as MedicineCategory)
	);
}

/** i18n-ключ названия категории (`i18n/medicine-category.ts`). */
export function getMedicineCategoryKey(id: MedicineCategory): string {
	return `MedCat${id}`;
}

/** Все префиксы выбранных категорий, без повторов. */
export function getMedicineCategoryAtcPrefixes(ids: number[]): string[] {
	const prefixes = new Set<string>();

	for (const id of ids) {
		if (!isMedicineCategory(id)) continue;
		for (const prefix of MEDICINE_CATEGORY_ATC[id]) {
			prefixes.add(prefix);
		}
	}

	return [...prefixes];
}
