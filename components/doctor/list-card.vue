<template>
	<div class="doctor-card">
		<div class="card-header">
			<DoctorAvatar
				:name="doctor.name"
				:photoUrl="doctor.photoUrl"
				:size="120"
				class="card-avatar"
			/>
			<div class="doctor-info">
				<h3 class="doctor-name">
					<NuxtLink
						:to="{
							name: 'doctors-doctorId',
							params: { doctorId: doctor.id },
						}"
						class="doctor-name-link"
					>
						{{ doctor.name }}
					</NuxtLink>
				</h3>
				<div class="doctor-specialty">
					{{ specialtiesText }}
				</div>
				<div class="languages">
					<span
						v-for="lang in doctor.languages"
						:key="lang"
						class="language-badge"
					>
						{{ t(lang) }}
					</span>
				</div>
				<p v-if="doctor.description" class="doctor-description">
					{{ doctor.description }}
				</p>
			</div>
		</div>

		<!-- <div class="doctor-meta">
			<div class="meta-item locations-meta">
				<div class="locations-list">
					<ClinicSummary
						v-for="clinic in doctor.clinics"
						:key="clinic.clinicId"
						:clinic="clinic"
					/>
				</div>
			</div>
		</div> -->
	</div>
</template>

<script setup lang="ts">
import type { DoctorWithClinics } from '~/interfaces/doctor';

const props = defineProps<{
	doctor: DoctorWithClinics;
}>();

const { t } = useI18n();

const specialtiesText = computed(() => {
	return props.doctor.specialtyIds
		?.split(',')
		.map((specialty) => t(specialty) || specialty)
		.join(', ');
});
</script>

<style scoped>
.doctor-card {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);
}

.card-header {
	display: flex;
	/* align-items: center; */
	gap: var(--spacing-2xl);
	/* margin-bottom: var(--spacing-xl); */
}

.doctor-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	flex: 1;
}

.doctor-name {
	margin: 0;
	font-size: var(--font-size-2xl);
	font-weight: 700;
	color: var(--color-text-primary);
	line-height: 1.2;
	letter-spacing: -0.01em;
}

.doctor-name-link {
	color: inherit;
	text-decoration: none;
	transition: color var(--transition-base);
}

.doctor-name-link:hover {
	color: var(--color-primary);
}

.doctor-specialty {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-primary);
	line-height: 1.3;
}

.doctor-meta {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-bottom: var(--spacing-xl);
}

.meta-item {
	display: flex;
	align-items: flex-start;
	gap: var(--spacing-sm);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
}

.locations-meta {
	align-items: flex-start;
}

.locations-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	flex: 1;
}

.languages {
	display: flex;
	gap: var(--spacing-xs);
	flex-wrap: wrap;
}

.language-badge {
	display: inline-flex;
	align-items: center;
	padding: var(--spacing-xs) var(--spacing-sm);
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-sm);
	font-size: var(--font-size-xs);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
}

.doctor-description {
	margin: 0 0 var(--spacing-xl) 0;
	font-size: var(--font-size-md);
	line-height: 1.6;
	color: var(--color-text-secondary);
	font-style: italic;
	opacity: 0.9;
}

@media (max-width: 768px) {
	.doctor-card {
		padding: var(--spacing-xl);
	}

	.card-header {
		gap: var(--spacing-md);
	}

	.card-avatar {
		width: 50px !important;
		height: 50px !important;
	}

	.doctor-name {
		font-size: var(--font-size-xl);
	}

	.doctor-specialty {
		font-size: var(--font-size-md);
	}

	.meta-item {
		font-size: var(--font-size-sm);
	}

	.locations-list {
		gap: var(--spacing-md);
	}
}
</style>
