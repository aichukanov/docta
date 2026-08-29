/**
 * Фармакологический класс лекарства, выведенный из ATC level-2 (первые 3 символа
 * `med_medicines.atc_code`): `R06` → «антигистаминное», `H02` → «гормональное
 * (кортикостероид, стероид)», `M01` → «противовоспалительное (НПВС)».
 *
 * Зачем не писать класс руками для каждого из 752 веществ: ATC level-2 и есть
 * фармакологический смысл, а в реестре у активных лекарств встречается всего 78
 * таких кодов. 78 меток × 6 локалей покрывают весь реестр без отдельных данных
 * и без миграции — код уже лежит в `atc_code`.
 *
 * Класс относится к ЛЕКАРСТВУ, а не к веществу: у одного вещества в разных формах
 * разный ATC (`flutikazon` = R01AD спрей для носа + R03BA ингалятор + D07AC мазь).
 * Поэтому метка показывается на карточке лекарства, где ATC однозначен.
 *
 * Метки — в `i18n/atc-class.ts` (ключ `AtcClass<КОД>`), собираются скриптом
 * `scripts/medicines/build-atc-class-i18n.mjs` из `data/atc-class/*.json`.
 */

/**
 * Коды ATC level-2, для которых есть метка класса. Список фиксированный: это
 * классификация ВОЗ, а не наши данные. Появится новый код в реестре — метки не
 * будет, и бейдж просто не отрисуется (фолбэк — ATC-группа в блоке «Детали»).
 *
 * Сверяется с `data/atc-class/base.json` при сборке i18n — расхождение падает.
 */
export const ATC_CLASS_CODES: ReadonlySet<string> = new Set([
	'A01',
	'A02',
	'A03',
	'A04',
	'A05',
	'A06',
	'A07',
	'A08',
	'A09',
	'A10',
	'A11',
	'A12',
	'A16',
	'B01',
	'B02',
	'B03',
	'B05',
	'B06',
	'C01',
	'C02',
	'C03',
	'C05',
	'C07',
	'C08',
	'C09',
	'C10',
	'D01',
	'D03',
	'D04',
	'D06',
	'D07',
	'D08',
	'D10',
	'D11',
	'G01',
	'G02',
	'G03',
	'G04',
	'H01',
	'H02',
	'H03',
	'H04',
	'H05',
	'J01',
	'J02',
	'J04',
	'J05',
	'J06',
	'J07',
	'L01',
	'L02',
	'L03',
	'L04',
	'M01',
	'M02',
	'M03',
	'M04',
	'M05',
	'M09',
	'N01',
	'N02',
	'N03',
	'N04',
	'N05',
	'N06',
	'N07',
	'P01',
	'P02',
	'R01',
	'R02',
	'R03',
	'R05',
	'R06',
	'S01',
	'S02',
	'S03',
	'V03',
	'V07',
	'V08',
]);

/**
 * Код класса по полному ATC-коду лекарства: `R06AX26` → `R06`. `null`, если кода
 * нет или он не из классификации (в реестре есть мусорные значения вроде `1` и
 * гомеопатические `HN05CM`).
 *
 * Он же — значение фасета `?atcClassCodes=R06` («все антигистаминные»).
 */
export function getAtcClassCode(atcCode?: string | null): string | null {
	if (!atcCode) return null;

	const code = atcCode.trim().slice(0, 3).toUpperCase();

	return ATC_CLASS_CODES.has(code) ? code : null;
}

/** i18n-ключ метки класса (`R06` → `AtcClassR06`). */
export function getAtcClassKeyByCode(code: string): string {
	return `AtcClass${code}`;
}

/** i18n-ключ метки класса по полному ATC-коду лекарства (`R06AX26` → `AtcClassR06`). */
export function getAtcClassKey(atcCode?: string | null): string | null {
	const code = getAtcClassCode(atcCode);

	return code ? getAtcClassKeyByCode(code) : null;
}

export function isAtcClassCode(value: unknown): value is string {
	return typeof value === 'string' && ATC_CLASS_CODES.has(value.toUpperCase());
}
