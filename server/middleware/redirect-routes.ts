import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
import { fixRetiredFilterIds } from '../common/redirect/retired-filter-ids';
import { buildRemovedMedicationsAction } from '../common/redirect/removed-medications';
import { checkSlugRedirect } from '../common/redirect/slug-redirects';
import { parseSitemapSectionPath, sendSitemap } from '../common/sitemap/utils';
import { getSitemapIndex, getSitemapSection } from '../common/sitemap/sitemap';
import { getCurrentUser } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	const { pathname, searchParams } = getRequestURL(event);

	// Слеш на конце: у каждого пути сайта был близнец, отдающий 200 с
	// self-canonical на самого себя. То есть дубль в индексе на КАЖДЫЙ адрес,
	// причём регистр при этом ловился (`/CLINICS/` → 302), а слеш — нет.
	// Постоянный редирект, потому что зависит только от URL. Корень трогать
	// нельзя: `/` — это и есть путь без слеша.
	if (pathname.length > 1 && pathname.endsWith('/')) {
		const target =
			pathname.slice(0, -1) + (searchParams.size ? `?${searchParams}` : '');
		await sendRedirect(event, target, 301);
		return;
	}

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
		// Это страница, а не API, поэтому здесь НЕ `requireAdmin`: он бросает
		// 401 с телом JSON, и браузер на такой ответ предлагает скачать файл
		// вместо того, чтобы что-то показать. Сам `requireAdmin` не трогаем —
		// его зовут 54 эндпоинта, и там JSON как раз правильный ответ.
		//
		// Раньше гард тут вызывался без `await`: бросок уходил в отклонённый
		// промис, h3 его не видел, и админка отдавала 200 кому угодно. Данные
		// при этом не утекали (страница — SPA-оболочка, а её API защищены), но
		// краулер видел живую страницу.
		const user = await getCurrentUser(event);

		if (!user) {
			// Куда вернуться после входа: страница логина обычно берёт адрес из
			// sessionStorage (его кладёт middleware/admin-auth.ts), но серверный
			// редирект туда писать не может — передаём параметром.
			const target = pathname + (searchParams.size ? `?${searchParams}` : '');

			await sendRedirect(
				event,
				`/login?redirect=${encodeURIComponent(target)}`,
				302,
			);
			return;
		}

		if (!user.is_admin) {
			// Залогинен, но не админ: логин ему не поможет, показывать нечего.
			await sendRedirect(event, '/', 302);
			return;
		}
	} else {
		// Редирект с числовых ID на slug-ссылки (включая объединённые сущности)
		const slugRedirect = await checkSlugRedirect(event, pathArray);
		if (slugRedirect) {
			await sendRedirect(event, slugRedirect.url, slugRedirect.status);
			return;
		}

		// Снятый раздел `/medications` — см. removed-medications.ts. Идёт ПОСЛЕ
		// slug-редиректа осознанно: тот превращает `/clinics/42/medications` в
		// `/clinics/<slug>` одним хопом (хвост пути он отбрасывает сам), а
		// поставь мы проверку раньше — вышло бы два.
		const removedMedications = buildRemovedMedicationsAction(
			pathArray,
			getQuery(event),
		);
		if (removedMedications) {
			if (removedMedications.type === 'gone') {
				// 410, а не 404: страницы удалены намеренно и навсегда, преемника
				// у карточки нет (см. комментарий в removed-medications.ts).
				// createError, а не setResponseStatus: иначе Nuxt пошёл бы дальше
				// и отрисовал бы обычную страницу «не найдено» с кодом 200.
				throw createError({ statusCode: 410, statusMessage: 'Gone' });
			}

			await sendRedirect(
				event,
				removedMedications.url,
				removedMedications.status,
			);
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
