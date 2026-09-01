<script setup lang="ts" generic="T extends ListPageItem">
import IconFilter from '~/components/icon/filter.vue';
import IconArrowDown from '~/components/icon/arrow-down.vue';
import { getCanonicalUrl, getRegionalQuery } from '~/common/url-utils';
import { fitSeoTitle } from '~/common/seo-meta';
import type { FilterNamespace } from '~/stores/filters';
import { CITY_COORDINATES, type CityId } from '~/enums/cities';
import { LIST_PAGE_SIZE } from '~/common/constants';
import type { ClinicData } from '~/interfaces/clinic';
import type { ListPageItem } from '~/interfaces/list-page';
import type { ClinicServicesMap } from '#components';

const props = withDefaults(
	defineProps<{
		list: T[];
		totalCount: number;
		isLoading: boolean;
		pageTitle: string;
		// Тот же заголовок без хвоста «(N)». Нужен только для <title>: когда
		// полный вариант не влезает в лимит Bing (70), счётчик — первое, чем
		// можно пожертвовать. В h1 остаётся pageTitle.
		pageTitleBase?: string;
		pageDescription?: string;
		filterQuery: Record<string, any>;
		// Нужен, чтобы узнать у стора, не было ли в URL невалидных значений
		// фильтров (пункт 7d аудита). Проп обязательный намеренно: с
		// необязательным страницу легко завести без защиты и не заметить.
		filterNamespace: FilterNamespace;
		cityIds: number[];
		mapClinics?: ClinicData[];
		clinicMode?: boolean;
		detailsRouteName?: string;
		detailsParamName?: string;
		showPrice?: boolean;
		// 'map' — список скрыт, карту рендерит слот #map-view на всю ширину
		// (на мобильном — фулскрин). По умолчанию обычный список.
		view?: 'list' | 'map';
		// Тот же состав страницы в другом порядке (сортировка в #header-actions)
		// — контент дублирующий, индексировать его незачем.
		noindex?: boolean;
	}>(),
	{
		showPrice: true,
		view: 'list',
	},
);

const { t, locale } = useI18n({ useScope: 'local' });

const router = useRouter();
const route = useRoute();
// Стор клиник питает только фолбэк-карту ниже — если страница подменяет
// #side-map своей картой, он не нужен и грузить его незачем
const hasSideMapSlot = !!useSlots()['side-map'];

const mapRef = ref<InstanceType<typeof ClinicServicesMap> | null>(null);
const { target: mapSentinel, hasBeenVisible: isMapVisible } = useInViewport();
const pageNumber = ref(Number(route.query.page) || 1);
const isSyncingFromRoute = ref(false);

const clinicsStore = useClinicsStore();
const filtersStore = useFiltersStore();

const routeWithParams = computed(() => {
	return {
		query: {
			page: pageNumber.value > 1 ? pageNumber.value : undefined,
			...props.filterQuery,
			...getRegionalQuery(locale.value),
		},
	};
});

const normalizeQuery = (query: Record<string, any>) => {
	const normalized: Record<string, string | string[]> = {};
	Object.keys(query)
		.sort()
		.forEach((key) => {
			const value = query[key];
			if (value == null || value === '') {
				return;
			}
			if (Array.isArray(value)) {
				normalized[key] = value.map(String);
			} else {
				normalized[key] = String(value);
			}
		});
	return JSON.stringify(normalized);
};

const syncRoute = async (replace = false) => {
	const target = routeWithParams.value;
	if (normalizeQuery(route.query) === normalizeQuery(target.query)) {
		return;
	}
	if (replace) {
		await router.replace(target);
		return;
	}
	await router.push(target);
};

const pendingMapAction = ref<(() => void) | null>(null);

const showClinicOnMap = (clinic: ClinicData) => {
	const action = () => mapRef.value?.openClinicPopup(clinic);
	if (mapRef.value) {
		action();
	} else {
		pendingMapAction.value = action;
		isMapVisible.value = true;
	}
};

// Watcher живёт в setup-скоупе (и уничтожается вместе с компонентом):
// регистрация внутри onMapReady создавала бы новый вечный watcher при каждом
// ремаунте карты — мобильный переключатель список/карта эмитит 'ready' заново
const centerMapOnCities = () => {
	mapRef.value?.centerOnLocations(
		props.cityIds.map((cityId) => CITY_COORDINATES[cityId as CityId]),
	);
};
watch(() => props.cityIds, centerMapOnCities);

