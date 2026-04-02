<script setup lang="ts">
import clinicTypeI18n from '~/i18n/clinic-type';
import { combineI18nMessages } from '~/i18n/utils';

const route = useRoute();
const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([clinicTypeI18n]),
});
const clinicSlug = computed(() => route.params.clinicSlug as string);
const currentPage = computed(() => parseInt(route.query.page as string) || 1);

const { data: reviewsData } = await useFetch('/api/clinics/reviews', {
	key: `clinic-reviews-${clinicSlug.value}`,
	method: 'POST',
	body: computed(() => ({
		slug: clinicSlug.value,
		locale: locale.value,
		page: currentPage.value,
		sort: route.query.sort || 'rank',
	})),
});

// Redirect if below threshold
if (import.meta.server && reviewsData.value?.shouldRedirect) {
	await navigateTo(`/clinics/${clinicSlug.value}#reviews`, {
		redirectCode: 301,
	});
}

watch(
	() => reviewsData.value?.shouldRedirect,
	(shouldRedirect) => {
		if (shouldRedirect) {
			navigateTo(`/clinics/${clinicSlug.value}#reviews`);
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

const clinicName = computed(() => {
	const c = (data.value as any)?.clinic;
	if (!c) return '';
	return c.localName || c.name;
});

const clinicTypeNames = computed(() => {
	const ids = (data.value as any)?.clinic?.clinicTypeIds;
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
		schemaOrgType="MedicalOrganization"
		schemaOrgFragment="medicalorganization"
		breadcrumbParentKey="BreadcrumbClinics"
		parentListRouteName="clinics"
		entityRouteName="clinics-clinicSlug"
		entityRouteParam="clinicSlug"
	>
		<template #badges>
			<el-tag
				v-for="name in clinicTypeNames"
				:key="name"
				type="info"
				effect="plain"
				round
			>{{ name }}</el-tag>
		</template>
	</ReviewsPage>
</template>
