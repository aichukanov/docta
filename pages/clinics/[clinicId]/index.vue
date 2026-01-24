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
import { combineI18nMessages } from '~/i18n/utils';
import { LocationFilled } from '@element-plus/icons-vue';
import { formatClinicAddressLine } from '~/common/clinic-address';
import { getLocalizedName } from '~/common/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		languageI18n,
		cityI18n,
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
			<header v-if="clinicData" class="clinic-header">
				<div class="clinic-main-info">
					<h1 class="clinic-title">{{ localizedName }}</h1>

					<address class="clinic-address">
						<LocationFilled aria-hidden="true" />
						<span>{{
							formatClinicAddressLine({
								clinic: clinicData,
								cityName: t(`city_${clinicData.cityId}`),
							})
						}}</span>
					</address>

					<ConsultationLanguages :languageIds="clinicData.languageIds">
						{{ t('LanguageAssistance') }}
					</ConsultationLanguages>

					<div class="clinic-actions" role="group">
						<ClinicShowOnMapButton
							:clinic="clinicData"
							:aria-label="t('AriaShowOnMap')"
							@click="showClinicOnMap(clinicData)"
						/>
						<ClinicRouteButton :clinic="clinicData" />
					</div>

					<MarkedContent
						v-if="clinicDescription"
						:content="clinicDescription"
						class="clinic-description-container"
					/>
				</div>

				<section class="clinic-contacts" :aria-label="t('AriaContactsSection')">
					<h2 class="contacts-title">{{ t('Contacts') }}</h2>
					<ContactsList :list="clinicData" />
				</section>
			</header>
		</template>

		<template #clinics>
			<div class="clinic-services">
				<!-- Врачи -->
				<ClinicServiceSection
					:title="t('DoctorsAtClinic')"
					:items="clinicDoctors"
					routeName="doctors"
				>
					<template #icon>
						<IconDoctor />
					</template>
					<template #default="{ item }">
						<DoctorInfo :service="item" short headingLevel="h3" />
					</template>
				</ClinicServiceSection>

				<!-- Медицинские услуги -->
				<ClinicServiceSection
					:title="t('MedicalServicesAtClinic')"
					:items="clinicMedicalServices"
					routeName="services"
				>
					<template #icon>
						<IconMedicalService />
					</template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:name="item.name"
							:localName="item.localName"
							:price="item.clinicPrices?.[0]?.price"
							:priceMax="item.clinicPrices?.[0]?.priceMax"
							:priceMin="item.clinicPrices?.[0]?.priceMin"
							routeName="services-serviceId"
							routeParamName="serviceId"
						/>
					</template>
				</ClinicServiceSection>

				<!-- Анализы -->
				<ClinicServiceSection
					:title="t('LabTestsAtClinic')"
					:items="clinicLabTests"
					routeName="labtests"
				>
					<template #icon>
						<IconLabTest />
					</template>
					<template #default="{ item }">
						<PricedItemCard
							:id="item.id"
							:name="item.name"
							:localName="item.localName"
							:price="item.clinicPrices?.[0]?.price"
							:priceMax="item.clinicPrices?.[0]?.priceMax"
							routeName="labtests-labTestId"
							routeParamName="labTestId"
						/>
					</template>
				</ClinicServiceSection>

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
							:price="item.clinicPrices?.[0]?.price"
							:priceMax="item.clinicPrices?.[0]?.priceMax"
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
	font-style: normal;

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

.clinic-description-container {
	margin-top: var(--spacing-xs);
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

.empty-state {
	text-align: center;
	padding: 40px;
	color: #6b7280;
}
</style>
