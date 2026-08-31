<script setup lang="ts">
import { debounce } from 'lodash-es';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName, normalizeForSearch } from '~/common/utils';
import { selectForm } from '~/common/intl';
import { localizeStrength } from '~/common/strength-label';
import { buildPackagingLabel } from '~/common/packaging-label';
import {
	groupMedicines,
	medicineMatchHint,
	type MedicineGroup,
} from '~/common/medicine-search-groups';
import { ARTICLE_SEARCH } from '~/common/articles';
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';
import cityI18n from '~/i18n/city';
import packagingI18n from '~/i18n/packaging';
import clinicCommonI18n from '~/i18n/clinic-common';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import labtestCategoryI18n from '~/i18n/labtest-category';
import articleSearchI18n from '~/i18n/article-search';
import searchMatchI18n from '~/i18n/search-match';
import { combineI18nMessages } from '~/i18n/utils';
import type {
	ClinicPrice,
	ClinicServiceWithPrices,
	LabTestItem,
} from '~/interfaces/clinic';
import type { MedicineListItem } from '~/interfaces/medicine';
import type { DoctorData } from '~/interfaces/doctor';

// Сколько строк показываем в каждой группе выдачи.
const SHOWN_PER_GROUP = 5;
// Лекарства запрашиваем с запасом: записи одного названия сводятся в одну
// строку (фасовки реестра), и без запаса пять групп могли не набраться.
const MEDICINE_FETCH_SIZE = 24;
// Сколько ярлыков-вариантов показываем под строкой лекарства до «все варианты».
const SHOWN_VARIANTS = 3;
// Уточнений (клиника, город) в строке врача — больше не влезает в ширину.
const SHOWN_DOCTOR_CLINICS = 2;
const SHOWN_CATEGORIES = 2;
// С какой длины запроса матчим статьи по невидимым ключевым словам. На одной
// букве по ним совпадает почти всё, и строка появлялась без объяснимой причины;
// ярлык статьи виден, поэтому по нему ищем с первого символа.
const MIN_KEYWORD_QUERY_LENGTH = 3;

