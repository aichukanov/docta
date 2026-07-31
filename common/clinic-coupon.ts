import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	CLINIC_COUPON_PAYMENT_METHODS,
	CLINIC_COUPON_SCOPES,
	type ClinicCoupon,
	type ClinicCouponPaymentMethod,
	type ClinicCouponScope,
} from '~/interfaces/clinic-coupon';

/**
 * Таб купонов на странице клиники. `?tab=coupons` — конвенция таб-бара
 * (`entity-page/tab-bar.vue` читает параметр на монтировании и скроллит к
 * секции), а секция купонов по нему ещё и раскрывается сразу: любой внешний
 * вход по купонной ссылке — запрос показать купон, а не просто открыть клинику.
 * Параметр исключён из canonical (NON_CANONICAL_QUERY_KEYS), дублей URL нет.
 *
 * Один адрес на все входы: метка в карточке клиники, баннер на подстраницах
 * с ценами и ссылка в шеринге.
 */
export const COUPON_TAB_ID = 'coupons';

/** Router-локация таба купонов — для внутренних ссылок. */
export function getCouponTabRoute(clinicSlug: string, locale: string) {
	return {
		name: 'clinics-clinicSlug',
		params: { clinicSlug },
		query: { ...getRegionalQuery(locale), tab: COUPON_TAB_ID },
	};
}

/** Абсолютный адрес того же таба — для шеринга в Telegram и Facebook. */
export function getCouponTabUrl(
	clinicSlug: string,
	siteUrl: string,
	locale: string,
): string {
	return getRegionalUrl(
		`${siteUrl}/clinics/${clinicSlug}`,
		{ tab: COUPON_TAB_ID },
		locale,
	);
}

// Карточка клиники (ClinicSummary) рендерится одним компонентом на каталоге
// клиник, страницах врача, услуги, анализа и лекарства — и цена в ней всегда
// относится к сущности текущей страницы. Поэтому тип позиции берём из имени
// роута, а не прокидываем пропсом через пять компонентов-посредников.
const ROUTE_COUPON_SCOPES: Record<string, ClinicCouponScope> = {
	'services': 'services',
	'services-serviceSlug': 'services',
	'labtests': 'labtests',
	'labtests-labTestSlug': 'labtests',
	'medications': 'medications',
	'medications-medicationSlug': 'medications',
};

/**
 * Тип позиций, чьи цены показаны на странице. null — страница без цен
 * конкретного типа (каталог клиник, страница врача, главная).
 */
export function getCouponScopeByRoute(
	routeName: unknown,
): ClinicCouponScope | null {
	if (typeof routeName !== 'string') return null;
	return ROUTE_COUPON_SCOPES[routeName] ?? null;
}

/**
 * Показывать ли купон рядом с ценой. При null-scope (каталог, врач) —
 * показываем: конкретной цены со скидкой там нет, а условия пользователь
 * читает в баннере на странице клиники.
 */
export function isCouponApplicable(
	coupon: ClinicCoupon | null | undefined,
	scope: ClinicCouponScope | null,
): boolean {
	if (!coupon) return false;
	if (!scope) return true;
	return coupon.appliesTo.includes(scope);
}

const COUPON_SCOPE_KEYS: Record<ClinicCouponScope, string> = {
	services: 'CouponScopeServices',
	labtests: 'CouponScopeLabtests',
	medications: 'CouponScopeMedications',
};

/**
 * Ключи фрагментов «на что действует» (i18n/clinic-coupon.ts) в постоянном
 * порядке — услуги, анализы, лекарства — независимо от порядка в SET-колонке,
 * чтобы «услуги и анализы» не превращались местами в «анализы и услуги».
 */
export function getCouponScopeKeys(appliesTo: ClinicCouponScope[]): string[] {
	return CLINIC_COUPON_SCOPES.filter((scope) => appliesTo.includes(scope)).map(
		(scope) => COUPON_SCOPE_KEYS[scope],
	);
}

// Наши коды локалей → теги BCP-47 для Intl. Для сербского обязательно указывать
// скрипт: у тега `sr` ICU считает язык кириллическим и подставляет союз «и»,
// то есть в латинскую фразу попадала бы кириллица.
const INTL_TAGS: Record<string, string> = {
	'sr': 'sr-Latn',
	'sr-cyrl': 'sr-Cyrl',
};

/**
 * Перечисление типов позиций по правилам языка: «услуги и анализы», «услуги,
 * анализы и лекарства». Купон бывает сразу на несколько типов, а склеивать
 * запятыми на всех языках нельзя.
 */
