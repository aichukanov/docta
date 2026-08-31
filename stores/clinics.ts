import { defineStore } from 'pinia';
import type { ClinicData } from '~/interfaces/clinic';

export const useClinicsStore = defineStore('clinics', () => {
	const { locale } = useI18n();

	// shallowRef: массив всегда заменяется целиком (loadClinicsData/refresh),
	// отдельные клиники никто не мутирует. Глубокая реактивность оборачивала
	// каждую из ~130 записей в прокси без единого потребителя такой точности.
	const clinics = shallowRef<ClinicData[]>([]);
	const isLoading = ref(false);
	const isLoaded = ref(false);
	const currentLocale = ref<string | null>(null);

	const fetchPromise = ref<Promise<{
		clinics: ClinicData[];
		totalCount: number;
	} | null> | null>(null);

	// Режим последней загрузки: справочный (без описаний) или полный.
	// Полный просит только админка — ей описание нужно для формы правки.
	const loadedMode = ref<'directory' | 'full' | null>(null);

	const loadClinicsData = async (mode: 'directory' | 'full') => {
		isLoading.value = true;
		currentLocale.value = locale.value;
		loadedMode.value = mode;

		const promise = $fetch<{
			clinics: ClinicData[];
			totalCount: number;
		}>('/api/clinics/list', {
			method: 'POST',
			body: {
				locale: locale.value || 'en',
				...(mode === 'directory' ? { fields: 'directory' } : {}),
			},
		}).catch((error) => {
			console.error('Failed to fetch clinics:', error);
			throw error;
		});
		fetchPromise.value = promise;

		const response = await promise;

		clinics.value = response.clinics || [];
		isLoaded.value = true;
		isLoading.value = false;
	};

	const fetchClinics = async (options?: { full?: boolean }) => {
		const mode = options?.full ? 'full' : 'directory';
		// Справочная загрузка полным ответом уже удовлетворена; обратное — нет.
		const modeSatisfied = mode === 'directory' || loadedMode.value === 'full';

		// After SSR hydration, Pinia restores clinics but isLoaded/currentLocale reset
		if (clinics.value.length > 0 && !currentLocale.value && modeSatisfied) {
			currentLocale.value = locale.value;
			isLoaded.value = true;
			return;
		}

		if (isLoaded.value && currentLocale.value === locale.value && modeSatisfied) {
			return;
		}

		if (fetchPromise.value && currentLocale.value === locale.value && modeSatisfied) {
			await fetchPromise.value;
		} else {
			await loadClinicsData(mode);
		}
	};

	const refresh = async () => {
		fetchPromise.value = null;
		isLoaded.value = false;
		await loadClinicsData(loadedMode.value ?? 'directory');
	};

	// Автоматически перезагружаем данные при смене языка
	watch(locale, () => {
		if (isLoaded.value) {
			refresh();
		}
	});

	// Индекс по id: карточка листинга резолвит клиники на каждый пересчёт
	// computed, а строка id у ходовой услуги содержит десятки значений. Через
	// find() это давало произведение «карточки × id × размер каталога» —
	// порядка сотен тысяч проходов по массиву на один рендер списка.
	const clinicsById = computed(() => {
		const index = new Map<number, ClinicData>();
		for (const clinic of clinics.value) {
			index.set(clinic.id, clinic);
		}
		return index;
	});

	/**
	 * Получает клиники по строке ID, сохраняя порядок (для сортировки по цене)
	 * @param clinicIdsString - строка с ID клиник через запятую (например "1,5,3")
	 * @param limit - сколько найденных клиник достаточно; остальные id не
	 *   резолвятся вовсе. Карточке нужны первые LIST_CARD_MAX_CLINICS, и
	 *   обрезать результат раньше дешевле, чем после.
	 */
	const getClinicsByIds = (
		clinicIdsString: string | undefined,
		limit?: number,
	): ClinicData[] => {
		if (!clinicIdsString || !clinics.value.length) {
			return [];
		}

		const found: ClinicData[] = [];

		for (const rawId of clinicIdsString.split(',')) {
			if (limit != null && found.length >= limit) {
				break;
			}

			const clinic = clinicsById.value.get(Number(rawId));

			if (clinic) {
				found.push(clinic);
			}
		}

		return found;
	};

	return {
		clinics,
		clinicsById,
		isLoading,
		isLoaded,
		fetchClinics,
		refresh,
		getClinicsByIds,
	};
});
