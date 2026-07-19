<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { InsuranceCompanyListItem } from '~/interfaces/insurance-company';

const props = defineProps<{
	company: InsuranceCompanyListItem;
	branchesLabel: string;
}>();

const { locale } = useI18n();

const detailLink = computed(() => ({
	name: 'insurance-companies-companySlug',
	params: { companySlug: props.company.slug },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<NuxtLink :to="detailLink" class="insurance-summary-card">
		<ClinicLogo :logoUrl="company.logoUrl" :name="company.name" :size="56" />
		<div class="insurance-summary-card__info">
			<h2 class="insurance-summary-card__name">{{ company.name }}</h2>
			<span v-if="company.localName" class="insurance-summary-card__local-name">{{
				company.localName
			}}</span>
			<span class="insurance-summary-card__meta">{{ branchesLabel }}</span>
		</div>
	</NuxtLink>
</template>

<style scoped lang="less">
.insurance-summary-card {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-lg);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-lg);
	text-decoration: none;
	transition: box-shadow 0.15s ease;

	&:hover {
		box-shadow: var(--shadow-hover);
	}
}

.insurance-summary-card__info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	min-width: 0;
}

.insurance-summary-card__name {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
}

.insurance-summary-card__local-name {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.insurance-summary-card__meta {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}
</style>
