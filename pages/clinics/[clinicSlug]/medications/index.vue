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
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, clinicItemsSortI18n]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const { currentPage, currentSearch, currentSort } = useClinicItemsRoute();

const { data: clinicData } = await useFetch('/api/clinics/items-summary', {
	key: `clinic-items-summary-medications-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
	})),
});

const totalMedications = computed(
	() => clinicData.value?.itemsSummary?.medications?.totalCount || 0,
);

const shouldRedirect = computed(
	() => totalMedications.value <= CLINIC_ITEMS_INLINE_THRESHOLD,
);

if (import.meta.server) {
	if (!clinicData.value?.id) {
		setResponseStatus(useRequestEvent()!, 404);
	} else if (shouldRedirect.value) {
		await navigateTo(`/clinics/${clinicSlug.value}#medications`, {
			redirectCode: 301,
		});
	}
}

watch(shouldRedirect, (v) => {
	if (import.meta.client && v) {
		navigateTo(`/clinics/${clinicSlug.value}#medications`);
	}
});

const clinicId = computed(() => clinicData.value?.id);

const { data: medicationsData, pending: isLoading } = await useFetch(
	'/api/medications/list',
	{
		key: `clinic-medications-page-${clinicSlug.value}`,
		method: 'POST',
		body: computed(() => ({
			clinicIds: clinicId.value ? [clinicId.value] : [],
			locale: locale.value,
			page: currentPage.value,
			pageSize: CLINIC_ITEMS_PAGE_SIZE,
			name: currentSearch.value || undefined,
			sort: currentSort.value || undefined,
		})),
		watch: [currentPage, currentSearch, currentSort],
	},
);

const items = computed(() => medicationsData.value?.items || []);
const totalCount = computed(() => medicationsData.value?.totalCount || 0);
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
	{ value: 'name-asc', label: t('SortNameAsc') },
	{ value: 'price-asc', label: t('SortPriceAsc') },
	{ value: 'price-desc', label: t('SortPriceDesc') },
]);

const getClinicPrice = (clinicPrices: any[] = []) =>
	clinicPrices.find((p) => p.clinicId === clinicId.value);

const isFiltered = computed(() => !!currentSearch.value);

const pageTitleText = computed(() =>
	t('MedicationsPageTitle', { name: clinicName.value }),
);
const pageDescription = computed(() => {
	const count = isFiltered.value
		? totalCount.value
		: totalMedications.value;
	return t('MedicationsPageDescription', { name: clinicName.value, count });
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
			totalCount: isFiltered.value
				? totalCount.value
				: totalMedications.value,
			items: items.value,
			buildPath: (item) => `/medications/${item.slug}`,
			isFiltered: isFiltered.value,
		}),
		buildBreadcrumbsSchema(url, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbClinics'), url: `${SITE_URL}/clinics` },
			{ name: clinicName.value, url: clinicUrl },
			{ name: t('BreadcrumbMedications') },
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
		:breadcrumbCurrentLabel="t('BreadcrumbMedications')"
		:pageTitle="pageTitleText"
		:items="items"
		:totalCount="totalCount"
		:categories="[]"
		:pagination="{
			page: currentPage,
			pageSize,
			totalCount,
			totalPages,
		}"
		:isLoading="isLoading"
		:searchPlaceholder="t('SearchMedications')"
		:allCategoriesLabel="''"
		:sortOptions="sortOptions"
		:sortPlaceholder="t('SortPlaceholder')"
		:emptyText="t('NoMatchingMedications')"
	>
		<template #default="{ item }">
			<PricedItemCard
				:id="item.id"
				:slug="item.slug"
				:name="item.name"
				:localName="item.localName"
				:price="getClinicPrice(item.clinicPrices)?.price"
				:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
				routeName="medications-medicationSlug"
				routeParamName="medicationSlug"
			/>
		</template>
	</ClinicItemsPage>
</template>

<i18n lang="json">
{
	"en": {
		"MedicationsPageTitle": "Medications at {name}",
		"MedicationsPageDescription": "{count} medications available at {name}.",
		"SearchMedications": "Search medications…",
		"NoMatchingMedications": "No medications match your filters."
	},
	"ru": {
		"MedicationsPageTitle": "Лекарства — {name}",
		"MedicationsPageDescription": "В клинике {name} доступно {count} лекарств.",
		"SearchMedications": "Поиск лекарств…",
		"NoMatchingMedications": "По текущим фильтрам лекарства не найдены."
	},
	"de": {
		"MedicationsPageTitle": "Medikamente — {name}",
		"MedicationsPageDescription": "In der Klinik {name} sind {count} Medikamente verfügbar.",
		"SearchMedications": "Medikamente suchen…",
		"NoMatchingMedications": "Keine Medikamente entsprechen Ihren Filtern."
	},
	"tr": {
		"MedicationsPageTitle": "İlaçlar — {name}",
		"MedicationsPageDescription": "{name} kliniğinde {count} ilaç sunulmaktadır.",
		"SearchMedications": "İlaç ara…",
		"NoMatchingMedications": "Filtrelere uyan ilaç bulunamadı."
	},
	"sr": {
		"MedicationsPageTitle": "Lekovi — {name}",
		"MedicationsPageDescription": "U klinici {name} dostupno je {count} lekova.",
		"SearchMedications": "Pretraga lekova…",
		"NoMatchingMedications": "Nema lekova koji odgovaraju filterima."
	},
	"sr-cyrl": {
		"MedicationsPageTitle": "Лекови — {name}",
		"MedicationsPageDescription": "У клиници {name} доступно је {count} лекова.",
		"SearchMedications": "Претрага лекова…",
		"NoMatchingMedications": "Нема лекова који одговарају филтерима."
	}
}
</i18n>
