<script setup lang="ts">
import { computed } from 'vue';
import { createDoctorUrl } from '~/common/url-utils';
import type { DoctorWithClinics, DoctorClinicFull } from '~/interfaces/doctor';
import { useDoctorsStore } from '~/stores/doctors';
import { useMapStore } from '~/stores/map-state';
import { createRouteUrl } from '~/common/google-maps';
import DoctorPopupCard from '~/components/doctor/popup-card.vue';
import IconRoute from '~/components/icon/route.vue';

const emit = defineEmits<{
	doctorClick: [doctorId: number];
	routeClick: [clinic: DoctorClinicFull];
	showOnMap: [doctorId: number, clinic: DoctorClinicFull];
}>();

const { t } = useI18n();
const mapStore = useMapStore();

// Получаем данные из стора
const doctors = computed(() => mapStore.popupDoctors);
const clinics = computed(() => mapStore.popupClinics);

// Обработчики событий
const handleDoctorClick = (doctorId: number) => {
	emit('doctorClick', doctorId);
};

const handleRouteClick = (clinic: DoctorClinicFull) => {
	emit('routeClick', clinic);
};

const handleShowOnMap = (doctorId: number, clinic: DoctorClinicFull) => {
	emit('showOnMap', doctorId, clinic);
};

const isMultipleDoctors = computed(() => doctors.value.length > 1);

// Computed свойства
const clinicsWithRoutes = computed(() => {
	return clinics.value.map((clinic) => ({
		...clinic,
		routeUrl: createRouteUrl(clinic.latitude, clinic.longitude),
	}));
});

// Данные первого врача и клиники для одиночного попапа
const primaryDoctor = computed(() => doctors.value?.[0] || null);
const primaryClinic = computed(() => clinicsWithRoutes.value?.[0] || null);

// Показывать ли попап (если есть данные и target)
const shouldShowPopup = computed(
	() =>
		doctors.value.length > 0 &&
		clinics.value.length > 0 &&
		mapStore.currentPopupId,
);

// Динамический target для teleport
const teleportTarget = computed(() =>
	mapStore.currentPopupId ? `#${mapStore.currentPopupId}` : null,
);

// isMultipleDoctors используется только внутри компонента
</script>

<template>
	<Teleport v-if="shouldShowPopup && teleportTarget" :to="teleportTarget">
		<!-- Множественные врачи -->
		<div v-if="isMultipleDoctors" class="doctor-popup-group">
			<div class="popup-clinics-group">
				<div
					v-for="clinic in clinicsWithRoutes"
					:key="clinic.clinicId"
					class="clinic-info-group"
				>
					<h3 class="clinic-name-popup">
						<a
							v-if="clinic.website"
							:href="clinic.website"
							target="_blank"
							rel="noopener noreferrer"
							class="clinic-website-link"
						>
							{{ clinic.clinicName }}
						</a>
						<span v-else>{{ clinic.clinicName }}</span>
					</h3>
					<p v-if="clinic.address" class="clinic-address-popup">
						<IconMapPin class="address-icon" />
						{{ clinic.address }}, {{ clinic.cityName }}
					</p>
					<div class="clinic-actions">
						<a
							:href="clinic.routeUrl"
							target="_blank"
							rel="noopener noreferrer"
							class="route-link"
							:title="t('build_route')"
							@click="handleRouteClick(clinic)"
						>
							<IconRoute />
							{{ t('route') }}
						</a>
					</div>
				</div>
			</div>

			<div class="popup-doctors-group">
				<h4 class="doctors-title">{{ t('doctors_in_clinic') }}:</h4>
				<DoctorPopupCard
					v-for="doctor in doctors"
					:key="doctor.id"
					:doctor="doctor"
					:clinic="clinicsWithRoutes[0]"
					variant="compact"
					@show-on-map="handleShowOnMap"
				/>
			</div>
		</div>

		<!-- Одиночный врач -->
		<div v-else-if="primaryDoctor && primaryClinic" class="doctor-popup">
			<DoctorPopupCard
				:doctor="primaryDoctor"
				:clinic="primaryClinic"
				variant="full"
				@show-on-map="handleShowOnMap"
			/>

			<div class="popup-meta">
				<div class="location-info">
					<h4 class="clinic-name-popup">
						<a
							v-if="primaryClinic.website"
							:href="primaryClinic.website"
							target="_blank"
							rel="noopener noreferrer"
							class="clinic-website-link"
						>
							{{ primaryClinic.clinicName }}
						</a>
						<span v-else>{{ primaryClinic.clinicName }}</span>
					</h4>
					<p v-if="primaryClinic.address" class="clinic-address-popup">
						<IconMapPin class="address-icon" />
						{{ primaryClinic.address }}, {{ primaryClinic.cityName }}
					</p>
					<p v-if="primaryClinic.phone" class="clinic-phone-popup">
						<IconPhone class="phone-icon" />
						{{ primaryClinic.phone }}
					</p>
					<div class="clinic-actions">
						<a
							:href="primaryClinic.routeUrl"
							target="_blank"
							rel="noopener noreferrer"
							class="route-link"
							:title="t('build_route')"
							@click="handleRouteClick(primaryClinic)"
						>
							<IconRoute />
							{{ t('route') }}
						</a>
					</div>
				</div>
			</div>

			<div
				v-if="primaryDoctor.clinics && primaryDoctor.clinics.length > 1"
				class="other-locations"
			>
				<p>
					<strong>{{ t('other_locations') }}:</strong>
					{{
						primaryDoctor.clinics
							.filter((cl) => cl.cityId !== primaryClinic.cityId)
							.map((cl) => cl.clinicName)
							.join(', ')
					}}
				</p>
			</div>

			<div class="popup-actions">
				<NuxtLink
					:to="primaryDoctor.doctorUrl"
					class="details-link"
					@click.stop
				>
					{{ t('details') }}
				</NuxtLink>
				<button
					@click="handleShowOnMap(primaryDoctor.id, primaryClinic)"
					class="show-on-map-btn"
					type="button"
				>
					{{ t('show_on_map') }}
				</button>
			</div>
		</div>
	</Teleport>
