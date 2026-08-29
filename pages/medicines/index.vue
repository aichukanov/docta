<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import { localizeStrength } from '~/common/strength-label';
import { capitalizeFirstLetter } from '~/common/string-utils';
import { buildPackagingLabel } from '~/common/packaging-label';
import {
	DEFAULT_MEDICINE_SORT,
	normalizeMedicineSort,
} from '~/common/medicine-sort';

import { getAtcClassKeyByCode } from '~/enums/atc-class';
import {
	MEDICINE_CATEGORY_IDS,
	getMedicineCategoryKey,
} from '~/enums/medicine-category';
import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';
import atcClassI18n from '~/i18n/atc-class';
import medicineCategoryI18n from '~/i18n/medicine-category';
import dispensingModeI18n from '~/i18n/dispensing-mode';
// packagingI18n нужен ради единиц pack_vol_* для localizeStrength
import packagingI18n from '~/i18n/packaging';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		atcClassI18n,
		breadcrumbI18n,
		medicineI18n,
		medicineCategoryI18n,
		dispensingModeI18n,
		packagingI18n,
	]),
});

const filtersStore = useFiltersStore();
const {
	name,
	dispensingModeIds,
	medicineCategoryIds,
	atcClassCodes,
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

// Сортировка живёт в странице, а не в сторе фильтров: она есть только у
// лекарств, и это не фильтр — состав каталога от неё не меняется.
const sort = ref(DEFAULT_MEDICINE_SORT);

watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		sort.value = normalizeMedicineSort(query.sort);
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
	medicineCategoryIds: medicineCategoryIds.value.length
		? medicineCategoryIds.value
		: undefined,
	atcClassCodes: atcClassCodes.value.length ? atcClassCodes.value : undefined,
	atcGroupIds: atcGroupIds.value.length ? atcGroupIds.value : undefined,
	substanceIds: substanceIds.value.length ? substanceIds.value : undefined,
	pharmaFormIds: pharmaFormIds.value.length ? pharmaFormIds.value : undefined,
	manufacturerIds: manufacturerIds.value.length
		? manufacturerIds.value
		: undefined,
	activeOnly: true,
	locale: locale.value,
	page: pageNumber.value,
	sort: sort.value,
}));

// Дефолтный порядок в URL не пишем: у базового листинга должен остаться один
// адрес — чистый /medicines.
const filterQuery = computed(() => ({
	...filtersStore.getRouteParams('medicines').query,
	sort: sort.value === DEFAULT_MEDICINE_SORT ? undefined : sort.value,
}));

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
const itemPackaging = (item: any) =>
	buildPackagingLabel(item, t, locale.value, false);

const getFilterLabel = (
	items: { value: number; label: string }[],
	ids: number[],
) => {
	if (ids.length !== 1) return null;
	return items.find((item) => item.value === ids[0])?.label || null;
};

// Категории статические (enums/medicine-category.ts) — в отличие от остальных
// фильтров, их не нужно тянуть из /filter-options
const categoryOptions = computed(() =>
	MEDICINE_CATEGORY_IDS.map((id) => ({
		value: id as number,
		label: t(getMedicineCategoryKey(id)),
	})),
);

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
	const categoryLabel = getFilterLabel(
		categoryOptions.value,
		medicineCategoryIds.value,
	);
	if (categoryLabel) suffixes.push(categoryLabel);
	// Класс приходит с бейджа на карточке лекарства («все антигистаминные»)
	if (atcClassCodes.value.length === 1) {
		suffixes.push(
			capitalizeFirstLetter(
				t(getAtcClassKeyByCode(atcClassCodes.value[0])),
				locale.value,
			),
		);
	}
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

// Чипы активных фильтров: подписи знает только страница — часть справочников
// приходит из API (вещества, формы, производители), часть лежит в enum'ах
// (категории, классы), а режим отпуска — в i18n.
const activeFilters = computed<
	{ key: string; label: string; remove: () => void }[]
