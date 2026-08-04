import { test, expect } from '@playwright/test';
import { ListingPage } from '../pages/listing.page';
import { LISTING_SECTIONS, detailUrlPattern } from '../utils/sections';

// Регресс: переход из листинга в карточку зависал — URL менялся, а на экране
// оставался листинг. Исключение в размонтировании старой страницы обрывало
// переход, и новая не монтировалась. Подробности и причина —
// tests/unit/vue-teleport-unmount.spec.ts.
//
// Условие проявления: Teleport'ы карты рождаются внутри окна перехода, то есть
// Leaflet догружается с CDN уже ПОСЛЕ клика по карточке. Тест это условие
// создаёт руками: тормозит CDN и details-API. На прод-сборке до фикса падало
// 6 из 6, поэтому тест содержательный, а не «на всякий случай».

const SERVICES = LISTING_SECTIONS.find((s) => s.key === 'services')!;

test('переход в карточку доживает до конца, пока догружается карта', async ({
	page,
}) => {
	const pageErrors: string[] = [];
	page.on('pageerror', (error) => pageErrors.push(error.message));

	// Leaflet приезжает уже после клика — onMounted карты всё это время
	// висит на await, а затем создаёт Teleport'ы маркеров
	await page.route('**unpkg.com/leaflet**', async (route) => {
		await new Promise((resolve) => setTimeout(resolve, 3000));
		await route.continue();
	});
	// Медленный details-API держит pending-ветку Suspense открытой
	await page.route('**/api/services/details', async (route) => {
		await new Promise((resolve) => setTimeout(resolve, 6000));
		await route.continue();
	});

	const listing = new ListingPage(page, SERVICES);
	await listing.goto();
	await listing.waitForResultsReady();

	await listing.clickFirstItem();
	await page.waitForURL(detailUrlPattern('services'));

	// Главное: страница действительно отрисовалась, а не осталась листингом
	await expect(page.locator('.entity-page')).toBeVisible({ timeout: 30000 });
	await expect(page.locator('.entity-page__layout h1')).toBeVisible();

	expect(pageErrors, 'при переходе не должно быть исключений').toEqual([]);
});
