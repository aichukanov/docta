<script setup lang="ts">
import { Clock } from '@element-plus/icons-vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import {
	buildBreadcrumbsSchema,
	buildClinicSchema,
} from '~/common/schema-org-builders';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import clinicCommonI18n from '~/i18n/clinic-common';
import clinicTypeI18n from '~/i18n/clinic-type';
import labTestCategoryI18n from '~/i18n/labtest-category';
import languageI18n from '~/i18n/language';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import reviewsI18n from '~/i18n/reviews';
import specialtyI18n from '~/i18n/specialty';
import workingHoursI18n from '~/i18n/working-hours';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicPrice } from '~/interfaces/clinic';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		clinicCommonI18n,
		clinicTypeI18n,
		languageI18n,
		cityI18n,
		medicalServiceCategoryI18n,
		specialtyI18n,
		labTestCategoryI18n,
		reviewsI18n,
		workingHoursI18n,
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

const { data: workingHoursData } = await useFetch<WorkingHours>(
	'/api/clinics/working-hours',
	{
		key: `clinic-wh-${route.params.clinicId}`,
		method: 'POST',
		body: { clinicId: route.params.clinicId },
	},
);

const hasWorkingHours = computed(() => {
	if (!workingHoursData.value) return false;
	return DAYS_OF_WEEK.some(
		(day) => workingHoursData.value![day]?.type !== 'not_specified',
	);
});

const isFound = computed(() => clinicData.value?.id != null);

const localizedName = computed(() =>
	getLocalizedName(clinicData.value, locale.value),
);

const clinicTypeNames = computed(() => {
	if (!clinicData.value?.clinicTypeIds) return [];
	return clinicData.value.clinicTypeIds
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id) => t(`clinic_type_${id}`));
});

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

const hasServices = computed(
	() =>
		clinicMedicalServices.value.length > 0 ||
		clinicLabTests.value.length > 0 ||
		clinicMedications.value.length > 0,
);

const totalServicesCount = computed(
	() =>
		clinicMedicalServices.value.length +
		clinicLabTests.value.length +
		clinicMedications.value.length,
);

const tabs = computed(() => {
	const result = [];
	if (clinicDescription.value) {
		result.push({ id: 'about', label: t('TabAbout') });
	}
	result.push({ id: 'contacts', label: t('TabContacts') });
	if (hasWorkingHours.value) {
		result.push({ id: 'hours', label: t('WorkingHours') });
	}
	if (clinicDoctors.value.length > 0) {
		result.push({
			id: 'doctors',
			label: `${t('TabDoctors')} (${clinicDoctors.value.length})`,
		});
	}
	if (hasServices.value) {
		result.push({
			id: 'services',
			label: `${t('TabServices')} (${totalServicesCount.value})`,
		});
	}
	if (clinicData.value?.reviews?.length) {
		result.push({
			id: 'reviews',
			label: `${t('TabReviews')} (${
				clinicData.value.rating?.totalReviews || clinicData.value.reviews.length
			})`,
		});
	}
	result.push({ id: 'map', label: t('TabMap') });
	return result;
});

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);

