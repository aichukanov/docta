<script setup lang="ts">
import { debounce } from 'lodash-es';
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';
import { getRegionalQuery } from '~/common/url-utils';
import type { DoctorData } from '~/interfaces/doctor';
import type { MedicationData } from '~/interfaces/medication';
import type { LabTestData } from '~/interfaces/lab-test';

const globalSearchI18n = {
	messages: {
		en: {
			SearchPlaceholder: 'Search doctors, clinics, medications, tests',
			Searching: 'Searching...',
			NoResults: 'No results found',
			Specialties: 'Specialties',
			Doctors: 'Doctors',
			Clinics: 'Clinics',
			Medications: 'Medications',
			LabTests: 'Lab Tests',
			MoreDoctors: 'More doctors ({count})',
			MoreClinics: 'More clinics ({count})',
			MoreMedications: 'More medications ({count})',
			MoreLabTests: 'More tests ({count})',
		},
		ru: {
			SearchPlaceholder: 'Поиск врачей, клиник, лекарств, анализов',
			Searching: 'Поиск...',
			NoResults: 'Ничего не найдено',
			Specialties: 'Специальности',
			Doctors: 'Врачи',
			Clinics: 'Клиники',
			Medications: 'Лекарства',
			LabTests: 'Анализы',
			MoreDoctors: 'Ещё врачи ({count})',
			MoreClinics: 'Ещё клиники ({count})',
			MoreMedications: 'Ещё лекарства ({count})',
			MoreLabTests: 'Ещё анализы ({count})',
		},
		sr: {
			SearchPlaceholder: 'Pretraga lekara, klinika, lekova, analiza',
			Searching: 'Pretraga...',
			NoResults: 'Nema rezultata',
			Specialties: 'Specijalnosti',
			Doctors: 'Lekari',
			Clinics: 'Klinike',
			Medications: 'Lekovi',
			LabTests: 'Analize',
			MoreDoctors: 'Još lekara ({count})',
			MoreClinics: 'Još klinika ({count})',
			MoreMedications: 'Još lekova ({count})',
			MoreLabTests: 'Još analiza ({count})',
		},
		de: {
			SearchPlaceholder: 'Suche nach Ärzten, Kliniken, Medikamenten, Tests',
			Searching: 'Suche...',
			NoResults: 'Keine Ergebnisse gefunden',
			Specialties: 'Fachgebiete',
			Doctors: 'Ärzte',
			Clinics: 'Kliniken',
			Medications: 'Medikamente',
			LabTests: 'Labortests',
			MoreDoctors: 'Mehr Ärzte ({count})',
			MoreClinics: 'Mehr Kliniken ({count})',
			MoreMedications: 'Mehr Medikamente ({count})',
			MoreLabTests: 'Mehr Tests ({count})',
		},
		tr: {
			SearchPlaceholder: 'Doktor, klinik, ilaç, test ara',
			Searching: 'Aranıyor...',
			NoResults: 'Sonuç bulunamadı',
			Specialties: 'Uzmanlıklar',
			Doctors: 'Doktorlar',
			Clinics: 'Klinikler',
			Medications: 'İlaçlar',
			LabTests: 'Laboratuvar Testleri',
			MoreDoctors: 'Daha fazla doktor ({count})',
			MoreClinics: 'Daha fazla klinik ({count})',
			MoreMedications: 'Daha fazla ilaç ({count})',
			MoreLabTests: 'Daha fazla test ({count})',
		},
	},
};

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([specialtyI18n, globalSearchI18n]),
});

const searchQuery = ref('');
const isOpen = ref(false);
const isLoading = ref(false);
const searchPerformed = ref(false);
const inputRef = ref<HTMLInputElement | null>(null);

// Store клиник (загружается один раз)
const clinicsStore = useClinicsStore();
clinicsStore.fetchClinics();

// Полные результаты поиска
const allFilteredSpecialties = ref<{ id: number; name: string }[]>([]);
const allDoctors = ref<DoctorData[]>([]);
const allFilteredClinics = ref<{ id: number; name: string }[]>([]);
const allMedications = ref<MedicationData[]>([]);
const allLabTests = ref<LabTestData[]>([]);

// Текущий поисковый запрос для ссылок
const currentQuery = ref('');

// Отображаемые результаты (первые 5)
const shownSpecialties = computed(() =>
	allFilteredSpecialties.value.slice(0, 5),
);
const shownDoctors = computed(() =>
	allDoctors.value.slice(0, 5).map((d) => ({
		id: d.id,
		name: d[`name_${locale.value}`] || d.name,
	})),
);
const shownClinics = computed(() => allFilteredClinics.value.slice(0, 5));
const shownMedications = computed(() =>
	allMedications.value.slice(0, 5).map((m) => ({ id: m.id, name: m.name })),
);
const shownLabTests = computed(() =>
	allLabTests.value.slice(0, 5).map((lt) => ({ id: lt.id, name: lt.name })),
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
	const lowerQuery = query.toLowerCase();
	allFilteredSpecialties.value = allSpecialties.value.filter((s) =>
		s.name.toLowerCase().includes(lowerQuery),
	);
}

