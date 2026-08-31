import type { ComputedRef, Ref } from 'vue';
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildMedicalWebPageSchema,
} from '~/common/schema-org-builders';
import {
	buildSeoDescription,
	fitSeoTitle,
	SEO_DESCRIPTION_MAX_LENGTH,
} from '~/common/seo-meta';

/**
 * Заголовок статьи устроен как «Суть: перечисление подтем» — при переборе
 * лимита отбрасывается хвост после двоеточия или тире, а не режутся символы.
 * Полный заголовок остаётся в h1: короче он нужен только в выдаче.
 */
export function buildArticleSeoTitle(title: string): string {
	const head = title.split(/\s*[:—–]\s+/)[0];
	return fitSeoTitle([title, head]);
}

/**
 * Лид статьи служит и meta description, и абзацем под h1, поэтому он длиннее
 * лимита выдачи (замер 2026-08-31: 147–338 символов при лимите 165). Отдаём
 * его предложениями в общую обвязку: она соберёт столько целых предложений,
 * сколько влезает, вместо обрубка на полуслове.
 *
 * Если и одного предложения много, оно доразбивается по двоеточию и тире —
 * это ровно тот шов, за которым в наших лидах идёт перечисление подтем.
 */
export function buildArticleSeoDescription(description: string): string {
	const trimmed = description.trim();
	if (trimmed.length <= SEO_DESCRIPTION_MAX_LENGTH) {
		return trimmed;
	}

	const sentences = trimmed.split(/(?<=[.!?])\s+/);
	const bySentences = buildSeoDescription(sentences);
	if (bySentences.length <= SEO_DESCRIPTION_MAX_LENGTH) {
		return bySentences;
	}

	return buildSeoDescription([
		...sentences[0].split(/\s*[:—–]\s+/),
		...sentences.slice(1),
	]);
}

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

	// В крошки, h1 и schema.org идёт полный заголовок и полный лид; урезанные
	// варианты нужны только там, где действует лимит выдачи.
	const seoTitle = computed(() => buildArticleSeoTitle(pageTitle.value));
	const seoDescription = computed(() =>
		buildArticleSeoDescription(pageDescription.value),
	);

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
		title: seoTitle,
		description: seoDescription,
		ogTitle: seoTitle,
		ogDescription: seoDescription,
		ogImage: articleImage,
		ogUrl: pageUrl,
		twitterCard: 'summary',
		twitterTitle: seoTitle,
		twitterDescription: seoDescription,
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
		seoTitle,
		seoDescription,
		articleImage,
	};
}
