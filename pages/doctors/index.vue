<script setup lang="ts">
import { ref, onMounted, nextTick, computed, watch, toRaw } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import type { DoctorWithClinics, Specialty } from '~/interfaces/doctor';
import {
	MONTENEGRO_CENTER,
	MONTENEGRO_ZOOM_SETTINGS,
} from '~/common/constants';

const {
	doctors,
	specialties,
	loading,
	loadDoctors,
	loadSpecialties,
	getSpecialtyNames,
} = useDoctors();
const searchQuery = ref('');

let map: L.Map | null = null;
let markersGroup: L.LayerGroup | null = null;

// Filtered doctors based on search query
const filteredDoctors = computed(() => {
	if (!searchQuery.value) return doctors.value;

	const query = searchQuery.value.toLowerCase();
	return doctors.value.filter(
		(doctor) =>
			doctor.name.toLowerCase().includes(query) ||
			(doctor.clinics &&
				doctor.clinics.some(
					(clinic) =>
						clinic.clinicName.toLowerCase().includes(query) ||
						clinic.cityName.toLowerCase().includes(query) ||
						clinic.address.toLowerCase().includes(query),
				)),
	);
});

// Load data from API
async function loadData() {
	try {
		// Load doctors and specialties in parallel
		await Promise.all([loadDoctors(), loadSpecialties()]);
	} catch (error) {
		console.error('Error loading data:', error);
	}
}

// Initialize map
function initMap() {
	if (map) return;

	// Fix Leaflet marker icons
	delete (L.Icon.Default.prototype as any)._getIconUrl;
	L.Icon.Default.mergeOptions({
		iconRetinaUrl:
			'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon-2x.png',
		iconUrl:
			'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon.png',
		shadowUrl:
			'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
	});

	// Initialize map centered on Montenegro
	map = L.map('map').setView(
		MONTENEGRO_CENTER,
		MONTENEGRO_ZOOM_SETTINGS.defaultZoom,
	);

	L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
		attribution: '© OpenStreetMap contributors',
	}).addTo(map);

	// Create markers group
	markersGroup = L.layerGroup().addTo(map);
}

// Update map markers
function updateMapMarkers() {
	if (!map || !markersGroup) return;

	// Clear existing markers
	markersGroup.clearLayers();

	// Add markers for filtered doctors
	filteredDoctors.value.forEach((doctor) => {
		toRaw(doctor.clinics).forEach((clinic) => {
			if (clinic.latitude && clinic.longitude) {
				const specialtyNames = getSpecialtyNames(toRaw(doctor));

				L.marker([clinic.latitude, clinic.longitude])
					.bindPopup(
						`
						<div class="map-popup">
							<h3>${doctor.name}</h3>
							<p><strong>${specialtyNames.join(', ')}</strong></p>
							<p><strong>Клиника:</strong> ${clinic.clinicName}</p>
							<p><strong>Адрес:</strong> ${clinic.address}</p>
							<p><strong>Град:</strong> ${clinic.cityName}</p>
							${doctor.phone ? `<p><strong>Телефон:</strong> ${doctor.phone}</p>` : ''}
							${
								clinic.phone
									? `<p><strong>Клиника телефон:</strong> ${clinic.phone}</p>`
									: ''
							}
						</div>
					`,
					)
					.addTo(markersGroup!);
			}
		});
	});
}

// Watch for changes in filtered doctors and update map
watch(filteredDoctors, () => {
	nextTick(() => updateMapMarkers());
});

onMounted(async () => {
	await loadData();

	nextTick(() => {
		initMap();
		updateMapMarkers();
	});
});
</script>

<template>
	<PageWrapper>
		<div class="doctors-page">
			<div class="doctors-sidebar">
				<h1 class="page-title">Врачи</h1>
				<div class="search-bar">
					<input
						v-model="searchQuery"
						type="text"
						placeholder="Поиск врачей..."
						class="search-input"
					/>
				</div>

				<div v-if="loading" class="loading">
					<div class="loading-spinner"></div>
					<p>Загрузка врачей...</p>
				</div>

				<div v-else class="doctors-list">
					<div v-if="filteredDoctors.length === 0" class="empty-state">
						<p>Врачи не найдены</p>
					</div>

					<div
						v-for="doctor in filteredDoctors"
						:key="doctor.id"
						class="doctor-card"
					>
						<div class="doctor-avatar">
							<div class="avatar-placeholder">
								{{ doctor.name.charAt(3)
								}}{{ doctor.name.split(' ')[1]?.charAt(0) }}
							</div>
						</div>

						<div class="doctor-info">
							<h3 class="doctor-name">{{ doctor.name }}</h3>
							<p class="doctor-specialty">{{
								getSpecialtyNames(toRaw(doctor)).join(', ')
							}}</p>
							<div v-if="doctor.clinics.length > 0" class="doctor-clinics">
								<div
									v-for="clinic in doctor.clinics"
									:key="clinic.clinicId"
									class="clinic-item"
								>
									<p class="clinic-name">{{ clinic.clinicName }}</p>
									<p class="clinic-address"
										>{{ clinic.address }}, {{ clinic.cityName }}</p
									>
								</div>
							</div>
							<p v-if="doctor.phone" class="doctor-phone">{{ doctor.phone }}</p>
						</div>

						<div class="doctor-actions">
							<button class="action-btn primary">Записаться</button>
							<NuxtLink
								:to="`/doctors/details?id=${doctor.id}`"
								class="action-btn secondary"
							>
								Детали
							</NuxtLink>
						</div>
					</div>
				</div>
			</div>

			<div class="map-container">
				<div id="map" class="map"></div>
			</div>
		</div>
	</PageWrapper>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctors-page {
	display: flex;
	height: calc(100vh - 120px);
	gap: 0;
}

