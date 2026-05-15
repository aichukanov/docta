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
		if (!raw || raw === 'other') return null;
		const n = parseInt(raw);
		return Number.isFinite(n) && n > 0 ? n : null;
	});

	const currentSort = computed<ClinicItemsSort>(() => {
		const raw = (route.query.sort as string) || '';
		return (allowed as readonly string[]).includes(raw)
			? (raw as ClinicItemsSort)
			: '';
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
		pushQuery,
	};
}
