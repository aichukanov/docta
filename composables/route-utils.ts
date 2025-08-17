import { useCountry } from './use-country';
import { getRegionalQuery } from '~/common/url-utils';

export function getLinkFromName(name: string) {
	return { path: '/' + name.replaceAll('-', '/') };
}

export const useRouteUtils = () => {
	const { locale } = useI18n({ useScope: 'global' });
	const { country } = useCountry();
	const { uiCurrency } = useCurrency();

	function getArticleLink(path: string | undefined, articleId?: number) {
		let name = '';

		const query = getRegionalQuery(
			country.value,
			locale.value,
			uiCurrency.value,
		);

		if (path === 'index') {
			return { name: 'index', params: {}, query };
		}

		const [menuName, subMenuName, categoryName] = (
			path ?? 'other-other-other'
		).split('-');

		const params: {
			menuName?: string;
			subMenuName?: string;
			categoryName?: string;
			articleId?: string;
		} = {};

		if (menuName) {
			name = 'menuName';
			params.menuName = menuName;

			if (subMenuName) {
				name += `-subMenuName`;
				params.subMenuName = subMenuName;

				if (categoryName) {
					name += `-categoryName`;
					params.categoryName = categoryName;

					if (articleId != null) {
						name += `-articleId`;
						params.articleId = articleId.toString();
					}
				}
			}
		}

		return { name, params, query };
	}

	return {
		getArticleLink,
	};
};
