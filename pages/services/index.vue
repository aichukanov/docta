<script setup lang="ts">
import { combineI18nMessages } from '~/i18n/utils';
import {
	buildEntityListSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import { getRegionalQuery } from '~/common/url-utils';

definePageMeta({ keepalive: true });

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		cityI18n,
		medicalServiceI18n,
		medicalServiceCategoryI18n,
	]),
});

const {
	cityIds,
	serviceCategoryIds,
	clinicIds,
	name,
	updateFromRoute,
	getRouteParams,
} = useFilters();

const route = useRoute();
watch(
	() => route.query,
	(query) => {
		updateFromRoute(query);
	},
	{ immediate: true },
);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	serviceCategoryIds: serviceCategoryIds.value,
	clinicIds: clinicIds.value,
	name: name.value,
	locale: locale.value,
}));

const filterQuery = computed(() => getRouteParams().query);

const clinicsStore = useClinicsStore();

const [{ pending: isLoadingMedicalServices, data: medicalServicesList }] =
	await Promise.all([
		useFetch('/api/services/list', {
			key: 'services-list',
			method: 'POST',
			body: filterList,
		}),
		clinicsStore.fetchClinics(),
	]);

const clinicName = computed(() => {
	if (clinicIds.value.length === 1) {
		const clinic = clinicsStore.clinics.find(
			(c) => c.id === clinicIds.value[0],
		);
		return clinic?.name || '';
	}
	return '';
});

const categoryName = computed(() => {
	if (serviceCategoryIds.value.length === 1) {
		return t(`medical_service_category_${serviceCategoryIds.value[0]}`);
	}
	return '';
});

const pageTitle = computed(() => {
	if (serviceCategoryIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			if (clinicIds.value.length === 1) {
				return t('MedicalServicesCategoryCityClinic', {
					category: categoryName.value,
					city: t(`city_${cityIds.value[0]}_genitive`),
					clinic: clinicName.value,
				});
			}
			return t('MedicalServicesCategoryCity', {
				category: categoryName.value,
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		if (clinicIds.value.length === 1) {
			return t('MedicalServicesCategoryClinic', {
				category: categoryName.value,
				clinic: clinicName.value,
			});
		}
		return t('MedicalServicesCategory', {
			category: categoryName.value,
		});
	}

	if (cityIds.value.length === 1) {
		if (clinicIds.value.length === 1) {
			return t('MedicalServicesCityClinic', {
				city: t(`city_${cityIds.value[0]}_genitive`),
				clinic: clinicName.value,
			});
		}
		return t('MedicalServicesCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}

	if (clinicIds.value.length === 1) {
		return t('MedicalServicesClinic', {
			clinic: clinicName.value,
		});
	}

	return t('MedicalServices');
});

const pageTitleWithCount = computed(() => {
	return `${pageTitle.value} (${medicalServicesList.value?.totalCount || 0})`;
});

const pageDescription = computed(() => {
	if (serviceCategoryIds.value.length === 1) {
		if (cityIds.value.length === 1) {
			return t('MedicalServicesListDescriptionCategoryCity', {
				category: categoryName.value,
				city: t(`city_${cityIds.value[0]}_genitive`),
			});
		}
		return t('MedicalServicesListDescriptionCategory', {
			category: categoryName.value,
		});
	}

	if (cityIds.value.length === 1) {
		return t('MedicalServicesListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('MedicalServicesListDescription');
});

// Schema.org for medical services list
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
	return (
		cityIds.value.length > 0 ||
		serviceCategoryIds.value.length > 0 ||
		clinicIds.value.length > 0 ||
		!!name.value
	);
});

watchEffect(() => {
	if (medicalServicesList.value) {
		const pageUrl = `${SITE_URL}${route.fullPath}`;
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitle.value,
				description: pageDescription.value,
				totalCount: medicalServicesList.value.totalCount,
				items: medicalServicesList.value.items,
				buildPath: (service) => `/services/${service.id}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbServices') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="medicalServicesList?.items || []"
		:totalCount="medicalServicesList?.totalCount || 0"
		:isLoading="isLoadingMedicalServices"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		detailsRouteName="services-serviceId"
		detailsParamName="serviceId"
	>
		<template #filters>
			<FilterName
				:label="t('ServiceName')"
				:placeholder="t('InsertServiceName')"
			/>
			<FilterCitySelect v-model:value="cityIds" />
			<FilterServiceCategorySelect v-model:value="serviceCategoryIds" />
			<FilterClinicSelect v-model:value="clinicIds" />
		</template>

		<template #item="{ item }">
			<div class="service-info">
				<h2 class="service-name">
					<NuxtLink
						:to="{
							name: 'services-serviceId',
							params: { serviceId: item.id },
							query: getRegionalQuery(locale),
						}"
						class="service-name-link"
					>
						{{ item.name }}
					</NuxtLink>
				</h2>
				<div v-if="item.localName" class="service-local-name">
					{{ item.localName }}
				</div>
				<div v-if="item.categoryIds?.length" class="service-categories">
					<span
						v-for="categoryId in item.categoryIds"
						:key="categoryId"
						class="category-tag"
					>
						{{ t(`medical_service_category_${categoryId}`) }}
					</span>
				</div>
			</div>
		</template>
	</ListPage>
</template>

<style lang="less" scoped>
.service-info {
	padding: 0 var(--spacing-xs);

	.service-name {
		font-size: 1.25rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
		word-break: break-word;

		.service-name-link {
			color: var(--color-primary);
			text-decoration: none;

			&:hover {
				color: var(--color-primary-dark);
				text-decoration: underline;
			}
		}
	}

	.service-local-name {
		font-size: 0.9rem;
		color: #6b7280;
		margin-top: var(--spacing-xs);
		font-style: italic;
		word-break: break-word;
	}

	.service-categories {
		display: flex;
		flex-wrap: wrap;
		gap: var(--spacing-xs);
		margin-top: var(--spacing-sm);

		.category-tag {
			display: inline-block;
			font-size: 0.75rem;
			color: var(--color-primary);
			background: rgba(79, 70, 229, 0.08);
			padding: 2px 8px;
			border-radius: 4px;
			border: 1px solid rgba(79, 70, 229, 0.15);
		}
	}
}
</style>
