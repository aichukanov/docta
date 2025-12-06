<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import type { CityId } from '~/enums/cities';
import { LanguageId } from '~/enums/language';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		doctorI18n,
		specialtyI18n,
		languageI18n,
		cityI18n,
	]),
});

const router = useRouter();
const route = useRoute();
const doctorsMapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();
const { getRouteParams } = useFilters();

const { pending: isLoadingDoctor, data: doctorData } = await useFetch(
	'/api/doctors/details',
	{
		key: 'doctor-details',
		method: 'POST',
		body: computed(() => ({
			doctorId: route.params.doctorId,
		})),
	},
);

const { data: clinicsList } = await useFetch('/api/clinics/list', {
	key: 'clinics-list',
	method: 'POST',
});

const isDoctorFound = computed(() => doctorData.value?.id != null);

const doctorClinics = computed(
	(): Array<{ latitude: number; longitude: number; cityId: CityId }> => {
		if (!isDoctorFound.value || !clinicsList.value?.clinics) {
			return [];
		}

		return clinicsList.value.clinics.filter((clinic) =>
			doctorData.value?.clinicIds.split(',').map(Number).includes(clinic.id),
		);
	},
);

const showClinicOnMap = (clinic: ClinicData) => {
	doctorsMapRef.value?.centerOnClinics([clinic]);
};

const backToSearch = () => {
	router.push({
		name: 'doctors',
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	doctorsMapRef.value?.centerOnClinics(doctorClinics.value);
};

const pageTitle = computed(() => {
	if (!isDoctorFound.value) {
		return '';
	}

	const specialtiesText = doctorData.value?.specialtyIds
		?.split(',')
		.map((specialty) => t(`specialty_${specialty}`))
		.join(', ');

	return `${doctorData.value?.name} | ${specialtiesText}`;
});

const pageDescription = computed(() => {
	if (!isDoctorFound.value || !doctorData.value || !doctorClinics.value) {
		return '';
	}

	const { specialtyIds, languageIds, professionalTitle, name } =
		doctorData.value;

	const specialtiesText = specialtyIds
		?.split(',')
		.map((specialty) => t(`doctor_${specialty}`).toLowerCase());

	const languagesText =
		languageIds === LanguageId.SR.toString()
			? null
			: joinWithAnd(
					languageIds
						.split(',')
						.map((language) => t(`language_${language}_prepositional`)),
			  );

	const usedCities: { [key: string]: true } = {};
	const citiesText = joinWithAnd(
		doctorClinics.value
			.map((clinic) => {
				if (usedCities[clinic.cityId]) {
					return '';
				}

				usedCities[clinic.cityId] = true;
				return t(`city_${clinic.cityId}_genitive`);
			})
			.filter(Boolean),
	);

	const visitText =
		citiesText && languagesText
			? t('VisitLanguageCity', {
					language: languagesText,
					city: citiesText,
			  })
			: citiesText
			? t('VisitCity', { city: citiesText })
			: languagesText
			? t('VisitLanguage', { language: languagesText })
			: t('Visit');

	const doctorName = (professionalTitle ? professionalTitle + ' ' : '') + name;

	return `${doctorName} — ${joinWithAnd(specialtiesText)}. ${visitText}`;
});

function joinWithAnd(items: string[]): string {
	if (items.length === 0) {
		return '';
	}

	if (items.length === 1) {
		return items[0];
	}

	return (
		items.slice(0, -1).join(', ') +
		' ' +
		t('And') +
		' ' +
		items[items.length - 1]
	);
}

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});
</script>

<template>
	<div class="doctor-page">
		<div class="doctor-page-header">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</div>
		<div class="doctor-page-content">
			<div v-if="isLoadingDoctor" class="loading">
				<div class="loading-spinner"></div>
				<p>{{ t('LoadingDoctor') }}</p>
			</div>
			<div v-else-if="isDoctorFound" class="doctor-info-container">
				<div class="doctor-info-wrapper">
					<DoctorInfo :doctor="doctorData" />
					<div class="clinics-list">
						<ClinicSummary
							v-for="clinic in doctorClinics"
							:key="clinic.id"
							:clinic="clinic"
							@show-on-map="showClinicOnMap(clinic)"
						/>
					</div>
				</div>
				<DoctorsMap
					ref="doctorsMapRef"
					:doctors="[doctorData]"
					:clinics="doctorClinics"
					@ready="onMapReady"
				/>
			</div>
			<div v-else class="doctor-info-container">
				<p>{{ t('DoctorNotFound') }}</p>
			</div>
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.doctor-page {
	padding: var(--spacing-md);

	.doctor-page-header {
		margin-bottom: var(--spacing-md);
	}

	.doctor-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.doctor-info-container {
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

			.doctor-info-wrapper {
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);
			}
		}
	}
}

@media (max-width: 650px) {
	.doctor-page {
		.doctor-page-content {
			.doctor-info-container {
				flex-direction: column;
			}
		}
	}
}
</style>
