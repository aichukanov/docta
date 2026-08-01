export const CLINIC_ITEMS_ALLOWED_SORTS = [
	'name-asc',
	'price-asc',
	'price-desc',
	'rating-desc',
	'popular-desc',
] as const;

export type ClinicItemsSort = (typeof CLINIC_ITEMS_ALLOWED_SORTS)[number] | '';

export function useClinicItemsRoute(options?: {
	allowedSorts?: readonly string[];
}) {
	const allowed = options?.allowedSorts ?? CLINIC_ITEMS_ALLOWED_SORTS;
	const route = useRoute();
	const router = useRouter();

	const currentPage = computed(() => {
		const v = parseInt(route.query.page as string);
		return Number.isFinite(v) && v > 0 ? v : 1;
	});

	const currentSearch = computed(() => (route.query.search as string) || '');

	const currentCategory = computed(() => {
		const raw = route.query.category as string | undefined;
		if (!raw) return null;
		const n = parseInt(raw);
		return Number.isFinite(n) && n > 0 ? n : null;
	});

	const currentSort = computed<ClinicItemsSort>(() => {
		const raw = (route.query.sort as string) || '';
		return (allowed as readonly string[]).includes(raw)
			? (raw as ClinicItemsSort)
			: '';
	});

	/**
	 * Есть ли в URL параметры, из-за которых страница — дубль базовой подстраницы.
	 * Используется только для `robots` (пункт 7e аудита и его окрестности).
	 *
	 * Отдельным флагом, а НЕ добавлением в `isFiltered`: тот управляет ещё и
	 * отображаемым счётчиком, и пропом `isFiltered` дочернего компонента —
	 * порядок сортировки не должен менять UI.
	 *
	 * Три случая, все проверены вживую:
	 *
	 * 1. `?sort=<любое непустое>` — валидное значение меняет только ПОРЯДОК, а не
	 *    состав; невалидное молча игнорируется. И то и другое = дубль.
	 * 2. `?category=abc` — не парсится, фильтр молча отбрасывается, отдаётся
	 *    полный список. Тот же класс, что 7d на листингах.
	 * 3. `?page=1` и `?page=abc` — сводятся к первой странице, то есть к базовому URL.
	 *
	 * Почему noindex, а не вырезание `sort` из canonical: подстраницы клиник
	 * пагинируются, и у `?sort=X&page=2` состав ИНОЙ, чем у `?page=2` —
	 * канонизировать одно в другое было бы неправдой.
	 */
	const hasRedundantQuery = computed(() => {
		const raw = (key: string) => {
			const v = route.query[key];
			return Array.isArray(v) ? v[0] : v;
		};

		if (raw('sort')) return true;
		if (raw('category') != null && currentCategory.value == null) return true;
		if (raw('page') != null && currentPage.value === 1) return true;

		return false;
	});

	const pushQuery = (
		updates: Record<string, string | number | null | undefined>,
	) => {
		const next: Record<string, string> = {};
		for (const [k, v] of Object.entries(route.query)) {
			if (k in updates) continue;
			if (typeof v === 'string') next[k] = v;
		}
		for (const [k, v] of Object.entries(updates)) {
			if (v == null || v === '' || v === 0) continue;
			next[k] = String(v);
		}
		router.push({ query: next });
	};

	return {
		currentPage,
		currentSearch,
		currentCategory,
		currentSort,
		hasRedundantQuery,
		pushQuery,
	};
}
