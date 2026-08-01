import { test, expect } from '@playwright/test';
import { isBotUserAgent } from '../../server/utils/bot-user-agent';

// Пункт 13 в docs/audit/seo-2026-07.md.
//
// Цена ошибки несимметрична: не опознанный бот стоит одного запроса к ipapi,
// а ложное срабатывание молча выключает геолокацию живому пользователю — и
// заметить это по продукту нельзя, эндпоинт и так умеет возвращать null.
// Поэтому список живых UA здесь длиннее списка ботов.

const REAL_BROWSERS = [
	// Chrome, Windows
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
	// Safari, iPhone
	'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1',
	// Firefox
	'Mozilla/5.0 (X11; Linux x86_64; rv:127.0) Gecko/20100101 Firefox/127.0',
	// Яндекс.Браузер — «yandex» в UA есть, но это живой человек
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 YaBrowser/24.6.0.0 Safari/537.36',
	'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 YandexBrowser/24.6.0.0 Mobile Safari/537.36',
	// Samsung Internet, Edge
	'Mozilla/5.0 (Linux; Android 14; SM-S918B) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/25.0 Chrome/121.0.0.0 Mobile Safari/537.36',
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36 Edg/126.0.0.0',
	// Telegram in-app WebView — важный для нас канал
	'Mozilla/5.0 (iPhone; CPU iPhone OS 17_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Telegram-iOS/10.14',
];

const CRAWLERS = [
	'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
	'Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)',
	'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)',
	'Mozilla/5.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)',
	'Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)',
	'Mozilla/5.0 (compatible; SemrushBot/7~bl; +http://www.semrush.com/bot.html)',
	'Mozilla/5.0 (compatible; PetalBot;+https://webmaster.petalsearch.com/site/petalbot)',
	'Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)',
	'Mozilla/5.0 (compatible; DotBot/1.2; +https://opensiteexplorer.org/dotbot)',
	'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)',
	'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/126.0.0.0 Safari/537.36',
	'Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; ClaudeBot/1.0; +claudebot@anthropic.com)',
];

test('живые браузеры не считаются ботами', () => {
	for (const ua of REAL_BROWSERS) {
		expect(isBotUserAgent(ua), ua).toBe(false);
	}
});

test('краулеры опознаются', () => {
	for (const ua of CRAWLERS) {
		expect(isBotUserAgent(ua), ua).toBe(true);
	}
});

test('пустой User-Agent ботом не считается', () => {
	// Пустой UA бывает и у людей (приватные сборки, прокси). Ошибиться в эту
	// сторону дешевле: лишний запрос к ipapi против выключенной геолокации.
	expect(isBotUserAgent('')).toBe(false);
	expect(isBotUserAgent(undefined)).toBe(false);
	expect(isBotUserAgent(null)).toBe(false);
});
