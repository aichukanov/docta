<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicServiceItem } from '~/interfaces/clinic';

const props = defineProps<{
	service: ClinicServiceItem;
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const { t, locale } = useI18n();

const serviceLink = computed(() => ({
	name: props.detailsRouteName || 'services-serviceId',
	params: { [props.detailsParamName || 'serviceId']: props.service.id },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="service-wrapper">
		<div class="service-info">
			<h3 class="service-name">
				<NuxtLink :to="serviceLink" class="service-name-link">
					{{ service.name }}
				</NuxtLink>
			</h3>
			<div v-if="service.localName" class="service-local-name">
				{{ service.localName }}
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.service-wrapper {
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-sm) var(--spacing-md);
	transition: border-color var(--transition-base);

	&:hover {
		border-color: var(--color-primary);
	}

	.service-info {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
	}

	.service-name {
		margin: 0;
		font-size: var(--font-size-md);
		font-weight: 500;
		line-height: 1.3;
		word-wrap: break-word;
		overflow-wrap: break-word;
	}

	.service-name-link {
		color: var(--color-primary);
		text-decoration: none;
	}

	.service-name-link:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}

	.service-local-name {
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-medium);
		color: var(--color-text-secondary);
		margin-top: var(--spacing-xs);
	}
}
</style>
