// import { getArticleIdByLink } from '../common/utils';
// import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
// import { getUpdatedMenuRoute } from '../common/redirect/menu-redirects';
// import { sendSitemap } from '../common/sitemap/utils';
// import { generateSitemapPage } from '../common/sitemap/sitemap';
// import { generateSitemapIndex } from '../common/sitemap/sitemap-index';

export default defineEventHandler(async (event) => {
	// 	const { pathname, searchParams } = getRequestURL(event);
	// 	const pathArray = pathname.split('/').slice(1); // remove a leading slash
	// 	function getUrlByArray(pathArray: string[]) {
	// 		let url = '';
	// 		for (let i = 0; i < pathArray.length; i++) {
	// 			if (!pathArray[i]) {
	// 				break;
	// 			} else {
	// 				url += '/' + pathArray[i];
	// 			}
	// 		}
	// 		const searchString = searchParams.toString();
	// 		return (url || '/') + (searchString ? '?' + searchString : '');
	// 	}
	// 	if (pathArray[0].includes('sitemap')) {
	// 		switch (pathArray[0]) {
	// 			case 'sitemap.xml':
	// 			case 'sitemap_index.xml': {
	// 				const sitemapContent = await generateSitemapIndex();
	// 				return sendSitemap(event, sitemapContent);
	// 			}
	// 			default: {
	// 				const sitemapPageRe = /^sitemap\d+\.xml$/gi;
	// 				const oldFormatSitemapRE = /^(\d+)-sitemap.xml$/;
	// 				if (
	// 					sitemapPageRe.test(pathArray[0]) ||
	// 					oldFormatSitemapRE.test(pathArray[0])
	// 				) {
	// 					const match = pathArray[0].match(/\d+/);
	// 					if (match) {
	// 						const sitemapIndex = parseInt(match[0], 10);
	// 						if (sitemapIndex >= 0) {
	// 							const sitemapContent = await generateSitemapPage(sitemapIndex);
	// 							return sendSitemap(event, sitemapContent);
	// 						}
	// 					}
	// 				}
	// 				throw createError({
	// 					statusCode: 404,
	// 					statusMessage: 'Sitemap Not Found',
	// 				});
	// 			}
	// 		}
	// 	} else if (pathArray[0] === 'api') {
	// 		if (pathArray[1] === 'sitemap_index.xml') {
	// 			await sendRedirect(event, '/sitemap_index.xml', 301);
	// 		} else if (pathArray[1] === 'sitemap.xml') {
	// 			const pageNumber = searchParams.get('page') as string;
	// 			if (pageNumber) {
	// 				await sendRedirect(event, `/sitemap${pageNumber}.xml`, 301);
	// 			} else {
	// 				throw createError({
	// 					statusCode: 404,
	// 					statusMessage: 'Sitemap Not Found',
	// 				});
	// 			}
	// 		}
	// 	} else if (pathArray[0] === 'find') {
	// 		const link = searchParams.get('link') as string;
	// 		const articleId = await getArticleIdByLink(link);
	// 		searchParams.delete('link');
	// 		if (articleId) {
	// 			const { originalArticleId, categoryId } = await getCategoryByArticleId(
	// 				articleId,
	// 			);
	// 			const [correctMenuName, correctSubmenuName, correctCategoryName] = (
	// 				categoryLinksMap[categoryId] || 'other-other-other'
	// 			).split('-');
	// 			await sendRedirect(
	// 				event,
	// 				getUrlByArray([
	// 					correctMenuName,
	// 					correctSubmenuName,
	// 					correctCategoryName,
	// 					originalArticleId,
	// 				]),
	// 				301,
	// 			);
	// 		} else {
	// 			await sendRedirect(event, '/', 301);
	// 		}
	// 	} else if (
	// 		pathArray[0] === 'ads' ||
	// 		pathArray[0] === 'search' ||
	// 		pathArray[0].includes('e290a5f4e3cd4086a71b3a63c578b24f') ||
	// 		pathArray[0].includes('cdn-cgi') ||
	// 		pathArray[0].includes('robots')
	// 	) {
	// 		// ignore these calls
	// 	} else {
	// 		const queryParamsRedirect = fixUrlRegionalParams(event);
	// 		if (queryParamsRedirect) {
	// 			await sendRedirect(
	// 				event,
	// 				queryParamsRedirect.url,
	// 				queryParamsRedirect.status,
	// 			);
	// 			return;
	// 		}
	// 		const [menuName, submenuName, categoryName, articleId] =
	// 			getUpdatedMenuRoute(pathArray);
	// 		if (articleId) {
	// 			const { originalArticleId, categoryId } = await getCategoryByArticleId(
	// 				articleId,
	// 			);
	// 			const [correctMenuName, correctSubmenuName, correctCategoryName] = (
	// 				categoryLinksMap[categoryId] || 'other-other-other'
	// 			).split('-');
	// 			if (
	// 				articleId !== originalArticleId ||
	// 				correctMenuName !== pathArray[0] ||
	// 				correctSubmenuName !== pathArray[1] ||
	// 				correctCategoryName !== pathArray[2]
	// 			) {
	// 				await sendRedirect(
	// 					event,
	// 					getUrlByArray([
	// 						correctMenuName,
	// 						correctSubmenuName,
	// 						correctCategoryName,
	// 						originalArticleId,
	// 					]),
	// 					301,
	// 				);
	// 			}
	// 		} else if (menuName) {
	// 			if (!menuHierarchy[menuName]) {
	// 				throw createError({
	// 					statusCode: 404,
	// 					statusMessage: 'Not Found',
	// 				});
	// 			}
	// 			if (submenuName) {
	// 				if (!menuHierarchy[menuName][submenuName]) {
	// 					throw createError({
	// 						statusCode: 404,
	// 						statusMessage: 'Not Found',
	// 					});
	// 				}
	// 				if (categoryName) {
	// 					const categoryExists = menuHierarchy[menuName][submenuName].find(
	// 						({ textKey }) => textKey === categoryName,
	// 					);
	// 					if (!categoryExists) {
	// 						throw createError({
	// 							statusCode: 404,
	// 							statusMessage: 'Not Found',
	// 						});
	// 					}
	// 					if (
	// 						menuName !== pathArray[0] ||
	// 						submenuName !== pathArray[1] ||
	// 						categoryName !== pathArray[2]
	// 					) {
	// 						await sendRedirect(
	// 							event,
	// 							getUrlByArray([menuName, submenuName, categoryName]),
	// 							301,
	// 						);
	// 					}
	// 				} else if (menuName !== pathArray[0] || submenuName !== pathArray[1]) {
	// 					await sendRedirect(
	// 						event,
	// 						getUrlByArray([menuName, submenuName]),
	// 						301,
	// 					);
	// 				}
	// 			} else if (menuName !== pathArray[0]) {
	// 				await sendRedirect(event, getUrlByArray([menuName]), 301);
	// 			}
	// 		}
	// 	}
});
