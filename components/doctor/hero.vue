<template>
	<div class="doctor-hero">
		<div class="doctor-photo">
			<DoctorAvatar
				:name="doctor.name"
				:photoUrl="doctor.photoUrl"
				:size="200"
				class="photo-img"
			/>
		</div>
		<div class="doctor-main-info">
			<h1 class="doctor-name">{{ doctor.name }}</h1>
			<div class="doctor-specialties">
				<span
					v-for="specialty in doctor.specialtyIds"
					:key="specialty"
					class="specialty-badge"
				>
					{{ t(specialty) }}
				</span>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import type { DoctorWithClinics } from '~/interfaces/doctor';

defineProps<{
	doctor: DoctorWithClinics;
}>();

const { t } = useI18n();
</script>

<style scoped>
.doctor-hero {
	display: flex;
	align-items: center;
	gap: var(--spacing-2xl);
	background: var(--color-surface-secondary);
	padding: var(--spacing-2xl);
	border-radius: var(--border-radius-lg);
	box-shadow: var(--shadow-xs);
}

.doctor-photo {
	flex-shrink: 0;
}

.photo-img {
	border: 3px solid var(--color-primary);
}

.doctor-main-info {
	flex: 1;
}

.doctor-name {
	font-size: var(--font-size-3xl);
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0 0 var(--spacing-md) 0;
	line-height: 1.2;
}

.doctor-specialties {
	display: flex;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

.specialty-badge {
	background: var(--color-surface-primary);
	color: var(--color-text-secondary);
	border: 1px solid var(--color-border-primary);
	padding: var(--spacing-sm) var(--spacing-lg);
	border-radius: var(--border-radius-lg);
	font-size: var(--font-size-lg);
	font-weight: 500;
}

/* Адаптивность */
@media (max-width: 768px) {
	.doctor-hero {
		flex-direction: column;
		text-align: center;
		gap: var(--spacing-lg);
		padding: var(--spacing-xl);
	}

	.doctor-name {
		font-size: var(--font-size-2xl);
	}

	.doctor-specialties {
		justify-content: center;
	}
}
</style>
