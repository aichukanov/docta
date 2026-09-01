<script setup lang="ts">
import { getCanonicalUrl } from './common/url-utils';
import { Language } from './enums/language';
import {
	defaultLocale,
	getHreflangTag,
	getLocaleFromQuery,
	locales,
} from './composables/use-locale';
import { useSchemaOrgStore } from './stores/schema-org';
import type { SchemaOrg } from './types/schema-org';
import {
	SITE_URL,
	SITE_NAME,
	OG_IMAGE,
	OG_IMAGE_WIDTH,
	OG_IMAGE_HEIGHT,
} from './common/constants';

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

/**
 * Признак «страницы нет»: ответ уже помечен кодом 4xx (404 на несуществующий
 * слаг, 410 на скрытую админом сущность — см. composables/use-missing-entity-status).
 *
 * Читаем именно код ответа, а не флаг конкретной страницы: его ставят все
 * детальные страницы, каждая своим способом (`setMissingEntityStatus` или
 * `setResponseStatus`), и новая страница получит поведение по умолчанию.
 *
 * Момент важен: статус проставляется в setup страницы, то есть уже ПОСЛЕ setup
 * app.vue. `app:rendered` срабатывает после рендера страницы, но до сериализации
 * payload — только там значение и известно, и ещё успевает уехать на клиент,
 * чтобы гидратация не вернула canonical обратно в DOM.
 */
const isMissingEntityPage = useState('seo-missing-entity', () => false);

if (import.meta.server) {
	const event = useRequestEvent();
	useNuxtApp().hook('app:rendered', () => {
		isMissingEntityPage.value = (event?.node.res.statusCode ?? 200) >= 400;
	});
}

// Чистим схемы перед каждой клиентской навигацией: страницы без собственной
// разметки (terms, privacy, 404 и т.п.) не должны наследовать схемы предыдущей
// страницы. Страницы со схемами заново заполнят стор в своём setup/watchEffect.
if (import.meta.client) {
	router.beforeEach(() => {
		schemaOrgStore.clearSchemas();
		// Код ответа существует только у серверного рендера. При клиентском
		// переходе флаг снимаем, иначе с 404-страницы он утёк бы на следующую,
		// живую. Обратный случай (клиентский переход НА 404) остаётся без
		// снятия canonical — краулеры грузят такие URL напрямую, то есть по SSR.
		isMissingEntityPage.value = false;
	});
}

// Reactive head for schema.org JSON-LD (works with SSR)
useHead(() => {
	const jsonLd = buildJsonLd(schemaOrgStore.schemas);
	if (!jsonLd) return {};
	return {
		script: [
			{
				type: 'application/ld+json',
				key: 'schema-org-jsonld',
				innerHTML: JSON.stringify(jsonLd),
			},
		],
	};
});

// Локаль определяется адресом страницы: сервер выбирает её только по `?lang=`
// (server/common/redirect/regional-settings.ts), клиент обязан следовать за
// тем же параметром.
//
// Раньше это было разовое присваивание в setup, и держалось оно на том, что
// сервер редиректил до рендера, а клиентские переходы всегда шли через
// переключатель языка, который менял `locale` сам. Обоих допущений больше
// нет: сохранённый язык восстанавливает plugins/locale-preference.client.ts
// уже после гидратации, и без этого watcher'а URL менялся на `?lang=de`, а
// интерфейс оставался сербским. Заодно чинится переход «назад» между
// адресами с разной локалью.
watch(
	() => route.query.lang,
	(lang) => {
		locale.value = getLocaleFromQuery(lang as string | string[]) || defaultLocale;
	},
	{ immediate: true },
);

function getLangLink(lang: string) {
	return getCanonicalUrl(
		route.path,
		route.query as Record<string, string | string[]>,
		lang,
	);
}

// Catch-all `pages/[...not-found].vue` матчит любой несуществующий путь. Опознаём
// его по имени параметра, а не по route.name: имя роута с i18n может получить
// локальный суффикс, а параметр стабилен. Дефис из имени файла Nuxt убирает,
// поэтому именно `notfound`.
// Канонизировать URL, которого не существует, и объявлять его языковые версии
// нельзя: self-canonical на мусорный путь превращал 404 в «валидную» страницу
// для краулера (см. prd/silent-200-index-hygiene).
const isNotFoundRoute = computed(() => route.params.notfound !== undefined);

const alternateLinks = computed(() => {
	// Тот же довод, что и для catch-all: несуществующий URL нельзя ни
	// канонизировать, ни объявлять его языковые версии. До этого исключение
	// работало только на catch-all, а 404 на несуществующий слаг услуги/врача и
	// 410 на скрытую клинику получали self-canonical и полный набор alternate на
	// шесть языков мёртвой страницы.
	if (isNotFoundRoute.value || isMissingEntityPage.value) {
		return [];
	}

	const currentLocale = locale.value;

	const links: Array<{
		key?: string;
		rel: string;
		href: string;
		hreflang?: string;
	}> = [
		{
			key: 'canonical',
			rel: 'canonical',
			href: getLangLink(currentLocale),
		},
		{
			rel: 'alternate',
			href: getLangLink(Language.EN),
			hreflang: 'x-default',
		},
	];

	for (let i = 0; i < locales.length; i++) {
		const lang = locales[i];

		links.push({
			rel: 'alternate',
			href: getLangLink(lang),
			hreflang: getHreflangTag(lang),
		});
	}

	return links;
});

useHead({
	link: alternateLinks,
});

const ogUrl = computed(() => `${SITE_URL}${route.fullPath}`);

useSeoMeta({
	applicationName: SITE_NAME,
	ogSiteName: SITE_NAME,
	ogLocale: locale,
	ogUrl: ogUrl,
	ogImage: OG_IMAGE,
	// Размеры обязательны для мгновенного превью: без них Facebook и Telegram
	// показывают ссылку без картинки, пока сами не скачают файл
	ogImageWidth: OG_IMAGE_WIDTH,
	ogImageHeight: OG_IMAGE_HEIGHT,
	ogImageType: 'image/jpeg',
	// Дефолтная картинка теперь 1200×630 (1.91:1) — это формат большой карточки
	twitterCard: 'summary_large_image',
});

useUserStore().fetchUser();
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
		<ConfirmProvider />
		<!-- Хост тостов @ach/ui-kit: ровно один на приложение -->
		<KitToaster :close-label="t('Close')" />
	</Html>
</template>
