<script setup lang="ts">
import specialtyI18n from '~/i18n/specialty';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n, specialtyI18n]),
});

const route = useRoute();
const doctorSlug = computed(() => route.params.doctorSlug as string);
const currentPage = computed(() => parseInt(route.query.page as string) || 1);

const { data: reviewsData } = await useFetch('/api/doctors/reviews', {
	key: `doctor-reviews-${doctorSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: doctorSlug.value,
		locale: locale.value,
		page: currentPage.value,
		sort: route.query.sort || 'rank',
	})),
});

// Redirect if below threshold
if (import.meta.server && reviewsData.value?.shouldRedirect) {
	await navigateTo(`/doctors/${doctorSlug.value}#reviews`, {
		redirectCode: 301,
	});
}

watch(
	() => reviewsData.value?.shouldRedirect,
	(shouldRedirect) => {
		if (shouldRedirect) {
			navigateTo(`/doctors/${doctorSlug.value}#reviews`);
		}
	},
);

// 404
if (import.meta.server && !reviewsData.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const data = computed(() => {
	const v = reviewsData.value;
	if (!v || v.shouldRedirect) return null;
	return v;
});

const doctorName = computed(() => {
	const d = (data.value as any)?.doctor;
	if (!d) return '';
	const title = d.professionalTitle ? d.professionalTitle + ' ' : '';
	return title + (d.localName || d.name);
});

const specialtyNames = computed(() => {
	const ids = (data.value as any)?.doctor?.specialtyIds;
	if (!ids) return [];
	return ids.split(',').map((id: string) => t(`specialty_${id}`));
});

const clinicsStore = useClinicsStore();
await clinicsStore.fetchClinics();

const clinicInfoMap = computed(() => {
	const map: Record<number, { name: string; slug: string }> = {};
	const clinicIds = (data.value as any)?.doctor?.clinicIds;
	if (!clinicIds || !clinicsStore.clinics) return map;
	for (const id of clinicIds.split(',').map(Number)) {
		const clinic = clinicsStore.clinics.find((c) => c.id === id);
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
		schemaOrgType="Physician"
		schemaOrgFragment="physician"
		breadcrumbParentKey="BreadcrumbDoctors"
		parentListRouteName="doctors"
		entityRouteName="doctors-doctorSlug"
		entityRouteParam="doctorSlug"
		:clinicInfo="clinicInfoMap"
	>
		<template #badges>
			<el-tag
				v-for="name in specialtyNames"
				:key="name"
				type="info"
				effect="plain"
				round
			>{{ name }}</el-tag>
		</template>
	</ReviewsPage>
</template>
