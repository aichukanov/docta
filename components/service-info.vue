<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorData } from '~/interfaces/doctor';

const props = withDefaults(
	defineProps<{
		doctor: DoctorData;
		short?: boolean;
	}>(),
	{
		short: false,
	},
);

const { t, locale } = useI18n();

const serviceLink = computed(() => ({
	name: 'services-serviceId',
	params: { serviceId: props.service.id },
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
		</div>
	</div>
</template>

<style scoped lang="less">
.service-wrapper {
	display: flex;
	gap: var(--spacing-2xl);

	.service-info {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-sm);
		flex: 1;
	}

	.service-name {
		margin: 0;
		font-size: var(--font-size-2xl);
		font-weight: 700;
		color: var(--color-text-primary);
		line-height: 1.2;
		letter-spacing: -0.01em;
	}

	.service-name-link {
		color: var(--color-primary);
		text-decoration: none;
	}

	.service-name-link:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}
}

@media (max-width: 500px) {
	.service-wrapper {
		gap: var(--spacing-md);
	}
}

@media (max-width: 300px) {
	.service-wrapper {
		flex-direction: column;
		padding: 0 var(--spacing-sm);
	}
}
</style>
