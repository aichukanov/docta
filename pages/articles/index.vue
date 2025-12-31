<script setup lang="ts">
import { SITE_URL } from '~/common/constants';
import { getRegionalQuery } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildCollectionPageSchemas,
	buildTopListItemElements,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import articlesI18n from '~/i18n/articles';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([articlesI18n, breadcrumbI18n]),
});

// 1. Define data first
const homeLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));

const breadcrumbItems = computed(() => [
	{ label: t('BreadcrumbHome'), to: homeLink.value },
	{ label: t('BreadcrumbArticles') },
]);

const articles = computed(() => [
	{
		title: t('RussianSpeakingDoctorsTitle'),
		description: t('RussianSpeakingDoctorsDescription'),
		image: '/img/articles/russian-speaking-doctors.webp',
		link: {
			path: '/articles/russian-speaking-doctors-in-montenegro',
			query: getRegionalQuery(locale.value),
		},
	},
	{
		title: t('ClinicsWithLanguageSupportTitle'),
		description: t('ClinicsWithLanguageSupportDescription'),
		image: '/img/articles/clinics-with-language-support.webp',
		link: {
			path: '/articles/clinics-with-language-support',
			query: getRegionalQuery(locale.value),
		},
	},
]);

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = `${SITE_URL}/articles`;

// 2. Then use it in effects/meta
useSeoMeta({
	title: t('Articles'),
	ogTitle: t('Articles'),
	twitterTitle: t('Articles'),
});

watchEffect(() => {
	schemaOrgStore.setSchemas([
		...buildCollectionPageSchemas({
			pageUrl,
			locale: locale.value,
			title: t('Articles'),
			description: t('Articles'),
			numberOfItems: articles.value.length,
			itemListElement: buildTopListItemElements(
				articles.value.map((a, i) => ({ id: i, name: a.title })),
				{
					baseUrl: SITE_URL,
					buildPath: (a) => articles.value[a.id].link.path,
				},
			),
		}),
		buildBreadcrumbsSchema(pageUrl, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbArticles') },
		]),
	]);
});
</script>

<template>
	<div class="articles-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbItems" />

			<h1>{{ t('Articles') }}</h1>
			<div class="articles-list">
				<NuxtLink
					v-for="article in articles"
					:key="article.link.path"
					:to="article.link"
					class="article-card"
				>
					<div v-if="article.image" class="article-card__image">
						<img :src="article.image" :alt="article.title" loading="lazy" />
					</div>
					<div class="article-card__content">
						<h2>{{ article.title }}</h2>
						<p>{{ article.description }}</p>
					</div>
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
@import '~/assets/css/vars.less';

.articles-page {
	padding: 24px 0;

	h1 {
		margin-top: 16px;
		margin-bottom: 24px;
		font-size: 24px;
		font-weight: 700;
	}
}

.articles-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.article-card {
	display: flex;
	gap: 20px;
	padding: 20px;
	background: #fff;
	border-radius: 12px;
	text-decoration: none;
	color: inherit;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	transition: all 0.2s ease;

	&:hover {
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
		transform: translateY(-2px);
	}

	&__image {
		flex: 0 0 200px;
		height: 120px;
		border-radius: 8px;
		overflow: hidden;

		img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
	}

	&__content {
		flex: 1;
	}

	h2 {
		margin: 0 0 8px;
		font-size: 18px;
		font-weight: 600;
		color: #4f46e5;
	}

	p {
		margin: 0;
		font-size: 14px;
		color: #6b7280;
		line-height: 1.5;
	}
}

@media (max-width: 600px) {
	.article-card {
		flex-direction: column;

		&__image {
			flex: none;
			width: 100%;
			height: 160px;
		}
	}
}

.container {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 16px;
}
</style>
