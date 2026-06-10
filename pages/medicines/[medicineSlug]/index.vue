<script setup lang="ts">
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { buildPackagingLabel } from '~/common/packaging-label';
import { localizeStrength } from '~/common/strength-label';
import {
	buildBreadcrumbsSchema,
	buildMedicineSchema,
} from '~/common/schema-org-builders';
import breadcrumbI18n from '~/i18n/breadcrumb';
import medicineI18n from '~/i18n/medicine';
import packagingI18n from '~/i18n/packaging';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n, medicineI18n, packagingI18n]),
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

const isOTC = computed(() => med.value?.dispensingModeId === 2);

const substanceNames = computed(
	() => med.value?.substances?.map((s: any) => s.name).join(', ') || '',
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
		return t('MedicineDescriptionOTC', {
			name: med.value.name,
			substance: sub,
		});
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
			...buildMedicineSchema({
				siteUrl: SITE_URL,
				slug: med.value.slug,
				name: med.value.name,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				substances: med.value.substances?.map((s: any) => s.name),
				pharmaForm: med.value.pharmaForm,
				strength: med.value.strength,
				manufacturer: med.value.manufacturer,
				country: med.value.country,
				dispensingModeId: med.value.dispensingModeId,
				atcCode: med.value.atcCode,
				isActive: med.value.isActive,
				detailUrl: med.value.detailUrl,
			}),
			buildBreadcrumbsSchema(url, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbMedicines'), url: `${SITE_URL}/medicines` },
				{ name: med.value.name },
			]),
		]);
	}
});

// «Другие дозировки» — тот же бренд (совпадает название); «Аналоги» — точно
// тот же состав действующих веществ (matchType из API); «Комбинированные» —
// весь состав текущего препарата плюс дополнительные вещества; «Компоненты
// по отдельности» — частичное совпадение состава (API сортирует от
// монопрепаратов к комбинациям)
const analogSections = computed(() => {
	const medName = (med.value?.name || '').trim().toLowerCase();
	const analogs = med.value?.analogs || [];
	const isSameBrand = (a: any) =>
		(a.name || '').trim().toLowerCase() === medName;
	const others = analogs.filter((a: any) => !isSameBrand(a));
	return [
		{
			id: 'dosages',
			title: t('OtherDosagesTitle'),
			hint: t('OtherDosagesDescription'),
			items: analogs.filter(isSameBrand),
		},
		{
			id: 'analogs',
			title: t('AnalogsTitle'),
			hint: t('AnalogsDescription'),
			items: others.filter((a: any) => a.matchType === 'exact'),
		},
		{
			id: 'combo',
			title: t('CombinationsTitle'),
			hint: t('CombinationsDescription'),
			items: others.filter((a: any) => a.matchType === 'superset'),
		},
		{
			id: 'components',
			title: t('ComponentsTitle'),
			hint: t('ComponentsDescription'),
			items: others.filter((a: any) => a.matchType === 'partial'),
		},
	].filter((section) => section.items.length > 0);
});

const tabs = computed(() => {
	const result = [{ id: 'info', label: t('PharmaForm') }];
	for (const section of analogSections.value) {
		result.push({ id: section.id, label: section.title });
	}
	return result;
});

// Локализованная подпись упаковки из структурных полей (сырой текст реестра
// не выводим). С разбивкой «(2 × 10)» на детальной странице.
const packagingLabel = computed(() =>
	med.value ? buildPackagingLabel(med.value, t, true) : '',
);
// Компактная подпись (без разбивки) для строки-подзаголовка hero
const packagingShort = computed(() =>
	med.value ? buildPackagingLabel(med.value, t, false) : '',
);
const analogPackaging = (analog: any) => buildPackagingLabel(analog, t, false);

