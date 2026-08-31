<script setup lang="ts">
import { SITE_URL, OG_IMAGE } from '~/common/constants';
import { CLINIC_SUPPORT_LANGUAGE_IDS } from '~/common/articles';
import { getRegionalQuery, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildCollectionPageSchemas,
	buildTopListItemElements,
} from '~/common/schema-org-builders';
import { buildArticleImageSrcSet } from '~/components/article-page.vue';
import { combineI18nMessages } from '~/i18n/utils';
import { LanguageId } from '~/enums/language';
import articlesI18n from '~/i18n/articles';
import cityHealthcareI18n from '~/i18n/article-city-healthcare';
import weekendMedicalHelpI18n from '~/i18n/article-weekend-medical-help';
import articleUnavailableI18n from '~/i18n/article-medications-unavailable';
import articleAllergyI18n from '~/i18n/article-allergy-medicines';
import breadcrumbI18n from '~/i18n/breadcrumb';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		articlesI18n,
		cityHealthcareI18n,
		weekendMedicalHelpI18n,
		articleUnavailableI18n,
		articleAllergyI18n,
		breadcrumbI18n,
	]),
});

// 1. Define data first
const homeLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));

const breadcrumbItems = computed(() => [
	{ label: t('BreadcrumbHome'), to: homeLink.value },
	{ label: t('BreadcrumbArticles') },
]);

// Реальные цифры для мета-строк карточек: те же выборки,
// что строят сами статьи.
//
// Из ответа нужны ровно два числа, а список врачей приходит полными строками.
// `transform` выполняется до сериализации ответа в payload, поэтому на клиент
// уезжают только числа, а не 70 карточек врачей с контактами и рейтингами.
// Пагинацией это не заменить: размер множества специальностей считается по
// всей выборке, а не по первой странице.
const clinicsStore = useClinicsStore();
const [{ data: doctorsStats }] = await Promise.all([
	useFetch('/api/doctors/list', {
		method: 'POST',
		body: computed(() => ({
			languageIds: [String(LanguageId.RU)],
			onlyDoctorLanguages: true,
			locale: locale.value,
		})),
		transform: (data) => {
			const specialtyIds = new Set<number>();
			data.doctors.forEach((doctor) => {
				doctor.specialtyIds
					?.split(',')
					.forEach((id: string) => specialtyIds.add(Number(id)));
			});
			return {
				doctorsCount: data.totalCount,
				specialtiesCount: specialtyIds.size,
			};
		},
	}),
	clinicsStore.fetchClinics(),
]);

const doctorsCount = computed(() => doctorsStats.value?.doctorsCount ?? 0);
const specialtiesCount = computed(
	() => doctorsStats.value?.specialtiesCount ?? 0,
);

const clinicLanguageStats = computed(() => {
	const clinicIds = new Set<number>();
	const languageIds = new Set<number>();
	clinicsStore.clinics.forEach((clinic) => {
		if (!clinic.languageIds) return;
		const langIds = clinic.languageIds.split(',').map(Number);
		CLINIC_SUPPORT_LANGUAGE_IDS.forEach((langId) => {
			if (langIds.includes(langId)) {
				clinicIds.add(clinic.id);
				languageIds.add(langId);
			}
		});
	});
	return { clinics: clinicIds.size, languages: languageIds.size };
});

