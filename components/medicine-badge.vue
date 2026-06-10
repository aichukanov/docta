<template>
	<span
		v-if="dispensingModeId"
		class="medicine-badge"
		:class="`medicine-badge--${badge}`"
		:title="t(`dm_${dispensingModeId}`)"
	>
		{{ t(`dm_badge_${badge}`) }}
	</span>
</template>

<script setup lang="ts">
import { getBadgeType } from '~/enums/dispensing-mode';
import dispensingModeI18n from '~/i18n/dispensing-mode';

const props = defineProps<{
	dispensingModeId: number | null | undefined;
}>();

const { t } = useI18n(dispensingModeI18n);

const badge = computed(() => getBadgeType(props.dispensingModeId));
</script>

<style lang="less" scoped>
.medicine-badge {
	display: inline-block;
	font-size: var(--font-size-sm);
	font-weight: 500;
	padding: var(--spacing-xs) var(--spacing-md);
	border-radius: 16px;
	white-space: nowrap;

	&--otc {
		background: #e8f5e9;
		color: #2e7d32;
	}

	&--rx {
		background: #fff3e0;
		color: #ba5000;
	}

	&--hospital {
		background: var(--color-bg-tertiary);
		color: var(--color-text-secondary);
	}

	&--restricted {
		background: #f3e5f5;
		color: #6a1b9a;
	}
}
</style>
