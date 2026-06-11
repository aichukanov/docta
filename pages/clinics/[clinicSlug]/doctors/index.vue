<script setup lang="ts">
import {
	CLINIC_ITEMS_INLINE_THRESHOLD,
	CLINIC_ITEMS_PAGE_SIZE,
	OG_IMAGE,
	SITE_URL,
} from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildDoctorListSchema,
} from '~/common/schema-org-builders';
import {
	getCanonicalUrl,
	getRegionalQuery,
	getRegionalUrl,
} from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import clinicItemsSortI18n from '~/i18n/clinic-items-sort';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		specialtyI18n,
		clinicItemsSortI18n,
	]),
});

const route = useRoute();
const clinicSlug = computed(() => route.params.clinicSlug as string);
const { currentPage, currentSearch, currentCategory, currentSort } =
	useClinicItemsRoute({ allowedSorts: ['rating-desc', 'name-asc'] });

const { data: clinicData } = await useFetch('/api/clinics/items-summary', {
	key: `clinic-items-summary-doctors-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
	})),
});

const totalDoctors = computed(
	() => clinicData.value?.itemsSummary?.doctors?.totalCount || 0,
);

const shouldRedirect = computed(
	() => totalDoctors.value <= CLINIC_ITEMS_INLINE_THRESHOLD,
);

if (import.meta.server) {
	if (!clinicData.value?.id) {
		setResponseStatus(useRequestEvent()!, 404);
	} else if (shouldRedirect.value) {
		await navigateTo(`/clinics/${clinicSlug.value}#doctors`, {
			redirectCode: 301,
		});
	}
}

watch(shouldRedirect, (v) => {
	if (import.meta.client && v) {
		navigateTo(`/clinics/${clinicSlug.value}#doctors`);
	}
});

const clinicId = computed(() => clinicData.value?.id);

const { data: doctorsData, pending: isLoading } = await useFetch(
	'/api/doctors/list',
	{
		key: `clinic-doctors-page-${clinicSlug.value}`,
		method: 'POST',
		body: computed(() => ({
			clinicIds: clinicId.value ? [clinicId.value] : [],
			locale: locale.value,
			page: currentPage.value,
			pageSize: CLINIC_ITEMS_PAGE_SIZE,
			name: currentSearch.value || undefined,
			specialtyIds: currentCategory.value ? [currentCategory.value] : undefined,
			sort: currentSort.value || undefined,
		})),
		watch: [currentPage, currentSearch, currentCategory, currentSort],
	},
);

const items = computed(() => doctorsData.value?.doctors || []);
const totalCount = computed(() => doctorsData.value?.totalCount || 0);
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
	{ value: 'rating-desc', label: t('SortRatingDesc') },
	{ value: 'name-asc', label: t('SortNameAsc') },
]);

const categories = computed(() => {
	const raw = clinicData.value?.itemsSummary?.doctors?.categories || [];
	return raw
		.filter((c) => c.categoryId != null)
		.map((c) => ({
			categoryId: c.categoryId as number,
			title: t(`specialty_${c.categoryId}`),
			count: c.count,
		}))
		.filter((c) => !!c.title && !c.title.startsWith('specialty_'));
});

const isFiltered = computed(
	() => currentCategory.value != null || !!currentSearch.value,
);

const selectedSpecialtyName = computed(() =>
	currentCategory.value != null ? t(`specialty_${currentCategory.value}`) : '',
);

const pageTitleText = computed(() => {
	const base = t('DoctorsPageTitle', { name: clinicName.value });
	return selectedSpecialtyName.value
		? `${selectedSpecialtyName.value} — ${base}`
		: base;
});

