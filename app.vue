<script setup lang="ts">
import { getRegionalUrl } from './common/url-utils';
import {
	defaultLocale,
	getLocaleFromQuery,
	locales,
	type Locale,
} from './composables/use-locale';

const { t, locale } = useI18n({ useScope: 'global' });
const router = useRouter();
const route = useRoute();

const queryLocale = getLocaleFromQuery(route.query.lang as string | string[]);
locale.value = queryLocale || defaultLocale;

function getMainUrl() {
	const searchParamsRe = /(?=.+)\?.+/gi;
	const path = route.fullPath.replace(searchParamsRe, '');
	return `https://docta.me${path}`;
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

	const links: Array<{
		rel: string;
		href: string;
		hreflang?: string;
	}> = [
		{
			rel: 'canonical',
			href: getLangLink(mainUrl, defaultLocale),
		},
	];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		links.push({
			rel: 'alternate',
			href: getLangLink(mainUrl, lang),
			hreflang: `${lang}-ME`,
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
	applicationName: 'docta.me',
	viewport: 'width=device-width, initial-scale=1',
	ogType: 'website',
	ogSiteName: 'docta.me',
	ogLocale: () => locale.value,
	ogUrl: () => `https://docta.me${route.fullPath}`,
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
