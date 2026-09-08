import { test, expect } from '@playwright/test';
import { URLS } from '../utils/constants';
import { visit, waitForHydration } from '../utils/http';

// Глобальный поиск в героблоке главной.
//
// Почему это критический сценарий именно для e2e: словари специальностей,
// категорий и городов (≈155 КБ) больше не приезжают статически — они грузятся
// динамическим импортом, когда человек собрался искать, и дебаунс ЖДЁТ эту
// загрузку перед первой фильтрацией. Сломается ожидание — `t()` вернёт сырой
// ключ вместо перевода, и в выдаче окажется `specialty_12` вместо
// «Кардиология». Ни typecheck, ни юнит-тесты этого не увидят: словари сами по
// себе целы, ломается только момент их появления.
//
// Вторая мина той же природы — гонка: `debouncedSearch.cancel()` отменяет лишь
// не начавшийся вызов, а начавшийся мог наполнить уже закрытый список.

const SEARCH_INPUT = '.global-search__input';
const DROPDOWN = '.global-search__dropdown';

/**
 * Признаки сырых ключей i18n в выдаче.
 *
 * Ключи справочников — snake_case с числовым хвостом (`specialty_12`,
 * `city_3`, `labtest_category_4`), ключи UI — CamelCase без пробелов
 * (`SpecialtyDoctors`, `MoreDoctors`). Настоящие подписи так не выглядят.
 */
const RAW_KEY_PATTERNS = [
	/\b(?:specialty|city|clinic_type|labtest_category|medical_service_category)_\d+\b/,
	/\b(?:SpecialtyDoctors|MoreDoctors|MoreClinics|Searching|NoResults)\b/,
];

/**
 * Ввод запроса и ожидание УСТОЙЧИВОГО состояния выдачи.
 *
 * Ждать исчезновения индикатора загрузки нельзя: между дебаунсом (300 мс),
 * догрузкой словарей и запросом к API он успевает пропасть и появиться снова,
 * и проверка ловит промежуточный кадр. Устойчивых состояний ровно два —
 * есть результаты либо явное «ничего не найдено», их и дожидаемся.
 */
async function search(page: any, query: string, lang = '') {
	await page.goto(`${URLS.HOME}${lang}`, { waitUntil: 'domcontentloaded' });

	// Монтирование приложения — необходимое условие, но не достаточное:
	// `__vue_app__` появляется на `app.mount()`, а Suspense главной резолвится
	// позже, и до этого ввод в поле меняет DOM мимо `v-model`.
	await waitForHydration(page);

	const input = page.locator(SEARCH_INPUT);
	const dropdown = page.locator(DROPDOWN);

	// Поэтому ждём не косвенный признак, а фактическую готовность: печатаем и
	// смотрим, открылась ли выдача. Если нет — поле ещё не живое, повторяем.
	// Ввод идемпотентен, а `fill('')` сбрасывает прошлую попытку, чтобы
	// watcher увидел смену значения, а не то же самое.
	await expect
		.poll(
			async () => {
				if (await dropdown.isVisible()) {
					return true;
				}

				await input.click(); // фокус запускает загрузку словарей
				await input.fill('');
				await input.fill(query);
				// Дебаунс 300 мс плюс запас на догрузку словарей.
				await page.waitForTimeout(1000);

				return await dropdown.isVisible();
			},
			{ timeout: 45000, message: 'поле поиска так и не стало интерактивным' },
		)
		.toBe(true);

	await expect
		.poll(
			async () =>
				(await dropdown.locator('a[href]').count()) > 0 ||
				(await dropdown.locator('.global-search__no-results').count()) > 0,
			{
				timeout: 45000,
				message: 'выдача так и не пришла в устойчивое состояние',
			},
		)
		.toBe(true);

	return dropdown;
}

test.describe('Глобальный поиск', () => {
	// Каждый тест здесь — реальный путь «фокус → догрузка словарей → дебаунс →
	// запрос к API → отрисовка», и на полном параллельном прогоне сервер занят
	// остальными тестами. В изоляции блок проходит стабильно, под нагрузкой
	// упирался в дефолтный таймаут; `slow` втрое поднимает бюджет, не пряча
	// настоящую поломку — она по-прежнему уронит тест.
	test.slow();

	test('выдача не содержит сырых ключей i18n', async ({ page }) => {
		const dropdown = await search(page, 'kardio');
		const text = (await dropdown.innerText()).trim();

		expect(text.length).toBeGreaterThan(0);

		for (const pattern of RAW_KEY_PATTERNS) {
			expect(text, `сырой ключ в выдаче: ${pattern}`).not.toMatch(pattern);
		}
	});

	test('находит специальности по локализованному названию', async ({
		page,
	}) => {
		const dropdown = await search(page, 'кардио', '?lang=ru');

		// Словарь специальностей — из динамического импорта: если он не доехал,
		// строка будет `specialty_N`, а не человеческое название.
		const text = await dropdown.innerText();
		expect(text).toMatch(/[а-яА-ЯёЁ]/);
		expect(text).not.toMatch(/specialty_\d+/);
	});

	test('переход по результату уводит на страницу сущности', async ({
		page,
	}) => {
		const dropdown = await search(page, 'kardio');

		const firstLink = dropdown.locator('a[href]').first();
		await expect(firstLink).toBeVisible();

		const href = await firstLink.getAttribute('href');
		await firstLink.click();
		// Без своего таймаута: ожидание должно жить в бюджете теста, который
		// `test.slow()` уже утроил под параллельную нагрузку.
		await page.waitForURL((url) => url.pathname !== URLS.HOME);

		expect(page.url()).toContain(new URL(href!, page.url()).pathname);
	});

	test('стирание запроса закрывает выдачу и не оставляет хвостов', async ({
		page,
	}) => {
		const dropdown = await search(page, 'kardio');
		await expect(dropdown).toBeVisible();

		// Гонка: отложенный вызов по длинному запросу мог прилететь уже после
		// того, как список закрыли, и снова его наполнить.
		await page.locator(SEARCH_INPUT).fill('k');

		// `toBeHidden`, а не `toHaveCount(0)`: выпадашка обёрнута в Transition,
		// и между «скрыта» и «удалена из DOM» есть кадр анимации.
		//
		// Таймаут щедрый и заданный явно: дефолтный `expect` в конфиге — 5 с, а
		// `test.slow()` его НЕ масштабирует (утраивается только бюджет теста).
		// Именно на этом здесь и ловилась флака под параллельной нагрузкой.
		await expect(page.locator(DROPDOWN)).toBeHidden({ timeout: 30000 });

		// Отложенный вызов по прошлому, более длинному запросу приходит позже
		// закрытия — ждём дольше дебаунса и убеждаемся, что список не всплыл.
		await page.waitForTimeout(1500);
		await expect(page.locator(DROPDOWN)).toBeHidden();
	});

	test('страница внутреннего поиска закрыта от индексации', async ({
		page,
	}) => {
		// Кнопка «ещё» в выдаче ведёт на листинг с `?name=`. Ходить по таким
		// ссылкам краулеру можно, индексировать — нет: значение произвольное,
		// то есть поверхность дублей неограниченная.
		const res = await visit(page, `${URLS.DOCTORS}?name=ivan`);

		expect(res.status).toBe(200);

		const robots = await page
			.locator('meta[name="robots"]')
			.getAttribute('content');

		expect(robots).toContain('noindex');
		expect(robots).toContain('follow');
	});
});