const globalSearchI18n = {
	messages: {
		'en': {
			SearchPlaceholder: 'Search doctors, clinics, medications, tests',
			Searching: 'Searching...',
			NoResults: 'No results found',
			Specialties: 'Specialties',
			Doctors: 'Doctors',
			Clinics: 'Clinics',
			MedicalServices: 'Medical Services',
			Medications: 'Medications',
			LabTests: 'Lab Tests',
			MoreDoctors: 'More doctors ({count})',
			MoreClinics: 'More clinics ({count})',
			MoreMedicalServices: 'More services ({count})',
			MoreMedications: 'More medications ({count})',
			MoreLabTests: 'More tests ({count})',
			SpecialtyDoctors: 'Doctors of this specialty',
			ClinicsUnit: 'clinic; clinics',
			AllVariants: 'All variants ({count})',
		},
		'ru': {
			SearchPlaceholder: 'Поиск врачей, клиник, лекарств, анализов',
			Searching: 'Поиск...',
			NoResults: 'Ничего не найдено',
			Specialties: 'Специальности',
			Doctors: 'Врачи',
			Clinics: 'Клиники',
			MedicalServices: 'Медицинские услуги',
			Medications: 'Лекарства',
			LabTests: 'Анализы',
			MoreDoctors: 'Ещё врачи ({count})',
			MoreClinics: 'Ещё клиники ({count})',
			MoreMedicalServices: 'Ещё услуги ({count})',
			MoreMedications: 'Ещё лекарства ({count})',
			MoreLabTests: 'Ещё анализы ({count})',
			SpecialtyDoctors: 'Врачи этой специальности',
			ClinicsUnit: 'клиника; клиники; клиник',
			AllVariants: 'Все варианты ({count})',
		},
		'sr': {
			SearchPlaceholder: 'Pretraga ljekara, klinika, lijekova, analiza',
			Searching: 'Pretraga...',
			NoResults: 'Nema rezultata',
			Specialties: 'Specijalnosti',
			Doctors: 'Ljekari',
			Clinics: 'Klinike',
			MedicalServices: 'Medicinske usluge',
			Medications: 'Lijekovi',
			LabTests: 'Analize',
			MoreDoctors: 'Još ljekara ({count})',
			MoreClinics: 'Još klinika ({count})',
			MoreMedicalServices: 'Još usluga ({count})',
			MoreMedications: 'Još lijekova ({count})',
			MoreLabTests: 'Još analiza ({count})',
			SpecialtyDoctors: 'Ljekari ove specijalnosti',
			ClinicsUnit: 'klinika; klinike; klinika',
			AllVariants: 'Sve varijante ({count})',
		},
		'sr-cyrl': {
			SearchPlaceholder: 'Претрага љекара, клиника, лијекова, анализа',
			Searching: 'Претрага...',
			NoResults: 'Нема резултата',
			Specialties: 'Специјалности',
			Doctors: 'Љекари',
			Clinics: 'Клинике',
			MedicalServices: 'Медицинске услуге',
			Medications: 'Лијекови',
			LabTests: 'Анализе',
			MoreDoctors: 'Још љекара ({count})',
			MoreClinics: 'Још клиника ({count})',
			MoreMedicalServices: 'Још услуга ({count})',
			MoreMedications: 'Још лијекова ({count})',
			MoreLabTests: 'Још анализа ({count})',
			SpecialtyDoctors: 'Љекари ове специјалности',
			ClinicsUnit: 'клиника; клинике; клиника',
			AllVariants: 'Све варијанте ({count})',
		},
		'de': {
			SearchPlaceholder: 'Suche nach Ärzten, Kliniken, Medikamenten, Tests',
			Searching: 'Suche...',
			NoResults: 'Keine Ergebnisse gefunden',
			Specialties: 'Fachgebiete',
			Doctors: 'Ärzte',
			Clinics: 'Kliniken',
			MedicalServices: 'Medizinische Leistungen',
			Medications: 'Medikamente',
			LabTests: 'Labortests',
			MoreDoctors: 'Mehr Ärzte ({count})',
			MoreClinics: 'Mehr Kliniken ({count})',
			MoreMedicalServices: 'Mehr Leistungen ({count})',
			MoreMedications: 'Mehr Medikamente ({count})',
			MoreLabTests: 'Mehr Tests ({count})',
			SpecialtyDoctors: 'Ärzte dieses Fachgebiets',
			ClinicsUnit: 'Klinik; Kliniken',
			AllVariants: 'Alle Varianten ({count})',
		},
		'tr': {
			SearchPlaceholder: 'Doktor, klinik, ilaç, test ara',
			Searching: 'Aranıyor...',
			NoResults: 'Sonuç bulunamadı',
			Specialties: 'Uzmanlıklar',
			Doctors: 'Doktorlar',
			Clinics: 'Klinikler',
			MedicalServices: 'Tıbbi Hizmetler',
			Medications: 'İlaçlar',
			LabTests: 'Laboratuvar Testleri',
			MoreDoctors: 'Daha fazla doktor ({count})',
			MoreClinics: 'Daha fazla klinik ({count})',
			MoreMedicalServices: 'Daha fazla hizmet ({count})',
			MoreMedications: 'Daha fazla ilaç ({count})',
			MoreLabTests: 'Daha fazla test ({count})',
			SpecialtyDoctors: 'Bu uzmanlıktaki doktorlar',
			ClinicsUnit: 'klinik',
			AllVariants: 'Tüm çeşitler ({count})',
		},
	},
};

const { t, n, locale } = useI18n({
	useScope: 'local',
	// globalSearchI18n последним: его ключи должны выигрывать у справочников
	messages: combineI18nMessages([
		specialtyI18n,
		cityI18n,
		packagingI18n,
		clinicCommonI18n,
		medicalServiceCategoryI18n,
		labtestCategoryI18n,
		articleSearchI18n,
		searchMatchI18n,
		globalSearchI18n,
	]),
});

const searchQuery = ref('');
const isOpen = ref(false);
const isLoading = ref(false);
const searchPerformed = ref(false);
const inputRef = ref<HTMLInputElement | null>(null);

// Store клиник (загружается один раз)
const clinicsStore = useClinicsStore();
clinicsStore.fetchClinics();

// Результаты поиска: серверные категории отдают страницу и общее число,
// клиентские (специальности, клиники) фильтруются целиком.
const allFilteredSpecialties = ref<{ id: number; name: string }[]>([]);
// Статьи: ярлык, путь и слово, по которому нашлось (для подписи «упоминается»)
const allFilteredArticles = ref<
	{ slug: string; label: string; keyword: string | null }[]
>([]);
const allFilteredClinics = ref<{ id: number; slug: string; name: string }[]>(
	[],
);
const doctors = ref<DoctorData[]>([]);
const doctorsTotal = ref(0);
const medicalServices = ref<ClinicServiceWithPrices[]>([]);
const medicalServicesTotal = ref(0);
const medicines = ref<MedicineListItem[]>([]);
const medicinesTotal = ref(0);
const labTests = ref<LabTestItem[]>([]);
const labTestsTotal = ref(0);

// Текущий поисковый запрос для ссылок и подсветки совпадений
const currentQuery = ref('');

