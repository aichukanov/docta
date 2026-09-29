<script setup lang="ts">
import { getRegionalUrl } from '~/common/url-utils';
import insuranceCompanyI18n from '~/i18n/insurance-company';
import { combineI18nMessages } from '~/i18n/utils';

const route = useRoute();
const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([insuranceCompanyI18n]),
});
const companySlug = computed(() => route.params.companySlug as string);
const currentPage = computed(() => parseInt(route.query.page as string) || 1);

const { data: reviewsData } = await useFetch(
	'/api/insurance-companies/reviews',
	{
		key: `insurance-company-reviews-${companySlug.value}`,
		method: 'POST',
		body: computed(() => ({
			slug: companySlug.value,
			locale: locale.value,
			page: currentPage.value,
			sort: route.query.sort || 'rank',
		})),
	},
);

// Цель редиректа собирается через getRegionalUrl, а не конкатенацией —
// см. комментарий в pages/clinics/[clinicSlug]/reviews/index.vue.
const parentAnchorUrl = computed(
	() =>
		`${getRegionalUrl(`/insurance-companies/${companySlug.value}`, {}, locale.value)}#reviews`,
);

// Redirect if below threshold
if (import.meta.server && reviewsData.value?.shouldRedirect) {
	await navigateTo(parentAnchorUrl.value, {
		redirectCode: 301,
	});
}

watch(
	() => reviewsData.value?.shouldRedirect,
	(shouldRedirect) => {
		if (shouldRedirect) {
			navigateTo(parentAnchorUrl.value);
		}
	},
);

// Компании нет — 404 (у страховых нет черновиков и админского скрытия)
if (!reviewsData.value) {
	setMissingEntityStatus(reviewsData.value);
}

const isMissing = computed(() => !reviewsData.value);

// Мета для отсутствующей компании — иначе «тихий 200» без title/robots,
// см. комментарий в pages/clinics/[clinicSlug]/reviews/index.vue.
if (isMissing.value) {
	useSeoMeta({
		title: () => t('InsuranceCompanyNotFound'),
		description: () => t('ReviewsNotFoundDescription'),
		robots: 'noindex, follow',
	});
}

const data = computed(() => {
	const v = reviewsData.value;
	if (!v || v.shouldRedirect) return null;
	return v;
});

const company = computed(() => data.value?.company ?? null);

const companyName = computed(() => {
	const c = company.value;
	if (!c) return '';
	return c.name || c.localName;
});
</script>

<template>
	<ReviewsPage
		v-if="data && !data.shouldRedirect"
		entityType="insurance_company"
		entityBasePath="insurance-companies"
		:entitySlug="companySlug"
		:entityName="companyName"
		:rating="data.rating"
		:reviews="data.reviews"
		:pagination="data.pagination"
		schemaOrgType="InsuranceAgency"
		schemaOrgFragment="insuranceagency"
		breadcrumbParentKey="BreadcrumbInsuranceCompanies"
		parentListRouteName="insurance-companies"
		entityRouteName="insurance-companies-companySlug"
		entityRouteParam="companySlug"
		:entityId="company?.id"
		:ownReview="data.ownReview"
	/>
	<!-- Без ClientOnly: текст ошибки обязан быть в серверной разметке, иначе
	краулер видит страницу, в которой об ошибке нет ни слова -->
	<main v-else-if="isMissing" class="reviews-missing" role="main">
		<ErrorBlock :code="404" :title="t('InsuranceCompanyNotFound')" />
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"ReviewsNotFoundDescription": "This insurance company page does not exist, so there are no reviews for it."
	},
	"ru": {
		"ReviewsNotFoundDescription": "Такой страницы страховой компании нет, отзывов по ней тоже нет."
	},
	"sr": {
		"ReviewsNotFoundDescription": "Ova stranica osiguravajućeg društva ne postoji, pa nema ni recenzija."
	},
	"sr-cyrl": {
		"ReviewsNotFoundDescription": "Ова страница осигуравајућег друштва не постоји, па нема ни рецензија."
	},
	"de": {
		"ReviewsNotFoundDescription": "Diese Seite der Versicherungsgesellschaft existiert nicht, daher gibt es auch keine Bewertungen."
	},
	"tr": {
		"ReviewsNotFoundDescription": "Bu sigorta şirketi sayfası mevcut değil, bu nedenle yorum da yok."
	}
}
</i18n>

<style scoped>
/* Та же коробка, что у ReviewsPage — заглушка встаёт на её место */
.reviews-missing {
	max-width: 1100px;
	width: 100%;
	margin: 0 auto;
	padding: var(--kit-spacing-xl);
	box-sizing: border-box;
}
</style>
