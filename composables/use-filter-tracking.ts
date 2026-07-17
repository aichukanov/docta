import { isEqual } from 'lodash-es';
import type { FilterNamespace } from '~/stores/filters';

type FilterValue = string | number | boolean | Array<string | number>;

/**
 * Трекинг поиска и фильтров на листинге: следит за неймспейсом фильтров и
 * шлёт search_performed / filter_applied / filter_cleared по изменившимся
 * полям. Значение name приходит уже debounced (FilterName эмитит с задержкой
 * 300мс), поэтому события не сыплются на каждый кейстрок.
 *
 * Вызывать в setup листинг-страницы ПОСЛЕ первичной синхронизации стора из
 * URL (watch route.query + updateFromRoute с immediate: true) — иначе
 * восстановление состояния затрекается как действие пользователя.
 */
export function useFilterTracking(namespace: FilterNamespace) {
	if (!import.meta.client) return;

	const { trackEvent } = useAnalytics();
	const filtersStore = useFiltersStore();

	// Снапшот-клон: watch получает прошлое и текущее состояние целиком
	const snapshot = () =>
		JSON.parse(JSON.stringify(filtersStore.namespaces[namespace])) as Record<
			string,
			FilterValue
		>;

	// Любая пачка изменений, в которой была URL-синхронизация (back/forward,
	// переход по ссылке с query), — не действие пользователя: пропускаем,
	// но запоминаем состояние как новую базу для следующего сравнения
	let seenSyncVersion = filtersStore.routeSyncVersion;

	watch(snapshot, (current, previous) => {
		if (filtersStore.routeSyncVersion !== seenSyncVersion) {
			seenSyncVersion = filtersStore.routeSyncVersion;
			return;
		}
		let clearedCount = 0;

		for (const [key, value] of Object.entries(current)) {
			if (isEqual(value, previous[key])) continue;

			const isEmpty = Array.isArray(value) ? value.length === 0 : !value;

			if (key === 'name') {
				if (!isEmpty) {
					trackEvent('search_performed', { query: value as string });
				}
				continue;
			}

			if (isEmpty) {
				clearedCount += 1;
				continue;
			}

			trackEvent('filter_applied', { filter_name: key, filter_value: value });
		}

		if (clearedCount > 0) {
			trackEvent('filter_cleared', { filters_count: clearedCount });
		}
	});
}
