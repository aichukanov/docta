<script setup lang="ts">
import {
	CLINIC_ITEMS_INLINE_THRESHOLD,
	CLINIC_ITEMS_PAGE_SIZE,
	OG_IMAGE,
	SITE_URL,
} from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildEntityListSchema,
} from '~/common/schema-org-builders';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import clinicItemsSortI18n from '~/i18n/clinic-items-sort';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		medicalServiceCategoryI18n,
		clinicItemsSortI18n,
	]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const { currentPage, currentSearch, currentCategory, currentSort } =
	useClinicItemsRoute();

const { data: clinicData } = await useFetch('/api/clinics/items-summary', {
	key: `clinic-items-summary-services-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
	})),
});

const totalServices = computed(
	() => clinicData.value?.itemsSummary?.services?.totalCount || 0,
);

const shouldRedirect = computed(
	() => totalServices.value <= CLINIC_ITEMS_INLINE_THRESHOLD,
);

if (import.meta.server) {
	if (!clinicData.value?.id) {
		setResponseStatus(useRequestEvent()!, 404);
	} else if (shouldRedirect.value) {
		await navigateTo(`/clinics/${clinicSlug.value}#services`, {
			redirectCode: 301,
		});
	}
}

watch(shouldRedirect, (v) => {
	if (import.meta.client && v) {
		navigateTo(`/clinics/${clinicSlug.value}#services`);
	}
});

const clinicId = computed(() => clinicData.value?.id);

const { data: servicesData, pending: isLoading } = await useFetch(
	'/api/services/list',
	{
		key: `clinic-services-page-${clinicSlug.value}`,
		method: 'POST',
		body: computed(() => ({
			clinicIds: clinicId.value ? [clinicId.value] : [],
			locale: locale.value,
			page: currentPage.value,
			pageSize: CLINIC_ITEMS_PAGE_SIZE,
			name: currentSearch.value || undefined,
			serviceCategoryIds: currentCategory.value
				? [currentCategory.value]
				: undefined,
			sort: currentSort.value || undefined,
		})),
		watch: [currentPage, currentSearch, currentCategory, currentSort],
	},
);

const items = computed(() => servicesData.value?.items || []);
const totalCount = computed(() => servicesData.value?.totalCount || 0);
const pageSize = CLINIC_ITEMS_PAGE_SIZE;
const totalPages = computed(
	() => Math.ceil(totalCount.value / pageSize) || 1,
);

const clinicName = computed(() =>
	getLocalizedName(clinicData.value, locale.value),
);

const clinicLink = computed(() => ({
	name: 'clinics-clinicSlug',
	params: { clinicSlug: clinicSlug.value },
	query: getRegionalQuery(locale.value),
}));

const sortOptions = computed(() => [
	{ value: 'popular-desc', label: t('SortPopularDesc') },
	{ value: 'name-asc', label: t('SortNameAsc') },
	{ value: 'price-asc', label: t('SortPriceAsc') },
	{ value: 'price-desc', label: t('SortPriceDesc') },
]);

const categories = computed(() => {
	const raw = clinicData.value?.itemsSummary?.services?.categories || [];
	return raw
		.filter((c) => c.categoryId != null)
		.map((c) => ({
			categoryId: c.categoryId as number,
			title: t(`medical_service_category_${c.categoryId}`),
			count: c.count,
		}))
		.filter((c) => !!c.title && !c.title.startsWith('medical_service_category_'));
});

const getClinicPrice = (clinicPrices: any[] = []) =>
	clinicPrices.find((p) => p.clinicId === clinicId.value);

const isFiltered = computed(
	() => currentCategory.value != null || !!currentSearch.value,
);

const selectedCategoryName = computed(() =>
	currentCategory.value != null
		? t(`medical_service_category_${currentCategory.value}`)
		: '',
);

const pageTitleText = computed(() => {
	const base = t('ServicesPageTitle', { name: clinicName.value });
	return selectedCategoryName.value
		? `${selectedCategoryName.value} — ${base}`
		: base;
});

const pageDescription = computed(() => {
	const count = isFiltered.value ? totalCount.value : totalServices.value;
	const base = t('ServicesPageDescription', {
		name: clinicName.value,
		count,
	});
	return selectedCategoryName.value
		? `${selectedCategoryName.value}. ${base}`
		: base;
});

const robotsMeta = computed(() =>
	isFiltered.value ? 'noindex, follow' : undefined,
);

