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
	gap: var(--kit-spacing-lg);
	padding: var(--kit-spacing-lg) var(--kit-spacing-xl);
	background: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-lg);
	border: 1px solid var(--kit-color-border-light);
	position: relative;
	transition: all var(--kit-transition-base);

	&::before {
		content: '';
		position: absolute;
		left: 0;
		top: 0;
		bottom: 0;
		width: 4px;
		border-radius: var(--kit-border-radius-lg) 0 0 var(--kit-border-radius-lg);
	}

	&--info {
		&::before {
			background: var(--kit-color-primary);
		}

		.tip-icon-wrapper {
			background: rgba(79, 70, 229, 0.1);
			color: var(--kit-color-primary);
		}
	}

	&--emergency {
		&::before {
			background: var(--kit-color-danger);
		}

		.tip-icon-wrapper {
			background: rgba(239, 68, 68, 0.1);
			color: var(--kit-color-danger);
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
	border-radius: var(--kit-border-radius-md);
}

.tip-icon {
	width: 22px;
	height: 22px;
}

.tip-content {
	flex: 1;
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-primary);
	line-height: 1.65;
	padding-top: 8px;
}
</style>

<style lang="less">
.tip-content a {
	color: var(--kit-color-primary);
	text-decoration: none;
	font-weight: var(--kit-font-weight-medium);
	transition: all var(--kit-transition-base);
	border-bottom: 1px solid transparent;

	&:hover {
		color: var(--kit-color-primary-dark);
		border-bottom-color: var(--kit-color-primary-dark);
	}
}
</style>
