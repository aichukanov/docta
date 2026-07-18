import type { ComputedRef, Ref } from 'vue';
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';

export interface UseArticlePageSeoOptions {
	/** Слаг статьи в /articles/{slug}, используется и как entity_id аналитики */
	slug: MaybeRefOrGetter<string>;
	title: MaybeRefOrGetter<string>;
	description: MaybeRefOrGetter<string>;
	/** Относительный путь картинки, напр. /img/articles/x.webp */
	image: MaybeRefOrGetter<string>;
	datePublished: string;
	/** По умолчанию равны datePublished */
	dateModified?: string;
	lastReviewed?: string;
	t: (key: string) => string;
	locale: ComputedRef<string> | Ref<string>;
}

/**
 * Общая для всех статей обвязка: аналитика (entity_viewed), useSeoMeta и
 * MedicalWebPage + BreadcrumbList schema.org. Не подходит статьям со
 * списочной schema (ItemList) — там нужен buildMedicalWebPageSchema
 * с doctors/totalCount, это остаётся на странице.
 */
export function useArticlePageSeo(options: UseArticlePageSeoOptions) {
	const slug = computed(() => toValue(options.slug));
	const pageTitle = computed(() => toValue(options.title));
	const pageDescription = computed(() => toValue(options.description));
	const articleImage = computed(() => `${SITE_URL}${toValue(options.image)}`);

	const { trackEvent } = useAnalytics();

	provideAnalyticsEntity(
		computed(() => ({
			entity_type: 'article' as const,
			entity_id: slug.value,
			entity_slug: slug.value,
		})),
	);

	onMounted(() => {
		trackEvent('entity_viewed', {
			entity_type: 'article',
			entity_id: slug.value,
			entity_slug: slug.value,
		});
	});

	const homeLink = computed(() => ({
		name: 'index',
		query: getRegionalQuery(options.locale.value),
	}));

	const articlesLink = computed(() => ({
		name: 'articles',
		query: getRegionalQuery(options.locale.value),
	}));

	const breadcrumbItems = computed(() => [
		{ label: options.t('BreadcrumbHome'), to: homeLink.value },
		{ label: options.t('BreadcrumbArticles'), to: articlesLink.value },
		{ label: pageTitle.value },
	]);

	const pageUrl = computed(() =>
		getRegionalUrl(
			`${SITE_URL}/articles/${slug.value}`,
			{},
			options.locale.value,
		),
	);

	useSeoMeta({
		title: pageTitle,
		description: pageDescription,
		ogTitle: pageTitle,
		ogDescription: pageDescription,
		ogImage: articleImage,
		ogUrl: pageUrl,
		twitterCard: 'summary',
		twitterTitle: pageTitle,
		twitterDescription: pageDescription,
		twitterImage: articleImage,
	});

	const schemaOrgStore = useSchemaOrgStore();

	watchEffect(() => {
		schemaOrgStore.setSchemas([
			...buildMedicalWebPageSchema({
				siteUrl: SITE_URL,
				pageUrl: pageUrl.value,
				locale: options.locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				image: articleImage.value,
				datePublished: options.datePublished,
				dateModified: options.dateModified ?? options.datePublished,
				lastReviewed: options.lastReviewed ?? options.datePublished,
			}),
			buildBreadcrumbsSchema(pageUrl.value, [
				{
					name: options.t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, options.locale.value),
				},
				{
					name: options.t('BreadcrumbArticles'),
					url: getRegionalUrl(`${SITE_URL}/articles`, {}, options.locale.value),
				},
				{ name: pageTitle.value },
			]),
		]);
	});

	return {
		breadcrumbItems,
		pageUrl,
		pageTitle,
		pageDescription,
		articleImage,
	};
}
