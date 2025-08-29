<script setup lang="ts">
import { computed } from 'vue';
import { createDoctorUrl } from '~/common/url-utils';
import type { DoctorWithClinics, DoctorClinicFull } from '~/interfaces/doctor';
import { useDoctorsStore } from '~/stores/doctors';
import DoctorAvatar from '~/components/doctor/avatar.vue';

const props = defineProps<{
	doctor: DoctorWithClinics;
	clinic?: DoctorClinicFull;
	variant?: 'full' | 'compact';
}>();

const emit = defineEmits<{
	showOnMap: [doctorId: number, clinic: DoctorClinicFull];
}>();

const { t, locale } = useI18n();
const doctorsStore = useDoctorsStore();

// Computed свойства
const doctorWithData = computed(() => {
	return {
		...props.doctor,
		specialties: doctorsStore.getSpecialtyNames(props.doctor),
		doctorUrl: createDoctorUrl(props.doctor.id, locale.value),
	};
});

const isCompact = computed(() => props.variant === 'compact');

const handleShowOnMap = () => {
	if (props.clinic) {
		emit('showOnMap', props.doctor.id, props.clinic);
	}
};
</script>

<template>
	<!-- Компактный вариант для списка -->
	<div v-if="isCompact" class="doctor-item-compact">
		<div class="doctor-item-header">
			<DoctorAvatar
				:name="doctorWithData.name"
				:photo-url="doctorWithData.photoUrl"
				:size="50"
				class="doctor-avatar-compact"
			/>
			<div class="doctor-item-info">
				<h4 class="doctor-name-compact">
					<NuxtLink
						:to="doctorWithData.doctorUrl"
						class="doctor-link"
						@click.stop
					>
						{{ doctorWithData.name }}
					</NuxtLink>
				</h4>
				<p class="doctor-specialty-compact">{{
					doctorWithData.specialties.join(', ')
				}}</p>
				<div
					v-if="doctorWithData.languages?.length"
					class="doctor-languages-compact"
				>
					<span
						v-for="lang in doctorWithData.languages"
						:key="lang"
						class="language-badge-small"
					>
						{{ lang.toUpperCase() }}
					</span>
				</div>
			</div>
		</div>
		<div class="doctor-actions-compact">
			<button @click="handleShowOnMap" class="show-on-map-btn" type="button">
				{{ t('show_on_map') }}
			</button>
		</div>
	</div>

	<!-- Полный вариант для одиночного попапа -->
	<div v-else class="doctor-item-full">
		<div class="doctor-header">
			<div class="doctor-header-content">
				<DoctorAvatar
					:name="doctorWithData.name"
					:photo-url="doctorWithData.photoUrl"
					:size="60"
					class="doctor-avatar-full"
				/>
				<div class="doctor-header-info">
					<h3 class="doctor-name-full">
						<NuxtLink
							:to="doctorWithData.doctorUrl"
							class="doctor-link"
							@click.stop
						>
							{{ doctorWithData.name }}
						</NuxtLink>
					</h3>
					<p class="doctor-specialty-full">{{
						doctorWithData.specialties.join(', ')
					}}</p>
					<div v-if="doctorWithData.languages?.length" class="languages-info">
						<span
							v-for="lang in doctorWithData.languages"
							:key="lang"
							class="language-badge"
						>
							<IconLanguage class="language-icon" />
							<span class="language-name">{{ lang.toUpperCase() }}</span>
						</span>
					</div>
				</div>
			</div>
		</div>

		<div
			v-if="
				doctorWithData.clinics && doctorWithData.clinics.length > 1 && clinic
			"
			class="other-locations"
		>
			<p>
				<strong>{{ t('other_locations') }}:</strong>
				{{
					doctorWithData.clinics
						.filter((cl) => cl.cityId !== clinic.cityId)
						.map((cl) => cl.clinicName)
						.join(', ')
				}}
			</p>
		</div>

		<div class="doctor-actions-full">
			<NuxtLink :to="doctorWithData.doctorUrl" class="details-link" @click.stop>
				{{ t('details') }}
			</NuxtLink>
			<button
				v-if="clinic"
				@click="handleShowOnMap"
				class="show-on-map-btn"
				type="button"
			>
				{{ t('show_on_map') }}
			</button>
		</div>
	</div>
