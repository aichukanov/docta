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
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		labTestCategoryI18n,
		clinicItemsSortI18n,
	]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const { currentPage, currentSearch, currentCategory, currentSort } =
	useClinicItemsRoute();

const { data: clinicData } = await useFetch('/api/clinics/items-summary', {
	key: `clinic-items-summary-labtests-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
	})),
});

const totalLabtests = computed(
	() => clinicData.value?.itemsSummary?.labtests?.totalCount || 0,
);

const shouldRedirect = computed(
	() => totalLabtests.value <= CLINIC_ITEMS_INLINE_THRESHOLD,
);

if (import.meta.server) {
	if (!clinicData.value?.id) {
		setResponseStatus(useRequestEvent()!, 404);
	} else if (shouldRedirect.value) {
		await navigateTo(`/clinics/${clinicSlug.value}#labtests`, {
			redirectCode: 301,
		});
	}
}

watch(shouldRedirect, (v) => {
	if (import.meta.client && v) {
		navigateTo(`/clinics/${clinicSlug.value}#labtests`);
	}
});

const clinicId = computed(() => clinicData.value?.id);

const { data: labtestsData, pending: isLoading } = await useFetch(
	'/api/labtests/list',
	{
		key: `clinic-labtests-page-${clinicSlug.value}`,
		method: 'POST',
		body: computed(() => ({
			clinicIds: clinicId.value ? [clinicId.value] : [],
			locale: locale.value,
			page: currentPage.value,
			pageSize: CLINIC_ITEMS_PAGE_SIZE,
			name: currentSearch.value || undefined,
			categoryIds: currentCategory.value ? [currentCategory.value] : undefined,
			sort: currentSort.value || undefined,
		})),
		watch: [currentPage, currentSearch, currentCategory, currentSort],
	},
);

const items = computed(() => labtestsData.value?.items || []);
const totalCount = computed(() => labtestsData.value?.totalCount || 0);
const pageSize = CLINIC_ITEMS_PAGE_SIZE;
const totalPages = computed(() => Math.ceil(totalCount.value / pageSize) || 1);

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
	const raw = clinicData.value?.itemsSummary?.labtests?.categories || [];
	return raw
		.filter((c) => c.categoryId != null)
		.map((c) => ({
			categoryId: c.categoryId as number,
			title: t(`lab_test_category_${c.categoryId}`),
			count: c.count,
		}))
		.filter((c) => !!c.title && !c.title.startsWith('lab_test_category_'));
});

const getClinicPrice = (clinicPrices: any[] = []) =>
	clinicPrices.find((p) => p.clinicId === clinicId.value);

const isFiltered = computed(
	() => currentCategory.value != null || !!currentSearch.value,
);

const selectedCategoryName = computed(() =>
	currentCategory.value != null
		? t(`lab_test_category_${currentCategory.value}`)
		: '',
);

const pageTitleText = computed(() => {
	const base = t('LabTestsPageTitle', { name: clinicName.value });
	return selectedCategoryName.value
		? `${selectedCategoryName.value} — ${base}`
		: base;
});

const pageDescription = computed(() => {
	const count = isFiltered.value ? totalCount.value : totalLabtests.value;
	const base = t('LabTestsPageDescription', {
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
			totalCount: isFiltered.value ? totalCount.value : totalLabtests.value,
			items: items.value,
			buildPath: (item) => `/labtests/${item.slug}`,
			isFiltered: isFiltered.value,
		}),
		buildBreadcrumbsSchema(url, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbClinics'), url: `${SITE_URL}/clinics` },
			{ name: clinicName.value, url: clinicUrl },
			{ name: t('BreadcrumbLabTests') },
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
		:breadcrumbCurrentLabel="t('BreadcrumbLabTests')"
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
		:searchPlaceholder="t('SearchLabTests')"
		:allCategoriesLabel="t('AllCategories')"
		:sortOptions="sortOptions"
		defaultSort="popular-desc"
		:sortPlaceholder="t('SortPlaceholder')"
		:emptyText="t('NoMatchingLabTests')"
	>
		<template #default="{ item }">
			<PricedItemCard
				:id="item.id"
				:slug="item.slug"
				:name="item.name"
				:localName="item.localName"
				:price="getClinicPrice(item.clinicPrices)?.price"
				:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
				routeName="labtests-labTestSlug"
				routeParamName="labTestSlug"
			/>
		</template>
	</ClinicItemsPage>
</template>

<i18n lang="json">
{
	"en": {
		"LabTestsPageTitle": "Lab tests at {name}",
		"LabTestsPageDescription": "{count} lab tests available at {name}.",
		"SearchLabTests": "Search lab tests…",
		"AllCategories": "All",
		"NoMatchingLabTests": "No lab tests match your filters."
	},
	"ru": {
		"LabTestsPageTitle": "Анализы — {name}",
		"LabTestsPageDescription": "В клинике {name} доступно {count} анализов.",
		"SearchLabTests": "Поиск анализов…",
		"AllCategories": "Все",
		"NoMatchingLabTests": "По текущим фильтрам анализы не найдены."
	},
	"de": {
		"LabTestsPageTitle": "Laboruntersuchungen — {name}",
		"LabTestsPageDescription": "In der Klinik {name} sind {count} Laboruntersuchungen verfügbar.",
		"SearchLabTests": "Untersuchungen suchen…",
		"AllCategories": "Alle",
		"NoMatchingLabTests": "Keine Laboruntersuchungen entsprechen Ihren Filtern."
	},
	"tr": {
		"LabTestsPageTitle": "Laboratuvar testleri — {name}",
		"LabTestsPageDescription": "{name} kliniğinde {count} laboratuvar testi sunulmaktadır.",
		"SearchLabTests": "Test ara…",
		"AllCategories": "Tümü",
		"NoMatchingLabTests": "Filtrelere uyan test bulunamadı."
	},
	"sr": {
		"LabTestsPageTitle": "Analize — {name}",
		"LabTestsPageDescription": "U klinici {name} dostupno je {count} laboratorijskih analiza.",
		"SearchLabTests": "Pretraga analiza…",
		"AllCategories": "Sve",
		"NoMatchingLabTests": "Nema analiza koje odgovaraju filterima."
	},
	"sr-cyrl": {
		"LabTestsPageTitle": "Анализе — {name}",
		"LabTestsPageDescription": "У клиници {name} доступно је {count} лабораторијских анализа.",
		"SearchLabTests": "Претрага анализа…",
		"AllCategories": "Све",
		"NoMatchingLabTests": "Нема анализа које одговарају филтерима."
	}
}
</i18n>
