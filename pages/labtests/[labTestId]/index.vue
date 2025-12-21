<script setup lang="ts">
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import labTestI18n from '~/i18n/labtest';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';
import { buildBreadcrumbsSchema } from '~/common/schema-org-builders';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		labTestI18n,
		cityI18n,
		labTestCategoryI18n,
	]),
});

const route = useRoute();

const { pending: isLoading, data: labTestData } = await useFetch(
	'/api/labtests/details',
	{
		key: 'labtest-details',
		method: 'POST',
		body: computed(() => ({
			labTestId: route.params.labTestId,
			locale: locale.value,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const isFound = computed(() => labTestData.value?.id != null);

const labTestClinics = computed(() => {
	if (!isFound.value || !clinicsStore.clinics) {
		return [];
	}

	return clinicsStore.clinics.filter((clinic) =>
		labTestData.value?.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	const usedCities: { [key: string]: true } = {};
	const uniqueCities = labTestClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return null;
			}
			usedCities[clinic.cityId] = true;
			return clinic.cityId;
		})
		.filter(Boolean);

	const locationText =
		uniqueCities.length === 1
			? t(`city_${uniqueCities[0]}`)
			: t('InMontenegro');

	const categoryText = labTestData.value?.categoryIds?.length
		? t(`lab_test_category_${labTestData.value.categoryIds[0]}_title`)
		: '';

	return categoryText
		? `${labTestData.value?.name} | ${categoryText} | ${locationText}`
		: `${labTestData.value?.name} | ${locationText}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !labTestData.value || !labTestClinics.value) {
		return '';
	}

	const { name, originalName } = labTestData.value;
	const displayName =
		originalName && originalName !== name ? `${name} (${originalName})` : name;

	const usedCities: { [key: string]: true } = {};
	const citiesText = labTestClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean)
		.join(', ');

	return citiesText
		? t('LabTestDescriptionCity', { name: displayName, city: citiesText })
		: t('LabTestDescriptionDefault', { name: displayName });
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});

// Schema.org for lab test details
const schemaOrgStore = useSchemaOrgStore();
const runtimeConfig = useRuntimeConfig();
watchEffect(() => {
	if (labTestData.value && isFound.value) {
		const siteUrl = runtimeConfig.public.siteUrl;
		const testUrl = `${siteUrl}/labtests/${labTestData.value.id}`;
		const alternateName = [
			labTestData.value.originalName,
			...(labTestData.value.synonyms || []),
		]
			.filter(Boolean)
			.join(', ');

		schemaOrgStore.setSchemas([
			{
				'@type': 'WebPage',
				'@id': `${testUrl}#webpage`,
				'url': testUrl,
				'name': labTestData.value.name,
				'inLanguage': locale.value,
				'mainEntity': { '@id': `${testUrl}#medicaltest` },
			},
			{
				'@type': 'MedicalTest',
				'@id': `${testUrl}#medicaltest`,
				'mainEntityOfPage': testUrl,
				'url': testUrl,
				'name': labTestData.value.name,
				'alternateName': alternateName || undefined,
				'availableService': labTestClinics.value.map((clinic) => ({
					'@type': 'MedicalOrganization',
					'name': clinic.name,
				})),
			},
			buildBreadcrumbsSchema(testUrl, [
				{ name: t('BreadcrumbHome'), url: `${siteUrl}/` },
				{ name: t('BreadcrumbLabTests'), url: `${siteUrl}/labtests` },
				{ name: labTestData.value.name },
			]),
		]);
	}
});
</script>

<template>
	<DetailsPage
		:isLoading="isLoading || clinicsStore.isLoadingClinics || false"
		:isFound="isFound"
		:clinics="labTestClinics"
		:clinicPrices="labTestData?.clinicPrices"
		backRouteName="labtests"
		:loadingText="t('LoadingLabTests')"
		:notFoundText="t('NoLabTestsFound')"
	>
		<template #info v-if="labTestData">
			<div class="lab-test-header">
				<h1 class="lab-test-name">{{ labTestData.name }}</h1>
				<div v-if="labTestData.originalName" class="lab-test-original">
					{{ labTestData.originalName }}
				</div>
				<div v-if="labTestData.synonyms?.length" class="lab-test-synonyms">
					<span class="synonyms-label">{{ t('Synonyms') }}:</span>
					<span class="synonyms-list">{{
						labTestData.synonyms.join(', ')
					}}</span>
				</div>
				<div v-if="labTestData.categoryIds?.length" class="lab-test-categories">
					<span
						v-for="categoryId in labTestData.categoryIds"
						:key="categoryId"
						class="category-tag"
					>
						{{ t(`lab_test_category_${categoryId}`) }}
					</span>
				</div>
			</div>
		</template>
	</DetailsPage>
</template>

<style lang="less" scoped>
.lab-test-header {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	box-shadow: var(--shadow-xs);

	.lab-test-name {
		font-size: 2rem;
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family: system-ui, -apple-system, sans-serif;
	}

	.lab-test-original {
		font-size: 1.1rem;
		color: #6b7280;
		margin-top: var(--spacing-sm);
		font-style: italic;
	}

	.lab-test-categories {
		display: flex;
		flex-wrap: wrap;
		gap: var(--spacing-xs);
		margin-top: var(--spacing-md);

		.category-tag {
			display: inline-block;
			font-size: 0.85rem;
			color: var(--color-primary);
			background: rgba(79, 70, 229, 0.08);
			padding: 4px 12px;
			border-radius: 4px;
			border: 1px solid rgba(79, 70, 229, 0.15);
		}
	}

	.lab-test-synonyms {
		font-size: 0.95rem;
		color: #6b7280;
		margin-top: var(--spacing-md);

		.synonyms-label {
			color: #9ca3af;
			margin-right: var(--spacing-xs);
		}

		.synonyms-list {
			color: #6b7280;
		}
	}
}
</style>
