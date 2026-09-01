<script setup lang="ts">
import { isGonePayload } from '~/common/gone';
import { getClinicSchemaOrgType } from '~/common/schema-org-builders';
import { getRegionalUrl } from '~/common/url-utils';
import clinicI18n from '~/i18n/clinic';
import clinicTypeI18n from '~/i18n/clinic-type';
import { combineI18nMessages } from '~/i18n/utils';

const route = useRoute();
const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicI18n, clinicTypeI18n]),
});
const clinicSlug = computed(() => route.params.clinicSlug as string);
const currentPage = computed(() => parseInt(route.query.page as string) || 1);

const { data: reviewsPayload } = await useFetch('/api/clinics/reviews', {
	key: `clinic-reviews-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
		page: currentPage.value,
		sort: route.query.sort || 'rank',
	})),
});

// Скрытую админом клинику эндпоинт отдаёт маркером `{ gone: true }` вместо
// данных — страница отвечает 410 (см. common/gone.ts).
const reviewsData = computed(() =>
	isGonePayload(reviewsPayload.value) ? null : reviewsPayload.value,
);

// Цель редиректа собирается через getRegionalUrl, а не конкатенацией: без
// параметра языка русская версия подстраницы 301-редиректилась на сербскую
// версию родителя, а редирект на другую локаль Google считает дефектом
// hreflang-кластера.
const parentAnchorUrl = computed(
	() =>
		`${getRegionalUrl(`/clinics/${clinicSlug.value}`, {}, locale.value)}#reviews`,
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

// 404, либо 410 если клинику скрыл администратор
if (!reviewsData.value) {
	setMissingEntityStatus(reviewsPayload.value);
}

// Клиники нет вовсе — в отличие от shouldRedirect, где данные есть и страница
// просто уезжает на родителя
const isMissing = computed(() => !reviewsData.value);
const isGone = computed(() => isGonePayload(reviewsPayload.value));

// Заголовок, описание и noindex живут в ReviewsPage, а он при отсутствии
// клиники не монтируется: код ответа был честным, но в <head> не было ни
// title, ни description, ни robots (тот же «тихий 200», см.
// prd/silent-200-index-hygiene). Мета ставим только для этого случая, иначе
// перебили бы мету смонтированного ReviewsPage.
if (isMissing.value) {
	useSeoMeta({
		title: () => t('ClinicNotFound'),
		description: () => t('ReviewsNotFoundDescription'),
		robots: 'noindex, follow',
	});
}

const data = computed(() => {
	const v = reviewsData.value;
	if (!v || v.shouldRedirect) return null;
	return v;
});

const clinic = computed(() => data.value?.clinic ?? null);

const clinicName = computed(() => {
	const c = clinic.value;
	if (!c) return '';
	return c.name || c.localName;
});

const { data: doctorsList } = await useFetch('/api/doctors/list', {
	key: `doctors-list-clinic-reviews-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		clinicIds: clinic.value?.id ? [clinic.value.id] : [],
		locale: locale.value,
	})),
});

const clinicDoctors = computed(() => doctorsList.value?.doctors || []);

const clinicSchemaOrgType = computed(() => {
	const ids = clinic.value?.clinicTypeIds;
	return getClinicSchemaOrgType(ids);
});

const clinicTypeNames = computed(() => {
	const ids = clinic.value?.clinicTypeIds;
	if (!ids) return [];
	return ids
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id: number) => t(`clinic_type_${id}`));
});
</script>

<template>
	<ReviewsPage
		v-if="data && !data.shouldRedirect"
		entityType="clinic"
		:entitySlug="clinicSlug"
		:entityName="clinicName"
		:rating="data.rating"
		:reviews="data.reviews"
		:pagination="data.pagination"
		:schemaOrgType="clinicSchemaOrgType"
		:schemaOrgFragment="clinicSchemaOrgType.toLowerCase()"
		breadcrumbParentKey="BreadcrumbClinics"
		parentListRouteName="clinics"
		entityRouteName="clinics-clinicSlug"
		entityRouteParam="clinicSlug"
		:entityId="clinic?.id"
		:ownReview="data.ownReview"
		:relatedEntities="clinicDoctors.map((d) => ({ id: d.id, name: d.name }))"
	>
		<template #badges>
			<CategoryTag v-for="name in clinicTypeNames" :key="name">{{
				name
			}}</CategoryTag>
		</template>
	</ReviewsPage>
	<!-- Без ClientOnly: текст ошибки обязан быть в серверной разметке, иначе
	краулер видит страницу, в которой об ошибке нет ни слова -->
	<main v-else-if="isMissing" class="reviews-missing" role="main">
		<ErrorBlock :code="isGone ? 410 : 404" :title="t('ClinicNotFound')" />
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"ReviewsNotFoundDescription": "This clinic page does not exist, so there are no reviews for it."
	},
	"ru": {
		"ReviewsNotFoundDescription": "Такой страницы клиники нет, отзывов по ней тоже нет."
	},
	"sr": {
		"ReviewsNotFoundDescription": "Ova stranica klinike ne postoji, pa nema ni recenzija."
	},
	"sr-cyrl": {
		"ReviewsNotFoundDescription": "Ова страница клинике не постоји, па нема ни рецензија."
	},
	"de": {
		"ReviewsNotFoundDescription": "Diese Klinikseite existiert nicht, daher gibt es auch keine Bewertungen."
	},
	"tr": {
		"ReviewsNotFoundDescription": "Bu klinik sayfası mevcut değil, bu nedenle yorum da yok."
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