useSeoMeta({
	title: pageTitleText,
	description: pageDescription,
	ogTitle: pageTitleText,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'website',
	twitterCard: 'summary',
	twitterTitle: pageTitleText,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (!clinicData.value || shouldRedirect.value) return;
	const url = `${SITE_URL}${route.fullPath}`;
	const clinicUrl = `${SITE_URL}/clinics/${clinicSlug.value}`;
	schemaOrgStore.setSchemas([
		...buildEntityListSchema({
			siteUrl: SITE_URL,
			pageUrl: url,
			locale: locale.value,
			title: pageTitleText.value,
			description: pageDescription.value,
			totalCount: isFiltered.value
				? totalCount.value
				: totalServices.value,
			items: items.value,
			buildPath: (item) => `/services/${item.slug}`,
			isFiltered: isFiltered.value,
		}),
		buildBreadcrumbsSchema(url, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbClinics'), url: `${SITE_URL}/clinics` },
			{ name: clinicName.value, url: clinicUrl },
			{ name: t('BreadcrumbServices') },
		]),
	]);
});
</script>

<template>
	<ClinicItemsPage
		v-if="clinicData && !shouldRedirect"
		:clinicSlug="clinicSlug"
		:clinicName="clinicName"
		:clinicLink="clinicLink"
		:breadcrumbHomeLabel="t('BreadcrumbHome')"
		:breadcrumbClinicsLabel="t('BreadcrumbClinics')"
		:breadcrumbCurrentLabel="t('BreadcrumbServices')"
		:pageTitle="pageTitleText"
		:items="items"
		:totalCount="totalCount"
		:categories="categories"
		:pagination="{
			page: currentPage,
			pageSize,
			totalCount,
			totalPages,
		}"
		:isLoading="isLoading"
		:searchPlaceholder="t('SearchServices')"
		:allCategoriesLabel="t('AllCategories')"
		:sortOptions="sortOptions"
		defaultSort="popular-desc"
		:sortPlaceholder="t('SortPlaceholder')"
		:emptyText="t('NoMatchingServices')"
	>
		<template #default="{ item }">
			<PricedItemCard
				:id="item.id"
				:slug="item.slug"
				:name="item.name"
				:localName="item.localName"
				:price="getClinicPrice(item.clinicPrices)?.price"
				:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
				:priceMin="getClinicPrice(item.clinicPrices)?.priceMin"
				routeName="services-serviceSlug"
				routeParamName="serviceSlug"
			/>
		</template>
	</ClinicItemsPage>
</template>

<i18n lang="json">
{
	"en": {
		"ServicesPageTitle": "Services at {name}",
		"ServicesPageDescription": "{count} medical services available at {name}.",
		"SearchServices": "Search services…",
		"AllCategories": "All",
		"NoMatchingServices": "No services match your filters."
	},
	"ru": {
		"ServicesPageTitle": "Услуги — {name}",
		"ServicesPageDescription": "В клинике {name} доступно {count} медицинских услуг.",
		"SearchServices": "Поиск услуг…",
		"AllCategories": "Все",
		"NoMatchingServices": "По текущим фильтрам услуги не найдены."
	},
	"de": {
		"ServicesPageTitle": "Leistungen — {name}",
		"ServicesPageDescription": "In der Klinik {name} sind {count} medizinische Leistungen verfügbar.",
		"SearchServices": "Leistungen suchen…",
		"AllCategories": "Alle",
		"NoMatchingServices": "Keine Leistungen entsprechen Ihren Filtern."
	},
	"tr": {
		"ServicesPageTitle": "Hizmetler — {name}",
		"ServicesPageDescription": "{name} kliniğinde {count} tıbbi hizmet sunulmaktadır.",
		"SearchServices": "Hizmet ara…",
		"AllCategories": "Tümü",
		"NoMatchingServices": "Filtrelere uyan hizmet bulunamadı."
	},
	"sr": {
		"ServicesPageTitle": "Usluge — {name}",
		"ServicesPageDescription": "U klinici {name} dostupno je {count} medicinskih usluga.",
		"SearchServices": "Pretraga usluga…",
		"AllCategories": "Sve",
		"NoMatchingServices": "Nema usluga koje odgovaraju filterima."
	},
	"sr-cyrl": {
		"ServicesPageTitle": "Услуге — {name}",
		"ServicesPageDescription": "У клиници {name} доступно је {count} медицинских услуга.",
		"SearchServices": "Претрага услуга…",
		"AllCategories": "Све",
		"NoMatchingServices": "Нема услуга које одговарају филтерима."
	}
}
</i18n>