// Фильтрация клиник из store (без запроса на сервер)
function filterClinics(query: string) {
	if (!query.trim()) {
		allFilteredClinics.value = [];
		return;
	}
	const lowerQuery = query.toLowerCase();
	allFilteredClinics.value = clinicsStore.clinics
		.filter((c) => c.name.toLowerCase().includes(lowerQuery))
		.map((c) => ({ id: c.id, name: c.name }));
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
		allDoctors.value = [];
		allMedications.value = [];
		allLabTests.value = [];
		return;
	}

	// Создаём новый AbortController
	abortController = new AbortController();
	const signal = abortController.signal;

	isLoading.value = true;
	currentQuery.value = query;

	try {
		const [doctorsRes, medicationsRes, labTestsRes] = await Promise.all([
			$fetch('/api/doctors/list', {
				method: 'POST',
				body: { name: query },
				signal,
			}),
			$fetch('/api/medications/list', {
				method: 'POST',
				body: { name: query },
				signal,
			}),
			$fetch('/api/labtests/list', {
				method: 'POST',
				body: { name: query, locale: locale.value },
				signal,
			}),
		]);

		// Проверяем что запрос не был отменён и query актуален
		if (signal.aborted || query !== currentQuery.value) {
			return;
		}

		allDoctors.value = doctorsRes?.doctors || [];
		allMedications.value = medicationsRes?.items || [];
		allLabTests.value = labTestsRes?.items || [];
	} catch (error: any) {
		// Игнорируем ошибки отмены
		if (error?.name === 'AbortError') {
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
	searchEntities(query);
}, 300);

watch(searchQuery, (value) => {
	if (value.trim()) {
		isOpen.value = true;
		searchPerformed.value = false;
		debouncedSearch(value);
	} else {
		isOpen.value = false;
		searchPerformed.value = false;
		allFilteredSpecialties.value = [];
		allDoctors.value = [];
		allFilteredClinics.value = [];
		allMedications.value = [];
		allLabTests.value = [];
	}
});

// Проверка есть ли результаты
const hasResults = computed(() => {
	return (
		allFilteredSpecialties.value.length > 0 ||
		allDoctors.value.length > 0 ||
		allFilteredClinics.value.length > 0 ||
		allMedications.value.length > 0 ||
		allLabTests.value.length > 0
	);
});

// Ссылки на страницы деталей
function getSpecialtyLink(specialtyId: number) {
	return {
		name: 'doctors',
		query: { ...getRegionalQuery(locale.value), specialty: specialtyId },
	};
}

function getDoctorLink(doctorId: number) {
	return {
		name: 'doctors-doctorId',
		params: { doctorId },
		query: getRegionalQuery(locale.value),
	};
}

function getClinicLink(clinicId: number) {
	return {
		name: 'clinics-clinicId',
		params: { clinicId },
		query: getRegionalQuery(locale.value),
	};
}

function getMedicationLink(medicationId: number) {
	return {
		name: 'medications-medicationId',
		params: { medicationId },
		query: getRegionalQuery(locale.value),
	};
}

function getLabTestLink(labTestId: number) {
	return {
		name: 'labtests-labTestId',
		params: { labTestId },
		query: getRegionalQuery(locale.value),
	};
}

// Ссылки на страницы списков с фильтром name (для кнопки "ещё")
function getDoctorsListLink() {
	return {
		name: 'doctors',
		query: { ...getRegionalQuery(locale.value), name: currentQuery.value },
	};
}

function getClinicsListLink() {
	return {
		name: 'clinics',
		query: { ...getRegionalQuery(locale.value), name: currentQuery.value },
	};
}

function getMedicationsListLink() {
	return {
		name: 'medications',
		query: { ...getRegionalQuery(locale.value), name: currentQuery.value },
	};
}

