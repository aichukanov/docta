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
				<div class="medicine-card-header">
					<span class="medicine-name">{{ item.name }}</span>
					<span
						v-if="item.dispensingMode"
						class="medicine-badge"
						:class="item.dispensingMode.includes('OTC') || item.dispensingMode.includes('без') || item.dispensingMode.includes('bez') || item.dispensingMode === 'Rezeptfrei' || item.dispensingMode === 'Reçetesiz' ? 'badge-otc' : 'badge-rx'"
					>
						{{ item.dispensingMode }}
					</span>
				</div>
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
	padding: var(--spacing-xs) var(--spacing-md);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-sm);
	background: var(--color-bg-primary);
	cursor: pointer;
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);

	&.active {
		background: var(--color-primary);
		color: #fff;
		border-color: var(--color-primary);
	}
}

.medicine-card {
	display: block;
	padding: var(--spacing-md);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	text-decoration: none;
	color: inherit;
	transition: border-color 0.15s;

	&:hover {
		border-color: var(--color-primary);
	}
}

.medicine-card-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-sm);
}

.medicine-name {
	font-weight: 600;
	font-size: var(--font-size-md);
}

.medicine-badge {
	font-size: var(--font-size-xs);
	padding: 2px var(--spacing-xs);
	border-radius: var(--border-radius-sm);
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
	margin-top: var(--spacing-xs);
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.medicine-card-meta {
	margin-top: var(--spacing-xs);
	font-size: var(--font-size-xs);
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
