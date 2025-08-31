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
				<div v-if="doctor.professionalTitle" class="doctor-professional-title">
					{{ doctor.professionalTitle }}
				</div>
				<div class="doctor-specialty">
					{{ specialtiesText }}
				</div>
				<div class="languages" :title="t('DoctorLanguages')">
					<IconLanguage size="18" />
					<span class="languages-text">{{ languagesText }}</span>
				</div>
			</div>
		</div>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in doctor.clinics"
				:key="clinic.clinicId"
				:clinic="clinic"
			/>
		</div>
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

const languagesText = computed(() => {
	return props.doctor.languageCodes
		?.split(',')
		.map((lang) => t(lang) || lang)
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
	color: var(--color-primary);
	text-decoration: none;
}

.doctor-name-link:hover {
	color: var(--color-primary-dark);
	text-decoration: underline;
}

.doctor-professional-title {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
	line-height: 1.4;
	font-style: italic;
	opacity: 0.85;
}

.doctor-specialty {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-primary-green);
	line-height: 1.3;
}

.clinics-list {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	flex: 1;
}

.languages {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	flex-wrap: wrap;

	.languages-text {
		color: var(--color-primary-green);
		margin-top: -3px;
	}
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

	.locations-list {
		gap: var(--spacing-md);
	}
}
</style>
