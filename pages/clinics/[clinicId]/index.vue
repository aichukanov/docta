<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import {
	buildClinicSchema,
	buildBreadcrumbsSchema,
} from '~/common/schema-org-builders';
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import languageI18n from '~/i18n/language';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import specialtyI18n from '~/i18n/specialty';
import labTestCategoryI18n from '~/i18n/labtest-category';
import { combineI18nMessages } from '~/i18n/utils';
import { getLocalizedName } from '~/common/utils';
import { formatClinicAddressLine } from '~/common/clinic-address';
import type { ClinicPrice } from '~/interfaces/clinic';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		languageI18n,
		cityI18n,
		medicalServiceCategoryI18n,
		specialtyI18n,
		labTestCategoryI18n,
	]),
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
			locale: locale.value,
		})),
	},
);

const { data: doctorsList } = await useFetch('/api/doctors/list', {
	key: `doctors-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: computed(() => ({ clinicIds: [clinicId.value], locale: locale.value })),
});

const { data: labTestsList } = await useFetch('/api/labtests/list', {
	key: `labtests-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: computed(() => ({ clinicIds: [clinicId.value], locale: locale.value })),
});

const { data: medicationsList } = await useFetch('/api/medications/list', {
	key: `medications-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: computed(() => ({ clinicIds: [clinicId.value], locale: locale.value })),
});

const { data: medicalServicesList } = await useFetch('/api/services/list', {
	key: `services-list-clinic-${route.params.clinicId}`,
	method: 'POST',
	body: computed(() => ({ clinicIds: [clinicId.value], locale: locale.value })),
});

const isFound = computed(() => clinicData.value?.id != null);

const localizedName = computed(() =>
	getLocalizedName(clinicData.value, locale.value),
);

// Set HTTP 404 status for not found clinic
if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const clinicDescription = computed(() => {
	if (!isFound.value || !clinicData.value) {
		return '';
	}

	return clinicData.value.description || '';
});

const clinicDoctors = computed(() => doctorsList.value?.doctors || []);
const clinicLabTests = computed(() => labTestsList.value?.items || []);
const clinicMedications = computed(() => medicationsList.value?.items || []);
const clinicMedicalServices = computed(
	() => medicalServicesList.value?.items || [],
);

// Группировка врачей по специальностям с переводами
const clinicDoctorsBySpecialty = useItemsByCategory(clinicDoctors, (doctor) =>
	doctor.specialtyIds?.split(',').map(Number).filter(Boolean),
);

const doctorCategoriesWithTitles = computed(() => ({
	categories: clinicDoctorsBySpecialty.value.categories.map((cat) => ({
		title: t(`specialty_${cat.categoryId}`),
		items: cat.items,
	})),
	otherCategory:
		clinicDoctorsBySpecialty.value.itemsWithoutCategory.length > 0
			? {
					title: t('OtherDoctors'),
					items: clinicDoctorsBySpecialty.value.itemsWithoutCategory,
			  }
			: undefined,
}));

// Группировка медицинских услуг по категориям с переводами
const clinicMedicalServicesByCategory = useItemsByCategory(
	clinicMedicalServices,
	(service) => service.categoryIds,
);

const serviceCategoriesWithTitles = computed(() => ({
	categories: clinicMedicalServicesByCategory.value.categories.map((cat) => ({
		title: t(`medical_service_category_${cat.categoryId}`),
		items: cat.items,
	})),
	otherCategory:
		clinicMedicalServicesByCategory.value.itemsWithoutCategory.length > 0
			? {
					title: t('OtherServices'),
					items: clinicMedicalServicesByCategory.value.itemsWithoutCategory,
			  }
			: undefined,
}));

// Группировка анализов по категориям с переводами
const clinicLabTestsByCategory = useItemsByCategory(
	clinicLabTests,
	(labTest) => labTest.categoryIds,
);

const labTestCategoriesWithTitles = computed(() => ({
	categories: clinicLabTestsByCategory.value.categories.map((cat) => ({
		title: t(`lab_test_category_${cat.categoryId}`),
		items: cat.items,
	})),
	otherCategory:
		clinicLabTestsByCategory.value.itemsWithoutCategory.length > 0
			? {
					title: t('OtherLabTests'),
					items: clinicLabTestsByCategory.value.itemsWithoutCategory,
			  }
			: undefined,
}));

const getClinicPrice = (clinicPrices?: ClinicPrice[]) => {
	return clinicPrices?.find((price) => price.clinicId === clinicId.value);
};

const clinicAsList = computed(() =>
	isFound.value && clinicData.value ? [clinicData.value] : [],
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

	return `${localizedName.value} | ${t(`city_${clinicData.value.cityId}`)}`;
});

const pageDescription = computed(() => {
	if (!isFound.value || !clinicData.value) {
		return '';
	}

	const { languageIds } = clinicData.value;
	const clinicName = localizedName.value;

	const addressText = formatClinicAddressLine({
		clinic: clinicData.value,
		cityName: t(`city_${clinicData.value.cityId}`),
	});

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

	return addressText
		? `${clinicName}. ${addressText}.${languageInfo}`
		: `${clinicName}.${languageInfo}`;
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

const schemaOrgStore = useSchemaOrgStore();

const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogType: 'business.business',
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

watchEffect(() => {
	if (clinicData.value && isFound.value) {
		const clinicUrl = `${SITE_URL}/clinics/${clinicData.value.id}`;

		schemaOrgStore.setSchemas([
			...buildClinicSchema({
				siteUrl: SITE_URL,
				clinic: clinicData.value,
				locale: locale.value,
				pageTitle: pageTitle.value,
				pageDescription: pageDescription.value,
				getCityName,
				services: clinicMedicalServices.value,
				doctors: clinicDoctors.value,
			}),
			buildBreadcrumbsSchema(clinicUrl, [
				{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
				{ name: t('BreadcrumbClinics'), url: `${SITE_URL}/clinics` },
				{ name: pageTitle.value },
			]),
		]);
	}
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
			<ClinicHeader
				v-if="clinicData"
				:clinic="clinicData"
				:cityName="t(`city_${clinicData.cityId}`)"
				:description="clinicDescription"
				:languageAssistanceLabel="t('LanguageAssistance')"
				:contactsLabel="t('Contacts')"
				:showOnMapLabel="t('AriaShowOnMap')"
				@showOnMap="showClinicOnMap"
			/>
		</template>

		<template #clinics>
			<div class="clinic-services">
				<!-- Врачи -->
				<ClinicCategorizedSection
					:title="t('DoctorsAtClinic')"
					:totalCount="clinicDoctors.length"
					routeName="doctors"
					:categories="doctorCategoriesWithTitles.categories"
					:otherCategory="doctorCategoriesWithTitles.otherCategory"
				>
					<template #icon>
						<IconDoctor />
					</template>
					<template #default="{ item }">
						<DoctorInfo :service="item" short headingLevel="h4" />
					</template>
				</ClinicCategorizedSection>

				<!-- Медицинские услуги -->
				<ClinicCategorizedSection
					:title="t('MedicalServicesAtClinic')"
					:totalCount="clinicMedicalServices.length"
					routeName="services"
					:categories="serviceCategoriesWithTitles.categories"
					:otherCategory="serviceCategoriesWithTitles.otherCategory"
				>
					<template #icon>
						<IconMedicalService />
					</template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							:priceMin="getClinicPrice(item.clinicPrices)?.priceMin"
							routeName="services-serviceId"
							routeParamName="serviceId"
						/>
					</template>
				</ClinicCategorizedSection>

				<!-- Анализы -->
				<ClinicCategorizedSection
					:title="t('LabTestsAtClinic')"
					:totalCount="clinicLabTests.length"
					routeName="labtests"
					:categories="labTestCategoriesWithTitles.categories"
					:otherCategory="labTestCategoriesWithTitles.otherCategory"
				>
					<template #icon>
						<IconLabTest />
					</template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							routeName="labtests-labTestId"
							routeParamName="labTestId"
						/>
					</template>
				</ClinicCategorizedSection>

				<!-- Лекарства -->
				<ClinicServiceSection
					:title="t('MedicationsAtClinic')"
					:items="clinicMedications"
					routeName="medications"
				>
					<template #icon>
						<IconMedication />
					</template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:name="item.name"
							:localName="item.localName"
							:price="getClinicPrice(item.clinicPrices)?.price"
							:priceMax="getClinicPrice(item.clinicPrices)?.priceMax"
							routeName="medications-medicationId"
							routeParamName="medicationId"
						/>
					</template>
				</ClinicServiceSection>

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
		"NoServicesAtClinic": "Information about services at this clinic is not yet available",
		"OtherServices": "Other services",
		"OtherDoctors": "Other doctors",
		"OtherLabTests": "Other lab tests",
		"AriaClinicInfo": "Clinic information",
		"AriaClinicAddress": "Clinic address",
		"AriaClinicActions": "Clinic actions",
		"AriaShowOnMap": "Show on map",
		"AriaContactsSection": "Clinic contacts",
		"AriaClinicServices": "Clinic services"
	},
	"ru": {
		"ClinicLanguageAssistance": "Предоставляется сопровождение на {language} языке.",
		"LanguageAssistance": "В клинике предоставляется сопровождение на следующих языках:",
		"Contacts": "Контакты",
		"MedicalServicesAtClinic": "Медицинские услуги",
		"LabTestsAtClinic": "Анализы",
		"MedicationsAtClinic": "Лекарства",
		"NoServicesAtClinic": "У нас пока нет информации об услугах этой клиники",
		"OtherServices": "Другие услуги",
		"OtherDoctors": "Другие врачи",
		"OtherLabTests": "Другие анализы",
		"AriaClinicInfo": "Информация о клинике",
		"AriaClinicAddress": "Адрес клиники",
		"AriaClinicActions": "Действия с клиникой",
		"AriaShowOnMap": "Показать на карте",
		"AriaContactsSection": "Контакты клиники",
		"AriaClinicServices": "Услуги клиники"
	},
	"de": {
		"ClinicLanguageAssistance": "Unterstützung wird in {language} bereitgestellt.",
		"LanguageAssistance": "Die Klinik bietet Unterstützung in:",
		"Contacts": "Kontakte",
		"MedicalServicesAtClinic": "Medizinische Dienstleistungen",
		"LabTestsAtClinic": "Laboruntersuchungen",
		"MedicationsAtClinic": "Medikamente",
		"NoServicesAtClinic": "Informationen über die Leistungen dieser Klinik sind noch nicht verfügbar",
		"OtherServices": "Andere Dienstleistungen",
		"OtherDoctors": "Andere Ärzte",
		"OtherLabTests": "Andere Laboruntersuchungen",
		"AriaClinicInfo": "Klinikinformationen",
		"AriaClinicAddress": "Klinikadresse",
		"AriaClinicActions": "Klinikaktionen",
		"AriaShowOnMap": "Auf Karte anzeigen",
		"AriaContactsSection": "Klinikkontakte",
		"AriaClinicServices": "Klinikleistungen"
	},
	"tr": {
		"ClinicLanguageAssistance": "{language} dilinde destek sağlanır.",
		"LanguageAssistance": "Klinik aşağıdaki dillerde destek sunar:",
		"Contacts": "İletişim",
		"MedicalServicesAtClinic": "Tıbbi hizmetler",
		"LabTestsAtClinic": "Laboratuvar testleri",
		"MedicationsAtClinic": "İlaçlar",
		"NoServicesAtClinic": "Bu kliniğin hizmetleri hakkında henüz bilgi bulunmamaktadır",
		"OtherServices": "Diğer hizmetler",
		"OtherDoctors": "Diğer doktorlar",
		"OtherLabTests": "Diğer laboratuvar testleri",
		"AriaClinicInfo": "Klinik bilgileri",
		"AriaClinicAddress": "Klinik adresi",
		"AriaClinicActions": "Klinik işlemleri",
		"AriaShowOnMap": "Haritada göster",
		"AriaContactsSection": "Klinik iletişim",
		"AriaClinicServices": "Klinik hizmetleri"
	},
	"sr": {
		"ClinicLanguageAssistance": "Pomoć se pruža na {language} jeziku.",
		"LanguageAssistance": "Klinika pruža pomoć na sledećim jezicima:",
		"Contacts": "Kontakti",
		"MedicalServicesAtClinic": "Medicinske usluge",
		"LabTestsAtClinic": "Laboratorijske analize",
		"MedicationsAtClinic": "Lekovi",
		"NoServicesAtClinic": "Trenutno nemamo informacije o uslugama ove klinike",
		"OtherServices": "Ostale usluge",
		"OtherDoctors": "Ostali lekari",
		"OtherLabTests": "Ostale analize",
		"AriaClinicInfo": "Informacije o klinici",
		"AriaClinicAddress": "Adresa klinike",
		"AriaClinicActions": "Akcije klinike",
		"AriaShowOnMap": "Prikaži na mapi",
		"AriaContactsSection": "Kontakti klinike",
		"AriaClinicServices": "Usluge klinike"
	},
	"sr-cyrl": {
		"ClinicLanguageAssistance": "Помоћ се пружа на {language} језику.",
		"LanguageAssistance": "Клиника пружа помоћ на следећим језицима:",
		"Contacts": "Контакти",
		"MedicalServicesAtClinic": "Медицинске услуге",
		"LabTestsAtClinic": "Лабораторијске анализе",
		"MedicationsAtClinic": "Лекови",
		"NoServicesAtClinic": "Тренутно немамо информације о услугама ове клинике",
		"OtherServices": "Остале услуге",
		"OtherDoctors": "Остали лекари",
		"OtherLabTests": "Остале анализе",
		"AriaClinicInfo": "Информације о клиници",
		"AriaClinicAddress": "Адреса клинике",
		"AriaClinicActions": "Акције клинике",
		"AriaShowOnMap": "Прикажи на мапи",
		"AriaContactsSection": "Контакти клинике",
		"AriaClinicServices": "Услуге клинике"
	}
}
</i18n>

<style lang="less" scoped>
.clinic-services {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}
</style>
