<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import type { InsuranceCompanyData } from '~/interfaces/insurance-company';

defineProps<{
	company: InsuranceCompanyData;
	branchesLabel: string;
}>();
</script>

<template>
	<header class="insurance-hero">
		<ClinicLogo
			:logoUrl="company.logoUrl"
			:name="company.name"
			:size="80"
			zoomable
			loading="eager"
		/>
		<div class="insurance-hero__info">
			<h1 class="insurance-hero__name">{{ company.name }}</h1>
			<span v-if="company.localName" class="insurance-hero__local-name">{{
				company.localName
			}}</span>
			<div class="insurance-hero__meta">
				<LocationFilled aria-hidden="true" />
				<span>{{ branchesLabel }}</span>
			</div>
		</div>
	</header>
</template>

<style lang="less" scoped>
.insurance-hero {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-lg);
	padding: var(--spacing-xl) 0;
}

.insurance-hero__info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	min-width: 0;
}

.insurance-hero__name {
	font-size: var(--font-size-4xl);
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	line-height: 1.2;
}

.insurance-hero__local-name {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.insurance-hero__meta {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
	}
}

@media (max-width: 500px) {
	.insurance-hero__name {
		font-size: var(--font-size-3xl);
	}
}
</style>
