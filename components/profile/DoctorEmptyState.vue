<script setup lang="ts">
import { PROJECT_CONTACTS } from '~/common/constants';
import doctorProfileI18n from '~/i18n/doctor-profile';

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
		<a class="empty-card__email" :href="`mailto:${PROJECT_CONTACTS.email}`">
			{{ PROJECT_CONTACTS.email }}
		</a>
	</div>
</template>

<style scoped>
.empty-card {
	background: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-xl);
	border: 1px solid var(--kit-color-border-secondary);
	box-shadow: var(--kit-shadow-sm);
	padding: var(--kit-spacing-3xl) var(--kit-spacing-2xl);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--kit-spacing-lg);
	text-align: center;
	min-height: 240px;
	justify-content: center;
}

.empty-card__icon {
	width: 80px;
	height: 80px;
	border-radius: var(--kit-border-radius-full);
	background: var(--kit-color-primary-bg);
	color: var(--kit-color-primary);
	display: flex;
	align-items: center;
	justify-content: center;
}

.empty-card__title {
	font-size: var(--kit-font-size-2xl);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-heading);
	margin: 0;
}

.empty-card__desc {
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-muted);
	margin: 0;
	max-width: 400px;
	line-height: 1.5;
}

.empty-card__email {
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-primary);
	text-decoration: none;
	transition: color 0.15s ease;

	&:hover {
		/* Токена --color-primary-hover не существует: ссылка была мёртвой
		   и ховер молча не срабатывал */
		color: var(--kit-color-primary-dark);
		text-decoration: underline;
	}
}
</style>
