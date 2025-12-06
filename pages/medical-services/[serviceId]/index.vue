<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { CityId } from '~/enums/cities';
import cityI18n from '~/i18n/city';
import medicalServiceI18n from '~/i18n/medical-service';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([medicalServiceI18n, cityI18n]),
});

const router = useRouter();
const route = useRoute();
const medicalServicesMapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();
const { getRouteParams } = useFilters();

const { pending: isLoadingMedicalService, data: medicalServiceData } =
	await useFetch('/api/medical-services/details', {
		key: 'medical-service-details',
		method: 'POST',
		body: computed(() => ({
			serviceId: route.params.serviceId,
		})),
	});

const { data: clinicsList } = await useFetch('/api/clinics/list', {
	key: 'clinics-list',
	method: 'POST',
});

const isMedicalServiceFound = computed(
	() => medicalServiceData.value?.id != null,
);

const medicalServiceClinics = computed(
	(): Array<{ latitude: number; longitude: number; cityId: CityId }> => {
		if (!isMedicalServiceFound.value || !clinicsList.value?.clinics) {
			return [];
		}

		return clinicsList.value.clinics.filter((clinic) =>
			medicalServiceData.value?.clinicIds
				.split(',')
				.map(Number)
				.includes(clinic.id),
		);
	},
);

const showClinicOnMap = (clinic: ClinicData) => {
	medicalServicesMapRef.value?.centerOnClinics([clinic]);
};

const backToSearch = () => {
	router.push({
		name: 'medical-services',
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	medicalServicesMapRef.value?.centerOnClinics(medicalServiceClinics.value);
};

const pageTitle = computed(() => {
	if (!isMedicalServiceFound.value) {
		return '';
	}

	return medicalServiceData.value?.name || '';
});

const pageDescription = computed(() => {
	if (
		!isMedicalServiceFound.value ||
		!medicalServiceData.value ||
		!medicalServiceClinics.value
	) {
		return '';
	}

	const { name } = medicalServiceData.value;

	const usedCities: { [key: string]: true } = {};
	const citiesText = medicalServiceClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean)
		.join(', ');

	return citiesText
		? `${name} — медицинская услуга в ${citiesText}`
		: `${name} — медицинская услуга в Черногории`;
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});
</script>

<template>
	<div class="medical-service-page">
		<div class="medical-service-page-header">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</div>
		<div class="medical-service-page-content">
			<div v-if="isLoadingMedicalService" class="loading">
				<div class="loading-spinner"></div>
				<p>{{ t('LoadingMedicalServices') }}</p>
			</div>
			<div
				v-else-if="isMedicalServiceFound"
				class="medical-service-info-container"
			>
				<div class="medical-service-info-wrapper">
					<div class="medical-service-header">
						<h1 class="medical-service-name">{{ medicalServiceData.name }}</h1>
					</div>
					<div class="clinics-list">
						<ClinicSummary
							v-for="clinic in medicalServiceClinics"
							:key="clinic.id"
							:clinic="clinic"
							@show-on-map="showClinicOnMap(clinic)"
						/>
					</div>
				</div>
				<DoctorsMap
					ref="medicalServicesMapRef"
					:doctors="[]"
					:clinics="medicalServiceClinics"
					@ready="onMapReady"
				/>
			</div>
			<div v-else class="medical-service-info-container">
				<p>{{ t('NoMedicalServicesFound') }}</p>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.medical-service-page {
	padding: var(--spacing-md);

	.medical-service-page-header {
		margin-bottom: var(--spacing-md);
	}

	.medical-service-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.medical-service-info-container {
			display: flex;
			flex-direction: row;
			gap: var(--spacing-2xl);
			width: 100%;
			min-height: 700px;
			max-width: 1600px;

			& > * {
				flex: 1;
				height: 100%;
			}

			.medical-service-info-wrapper {
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);

				.medical-service-header {
					background: var(--color-surface-secondary);
					border: 1px solid var(--color-border-primary);
					border-radius: var(--border-radius-lg);
					padding: var(--spacing-xl) var(--spacing-2xl);
					box-shadow: var(--shadow-xs);

					.medical-service-name {
						font-size: 2rem;
						font-weight: 600;
						color: #1f2937;
						margin: 0;
						font-family: system-ui, -apple-system, sans-serif;
					}
				}
			}
		}
	}
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

.clinics-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

@media (max-width: 650px) {
	.medical-service-page {
		.medical-service-page-content {
			.medical-service-info-container {
				flex-direction: column;
			}
		}
	}
}
</style>
