<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';

import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';
import dispensingModeI18n from '~/i18n/dispensing-mode';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicineI18n, dispensingModeI18n]),
});

const { name, dispensingModeIds, atcGroupIds, substanceIds, pharmaFormIds, manufacturerIds, updateFromRoute, getRouteParams } = useFilters();

const { data: filterOptions } = await useFetch('/api/medicines/filter-options', {
	key: 'medicine-filter-options',
	method: 'POST',
	body: computed(() => ({ locale: locale.value })),
});

const route = useRoute();
const pageNumber = ref(Number(route.query.page || 1));
const routeName = route.name;

watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		updateFromRoute(query);
	},
	{ immediate: true },
);

const filterList = computed(() => ({
	name: name.value,
	dispensingModeIds: dispensingModeIds.value.length ? dispensingModeIds.value : undefined,
	atcGroupIds: atcGroupIds.value.length ? atcGroupIds.value : undefined,
	substanceIds: substanceIds.value.length ? substanceIds.value : undefined,
	pharmaFormIds: pharmaFormIds.value.length ? pharmaFormIds.value : undefined,
	manufacturerIds: manufacturerIds.value.length ? manufacturerIds.value : undefined,
	activeOnly: true,
	locale: locale.value,
	page: pageNumber.value,
}));

const filterQuery = computed(() => {
	return getRouteParams().query;
});

const { pending: isLoading, data: medicinesList } = await useFetch(
	'/api/medicines/list',
	{
		key: 'medicines-list',
		method: 'POST',
		body: filterList,
	},
);

const getFilterLabel = (items: { value: number; label: string }[], ids: number[]) => {
	if (ids.length !== 1) return null;
	return items.find((item) => item.value === ids[0])?.label || null;
};

const pageTitle = computed(() => {
	const opts = filterOptions.value;
	const substanceLabel = getFilterLabel(opts?.substances || [], substanceIds.value);

	// Dispensing mode label for single selection
	const dmLabel = dispensingModeIds.value.length === 1
		? t(`dm_${dispensingModeIds.value[0]}`)
		: null;

	// Base title: substance has priority for natural phrasing
	let base: string;
	if (substanceLabel) {
		base = t('TitleSubstance', { substance: substanceLabel });
	} else {
		base = t('Medicines');
	}

	// Collect suffix parts
	const suffixes: string[] = [];
	if (dmLabel) suffixes.push(dmLabel);
	const atcLabel = getFilterLabel(opts?.atcGroups || [], atcGroupIds.value);
	if (atcLabel) suffixes.push(atcLabel);
	const formLabel = getFilterLabel(opts?.pharmaForms || [], pharmaFormIds.value);
	if (formLabel) suffixes.push(formLabel);
	const mfgLabel = getFilterLabel(opts?.manufacturers || [], manufacturerIds.value);
	if (mfgLabel) suffixes.push(mfgLabel);

	if (suffixes.length > 0) {
		return `${base} — ${suffixes.join(' — ')}`;
	}
	return base;
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicinesList.value?.totalCount || 0})`;
});

const isFiltered = computed(() => {
	return !!name.value || dispensingModeIds.value.length > 0 ||
		atcGroupIds.value.length > 0 || substanceIds.value.length > 0 ||
		pharmaFormIds.value.length > 0 || manufacturerIds.value.length > 0;
});

const pageDescription = computed(() => {
	if (isFiltered.value) {
		return t('MedicinesDescriptionFiltered', {
			count: medicinesList.value?.totalCount || 0,
			title: pageTitle.value,
		});
	}
	return t('MedicinesDescription');
});

const schemaOrgStore = useSchemaOrgStore();

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

watchEffect(() => {
	if (medicinesList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: medicinesList.value.totalCount,
				items: medicinesList.value.items,
				buildPath: (med) => `/medicines/${med.slug}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbMedicines') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicinesList?.items || []"
		:totalCount="medicinesList?.totalCount || 0"
		:isLoading="isLoading"
		:filterQuery="filterQuery"
		:cityIds="[]"
		:showPrice="false"
		detailsRouteName="medicines-medicineSlug"
		detailsParamName="medicineSlug"
	>
		<template #filters>
			<FilterName
				:label="t('MedicineName')"
				:placeholder="t('InsertMedicineName')"
			/>
			<FilterMedicineDispensingModeSelect v-model:value="dispensingModeIds" />
			<FilterMedicineAtcGroupSelect v-model:value="atcGroupIds" :items="filterOptions?.atcGroups || []" />
			<FilterMedicineSubstanceSelect v-model:value="substanceIds" :items="filterOptions?.substances || []" />
			<FilterMedicinePharmaFormSelect v-model:value="pharmaFormIds" :items="filterOptions?.pharmaForms || []" />
			<FilterMedicineManufacturerSelect v-model:value="manufacturerIds" :items="filterOptions?.manufacturers || []" />
		</template>

		<template #card="{ item }">
			<NuxtLink
				:to="{ name: 'medicines-medicineSlug', params: { medicineSlug: item.slug } }"
				class="medicine-card"
			>
				<div class="medicine-name">{{ item.name }}</div>
				<div v-if="item.substances" class="medicine-substances">{{ item.substances }}</div>
				<MedicineBadge :dispensingModeId="item.dispensingModeId" />
				<div class="medicine-card-details">
					<span v-if="item.pharmaForm">{{ item.pharmaForm }}</span>
					<span v-if="item.strength">, {{ item.strength }}</span>
				</div>
				<div class="medicine-card-meta">
					<span v-if="item.manufacturer">{{ item.manufacturer }}</span>
					<span v-if="item.country">, {{ item.country }}</span>
				</div>
			</NuxtLink>
		</template>
	</ListPage>
</template>

<style lang="less" scoped>
.medicine-card {
	display: block;
	padding: 16px 20px;
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	text-decoration: none;
	color: inherit;
	transition: border-color 0.15s, box-shadow 0.15s;

	&:hover {
		border-color: var(--color-primary);
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	}
}

.medicine-name {
	font-weight: 600;
	font-size: 1rem;
	line-height: 1.3;
}

.medicine-substances {
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	margin-top: 4px;
	font-style: italic;
}

.medicine-card-details {
	margin-top: 10px;
	padding-top: 8px;
	border-top: 1px solid var(--color-border-light);
	font-size: 0.875rem;
	color: var(--color-text-secondary);
}

.medicine-card-meta {
	margin-top: 4px;
	font-size: 0.8rem;
	color: var(--color-text-tertiary);
}

// Hide map sidebar — medicines aren't tied to locations
:deep(.map-container) {
	display: none;
}

:deep(.list-sidebar) {
	border-right: none;
}
</style>
