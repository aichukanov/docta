<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';
import { combineI18nMessages } from '~/i18n/utils';
import { LocationFilled } from '@element-plus/icons-vue';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, languageI18n, cityI18n]),
});

const route = useRoute();
const clinicId = computed(() => Number(route.params.clinicId));

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
	key: `doctors-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: { clinicIds: [clinicId.value] },
});

const { data: labTestsList } = await useFetch('/api/lab-tests/list', {
	key: `lab-tests-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: { clinicIds: [clinicId.value] },
});

const { data: medicationsList } = await useFetch('/api/medications/list', {
	key: `medications-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: { clinicIds: [clinicId.value] },
});

const { data: medicalServicesList } = await useFetch(
	'/api/medical-services/list',
	{
		key: `medical-services-list-clinic-${route.params.clinicId}`,
		method: 'POST',
		body: { clinicIds: [clinicId.value] },
	},
);

const isFound = computed(() => clinicData.value?.id != null);

const clinicDoctors = computed(() => doctorsList.value?.doctors || []);
const clinicLabTests = computed(() => labTestsList.value?.labTests || []);
const clinicMedications = computed(
	() => medicationsList.value?.medications || [],
);
const clinicMedicalServices = computed(
	() => medicalServicesList.value?.medicalServices || [],
);

const clinicAsList = computed(() =>
	isFound.value && clinicData.value ? [clinicData.value] : [],
);

// Лимит элементов по умолчанию
const INITIAL_LIMIT = 10;

// Состояние развернутости для каждого списка
const showAllDoctors = ref(false);
const showAllMedicalServices = ref(false);
const showAllLabTests = ref(false);
const showAllMedications = ref(false);

// Отображаемые элементы с учетом лимита
const visibleDoctors = computed(() =>
	showAllDoctors.value
		? clinicDoctors.value
		: clinicDoctors.value.slice(0, INITIAL_LIMIT),
);
const visibleMedicalServices = computed(() =>
	showAllMedicalServices.value
		? clinicMedicalServices.value
		: clinicMedicalServices.value.slice(0, INITIAL_LIMIT),
);
const visibleLabTests = computed(() =>
	showAllLabTests.value
		? clinicLabTests.value
		: clinicLabTests.value.slice(0, INITIAL_LIMIT),
);
const visibleMedications = computed(() =>
	showAllMedications.value
		? clinicMedications.value
		: clinicMedications.value.slice(0, INITIAL_LIMIT),
);

const getItemLink = (routeName: string, paramName: string, id: number) => ({
	name: routeName,
	params: { [paramName]: id },
	query: getRegionalQuery(locale.value),
});

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
		<template #info="{ showClinicOnMap }">
			<div v-if="clinicData" class="clinic-header">
				<div class="clinic-main-info">
					<h1 class="clinic-title">{{ clinicData.name }}</h1>

					<div class="clinic-address">
						<LocationFilled />
						<span>{{ clinicData.address }}</span>
					</div>

					<ConsultationLanguages :languageIds="clinicData.languageIds">
						{{ t('LanguageAssistance') }}
					</ConsultationLanguages>

					<div class="clinic-actions">
						<ClinicShowOnMapButton
							:clinic="clinicData"
							@click="showClinicOnMap(clinicData)"
						/>
						<ClinicRouteButton :clinic="clinicData" />
					</div>
				</div>

				<div class="clinic-contacts">
					<h2 class="contacts-title">{{ t('Contacts') }}</h2>
					<ContactsList :list="clinicData" />
				</div>
			</div>
		</template>

		<template #clinics>
			<div class="clinic-services">
				<!-- Врачи -->
				<div v-if="clinicDoctors.length > 0" class="service-section">
					<div class="section-header">
						<IconDoctor class="section-icon" />
						<h2 class="section-title">{{ t('DoctorsAtClinic') }}</h2>
						<span class="section-count">{{ clinicDoctors.length }}</span>
					</div>
					<div class="section-content">
						<div class="doctors-list">
							<DoctorInfo
								v-for="doctor in visibleDoctors"
								:key="doctor.id"
								:service="doctor"
							/>
						</div>
						<button
							v-if="clinicDoctors.length > INITIAL_LIMIT"
							class="show-more-button"
							@click="showAllDoctors = !showAllDoctors"
						>
							{{
								showAllDoctors
									? t('ShowLess')
									: t('ShowMore', {
											count: clinicDoctors.length - INITIAL_LIMIT,
									  })
							}}
						</button>
					</div>
				</div>

				<!-- Медицинские услуги -->
				<div v-if="clinicMedicalServices.length > 0" class="service-section">
					<div class="section-header">
						<IconClinic class="section-icon" />
						<h2 class="section-title">{{ t('MedicalServicesAtClinic') }}</h2>
						<span class="section-count">{{
							clinicMedicalServices.length
						}}</span>
					</div>
					<div class="section-content">
						<div class="items-list">
							<div
								v-for="service in visibleMedicalServices"
								:key="service.id"
								class="item-card"
							>
								<NuxtLink
									:to="
										getItemLink(
											'medical-services-serviceId',
											'serviceId',
											service.id,
										)
									"
									class="item-link"
								>
									{{ service.name }}
								</NuxtLink>
								<span
									v-if="service.clinicPrices?.[0]?.price"
									class="item-price"
								>
									{{ service.clinicPrices[0].price }} €
								</span>
							</div>
						</div>
						<button
							v-if="clinicMedicalServices.length > INITIAL_LIMIT"
							class="show-more-button"
							@click="showAllMedicalServices = !showAllMedicalServices"
						>
							{{
								showAllMedicalServices
									? t('ShowLess')
									: t('ShowMore', {
											count: clinicMedicalServices.length - INITIAL_LIMIT,
									  })
							}}
						</button>
					</div>
				</div>

				<!-- Анализы -->
				<div v-if="clinicLabTests.length > 0" class="service-section">
					<div class="section-header">
						<IconSearch class="section-icon" />
						<h2 class="section-title">{{ t('LabTestsAtClinic') }}</h2>
						<span class="section-count">{{ clinicLabTests.length }}</span>
					</div>
					<div class="section-content">
						<div class="items-list">
							<div
								v-for="labTest in visibleLabTests"
								:key="labTest.id"
								class="item-card"
							>
								<NuxtLink
									:to="
										getItemLink('lab-tests-labTestId', 'labTestId', labTest.id)
									"
									class="item-link"
								>
									{{ labTest.name }}
								</NuxtLink>
								<span
									v-if="labTest.clinicPrices?.[0]?.price"
									class="item-price"
								>
									{{ labTest.clinicPrices[0].price }} €
								</span>
							</div>
						</div>
						<button
							v-if="clinicLabTests.length > INITIAL_LIMIT"
							class="show-more-button"
							@click="showAllLabTests = !showAllLabTests"
						>
							{{
								showAllLabTests
									? t('ShowLess')
									: t('ShowMore', {
											count: clinicLabTests.length - INITIAL_LIMIT,
									  })
							}}
						</button>
					</div>
				</div>

				<!-- Лекарства -->
				<div v-if="clinicMedications.length > 0" class="service-section">
					<div class="section-header">
						<IconCheck class="section-icon" />
						<h2 class="section-title">{{ t('MedicationsAtClinic') }}</h2>
						<span class="section-count">{{ clinicMedications.length }}</span>
					</div>
					<div class="section-content">
						<div class="items-list">
							<div
								v-for="medication in visibleMedications"
								:key="medication.id"
								class="item-card"
							>
								<NuxtLink
									:to="
										getItemLink(
											'medications-medicationId',
											'medicationId',
											medication.id,
										)
									"
									class="item-link"
								>
									{{ medication.name }}
								</NuxtLink>
								<span
									v-if="medication.clinicPrices?.[0]?.price"
									class="item-price"
								>
									{{ medication.clinicPrices[0].price }} €
								</span>
							</div>
						</div>
						<button
							v-if="clinicMedications.length > INITIAL_LIMIT"
							class="show-more-button"
							@click="showAllMedications = !showAllMedications"
						>
							{{
								showAllMedications
									? t('ShowLess')
									: t('ShowMore', {
											count: clinicMedications.length - INITIAL_LIMIT,
									  })
							}}
						</button>
					</div>
				</div>

				<!-- Если ничего нет -->
				<div
					v-if="
						clinicDoctors.length === 0 &&
						clinicMedicalServices.length === 0 &&
						clinicLabTests.length === 0 &&
						clinicMedications.length === 0
					"
					class="empty-state"
				>
					<p>{{ t('NoServicesAtClinic') }}</p>
				</div>
			</div>
		</template>
	</DetailsPage>
</template>

<i18n lang="json">
{
	"en": {
		"ClinicLanguageAssistance": "Assistance is provided in {language}.",
		"LanguageAssistance": "The clinic provides assistance in:",
		"Contacts": "Contacts",
		"MedicalServicesAtClinic": "Medical services",
		"LabTestsAtClinic": "Lab tests",
		"MedicationsAtClinic": "Medications",
		"NoServicesAtClinic": "No services available at this clinic",
		"ShowMore": "Show more ({count})",
		"ShowLess": "Show less"
	},
	"ru": {
		"ClinicLanguageAssistance": "Предоставляется сопровождение на {language} языке.",
		"LanguageAssistance": "В клинике предоставляется сопровождение на следующих языках:",
		"Contacts": "Контакты",
		"MedicalServicesAtClinic": "Медицинские услуги",
		"LabTestsAtClinic": "Анализы",
		"MedicationsAtClinic": "Лекарства",
		"NoServicesAtClinic": "В этой клинике нет доступных услуг",
		"ShowMore": "Показать ещё ({count})",
		"ShowLess": "Свернуть"
	},
	"de": {
		"ClinicLanguageAssistance": "Unterstützung wird in {language} bereitgestellt.",
		"LanguageAssistance": "Die Klinik bietet Unterstützung in:",
		"Contacts": "Kontakte",
		"MedicalServicesAtClinic": "Medizinische Dienstleistungen",
		"LabTestsAtClinic": "Laboruntersuchungen",
		"MedicationsAtClinic": "Medikamente",
		"NoServicesAtClinic": "Keine Dienstleistungen in dieser Klinik verfügbar",
		"ShowMore": "Mehr anzeigen ({count})",
		"ShowLess": "Weniger anzeigen"
	},
	"tr": {
		"ClinicLanguageAssistance": "{language} dilinde destek sağlanır.",
		"LanguageAssistance": "Klinik aşağıdaki dillerde destek sunar:",
		"Contacts": "İletişim",
		"MedicalServicesAtClinic": "Tıbbi hizmetler",
		"LabTestsAtClinic": "Laboratuvar testleri",
		"MedicationsAtClinic": "İlaçlar",
		"NoServicesAtClinic": "Bu klinikte hizmet bulunmamaktadır",
		"ShowMore": "Daha fazla göster ({count})",
		"ShowLess": "Daha az göster"
	},
	"sr": {
		"ClinicLanguageAssistance": "Pomoć se pruža na {language} jeziku.",
		"LanguageAssistance": "Klinika pruža pomoć na sledećim jezicima:",
		"Contacts": "Kontakti",
		"MedicalServicesAtClinic": "Medicinske usluge",
		"LabTestsAtClinic": "Laboratorijske analize",
		"MedicationsAtClinic": "Lekovi",
		"NoServicesAtClinic": "Nema dostupnih usluga u ovoj klinici",
		"ShowMore": "Prikaži više ({count})",
		"ShowLess": "Prikaži manje"
	}
}
</i18n>

<style lang="less" scoped>
.clinic-header {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-lg) var(--spacing-xl);
}

.clinic-main-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.clinic-title {
	font-size: var(--font-size-2xl);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.clinic-address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);

	svg {
		width: 18px;
		height: 18px;
		flex-shrink: 0;
	}
}

.clinic-actions {
	display: flex;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-sm);
}

.clinic-contacts {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-light);
}

.contacts-title {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
}

.clinic-services {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.service-section {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	overflow: hidden;
}

.section-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: linear-gradient(to right, rgba(79, 70, 229, 0.04), transparent);
	border-bottom: 1px solid var(--color-border-light);
}

.section-icon {
	width: 24px;
	height: 24px;
	color: var(--color-primary);
	flex-shrink: 0;
}

.section-title {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	flex: 1;
	font-family: system-ui, -apple-system, sans-serif;
}

.section-count {
	background: var(--color-primary);
	color: white;
	font-size: var(--font-size-sm);
	font-weight: 600;
	padding: var(--spacing-xs) var(--spacing-sm);
	border-radius: var(--border-radius-full);
	min-width: 28px;
	text-align: center;
}

.section-content {
	padding: var(--spacing-lg) var(--spacing-xl);
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}

.doctors-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.items-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.item-card {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: var(--spacing-sm) var(--spacing-md);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-sm);
	transition: all var(--transition-base);

	&:hover {
		background: rgba(79, 70, 229, 0.06);
	}
}

.item-link {
	color: var(--color-primary);
	text-decoration: none;
	font-weight: 500;

	&:hover {
		text-decoration: underline;
	}
}

.item-price {
	font-weight: 600;
	color: var(--color-text-primary);
	white-space: nowrap;
}

.show-more-button {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: var(--spacing-md);
	margin-top: var(--spacing-md);
	background: transparent;
	border: 1px dashed var(--color-border-light);
	border-radius: var(--border-radius-md);
	color: var(--color-primary);
	font-size: var(--font-size-sm);
	font-weight: 500;
	cursor: pointer;
	transition: all var(--transition-base);

	&:hover {
		border-color: var(--color-primary);
		background: rgba(79, 70, 229, 0.04);
	}
}
</style>