</template>

<style scoped>
/* Стили для попапов врачей */
.doctor-popup,
.doctor-popup-group {
	font-family: system-ui, -apple-system, sans-serif;
	max-width: 380px;
	padding: 8px;
}

/* Заголовок попапа */
.popup-header {
	margin-bottom: 16px;
}

.popup-header-content {
	display: flex;
	gap: 12px;
	align-items: flex-start;
}

.doctor-avatar-popup,
.doctor-avatar-group {
	border-radius: 8px;
	object-fit: cover;
	flex-shrink: 0;
}

.doctor-header-info {
	flex: 1;
	min-width: 0;
}

.doctor-name {
	font-size: 1.1rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 6px 0;
}

.doctor-link {
	color: #4f46e5;
	text-decoration: none;
	transition: color 0.2s ease;
}

.doctor-link:hover {
	color: #4338ca;
}

.doctor-specialty,
.doctor-specialty-group {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 0 0 8px 0;
	font-weight: 500;
}

/* Языковые бэйджи */
.languages-info,
.doctor-languages-group {
	display: flex;
	gap: 4px;
	flex-wrap: wrap;
	margin: 8px 0 0 0;
}

.language-badge-popup,
.language-badge-popup-small {
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

.language-badge-popup-small {
	padding: 1px 4px;
	font-size: 0.7rem;
}

.language-icon {
	font-size: 0.7rem;
}

/* Информация о клиниках */
.popup-clinics-group {
	margin-bottom: 16px;
	padding-bottom: 12px;
	border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.clinic-info-group {
	background: rgba(79, 70, 229, 0.04);
	border-radius: 6px;
	padding: 12px;
	margin-bottom: 8px;
}

.clinic-name-popup {
	font-size: 1rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 6px 0;
}

.clinic-website-link {
	color: #4f46e5;
	text-decoration: none;
	transition: color 0.2s ease;
}

.clinic-website-link:hover {
	color: #4338ca;
}

.clinic-address-popup,
.clinic-phone-popup {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 4px 0;
	display: flex;
	align-items: center;
	gap: 6px;
}

.address-icon,
.phone-icon {
	width: 16px;
	height: 16px;
	flex-shrink: 0;
}

/* Действия с клиникой */
.clinic-actions {
	margin: 8px 0 0 0;
}

.route-link {
	display: inline-flex;
	align-items: center;
	gap: 4px;
	color: #06b6d4;
	text-decoration: none;
	font-size: 0.875rem;
	font-weight: 500;
	transition: color 0.2s ease;
}

.route-link:hover {
	color: #0891b2;
}

.route-link svg {
	color: currentColor;
}

/* Список врачей */
.popup-doctors-group {
	margin-top: 8px;
}

.doctors-title {
	font-size: 0.9rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 12px 0;
}

.doctor-item-group {
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

.doctor-item-group:hover {
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

.doctor-item-info {
	flex: 1;
	min-width: 0;
}

.doctor-name-group {
	font-size: 0.9rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 4px 0;
}

/* Действия с врачом */
.doctor-actions-group {
	flex-shrink: 0;
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

/* Мета информация попапа */
.popup-meta {
	margin: 16px 0;
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

/* Действия попапа */
.popup-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
	margin-top: 12px;
	padding-top: 12px;
	border-top: 1px solid rgba(0, 0, 0, 0.06);
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
