import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
import { checkSlugRedirect } from '../common/redirect/slug-redirects';
import { sendSitemap } from '../common/sitemap/utils';
import { generateSitemapPage } from '../common/sitemap/sitemap';
import { requireAdmin } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	const { pathname, searchParams } = getRequestURL(event);

	const pathArray = pathname.split('/').slice(1); // remove a leading slash

	if (pathArray[0] === 'sitemap.xml') {
		return sendSitemap(event, await generateSitemapPage());
	} else if (
		pathArray[0] === 'api' ||
		pathArray[0] === 'uploads' ||
		pathArray[0] === 'ads' ||
		pathArray[0] === 'search' ||
		pathArray[0].includes('a1b2c3d4e5f6789012345678901234567890abcd') ||
		pathArray[0].includes('cdn-cgi') ||
		pathArray[0].includes('robots')
	) {
		// ignore these calls
	} else if (pathArray[0] === 'admin') {
		requireAdmin(event);
	} else {
		// Редирект с числовых ID на slug-ссылки (включая объединённые сущности)
		const slugRedirect = await checkSlugRedirect(event, pathArray);
		if (slugRedirect) {
			await sendRedirect(event, slugRedirect.url, slugRedirect.status);
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