const onMapReady = () => {
	if (pendingMapAction.value) {
		pendingMapAction.value();
		pendingMapAction.value = null;
	}
	centerMapOnCities();
};

// На узких экранах фильтры свёрнуты по умолчанию — развёрнутые они
// занимают весь первый экран
const areFiltersOpen = ref(false);

const activeFiltersCount = computed(
	() =>
		Object.entries(props.filterQuery).filter(([key, value]) => {
			// Порядок выдачи — не фильтр: в счётчике на кнопке «Фильтры» он читался
			// бы как ещё одно ограничение выборки
			if (key === 'sort') return false;
			if (Array.isArray(value)) return value.length > 0;
			return value != null && value !== '' && value !== false;
		}).length,
);

const totalPages = computed(() => Math.ceil(props.totalCount / LIST_PAGE_SIZE));

/**
 * Присутствие ключа, а не его значение: пустое (`?name=`) и вовсе безвоздушное
 * (`?name`) значение тоже отдают базовый листинг, то есть дубль. Свои ссылки
 * такого не порождают — параметр без значения всегда приходит снаружи.
 */
const hasQueryKey = (key: string) => key in route.query;

/**
 * Есть ли в URL параметры, из-за которых страница — дубль базового листинга.
 *
 * Только для `robots`: выборку это не меняет, фильтрация как была, так и есть.
 * По смыслу — тот же `hasRedundantQuery`, что у подстраниц клиник
 * (`composables/use-clinic-items-route.ts`), но у листингов свой набор ключей.
 */
const hasRedundantQuery = computed(() => {
	// Внутренний поиск по сайту: Google прямо просит его не индексировать, а
	// значение здесь любое — поверхность неограниченная. Ссылки на такие URL
	// сайт генерирует сам (кнопка «ещё» в global-search), поэтому follow
	// остаётся: по ним надо ходить, но не индексировать.
	// На подстраницах клиник тот же поиск (`?search=`) закрыт давно.
	if (hasQueryKey('name')) {
		return true;
	}

	// Сортировка меняет порядок, а не состав; на шести листингах из семи её
	// вообще никто не читает, там `?sort=` — чистый дубль базового URL.
	if (hasQueryKey('sort')) {
		return true;
	}

	// openNow/minRating читает только листинг клиник — на остальных они молча
	// игнорируются и отдают полный каталог. Но и на клиниках индексировать
	// нечего: выборка нестабильна (часы работы, средний рейтинг), в sitemap её
	// нет, а `minRating=0`/`openNow=false` — просто состояние по умолчанию.
	if (hasQueryKey('openNow') || hasQueryKey('minRating')) {
		return true;
	}

	const page = route.query.page;
	if (hasQueryKey('page')) {
		// Дубль ключа (`?page=1&page=2`) — мусор сам по себе, как и `?page` без
		// значения (в route.query это null).
		if (Array.isArray(page) || page == null) {
			return true;
		}
		// Натуральное число без ведущих нулей. `0`, `abc`, `-1`, `2.5`, `01`
		// сводятся к первой странице, то есть к базовому URL.
		if (!/^[1-9]\d*$/.test(String(page))) {
			return true;
		}
		const pageNum = Number(page);
		// `?page=1` — избыточный: ровно тот же контент, что и без параметра.
		if (pageNum === 1) {
			return true;
		}
		// Страница за пределами пагинации заведомо пуста.
		if (totalPages.value > 0 && pageNum > totalPages.value) {
			return true;
		}
	}

	return false;
});

const robotsMeta = computed(() => {
	if (props.list?.length === 0) {
		return 'noindex, follow';
	}

	if (props.noindex) {
		return 'noindex, follow';
	}

	if (hasRedundantQuery.value) {
		return 'noindex, follow';
	}

	// Невалидное значение фильтра store молча заменяет на «фильтра нет», и
	// страница отдаёт ПОЛНЫЙ каталог: `?specialtyIds=99999` показывал всех 1316
	// врачей с self-canonical на этот URL. Значение может быть любым, то есть
	// это неограниченная поверхность дублей базового листинга.
	// См. пункт 7d в docs/audit/seo-2026-07.md.
	if (filtersStore.hasInvalidFilters(props.filterNamespace)) {
		return 'noindex, follow';
	}

	return undefined;
});

