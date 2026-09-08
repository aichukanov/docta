import { test, expect } from '@playwright/test';
import {
	getPrivateCacheControl,
	PRIVATE_CACHE_CONTROL,
} from '~/server/common/private-cache';

// Единственная развилка всего кэша HTML: попадёт ответ в общий кэш или нет.
//
// Ошибка в сторону «слишком часто снимаем» стоит потерянного кэша, то есть
// денег за CPU. Ошибка в другую сторону — чужие имя, email и `is_admin` из
// payload на общем кэше Cloudflare. Поэтому проверка тут подробнее, чем
// кажется нужным по размеру функции.

test.describe('без cookie сессии не трогаем ничего', () => {
	const untouched = [
		'public, max-age=0, s-maxage=600, stale-while-revalidate=86400',
		'max-age=31536000, public, immutable',
		undefined,
	];

	for (const value of untouched) {
		test(`${value ?? 'без заголовка'}`, () => {
			expect(getPrivateCacheControl(value, false)).toBeNull();
		});
	}
});

test.describe('с cookie сессии снимаем только кэш страниц', () => {
	test('страница из routeRules', () => {
		expect(
			getPrivateCacheControl(
				'public, max-age=0, s-maxage=600, stale-while-revalidate=86400',
				true,
			),
		).toBe(PRIVATE_CACHE_CONTROL);
	});

	test('статика остаётся immutable: иначе вошедший качает иконки заново', () => {
		expect(
			getPrivateCacheControl('max-age=31536000, public, immutable', true),
		).toBeNull();
	});

	test('ответ без Cache-Control не трогаем: кабинет и API и так не кэшируются', () => {
		expect(getPrivateCacheControl(undefined, true)).toBeNull();
		expect(getPrivateCacheControl('', true)).toBeNull();
	});

	test('заголовок массивом — h3 отдаёт и так', () => {
		expect(getPrivateCacheControl(['public', 's-maxage=600'], true)).toBe(
			PRIVATE_CACHE_CONTROL,
		);
	});
});

test('замена запрещает и общий кэш, и промежуточные прокси', () => {
	// `private` отсекает CDN и корпоративные прокси, `no-store` — ещё и диск
	// браузера на общей машине. Для страницы с чужой сессией это уместно:
	// она всё равно перерисовывается за один запрос.
	expect(PRIVATE_CACHE_CONTROL).toContain('private');
	expect(PRIVATE_CACHE_CONTROL).toContain('no-store');
	expect(PRIVATE_CACHE_CONTROL).not.toContain('s-maxage');
});
