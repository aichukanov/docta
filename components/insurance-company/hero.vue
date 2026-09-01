<script setup lang="ts">
import IconMapPin from '~/components/icon/map-pin.vue';
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
				<IconMapPin aria-hidden="true" size="1em" />
				<span>{{ branchesLabel }}</span>
			</div>
		</div>
	</header>
</template>

<style lang="less" scoped>
.insurance-hero {
	display: flex;
	align-items: flex-start;
	gap: var(--kit-spacing-lg);
	padding: var(--kit-spacing-xl) 0;
}

.insurance-hero__info {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	min-width: 0;
}

.insurance-hero__name {
	font-size: var(--kit-font-size-4xl);
	font-weight: 700;
	color: var(--kit-color-text-primary);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	line-height: 1.2;
}

.insurance-hero__local-name {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.insurance-hero__meta {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-secondary);

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
	}
}

@media (max-width: 500px) {
	.insurance-hero__name {
		font-size: var(--kit-font-size-3xl);
	}
}
</style>
