<script setup lang="ts">
import { List, MapLocation } from '@element-plus/icons-vue';
import { OG_IMAGE, SITE_URL } from '~/common/constants';
import { getCanonicalUrl, getRegionalUrl } from '~/common/url-utils';
import {
	buildBreadcrumbsSchema,
	buildEntityListSchema,
} from '~/common/schema-org-builders';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

import breadcrumbI18n from '~/i18n/breadcrumb';
import cityI18n from '~/i18n/city';
import clinicI18n from '~/i18n/clinic';
import clinicTypeI18n from '~/i18n/clinic-type';
import languageI18n from '~/i18n/language';
import ratingI18n from '~/i18n/rating';
import specialtyI18n from '~/i18n/specialty';
import workingHoursI18n from '~/i18n/working-hours';

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		breadcrumbI18n,
		clinicI18n,
		clinicTypeI18n,
		cityI18n,
		languageI18n,
		ratingI18n,
		specialtyI18n,
		workingHoursI18n,
	]),
});

const { userLocation, initLocation } = useUserLocation();

onMounted(() => {
	initLocation();
});

const filtersStore = useFiltersStore();
const {
	cityIds,
	languageIds,
	clinicTypeIds,
	specialtyIds,
	name,
	openNow,
	minRating,
} = toRefs(filtersStore.namespaces.clinics);
const route = useRoute();
const pageNumber = ref(Number(route.query.page || 1));
// Переключатель список/карта — только мобильные; на десктопе карта всегда
// сбоку списка. Локальное состояние, НЕ в URL: карта — вспомогательный режим,
// перезагрузка/шеринг ссылки должны всегда открывать список.
const view = ref<'list' | 'map'>('list');

const MOBILE_BREAKPOINT = '(max-width: 950px)';
const isMobileViewport = ref(false);
let mediaQuery: MediaQueryList | null = null;
const onViewportChange = (e: MediaQueryListEvent | MediaQueryList) => {
	isMobileViewport.value = e.matches;
};
onMounted(() => {
	mediaQuery = window.matchMedia(MOBILE_BREAKPOINT);
	onViewportChange(mediaQuery);
	mediaQuery.addEventListener('change', onViewportChange);
});
onUnmounted(() => {
	mediaQuery?.removeEventListener('change', onViewportChange);
});

// Режим карты на десктопе (ресайз с открытой картой) рендерится списком
const effectiveView = computed(() =>
	isMobileViewport.value && view.value === 'map' ? 'map' : 'list',
);
const routeName = route.name;
watch(
	() => route.query,
	(query) => {
		if (route.name !== routeName) return;
		pageNumber.value = Number(query.page || 1);
		filtersStore.updateFromRoute('clinics', query);
	},
	{ immediate: true },
);
// строго после первичной синхронизации из URL — она не действие пользователя
useFilterTracking('clinics');

// Композитное ранжирование (rank_score + вклад близости, common/ranking.ts) —
// когда локация известна. На SSR её нет, поэтому SEO-выдача не меняется.
// Спецслучай «фильтр по городу отключает сортировку» (бывш. FR-2.6) не нужен:
// у клиник далёкого отфильтрованного города вклад близости ≈ 0 у всех,
// порядок сам вырождается в rank_score.
const sortByDistance = computed(() => !!userLocation.value);

const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	clinicTypeIds: clinicTypeIds.value,
	specialtyIds: specialtyIds.value,
	name: name.value,
	openNow: openNow.value,
	minRating: minRating.value || undefined,
	locale: locale.value,
	page: pageNumber.value,
	userLatitude: sortByDistance.value
		? userLocation.value?.latitude
		: undefined,
	userLongitude: sortByDistance.value
		? userLocation.value?.longitude
		: undefined,
	sortByDistance: sortByDistance.value || undefined,
}));

// Расстояние на карточке — общий механизм ранжирования
const { getDistanceKm } = useClinicRanking();

const filterQuery = computed(
	() => filtersStore.getRouteParams('clinics').query,
);

