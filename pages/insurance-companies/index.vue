<script setup lang="ts">
import { List, MapLocation } from '@element-plus/icons-vue';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildEntityListSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import insuranceCompanyI18n from '~/i18n/insurance-company';
import type {
	InsuranceCompanyBranchWithCompany,
	InsuranceCompanyListItem,
} from '~/interfaces/insurance-company';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, cityI18n, insuranceCompanyI18n]),
});

const route = useRoute();
const filtersStore = useFiltersStore();
const { cityIds, name } = toRefs(filtersStore.namespaces['insurance-companies']);

watch(
	() => route.query,
	(query) => {
		filtersStore.updateFromRoute('insurance-companies', query);
	},
	{ immediate: true },
);
useFilterTracking('insurance-companies');

const filterQuery = computed(
	() => filtersStore.getRouteParams('insurance-companies').query,
);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	name: name.value,
	locale: locale.value,
}));

const { pending: isLoading, data: companies } = await useFetch<
	InsuranceCompanyListItem[]
>('/api/insurance-companies/list', {
	key: 'insurance-companies-list',
	method: 'POST',
	body: filterList,
});

const companiesList = computed(() => companies.value || []);

const allBranches = computed<InsuranceCompanyBranchWithCompany[]>(() =>
	companiesList.value.flatMap((company) =>
		company.branches.map((branch) => ({
			...branch,
			companyId: company.id,
			companySlug: company.slug,
			companyName: company.name,
			companyPhone: company.phone,
		})),
	),
);

// Мобильный переключатель список/карта — на десктопе карта всегда рядом
// со списком (см. list-page.vue #side-map)
const view = ref<'list' | 'map'>('list');
const MOBILE_BREAKPOINT = '(max-width: 950px)';
const isMobileViewport = ref(false);
let mediaQuery: MediaQueryList | null = null;
const onViewportChange = (e: MediaQueryListEvent | MediaQueryList) => {
	isMobileViewport.value = e.matches;
};
onMounted(() => {
	mediaQuery = window.matchMedia(MOBILE_BREAKPOINT);
	onViewportChange(mediaQuery);
	mediaQuery.addEventListener('change', onViewportChange);
});
onUnmounted(() => {
	mediaQuery?.removeEventListener('change', onViewportChange);
});
const effectiveView = computed(() =>
	isMobileViewport.value && view.value === 'map' ? 'map' : 'list',
);

const pageTitle = computed(() => {
	if (cityIds.value.length === 1) {
		return t('InsuranceCompaniesInCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('InsuranceCompanies');
});

const pageTitleWithCount = computed(
	() => `${pageTitle.value} (${companiesList.value.length})`,
);

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('InsuranceCompaniesDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('InsuranceCompaniesDescription');
});

// Когда выбран один город, показываем количество офисов именно в нём
// (branchCount уже отфильтрован по городу на бэкенде), а не общее по стране.
const branchesLabel = (company: InsuranceCompanyListItem) => {
	if (cityIds.value.length === 1) {
		return t('OfficeCountInCity', {
			count: company.branchCount,
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('OfficeCount', { count: company.branchCount });
};

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
	ogTitle: pageTitleWithCount,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	twitterCard: 'summary',
	twitterTitle: pageTitleWithCount,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

const isFiltered = computed(() => cityIds.value.length > 0 || !!name.value);

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	const pageUrl = getCanonicalUrl(
		route.path,
		route.query as Record<string, string | string[]>,
		locale.value,
	);

	schemaOrgStore.setSchemas([
		...buildEntityListSchema({
			siteUrl: SITE_URL,
			pageUrl,
			locale: locale.value,
			title: pageTitle.value,
			description: pageDescription.value,
			totalCount: companiesList.value.length,
			items: companiesList.value,
			buildPath: (company) => `/insurance-companies/${company.slug}`,
			isFiltered: isFiltered.value,
		}),
		buildBreadcrumbsSchema(pageUrl, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{ name: t('BreadcrumbInsuranceCompanies') },
		]),
	]);
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="companiesList"
		:totalCount="companiesList.length"
		:isLoading="isLoading || false"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		:view="effectiveView"
	>
		<template #header-actions>
			<el-radio-group v-model="view" class="view-toggle">
				<el-radio-button value="list">
					<el-icon><List /></el-icon>
					{{ t('ViewList') }}
				</el-radio-button>
				<el-radio-button value="map">
					<el-icon><MapLocation /></el-icon>
					{{ t('ViewMap') }}
				</el-radio-button>
			</el-radio-group>
		</template>

		<template #filters>
			<FilterName
				v-model:value="name"
				:label="t('InsuranceCompanyName')"
				:placeholder="t('InsertInsuranceCompanyName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
		</template>

		<template #card="{ item }">
			<InsuranceCompanySummaryCard
				:company="item as InsuranceCompanyListItem"
				:branchesLabel="branchesLabel(item as InsuranceCompanyListItem)"
			/>
		</template>

		<template #side-map>
			<InsuranceCompanyMapView :branches="allBranches" />
		</template>

		<template #map-view>
			<div class="map-view-wrapper">
				<InsuranceCompanyMapView :branches="allBranches" />
				<el-button
					class="map-view-exit"
					type="primary"
					round
					@click="view = 'list'"
				>
					<el-icon><List /></el-icon>
					{{ t('BackToList') }}
				</el-button>
			</div>
		</template>
	</ListPage>
</template>

<style scoped lang="less">
// Переключатель список/карта — только мобильные; на десктопе
// карта всегда отображается сбоку от списка
.view-toggle {
	display: none;
	flex-shrink: 0;

	:deep(.el-radio-button__inner) {
		display: inline-flex;
		align-items: center;
		gap: var(--spacing-xs);
	}
}

.map-view-wrapper {
	position: relative;
	width: 100%;
	height: 100%;
	min-height: inherit;
}

.map-view-exit {
	display: none;
	position: absolute;
	bottom: var(--spacing-2xl);
	left: 50%;
	transform: translateX(-50%);
	z-index: var(--z-dropdown);
	box-shadow: var(--shadow-lg);

	.el-icon {
		margin-right: var(--spacing-xs);
	}
}

@media (max-width: 950px) {
	.view-toggle {
		display: inline-flex;
	}

	.map-view-exit {
		display: inline-flex;
	}
}
</style>
