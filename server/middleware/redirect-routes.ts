import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
import { fixRetiredFilterIds } from '../common/redirect/retired-filter-ids';
import { checkSlugRedirect } from '../common/redirect/slug-redirects';
import { parseSitemapSectionPath, sendSitemap } from '../common/sitemap/utils';
import { getSitemapIndex, getSitemapSection } from '../common/sitemap/sitemap';
import { requireAdmin } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	const { pathname, searchParams } = getRequestURL(event);

	const pathArray = pathname.split('/').slice(1); // remove a leading slash

	if (pathArray[0] === 'sitemap.xml') {
		// Теперь это sitemap-индекс, а не сам список URL: после того как каждая
		// страница стала давать по <url> на локаль, монолит упирался в лимиты
		// спецификации. Адрес менять нельзя — на него ссылается robots.txt
		// (public/robots.txt, файл отдаётся наружу как есть) и он же
		// зарегистрирован в консолях поисковиков.
		return sendSitemap(event, await getSitemapIndex());
	} else if (pathArray[0] === 'sitemaps') {
		// Файлы секций: /sitemaps/<section>-<part>.xml. Непонятный адрес
		// намеренно проваливается дальше без ответа — пусть отдаётся обычный
		// 404, а не пустой sitemap с кодом 200.
		const sectionPath = parseSitemapSectionPath(pathArray);
		if (sectionPath) {
			return sendSitemap(
				event,
				await getSitemapSection(sectionPath.section, sectionPath.part),
			);
		}
	} else if (
		pathArray[0] === 'api' ||
		// технические страницы авторизации: локаль в URL им не нужна, а лишний
		// редирект только мешает (данные Telegram приезжают в hash-фрагменте)
		pathArray[0] === 'auth' ||
		pathArray[0] === 'uploads' ||
		pathArray[0] === 'ads' ||
		pathArray[0] === 'search' ||
		// Любой .txt в корне: robots.txt, ads.txt, ключи IndexNow. Их нельзя
		// пропускать через fixUrlRegionalParams — с cookie `locale` он отдал бы
		// 302 на версию с ?lang=, а верификация IndexNow и парсеры robots.txt
		// ждут 200 с ровным содержимым. Раньше здесь был захардкожен конкретный
		// ключ-файл, из-за чего второй ключ пришлось бы дописывать руками.
		(pathArray.length === 1 && pathArray[0].endsWith('.txt')) ||
		pathArray[0].includes('cdn-cgi')
	) {
		// ignore these calls
	} else if (pathArray[0] === 'admin') {
		// Без await бросок уходил в отклонённый промис: h3 его не видел, гард
		// молча пропускал кого угодно, а на каждый запрос оставался
		// необработанный rejection. Данные при этом не утекали (все админские
		// эндпоинты зовут requireAdmin корректно, страница — SPA-оболочка без
		// данных), но краулер получал 200 вместо 401.
		await requireAdmin(event);
	} else {
		// Редирект с числовых ID на slug-ссылки (включая объединённые сущности)
		const slugRedirect = await checkSlugRedirect(event, pathArray);
		if (slugRedirect) {
			await sendRedirect(event, slugRedirect.url, slugRedirect.status);
			return;
		}

		// Раньше локального: снятое значение фильтра надо унести на преемника
		// до того, как страница отрисуется полным каталогом. Целевой URL уже
		// нормализован по `lang`, поэтому второго хопа обычно не будет.
		const retiredFilterRedirect = fixRetiredFilterIds(event);
		if (retiredFilterRedirect) {
			await sendRedirect(
				event,
				retiredFilterRedirect.url,
				retiredFilterRedirect.status,
			);
			return;
		}

		const queryParamsRedirect = await fixUrlRegionalParams(event);
		if (queryParamsRedirect) {
			await sendRedirect(
				event,
				queryParamsRedirect.url,
				queryParamsRedirect.status,
			);
			return;
		}
	}
});