const shownSpecialties = computed(() =>
	allFilteredSpecialties.value.slice(0, SHOWN_PER_GROUP),
);
const shownClinics = computed(() =>
	allFilteredClinics.value.slice(0, SHOWN_PER_GROUP),
);
const shownArticles = computed(() =>
	allFilteredArticles.value.slice(0, SHOWN_PER_GROUP),
);
const shownDoctors = computed(() => doctors.value.slice(0, SHOWN_PER_GROUP));
const shownMedicalServices = computed(() =>
	medicalServices.value.slice(0, SHOWN_PER_GROUP),
);
const shownLabTests = computed(() => labTests.value.slice(0, SHOWN_PER_GROUP));

// Фасовки одного названия — одной строкой (см. common/medicine-search-groups.ts)
const shownMedicineGroups = computed(() =>
	groupMedicines(medicines.value, t, locale.value).slice(0, SHOWN_PER_GROUP),
);
// Показанные группы покрывают столько записей реестра — с этим и сравниваем
// общее число, иначе ссылка «ещё» появлялась бы при полностью выведенной выдаче
const shownMedicineItems = computed(() =>
	shownMedicineGroups.value.reduce(
		(sum, group) => sum + group.variants.length,
		0,
	),
);

// Все специальности с локализованными названиями
const allSpecialties = computed(() =>
	Object.values(DoctorSpecialty)
		.filter(Number)
		.map((key) => ({
			id: key as number,
			name: t(`specialty_${key}`),
		}))
		.sort((a, b) => a.name.localeCompare(b.name)),
);

// Фильтрация специальностей по вводу
function filterSpecialties(query: string) {
	if (!query.trim()) {
		allFilteredSpecialties.value = [];
		return;
	}
	const normalizedQuery = normalizeForSearch(query);
	allFilteredSpecialties.value = allSpecialties.value.filter((s) =>
		normalizeForSearch(s.name).includes(normalizedQuery),
	);
}

// Фильтрация клиник из store (без запроса на сервер).
// Ищем и по локализованному имени, и по оригинальному сербскому (localName):
// в ru/en/de/tr-локалях клинику ищут по вывеске, а не только по переводу —
// как это делает /api/clinics/list (name_sr OR name_sr_cyrl OR name_ru).
function filterClinics(query: string) {
	if (!query.trim()) {
		allFilteredClinics.value = [];
		return;
	}
	const normalizedQuery = normalizeForSearch(query);
	allFilteredClinics.value = clinicsStore.clinics
		.filter(
			(c) =>
				normalizeForSearch(getLocalizedName(c, locale.value)).includes(
					normalizedQuery,
				) || normalizeForSearch(c.localName).includes(normalizedQuery),
		)
		.map((c) => ({
			id: c.id,
			slug: c.slug,
			name: getLocalizedName(c, locale.value),
		}));
}

// Статьи ищем по короткому ярлыку и по ключевым словам (common/articles.ts).
// Ключевые слова закрывают то, чего в ярлыке нет: «Zyrtec» → статья о
// лекарствах, которых в Черногории не найти. Без этого поиск по такому бренду
// отдавал пустую выдачу — сопоставить его с реестром нечем, вещества
// (цетиризина) в Черногории нет вообще.
function filterArticles(query: string) {
	if (!query.trim()) {
		allFilteredArticles.value = [];
		return;
	}
	const normalizedQuery = normalizeForSearch(query.trim());
	const matchKeywords = normalizedQuery.length >= MIN_KEYWORD_QUERY_LENGTH;
	allFilteredArticles.value = ARTICLE_SEARCH.flatMap((article) => {
		const label = t(article.labelKey);
		const byLabel = normalizeForSearch(label).includes(normalizedQuery);
		// Подпись показывает слово, по которому нашлось, только если в ярлыке
		// его не видно — иначе это повтор того же самого в двух строках
		const keyword =
			byLabel || !matchKeywords
				? null
				: article.keywords.find((word) =>
						normalizeForSearch(word).includes(normalizedQuery),
					) || null;
		if (!byLabel && !keyword) return [];
		return [{ slug: article.slug, label, keyword }];
	})
		// Совпадение в видимом ярлыке — выше совпадения по ключевому слову
		.sort((a, b) => Number(!!a.keyword) - Number(!!b.keyword));
}

function resetResults() {
	allFilteredSpecialties.value = [];
	allFilteredArticles.value = [];
	allFilteredClinics.value = [];
	doctors.value = [];
	doctorsTotal.value = 0;
	medicalServices.value = [];
	medicalServicesTotal.value = 0;
	medicines.value = [];
	medicinesTotal.value = 0;
	labTests.value = [];
	labTestsTotal.value = 0;
}

// AbortController для отмены предыдущих запросов
let abortController: AbortController | null = null;

