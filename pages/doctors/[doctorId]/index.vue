<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import specialtyI18n from '~/i18n/specialty';
import languageI18n from '~/i18n/language';
import cityI18n from '~/i18n/city';
import doctorI18n from '~/i18n/doctor';
import { Language, LanguageId } from '~/enums/language';

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
const doctorsMapRef = ref<HTMLElement>();
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

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
	},
);
const doctorClinics = computed(() => {
	return clinicsList.value.clinics.filter((clinic) =>
		doctorData.value.clinicIds.split(',').map(Number).includes(clinic.id),
	);
});

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
	if (!doctorData.value) {
		return '';
	}

	const specialtiesText = doctorData.value.specialtyIds
		?.split(',')
		.map((specialty) => t(`doctor_${specialty}`))
		.join(', ');

	const languagesText = doctorData.value.languageIds
		?.split(',')
		.map((language) => t(`language_${language}_prepositional`))
		.join(', ');

	const visitText = t('VisitLanguage', { language: languagesText });

	return `${doctorData.value.name}, ${doctorData.value.professionalTitle} | ${visitText} | ${specialtiesText}`;
});

useSeoMeta({
	title: () => pageTitle.value + ' | docta.me',
	// description: pageTitle.value,
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
			<div v-else class="doctor-info-container">
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
