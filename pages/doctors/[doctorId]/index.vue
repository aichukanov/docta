<template>
	<div class="doctor-content">
		<section class="doctor-details">
			<div class="detail-section">
				<h3 class="section-title">{{ t('Languages') }}</h3>
				<div class="languages-list">
					<LanguageBadge
						v-for="lang in doctor.languages"
						:key="lang"
						:lang="lang"
					/>
				</div>
			</div>

			<div class="detail-section">
				<h3 class="section-title">{{ t('Contacts') }}</h3>
				<ContactsCollapseVue :doctor="doctor" />
			</div>

			<div class="detail-section">
				<h3 class="section-title">{{ t('doctor.locations') }}</h3>
				<div class="locations-list">
					<ClinicSummary
						v-for="(clinic, index) in doctor.clinics"
						:key="clinic.clinicId"
						:clinic="clinic"
						:location-index="index"
						:doctor-id="doctor.id"
						@show-on-map="onShowOnMap"
					/>
				</div>
			</div>
		</section>

		<aside class="doctor-map-sidebar">
			<div class="map-container">
				<div class="doctor-map-container">
					<DoctorsMap :doctors="[doctor]" :hide-popup="false" />
				</div>
			</div>
		</aside>
	</div>
</template>

<script setup lang="ts">
import type { DoctorWithClinics } from '~/interfaces/doctor';

defineProps<{
	doctor: DoctorWithClinics;
}>();

const { t } = useI18n();
// const mapStore = useMapStore();

const onShowOnMap = (clinic: any, coordinates: [number, number]) => {
	// 	mapStore.showClinicOnMap(clinic, coordinates);
	console.log('clinic', clinic);
};
</script>

<style scoped>
.doctor-content {
	display: grid;
	grid-template-columns: 1fr 550px;
	gap: var(--spacing-2xl);
	align-items: start;
	margin-top: var(--spacing-2xl);
}

.detail-section {
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-2xl);
	margin-bottom: var(--spacing-xl);
}

.section-title {
	font-size: var(--font-size-xl);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0 0 var(--spacing-lg) 0;
}

.languages-list {
	display: flex;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

.locations-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.doctor-map-sidebar {
	position: sticky;
	top: var(--spacing-xl);
}

.map-container {
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-lg);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}

.doctor-map-container {
	height: 510px;
	position: relative;
}

/* Адаптивность */
@media (max-width: 1024px) {
	.doctor-content {
		grid-template-columns: 1fr;
	}

	.doctor-map-sidebar {
		position: static;
		margin-top: var(--spacing-xl);
	}

	.doctor-map-container {
		height: 450px;
	}
}

@media (max-width: 768px) {
	.doctor-map-container {
		height: 350px;
	}
}
</style>
