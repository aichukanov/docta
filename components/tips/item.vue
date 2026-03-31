<script setup lang="ts">
type TipType = 'info' | 'emergency';

withDefaults(
	defineProps<{
		type?: TipType;
		text?: string;
	}>(),
	{
		type: 'info',
	},
);
</script>

<template>
	<div :class="['tip-card', `tip-card--${type}`]">
		<div class="tip-icon-wrapper">
			<IconAlertCircle v-if="type === 'emergency'" class="tip-icon" />
			<IconLightbulb v-else class="tip-icon" />
		</div>
		<div class="tip-content">
			<slot>{{ text }}</slot>
		</div>
	</div>
</template>

<style lang="less" scoped>
.tip-card {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-lg);
	border: 1px solid var(--color-border-light);
	position: relative;
	transition: all var(--transition-base);

	&::before {
		content: '';
		position: absolute;
		left: 0;
		top: 0;
		bottom: 0;
		width: 4px;
		border-radius: var(--border-radius-lg) 0 0 var(--border-radius-lg);
	}

	&--info {
		&::before {
			background: var(--color-primary);
		}

		.tip-icon-wrapper {
			background: rgba(79, 70, 229, 0.1);
			color: var(--color-primary);
		}
	}

	&--emergency {
		&::before {
			background: #ef4444;
		}

		.tip-icon-wrapper {
			background: rgba(239, 68, 68, 0.1);
			color: #ef4444;
		}
	}
}

.tip-icon-wrapper {
	flex-shrink: 0;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	border-radius: var(--border-radius-md);
}

.tip-icon {
	width: 22px;
	height: 22px;
}

.tip-content {
	flex: 1;
	font-size: var(--font-size-md);
	color: var(--color-text-primary);
	line-height: 1.65;
	padding-top: 8px;
}
</style>

<style lang="less">
.tip-content a {
	color: var(--color-primary);
	text-decoration: none;
	font-weight: var(--font-weight-medium);
	transition: all var(--transition-base);
	border-bottom: 1px solid transparent;

	&:hover {
		color: var(--color-primary-dark);
		border-bottom-color: var(--color-primary-dark);
	}
}
</style>
