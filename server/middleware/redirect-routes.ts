// import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
import { sendSitemap } from '../common/sitemap/utils';
import { generateSitemapPage } from '../common/sitemap/sitemap';
import { generateSitemapIndex } from '../common/sitemap/sitemap-index';

export default defineEventHandler(async (event) => {
	const { pathname, searchParams } = getRequestURL(event);

	const pathArray = pathname.split('/').slice(1); // remove a leading slash

	if (pathArray[0] === 'sitemap.xml') {
		return sendSitemap(event, await generateSitemapPage());
	} else if (
		pathArray[0] === 'ads' ||
		pathArray[0] === 'search' ||
		pathArray[0].includes('a1b2c3d4e5f6789012345678901234567890abcd') ||
		pathArray[0].includes('cdn-cgi') ||
		pathArray[0].includes('robots')
	) {
		// ignore these calls
	} else if (pathArray[0] === '') {
		return sendRedirect(event, '/doctors', 302);
	}
});
