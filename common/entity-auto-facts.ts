import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

/**
 * Авто-факты для страницы услуги/анализа: цифры, которые уже есть в БД и
 * приезжают на клиент вместе с деталями сущности (клиники + их прайсы).
 * Отдельных запросов не делаем — считаем из того, что уже отрисовано.
 * См. docs/audit/seo-2026-07.md, пункт 4 плана.
 */
export interface EntityAutoFacts {
	/** Клиники из видимого (отфильтрованного по городу) списка */
	clinicCount: number;
	/** Города этих клиник, в порядке появления */
	cityIds: number[];
	/** Нижняя граница по всем прайсам; null — цен нет вообще */
	priceMin: number | null;
	/**
	 * Верхняя граница по прайсам с известным потолком. null означает, что
	 * потолка нет ни у одной записи (все цены вида «от X») — UI обязан
	 * показать «от {priceMin}», а не диапазон.
	 */
	priceMax: number | null;
	/** Средняя по клиникам с определённой ценой; null — их меньше порога */
	priceAvg: number | null;
	/** Сколько клиник вообще указали цену */
	pricedClinicCount: number;
}

/**
 * Меньше трёх цен — «средняя» вводит в заблуждение (это просто одна из них
 * или полусумма двух), поэтому ниже порога не показываем.
 */
const MIN_CLINICS_FOR_AVG = 3;

/**
 * Опции `n()` для цен в авто-фактах и FAQ. В отличие от прайс-листа клиник
 * (PricedItemCard) целые суммы показываем без «,00»: здесь цена — крупный
 * сводный показатель, и «13 € – 70 €» читается заметно легче, чем
 * «13,00 € – 70,00 €». Символ валюты форматирует Intl, поэтому позиция
 * (13 € / €13) остаётся правильной для каждой локали.
 */
export function priceFormatOptions(value: number) {
	const digits = Number.isInteger(value) ? 0 : 2;
	return {
		style: 'currency' as const,
		currency: 'EUR',
		minimumFractionDigits: digits,
		maximumFractionDigits: digits,
	};
}

export function computeEntityAutoFacts(
	clinics: ClinicData[],
	clinicPrices: ClinicPrice[] | undefined,
): EntityAutoFacts | null {
	if (!clinics.length) {
		return null;
	}

	const cityIds: number[] = [];
	for (const clinic of clinics) {
		if (!cityIds.includes(clinic.cityId)) {
			cityIds.push(clinic.cityId);
		}
	}

	// Прайсы приходят по полному набору клиник, а факты описывают видимый
	// список — иначе при фильтре по городу цифры разойдутся с карточками.
	const visibleClinicIds = new Set(clinics.map((clinic) => clinic.id));

	const lows: number[] = [];
	const highs: number[] = [];
	// Середины вилок — только у записей с известным потолком (см. ниже)
	const definiteMidpoints: number[] = [];

	for (const entry of clinicPrices ?? []) {
		if (!visibleClinicIds.has(entry.clinicId)) {
			continue;
		}

		// Семантика полей — та же, что в PricedItemCard: priceMin = «от X»
		// (потолок неизвестен и приоритетнее остальных полей), price+priceMax =
		// вилка, один price = точная цена.
		const isOpenEnded = entry.priceMin != null;
		const low = isOpenEnded ? entry.priceMin! : entry.price;
		if (low == null || low <= 0) {
			continue;
		}
		lows.push(low);

		if (isOpenEnded) {
			continue;
		}

		const high =
			entry.priceMax != null && entry.priceMax > low ? entry.priceMax : low;
		highs.push(high);
		definiteMidpoints.push((low + high) / 2);
	}

	const priceAvg =
		definiteMidpoints.length >= MIN_CLINICS_FOR_AVG
			? Math.round(
					definiteMidpoints.reduce((sum, value) => sum + value, 0) /
						definiteMidpoints.length,
				)
			: null;

	return {
		clinicCount: clinics.length,
		cityIds,
		priceMin: lows.length ? Math.min(...lows) : null,
		priceMax: highs.length ? Math.max(...highs) : null,
		priceAvg,
		pricedClinicCount: lows.length,
	};
}