export function formatCouponScopeList(names: string[], locale: string): string {
	if (names.length <= 1) return names[0] ?? '';
	try {
		return new Intl.ListFormat(INTL_TAGS[locale] || locale, {
			style: 'long',
			type: 'conjunction',
		}).format(names);
	} catch {
		// Неизвестный тег локали — перечисление важнее союза
		return names.join(', ');
	}
}

/**
 * Заголовок купона: «Скидка 10% на услуги и анализы». Собирается в одном месте —
 * его показывают чип (тултипом), баннер и диалог.
 */
export function buildCouponTitle(
	coupon: Pick<ClinicCoupon, 'appliesTo' | 'discountPercent'>,
	t: (key: string, params?: Record<string, unknown>) => string,
	locale: string,
): string {
	const names = getCouponScopeKeys(coupon.appliesTo).map((key) => t(key));
	return t('CouponTitle', {
		percent: coupon.discountPercent,
		scope: formatCouponScopeList(names, locale),
	});
}

/**
 * «на услуги и анализы» — часть заголовка без процента, для мест, где процент
 * уже стоит рядом в купонном чипе (заголовок таба «Купоны»).
 */
export function buildCouponScopePhrase(
	coupon: Pick<ClinicCoupon, 'appliesTo'>,
	t: (key: string, params?: Record<string, unknown>) => string,
	locale: string,
): string {
	const names = getCouponScopeKeys(coupon.appliesTo).map((key) => t(key));
	return t('CouponScopePhrase', {
		scope: formatCouponScopeList(names, locale),
	});
}

/**
 * Действует ли купон сегодня — те же три условия, что в SQL-выборке
 * (server/common/clinic-coupons.ts). Нужно админскому списку: он показывает
 * все купоны клиники, включая снятые и просроченные, и помечает их статус.
 */
export function isCouponCurrentlyActive(
	coupon: {
		isActive: boolean;
		validFrom: string | null;
		validUntil: string | null;
	},
	today = new Date().toISOString().slice(0, 10),
): boolean {
	if (!coupon.isActive) return false;
	if (coupon.validFrom && coupon.validFrom > today) return false;
	if (coupon.validUntil && coupon.validUntil < today) return false;
	return true;
}

/**
 * Адрес og-превью купона (`server/api/og/coupon.get.ts`) — то, что видно в
 * Telegram и Facebook вместо стандартной картинки сайта. null — картинки у
 * купона нет, превью остаётся дефолтным.
 *
 * `v` — версия файла: соцсети кэшируют превью по URL, а при замене картинки
 * меняется имя файла, значит меняется и адрес, и превью перечитывается.
 */
export function getCouponOgImageUrl(
	coupon: Pick<ClinicCoupon, 'id' | 'imageUrl'>,
	siteUrl: string,
): string | null {
	if (!coupon.imageUrl) return null;
	const fileName = coupon.imageUrl.split('/').pop() ?? '';
	const version = fileName.split('.')[0].slice(0, 8);
	return `${siteUrl}/api/og/coupon?couponId=${coupon.id}&v=${version}`;
}

/**
 * Ключ строки условия про оплату (i18n/clinic-coupon.ts) или null, если купон
 * действует при любой оплате и говорить не о чем.
 */
export function getCouponPaymentKey(
	paymentMethod: ClinicCouponPaymentMethod,
): string | null {
	if (paymentMethod === 'cash') return 'CouponPaymentCash';
	if (paymentMethod === 'card') return 'CouponPaymentCard';
	return null;
}

/**
 * Парсит ENUM `payment_method`. Неизвестное значение — 'any': обещать «только
 * наличные» без уверенности хуже, чем не сказать ничего (условие проверит касса).
 */
export function parseCouponPaymentMethod(
	value: unknown,
): ClinicCouponPaymentMethod {
	return (CLINIC_COUPON_PAYMENT_METHODS as readonly unknown[]).includes(value)
		? (value as ClinicCouponPaymentMethod)
		: 'any';
}

/** Парсит SET-колонку `applies_to`, отбрасывая неизвестные значения. */
export function parseCouponScopes(value: unknown): ClinicCouponScope[] {
	if (typeof value !== 'string' || !value) return [];
	return value
		.split(',')
		.map((scope) => scope.trim())
		.filter((scope): scope is ClinicCouponScope =>
			(CLINIC_COUPON_SCOPES as readonly string[]).includes(scope),
		);
}