</template>

<style scoped>
/* Компактный вариант */
.doctor-item-compact {
	display: flex;
	align-items: center;
	justify-content: space-between;
	background: #ffffff;
	border: 1px solid rgba(0, 0, 0, 0.04);
	border-radius: 6px;
	padding: 8px;
	margin-bottom: 6px;
	transition: all 0.2s ease;
}

.doctor-item-compact:hover {
	border-color: rgba(79, 70, 229, 0.12);
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.doctor-item-header {
	display: flex;
	gap: 8px;
	align-items: center;
	flex: 1;
	min-width: 0;
}

.doctor-avatar-compact :deep(.doctor-avatar) {
	border-radius: 8px;
}

.doctor-item-info {
	flex: 1;
	min-width: 0;
}

.doctor-name-compact {
	font-size: 0.9rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 4px 0;
}

.doctor-specialty-compact {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 0 0 8px 0;
	font-weight: 500;
}

.doctor-languages-compact {
	display: flex;
	gap: 4px;
	flex-wrap: wrap;
}

.language-badge-small {
	display: inline-flex;
	align-items: center;
	background: rgba(79, 70, 229, 0.08);
	color: #4f46e5;
	padding: 1px 4px;
	border-radius: 4px;
	font-size: 0.7rem;
	font-weight: 500;
}

.doctor-actions-compact {
	flex-shrink: 0;
}

/* Полный вариант */
.doctor-item-full {
	width: 100%;
}

.doctor-header {
	margin-bottom: 16px;
}

.doctor-header-content {
	display: flex;
	gap: 12px;
	align-items: flex-start;
}

.doctor-avatar-full :deep(.doctor-avatar) {
	border-radius: 8px;
}

.doctor-header-info {
	flex: 1;
	min-width: 0;
}

.doctor-name-full {
	font-size: 1.1rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 6px 0;
}

.doctor-specialty-full {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 0 0 8px 0;
	font-weight: 500;
}

.languages-info {
	display: flex;
	gap: 4px;
	flex-wrap: wrap;
	margin: 8px 0 0 0;
}

.language-badge {
	display: inline-flex;
	align-items: center;
	gap: 3px;
	background: rgba(79, 70, 229, 0.08);
	color: #4f46e5;
	padding: 2px 6px;
	border-radius: 4px;
	font-size: 0.75rem;
	font-weight: 500;
}

.language-icon {
	font-size: 0.7rem;
}

.other-locations {
	background: rgba(243, 244, 246, 0.5);
	border-radius: 4px;
	padding: 8px;
	margin: 12px 0;
}

.other-locations p {
	font-size: 0.8rem;
	color: #6b7280;
	margin: 0;
}

.doctor-actions-full {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
	margin-top: 12px;
	padding-top: 12px;
	border-top: 1px solid rgba(0, 0, 0, 0.06);
}

/* Общие стили */
.doctor-link {
	color: #4f46e5;
	text-decoration: none;
	transition: color 0.2s ease;
}

.doctor-link:hover {
	color: #4338ca;
}

.show-on-map-btn {
	background: transparent;
	color: #06b6d4;
	border: 1px solid #06b6d4;
	border-radius: 4px;
	padding: 4px 8px;
	font-size: 0.75rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s ease;
}

.show-on-map-btn:hover {
	background: #06b6d4;
	color: white;
}

.details-link {
	color: #4f46e5;
	text-decoration: none;
	font-size: 0.875rem;
	font-weight: 500;
	padding: 4px 8px;
	border-radius: 4px;
	transition: all 0.2s ease;
}

.details-link:hover {
	background: rgba(79, 70, 229, 0.08);
}
</style>
