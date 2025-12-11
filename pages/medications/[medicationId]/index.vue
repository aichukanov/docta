<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { CityId } from '~/enums/cities';
import cityI18n from '~/i18n/city';
import medicationI18n from '~/i18n/medication';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([medicationI18n, cityI18n]),
});

const router = useRouter();
const route = useRoute();
const medicationsMapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();
const { getRouteParams } = useFilters();

const { pending: isLoadingMedication, data: medicationData } = await useFetch(
	'/api/medications/details',
	{
		key: 'medication-details',
		method: 'POST',
		body: computed(() => ({
			medicationId: route.params.medicationId,
		})),
	},
);

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicsList = computed(() => ({
	clinics: clinicsStore.clinics,
	totalCount: clinicsStore.clinics.length,
}));

const isMedicationFound = computed(() => medicationData.value?.id != null);

const medicationClinics = computed(
	(): Array<{ latitude: number; longitude: number; cityId: CityId }> => {
		if (!isMedicationFound.value || !clinicsList.value?.clinics) {
			return [];
		}

		return clinicsList.value.clinics.filter((clinic) =>
			medicationData.value?.clinicIds
				.split(',')
				.map(Number)
				.includes(clinic.id),
		);
	},
);

const showClinicOnMap = (clinic: ClinicData) => {
	medicationsMapRef.value?.centerOnClinics([clinic]);
};

const backToSearch = () => {
	router.push({
		name: 'medications',
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	medicationsMapRef.value?.centerOnClinics(medicationClinics.value);
};

const pageTitle = computed(() => {
	if (!isMedicationFound.value) {
		return '';
	}

	return medicationData.value?.name;
});

const pageDescription = computed(() => {
	if (
		!isMedicationFound.value ||
		!medicationData.value ||
		!medicationClinics.value
	) {
		return '';
	}

	const { name } = medicationData.value;

	const usedCities: { [key: string]: true } = {};
	const citiesText = medicationClinics.value
		.map((clinic) => {
			if (usedCities[clinic.cityId]) {
				return '';
			}

			usedCities[clinic.cityId] = true;
			return t(`city_${clinic.cityId}_genitive`);
		})
		.filter(Boolean)
		.join(', ');

	return citiesText ? `${name} — доступно в ${citiesText}` : name;
});

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});
</script>

<template>
	<div class="medication-page">
		<div class="medication-page-header">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</div>
		<div class="medication-page-content">
			<div v-if="isLoadingMedication" class="loading">
				<div class="loading-spinner"></div>
				<p>{{ t('LoadingMedications') }}</p>
			</div>
			<div v-else-if="isMedicationFound" class="medication-info-container">
				<div class="medication-info-wrapper">
					<div class="medication-info">
						<h1 class="medication-name">{{ medicationData.name }}</h1>
					</div>
					<div class="clinics-list">
						<ClinicSummary
							v-for="clinic in medicationClinics"
							:key="clinic.id"
							:clinic="clinic"
							@show-on-map="showClinicOnMap(clinic)"
						/>
					</div>
				</div>
				<DoctorsMap
					ref="medicationsMapRef"
					:doctors="[medicationData]"
					:clinics="medicationClinics"
					@ready="onMapReady"
				/>
			</div>
			<div v-else class="medication-info-container">
				<p>{{ t('NoMedicationsFound') }}</p>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.medication-page {
	padding: var(--spacing-md);

	.medication-page-header {
		margin-bottom: var(--spacing-md);
	}

	.medication-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.medication-info-container {
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

			.medication-info-wrapper {
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);
			}

			.medication-info {
				background: var(--color-surface-secondary);
				border: 1px solid var(--color-border-primary);
				border-radius: var(--border-radius-lg);
				padding: var(--spacing-xl) var(--spacing-2xl);
				box-shadow: var(--shadow-xs);

				.medication-name {
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

@media (max-width: 650px) {
	.medication-page {
		.medication-page-content {
			.medication-info-container {
				flex-direction: column;
			}
		}
	}
}
</style>
