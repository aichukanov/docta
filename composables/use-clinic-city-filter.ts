import { toRefs } from 'vue';
import type { ComputedRef } from 'vue';
import type { LocationQueryRaw } from 'vue-router';
import { useFiltersStore, type FilterNamespace } from '~/stores/filters';
import { validateCityIds } from '~/common/validation';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

const parseCityIdsFromQuery = (raw: unknown): number[] => {
	if (raw == null) return [];
	const arr = Array.isArray(raw) ? raw : [raw];
	const ids = arr
		.map((v) => Number(v))
		.filter((n) => Number.isFinite(n) && n > 0);
	if (!ids.length) return [];
	return validateCityIds({ cityIds: ids }, 'use-clinic-city-filter') ? ids : [];
};

const sameIdSet = (a: readonly number[], b: readonly number[]) => {
	if (a.length !== b.length) return false;
	const setA = new Set(a);
	for (const id of b) {
		if (!setA.has(id)) return false;
	}
	return true;
};

/**
 * Связывает list-page-овский фильтр городов из стора `filters` с URL детальной
 * страницы и со списком клиник этой страницы.
 *
 * - Фильтрация чисто клиентская — бэкенд про неё не знает.
 * - `cityIds` живёт в URL как `?cityIds=10&cityIds=20`: разные города дают
 *   разные канонические URL, что нужно для SEO (паук видит отдельную страницу
 *   на каждый город, заголовок / описание / JSON-LD на сервере уже отражают
 *   выбранный город).
 */
export function useClinicCityFilter(
	namespace: FilterNamespace,
	clinics: ComputedRef<ClinicData[]>,
	clinicPrices?: ComputedRef<ClinicPrice[] | undefined>,
) {
	const filtersStore = useFiltersStore();
	const route = useRoute();
	const router = useRouter();
	const { cityIds } = toRefs(filtersStore.namespaces[namespace]);

	const isSyncingFromRoute = ref(false);
	// Фиксируем имя маршрута на момент монтирования. Во время back-navigation
	// route обновляется ДО того, как страница успевает размонтироваться, и
	// watch-и из этого composable могут сработать на чужой странице — что роняет
	// рендер из-за гонки с useFetch.clear() и v-if на отфильтрованных списках.
	const ownRouteName = route.name;

	// URL → store. Срабатывает immediate-ом, поэтому SSR сразу видит выбранный
	// город и рендерит уже отфильтрованный контент.
	watch(
		() => route.query.cityIds,
		(raw) => {
			if (route.name !== ownRouteName) return;
			const parsed = parseCityIdsFromQuery(raw);
			if (sameIdSet(parsed, cityIds.value)) return;
			isSyncingFromRoute.value = true;
			cityIds.value = parsed;
			nextTick(() => {
				isSyncingFromRoute.value = false;
			});
		},
		{ immediate: true },
	);

	// store → URL. Только на клиенте: на SSR нам менять URL нечем,
	// а после гидрации пользовательский выбор должен попадать в адресную строку
	// через replace (не засоряем history).
	if (import.meta.client) {
		watch(cityIds, (ids) => {
			if (route.name !== ownRouteName) return;
			if (isSyncingFromRoute.value) return;
			const current = parseCityIdsFromQuery(route.query.cityIds);
			if (sameIdSet(ids, current)) return;
			const nextQuery: LocationQueryRaw = { ...route.query };
			if (ids.length) {
				nextQuery.cityIds = ids.map(String);
			} else {
				delete nextQuery.cityIds;
			}
			router.replace({ query: nextQuery });
		});
	}

	const filteredClinics = computed(() => {
		if (!cityIds.value.length) {
			return clinics.value;
		}
		const allowed = new Set(cityIds.value);
		return clinics.value.filter((clinic) => allowed.has(clinic.cityId));
	});

	// Цены клиник, отсечённые по видимому списку — нужны JSON-LD-схеме,
	// чтобы AggregateOffer (lowPrice / highPrice / offerCount) отражал то,
	// что реально отрисовано.
	const filteredClinicPrices = computed<ClinicPrice[]>(() => {
		const all = clinicPrices?.value ?? [];
		if (!cityIds.value.length) return all;
		const allowed = new Set(filteredClinics.value.map((c) => c.id));
		return all.filter((p) => allowed.has(p.clinicId));
	});

	return {
		cityIds,
		filteredClinics,
		filteredClinicPrices,
	};
}
