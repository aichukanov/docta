<script setup lang="ts">
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { buildBreadcrumbsSchema } from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicineI18n]),
});

const route = useRoute();

const { pending: isLoading, data: med } = await useFetch(
	'/api/medicines/details',
	{
		key: 'medicine-details',
		method: 'POST',
		body: computed(() => ({
			slug: route.params.medicineSlug,
			locale: locale.value,
		})),
	},
);

const isFound = computed(() => med.value?.id != null);

if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const isOTC = computed(() => {
	const m = med.value?.dispensingMode;
	if (!m) return false;
	return m.includes('bez') || m.includes('OTC') || m === 'Без рецепта' || m === 'Rezeptfrei' || m === 'Reçetesiz';
});

const substanceNames = computed(() =>
	med.value?.substances?.map((s: any) => s.name).join(', ') || '',
);

const pageTitle = computed(() => {
	if (!isFound.value || !med.value) return '';
	const parts = [med.value.name];
	if (med.value.strength) parts.push(med.value.strength);
	return parts.join(' ');
});

const pageDescription = computed(() => {
	if (!isFound.value || !med.value) return '';
	const sub = substanceNames.value;
	if (sub && isOTC.value) {
		return t('MedicineDescriptionOTC', { name: med.value.name, substance: sub });
	}
	if (sub) {
		return t('MedicineDescriptionRx', { name: med.value.name, substance: sub });
	}
	return t('MedicineDescriptionDefault', { name: med.value.name });
});

const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'article',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

// Schema.org
const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (med.value && isFound.value) {
		const url = `${SITE_URL}/medicines/${med.value.slug}`;
		schemaOrgStore.setSchemas([
			buildBreadcrumbsSchema(url, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbMedicines'), url: `${SITE_URL}/medicines` },
				{ name: med.value.name },
			]),
		]);
	}
});
</script>

<template>
	<div class="medicine-page">
		<div v-if="isLoading" class="medicine-loading">
			{{ t('LoadingMedicines') }}
		</div>

		<div v-else-if="!isFound" class="medicine-not-found">
			<p>{{ t('NoMedicinesFound') }}</p>
			<NuxtLink to="/medicines" class="back-link">
				{{ t('ToSearchPage') }}
			</NuxtLink>
		</div>

		<template v-else-if="med">
			<!-- Header -->
			<div class="medicine-header">
				<NuxtLink to="/medicines" class="breadcrumb-back">
					← {{ t('BreadcrumbMedicines') }}
				</NuxtLink>
				<h1 class="medicine-name">{{ med.name }}</h1>
				<div class="medicine-subtitle">
					<span v-if="med.pharmaForm">{{ med.pharmaForm }}</span>
					<span v-if="med.strength">, {{ med.strength }}</span>
				</div>
				<div class="medicine-status">
					<span
						class="status-badge"
						:class="isOTC ? 'badge-otc' : 'badge-rx'"
					>
						{{ isOTC ? t('OTC') : t('Prescription') }}
					</span>
					<span
						class="status-badge"
						:class="med.isActive ? 'badge-active' : 'badge-expired'"
					>
						{{ med.isActive ? t('ActiveLicense') : t('ExpiredLicense') }}
					</span>
				</div>
			</div>

			<!-- Active substance -->
			<section v-if="med.substances?.length" class="medicine-section">
				<h2 class="section-title">{{ t('ActiveSubstance') }}</h2>
				<div class="substance-list">
					<span
						v-for="sub in med.substances"
						:key="sub.id"
						class="substance-tag"
					>
						{{ sub.name }}
					</span>
				</div>
			</section>

			<!-- Details -->
			<section class="medicine-section">
				<div class="details-grid">
					<div v-if="med.pharmaForm" class="detail-row">
						<span class="detail-label">{{ t('PharmaForm') }}</span>
						<span class="detail-value">{{ med.pharmaForm }}</span>
					</div>
					<div v-if="med.strength" class="detail-row">
						<span class="detail-label">{{ t('Strength') }}</span>
						<span class="detail-value">{{ med.strength }}</span>
					</div>
					<div v-if="med.detailPackaging || med.packaging" class="detail-row">
						<span class="detail-label">{{ t('Packaging') }}</span>
						<span class="detail-value">{{ med.detailPackaging || med.packaging }}</span>
					</div>
					<div v-if="med.manufacturer" class="detail-row">
						<span class="detail-label">{{ t('Manufacturer') }}</span>
						<span class="detail-value">
							{{ med.manufacturer }}<template v-if="med.country">, {{ med.country }}</template>
						</span>
					</div>
					<div v-if="med.dispensingMode" class="detail-row">
						<span class="detail-label">{{ t('DispensingMode') }}</span>
						<span class="detail-value">{{ med.dispensingMode }}</span>
					</div>
					<div v-if="med.atcGroup" class="detail-row">
						<span class="detail-label">{{ t('AtcGroup') }}</span>
						<span class="detail-value">{{ med.atcGroup }} ({{ med.atcCode }})</span>
					</div>
					<div v-if="med.authorizationHolder" class="detail-row">
						<span class="detail-label">{{ t('AuthorizationHolder') }}</span>
						<span class="detail-value">{{ med.authorizationHolder }}</span>
					</div>
					<div v-if="med.authorizationDate" class="detail-row">
						<span class="detail-label">{{ t('AuthorizationDate') }}</span>
						<span class="detail-value">{{ med.authorizationDate }}</span>
					</div>
					<div v-if="med.authorizationNumber" class="detail-row">
						<span class="detail-label">{{ t('AuthorizationNumber') }}</span>
						<span class="detail-value">{{ med.authorizationNumber }}</span>
					</div>
				</div>
			</section>

			<!-- Analogs -->
			<section v-if="med.analogs?.length" class="medicine-section">
				<h2 class="section-title">{{ t('AnalogsTitle') }}</h2>
				<p class="section-subtitle">{{ t('AnalogsDescription') }}</p>
				<div class="analogs-list">
					<NuxtLink
						v-for="analog in med.analogs"
						:key="analog.id"
						:to="`/medicines/${analog.slug}`"
						class="analog-card"
					>
						<span class="analog-name">{{ analog.name }}</span>
						<span class="analog-details">
							<template v-if="analog.pharmaForm">{{ analog.pharmaForm }}</template>
							<template v-if="analog.strength">, {{ analog.strength }}</template>
						</span>
						<span class="analog-meta">
							{{ analog.manufacturer }}
							<span
								v-if="analog.dispensingMode"
								class="analog-badge"
								:class="analog.dispensingMode.includes('bez') || analog.dispensingMode.includes('OTC') || analog.dispensingMode === 'Без рецепта' ? 'badge-otc' : 'badge-rx'"
							>
								{{ analog.dispensingMode.includes('bez') || analog.dispensingMode.includes('OTC') || analog.dispensingMode === 'Без рецепта' ? t('OTC') : t('Prescription') }}
							</span>
						</span>
					</NuxtLink>
				</div>
			</section>

			<!-- Source -->
			<div v-if="med.detailUrl" class="medicine-source">
				<a :href="med.detailUrl" target="_blank" rel="noopener">
					{{ t('SourceCInMED') }} ↗
				</a>
			</div>
		</template>
	</div>