function getLabTestsListLink() {
	return {
		name: 'labtests',
		query: { ...getRegionalQuery(locale.value), name: currentQuery.value },
	};
}

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
				@focus="searchQuery.trim() && (isOpen = true)"
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
					<div v-if="shownSpecialties.length > 0" class="global-search__group">
						<div class="global-search__group-title">
							<IconDoctor :size="16" />
							{{ t('Specialties') }}
						</div>
						<NuxtLink
							v-for="specialty in shownSpecialties"
							:key="`specialty-${specialty.id}`"
							:to="getSpecialtyLink(specialty.id)"
							class="global-search__item"
							@click="handleResultClick"
						>
							{{ specialty.name }}
						</NuxtLink>
					</div>

					<!-- Врачи -->
					<div v-if="shownDoctors.length > 0" class="global-search__group">
						<div class="global-search__group-title">
							<IconDoctor :size="16" />
							{{ t('Doctors') }}
						</div>
						<NuxtLink
							v-for="doctor in shownDoctors"
							:key="`doctor-${doctor.id}`"
							:to="getDoctorLink(doctor.id)"
							class="global-search__item"
							@click="handleResultClick"
						>
							{{ doctor.name }}
						</NuxtLink>
						<NuxtLink
							v-if="allDoctors.length > 5"
							:to="getDoctorsListLink()"
							class="global-search__more"
							@click="handleResultClick"
						>
							{{ t('MoreDoctors', { count: allDoctors.length }) }}
						</NuxtLink>
					</div>

					<!-- Клиники -->
					<div v-if="shownClinics.length > 0" class="global-search__group">
						<div class="global-search__group-title">
							<IconClinic :size="16" />
							{{ t('Clinics') }}
						</div>
						<NuxtLink
							v-for="clinic in shownClinics"
							:key="`clinic-${clinic.id}`"
							:to="getClinicLink(clinic.id)"
							class="global-search__item"
							@click="handleResultClick"
						>
							{{ clinic.name }}
						</NuxtLink>
						<NuxtLink
							v-if="allFilteredClinics.length > 5"
							:to="getClinicsListLink()"
							class="global-search__more"
							@click="handleResultClick"
						>
							{{ t('MoreClinics', { count: allFilteredClinics.length }) }}
						</NuxtLink>
					</div>

					<!-- Лекарства -->
					<div v-if="shownMedications.length > 0" class="global-search__group">
						<div class="global-search__group-title">
							<IconMedication :size="16" />
							{{ t('Medications') }}
						</div>
						<NuxtLink
							v-for="medication in shownMedications"
							:key="`medication-${medication.id}`"
							:to="getMedicationLink(medication.id)"
							class="global-search__item"
							@click="handleResultClick"
						>
							{{ medication.name }}
						</NuxtLink>
						<NuxtLink
							v-if="allMedications.length > 5"
							:to="getMedicationsListLink()"
							class="global-search__more"
							@click="handleResultClick"
						>
							{{ t('MoreMedications', { count: allMedications.length }) }}
						</NuxtLink>
					</div>

					<!-- Анализы -->
					<div v-if="shownLabTests.length > 0" class="global-search__group">
						<div class="global-search__group-title">
							<IconLabTest :size="16" />
							{{ t('LabTests') }}
						</div>
						<NuxtLink
							v-for="labTest in shownLabTests"
							:key="`labtest-${labTest.id}`"
							:to="getLabTestLink(labTest.id)"
							class="global-search__item"
							@click="handleResultClick"
						>
							{{ labTest.name }}
						</NuxtLink>
						<NuxtLink
							v-if="allLabTests.length > 5"
							:to="getLabTestsListLink()"
							class="global-search__more"
							@click="handleResultClick"
						>
							{{ t('MoreLabTests', { count: allLabTests.length }) }}
						</NuxtLink>
					</div>

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
@import url('~/assets/css/vars.less');

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
			color: var(--color-text-light);
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
		max-height: 400px;
		overflow: hidden;
		overflow-y: auto;
		z-index: var(--z-dropdown);

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

	&__group {
		border-bottom: var(--border-width-thin) solid var(--color-border-light);

		&:last-child {
			border-bottom: none;
		}
	}

	&__group-title {
		display: flex;
		align-items: center;
		gap: var(--spacing-sm);
		padding: var(--spacing-md) var(--spacing-lg) var(--spacing-sm);
		font-size: var(--font-size-xs);
		font-weight: var(--font-weight-semibold);
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--color-text-muted);
	}

	&__item {
		display: block;
		padding: var(--spacing-sm) var(--spacing-lg) var(--spacing-sm) 40px;
		color: var(--color-text-primary);
		text-decoration: none;
		font-size: var(--font-size-md);
		transition: var(--transition-fast);

		&:hover {
			background: var(--color-bg-secondary);
		}
	}

	&__more {
		display: block;
		padding: var(--spacing-sm) var(--spacing-lg) var(--spacing-sm) 40px;
		color: var(--color-primary);
		text-decoration: none;
		font-size: var(--font-size-sm);
		transition: var(--transition-fast);

		&:hover {
			background: var(--color-bg-secondary);
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
			max-height: 60vh;
			border-radius: var(--border-radius-xl);
		}

		&__group-title {
			padding: var(--spacing-sm) var(--spacing-md) var(--spacing-xs);
			font-size: var(--font-size-xs);
		}

		&__item {
			padding: var(--spacing-sm) var(--spacing-md) var(--spacing-sm) 36px;
			font-size: var(--font-size-base);
		}

		&__more {
			padding: var(--spacing-sm) var(--spacing-md) var(--spacing-sm) 36px;
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