.doctors-sidebar {
	flex: 1;
	max-width: 50%;
	padding: @double-padding;
	background: #ffffff;
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	overflow-y: auto;
}

.page-title {
	font-size: 2rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 @double-padding 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.search-bar {
	margin-bottom: @double-padding;
}

.search-input {
	width: 100%;
	padding: 12px @base-padding;
	border: 1px solid #e5e7eb;
	border-radius: 6px;
	font-size: 1rem;
	font-family: system-ui, -apple-system, sans-serif;
	transition: border-color 0.2s ease, box-shadow 0.2s ease;

	&:focus {
		outline: none;
		border-color: #4f46e5;
		box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.05);
	}

	&::placeholder {
		color: #9ca3af;
	}
}

.doctors-list {
	display: flex;
	flex-direction: column;
	gap: @base-padding;
}

.doctor-card {
	display: flex;
	gap: @base-padding;
	padding: @base-padding;
	background: #ffffff;
	border: 1px solid rgba(0, 0, 0, 0.04);
	border-radius: 8px;
	transition: all 0.2s ease;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);

	&:hover {
		border-color: rgba(79, 70, 229, 0.12);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
	}
}

.doctor-avatar {
	flex-shrink: 0;
}

.avatar-placeholder {
	width: 64px;
	height: 64px;
	background: linear-gradient(135deg, #4f46e5, #06b6d4);
	color: white;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 8px;
	font-weight: 600;
	font-size: 1.1rem;
	text-transform: uppercase;
	font-family: system-ui, -apple-system, sans-serif;
}

.doctor-info {
	flex: 1;
	min-width: 0;
}

.doctor-name {
	font-size: 1.1rem;
	font-weight: 600;
	color: #1f2937;
	margin: 0 0 4px 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.doctor-specialty {
	color: #4f46e5;
	font-weight: 500;
	margin: 0 0 8px 0;
	font-size: 0.9rem;
}

.doctor-phone {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 8px 0 0 0;
	line-height: 1.4;
}

.doctor-clinics {
	margin: 8px 0;
}

.clinic-item {
	margin: 4px 0;
}

.clinic-name {
	color: #6b7280;
	font-size: 0.875rem;
	font-weight: 500;
	margin: 0;
	line-height: 1.3;
}

.clinic-address {
	color: #9ca3af;
	font-size: 0.8rem;
	margin: 2px 0 0 0;
	line-height: 1.3;
}

.loading {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 40px;
	color: #6b7280;
}

.loading-spinner {
	width: 40px;
	height: 40px;
	border: 3px solid #e5e7eb;
	border-top: 3px solid #4f46e5;
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin-bottom: 16px;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}
	100% {
		transform: rotate(360deg);
	}
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}

.doctor-actions {
	display: flex;
	flex-direction: column;
	gap: 8px;
	flex-shrink: 0;
}

.action-btn {
	padding: 8px 12px;
	border-radius: 6px;
	font-size: 0.875rem;
	font-weight: 500;
	border: none;
	cursor: pointer;
	transition: all 0.2s ease;
	font-family: system-ui, -apple-system, sans-serif;

	&.primary {
		background: #4f46e5;
		color: white;

		&:hover {
			background: #4338ca;
		}
	}

	&.secondary {
		background: transparent;
		color: #4f46e5;
		border: 1px solid #4f46e5;
		text-decoration: none;
		display: inline-flex;
		align-items: center;
		justify-content: center;

		&:hover {
			background: #f8fafc;
		}
	}
}

.map-container {
	flex: 1;
	max-width: 50%;
	position: relative;
}

.map {
	width: 100%;
	height: 100%;
}

// Global styles for map popup
:global(.map-popup) {
	font-family: system-ui, -apple-system, sans-serif;

	h3 {
		margin: 0 0 8px 0;
		font-size: 1.1rem;
		color: #1f2937;
	}

	p {
		margin: 4px 0;
		font-size: 0.875rem;
		color: #6b7280;

		&:first-of-type {
			color: #4f46e5;
			font-weight: 500;
		}
	}
}

// Responsive design
@media (max-width: 768px) {
	.doctors-page {
		flex-direction: column;
		height: auto;
	}

	.doctors-sidebar,
	.map-container {
		max-width: 100%;
	}

	.map-container {
		height: 400px;
	}
}
</style>