const { pending: isLoadingClinics, data: clinicsList } = await useFetch(
	'/api/clinics/list',
	{
		key: 'clinics-list',
		method: 'POST',
		body: filterList,
	},
);

// Для карты нужны ВСЕ клиники по текущим фильтрам (без пагинации).
// Грузится только на клиенте; в режиме списка тоже используется —
// боковая карта показывает отфильтрованные клиники, а не все подряд.
const mapFilterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	clinicTypeIds: clinicTypeIds.value,
	specialtyIds: specialtyIds.value,
	name: name.value,
	openNow: openNow.value,
	minRating: minRating.value || undefined,
	locale: locale.value,
}));

const { data: mapClinicsList } = await useFetch('/api/clinics/list', {
	key: 'clinics-map-list',
	method: 'POST',
	body: mapFilterList,
	server: false,
	lazy: true,
});

const clinicTypeName = computed(() => {
	if (clinicTypeIds.value.length === 1) {
		return t(`clinic_type_${clinicTypeIds.value[0]}_plural`);
	}
	return '';
});

const pageTitle = computed(() => {
	const hasType = clinicTypeIds.value.length === 1;
	const hasLang = languageIds.value.length === 1;
	const hasCity = cityIds.value.length === 1;

	const type = clinicTypeName.value;
	const language = hasLang
		? t(`language_${languageIds.value[0]}_genitive`)
		: '';
	const city = hasCity ? t(`city_${cityIds.value[0]}_genitive`) : '';

	if (hasType) {
		if (hasLang) {
			if (hasCity) {
				return t('ClinicsTypeLanguageCity', { type, language, city });
			}
			return t('ClinicsTypeLanguage', { type, language });
		}
		if (hasCity) {
			return t('ClinicsTypeCity', { type, city });
		}
		return t('ClinicsType', { type });
	}

	if (hasLang) {
		if (hasCity) {
			return t('ClinicsLanguageCity', { language, city });
		}
		return t('ClinicsLanguage', { language });
	}

	if (hasCity) {
		return t('ClinicsCity', { city });
	}

	return t('Clinics');
});

// Специальность и рейтинг не входят в комбинаторику базовых заголовков —
// добавляются суффиксами через разделитель
const pageTitleSuffixes = computed(() => {
	const parts: string[] = [];
	if (specialtyIds.value.length === 1) {
		parts.push(t(`specialty_${specialtyIds.value[0]}`));
	}
	if (minRating.value) {
		parts.push(t('RatingFrom', { rating: n(minRating.value) }));
	}
	return parts;
});

const pageTitleFull = computed(() => {
	if (pageTitleSuffixes.value.length === 0) {
		return pageTitle.value;
	}
	return `${pageTitle.value} · ${pageTitleSuffixes.value.join(' · ')}`;
});

const pageTitleWithCount = computed(() => {
	return `${pageTitleFull.value} (${clinicsList.value?.totalCount || 0})`;
});

const pageDescription = computed(() => {
	if (cityIds.value.length === 1) {
		return t('ClinicsListDescriptionCity', {
			city: t(`city_${cityIds.value[0]}_genitive`),
		});
	}
	return t('ClinicsListDescription');
});

// Schema.org for clinics list
const schemaOrgStore = useSchemaOrgStore();

