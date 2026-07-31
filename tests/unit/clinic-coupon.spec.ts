import { test, expect } from '@playwright/test';
import {
	buildCouponScopePhrase,
	buildCouponTitle,
	formatCouponScopeList,
	getCouponOgImageUrl,
	getCouponPaymentKey,
	getCouponTabRoute,
	getCouponTabUrl,
	getCouponScopeByRoute,
	getCouponScopeKeys,
	isCouponApplicable,
	isCouponCurrentlyActive,
	parseCouponPaymentMethod,
	parseCouponScopes,
} from '../../common/clinic-coupon';
import type { ClinicCoupon } from '../../interfaces/clinic-coupon';

// Купон Novi Standard действует на услуги и НЕ действует на анализы, которых
// у клиники 944. Карточка клиники рендерится одним компонентом на страницах
// услуг, анализов и лекарств, поэтому цена ошибки — обещание скидки там, где
// её нет.

const servicesCoupon: ClinicCoupon = {
	id: 1,
	discountPercent: 10,
	appliesTo: ['services'],
	paymentMethod: 'cash',
	sourceName: 'Montenegro Experte',
	imageUrl: null,
	code: null,
	validUntil: null,
};

test('scope страницы берётся из имени роута', () => {
	expect(getCouponScopeByRoute('services')).toBe('services');
	expect(getCouponScopeByRoute('services-serviceSlug')).toBe('services');
	expect(getCouponScopeByRoute('labtests-labTestSlug')).toBe('labtests');
	expect(getCouponScopeByRoute('medications')).toBe('medications');
	// Каталог клиник и страница врача — цен конкретного типа нет
	expect(getCouponScopeByRoute('clinics')).toBeNull();
	expect(getCouponScopeByRoute('doctors-doctorSlug')).toBeNull();
	expect(getCouponScopeByRoute(undefined)).toBeNull();
});

test('купон на услуги не показывается на страницах анализов и лекарств', () => {
	expect(isCouponApplicable(servicesCoupon, 'services')).toBe(true);
	expect(isCouponApplicable(servicesCoupon, 'labtests')).toBe(false);
	expect(isCouponApplicable(servicesCoupon, 'medications')).toBe(false);
	// Страница без цен конкретного типа: условия читаются в баннере клиники
	expect(isCouponApplicable(servicesCoupon, null)).toBe(true);
	expect(isCouponApplicable(null, null)).toBe(false);
	expect(isCouponApplicable(undefined, 'services')).toBe(false);
});

test('фрагменты «на что действует» — в постоянном порядке', () => {
	expect(getCouponScopeKeys(['services'])).toEqual(['CouponScopeServices']);
	expect(getCouponScopeKeys(['labtests'])).toEqual(['CouponScopeLabtests']);
	// Порядок в SET-колонке произвольный, в заголовке — всегда услуги первыми
	expect(getCouponScopeKeys(['labtests', 'services'])).toEqual([
		'CouponScopeServices',
		'CouponScopeLabtests',
	]);
	expect(getCouponScopeKeys(['medications', 'labtests', 'services'])).toEqual([
		'CouponScopeServices',
		'CouponScopeLabtests',
		'CouponScopeMedications',
	]);
	expect(getCouponScopeKeys([])).toEqual([]);
});

// Купон бывает и на услуги, и на анализы сразу — перечисление собирается по
// правилам языка, а не склейкой запятыми
test('перечисление типов позиций локализовано', () => {
	expect(formatCouponScopeList(['услуги'], 'ru')).toBe('услуги');
	expect(formatCouponScopeList(['услуги', 'анализы'], 'ru')).toBe(
		'услуги и анализы',
	);
	expect(formatCouponScopeList(['услуги', 'анализы', 'лекарства'], 'ru')).toBe(
		'услуги, анализы и лекарства',
	);
	expect(formatCouponScopeList(['services', 'lab tests'], 'en')).toBe(
		'services and lab tests',
	);
	// Сербская латиница: союз обязан быть латинским «i». У тега `sr` без скрипта
	// ICU отдаёт кириллическое «и» — отсюда карта INTL_TAGS
	expect(formatCouponScopeList(['usluge', 'analize'], 'sr')).toBe(
		'usluge i analize',
	);
	expect(formatCouponScopeList(['услуге', 'анализе'], 'sr-cyrl')).toBe(
		'услуге и анализе',
	);
	expect(formatCouponScopeList([], 'ru')).toBe('');
});

test('заголовок купона собирается из процента и типов позиций', () => {
	// Вместо словаря переводов — сам ключ, проверяем сборку, а не тексты
	const t = (key: string, params?: Record<string, unknown>) =>
		params ? `${key}(${JSON.stringify(params)})` : key;

	expect(
		buildCouponTitle({ appliesTo: ['services'], discountPercent: 10 }, t, 'ru'),
	).toBe('CouponTitle({"percent":10,"scope":"CouponScopeServices"})');

	expect(
		buildCouponTitle(
			{ appliesTo: ['services', 'labtests'], discountPercent: 10 },
			t,
			'ru',
		),
	).toBe(
		'CouponTitle({"percent":10,"scope":"CouponScopeServices и CouponScopeLabtests"})',
	);
});

