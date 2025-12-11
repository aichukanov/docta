<script setup lang="ts">
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';
import { combineI18nMessages } from '~/i18n/utils';

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, languageI18n, cityI18n]),
});

const route = useRoute();

const { pending: isLoading, data: clinicData } = await useFetch(
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

const isFound = computed(() => clinicData.value?.id != null);

const clinicDoctors = computed(() => {
	if (!isFound.value || !doctorsList.value?.doctors) {
		return [];
	}

	return doctorsList.value.doctors.filter((doctor) => {
		const clinicIds = doctor.clinicIds.split(',').map(Number);
		return clinicIds.includes(clinicData.value.id);
	});
});

const clinicAsList = computed(() =>
	isFound.value && clinicData.value ? [clinicData.value] : [],
);

const pageTitle = computed(() => {
	if (!isFound.value) {
		return '';
	}

	return `${clinicData.value.name} | ${t(`city_${clinicData.value.cityId}`)}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !clinicData.value) {
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
	<DetailsPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		:clinics="clinicAsList"
		backRouteName="clinics"
		:loadingText="t('LoadingClinic')"
		:notFoundText="t('ClinicNotFound')"
	>
		<template #info>
			<ClinicSummary v-if="clinicData" :clinic="clinicData" />
		</template>

		<template #clinics>
			<div class="doctors-section">
				<h2 class="section-title">{{ t('DoctorsAtClinic') }}</h2>
				<div v-if="clinicDoctors.length === 0" class="empty-state">
					<p>{{ t('NoDoctorsAtClinic') }}</p>
				</div>
				<div v-else class="doctors-list">
					<DoctorInfo
						v-for="doctor in clinicDoctors"
						:key="doctor.id"
						:service="doctor"
					/>
				</div>
			</div>
		</template>
	</DetailsPage>
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

.doctors-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}
</style>