// Поиск по API
async function searchEntities(query: string) {
	// Отменяем предыдущий запрос
	if (abortController) {
		abortController.abort();
	}

	if (!query.trim()) {
		resetResults();
		return;
	}

	// Создаём новый AbortController
	abortController = new AbortController();
	const signal = abortController.signal;

	isLoading.value = true;
	currentQuery.value = query;

	// Запрашиваем ровно страницу, а не всю выдачу: число совпадений приходит
	// отдельным полем totalCount и идёт в подпись «ещё N».
	const listBody = {
		name: query,
		locale: locale.value,
		page: 1,
		pageSize: SHOWN_PER_GROUP,
	};

	try {
		const [doctorsRes, medicalServicesRes, medicinesRes, labTestsRes] =
			await Promise.all([
				$fetch('/api/doctors/list', {
					method: 'POST',
					body: listBody,
					signal,
				}),
				$fetch('/api/services/list', {
					method: 'POST',
					body: listBody,
					signal,
				}),
				$fetch('/api/medicines/list', {
					method: 'POST',
					body: { ...listBody, pageSize: MEDICINE_FETCH_SIZE },
					signal,
				}),
				$fetch('/api/labtests/list', {
					method: 'POST',
					body: listBody,
					signal,
				}),
			]);

		// Проверяем что запрос не был отменён и query актуален
		if (signal.aborted || query !== currentQuery.value) {
			return;
		}

		doctors.value = doctorsRes?.doctors || [];
		doctorsTotal.value = doctorsRes?.totalCount || 0;
		medicalServices.value = medicalServicesRes?.items || [];
		medicalServicesTotal.value = medicalServicesRes?.totalCount || 0;
		medicines.value = medicinesRes?.items || [];
		medicinesTotal.value = medicinesRes?.totalCount || 0;
		labTests.value = labTestsRes?.items || [];
		labTestsTotal.value = labTestsRes?.totalCount || 0;
	} catch (error: any) {
		// Игнорируем ошибки отмены (может быть AbortError напрямую или в cause)
		if (
			signal.aborted ||
			error?.name === 'AbortError' ||
			error?.cause?.name === 'AbortError'
		) {
			return;
		}
		console.error('Search error:', error);
	} finally {
		if (!signal.aborted) {
			isLoading.value = false;
			searchPerformed.value = true;
		}
	}
}

// Debounced поиск
const debouncedSearch = debounce((query: string) => {
	filterSpecialties(query);
	filterClinics(query);
	filterArticles(query);
	searchEntities(query);
}, 300);

// Порог запроса — 2 знака. Один знак бессмыслен: «а» даёт тысячи совпадений
// и на каждое нажатие гоняет LIKE '%а%' по всем таблицам имён. Трёх знаков
// было бы много — отрезало бы реальные запросы: анализы CK, LH, T3, T4
// и двузначные коды FZOCG (10, 20, 30…), по которым поиск ищет намеренно.
const MIN_QUERY_LENGTH = 2;

const canSearch = (value: string) => value.trim().length >= MIN_QUERY_LENGTH;

watch(searchQuery, (value) => {
	if (canSearch(value)) {
		isOpen.value = true;
		searchPerformed.value = false;
		debouncedSearch(value);
	} else {
		// Отменяем отложенный вызов от прошлого, более длинного запроса: без
		// этого стирание «ab» → «a» сбрасывает результаты, а через мгновение
		// прилетает ответ по «ab» и наполняет закрытый уже список.
		debouncedSearch.cancel();
		isOpen.value = false;
		searchPerformed.value = false;
		resetResults();
	}
});

// Проверка есть ли результаты
const hasResults = computed(
	() =>
		allFilteredSpecialties.value.length > 0 ||
		allFilteredClinics.value.length > 0 ||
		allFilteredArticles.value.length > 0 ||
		doctors.value.length > 0 ||
		medicalServices.value.length > 0 ||
		medicines.value.length > 0 ||
		labTests.value.length > 0,
);

// ---------- Подписи строк ----------

const idsToArray = (ids: string | null | undefined): number[] =>
	(ids || '')
		.split(',')
		.map(Number)
		.filter((id) => Number.isInteger(id) && id > 0);

const joinLabels = (labels: string[], limit: number): string | null =>
	labels.slice(0, limit).join(', ') || null;

const doctorSpecialties = (doctor: DoctorData): string | null =>
	joinLabels(
		idsToArray(doctor.specialtyIds).map((id) => t(`specialty_${id}`)),
		SHOWN_CATEGORIES,
	);

// Клиники врача и их города — так видно, куда идти на приём
const doctorPlaces = (doctor: DoctorData): string[] => {
	const clinics = clinicsStore
		.getClinicsByIds(doctor.clinicIds)
		.slice(0, SHOWN_DOCTOR_CLINICS);
	const cities = [
		...new Set(clinics.map((clinic) => t(`city_${clinic.cityId}`))),
	];
	return [
		...clinics.map((clinic) => getLocalizedName(clinic, locale.value)),
		...cities,
	];
};

