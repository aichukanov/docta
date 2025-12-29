<script setup lang="ts">
import { getRegionalUrl } from './common/url-utils';
import { Language } from './enums/language';
import {
	defaultLocale,
	getLocaleFromQuery,
	locales,
	type Locale,
} from './composables/use-locale';
import { useSchemaOrgStore } from './stores/schema-org';
import type { SchemaOrg } from './types/schema-org';
import { SITE_URL, SITE_NAME } from './common/constants';

const { t, locale } = useI18n({ useScope: 'global' });
const router = useRouter();
const route = useRoute();
const schemaOrgStore = useSchemaOrgStore();

// Build JSON-LD from schemas
const buildJsonLd = (schemas: SchemaOrg[]) => {
	if (schemas.length === 0) {
		return null;
	}

	const normalizeNode = (schema: SchemaOrg) => {
		const { ['@context']: _context, ...rest } = schema as Record<
			string,
			unknown
		>;
		return rest;
	};

	return schemas.length === 1
		? {
				'@context': 'https://schema.org',
				...normalizeNode(schemas[0]),
		  }
		: {
				'@context': 'https://schema.org',
				'@graph': schemas.map(normalizeNode),
		  };
};

// Watch schema changes and update head
watch(
	() => schemaOrgStore.schemas,
	(schemas) => {
		const jsonLd = buildJsonLd(schemas);
		if (jsonLd) {
			useHead({
				script: [
					{
						type: 'application/ld+json',
						key: 'schema-org-jsonld',
						tagDuplicateStrategy: 'replace',
						innerHTML: JSON.stringify(jsonLd),
					},
				],
			});
		}
	},
	{ immediate: true, deep: true },
);

const queryLocale = getLocaleFromQuery(route.query.lang as string | string[]);
locale.value = queryLocale || defaultLocale;

function getMainUrl() {
	const searchParamsRe = /(?=.+)\?.+/gi;
	const path = route.fullPath.replace(searchParamsRe, '');
	return `${SITE_URL}${path}`;
}

function getLangLink(mainUrl: string, lang: Locale) {
	return getRegionalUrl(
		mainUrl,
		route.query as Record<string, string | string[]>,
		lang,
	);
}

const alternateLinks = computed(() => {
	const mainUrl = getMainUrl();
	const currentLocale = locale.value;

	const links: Array<{
		rel: string;
		href: string;
		hreflang?: string;
	}> = [
		{
			rel: 'canonical',
			href: getLangLink(mainUrl, currentLocale),
		},
		{
			rel: 'alternate',
			href: getLangLink(mainUrl, Language.EN),
			hreflang: 'x-default',
		},
	];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		if (lang === currentLocale) {
			continue;
		}

		links.push({
			rel: 'alternate',
			href: getLangLink(mainUrl, lang),
			hreflang: lang,
		});
	}

	return links;
});

useHead({
	link: alternateLinks,
});

useSeoMeta({
	title: () => t('ApplicationName'),
	description: () => t('ApplicationName'),
	applicationName: SITE_NAME,
	viewport: 'width=device-width, initial-scale=1',
	ogType: 'website',
	ogSiteName: SITE_NAME,
	ogLocale: () => locale.value,
	ogUrl: () => `${SITE_URL}${route.fullPath}`,
	ogImage: `${SITE_URL}/apple-touch-icon.png`,
	twitterCard: 'summary',
});
</script>

<template>
	<Html :lang="locale">
		<Head charset="utf-8">
			<link
				rel="apple-touch-icon"
				sizes="180x180"
				href="/apple-touch-icon.png"
			/>
			<link rel="icon" href="/favicon.ico" sizes="any" />
			<link rel="icon" href="/favicon.svg" type="image/svg+xml" />
			<link
				rel="icon"
				type="image/png"
				sizes="96x96"
				href="/favicon-96x96.png"
			/>
			<link rel="manifest" href="/site.webmanifest" />
			<meta name="msapplication-TileColor" content="#ffffff" />
			<meta name="theme-color" content="#ffffff" />
			<meta name="seznam-wmt" content="yjHUbY6o2sFmTWlqqH6Bmyq7CeEva3XL" />
		</Head>
		<NuxtLoadingIndicator />
		<NuxtLayout>
			<NuxtPage />
		</NuxtLayout>
	</Html>
</template>