const pageDescription = computed(() => {
	const count = isFiltered.value ? totalCount.value : totalDoctors.value;
	const base = t('DoctorsPageDescription', {
		name: clinicName.value,
		count,
	});
	return selectedSpecialtyName.value
		? `${selectedSpecialtyName.value}. ${base}`
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

const getSpecialtyName = (id: number): string | undefined => {
	const key = `specialty_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

watchEffect(() => {
	if (!clinicData.value || shouldRedirect.value) return;
	const url = getCanonicalUrl(
		route.path,
		route.query as Record<string, string | string[]>,
		locale.value,
	);
	const clinicUrl = getRegionalUrl(
		`${SITE_URL}/clinics/${clinicSlug.value}`,
		{},
		locale.value,
	);
	schemaOrgStore.setSchemas([
		...buildDoctorListSchema({
			siteUrl: SITE_URL,
			pageUrl: url,
			locale: locale.value,
			title: pageTitleText.value,
			description: pageDescription.value,
			totalCount: isFiltered.value ? totalCount.value : totalDoctors.value,
			doctors: items.value,
			isFiltered: isFiltered.value,
			getSpecialtyName,
		}),
		buildBreadcrumbsSchema(url, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{
				name: t('BreadcrumbClinics'),
				url: getRegionalUrl(`${SITE_URL}/clinics`, {}, locale.value),
			},
			{ name: clinicName.value, url: clinicUrl },
			{ name: t('BreadcrumbDoctors') },
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
		:breadcrumbCurrentLabel="t('BreadcrumbDoctors')"
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
		:searchPlaceholder="t('SearchDoctors')"
		:allCategoriesLabel="t('AllSpecialties')"
		:sortOptions="sortOptions"
		defaultSort="rating-desc"
		:sortPlaceholder="t('SortPlaceholder')"
		:emptyText="t('NoMatchingDoctors')"
	>
		<template #default="{ item }">
			<DoctorInfo :service="item" short headingLevel="h3" />
		</template>
	</ClinicItemsPage>
</template>

<i18n lang="json">
{
	"en": {
		"DoctorsPageTitle": "Doctors at {name}",
		"DoctorsPageDescription": "{count} doctors at {name}.",
		"SearchDoctors": "Search doctors…",
		"AllSpecialties": "All",
		"NoMatchingDoctors": "No doctors match your filters."
	},
	"ru": {
		"DoctorsPageTitle": "Врачи — {name}",
		"DoctorsPageDescription": "В клинике {name} принимают {count} врачей.",
		"SearchDoctors": "Поиск врачей…",
		"AllSpecialties": "Все",
		"NoMatchingDoctors": "По текущим фильтрам врачи не найдены."
	},
	"de": {
		"DoctorsPageTitle": "Ärzte — {name}",
		"DoctorsPageDescription": "In der Klinik {name} sind {count} Ärzte tätig.",
		"SearchDoctors": "Ärzte suchen…",
		"AllSpecialties": "Alle",
		"NoMatchingDoctors": "Keine Ärzte entsprechen Ihren Filtern."
	},
	"tr": {
		"DoctorsPageTitle": "Doktorlar — {name}",
		"DoctorsPageDescription": "{name} kliniğinde {count} doktor görev yapmaktadır.",
		"SearchDoctors": "Doktor ara…",
		"AllSpecialties": "Tümü",
		"NoMatchingDoctors": "Filtrelere uyan doktor bulunamadı."
	},
	"sr": {
		"DoctorsPageTitle": "Lekari — {name}",
		"DoctorsPageDescription": "U klinici {name} radi {count} lekara.",
		"SearchDoctors": "Pretraga lekara…",
		"AllSpecialties": "Sve",
		"NoMatchingDoctors": "Nema lekara koji odgovaraju filterima."
	},
	"sr-cyrl": {
		"DoctorsPageTitle": "Лекари — {name}",
		"DoctorsPageDescription": "У клиници {name} ради {count} лекара.",
		"SearchDoctors": "Претрага лекара…",
		"AllSpecialties": "Све",
		"NoMatchingDoctors": "Нема лекара који одговарају филтерима."
	}
}
</i18n>