// Дозировка с локализованными единицами («500mg» → «500 мг» для ru)
const strengthLabel = computed(() => localizeStrength(med.value?.strength, t));
const analogStrength = (analog: any) => localizeStrength(analog.strength, t);
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
				<div class="medicine-hero-icon">
					<MedicineFormIcon :formSrc="med.pharmaFormSrc" :size="32" />
				</div>
				<div class="medicine-hero-main">
					<h1 class="medicine-name">{{ med.name }}</h1>
					<div class="medicine-subtitle">
						<span v-if="med.strength">{{ strengthLabel }}</span>
						<template v-if="med.strength && packagingShort"> · </template>
						<span v-if="packagingShort">{{ packagingShort }}</span>
						<template v-if="(med.strength || packagingShort) && med.pharmaForm">
							·
						</template>
						<span v-if="med.pharmaForm" class="medicine-form">{{
							med.pharmaForm
						}}</span>
					</div>
					<div class="medicine-badges">
						<MedicineBadge :dispensingModeId="med.dispensingModeId" />
						<span
							class="badge"
							:class="med.isActive ? 'badge-active' : 'badge-expired'"
						>
							{{ med.isActive ? t('ActiveLicense') : t('ExpiredLicense') }}
						</span>
					</div>
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
					<NuxtLink
						v-for="sub in med.substances"
						:key="sub.id"
						:to="{ name: 'medicines', query: { substanceIds: sub.id } }"
						class="substance-tag"
					>
						{{ sub.name }}
					</NuxtLink>
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
						<span>{{ strengthLabel }}</span>
					</div>
					<div v-if="packagingLabel" class="detail-row">
						<span class="detail-label">{{ t('Packaging') }}</span>
						<span>{{ packagingLabel }}</span>
					</div>
					<div v-if="med.manufacturer" class="detail-row">
						<span class="detail-label">{{ t('Manufacturer') }}</span>
						<span>
							<NuxtLink
								v-if="med.manufacturerId"
								:to="{
									name: 'medicines',
									query: { manufacturerIds: med.manufacturerId },
								}"
								class="detail-link"
								>{{ med.manufacturer }}</NuxtLink
							><template v-else>{{ med.manufacturer }}</template
							><template v-if="med.country">, {{ med.country }}</template>
						</span>
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
						<span>{{
							new Date(med.authorizationDate).toLocaleDateString(
								locale === 'sr-cyrl' ? 'sr-Cyrl' : locale,
								{ year: 'numeric', month: 'long', day: 'numeric' },
							)
						}}</span>
					</div>
				</div>
			</EntityPageSection>

			<!-- Other dosages / Analogs -->
			<EntityPageSection
				v-for="section in analogSections"
				:key="section.id"
				:sectionId="section.id"
				:title="section.title"
				:count="section.items.length"
			>
				<p class="section-hint">{{ section.hint }}</p>
				<div class="analogs-list">
					<NuxtLink
						v-for="analog in section.items"
						:key="analog.id"
						:to="{
							name: 'medicines-medicineSlug',
							params: { medicineSlug: analog.slug },
						}"
						class="analog-card"
					>
						<div class="analog-header">
							<MedicineFormIcon
								class="analog-form-icon"
								:formSrc="analog.pharmaFormSrc"
								:size="20"
								color="var(--color-text-muted)"
							/>
							<span class="analog-name">{{ analog.name }}</span>
							<MedicineBadge :dispensingModeId="analog.dispensingModeId" />
						</div>
						<span
							v-if="analog.strength || analogPackaging(analog)"
							class="analog-key"
						>
							<span v-if="analog.strength" class="analog-strength">{{
								analogStrength(analog)
							}}</span>
							<template v-if="analog.strength && analogPackaging(analog)">
								·
							</template>
							<span v-if="analogPackaging(analog)">{{
								analogPackaging(analog)
							}}</span>
						</span>
						<span v-if="analog.substances" class="analog-substances">
							{{ analog.substances }}
						</span>
						<span v-if="analog.pharmaForm" class="analog-form">{{
							analog.pharmaForm
						}}</span>
						<span class="analog-meta">{{ analog.manufacturer }}</span>
					</NuxtLink>
				</div>
			</EntityPageSection>

			<!-- Source -->
			<div class="medicine-source">
				<div class="source-text">
					{{ t('SourceCInMED') }}
					—
					<a
						href="https://www.cinmed.me"
						target="_blank"
						rel="noopener noreferrer"
						class="source-link"
					>
						{{ t('SourceCInMEDSite') }}&nbsp;&nearr;
					</a>
				</div>
				<div v-if="med.updatedAt" class="source-updated">
					{{
						t('SourceCInMEDUpdated', {
							date: new Date(med.updatedAt).toLocaleDateString(
								locale === 'sr-cyrl' ? 'sr-Cyrl' : locale,
								{ year: 'numeric', month: 'long' },
							),
						})
					}}
				</div>
			</div>
		</template>
	</EntityPage>