const scrollToMap = () => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
	if (clinicData.value) {
		mapRef.value?.openClinicPopup(clinicData.value);
	}
};

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
				workingHours: workingHoursData.value,
				rating: clinicData.value.rating,
				reviews: clinicData.value.reviews?.map((review) => ({
					id: review.id,
					text: review.text,
					rating: review.rating,
					author: review.author,
					publishedAt: review.publishedAt,
					provider: review.provider,
				})),
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
	<EntityPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		backRouteName="clinics"
		:loadingText="t('LoadingClinic')"
		:notFoundText="t('ClinicNotFound')"
		:tabs="tabs"
	>
		<template #hero>
			<ClinicHero
				v-if="clinicData"
				:clinic="clinicData"
				:cityName="t(`city_${clinicData.cityId}`)"
				:languageAssistanceLabel="t('LanguageAssistance')"
				:clinicTypeNames="clinicTypeNames"
				@scrollToMap="scrollToMap"
			/>
		</template>

		<template #sections>
			<!-- About -->
			<EntityPageSection
				v-if="clinicDescription"
				sectionId="about"
				:title="t('TabAbout')"
			>
				<template #icon><IconInfo :size="20" /></template>
				<MarkedContent :content="clinicDescription" />
			</EntityPageSection>

			<!-- Contacts -->
			<EntityPageSection
				v-if="clinicData"
				sectionId="contacts"
				:title="t('TabContacts')"
			>
				<template #icon><IconPhone :size="20" /></template>
				<ContactsList :list="clinicData" />
			</EntityPageSection>

			<!-- Working Hours -->
			<EntityPageSection
				v-if="hasWorkingHours"
				sectionId="hours"
				:title="t('WorkingHours')"
			>
				<template #icon><el-icon :size="20"><Clock /></el-icon></template>
				<ClinicWorkingHours :clinicId="clinicId" />
			</EntityPageSection>

			<!-- Doctors -->
			<EntityPageSection v-if="clinicDoctors.length > 0" sectionId="doctors">
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
			</EntityPageSection>

			<!-- Services -->
			<EntityPageSection v-if="hasServices" sectionId="services">
				<div class="clinic-services">
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
				</div>
			</EntityPageSection>

			<!-- Reviews -->
			<EntityPageSection
				v-if="clinicData?.reviews?.length"
				sectionId="reviews"
				:title="t('TabReviews')"
				:count="clinicData.rating?.totalReviews || clinicData.reviews.length"
			>
				<template #icon><IconStar :size="20" /></template>
				<DoctorReviews
					:reviews="clinicData.reviews"
					:rating="clinicData.rating"
					:noReviewsText="t('NoReviewsClinic')"
				/>
			</EntityPageSection>

			<!-- Map -->
			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon><IconMapPin :size="20" color="#ffffff" /></template>
				<div class="clinic-map">
					<ClinicServicesMap
						ref="mapRef"
						:services="[]"
						:clinics="clinicAsList"
						:showAllClinics="true"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<i18n lang="json">
{
	"en": {
		"ClinicLanguageAssistance": "Assistance is provided in {language}.",
		"Contacts": "Contacts",
		"MedicalServicesAtClinic": "Medical services",
		"LabTestsAtClinic": "Lab tests",
		"MedicationsAtClinic": "Medications",
		"NoServicesAtClinic": "Information about services at this clinic is not yet available",
		"OtherServices": "Other services",
		"OtherDoctors": "Other doctors",
		"OtherLabTests": "Other lab tests",
		"TabAbout": "About",
		"TabContacts": "Contacts",
		"TabDoctors": "Doctors",
		"TabServices": "Services",
		"TabReviews": "Reviews",
		"TabMap": "Location"
	},
	"ru": {
		"ClinicLanguageAssistance": "Предоставляется сопровождение на {language} языке.",
		"Contacts": "Контакты",
		"MedicalServicesAtClinic": "Медицинские услуги",
		"LabTestsAtClinic": "Анализы",
		"MedicationsAtClinic": "Лекарства",
		"NoServicesAtClinic": "У нас пока нет информации об услугах этой клиники",
		"OtherServices": "Другие услуги",
		"OtherDoctors": "Другие врачи",
		"OtherLabTests": "Другие анализы",
		"TabAbout": "О клинике",
		"TabContacts": "Контакты",
		"TabDoctors": "Врачи",
		"TabServices": "Услуги",
		"TabReviews": "Отзывы",
		"TabMap": "На карте"
	},
	"de": {
		"ClinicLanguageAssistance": "Unterstützung wird in {language} bereitgestellt.",
		"Contacts": "Kontakte",
		"MedicalServicesAtClinic": "Medizinische Dienstleistungen",
		"LabTestsAtClinic": "Laboruntersuchungen",
		"MedicationsAtClinic": "Medikamente",
		"NoServicesAtClinic": "Informationen über die Leistungen dieser Klinik sind noch nicht verfügbar",
		"OtherServices": "Andere Dienstleistungen",
		"OtherDoctors": "Andere Ärzte",
		"OtherLabTests": "Andere Laboruntersuchungen",
		"TabAbout": "Über uns",
		"TabContacts": "Kontakte",
		"TabDoctors": "Ärzte",
		"TabServices": "Leistungen",
		"TabReviews": "Bewertungen",
		"TabMap": "Standort"
	},
	"tr": {
		"ClinicLanguageAssistance": "{language} dilinde destek sağlanır.",
		"Contacts": "İletişim",
		"MedicalServicesAtClinic": "Tıbbi hizmetler",
		"LabTestsAtClinic": "Laboratuvar testleri",
		"MedicationsAtClinic": "İlaçlar",
		"NoServicesAtClinic": "Bu kliniğin hizmetleri hakkında henüz bilgi bulunmamaktadır",
		"OtherServices": "Diğer hizmetler",
		"OtherDoctors": "Diğer doktorlar",
		"OtherLabTests": "Diğer laboratuvar testleri",
		"TabAbout": "Hakkında",
		"TabContacts": "İletişim",
		"TabDoctors": "Doktorlar",
		"TabServices": "Hizmetler",
		"TabReviews": "Değerlendirmeler",
		"TabMap": "Konum"
	},
	"sr": {
		"ClinicLanguageAssistance": "Pomoć se pruža na {language} jeziku.",
		"Contacts": "Kontakti",
		"MedicalServicesAtClinic": "Medicinske usluge",
		"LabTestsAtClinic": "Laboratorijske analize",
		"MedicationsAtClinic": "Lekovi",
		"NoServicesAtClinic": "Trenutno nemamo informacije o uslugama ove klinike",
		"OtherServices": "Ostale usluge",
		"OtherDoctors": "Ostali lekari",
		"OtherLabTests": "Ostale analize",
		"TabAbout": "O klinici",
		"TabContacts": "Kontakti",
		"TabDoctors": "Lekari",
		"TabServices": "Usluge",
		"TabReviews": "Recenzije",
		"TabMap": "Lokacija"
	},
	"sr-cyrl": {
		"ClinicLanguageAssistance": "Помоћ се пружа на {language} језику.",
		"Contacts": "Контакти",
		"MedicalServicesAtClinic": "Медицинске услуге",
		"LabTestsAtClinic": "Лабораторијске анализе",
		"MedicationsAtClinic": "Лекови",
		"NoServicesAtClinic": "Тренутно немамо информације о услугама ове клинике",
		"OtherServices": "Остале услуге",
		"OtherDoctors": "Остали лекари",
		"OtherLabTests": "Остале анализе",
		"TabAbout": "О клиници",
		"TabContacts": "Контакти",
		"TabDoctors": "Лекари",
		"TabServices": "Услуге",
		"TabReviews": "Рецензије",
		"TabMap": "Локација"
	}
}
</i18n>

<style lang="less" scoped>
.clinic-services {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.clinic-map {
	height: 400px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-light);
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}
</style>