</template>

<style lang="less" scoped>
.medicine-page {
	max-width: 800px;
	margin: 0 auto;
	padding: var(--spacing-lg);
}

.medicine-loading,
.medicine-not-found {
	text-align: center;
	padding: var(--spacing-2xl);
	color: var(--color-text-secondary);
}

.back-link {
	color: var(--color-primary);
}

.breadcrumb-back {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	text-decoration: none;

	&:hover {
		color: var(--color-primary);
	}
}

.medicine-header {
	margin-bottom: var(--spacing-xl);
}

.medicine-name {
	font-size: 1.75rem;
	font-weight: 700;
	margin: var(--spacing-sm) 0 0;
	line-height: 1.2;
}

.medicine-subtitle {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin-top: var(--spacing-xs);
}

.medicine-status {
	display: flex;
	gap: var(--spacing-xs);
	margin-top: var(--spacing-sm);
}

.status-badge {
	font-size: var(--font-size-sm);
	padding: 2px var(--spacing-sm);
	border-radius: var(--border-radius-sm);
}

.badge-otc { background: #e8f5e9; color: #2e7d32; }
.badge-rx { background: #fff3e0; color: #e65100; }
.badge-active { background: #e3f2fd; color: #1565c0; }
.badge-expired { background: #fce4ec; color: #c62828; }

.medicine-section {
	margin-bottom: var(--spacing-xl);
}

.section-title {
	font-size: 1.1rem;
	font-weight: 600;
	margin: 0 0 var(--spacing-sm);
}

.section-subtitle {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	margin: 0 0 var(--spacing-md);
}

.substance-list {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

.substance-tag {
	background: var(--color-bg-secondary);
	padding: var(--spacing-xs) var(--spacing-sm);
	border-radius: var(--border-radius-sm);
	font-size: var(--font-size-sm);
}

.details-grid {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.detail-row {
	display: flex;
	gap: var(--spacing-md);

	@media (max-width: 600px) {
		flex-direction: column;
		gap: 2px;
	}
}

.detail-label {
	min-width: 180px;
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	flex-shrink: 0;
}

.detail-value {
	font-size: var(--font-size-sm);
}

.analogs-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.analog-card {
	display: flex;
	flex-direction: column;
	padding: var(--spacing-sm) var(--spacing-md);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-sm);
	text-decoration: none;
	color: inherit;
	transition: border-color 0.15s;

	&:hover {
		border-color: var(--color-primary);
	}
}

.analog-name {
	font-weight: 600;
	font-size: var(--font-size-sm);
}

.analog-details {
	font-size: var(--font-size-xs);
	color: var(--color-text-secondary);
}

.analog-meta {
	font-size: var(--font-size-xs);
	color: var(--color-text-tertiary);
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.analog-badge {
	font-size: 10px;
	padding: 1px var(--spacing-xs);
	border-radius: var(--border-radius-sm);
}

.medicine-source {
	margin-top: var(--spacing-xl);
	padding-top: var(--spacing-md);
	border-top: 1px solid var(--color-border-light);
	font-size: var(--font-size-xs);

	a {
		color: var(--color-text-tertiary);
		text-decoration: none;
		&:hover { color: var(--color-primary); }
	}
}
</style>
