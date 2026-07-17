<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import { localizeStrength } from '~/common/strength-label';
import { buildPackagingLabel } from '~/common/packaging-label';

import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';
import dispensingModeI18n from '~/i18n/dispensing-mode';
// packagingI18n нужен ради единиц pack_vol_* для localizeStrength
import packagingI18n from '~/i18n/packaging';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		medicineI18n,
		dispensingModeI18n,
		packagingI18n,
	]),
});

const filtersStore = useFiltersStore();
const {
	name,
	dispensingModeIds,
	atcGroupIds,
	substanceIds,
	pharmaFormIds,
	manufacturerIds,
} = toRefs(filtersStore.namespaces.medicines);

const { data: filterOptions } = await useFetch(
	'/api/medicines/filter-options',
	{
		key: 'medicine-filter-options',
		method: 'POST',
		body: computed(() => ({ locale: locale.value })),
	},
);

const route = useRoute();
const pageNumber = ref(Number(route.query.page || 1));
const routeName = route.name;

watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		filtersStore.updateFromRoute('medicines', query);
	},
	{ immediate: true },
);
// строго после первичной синхронизации из URL — она не действие пользователя
useFilterTracking('medicines');

const filterList = computed(() => ({
	name: name.value,
	dispensingModeIds: dispensingModeIds.value.length
		? dispensingModeIds.value
		: undefined,
	atcGroupIds: atcGroupIds.value.length ? atcGroupIds.value : undefined,
	substanceIds: substanceIds.value.length ? substanceIds.value : undefined,
	pharmaFormIds: pharmaFormIds.value.length ? pharmaFormIds.value : undefined,
	manufacturerIds: manufacturerIds.value.length
		? manufacturerIds.value
		: undefined,
	activeOnly: true,
	locale: locale.value,
	page: pageNumber.value,
}));

const filterQuery = computed(
	() => filtersStore.getRouteParams('medicines').query,
);

const { pending: isLoading, data: medicinesList } = await useFetch(
	'/api/medicines/list',
	{
		key: 'medicines-list',
		method: 'POST',
		body: filterList,
	},
);

// Фасовка различает «дубли» реестра: одинаковые название/дозировка,
// но 10 vs 20 таблеток
const itemPackaging = (item: any) => buildPackagingLabel(item, t, false);

const getFilterLabel = (
	items: { value: number; label: string }[],
	ids: number[],
) => {
	if (ids.length !== 1) return null;
	return items.find((item) => item.value === ids[0])?.label || null;
};

const pageTitle = computed(() => {
	const opts = filterOptions.value;
	const substanceLabel = getFilterLabel(
		opts?.substances || [],
		substanceIds.value,
	);

	// Dispensing mode label for single selection
	const dmLabel =
		dispensingModeIds.value.length === 1
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
	const formLabel = getFilterLabel(
		opts?.pharmaForms || [],
		pharmaFormIds.value,
	);
	if (formLabel) suffixes.push(formLabel);
	const mfgLabel = getFilterLabel(
		opts?.manufacturers || [],
		manufacturerIds.value,
	);
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
	return (
		!!name.value ||
		dispensingModeIds.value.length > 0 ||
		atcGroupIds.value.length > 0 ||
		substanceIds.value.length > 0 ||
		pharmaFormIds.value.length > 0 ||
		manufacturerIds.value.length > 0
	);
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
				totalCount: medicinesList.value.totalCount,
				items: medicinesList.value.items,
				buildPath: (med) => `/medicines/${med.slug}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
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
				v-model:value="name"
				:label="t('MedicineName')"
				:placeholder="t('InsertMedicineName')"
			/>
			<FilterMedicineDispensingModeSelect v-model:value="dispensingModeIds" />
			<FilterMedicineAtcGroupSelect
				v-model:value="atcGroupIds"
				:items="filterOptions?.atcGroups || []"
			/>
			<FilterMedicineSubstanceSelect
				v-model:value="substanceIds"
				:items="filterOptions?.substances || []"
			/>
			<FilterMedicinePharmaFormSelect
				v-model:value="pharmaFormIds"
				:items="filterOptions?.pharmaForms || []"
			/>
			<FilterMedicineManufacturerSelect
				v-model:value="manufacturerIds"
				:items="filterOptions?.manufacturers || []"
			/>
		</template>

		<template #card="{ item }">
			<NuxtLink
				:to="{
					name: 'medicines-medicineSlug',
					params: { medicineSlug: item.slug },
				}"
				class="medicine-card"
			>
				<div class="medicine-card-icon">
					<MedicineFormIcon :formSrc="item.pharmaFormSrc" :size="24" />
				</div>
				<div class="medicine-card-content">
					<div class="medicine-name">{{ item.name }}</div>
					<div v-if="item.substances" class="medicine-substances">{{
						item.substances
					}}</div>
					<MedicineBadge :dispensingModeId="item.dispensingModeId" />
					<div class="medicine-card-details">
						<span v-if="item.pharmaForm">{{ item.pharmaForm }}</span>
						<span v-if="item.strength"
							>, {{ localizeStrength(item.strength, t) }}</span
						>
						<span v-if="itemPackaging(item)">, {{ itemPackaging(item) }}</span>
					</div>
					<div class="medicine-card-meta">
						<span v-if="item.manufacturer">{{ item.manufacturer }}</span>
						<span v-if="item.country">, {{ item.country }}</span>
					</div>
				</div>
			</NuxtLink>
		</template>
	</ListPage>
</template>

<style lang="less" scoped>
.medicine-card {
	display: flex;
	gap: var(--spacing-md);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	box-shadow: var(--shadow-xs);
	text-decoration: none;
	color: inherit;
	transition:
		border-color var(--transition-base),
		box-shadow var(--transition-base);

	&:hover {
		border-color: var(--color-primary);
		box-shadow: var(--shadow-hover);
	}
}

.medicine-card-icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	flex-shrink: 0;
	background: var(--color-primary-bg);
	border-radius: var(--border-radius-lg);
	color: var(--color-primary);
}

.medicine-card-content {
	flex: 1;
	min-width: 0;
}

.medicine-name {
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-base);
	line-height: 1.3;
}

.medicine-substances {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-xs);
	font-style: italic;
}

.medicine-card-details {
	margin-top: var(--spacing-md);
	padding-top: var(--spacing-sm);
	border-top: 1px solid var(--color-border-light);
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.medicine-card-meta {
	margin-top: var(--spacing-xs);
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}

// Hide map sidebar — medicines aren't tied to locations
:deep(.map-container) {
	display: none;
}

:deep(.list-sidebar) {
	border-right: none;
}
</style>
