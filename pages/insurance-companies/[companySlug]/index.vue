<script setup lang="ts">
import type { InsuranceCompanyBranchesMap } from '#components';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { buildInsuranceCompanySchema } from '~/common/schema-org-builders';
import { getCanonicalUrl } from '~/common/url-utils';
import { combineI18nMessages } from '~/i18n/utils';
import cityI18n from '~/i18n/city';
import insuranceCompanyI18n from '~/i18n/insurance-company';
import type { InsuranceCompanyData } from '~/interfaces/insurance-company';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, insuranceCompanyI18n]),
});

const route = useRoute();
const companySlug = computed(() => route.params.companySlug as string);

const { pending: isLoading, data: companyData } =
	await useFetch<InsuranceCompanyData | null>(
		'/api/insurance-companies/details',
		{
			key: 'insurance-company-details',
			method: 'POST',
			body: computed(() => ({
				slug: companySlug.value,
				locale: locale.value,
			})),
		},
	);

const isFound = computed(() => companyData.value?.id != null);

if (import.meta.server && !isFound.value) {
	setResponseStatus(useRequestEvent()!, 404);
}

const branches = computed(() => companyData.value?.branches || []);

const branchesLabel = computed(() =>
	t('OfficeCount', { count: branches.value.length }),
);

const tabs = computed(() => [
	{ id: 'offices', label: t('OfficesTitle') },
	{ id: 'map', label: t('TabMap') },
]);

// Аналог scrollToMap на странице клиники — открывает попап нужного филиала
// на карте офисов (см. components/insurance-company/branches-map.vue).
const mapRef = ref<InstanceType<typeof InsuranceCompanyBranchesMap> | null>(
	null,
);
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pendingMapAction = ref<(() => void) | null>(null);

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
};

const scrollToMap = (branch: (typeof branches.value)[number]) => {
	const el = document.getElementById('map');
	if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });

	const action = () => mapRef.value?.openBranchPopup(branch);
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

// У несуществующей компании заголовок и описание — про ошибку, а не пустая
// строка и описание листинга: пустой <title> нечего показать в выдаче, а
// описание листинга делало из 404 «валидную» страницу-дубль каталога.
const pageTitle = computed(() => {
	if (!isFound.value || !companyData.value) {
		return t('InsuranceCompanyNotFound');
	}
	return companyData.value.name;
});

const pageDescription = computed(() => {
	if (!isFound.value || !companyData.value) {
		return t('InsuranceCompanyNotFound');
	}
	return t('InsuranceCompanyPageDescription', { name: companyData.value.name });
});

// Единственная из шести детальных страниц, где noindex не стоял: страница
// несуществующей компании индексировалась как обычная
const robotsMeta = computed(() => (isFound.value ? undefined : 'noindex'));

const getCityName = (id: number): string | undefined => {
	const key = `city_${id}`;
	const value = t(key);
	return value && value !== key ? value : undefined;
};

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	// Дефолтная og:image теперь 1200×630 — формат большой карточки
	twitterCard: 'summary_large_image',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
	robots: robotsMeta,
});

const schemaOrgStore = useSchemaOrgStore();

watchEffect(() => {
	if (!companyData.value || !isFound.value) return;

	const pageUrl = getCanonicalUrl(
		route.path,
		route.query as Record<string, string | string[]>,
		locale.value,
	);

	// BreadcrumbList здесь больше не отдаётся: видимых крошек на странице нет
	// (EntityPage рисует только кнопку «к поиску»), а размечать структуру,
	// которой пользователь не видит, Google прямо запрещает. Вернуть разметку
	// можно вместе с AppBreadcrumbs — но добавлять их надо в EntityPage, то есть
	// сразу всем детальным страницам.
	schemaOrgStore.setSchemas(
		buildInsuranceCompanySchema({
			siteUrl: SITE_URL,
			company: companyData.value,
			locale: locale.value,
			pageTitle: pageTitle.value,
			pageDescription: pageDescription.value,
			pageUrl,
			getCityName,
		}),
	);
});
</script>

<template>
	<EntityPage
		:isLoading="isLoading || false"
		:isFound="isFound"
		backRouteName="insurance-companies"
		:loadingText="t('InsuranceCompanyLoading')"
		:notFoundText="t('InsuranceCompanyNotFound')"
		:tabs="tabs"
	>
		<template #hero>
			<InsuranceCompanyHero
				v-if="companyData"
				:company="companyData"
				:branchesLabel="branchesLabel"
			/>
		</template>

		<template #sections>
			<EntityPageSection sectionId="offices" :title="t('OfficesTitle')">
				<template #icon
					><IconMapPin :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<div class="insurance-branches-list">
					<InsuranceCompanyBranchItem
						v-for="branch in branches"
						:key="branch.id"
						:branch="branch"
						:companyPhone="companyData?.phone"
						:companyEmail="companyData?.email"
						@showOnMap="scrollToMap(branch)"
					/>
				</div>
			</EntityPageSection>

			<EntityPageSection
				v-if="
					companyData &&
					(companyData.website || companyData.phone || companyData.email)
				"
				sectionId="contacts"
				:title="t('ContactsTitle')"
			>
				<template #icon
					><IconPhone :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<ContactsList :list="companyData" />
			</EntityPageSection>

			<EntityPageSection sectionId="map" :title="t('TabMap')">
				<template #icon
					><IconMapPin :size="20" color="var(--kit-color-text-on-solid)"
				/></template>
				<div ref="mapSentinel" class="insurance-map">
					<InsuranceCompanyBranchesMap
						v-if="isMapVisible"
						ref="mapRef"
						:branches="branches"
						:companyPhone="companyData?.phone"
						@ready="onMapReady"
					/>
				</div>
			</EntityPageSection>
		</template>
	</EntityPage>
</template>

<style scoped lang="less">
.insurance-branches-list {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
	gap: var(--kit-spacing-md);
}

.insurance-map {
	width: 100%;
	height: 500px;
}
</style>