if (!hasSideMapSlot) {
	await clinicsStore.fetchClinics();
}

/**
 * Хвост «— Страница N из M» для страниц пагинации.
 *
 * У них canonical self (и это правильно: контент разный), но title и
 * description совпадали с первой страницей — для поисковика это дубли, у
 * которых нет ни одного отличающего признака. Формулировка и знак тире те же,
 * что на страницах отзывов (`components/reviews-page.vue`), чтобы вид у
 * пагинации был один на весь сайт.
 */
const pageSuffix = computed(() =>
	totalPages.value > 1 && pageNumber.value > 1
		? ` — ${t('PageOf', { page: pageNumber.value, total: totalPages.value })}`
		: '',
);

// Лимит Bing — 70 символов, а шаблон листинга склеивает фасеты без оглядки на
// длину: «специальность × язык» в ru доходит до сотни. Первым отбрасываем
// счётчик `(N)` — из всех частей заголовка он наименее полезен в выдаче.
const seoTitle = computed(() =>
	fitSeoTitle([
		`${props.pageTitle}${pageSuffix.value}`,
		`${props.pageTitleBase || props.pageTitle}${pageSuffix.value}`,
	]),
);

const seoDescription = computed(() =>
	props.pageDescription
		? `${props.pageDescription}${pageSuffix.value}`
		: undefined,
);

// Заголовок и описание страницы задаются дважды: сама страница листинга (там
// живут og:image и прочее) и этот компонент. Выигрывает регистрация, сделанная
// позже, а ListPage — дочерний компонент, то есть его setup выполняется после
// setup страницы. Поэтому номер страницы и лимит длины достаточно применить
// здесь одним местом на все семь листингов.
useSeoMeta({
	title: seoTitle,
	description: seoDescription,
	ogTitle: seoTitle,
	ogDescription: seoDescription,
	twitterTitle: seoTitle,
	twitterDescription: seoDescription,
	robots: robotsMeta,
});

const paginationLinks = computed(() => {
	const links: Array<{ rel: string; href: string }> = [];

	// Через getCanonicalUrl, а не своей сборкой URL: иначе порядок параметров
	// расходится с canonical этой же страницы. До правки rel=next отдавал
	// `?lang=ru&page=3`, а сама третья страница канонизировалась в
	// `?page=3&lang=ru` — та же перестановка, против которой затевалась
	// итерация 3 в prd/silent-200-index-hygiene.
	const buildUrl = (p: number) =>
		getCanonicalUrl(
			route.path,
			{
				...props.filterQuery,
				...(p > 1 ? { page: String(p) } : {}),
			},
			locale.value,
		);

	if (pageNumber.value > 1) {
		links.push({ rel: 'prev', href: buildUrl(pageNumber.value - 1) });
	}
	if (pageNumber.value < totalPages.value) {
		links.push({ rel: 'next', href: buildUrl(pageNumber.value + 1) });
	}
	return links;
});

useHead({ link: paginationLinks });

watch(
	() => route.query,
	(query) => {
		isSyncingFromRoute.value = true;
		pageNumber.value = Number(query.page) || 1;
		nextTick(() => {
			isSyncingFromRoute.value = false;
		});
	},
	{ immediate: true },
);

// Наблюдатели ниже регистрируются здесь, а не в конце onMounted: после
// `await` активный scope компонента потерян, и такие watch НЕ останавливаются
// при размонтировании. Утёкшие дёргали syncRoute(), то есть навигацию, уже
// после ухода со страницы — и копились с каждым открытием листинга.
// Флаг заменяет прежнюю защиту «порядком регистрации»: до первой
// синхронизации с роутом реагировать нельзя, иначе на монтировании уедет
// лишний push.
const isInitialRouteSyncDone = ref(false);

watch(
	() => props.filterQuery,
	() => {
		if (!isInitialRouteSyncDone.value || isSyncingFromRoute.value) {
			return;
		}
		pageNumber.value = 1;

		syncRoute();
	},
);

watch(pageNumber, () => {
	if (!isInitialRouteSyncDone.value || isSyncingFromRoute.value) {
		return;
	}
	syncRoute();

	window.scrollTo(0, 0);
});

onMounted(async () => {
	await nextTick();
	await syncRoute(true);
	isInitialRouteSyncDone.value = true;
});
</script>

