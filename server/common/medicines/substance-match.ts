// Сопоставление МНОЖЕСТВ действующих веществ другого продукта (аналог ЧГ или
// зарубежный бренд) против состава текущей карточки. Единая логика для бейджей
// «совпало / лишнее / отсутствует» и полного совпадения. DRY: и аналоги, и
// foreign-блок используют это.
import type { MedicineForeignSubstance } from '~/interfaces/medicine';

export interface SubstanceSetMatch {
	// matched-вещества идут первыми, затем extra (лишние)
	substances: MedicineForeignSubstance[];
	// вещества карточки, которых нет в продукте (перечёркнутые бейджи)
	missing: string[];
	matchedCount: number;
	// количество лишних веществ (есть у продукта, нет у карточки)
	extraCount: number;
	// наборы веществ полностью совпадают
	fullMatch: boolean;
}

export function matchSubstanceSet(
	pageIdSet: Set<number>,
	pageNameById: Map<number, string>,
	items: { id: number; name: string }[],
): SubstanceSetMatch {
	const matched = items.filter((x) => pageIdSet.has(x.id));
	const extra = items.filter((x) => !pageIdSet.has(x.id));
	const itemIds = new Set(items.map((x) => x.id));
	const missing = [...pageIdSet]
		.filter((id) => !itemIds.has(id))
		.map((id) => pageNameById.get(id))
		.filter((n): n is string => !!n);
	return {
		substances: [
			...matched.map((x) => ({ name: x.name, state: 'matched' as const })),
			...extra.map((x) => ({ name: x.name, state: 'extra' as const })),
		],
		missing,
		matchedCount: matched.length,
		extraCount: extra.length,
		fullMatch: matched.length === pageIdSet.size && extra.length === 0,
	};
}