>(() => {
	const chips: { key: string; label: string; remove: () => void }[] = [];
	const opts = filterOptions.value;

	const pushIds = (
		prefix: string,
		ids: Ref<number[]>,
		labelOf: (id: number) => string | null | undefined,
	) => {
		for (const id of ids.value) {
			const label = labelOf(id);
			if (!label) continue;
			chips.push({
				key: `${prefix}:${id}`,
				label,
				remove: () => {
					ids.value = ids.value.filter((value) => value !== id);
				},
			});
		}
	};

	if (name.value) {
		chips.push({
			key: `name:${name.value}`,
			label: name.value,
			remove: () => {
				name.value = '';
			},
		});
	}

	pushIds('dm', dispensingModeIds, (id) => t(`dm_${id}`));
	pushIds('cat', medicineCategoryIds, (id) =>
		categoryOptions.value.find((option) => option.value === id)?.label,
	);

	for (const code of atcClassCodes.value) {
		chips.push({
			key: `class:${code}`,
			label: capitalizeFirstLetter(
				t(getAtcClassKeyByCode(code)),
				locale.value,
			),
			remove: () => {
				atcClassCodes.value = atcClassCodes.value.filter(
					(value) => value !== code,
				);
			},
		});
	}

	// У ATC-группы своего контрола в панели больше нет — чип остаётся
	// единственным способом снять фильтр на старых ссылках из индекса
	pushIds('atc', atcGroupIds, (id) =>
		opts?.atcGroups?.find((option: any) => option.value === id)?.label,
	);
	pushIds('sub', substanceIds, (id) =>
		opts?.substances?.find((option: any) => option.value === id)?.label,
	);
	pushIds('form', pharmaFormIds, (id) =>
		opts?.pharmaForms?.find((option: any) => option.value === id)?.label,
	);
	pushIds('mfg', manufacturerIds, (id) =>
		opts?.manufacturers?.find((option: any) => option.value === id)?.label,
	);

	return chips;
});

const resetFilters = () => {
	name.value = '';
	dispensingModeIds.value = [];
	medicineCategoryIds.value = [];
	atcClassCodes.value = [];
	atcGroupIds.value = [];
	substanceIds.value = [];
	pharmaFormIds.value = [];
	manufacturerIds.value = [];
};

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicinesList.value?.totalCount || 0})`;
});

const isFiltered = computed(() => {
	return (
		!!name.value ||
		dispensingModeIds.value.length > 0 ||
		medicineCategoryIds.value.length > 0 ||
		atcClassCodes.value.length > 0 ||
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
		filter-namespace="medicines"
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicinesList?.items || []"
		:totalCount="medicinesList?.totalCount || 0"
		:isLoading="isLoading"
		:filterQuery="filterQuery"
		:cityIds="[]"
		:showPrice="false"
		:noindex="sort !== DEFAULT_MEDICINE_SORT"
		detailsRouteName="medicines-medicineSlug"
		detailsParamName="medicineSlug"
	>
		<template #active-filters>
			<FilterActiveFilters :items="activeFilters" @reset="resetFilters" />
		</template>

		<template #header-actions>
			<FilterMedicineSortSelect v-model:value="sort" />
		</template>

		<template #filters>
			<FilterName
				v-model:value="name"
				:label="t('MedicineName')"
				:placeholder="t('InsertMedicineName')"
			/>
			<FilterMedicineCategorySelect v-model:value="medicineCategoryIds" />
			<FilterMedicineDispensingModeSelect v-model:value="dispensingModeIds" />
			<!-- ATC level-1 («Respiratory system») из панели убран: класс ниже строго
			     его уточняет и назван человеческими словами. Параметр
			     `?atcGroupIds=` и старые проиндексированные URL продолжают работать -->
			<FilterMedicineAtcClassSelect v-model:value="atcClassCodes" />
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

		<!-- Фасет одного вещества = страница вещества: под списком его справка -->
		<template #tips v-if="medicinesList?.substanceReference">
			<MedicineSubstanceReference
				class="substance-reference-block"
				:substances="[medicinesList.substanceReference]"
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
					<MedicineFormIcon :formId="item.pharmaFormId" :size="24" />
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
/* Справка о веществе идёт под списком — отделяем её от последней карточки */
.substance-reference-block {
	margin-top: var(--spacing-xl);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-secondary);
}

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
