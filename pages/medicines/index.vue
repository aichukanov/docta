<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';

import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicineI18n]),
});

const { name, updateFromRoute, getRouteParams } = useFilters();

const route = useRoute();
const pageNumber = ref(Number(route.query.page || 1));
const routeName = route.name;
const dispensingMode = ref<string>((route.query.mode as string) || 'all');

watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		dispensingMode.value = (query.mode as string) || 'all';
		updateFromRoute(query);
	},
	{ immediate: true },
);

const filterList = computed(() => ({
	name: name.value,
	dispensingMode: dispensingMode.value,
	activeOnly: true,
	locale: locale.value,
	page: pageNumber.value,
}));

const filterQuery = computed(() => {
	const q = getRouteParams().query;
	if (dispensingMode.value !== 'all') q.mode = dispensingMode.value;
	return q;
});

const { pending: isLoading, data: medicinesList } = await useFetch(
	'/api/medicines/list',
	{
		key: 'medicines-list',
		method: 'POST',
		body: filterList,
	},
);

const pageTitleWithCount = computed(() => {
	return `${t('Medicines')} (${medicinesList.value?.totalCount || 0})`;
});

const pageDescription = computed(() => t('MedicinesDescription'));

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

const isFiltered = computed(() => {
	return !!name.value || dispensingMode.value !== 'all';
});

watchEffect(() => {
	if (medicinesList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: t('Medicines'),
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
			<div class="dispensing-filter">
				<button
					class="dispensing-btn"
					:class="{ active: dispensingMode === 'all' }"
					@click="dispensingMode = 'all'"
				>{{ t('FilterAll') }}</button>
				<button
					class="dispensing-btn"
					:class="{ active: dispensingMode === 'otc' }"
					@click="dispensingMode = 'otc'"
				>{{ t('FilterOTC') }}</button>
				<button
					class="dispensing-btn"
					:class="{ active: dispensingMode === 'prescription' }"
					@click="dispensingMode = 'prescription'"
				>{{ t('FilterPrescription') }}</button>
			</div>
		</template>

		<template #card="{ item }">
			<NuxtLink
				:to="{ name: 'medicines-medicineSlug', params: { medicineSlug: item.slug } }"
				class="medicine-card"
			>
				<div class="medicine-name">{{ item.name }}</div>
				<div v-if="item.substances" class="medicine-substances">{{ item.substances }}</div>
				<span
					v-if="item.dispensingMode"
					class="medicine-badge"
					:class="(/bez|OTC|Без рецепта|Rezeptfrei|Reçetesiz/i).test(item.dispensingMode) ? 'badge-otc' : 'badge-rx'"
				>
					{{ item.dispensingMode }}
				</span>
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
.dispensing-filter {
	display: flex;
	gap: var(--spacing-xs);
	flex-wrap: wrap;
}

.dispensing-btn {
	padding: 6px 16px;
	border: 1px solid var(--color-border-light);
	border-radius: 20px;
	background: var(--color-bg-primary);
	cursor: pointer;
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	transition: all 0.15s;

	&:hover {
		border-color: var(--color-primary);
		color: var(--color-primary);
	}

	&.active {
		background: var(--color-primary);
		color: #fff;
		border-color: var(--color-primary);
	}
}

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

.medicine-badge {
	display: inline-block;
	margin-top: 8px;
	font-size: 0.75rem;
	font-weight: 500;
	padding: 3px 10px;
	border-radius: 12px;
	white-space: nowrap;
}

.badge-otc {
	background: #e8f5e9;
	color: #2e7d32;
}

.badge-rx {
	background: #fff3e0;
	color: #e65100;
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
