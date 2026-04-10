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

const route = useRoute();
const routeName = route.name;
const pageNumber = ref(Number(route.query.page || 1));
const name = ref((route.query.name as string) || '');
const dispensingMode = ref<string>((route.query.mode as string) || 'all');
const atcGroupId = ref<number | null>(
	route.query.atcGroup ? Number(route.query.atcGroup) : null,
);

watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		name.value = (query.name as string) || '';
		dispensingMode.value = (query.mode as string) || 'all';
		atcGroupId.value = query.atcGroup ? Number(query.atcGroup) : null;
	},
);

const filterList = computed(() => ({
	name: name.value,
	dispensingMode: dispensingMode.value,
	atcGroupId: atcGroupId.value,
	activeOnly: true,
	locale: locale.value,
	page: pageNumber.value,
}));

const { pending: isLoading, data: medicinesList } = await useFetch(
	'/api/medicines/list',
	{
		key: 'medicines-list',
		method: 'POST',
		body: filterList,
	},
);

const pageTitleWithCount = computed(() => {
	const count = medicinesList.value?.totalCount || 0;
	return `${t('Medicines')} (${count})`;
});

const pageDescription = computed(() => t('MedicinesDescription'));

// Schema.org
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
				title: t('Medicines'),
				description: pageDescription.value,
				totalCount: medicinesList.value.totalCount,
				items: medicinesList.value.items,
				buildPath: (med) => `/medicines/${med.slug}`,
				isFiltered: !!name.value || dispensingMode.value !== 'all' || !!atcGroupId.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbMedicines') },
			]),
		]);
	}
});

// Filter query for pagination links
const filterQuery = computed(() => {
	const q: Record<string, string> = {};
	if (name.value) q.name = name.value;
	if (dispensingMode.value !== 'all') q.mode = dispensingMode.value;
	if (atcGroupId.value) q.atcGroup = String(atcGroupId.value);
	return q;
});

const updateFilters = () => {
	pageNumber.value = 1;
	navigateTo({
		query: {
			...filterQuery.value,
			page: undefined,
		},
	});
};

const dispensingModeLabel = (mode: string | null) => {
	if (!mode) return '';
	if (mode.includes('bez ljekarskog') || mode === 'Over-the-counter (OTC)' || mode === 'Без рецепта' || mode === 'Rezeptfrei' || mode === 'Reçetesiz') {
		return t('OTC');
	}
	if (mode.includes('stacionarnoj') || mode === 'Hospital use only') {
		return t('HospitalOnly');
	}
	return t('Prescription');
};
</script>

<template>
	<div class="medicines-page">
		<div class="medicines-header">
			<h1 class="medicines-title">{{ pageTitleWithCount }}</h1>
			<p class="medicines-description">{{ pageDescription }}</p>
		</div>

		<div class="medicines-filters">
			<div class="filter-row">
				<input
					v-model="name"
					type="text"
					class="filter-search"
					:placeholder="t('InsertMedicineName')"
					@input="updateFilters"
				/>
			</div>
			<div class="filter-row filter-toggles">
				<button
					class="filter-btn"
					:class="{ active: dispensingMode === 'all' }"
					@click="dispensingMode = 'all'; updateFilters()"
				>
					{{ t('FilterAll') }}
				</button>
				<button
					class="filter-btn"
					:class="{ active: dispensingMode === 'otc' }"
					@click="dispensingMode = 'otc'; updateFilters()"
				>
					{{ t('FilterOTC') }}
				</button>
				<button
					class="filter-btn"
					:class="{ active: dispensingMode === 'prescription' }"
					@click="dispensingMode = 'prescription'; updateFilters()"
				>
					{{ t('FilterPrescription') }}
				</button>
			</div>
		</div>

		<div v-if="isLoading" class="medicines-loading">
			{{ t('LoadingMedicines') }}
		</div>

		<div v-else-if="!medicinesList?.items?.length" class="medicines-empty">
			{{ t('NoMedicinesFound') }}
		</div>

		<div v-else class="medicines-list">
			<NuxtLink
				v-for="med in medicinesList.items"
				:key="med.id"
				:to="`/medicines/${med.slug}`"
				class="medicine-card"
			>
				<div class="medicine-card-header">
					<span class="medicine-name">{{ med.name }}</span>
					<span
						v-if="med.isActive"
						class="medicine-badge"
						:class="med.dispensingMode?.includes('bez') || med.dispensingMode === 'Over-the-counter (OTC)' || med.dispensingMode === 'Без рецепта' || med.dispensingMode === 'Rezeptfrei' || med.dispensingMode === 'Reçetesiz' ? 'badge-otc' : 'badge-rx'"
					>
						{{ dispensingModeLabel(med.dispensingMode) }}
					</span>
				</div>
				<div class="medicine-card-details">
					<span v-if="med.pharmaForm" class="medicine-form">{{ med.pharmaForm }}</span>
					<span v-if="med.strength" class="medicine-strength">{{ med.strength }}</span>
				</div>
				<div class="medicine-card-meta">
					<span v-if="med.manufacturer">{{ med.manufacturer }}</span>
					<span v-if="med.country">, {{ med.country }}</span>
				</div>
			</NuxtLink>
		</div>

		<Pagination
			v-if="medicinesList && medicinesList.totalCount > 20"
			:totalCount="medicinesList.totalCount"
			:currentPage="pageNumber"
			:filterQuery="filterQuery"
		/>
	</div>
</template>

<style lang="less" scoped>
.medicines-page {
	max-width: 800px;
	margin: 0 auto;
	padding: var(--spacing-lg);
}

.medicines-header {
	margin-bottom: var(--spacing-xl);
}

.medicines-title {
	font-size: 1.5rem;
	font-weight: 700;
	margin: 0 0 var(--spacing-sm);
}

.medicines-description {
	color: var(--color-text-secondary);
	margin: 0;
}

.medicines-filters {
	margin-bottom: var(--spacing-lg);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.filter-search {
	width: 100%;
	padding: var(--spacing-sm) var(--spacing-md);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	font-size: var(--font-size-md);

	&:focus {
		outline: none;
		border-color: var(--color-primary);
	}
}

.filter-toggles {
	display: flex;
	gap: var(--spacing-xs);
}

.filter-btn {
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

.medicines-loading,
.medicines-empty {
	text-align: center;
	padding: var(--spacing-2xl);
	color: var(--color-text-secondary);
}

.medicines-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
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

	span + span::before {
		content: ', ';
	}
}

.medicine-card-meta {
	margin-top: var(--spacing-xs);
	font-size: var(--font-size-xs);
	color: var(--color-text-tertiary);
}
</style>