// date — дата публикации статьи (совпадает с datePublished на самой странице).
// Список сортируется по ней от новых к старым; при равных датах сохраняется
// порядок объявления. Новую статью достаточно добавить с правильной датой.
const articles = computed(() =>
	[
		{
			title: t('HealthcareSystemTitle'),
			description: t('HealthcareSystemDescription'),
			image: '/img/articles/healthcare-system-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/healthcare-system-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('BirthInMontenegroTitle'),
			description: t('BirthInMontenegroDescription'),
			image: '/img/articles/birth-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/birth-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('ResidenceInsuranceTitle'),
			description: t('ResidenceInsuranceDescription'),
			image: '/img/articles/health-insurance-for-residence-permit.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/health-insurance-for-residence-permit',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('MentalHealthTitle'),
			description: t('MentalHealthDescription'),
			image: '/img/articles/mental-health-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/mental-health-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('TouristHealthcareTitle'),
			description: t('TouristHealthcareDescription'),
			image: '/img/articles/tourist-healthcare-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/tourist-healthcare-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('DentistryTitle'),
			description: t('DentistryDescription'),
			image: '/img/articles/dentistry-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/dentistry-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('PharmaciesTitle'),
			description: t('PharmaciesDescription'),
			image: '/img/articles/pharmacies-and-medications.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/pharmacies-and-medications',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('UnaTitle'),
			description: t('UnaDescription'),
			image: '/img/articles/medications-not-available-in-montenegro.webp',
			date: '2026-07-23',
			meta: '',
			link: {
				path: '/articles/medications-not-available-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('AlgTitle'),
			description: t('AlgDescription'),
			image: '/img/articles/allergy-medicines-in-montenegro.webp',
			date: '2026-08-31',
			meta: '',
			link: {
				path: '/articles/allergy-medicines-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('WeekendMedicalHelpTitle'),
			description: t('WeekendMedicalHelpDescription'),
			image: '/img/articles/weekend-medical-help-in-montenegro.webp',
			date: '2026-07-17',
			meta: '',
			link: {
				path: '/articles/weekend-medical-help-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('LabTestsArticleTitle'),
			description: t('LabTestsArticleDescription'),
			image: '/img/articles/lab-tests-and-checkups.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/lab-tests-and-checkups',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('ChildHealthcareTitle'),
			description: t('ChildHealthcareDescription'),
			image: '/img/articles/child-healthcare-in-montenegro.webp',
			date: '2026-07-16',
			meta: '',
			link: {
				path: '/articles/child-healthcare-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		{
			title: t('RussianSpeakingDoctorsTitle'),
			description: t('RussianSpeakingDoctorsDescription'),
			image: '/img/articles/russian-speaking-doctors.webp',
			date: '2025-12-31',
			meta: doctorsCount.value
				? t('ArticleMetaDoctors', {
						doctors: doctorsCount.value,
						specialties: specialtiesCount.value,
					})
				: '',
			link: {
				path: '/articles/russian-speaking-doctors-in-montenegro',
				query: getRegionalQuery(locale.value),
			},
		},
		...(['budva', 'podgorica', 'kotor', 'bar'] as const).map((city) => ({
			title: t(`CityHcTitle_${city}`),
			description: t(`CityHcDescription_${city}`),
			image: `/img/articles/healthcare-in-${city}.webp`,
			date: '2026-07-16',
			meta: '',
			link: {
				path: `/articles/healthcare-in-${city}`,
				query: getRegionalQuery(locale.value),
			},
		})),
		{
			title: t('ClinicsWithLanguageSupportTitle'),
			description: t('ClinicsWithLanguageSupportDescription'),
			image: '/img/articles/clinics-with-language-support.webp',
			date: '2026-07-16',
			meta: clinicLanguageStats.value.clinics
				? t('ArticleMetaClinics', {
						languages: clinicLanguageStats.value.languages,
						clinics: clinicLanguageStats.value.clinics,
					})
				: '',
			link: {
				path: '/articles/clinics-with-language-support',
				query: getRegionalQuery(locale.value),
			},
		},
	].sort((a, b) => b.date.localeCompare(a.date)),
);

const schemaOrgStore = useSchemaOrgStore();
const pageUrl = computed(() =>
	getRegionalUrl(`${SITE_URL}/articles`, {}, locale.value),
);

// 2. Then use it in effects/meta
const pageTitle = computed(() => t('Articles'));
const pageDescription = computed(() => t('ArticlesDescription'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

watchEffect(() => {
	schemaOrgStore.setSchemas([
		...buildCollectionPageSchemas({
			pageUrl: pageUrl.value,
			locale: locale.value,
			title: t('Articles'),
			description: t('Articles'),
			numberOfItems: articles.value.length,
			itemListElement: buildTopListItemElements(
				articles.value.map((a, i) => ({ id: i, name: a.title })),
				{
					baseUrl: SITE_URL,
					buildPath: (a) => articles.value[a.id].link.path,
				},
			),
		}),
		buildBreadcrumbsSchema(pageUrl.value, [
			{
				name: t('BreadcrumbHome'),
				url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
			},
			{ name: t('BreadcrumbArticles') },
		]),
	]);
});
</script>

<template>
	<div class="articles-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbItems" />

			<h1 class="page-title">{{ t('Articles') }}</h1>
			<p class="page-subtitle">{{ t('ArticlesDescription') }}</p>

			<div class="articles-list">
				<NuxtLink
					v-for="article in articles"
					:key="article.link.path"
					:to="article.link"
					class="article-card"
				>
					<div v-if="article.image" class="article-card__image">
						<!-- Слот карточки ~360 px (две колонки в контейнере 800 px),
						     оригиналы до 1536 px — отдаём деривативы через srcset.
						     Ленивую загрузку здесь оставляем: карточки ниже первого
						     экрана, LCP-обложка живёт в самой статье. -->
						<img
							:src="article.image"
							:srcset="buildArticleImageSrcSet(article.image)"
							sizes="(max-width: 700px) calc(100vw - 48px), 360px"
							:alt="article.title"
							loading="lazy"
						/>
					</div>
					<h2 class="article-card__title">{{ article.title }}</h2>
					<p class="article-card__description">{{ article.description }}</p>
					<div v-if="article.meta" class="article-card__meta">
						{{ article.meta }}
					</div>
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.articles-page {
	padding: var(--kit-spacing-xl) 0 var(--kit-spacing-3xl);
}

.page-title {
	margin: var(--kit-spacing-lg) 0 var(--kit-spacing-sm);
	font-size: var(--kit-font-size-4xl);
	font-weight: var(--kit-font-weight-bold);
	letter-spacing: -0.02em;
	line-height: 1.2;
	color: var(--kit-color-text-heading);
}

.page-subtitle {
	margin: 0 0 var(--kit-spacing-3xl);
	font-size: var(--kit-font-size-lg);
	line-height: 1.7;
	color: var(--kit-color-text-secondary);
}

.articles-list {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: var(--kit-spacing-3xl) var(--kit-spacing-2xl);
}

.article-card {
	display: block;
	text-decoration: none;
	color: inherit;

	&__image {
		aspect-ratio: 16 / 9;
		border-radius: var(--kit-border-radius-xl);
		overflow: hidden;
		margin-bottom: var(--kit-spacing-lg);

		img {
			width: 100%;
			height: 100%;
			object-fit: cover;
			transition: transform var(--kit-transition-base);
		}
	}

	&:hover &__image img {
		transform: scale(1.03);
	}

	&__title {
		margin: 0 0 var(--kit-spacing-sm);
		font-size: var(--kit-font-size-xl);
		font-weight: var(--kit-font-weight-semibold);
		letter-spacing: -0.01em;
		line-height: 1.35;
		color: var(--kit-color-text-heading);
		transition: color var(--kit-transition-base);
	}

	&:hover &__title {
		color: var(--kit-color-primary);
	}

	&__description {
		margin: 0;
		font-size: var(--kit-font-size-base);
		color: var(--kit-color-text-secondary);
		line-height: 1.6;
	}

	&__meta {
		margin-top: var(--kit-spacing-md);
		font-size: var(--kit-font-size-sm);
		color: var(--kit-color-text-muted);
	}
}

@media (max-width: 700px) {
	.articles-list {
		grid-template-columns: 1fr;
		gap: var(--kit-spacing-2xl);
	}
}

.container {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 var(--kit-spacing-lg);
}
</style>
