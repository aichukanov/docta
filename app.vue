<script setup lang="ts">
import { CountryCode, enrichForCountry } from './composables/use-country';
import { locales, type Locale } from './composables/use-locale';
import { getRegionalUrl } from './common/url-utils';
import { Currency } from './enums/currency';

const { t, locale } = useI18n({ useScope: 'global' });
const route = useRoute();
const { country } = useCountry();
const { uiCurrency } = useCurrency();

const queryLocale = getLocaleFromQuery(route.query.lang as string | string[]);
if (queryLocale) {
	locale.value = queryLocale;
}

const queryCountry = getCountryCodeFromQuery(
	route.query.country as string | string[],
);
if (queryCountry) {
	country.value = queryCountry;
}

const queryCurrency = getCurrencyFromQuery(
	route.query.currency as string | string[],
);
if (queryCurrency) {
	uiCurrency.value = queryCurrency;
}

function getMainUrl() {
	const searchParamsRe = /(?=.+)\?.+/gi;
	const path = route.fullPath.replace(searchParamsRe, '');
	return `https://docta.me${path}`;
}

function getLangLink(mainUrl: string, lang: Locale, country: CountryCode) {
	return getRegionalUrl(
		mainUrl,
		route.query as Record<string, string | string[]>,
		[country],
		lang,
		country === CountryCode.BIH ? Currency.BAM : Currency.EUR,
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
			// href: getMainUrl(),
			href: getLangLink(mainUrl, 'sr', CountryCode.MNE),
		},
		// todo: need to add country-switcher to layout if country is not set
		// {
		// 	rel: 'alternate',
		// 	href: getMainUrl(),
		// 	hreflang: 'x-default',
		// },
	];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		// Google doesn't support montenegrin language
		if (lang === 'me') {
			continue;
		}

		for (let j = 0; j < allCountries.length; j++) {
			const country = allCountries[j];
			links.push({
				rel: 'alternate',
				href: getLangLink(mainUrl, lang, country),
				hreflang: `${lang}-${country.toUpperCase()}`,
			});
		}
	}

	return links;
});

useHead({
	link: alternateLinks,
});

useSeoMeta({
	applicationName: () => t(enrichForCountry('ApplicationName')),
	viewport: 'width=device-width, initial-scale=1',
	ogType: 'website',
	ogSiteName: 'svad',
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
