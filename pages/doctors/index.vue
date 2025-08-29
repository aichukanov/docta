<script setup lang="ts">
import { createDoctorUrl, getRegionalQuery } from '~/common/url-utils';
import { useDoctorsStore } from '~/stores/doctors';

const { t, locale } = useI18n();

const { pending: isLoading, data: doctors } = await useFetch(
	'/api/doctors/list',
	{
		key: 'doctors-list',
		method: 'POST',
	},
);

const filteredDoctors = computed(() => {
	return doctors.value;
});
</script>

<template>
	<PageWrapper>
		<div class="doctors-page">
			<div class="doctors-sidebar">
				<h1 class="page-title">{{ t('doctors') }}</h1>
				<!-- 
				<div class="filter-toggle">
					<label class="toggle-container">
						<input
							v-model="doctorsStore.mapFilterEnabled"
							type="checkbox"
							class="toggle-checkbox"
						/>
						<span class="toggle-switch"></span>
						<span class="toggle-label">{{
							t('show_only_doctors_on_map')
						}}</span>
					</label>
				</div>

				<div class="search-bar">
					<input
						v-model="doctorsStore.searchQuery"
						type="text"
						:placeholder="t('search_doctors_placeholder')"
						class="search-input"
					/>
				</div> -->

				<div v-if="isLoading" class="loading">
					<div class="loading-spinner"></div>
					<p>{{ t('loading_doctors') }}</p>
				</div>

				<div v-else class="doctors-list">
					<div v-if="filteredDoctors.length === 0" class="empty-state">
						<p>{{ t('no_doctors_found') }}</p>
					</div>

					<DoctorListCard
						v-for="doctor in filteredDoctors"
						:key="doctor.id"
						:doctor="doctor"
					/>
				</div>
			</div>

			<div class="map-container">
				<!-- <DoctorsMap id="doctors-page-map" /> -->
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

.filter-toggle {
	margin-bottom: @base-padding;
}

.toggle-container {
	display: flex;
	align-items: center;
	cursor: pointer;
	user-select: none;
}

.toggle-checkbox {
	position: absolute;
	opacity: 0;
	cursor: pointer;
}

.toggle-switch {
	position: relative;
	width: 44px;
	height: 24px;
	background: #e5e7eb;
	border-radius: 12px;
	margin-right: 12px;
	transition: background-color 0.2s ease;

	&::before {
		content: '';
		position: absolute;
		top: 2px;
		left: 2px;
		width: 20px;
		height: 20px;
		background: #ffffff;
		border-radius: 50%;
		transition: transform 0.2s ease;
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}

	.toggle-checkbox:checked + & {
		background: #4f46e5;

		&::before {
			transform: translateX(20px);
		}
	}
}

.toggle-label {
	font-size: 0.9rem;
	color: #374151;
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
