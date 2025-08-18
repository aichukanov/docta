<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

interface Doctor {
	id: number;
	name: string;
	specialty: string;
	address: string;
	phone: string;
	image?: string;
}

// Mock data for doctors
const doctors = ref<Doctor[]>([
	{
		id: 1,
		name: 'Dr. Marko Petrović',
		specialty: 'Kardiolog',
		address: 'Kneza Miloša 15, Beograd',
		phone: '+381 11 123 4567',
		image: '/doctors/doctor-1.jpg',
	},
	{
		id: 2,
		name: 'Dr. Ana Nikolić',
		specialty: 'Dermatolog',
		address: 'Nemanjina 25, Novi Sad',
		phone: '+381 21 987 6543',
		image: '/doctors/doctor-2.jpg',
	},
	{
		id: 3,
		name: 'Dr. Stefan Jovanović',
		specialty: 'Neurolog',
		address: 'Kralja Petra 8, Niš',
		phone: '+381 18 456 7890',
		image: '/doctors/doctor-3.jpg',
	},
	{
		id: 4,
		name: 'Dr. Milica Stojanović',
		specialty: 'Ginekolog',
		address: 'Cara Dušana 12, Kragujevac',
		phone: '+381 34 234 5678',
		image: '/doctors/doctor-4.jpg',
	},
	{
		id: 5,
		name: 'Dr. Miloš Radić',
		specialty: 'Ortoped',
		address: 'Vuka Karadžića 30, Subotica',
		phone: '+381 24 345 6789',
		image: '/doctors/doctor-5.jpg',
	},
]);

let map: L.Map | null = null;

onMounted(() => {
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

	// Initialize Leaflet map
	nextTick(() => {
		if (!map) {
			map = L.map('map').setView([44.8176, 20.4567], 7); // Center on Serbia

			L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
				attribution: '© OpenStreetMap contributors',
			}).addTo(map);

			// Add markers for doctors
			doctors.value.forEach((doctor, index) => {
				// Mock coordinates for demonstration
				const coords: [number, number] = [
					44.8176 + (Math.random() - 0.5) * 2,
					20.4567 + (Math.random() - 0.5) * 2,
				];

				L.marker(coords)
					.bindPopup(
						`
						<div class="map-popup">
							<h3>${doctor.name}</h3>
							<p><strong>${doctor.specialty}</strong></p>
							<p>${doctor.address}</p>
							<p>${doctor.phone}</p>
						</div>
					`,
					)
					.addTo(map!);
			});
		}
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
						type="text"
						placeholder="Поиск врачей..."
						class="search-input"
					/>
				</div>

				<div class="doctors-list">
					<div v-for="doctor in doctors" :key="doctor.id" class="doctor-card">
						<div class="doctor-avatar">
							<div class="avatar-placeholder">
								{{ doctor.name.charAt(3)
								}}{{ doctor.name.split(' ')[1]?.charAt(0) }}
							</div>
						</div>

						<div class="doctor-info">
							<h3 class="doctor-name">{{ doctor.name }}</h3>
							<p class="doctor-specialty">{{ doctor.specialty }}</p>
							<p class="doctor-address">{{ doctor.address }}</p>
							<p class="doctor-phone">{{ doctor.phone }}</p>
						</div>

						<div class="doctor-actions">
							<button class="action-btn primary">Записаться</button>
							<button class="action-btn secondary">Детали</button>
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

.doctor-address,
.doctor-phone {
	color: #6b7280;
	font-size: 0.875rem;
	margin: 4px 0 0 0;
	line-height: 1.4;
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