const clinicById = (id: number) =>
	clinicsStore.clinics.find((clinic) => clinic.id === id);

const ratingLabel = (rating?: {
	averageRating: number | null;
	totalReviews: number;
}): string | null =>
	rating?.averageRating != null ? n(rating.averageRating) : null;

// Минимальная цена по клиникам — в карточке услуги/анализа это ориентир «от»
const priceFromLabel = (prices?: ClinicPrice[]): string | null => {
	const values = (prices || [])
		.map((price) => price.priceMin ?? price.price)
		.filter((value): value is number => value != null);
	if (!values.length) return null;
	return t('PriceFrom', {
		price: n(Math.min(...values), { style: 'currency', currency: 'EUR' }),
	});
};

const clinicsCountLabel = (count?: number): string | null =>
	count
		? `${count} ${selectForm(t('ClinicsUnit'), locale.value, count)}`
		: null;

const serviceCategories = (item: ClinicServiceWithPrices): string | null =>
	joinLabels(
		(item.categoryIds || []).map((id) => t(`medical_service_category_${id}`)),
		SHOWN_CATEGORIES,
	);

const labTestCategories = (item: LabTestItem): string | null =>
	joinLabels(
		(item.categoryIds || []).map((id) => t(`lab_test_category_${id}`)),
		SHOWN_CATEGORIES,
	);

// Синонимы анализа приходят целиком (на текущей локали) — совпавший ищем сами;
// у услуг это делает бэкенд (matchedSynonyms), там локаль синонима любая.
const matchedSynonym = (
	item: { matchedSynonyms?: string[]; synonyms?: string[] },
	query: string,
): string | null => {
	if (item.matchedSynonyms?.length) return item.matchedSynonyms[0];
	const normalizedQuery = normalizeForSearch(query);
	return (
		(item.synonyms || []).find((synonym) =>
			normalizeForSearch(synonym).includes(normalizedQuery),
		) || null
	);
};

const medicineHint = (group: MedicineGroup) =>
	medicineMatchHint(group.primary.match, t);

// Форма/дозировка/упаковка — когда у названия единственная запись реестра;
// у группы различия выносятся в ярлыки-варианты под строкой.
const medicineMeta = (group: MedicineGroup): (string | null)[] => {
	if (group.variants.length > 1) {
		return [group.sharedForm];
	}
	const item = group.primary;
	return [
		item.pharmaForm,
		item.strength ? localizeStrength(item.strength, t) : null,
		buildPackagingLabel(item, t, locale.value, false) || null,
	];
};

const shownVariants = (group: MedicineGroup) =>
	group.variants.length > 1 ? group.variants.slice(0, SHOWN_VARIANTS) : [];

// ---------- Ссылки ----------

function getSpecialtyLink(specialtyId: number) {
	return {
		name: 'doctors',
		query: { specialtyIds: specialtyId, ...getRegionalQuery(locale.value) },
	};
}

function getDoctorLink(slug: string) {
	return {
		name: 'doctors-doctorSlug',
		params: { doctorSlug: slug },
		query: getRegionalQuery(locale.value),
	};
}

function getClinicLink(slug: string) {
	return {
		name: 'clinics-clinicSlug',
		params: { clinicSlug: slug },
		query: getRegionalQuery(locale.value),
	};
}

function getMedicalServiceLink(slug: string) {
	return {
		name: 'services-serviceSlug',
		params: { serviceSlug: slug },
		query: getRegionalQuery(locale.value),
	};
}

function getMedicineLink(slug: string) {
	return {
		name: 'medicines-medicineSlug',
		params: { medicineSlug: slug },
		query: getRegionalQuery(locale.value),
	};
}

// Все фасовки бренда живут на вкладке «Другие дозировки» карточки препарата —
// отдельной зонтичной страницы для этого не нужно.
function getMedicineVariantsLink(slug: string) {
	return {
		name: 'medicines-medicineSlug',
		params: { medicineSlug: slug },
		query: { tab: 'dosages', ...getRegionalQuery(locale.value) },
	};
}

function getLabTestLink(slug: string) {
	return {
		name: 'labtests-labTestSlug',
		params: { labTestSlug: slug },
		query: getRegionalQuery(locale.value),
	};
}

// Статьи — статичные страницы, у каждой свой файл в pages/articles,
// поэтому ссылка по пути, а не по имени роута
function getArticleLink(slug: string) {
	return {
		path: `/articles/${slug}`,
		query: getRegionalQuery(locale.value),
	};
}

// Ссылки на страницы списков с фильтром name (для кнопки «ещё»)
const listLink = (name: string) => ({
	name,
	query: { name: currentQuery.value, ...getRegionalQuery(locale.value) },
});