// В заголовке таба процент стоит в купонном чипе, поэтому рядом идёт фраза без
// процента — иначе скидка называлась бы дважды
test('фраза «на что действует» — без процента', () => {
	const t = (key: string, params?: Record<string, unknown>) =>
		params ? `${key}(${JSON.stringify(params)})` : key;

	expect(buildCouponScopePhrase({ appliesTo: ['services'] }, t, 'ru')).toBe(
		'CouponScopePhrase({"scope":"CouponScopeServices"})',
	);
	expect(
		buildCouponScopePhrase({ appliesTo: ['services', 'labtests'] }, t, 'ru'),
	).toBe(
		'CouponScopePhrase({"scope":"CouponScopeServices и CouponScopeLabtests"})',
	);
});

// Админский список показывает и снятые, и просроченные купоны — статус в нём
// считается на клиенте и обязан совпадать с SQL-условием публичной выборки
// (server/common/clinic-coupons.ts)
test('статус купона: флаг и обе даты', () => {
	const today = '2026-07-30';
	const base = { isActive: true, validFrom: null, validUntil: null };

	expect(isCouponCurrentlyActive(base, today)).toBe(true);
	expect(isCouponCurrentlyActive({ ...base, isActive: false }, today)).toBe(
		false,
	);
	// Ещё не начался
	expect(
		isCouponCurrentlyActive({ ...base, validFrom: '2026-08-01' }, today),
	).toBe(false);
	// Начался вчера, бессрочный
	expect(
		isCouponCurrentlyActive({ ...base, validFrom: '2026-07-29' }, today),
	).toBe(true);
	// Последний день действия — ещё активен
	expect(isCouponCurrentlyActive({ ...base, validUntil: today }, today)).toBe(
		true,
	);
	expect(
		isCouponCurrentlyActive({ ...base, validUntil: '2026-07-29' }, today),
	).toBe(false);
});

// Условие оплаты нельзя ни потерять, ни выдумать: «только наличными» — повод
// развернуться на кассе, а ложное «только наличными» — повод не прийти
test('способ оплаты: строка условия и парсинг ENUM', () => {
	expect(getCouponPaymentKey('cash')).toBe('CouponPaymentCash');
	expect(getCouponPaymentKey('card')).toBe('CouponPaymentCard');
	// При любой оплате говорить не о чем — строки в условиях нет
	expect(getCouponPaymentKey('any')).toBeNull();

	expect(parseCouponPaymentMethod('cash')).toBe('cash');
	expect(parseCouponPaymentMethod('card')).toBe('card');
	expect(parseCouponPaymentMethod('any')).toBe('any');
	// Неизвестное значение — 'any', а не выдуманное ограничение
	expect(parseCouponPaymentMethod('bitcoin')).toBe('any');
	expect(parseCouponPaymentMethod(null)).toBe('any');
	expect(parseCouponPaymentMethod(undefined)).toBe('any');
});

// Три входа в купон — метка в карточке, баннер на подстранице и расшаренная
// ссылка — обязаны вести на один адрес: по нему секция раскрывается сразу
test('адрес таба купонов: один для ссылок и шеринга', () => {
	expect(getCouponTabRoute('novi-standard-poliklinika', 'ru')).toEqual({
		name: 'clinics-clinicSlug',
		params: { clinicSlug: 'novi-standard-poliklinika' },
		query: { lang: 'ru', tab: 'coupons' },
	});

	const url = getCouponTabUrl(
		'novi-standard-poliklinika',
		'https://docta.me',
		'ru',
	);
	expect(url).toContain('/clinics/novi-standard-poliklinika');
	expect(url).toContain('tab=coupons');
	expect(url).toContain('lang=ru');
});

// Telegram и Facebook кэшируют превью по URL — при замене картинки адрес
// обязан меняться, иначе в ленте останется старый купон
test('og-превью купона: адрес и версия файла', () => {
	expect(
		getCouponOgImageUrl(
			{ id: 7, imageUrl: '/uploads/coupons/9f3a1c2b-dead-beef.webp' },
			'https://docta.me',
		),
	).toBe('https://docta.me/api/og/coupon?couponId=7&v=9f3a1c2b');

	// Другой файл — другая версия, значит соцсети перечитают превью
	expect(
		getCouponOgImageUrl(
			{ id: 7, imageUrl: '/uploads/coupons/11111111-dead-beef.webp' },
			'https://docta.me',
		),
	).toContain('v=11111111');

	// Без картинки превью остаётся дефолтным
	expect(
		getCouponOgImageUrl({ id: 7, imageUrl: null }, 'https://docta.me'),
	).toBeNull();
});

test('SET-колонка applies_to парсится, мусор отбрасывается', () => {
	expect(parseCouponScopes('services')).toEqual(['services']);
	expect(parseCouponScopes('services,medications')).toEqual([
		'services',
		'medications',
	]);
	expect(parseCouponScopes('services,doctors')).toEqual(['services']);
	expect(parseCouponScopes('')).toEqual([]);
	expect(parseCouponScopes(null)).toEqual([]);
});
