<script setup lang="ts">
import { isGonePayload } from '~/common/gone';
import { getSchemaType } from '~/common/schema-org-builders';
import { getRegionalUrl } from '~/common/url-utils';
import doctorI18n from '~/i18n/doctor';
import specialtyI18n from '~/i18n/specialty';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n, doctorI18n, specialtyI18n]),
});

const route = useRoute();
const doctorSlug = computed(() => route.params.doctorSlug as string);
const currentPage = computed(() => parseInt(route.query.page as string) || 1);

const { data: reviewsPayload } = await useFetch('/api/doctors/reviews', {
	key: `doctor-reviews-${doctorSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: doctorSlug.value,
		locale: locale.value,
		page: currentPage.value,
		sort: route.query.sort || 'rank',
	})),
});

// Скрытого админом врача эндпоинт отдаёт маркером `{ gone: true }` вместо
// данных — страница отвечает 410 (см. common/gone.ts).
const reviewsData = computed(() =>
	isGonePayload(reviewsPayload.value) ? null : reviewsPayload.value,
);

// Цель редиректа собирается через getRegionalUrl, а не конкатенацией: без
// параметра языка русская версия подстраницы 301-редиректилась на сербскую
// версию родителя (проверено на проде), а редирект на другую локаль Google
// считает дефектом hreflang-кластера.
const parentAnchorUrl = computed(
	() =>
		`${getRegionalUrl(`/doctors/${doctorSlug.value}`, {}, locale.value)}#reviews`,
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

// 404, либо 410 если врача скрыл администратор
if (!reviewsData.value) {
	setMissingEntityStatus(reviewsPayload.value);
}

// Врача нет вовсе — в отличие от shouldRedirect, где данные есть и страница
// просто уезжает на родителя
const isMissing = computed(() => !reviewsData.value);
const isGone = computed(() => isGonePayload(reviewsPayload.value));

// Заголовок, описание и noindex живут в ReviewsPage, а он при отсутствии врача
// не монтируется: код ответа был честным, но в <head> не было ни title, ни
// description, ни robots (тот же «тихий 200», см.
// prd/silent-200-index-hygiene). Мета ставим только для этого случая, иначе
// перебили бы мету смонтированного ReviewsPage.
if (isMissing.value) {
	useSeoMeta({
		title: () => t('DoctorNotFound'),
		description: () => t('ReviewsNotFoundDescription'),
		robots: 'noindex, follow',
	});
}

const data = computed(() => {
	const v = reviewsData.value;
	if (!v || v.shouldRedirect) return null;
	return v;
});

const doctor = computed(() => data.value?.doctor ?? null);

const doctorName = computed(() => {
	const d = doctor.value;
	if (!d) return '';
	const title = d.professionalTitle ? d.professionalTitle + ' ' : '';
	return title + d.name;
});

const doctorSchema = computed(() => {
	const title = doctor.value?.professionalTitle?.trim() || '';
	return getSchemaType(title);
});

const specialtyNames = computed(() => {
	const ids = doctor.value?.specialtyIds;
	if (!ids) return [];
	return ids.split(',').map((id: string) => t(`specialty_${id}`));
});

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const doctorClinics = computed(() => {
	const clinicIds = doctor.value?.clinicIds;
	const allClinics = clinicsStore.clinics;
	if (!clinicIds || !allClinics) return [];
	return clinicIds
		.split(',')
		.map(Number)
		.map((id) => allClinics.find((c) => c.id === id))
		.filter((c) => !!c);
});

const clinicInfoMap = computed(() => {
	const map: Record<number, { name: string; slug: string }> = {};
	for (const clinic of doctorClinics.value) {
		if (clinic) {
			map[clinic.id] = {
				name: clinic.localName || clinic.name,
				slug: clinic.slug,
			};
		}
	}
	return map;
});
</script>

<template>
	<ReviewsPage
		v-if="data && !data.shouldRedirect"
		entityType="doctor"
		:entitySlug="doctorSlug"
		:entityName="doctorName"
		:rating="data.rating"
		:reviews="data.reviews"
		:pagination="data.pagination"
		:schemaOrgType="doctorSchema.schemaType"
		:schemaOrgFragment="doctorSchema.fragment"
		breadcrumbParentKey="BreadcrumbDoctors"
		parentListRouteName="doctors"
		entityRouteName="doctors-doctorSlug"
		entityRouteParam="doctorSlug"
		:clinicInfo="clinicInfoMap"
		:entityId="doctor?.id"
		:ownReview="data.ownReview"
		:relatedEntities="doctorClinics.map((c) => ({ id: c.id, name: c.name }))"
	>
		<template #badges>
			<CategoryTag v-for="name in specialtyNames" :key="name">{{
				name
			}}</CategoryTag>
		</template>
	</ReviewsPage>
	<!-- Без ClientOnly: текст ошибки обязан быть в серверной разметке, иначе
	краулер видит страницу, в которой об ошибке нет ни слова -->
	<main v-else-if="isMissing" class="reviews-missing" role="main">
		<ErrorBlock :code="isGone ? 410 : 404" :title="t('DoctorNotFound')" />
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"ReviewsNotFoundDescription": "This doctor page does not exist, so there are no reviews for it."
	},
	"ru": {
		"ReviewsNotFoundDescription": "Такой страницы врача нет, отзывов по ней тоже нет."
	},
	"sr": {
		"ReviewsNotFoundDescription": "Ova stranica ljekara ne postoji, pa nema ni recenzija."
	},
	"sr-cyrl": {
		"ReviewsNotFoundDescription": "Ова страница љекара не постоји, па нема ни рецензија."
	},
	"de": {
		"ReviewsNotFoundDescription": "Diese Arztseite existiert nicht, daher gibt es auch keine Bewertungen."
	},
	"tr": {
		"ReviewsNotFoundDescription": "Bu doktor sayfası mevcut değil, bu nedenle yorum da yok."
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
