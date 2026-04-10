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
		key: `medicine-details-${route.params.medicineSlug}`,
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
	const dm = med.value?.dispensingMode;
	if (!dm) return false;
	return /bez|OTC|Без рецепта|Rezeptfrei|Reçetesiz/i.test(dm);
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

const tabs = computed(() => {
	const result = [{ id: 'info', label: t('PharmaForm') }];
	if (med.value?.analogs?.length) {
		result.push({ id: 'analogs', label: t('AnalogsTitle') });
	}
	return result;
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		backRouteName="medicines"
		:loadingText="t('LoadingMedicines')"
		:notFoundText="t('NoMedicinesFound')"
		:tabs="tabs"
	>
		<template #hero v-if="med">
			<div class="medicine-hero">
				<h1 class="medicine-name">{{ med.name }}</h1>
				<div class="medicine-subtitle">
					<span v-if="med.pharmaForm">{{ med.pharmaForm }}</span>
					<span v-if="med.strength">, {{ med.strength }}</span>
				</div>
				<div class="medicine-badges">
					<span class="badge" :class="isOTC ? 'badge-otc' : 'badge-rx'">
						{{ isOTC ? t('OTC') : t('Prescription') }}
					</span>
					<span class="badge" :class="med.isActive ? 'badge-active' : 'badge-expired'">
						{{ med.isActive ? t('ActiveLicense') : t('ExpiredLicense') }}
					</span>
				</div>
			</div>
		</template>

		<template #sections v-if="med">
			<!-- Substances -->
			<EntityPageSection
				v-if="med.substances?.length"
				sectionId="substances"
				:title="t('ActiveSubstance')"
			>
				<div class="substance-list">
					<span v-for="sub in med.substances" :key="sub.id" class="substance-tag">
						{{ sub.name }}
					</span>
				</div>
			</EntityPageSection>

			<!-- Details -->
			<EntityPageSection sectionId="info" :title="t('PharmaForm')">
				<div class="details-grid">
					<div v-if="med.pharmaForm" class="detail-row">
						<span class="detail-label">{{ t('PharmaForm') }}</span>
						<span>{{ med.pharmaForm }}</span>
					</div>
					<div v-if="med.strength" class="detail-row">
						<span class="detail-label">{{ t('Strength') }}</span>
						<span>{{ med.strength }}</span>
					</div>
					<div v-if="med.detailPackaging || med.packaging" class="detail-row">
						<span class="detail-label">{{ t('Packaging') }}</span>
						<span>{{ med.detailPackaging || med.packaging }}</span>
					</div>
					<div v-if="med.manufacturer" class="detail-row">
						<span class="detail-label">{{ t('Manufacturer') }}</span>
						<span>{{ med.manufacturer }}<template v-if="med.country">, {{ med.country }}</template></span>
					</div>
					<div v-if="med.dispensingMode" class="detail-row">
						<span class="detail-label">{{ t('DispensingMode') }}</span>
						<span>{{ med.dispensingMode }}</span>
					</div>
					<div v-if="med.atcGroup" class="detail-row">
						<span class="detail-label">{{ t('AtcGroup') }}</span>
						<span>{{ med.atcGroup }} ({{ med.atcCode }})</span>
					</div>
					<div v-if="med.authorizationHolder" class="detail-row">
						<span class="detail-label">{{ t('AuthorizationHolder') }}</span>
						<span>{{ med.authorizationHolder }}</span>
					</div>
					<div v-if="med.authorizationDate" class="detail-row">
						<span class="detail-label">{{ t('AuthorizationDate') }}</span>
						<span>{{ new Date(med.authorizationDate).toLocaleDateString(locale === 'sr-cyrl' ? 'sr-Cyrl' : locale, { year: 'numeric', month: 'long', day: 'numeric' }) }}</span>
					</div>
				</div>
			</EntityPageSection>

			<!-- Analogs -->
			<EntityPageSection
				v-if="med.analogs?.length"
				sectionId="analogs"
				:title="t('AnalogsTitle')"
				:count="med.analogs.length"
			>
				<p class="section-hint">{{ t('AnalogsDescription') }}</p>
				<div class="analogs-list">
					<NuxtLink
						v-for="analog in med.analogs"
						:key="analog.id"
						:to="{ name: 'medicines-medicineSlug', params: { medicineSlug: analog.slug } }"
						class="analog-card"
					>
						<div class="analog-header">
							<span class="analog-name">{{ analog.name }}</span>
							<span
								v-if="analog.dispensingMode"
								class="badge"
								:class="(/bez|OTC|Без рецепта/i).test(analog.dispensingMode) ? 'badge-otc' : 'badge-rx'"
							>
								{{ (/bez|OTC|Без рецепта/i).test(analog.dispensingMode) ? t('OTC') : t('Prescription') }}
							</span>
						</div>
						<span class="analog-details">
							<template v-if="analog.pharmaForm">{{ analog.pharmaForm }}</template>
							<template v-if="analog.strength">, {{ analog.strength }}</template>
						</span>
						<span class="analog-meta">{{ analog.manufacturer }}</span>
					</NuxtLink>
				</div>
			</EntityPageSection>

			<!-- Source -->
			<div v-if="med.detailUrl" class="medicine-source">
				<a :href="med.detailUrl" target="_blank" rel="noopener">
					{{ t('SourceCInMED') }} ↗
				</a>
			</div>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.medicine-hero {
	padding: var(--spacing-xl) 0 var(--spacing-lg);
}

.medicine-name {
	font-size: 2rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	line-height: 1.2;
}

.medicine-subtitle {
	font-size: 1rem;
	color: var(--color-text-secondary);
	margin-top: 6px;
}

.medicine-badges {
	display: flex;
	gap: 8px;
	margin-top: 12px;
}

.badge {
	font-size: 0.8rem;
	font-weight: 500;
	padding: 4px 12px;
	border-radius: 16px;
}

.badge-otc { background: #e8f5e9; color: #2e7d32; }
.badge-rx { background: #fff3e0; color: #e65100; }
.badge-active { background: #e3f2fd; color: #1565c0; }
.badge-expired { background: #fce4ec; color: #c62828; }

.substance-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.substance-tag {
	background: #f0f4ff;
	color: #3b5998;
	padding: 6px 14px;
	border-radius: 16px;
	font-size: 0.9rem;
	font-weight: 500;
}

.details-grid {
	display: flex;
	flex-direction: column;
	gap: 12px;
}

.detail-row {
	display: flex;
	gap: var(--spacing-md);
	font-size: 0.9rem;
	line-height: 1.5;

	@media (max-width: 600px) {
		flex-direction: column;
		gap: 2px;
	}
}

.detail-label {
	min-width: 200px;
	color: var(--color-text-tertiary);
	flex-shrink: 0;
	font-size: 0.85rem;
	text-transform: uppercase;
	letter-spacing: 0.03em;
}

.section-hint {
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	margin: 0 0 16px;
}

.analogs-list {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.analog-card {
	display: flex;
	flex-direction: column;
	gap: 2px;
	padding: 12px 16px;
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

.analog-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 8px;
}

.analog-name {
	font-weight: 600;
	font-size: 0.9rem;
}

.analog-details {
	font-size: 0.8rem;
	color: var(--color-text-secondary);
}

.analog-meta {
	font-size: 0.8rem;
	color: var(--color-text-tertiary);
	display: flex;
	align-items: center;
	gap: 8px;
	margin-top: 2px;
}

.medicine-source {
	margin-top: var(--spacing-2xl);
	padding-top: var(--spacing-md);
	border-top: 1px solid var(--color-border-light);
	font-size: 0.8rem;

	a {
		color: var(--color-text-tertiary);
		text-decoration: none;
		&:hover { color: var(--color-primary); }
	}
}
</style>
