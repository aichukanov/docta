/**
 * Bing SEO Best Practices требует title короче 70 символов: длиннее он
 * обрезается или игнорируется в выдаче. Замер 2026-08-03 показал, что порог
 * пробивает половина карточек услуг (максимум — 132 символа), часть анализов и
 * клиник. Причина везде одна: шаблон склеивает название, категорию и город без
 * учёта длины.
 */
export const SEO_TITLE_MAX_LENGTH = 70;

/**
 * Возвращает первый вариант заголовка, влезающий в лимит.
 *
 * `variants` идут от самого полного к самому короткому — последний вариант это
 * дно (обычно голое название сущности) и отдаётся даже если он длиннее лимита.
 * Обрезать медицинское название по символам нельзя: «Ureteropijelografija
 * retrogradna bilateralna kod muškaraca ili…» хуже честного длинного, а первые
 * 70 символов у него всё равно те же.
 *
 * Порядок отбрасывания — решение страницы, а не этой функции: у карточки услуги
 * первым уходит категория, а не город, потому что интент локальный.
 */
export function fitSeoTitle(
	variants: (string | false | null | undefined)[],
	limit = SEO_TITLE_MAX_LENGTH,
): string {
	const candidates = variants
		.map((variant) => (variant ? variant.trim() : ''))
		.filter((variant): variant is string => Boolean(variant));

	if (candidates.length === 0) {
		return '';
	}

	return (
		candidates.find((variant) => variant.length <= limit) ??
		candidates[candidates.length - 1]
	);
}

/**
 * Сколько городов перечисляем в description по именам. Дальше список сворачивается
 * в «в Черногории»: место в сниппете дороже отдать цене, а хвост перечисления в
 * выдаче всё равно обрежется. Полоса авто-фактов на самой странице держит свой
 * порог (там города — отдельная колонка, а не часть предложения).
 */
export const MAX_CITIES_IN_DESCRIPTION = 4;

/** Минимальный контракт `t` из vue-i18n: только то, что нужно сегментам ниже. */
type Translate = (key: string, named: Record<string, unknown>) => string;

/**
 * Сегмент с ценой для description карточки услуги, анализа или лекарства.
 * Формулировки одни и те же во всех трёх разделах, поэтому логика выбора ключа
 * живёт здесь, а не в трёх страницах.
 *
 * Семантика полей — из common/entity-auto-facts.ts: `priceMax === null` означает
 * «все цены вида от X», и диапазон в этом случае показывать нельзя.
 */
export function buildSeoPriceSegment(
	facts: {
		priceMin: number | null;
		priceMax: number | null;
		priceAvg: number | null;
	} | null,
	t: Translate,
	formatPrice: (value: number) => string,
): string | null {
	if (!facts || facts.priceMin == null) {
		return null;
	}

	const min = formatPrice(facts.priceMin);

	if (facts.priceMax == null || facts.priceMax <= facts.priceMin) {
		return t('SeoDescPriceFromValue', { min });
	}

	const max = formatPrice(facts.priceMax);

	return facts.priceAvg == null
		? t('SeoDescPriceRange', { min, max })
		: t('SeoDescPriceRangeAvg', {
				min,
				max,
				avg: formatPrice(facts.priceAvg),
			});
}

/**
 * Bing SEO Best Practices просит description 150–160 символов; замер прода
 * 2026-08-03 — 68 карточек из 72 короче 150, типичная длина 50–110. Потолок
 * берём с запасом на предложение: Google обрезает сниппет около 160 символов,
 * а платить за перебор нечем — обрезанный хвост просто не показывается.
 */
export const SEO_DESCRIPTION_MAX_LENGTH = 165;

/**
 * Собирает description из фактов-предложений, пока влезает в лимит.
 *
 * Дописывать «воды» ради длины нельзя — цель не 160 символов, а факты, которые
 * у нас есть в БД (города, вилка цен, рейтинг). Поэтому у карточки без цен и
 * отзывов description честно останется коротким.
 *
 * Первый сегмент — суть страницы, он идёт всегда, даже если один длиннее
 * лимита. Дальше сегменты добавляются по порядку приоритета, и слишком длинный
 * пропускается: короткий призыв в конце влезет там, где не влез длинный
 * прайсовый сегмент.
 */
export function buildSeoDescription(
	segments: (string | false | null | undefined)[],
	limit = SEO_DESCRIPTION_MAX_LENGTH,
): string {
	const parts = segments
		.map((segment) => (segment ? segment.trim().replace(/\.$/, '') : ''))
		.filter((segment): segment is string => Boolean(segment));

	if (parts.length === 0) {
		return '';
	}

	let result = parts[0];
	for (const part of parts.slice(1)) {
		const next = `${result}. ${part}`;
		if (next.length + 1 <= limit) {
			result = next;
		}
	}

	return `${result}.`;
}
