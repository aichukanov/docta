<script setup lang="ts">
import { locales, type Locale } from './composables/use-locale';
import { defaultLocale, getLocaleFromQuery } from './composables/use-locale';
import { getRegionalUrl } from './common/url-utils';

const { t, locale } = useI18n({ useScope: 'global' });
const router = useRouter();
const route = useRoute();

const cookieLocale = useCookie<string>('locale', {
	maxAge: 1000 * 60 * 60 * 24 * 365,
});
const queryLocale = getLocaleFromQuery(route.query.lang as string | string[]);
locale.value = cookieLocale.value || queryLocale || defaultLocale;

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
			href: getLangLink(mainUrl, 'sr'),
		},
	];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		// Google doesn't support montenegrin language
		if (lang === 'me') {
			continue;
		}
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

onMounted(async () => {
	await nextTick();

	watch(
		locale,
		() => {
			cookieLocale.value = locale.value;

			router.replace({
				query: {
					...route.query,
					lang: formatLocaleAsQuery(locale.value),
				},
			});
		},
		{ immediate: true },
	);
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
			<link
				rel="icon"
				type="image/png"
				sizes="32x32"
				href="/favicon-32x32.png"
			/>
			<link
				rel="icon"
				type="image/png"
				sizes="16x16"
				href="/favicon-16x16.png"
			/>
			<link rel="manifest" href="/site.webmanifest" />
			<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5" />
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
