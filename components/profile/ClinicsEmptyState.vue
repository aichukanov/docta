<script setup lang="ts">
import { Plus } from '@element-plus/icons-vue';
import clinicProfileI18n from '~/i18n/clinic-profile';

const emit = defineEmits<{
	(e: 'create'): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});
</script>

<template>
	<div class="empty-card">
		<div class="empty-card__icon">
			<IconClinic :size="40" />
		</div>
		<h2 class="empty-card__title">{{ t('NoClinics') }}</h2>
		<p class="empty-card__desc">{{ t('NoClinicsDesc') }}</p>
		<el-button type="primary" :icon="Plus" @click="emit('create')">
			{{ t('CreateFirstClinic') }}
		</el-button>
	</div>
</template>

<style scoped>
.empty-card {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	border: 1px solid var(--color-border-secondary);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-3xl) var(--spacing-2xl);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--spacing-lg);
	text-align: center;
	min-height: 280px;
	justify-content: center;
}

.empty-card__icon {
	width: 80px;
	height: 80px;
	border-radius: var(--border-radius-full);
	background: var(--color-primary-bg);
	color: var(--color-primary);
	display: flex;
	align-items: center;
	justify-content: center;
}

.empty-card__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.empty-card__desc {
	font-size: var(--font-size-md);
	color: var(--color-text-muted);
	margin: 0;
	max-width: 440px;
	line-height: 1.5;
}
</style>