<template>
	<div
		class="list-page"
		:class="{ 'list-page--map-view': view === 'map' }"
		role="main"
		:aria-label="t('AriaMainContent')"
	>
		<div class="list-sidebar">
			<div class="page-header">
				<h1 class="page-title">{{ pageTitle }}</h1>
				<!-- На узких экранах контролы встают одной строкой под заголовком -->
				<div class="page-header__controls">
					<slot name="header-actions" />
					<el-badge
						:value="activeFiltersCount"
						:hidden="activeFiltersCount === 0"
						type="primary"
						class="filters-toggle"
					>
						<el-button
							:icon="IconFilter"
							:aria-expanded="areFiltersOpen"
							@click="areFiltersOpen = !areFiltersOpen"
						>
							{{ t('Filters') }}
							<IconArrowDown
								:size="14"
								class="filters-toggle__chevron"
								:class="{ 'is-open': areFiltersOpen }"
							/>
						</el-button>
					</el-badge>
				</div>
			</div>

			<!-- Активные фильтры: не у каждого фасета есть свой контрол в панели
			     (ссылки из индекса, бейджи с карточек), и без этой строки человек
			     не видит, чем сужен список -->
			<slot name="active-filters" />

			<div class="list-container">
				<aside
					class="filters-sidebar"
					:class="{ 'is-open': areFiltersOpen }"
					role="search"
					:aria-label="t('AriaSearchFilters')"
				>
					<slot name="filters" />
				</aside>

				<section
					v-show="view !== 'map'"
					class="list-content"
					:aria-label="t('AriaSearchResults')"
					:aria-busy="isLoading || clinicsStore.isLoading"
				>
					<div class="list-wrapper">
						<div
							v-if="list.length === 0 && !isLoading"
							class="empty-state"
							role="status"
							aria-live="polite"
						>
							<p>{{ t('NotFound') }}</p>
						</div>

						<div
							v-else-if="list.length === 0"
							class="skeleton-list"
							role="status"
							aria-live="polite"
							:aria-label="t('AriaLoadingResults')"
						>
							<SkeletonCard v-for="i in 5" :key="i" />
						</div>

						<ul
							v-else
							class="results-list"
							role="list"
							:aria-label="t('AriaResultsList')"
						>
							<li
								v-for="item in list"
								:key="item.id"
								role="listitem"
								class="results-list-item"
							>
								<slot
									name="card"
									:item="item"
									:showClinicOnMap="showClinicOnMap"
								>
									<ListCard
										:title="item.name"
										:localName="item.localName"
										:itemId="item.id"
										:itemSlug="item.slug"
										:clinicIds="item.clinicIds"
										:clinicCount="item.clinicCount"
										:clinicPrices="item.clinicPrices"
										:detailsRouteName="detailsRouteName"
										:detailsParamName="detailsParamName"
										:clinicServices="item.clinicServices"
										:showPrice="showPrice"
										:filterCityIds="cityIds"
										@show-on-map="showClinicOnMap($event)"
									>
										<slot name="item" :item="item" />
									</ListCard>
								</slot>
							</li>
						</ul>

						<slot name="tips" />
					</div>

					<div
						v-if="isLoading || clinicsStore.isLoading"
						class="loading-overlay"
						role="status"
						aria-live="polite"
						:aria-label="t('AriaLoadingResults')"
					>
						<div class="loading-bar" aria-hidden="true"></div>
					</div>

					<nav :aria-label="t('AriaPagination')">
						<Pagination
							:total="totalCount"
							:page-size="LIST_PAGE_SIZE"
							v-model:current-page="pageNumber"
						/>
					</nav>
				</section>
			</div>
		</div>

		<aside
			ref="mapSentinel"
			class="map-container"
			:aria-label="t('AriaMapSection')"
		>
			<slot v-if="view === 'map'" name="map-view" />
			<slot v-else name="side-map">
				<ClinicServicesMap
					v-if="isMapVisible"
					ref="mapRef"
					:services="clinicMode || mapClinics ? [] : list"
					:clinics="mapClinics || clinicsStore.clinics"
					:showAllClinics="clinicMode || !!mapClinics"
					:autoFit="cityIds.length === 0"
					:detailsRouteName="detailsRouteName"
					:detailsParamName="detailsParamName"
					@ready="onMapReady"
				>
					<template #map-clinic-popup="slotProps">
						<slot name="map-clinic-popup" v-bind="slotProps" />
					</template>
				</ClinicServicesMap>
			</slot>
		</aside>
	</div>