// Закрытие при клике вне компонента
function handleClickOutside(event: MouseEvent) {
	const target = event.target as HTMLElement;
	if (!target.closest('.global-search')) {
		isOpen.value = false;
	}
}

function handleResultClick() {
	isOpen.value = false;
	searchQuery.value = '';
}

onMounted(() => {
	document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
	document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
	<div class="global-search">
		<div class="global-search__input-wrapper">
			<IconSearch class="global-search__icon" :size="22" color="#94a3b8" />
			<input
				ref="inputRef"
				v-model="searchQuery"
				type="text"
				class="global-search__input"
				:placeholder="t('SearchPlaceholder')"
				@focus="canSearch(searchQuery) && (isOpen = true)"
			/>
			<div v-if="isLoading" class="global-search__spinner" />
		</div>

		<Transition name="dropdown">
			<div
				v-if="isOpen && (hasResults || isLoading || searchPerformed)"
				class="global-search__dropdown"
			>
				<div v-if="isLoading" class="global-search__loading">
					{{ t('Searching') }}
				</div>

				<template v-else>
					<!-- Специальности -->
					<SearchResultGroup
						v-if="shownSpecialties.length"
						:title="t('Specialties')"
					>
						<template #icon><IconDoctor :size="16" /></template>
						<SearchResultRow
							v-for="specialty in shownSpecialties"
							:key="`specialty-${specialty.id}`"
							:to="getSpecialtyLink(specialty.id)"
							:title="specialty.name"
							:query="currentQuery"
							:meta="[t('SpecialtyDoctors')]"
							@navigate="handleResultClick"
						>
							<template #icon><IconDoctor :size="20" /></template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Врачи -->
					<SearchResultGroup
						v-if="shownDoctors.length"
						:title="t('Doctors')"
						:moreTo="
							doctorsTotal > shownDoctors.length ? listLink('doctors') : null
						"
						:moreLabel="t('MoreDoctors', { count: doctorsTotal })"
						@navigate="handleResultClick"
					>
						<template #icon><IconDoctor :size="16" /></template>
						<SearchResultRow
							v-for="doctor in shownDoctors"
							:key="`doctor-${doctor.id}`"
							:to="getDoctorLink(doctor.slug)"
							:title="doctor.name"
							:query="currentQuery"
							:subtitle="doctorSpecialties(doctor)"
							:meta="doctorPlaces(doctor)"
							@navigate="handleResultClick"
						>
							<template #icon>
								<img
									v-if="doctor.photoUrl"
									:src="doctor.photoUrl"
									:alt="doctor.name"
									class="global-search__photo"
									loading="lazy"
								/>
								<IconDoctor v-else :size="20" />
							</template>
							<template v-if="ratingLabel(doctor.rating)" #aside>
								<span class="global-search__rating">
									<IconStar :size="14" />
									{{ ratingLabel(doctor.rating) }}
								</span>
							</template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Клиники -->
					<SearchResultGroup
						v-if="shownClinics.length"
						:title="t('Clinics')"
						:moreTo="
							allFilteredClinics.length > shownClinics.length
								? listLink('clinics')
								: null
						"
						:moreLabel="t('MoreClinics', { count: allFilteredClinics.length })"
						@navigate="handleResultClick"
					>
						<template #icon><IconClinic :size="16" /></template>
						<SearchResultRow
							v-for="clinic in shownClinics"
							:key="`clinic-${clinic.id}`"
							:to="getClinicLink(clinic.slug)"
							:title="clinic.name"
							:query="currentQuery"
							highlightSubtitle
							:subtitle="
								clinicById(clinic.id)?.localName !== clinic.name
									? clinicById(clinic.id)?.localName
									: null
							"
							:meta="[
								clinicById(clinic.id)?.cityId
									? t(`city_${clinicById(clinic.id)!.cityId}`)
									: null,
								clinicById(clinic.id)?.address,
							]"
							@navigate="handleResultClick"
						>
							<template #icon><IconClinic :size="20" /></template>
							<template
								v-if="ratingLabel(clinicById(clinic.id)?.rating)"
								#aside
							>
								<span class="global-search__rating">
									<IconStar :size="14" />
									{{ ratingLabel(clinicById(clinic.id)?.rating) }}
								</span>
							</template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Медицинские услуги -->
					<SearchResultGroup
						v-if="shownMedicalServices.length"
						:title="t('MedicalServices')"
						:moreTo="
							medicalServicesTotal > shownMedicalServices.length
								? listLink('services')
								: null
						"
						:moreLabel="
							t('MoreMedicalServices', { count: medicalServicesTotal })
						"
						@navigate="handleResultClick"
					>
						<template #icon><IconMedicalService :size="16" /></template>
						<SearchResultRow
							v-for="service in shownMedicalServices"
							:key="`service-${service.id}`"
							:to="getMedicalServiceLink(service.slug)"
							:title="service.name"
							:query="currentQuery"
							:subtitle="serviceCategories(service)"
							:meta="[clinicsCountLabel(service.clinicCount)]"
							:hintLabel="t('MatchOtherName')"
							:hintValue="matchedSynonym(service, currentQuery)"
							@navigate="handleResultClick"
						>
							<template #icon><IconMedicalService :size="20" /></template>
							<template v-if="priceFromLabel(service.clinicPrices)" #aside>
								{{ priceFromLabel(service.clinicPrices) }}
							</template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Лекарства -->
					<SearchResultGroup
						v-if="shownMedicineGroups.length"
						:title="t('Medications')"
						:moreTo="
							medicinesTotal > shownMedicineItems ? listLink('medicines') : null
						"
						:moreLabel="t('MoreMedications', { count: medicinesTotal })"
						@navigate="handleResultClick"
					>
						<template #icon><IconMedication :size="16" /></template>
						<SearchResultRow
							v-for="group in shownMedicineGroups"
							:key="`medicine-${group.key}`"
							:to="getMedicineLink(group.primary.slug)"
							:title="group.name"
							:query="currentQuery"
							highlightSubtitle
							:subtitle="group.primary.substances"
							:meta="medicineMeta(group)"
							:metaSecondary="[group.sharedManufacturer, group.sharedCountry]"
							:hintLabel="medicineHint(group)?.label"
							:hintValue="medicineHint(group)?.value"
							@navigate="handleResultClick"
						>
							<template #icon>
								<MedicineFormIcon
									:formId="group.primary.pharmaFormId"
									:size="20"
								/>
							</template>
							<template #badge>
								<MedicineBadge
									:dispensingModeId="group.sharedDispensingModeId"
								/>
							</template>
							<template v-if="shownVariants(group).length" #footer>
								<NuxtLink
									v-for="variant in shownVariants(group)"
									:key="`variant-${variant.item.id}`"
									:to="getMedicineLink(variant.item.slug)"
									class="global-search__variant"
									@click="handleResultClick"
								>
									<MedicineFormIcon
										v-if="!group.sharedForm"
										:formId="variant.item.pharmaFormId"
										:size="14"
									/>
									{{ variant.label }}
								</NuxtLink>
								<NuxtLink
									v-if="group.variants.length > shownVariants(group).length"
									:to="getMedicineVariantsLink(group.primary.slug)"
									class="global-search__variant global-search__variant--all"
									@click="handleResultClick"
								>
									{{ t('AllVariants', { count: group.variants.length }) }}
								</NuxtLink>
							</template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Анализы -->
					<SearchResultGroup
						v-if="shownLabTests.length"
						:title="t('LabTests')"
						:moreTo="
							labTestsTotal > shownLabTests.length ? listLink('labtests') : null
						"
						:moreLabel="t('MoreLabTests', { count: labTestsTotal })"
						@navigate="handleResultClick"
					>
						<template #icon><IconLabTest :size="16" /></template>
						<SearchResultRow
							v-for="labTest in shownLabTests"
							:key="`labtest-${labTest.id}`"
							:to="getLabTestLink(labTest.slug)"
							:title="labTest.name"
							:query="currentQuery"
							:subtitle="labTestCategories(labTest)"
							:meta="[clinicsCountLabel(labTest.clinicCount)]"
							:hintLabel="t('MatchOtherName')"
							:hintValue="matchedSynonym(labTest, currentQuery)"
							@navigate="handleResultClick"
						>
							<template #icon><IconLabTest :size="20" /></template>
							<template v-if="priceFromLabel(labTest.clinicPrices)" #aside>
								{{ priceFromLabel(labTest.clinicPrices) }}
							</template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Статьи -->
					<SearchResultGroup
						v-if="shownArticles.length"
						:title="t('Articles')"
						:moreTo="
							allFilteredArticles.length > shownArticles.length
								? { path: '/articles' }
								: null
						"
						:moreLabel="
							t('MoreArticles', { count: allFilteredArticles.length })
						"
						@navigate="handleResultClick"
					>
						<template #icon><IconLightbulb :size="16" /></template>
						<SearchResultRow
							v-for="article in shownArticles"
							:key="`article-${article.slug}`"
							:to="getArticleLink(article.slug)"
							:title="article.label"
							:query="currentQuery"
							:hintLabel="t('MatchMentioned')"
							:hintValue="article.keyword"
							@navigate="handleResultClick"
						>
							<template #icon><IconLightbulb :size="20" /></template>
						</SearchResultRow>
					</SearchResultGroup>

					<!-- Нет результатов -->
					<div
						v-if="!hasResults && !isLoading"
						class="global-search__no-results"
					>
						{{ t('NoResults') }}
					</div>
				</template>
			</div>
		</Transition>
	</div>
</template>

<style lang="less" scoped>
.global-search {
	position: relative;
	width: 100%;
	max-width: 600px;
	margin: 0 auto;
	text-align: left;

	&__input-wrapper {
		position: relative;
		display: flex;
		align-items: center;
	}

	&__icon {
		position: absolute;
		left: var(--spacing-lg);
		width: 22px;
		height: 22px;
		pointer-events: none;
	}

	&__input {
		width: 100%;
		height: 56px;
		padding: var(--spacing-lg) 48px var(--spacing-lg) 52px;
		font-size: var(--font-size-2xl);
		line-height: 1.5;
		border: var(--border-width-thin) solid var(--color-border-light);
		border-radius: var(--border-radius-xl);
		background: var(--color-bg-primary);
		box-shadow: var(--shadow-sm);
		transition: var(--transition-base);
		outline: none;
		box-sizing: border-box;

		&::placeholder {
			color: var(--color-text-placeholder);
		}

		&:focus {
			border-color: var(--color-border-accent);
			box-shadow: var(--shadow-hover);
		}
	}

	&__spinner {
		position: absolute;
		right: var(--spacing-lg);
		width: 22px;
		height: 22px;
		border: 2px solid var(--color-bg-muted);
		border-top-color: var(--color-primary);
		border-radius: var(--border-radius-full);
		animation: spin 0.8s linear infinite;
	}

	&__dropdown {
		position: absolute;
		top: calc(100% + var(--spacing-sm));
		left: 0;
		right: 0;
		background: var(--color-bg-primary);
		border-radius: var(--border-radius-xl);
		border: var(--border-width-thin) solid var(--color-border-light);
		box-shadow: var(--shadow-xl);
		// Карточки многострочные: 400px хватало на 6 однострочников, а теперь
		// не помещалась и одна группа целиком
		max-height: min(70vh, 620px);
		overflow: hidden;
		overflow-y: auto;
		z-index: var(--z-dropdown);
		padding-bottom: var(--spacing-sm);
		overscroll-behavior: contain;

		// Кастомный скроллбар
		&::-webkit-scrollbar {
			width: 6px;
		}

		&::-webkit-scrollbar-track {
			background: transparent;
			margin: var(--border-radius-xl) 0;
		}

		&::-webkit-scrollbar-thumb {
			background: var(--color-bg-muted);
			border-radius: 3px;

			&:hover {
				background: var(--color-border-primary);
			}
		}
	}

	&__loading,
	&__no-results {
		padding: var(--spacing-xl);
		text-align: center;
		color: var(--color-text-muted);
		font-size: var(--font-size-md);
	}

	&__photo {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}

	&__rating {
		display: inline-flex;
		align-items: center;
		gap: var(--spacing-xs);
		color: var(--color-rating);
	}

	// Ярлык варианта препарата: своя ссылка на фасовку под строкой бренда
	&__variant {
		display: inline-flex;
		align-items: center;
		gap: var(--spacing-xs);
		padding: 2px var(--spacing-sm);
		border: var(--border-width-thin) solid var(--color-border-secondary);
		// Не --border-radius-full: он равен 50%, и на широком ярлыке процент
		// даёт эллипс, а не пилюлю
		border-radius: var(--border-radius-md);
		font-size: var(--font-size-xs);
		color: var(--color-text-secondary);
		text-decoration: none;
		background: var(--color-bg-primary);
		transition: var(--transition-fast);

		&:hover {
			border-color: var(--color-primary);
			color: var(--color-primary);
		}

		&--all {
			color: var(--color-primary);
			border-style: dashed;
		}
	}
}

// Анимация dropdown
.dropdown-enter-active,
.dropdown-leave-active {
	transition: var(--transition-base);
}

.dropdown-enter-from,
.dropdown-leave-to {
	opacity: 0;
	transform: translateY(-8px);
}

@keyframes spin {
	to {
		transform: rotate(360deg);
	}
}

// Responsive - tablets
@media (max-width: 768px) {
	.global-search {
		max-width: 480px;
	}
}

// Responsive - mobile
@media (max-width: 640px) {
	.global-search {
		max-width: 100%;

		&__input {
			height: 48px;
			padding: var(--spacing-md) 40px var(--spacing-md) 44px;
			font-size: var(--font-size-md);
			border-radius: var(--border-radius-xl);
		}

		&__dropdown {
			max-height: 70vh;
			border-radius: var(--border-radius-xl);
		}
	}
}

// Responsive - small mobile
@media (max-width: 375px) {
	.global-search {
		&__icon {
			left: var(--spacing-md);
		}

		&__input {
			height: 46px;
			padding: var(--spacing-md) 36px var(--spacing-md) 40px;
			font-size: var(--font-size-base);
		}

		&__spinner {
			right: var(--spacing-md);
		}
	}
}
</style>
