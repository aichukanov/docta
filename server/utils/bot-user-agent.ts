/**
 * Грубый детект поисковых/технических краулеров по User-Agent.
 *
 * Нужен там, где запрос стоит денег или квоты, а боту результат не нужен:
 * первый случай — геолокация по IP через ipapi.co, где Googlebot и Baiduspider
 * выжигали бесплатный дневной лимит (docs/audit/server-logs-2026-07-30.md).
 *
 * НЕ использовать для скрытия контента или отдачи ботам другой разметки — это
 * клоакинг. Только для отказа от побочных внешних вызовов.
 *
 * Осторожно с подстроками: `yandex` встречается в UA Яндекс.Браузера
 * (`YaBrowser`… но и `YandexBrowser` у старых версий), поэтому он идёт с
 * negative lookahead. По той же причине здесь нет `safari`, `mobile` и прочих
 * слов, которые есть у обычных браузеров.
 */
const BOT_USER_AGENT_RE =
	/bot\b|bot\/|crawler|crawling|spider|slurp|bingpreview|facebookexternalhit|ia_archiver|headlesschrome|lighthouse|pingdom|semrush|ahrefs|mj12|dotbot|petalbot|yandex(?!browser)/i;

export function isBotUserAgent(userAgent: string | undefined | null): boolean {
	if (!userAgent) return false;
	return BOT_USER_AGENT_RE.test(userAgent);
}