</template>

<style lang="less" scoped>
.list-page {
	display: flex;
	min-height: calc(100vh - 120px);
	gap: 0;
	width: 100%;
	box-sizing: border-box;
}

.filters-sidebar {
	display: flex;
	box-sizing: border-box;
	flex-direction: column;
	flex: 0 0 280px;
	width: 280px;
	background: var(--kit-color-bg-primary);
	gap: var(--kit-spacing-lg);
	position: sticky;
	top: calc(60px + var(--kit-spacing-lg));
	align-self: flex-start;
	max-height: calc(100vh - 60px - 2 * var(--kit-spacing-lg));
	overflow-y: auto;
}

// Кнопка «Фильтры» — только на узких экранах, где фильтры свёрнуты
.filters-toggle {
	display: none;

	&__chevron {
		margin-left: var(--kit-spacing-xs);
		transition: transform var(--kit-transition-base);

		&.is-open {
			transform: rotate(180deg);
		}
	}
}

.list-sidebar {
	flex: 1 1 60%;
	min-width: 0;
	box-sizing: border-box;
	background: var(--kit-color-bg-primary);
	border-right: 1px solid rgba(0, 0, 0, 0.06);
	padding: var(--kit-spacing-lg);
}

.page-header {
	display: flex;
	align-items: flex-start;
	justify-content: space-between;
	flex-wrap: wrap;
	gap: var(--kit-spacing-md);
	margin-bottom: var(--kit-spacing-2xl);

	&__controls {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
		gap: var(--kit-spacing-md);
	}
}

.page-title {
	font-size: var(--kit-font-size-3xl);
	font-weight: 600;
	color: var(--kit-color-text-heading);
	margin: 0;
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	word-wrap: break-word;
}

.list-container {
	display: flex;
	flex-direction: row;
	gap: var(--kit-spacing-2xl);
	width: 100%;
	box-sizing: border-box;

	.list-content {
		flex: 1 1 auto;
		min-width: 0;
		min-height: 400px;
		box-sizing: border-box;
		position: relative;
	}
}

.list-wrapper {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
	width: 100%;
	box-sizing: border-box;
}

.results-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
	width: 100%;
	box-sizing: border-box;
}

.results-list-item {
	display: block;
	width: 100%;
	box-sizing: border-box;
}

.skeleton-list {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
	width: 100%;
	box-sizing: border-box;
}

.empty-state {
	text-align: center;
	padding: 40px;
	color: var(--kit-color-text-muted);
}

.loading-overlay {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(255, 255, 255, 0.4);
	pointer-events: none;
}

.loading-bar {
	height: 3px;
	width: 100%;
	background: linear-gradient(
		90deg,
		var(--kit-color-primary) 0%,
		var(--kit-color-primary-light) 50%,
		var(--kit-color-primary) 100%
	);
	animation: loading-slide 0.8s linear infinite;
}

@keyframes loading-slide {
	0% {
		transform: translateX(-40%);
	}
	100% {
		transform: translateX(40%);
	}
}

.map-container {
	flex: 1 1 40%;
	min-width: 0;
	box-sizing: border-box;
	position: sticky;
	top: 60px;
	height: calc(100vh - 60px);
	align-self: flex-start;
}

// Режим «Карта»: слева узкая колонка с заголовком и фильтрами, карта — всё остальное
.list-page--map-view {
	.list-sidebar {
		flex: 0 0 380px;
		min-width: 0;
	}

	.map-container {
		flex: 1 1 auto;
	}

	.list-container .filters-sidebar {
		flex: 1 1 auto;
		width: 100%;
	}
}

@media (max-width: 1300px) {
	.page-header {
		margin-bottom: var(--kit-spacing-lg);
	}

	.filters-toggle {
		display: inline-block;
	}

	.list-container {
		flex-direction: column;

		// Свёрнуты по умолчанию, раскрываются кнопкой «Фильтры»
		.filters-sidebar {
			display: none;
			position: initial;
			max-width: 100%;
			width: 100%;
			max-height: none;
			overflow-y: visible;
			gap: var(--kit-spacing-sm);

			&.is-open {
				display: flex;
			}
		}
	}
}