</template>

<style lang="less" scoped>
.medicine-hero {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-lg);
	padding: var(--spacing-xl) 0 var(--spacing-lg);
}

.medicine-hero-icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 56px;
	height: 56px;
	flex-shrink: 0;
	background: var(--color-primary-bg);
	border-radius: var(--border-radius-lg);
	color: var(--color-primary);
}

.medicine-hero-main {
	flex: 1;
	min-width: 0;
}

.medicine-name {
	font-size: var(--font-size-4xl);
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	line-height: 1.2;
}

.medicine-subtitle {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin-top: 6px;
}

/* Форма — общий контекст, приглушаем цветом (без жирности) */
.medicine-subtitle .medicine-form {
	color: var(--color-text-muted);
}

.medicine-badges {
	display: flex;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-md);
}

.badge {
	font-size: var(--font-size-sm);
	font-weight: 500;
	padding: var(--spacing-xs) var(--spacing-md);
	border-radius: 16px;
}

.badge-active {
	background: #e3f2fd;
	color: #1565c0;
}
.badge-expired {
	background: #fce4ec;
	color: #c62828;
}

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
	font-size: var(--font-size-sm);
	font-weight: 500;
	text-decoration: none;
	transition: background-color 0.15s ease;
}

.substance-tag:hover {
	background: #e0e8fc;
}

.details-grid {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.detail-row {
	display: flex;
	gap: var(--spacing-md);
	font-size: var(--font-size-base);
	line-height: 1.5;

	@media (max-width: 600px) {
		flex-direction: column;
		gap: 2px;
	}
}

.detail-label {
	min-width: 200px;
	color: var(--color-text-muted);
	flex-shrink: 0;
	font-size: var(--font-size-sm);
	text-transform: uppercase;
	letter-spacing: 0.03em;
}

.detail-link {
	color: var(--color-primary);
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}
}

.section-hint {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	margin: 0 0 var(--spacing-lg);
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
	transition:
		border-color 0.15s,
		box-shadow 0.15s;

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

.analog-form-icon {
	flex-shrink: 0;
}

.analog-name {
	flex: 1;
	min-width: 0;
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-base);
}

/* Различители (дозировка + фасовка) — заметный вес, строка-якорь */
.analog-key {
	font-size: var(--font-size-base);
	color: var(--color-text-primary);
}

/* Состав комбинации — ключевой различитель в секции комбо, поэтому темнее
   и выше формы выпуска */
.analog-substances {
	font-size: var(--font-size-sm);
	font-style: italic;
	color: var(--color-text-secondary);
}

/* Форма — общий контекст линейки, приглушаем */
.analog-form {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

/* muted, не tertiary: 12px тоном #94a3b8 не проходит WCAG AA (≈2.6:1) */
.analog-meta {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	margin-top: 6px;
}

.medicine-source {
	margin-top: var(--spacing-2xl);
	padding: var(--spacing-md) var(--spacing-lg);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-light);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.source-text {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	line-height: 1.4;
}

.source-link {
	color: var(--color-primary);
	text-decoration: none;
	font-weight: 500;

	&:hover {
		text-decoration: underline;
	}
}

.source-updated {
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}
</style>
