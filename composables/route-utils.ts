import { getRegionalQuery } from '~/common/url-utils';

export function getLinkFromName(name: string) {
	return { path: '/' + name.replaceAll('-', '/') };
}

export const useRouteUtils = () => {
	const { locale } = useI18n({ useScope: 'global' });

	function getArticleLink(path: string | undefined, articleId?: number) {
		let name = '';

		const query = getRegionalQuery(locale.value);

		if (path === 'index') {
			return { name: 'index', params: {}, query };
		}

		const [category, page] = (path ?? 'other-other').split('-');

		if (category) {
			name = category;

			if (page) {
				name += `-${page}`;
			}
		}

		return { name, query };
	}

	return {
		getArticleLink,
	};
};