@media (max-width: 950px) {
	.list-page {
		flex-direction: column;
	}

	.list-sidebar {
		flex: none;
		width: 100%;
		border-right: none;
	}

	.map-container {
		flex: none;
		width: 100%;
		position: static;
		height: 450px;
		margin-bottom: var(--kit-spacing-2xl);
	}

	// На мобильном режим карты — настоящий фулскрин-оверлей поверх шапки
	// и фильтров; выход — плавающая кнопка «К списку».
	.list-page--map-view {
		.list-sidebar {
			flex: none;
			width: 100%;
		}

		.map-container {
			position: fixed;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			width: 100%;
			// Явная высота: Leaflet-контейнер тянется цепочкой height:100%,
			// которая должна упираться в конкретное значение — с height:auto
			// карта схлопывается в 0
			height: 100vh;
			height: 100dvh;
			margin-bottom: 0;
			background: var(--kit-color-bg-primary);
			// Поверх sticky-шапки (--kit-z-header), иначе та перекрывает верх карты
			z-index: var(--kit-z-modal);
		}
	}
}

@media (max-width: 500px) {
	.list-sidebar {
		padding: var(--kit-spacing-sm);
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"Loading": "Loading...",
		"Filters": "Filters",
		"NotFound": "No results found",
		"AriaMainContent": "Main content",
		"AriaSearchFilters": "Search filters",
		"AriaSearchResults": "Search results",
		"AriaResultsList": "List of results",
		"AriaLoadingResults": "Loading results",
		"AriaPagination": "Results pagination",
		"AriaMapSection": "Map with locations",
		"PageOf": "Page {page} of {total}"
	},
	"ru": {
		"Loading": "Загрузка...",
		"Filters": "Фильтры",
		"NotFound": "Результаты не найдены",
		"AriaMainContent": "Основное содержимое",
		"AriaSearchFilters": "Фильтры поиска",
		"AriaSearchResults": "Результаты поиска",
		"AriaResultsList": "Список результатов",
		"AriaLoadingResults": "Загрузка результатов",
		"AriaPagination": "Постраничная навигация",
		"AriaMapSection": "Карта с расположениями",
		"PageOf": "Страница {page} из {total}"
	},
	"sr": {
		"Loading": "Učitavanje...",
		"Filters": "Filteri",
		"NotFound": "Rezultati nisu pronađeni",
		"AriaMainContent": "Glavni sadržaj",
		"AriaSearchFilters": "Filteri pretrage",
		"AriaSearchResults": "Rezultati pretrage",
		"AriaResultsList": "Lista rezultata",
		"AriaLoadingResults": "Učitavanje rezultata",
		"AriaPagination": "Navigacija po stranicama",
		"AriaMapSection": "Mapa sa lokacijama",
		"PageOf": "Stranica {page} od {total}"
	},
	"sr-cyrl": {
		"Loading": "Учитавање...",
		"Filters": "Филтери",
		"NotFound": "Резултати нису пронађени",
		"AriaMainContent": "Главни садржај",
		"AriaSearchFilters": "Филтери претраге",
		"AriaSearchResults": "Резултати претраге",
		"AriaResultsList": "Листа резултата",
		"AriaLoadingResults": "Учитавање резултата",
		"AriaPagination": "Навигација по страницама",
		"AriaMapSection": "Мапа са локацијама",
		"PageOf": "Страница {page} од {total}"
	},
	"de": {
		"Loading": "Laden...",
		"Filters": "Filter",
		"NotFound": "Keine Ergebnisse gefunden",
		"AriaMainContent": "Hauptinhalt",
		"AriaSearchFilters": "Suchfilter",
		"AriaSearchResults": "Suchergebnisse",
		"AriaResultsList": "Ergebnisliste",
		"AriaLoadingResults": "Ergebnisse werden geladen",
		"AriaPagination": "Seitennavigation",
		"AriaMapSection": "Karte mit Standorten",
		"PageOf": "Seite {page} von {total}"
	},
	"tr": {
		"Loading": "Yükleniyor...",
		"Filters": "Filtreler",
		"NotFound": "Sonuç bulunamadı",
		"AriaMainContent": "Ana içerik",
		"AriaSearchFilters": "Arama filtreleri",
		"AriaSearchResults": "Arama sonuçları",
		"AriaResultsList": "Sonuç listesi",
		"AriaLoadingResults": "Sonuçlar yükleniyor",
		"AriaPagination": "Sayfa navigasyonu",
		"AriaMapSection": "Konumlu harita",
		"PageOf": "Sayfa {page} / {total}"
	}
}
</i18n>