useSeoMeta({
	title: pageTitleWithCount,
	description: pageDescription,
	ogTitle: pageTitleWithCount,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	twitterCard: 'summary',
	twitterTitle: pageTitleWithCount,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

const isFiltered = computed(() => {
	return (
		cityIds.value.length > 0 ||
		languageIds.value.length > 0 ||
		clinicTypeIds.value.length > 0 ||
		specialtyIds.value.length > 0 ||
		!!name.value ||
		openNow.value ||
		minRating.value > 0
	);
});

watchEffect(() => {
	if (clinicsList.value) {
		const pageUrl = getCanonicalUrl(
			route.path,
			route.query as Record<string, string | string[]>,
			locale.value,
		);
		schemaOrgStore.setSchemas([
			...buildEntityListSchema({
				siteUrl: SITE_URL,
				pageUrl,
				locale: locale.value,
				title: pageTitleFull.value,
				description: pageDescription.value,
				totalCount: clinicsList.value.totalCount,
				items: clinicsList.value.clinics,
				buildPath: (clinic) => `/clinics/${clinic.slug}`,
				isFiltered: isFiltered.value,
			}),
			buildBreadcrumbsSchema(pageUrl, [
				{
					name: t('BreadcrumbHome'),
					url: getRegionalUrl(`${SITE_URL}/`, {}, locale.value),
				},
				{ name: t('BreadcrumbClinics') },
			]),
		]);
	}
});
</script>

<template>
	<ListPage
		:pageTitle="pageTitleWithCount"
		:pageDescription="pageDescription"
		:list="clinicsList?.clinics || []"
		:totalCount="clinicsList?.totalCount || 0"
		:isLoading="isLoadingClinics"
		:filterQuery="filterQuery"
		:cityIds="cityIds"
		:clinicMode="true"
		:mapClinics="mapClinicsList?.clinics"
		:view="effectiveView"
	>
		<template #header-actions>
			<el-radio-group v-model="view" class="view-toggle">
				<el-radio-button value="list">
					<el-icon><List /></el-icon>
					{{ t('ViewList') }}
				</el-radio-button>
				<el-radio-button value="map">
					<el-icon><MapLocation /></el-icon>
					{{ t('ViewMap') }}
				</el-radio-button>
			</el-radio-group>
		</template>

		<template #map-view>
			<div class="map-view-wrapper">
				<ClinicsMapView :clinics="mapClinicsList?.clinics || []" />
				<el-button
					class="map-view-exit"
					type="primary"
					round
					@click="view = 'list'"
				>
					<el-icon><List /></el-icon>
					{{ t('BackToList') }}
				</el-button>
			</div>
		</template>

		<template #filters>
			<FilterName
				v-model:value="name"
				:label="t('ClinicName')"
				:placeholder="t('InsertClinicName')"
			/>
			<FilterClinicTypeSelect v-model:value="clinicTypeIds" />
			<FilterSpecialtySelect v-model:value="specialtyIds" />
			<FilterCitySelect v-model:value="cityIds" />
			<FilterLanguageSelect v-model:value="languageIds" />
			<FilterRatingSelect v-model:value="minRating" />
			<FilterOpenNow v-model:value="openNow" :label="t('OpenNow')" />
		</template>

		<template #card="{ item, showClinicOnMap }">
			<ClinicSummary
				:clinic="item as ClinicData"
				:showPrice="false"
				:distance="getDistanceKm(item as ClinicData)"
				@show-on-map="showClinicOnMap(item)"
			/>
		</template>

		<template #tips>
			<TipsList v-if="clinicTypeIds.length === 1">
				<TipsClinics
					:clinicTypeIds="clinicTypeIds"
					:languageIds="languageIds"
					:cityIds="cityIds"
				/>
			</TipsList>
			<ClinicRelatedFilters :clinicTypeIds="clinicTypeIds" :cityIds="cityIds" />
		</template>
	</ListPage>
</template>

<style scoped lang="less">
// Переключатель список/карта — только мобильные; на десктопе
// карта всегда отображается сбоку от списка
.view-toggle {
	display: none;
	flex-shrink: 0;

	:deep(.el-radio-button__inner) {
		display: inline-flex;
		align-items: center;
		gap: var(--spacing-xs);
	}
}

.map-view-wrapper {
	position: relative;
	width: 100%;
	height: 100%;
	min-height: inherit;
}

// Плавающая кнопка выхода из мобильного фулскрина карты
.map-view-exit {
	display: none;
	position: absolute;
	bottom: var(--spacing-2xl);
	left: 50%;
	transform: translateX(-50%);
	z-index: var(--z-dropdown);
	box-shadow: var(--shadow-lg);

	.el-icon {
		margin-right: var(--spacing-xs);
	}
}

@media (max-width: 950px) {
	.view-toggle {
		display: inline-flex;
	}

	.map-view-exit {
		display: inline-flex;
	}
}
</style>
