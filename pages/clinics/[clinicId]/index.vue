<script setup lang="ts">
import { ArrowLeft } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, languageI18n, cityI18n]),
});

const router = useRouter();
const route = useRoute();
const clinicsMapRef = ref<
	HTMLElement & {
		centerOnClinics: (
			clinics: Array<{ latitude: number; longitude: number }>,
		) => void;
	}
>();
const { getRouteParams } = useFilters();

const { pending: isLoadingClinic, data: clinicData } = await useFetch(
	'/api/clinics/details',
	{
		key: 'clinic-details',
		method: 'POST',
		body: computed(() => ({
			clinicId: route.params.clinicId,
		})),
	},
);

const { data: doctorsList } = await useFetch('/api/doctors/list', {
	key: 'doctors-list-clinic',
	method: 'POST',
});

const isClinicFound = computed(() => clinicData.value?.id != null);

const clinicDoctors = computed(() => {
	if (!isClinicFound.value || !doctorsList.value?.doctors) {
		return [];
	}

	return doctorsList.value.doctors.filter((doctor) => {
		const clinicIds = doctor.clinicIds.split(',').map(Number);
		return clinicIds.includes(clinicData.value.id);
	});
});

const backToSearch = () => {
	router.push({
		name: 'clinics',
		query: { ...getRouteParams().query, ...getRegionalQuery(locale.value) },
	});
};

const onMapReady = () => {
	if (isClinicFound.value) {
		clinicsMapRef.value?.centerOnClinics([clinicData.value]);
	}
};

const pageTitle = computed(() => {
	if (!isClinicFound.value) {
		return '';
	}

	return `${clinicData.value.name} | ${t(`city_${clinicData.value.cityId}`)}`;
});

const pageDescription = computed(() => {
	if (!isClinicFound.value || !clinicData.value) {
		return '';
	}

	const { name, address, languageIds } = clinicData.value;

	const languagesText =
		languageIds === '1'
			? null
			: joinWithAnd(
					languageIds
						.split(',')
						.map((language) => t(`language_${language}_prepositional`)),
			  );

	const languageInfo = languagesText
		? ` ${t('ClinicLanguageAssistance', { language: languagesText })}`
		: '';

	return `${name}. ${address}.${languageInfo}`;
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
	<div class="clinic-page">
		<div class="clinic-page-header">
			<el-button @click="backToSearch()" :icon="ArrowLeft">
				{{ t('ToSearchPage') }}
			</el-button>
		</div>
		<div class="clinic-page-content">
			<div v-if="isLoadingClinic" class="loading">
				<div class="loading-spinner"></div>
				<p>{{ t('LoadingClinic') }}</p>
			</div>
			<div v-else-if="isClinicFound" class="clinic-info-container">
				<div class="clinic-info-wrapper">
					<ClinicSummary :clinic="clinicData" />

					<div class="doctors-section">
						<h2 class="section-title">{{ t('DoctorsAtClinic') }}</h2>
						<div v-if="clinicDoctors.length === 0" class="empty-state">
							<p>{{ t('NoDoctorsAtClinic') }}</p>
						</div>
						<DoctorListCard
							v-for="doctor in clinicDoctors"
							:key="doctor.id"
							:doctor="doctor"
							:clinics="[clinicData]"
						/>
					</div>
				</div>
				<DoctorsMap
					ref="clinicsMapRef"
					:doctors="clinicDoctors"
					:clinics="[clinicData]"
					@ready="onMapReady"
				/>
			</div>
			<div v-else class="clinic-info-container">
				<p>{{ t('ClinicNotFound') }}</p>
			</div>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"ClinicLanguageAssistance": "Assistance is provided in {language}."
	},
	"ru": {
		"ClinicLanguageAssistance": "Предоставляется сопровождение на {language} языке."
	},
	"de": {
		"ClinicLanguageAssistance": "Unterstützung wird in {language} bereitgestellt."
	},
	"tr": {
		"ClinicLanguageAssistance": "{language} dilinde destek sağlanır."
	},
	"sr": {
		"ClinicLanguageAssistance": "Pomoć se pruža na {language} jeziku."
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.clinic-page {
	padding: var(--spacing-md);

	.clinic-page-header {
		margin-bottom: var(--spacing-md);
	}

	.clinic-page-content {
		display: flex;
		gap: var(--spacing-2xl);
		justify-content: center;

		.clinic-info-container {
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

			.clinic-info-wrapper {
				display: flex;
				flex-direction: column;
				gap: var(--spacing-2xl);
			}
		}
	}
}

.doctors-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.section-title {
	font-size: var(--font-size-xl);
	font-weight: 600;
	color: #1f2937;
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
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
	.clinic-page {
		.clinic-page-content {
			.clinic-info-container {
				flex-direction: column;
			}
		}
	}
}
</style>
