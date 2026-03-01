<script setup lang="ts">
import doctorProfileI18n from '~/i18n/doctor-profile';
import { PROJECT_CONTACTS } from '~/common/constants';

const { t } = useI18n({
	useScope: 'local',
	messages: doctorProfileI18n.messages,
});
</script>

<template>
	<div class="empty-card">
		<div class="empty-card__icon">
			<IconDoctor :size="40" />
		</div>
		<h2 class="empty-card__title">{{ t('noDoctorProfile') }}</h2>
		<p class="empty-card__desc">{{ t('noDoctorProfileDesc') }}</p>
		<a
			class="empty-card__email"
			:href="`mailto:${PROJECT_CONTACTS.email}`"
		>
			{{ PROJECT_CONTACTS.email }}
		</a>
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
	min-height: 240px;
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
	max-width: 400px;
	line-height: 1.5;
}

.empty-card__email {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-medium);
	color: var(--color-primary);
	text-decoration: none;
	transition: color 0.15s ease;

	&:hover {
		color: var(--color-primary-hover);
		text-decoration: underline;
	}
}
</style>
