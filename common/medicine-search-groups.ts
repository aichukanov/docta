// Группировка лекарств для выдачи поиска.
//
// В реестре CInMED одна запись = одна фасовка, поэтому «хлороп» возвращает два
// SYNOPEN (инъекции и мазь), а «euthyrox» — девять дозировок. В дропдауне это
// читалось как дубли и вытесняло остальные препараты. Здесь записи одного
// названия сводятся в одну строку, а различия (форма/дозировка/упаковка)
// выносятся в ярлыки-варианты под ней.
//
// Отдельной «зонтичной» страницы бренда нет и не нужно: её роль играет вкладка
// «Другие дозировки» на карточке любого варианта (см. analogSections в
// pages/medicines/[medicineSlug]/index.vue).
import { buildPackagingLabel } from '~/common/packaging-label';
import { localizeStrength } from '~/common/strength-label';
import { normalizeForSearch } from '~/common/utils';
import type { MedicineListItem, MedicineMatch } from '~/interfaces/medicine';

type TFn = (key: string) => string;

export interface MedicineVariant {
	item: MedicineListItem;
	/** Чем этот вариант отличается от остальных в группе. */
	label: string;
}

export interface MedicineGroup {
	key: string;
	name: string;
	/** Первый вариант — самый релевантный (порядок задаёт бэкенд). */
	primary: MedicineListItem;
	variants: MedicineVariant[];
	/** Форма, общая для всех вариантов группы (иначе null). */
	sharedForm: string | null;
	/** Производитель, общий для всех вариантов (иначе null). */
	sharedManufacturer: string | null;
	sharedCountry: string | null;
	/**
	 * Режим отпуска, общий для всех вариантов (иначе null). У SYNOPEN мазь
	 * безрецептурная, а инъекции — по рецепту: бейдж на строке бренда в таком
	 * случае был бы неправдой, поэтому его не показываем.
	 */
	sharedDispensingModeId: number | null;
}

/** Записи одного названия — в одну группу, порядок появления сохраняется. */
export function groupMedicines(
	items: MedicineListItem[],
	t: TFn,
	locale: string,
): MedicineGroup[] {
	const groups = new Map<string, MedicineListItem[]>();
	for (const item of items) {
		const key = normalizeForSearch(item.name).trim();
		const list = groups.get(key);
		if (list) {
			list.push(item);
		} else {
			groups.set(key, [item]);
		}
	}

	return [...groups.entries()].map(([key, list]) => {
		const shared = <T extends string | number>(
			pick: (item: MedicineListItem) => T | null,
		): T | null => {
			const first = pick(list[0]);
			return first != null && list.every((item) => pick(item) === first)
				? first
				: null;
		};
		const sharedForm = shared((item) => item.pharmaForm);

		return {
			key,
			name: list[0].name,
			primary: list[0],
			variants: buildVariantLabels(list, sharedForm, t, locale),
			sharedForm,
			sharedManufacturer: shared((item) => item.manufacturer),
			sharedCountry: shared((item) => item.country),
			sharedDispensingModeId: shared((item) => item.dispensingModeId),
		};
	});
}

/**
 * Ярлык варианта показывает ровно то, чем варианты различаются: у EUTHYROX это
 * дозировки при одной форме, у SYNOPEN — формы. Упаковка добавляется только
 * если без неё ярлыки не различаются (в реестре есть записи, отличающиеся
 * лишь числом таблеток).
 */
function buildVariantLabels(
	items: MedicineListItem[],
	sharedForm: string | null,
	t: TFn,
	locale: string,
): MedicineVariant[] {
	const base = items.map((item) =>
		[
			sharedForm ? null : item.pharmaForm,
			item.strength ? localizeStrength(item.strength, t) : null,
		]
			.filter(Boolean)
			.join(', '),
	);

	const needsPack =
		base.some((label) => !label) || new Set(base).size !== base.length;

	// Порядок ярлыков — по подписи с числовым сравнением: «25 мкг, 50 мкг,
	// 75 мкг» вместо порядка популярности, в котором дозировки выглядят
	// перемешанными. Строка бренда всё равно ведёт на самый популярный вариант.
	return items
		.map((item, index) => {
			const pack = needsPack ? buildPackagingLabel(item, t, locale, false) : '';
			const label = [base[index], pack].filter(Boolean).join(', ');
			return { item, label: label || item.name };
		})
		.sort((a, b) => a.label.localeCompare(b.label, locale, { numeric: true }));
}

/**
 * Подпись «почему это в выдаче» для лекарства: своё название совпало —
 * объяснять нечего; иначе называем зарубежный бренд. Совпадение по
 * действующему веществу подписи не требует: вещество и так есть в карточке,
 * там же подсвечивается совпадение (см. feedback о дублировании данных).
 *
 * Ярлыки — из i18n/search-match.ts, они нужны и дропдауну, и листингу.
 */
export function medicineMatchHint(
	match: MedicineMatch | undefined,
	t: TFn,
): { label: string; value: string } | null {
	if (!match || match.byName || !match.foreignBrands.length) return null;
	const fullMatches = match.foreignBrands.filter((brand) => brand.fullMatch);
	const brands = fullMatches.length ? fullMatches : match.foreignBrands;
	return {
		label: fullMatches.length ? t('MatchAnalog') : t('MatchSimilar'),
		value: brands.map((brand) => brand.brand).join(', '),
	};
}
