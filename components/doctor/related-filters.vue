<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import languageI18n from '~/i18n/language';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /doctors. Источник комбинаций — тот же запрос, что и у
// sitemap-фильтра (только реально существующие пары, см.
// docs/audit/seo-2026-07.md, пункт 1b), поэтому ни одна ссылка отсюда не ведёт
// на пустой листинг с `noindex`.
//
// Три режима, в зависимости от того, что выбрано:
// 1. Ничего не выбрано (голый /doctors) — топ специальностей. Раньше блок здесь
//    молчал, и это была дыра: панель фильтров — чекбоксы, а не ссылки, то есть
//    в фасетную сеть неоткуда было войти. 2057 фасетных URL из sitemap не имели
//    ни одной входящей ссылки, весь внутренний вес уходил в футер.
// 2. Выбрана ровно одна специальность — она же в других городах и она же по
//    языкам приёма. Языки в sitemap есть только в паре со специальностью, и до
//    появления этой группы все 127 таких URL были известны краулеру ровно из
//    одного места — самого файла sitemap.
// 3. Выбран ровно один город — другие специальности в этом городе.
// Режимы 2 и 3 совмещаются, когда выбрано и то и другое.
const props = defineProps<{
	specialtyIds: number[];
	cityIds: number[];
}>();

// Сколько ссылок показываем на голом листинге. Полный список специальностей уже
// стоит рядом в панели фильтров — выкладывать все 77 значками значило бы
// продублировать её ковром ссылок. Хаб — это короткий срез «самое ходовое»,
// а не второй фильтр; в фасетную сеть достаточно одной двери, дальше работают
// режимы 2 и 3.
const HUB_LINK_LIMIT = 12;

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, languageI18n, specialtyI18n]),
});

const { data } = await useFetch('/api/doctors/specialty-city-combinations', {
	key: 'doctors-specialty-city-combinations',
});

const combinations = computed(
	() => data.value?.specialtyCityCombinations ?? [],
);

const languageCombinations = computed(
	() => data.value?.specialtyLanguageCombinations ?? [],
);

const selectedSpecialtyId = computed(() =>
	props.specialtyIds.length === 1 ? props.specialtyIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
);

// Язык пропсом не приходит — хаб получает только специальность и город.
// Берём его из того же стора фильтров, из которого страница берёт остальные:
// без этого на `/doctors?specialtyIds=X&languageIds=L` группа языков дала бы
// ссылку на саму себя, тогда как соседние группы выбранное значение исключают.
const filtersStore = useFiltersStore();
const selectedLanguageId = computed(() => {
	const languageIds = filtersStore.namespaces.doctors.languageIds;
	return languageIds.length === 1 ? languageIds[0] : null;
});

// Голый листинг — ни специальности, ни города. Другие фильтры (язык, поиск по
// имени) на выбор среза не влияют: ссылки всё равно ведут на чистые фасеты.
const isUnfiltered = computed(
	() => props.specialtyIds.length === 0 && props.cityIds.length === 0,
);

/**
 * Топ специальностей для голого листинга.
 *
 * Ранжируем по числу городов, где специальность вообще представлена. Счётчика
 * врачей эндпоинт не отдаёт, а география — честный прокси востребованности:
 * специальность, которая есть по всей стране, полезна читателю из любого
 * города, и её фасет заведомо не тонкая страница. При равенстве — меньший id
 * enum'а: там перечислены основные специальности, редкие добавлялись позже.
 */
const specialtyCityCount = computed(() => {
	const counts = new Map<number, number>();
	for (const combo of combinations.value) {
		counts.set(combo.specialtyId, (counts.get(combo.specialtyId) ?? 0) + 1);
	}
	return counts;
});

const topSpecialties = computed(() => {
	if (!isUnfiltered.value) return [];
	return [...specialtyCityCount.value.entries()]
		.sort((a, b) => b[1] - a[1] || a[0] - b[0])
		.slice(0, HUB_LINK_LIMIT)
		.map(([specialtyId]) => specialtyId);
});

const otherCitiesForSpecialty = computed(() => {
	if (selectedSpecialtyId.value === null) return [];
	return combinations.value
		.filter((c) => c.specialtyId === selectedSpecialtyId.value)
		.map((c) => c.cityId)
		.filter((cityId) => cityId !== selectedCityId.value);
});

// Языки приёма выбранной специальности. Показываем только при выбранной
// специальности: одиночного `?languageIds=L` в sitemap нет — такой листинг
// повторял бы базовый другими словами, — и ссылаться на него нельзя.
const languagesForSpecialty = computed(() => {
	if (selectedSpecialtyId.value === null) return [];
	return languageCombinations.value
		.filter((c) => c.specialtyId === selectedSpecialtyId.value)
		.map((c) => c.languageId)
		.filter((languageId) => languageId !== selectedLanguageId.value);
});

const otherSpecialtiesForCity = computed(() => {
	if (selectedCityId.value === null) return [];
	return combinations.value
		.filter((c) => c.cityId === selectedCityId.value)
		.map((c) => c.specialtyId)
		.filter((specialtyId) => specialtyId !== selectedSpecialtyId.value);
});

// Ссылка на специальность без города: и человеку — способ расширить поиск на
// всю страну, и краулеру — единственный вход на `?specialtyIds=N` с фасетной
// страницы. Без неё в sitemap оставались бы недостижимы все специальности,
// не попавшие в топ голого листинга.
const specialtyLink = (specialtyId: number) => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: String(specialtyId),
	},
});

const specialtyCityLink = (specialtyId: number, cityId: number) => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: String(specialtyId),
		cityIds: String(cityId),
	},
});

// Язык теряет город намеренно: в sitemap опубликована пара
// «специальность+язык», тройки с городом там нет.
const specialtyLanguageLink = (specialtyId: number, languageId: number) => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: String(specialtyId),
		languageIds: String(languageId),
	},
});

const hasHub = computed(
	() =>
		topSpecialties.value.length > 0 ||
		otherCitiesForSpecialty.value.length > 0 ||
		languagesForSpecialty.value.length > 0 ||
		otherSpecialtiesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="doctors-related-filters">
		<div v-if="topSpecialties.length" class="doctors-related-filters__group">
			<h3 class="doctors-related-filters__title">
				{{ t('PopularSpecialties') }}
			</h3>
			<div class="doctors-related-filters__links">
				<NuxtLink
					v-for="specialtyId in topSpecialties"
					:key="specialtyId"
					:to="specialtyLink(specialtyId)"
				>
					{{ t(`doctors_${specialtyId}`) }}
				</NuxtLink>
			</div>
		</div>

		<div
			v-if="otherCitiesForSpecialty.length"
			class="doctors-related-filters__group"
		>
			<h3 class="doctors-related-filters__title">
				{{ t(`doctors_${selectedSpecialtyId}`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="doctors-related-filters__links">
				<NuxtLink
					v-if="selectedCityId !== null"
					:to="specialtyLink(selectedSpecialtyId!)"
				>
					{{ t('AllCities') }}
				</NuxtLink>
				<NuxtLink
					v-for="cityId in otherCitiesForSpecialty"
					:key="cityId"
					:to="specialtyCityLink(selectedSpecialtyId!, cityId)"
				>
					{{ t(`city_${cityId}_genitive`) }}
				</NuxtLink>
			</div>
		</div>

		<div
			v-if="languagesForSpecialty.length"
			class="doctors-related-filters__group"
		>
			<h3 class="doctors-related-filters__title">
				{{
					t('SpecialtyByLanguage', {
						specialty: t(`doctors_${selectedSpecialtyId}`),
					})
				}}
			</h3>
			<div class="doctors-related-filters__links">
				<NuxtLink
					v-for="languageId in languagesForSpecialty"
					:key="languageId"
					:to="specialtyLanguageLink(selectedSpecialtyId!, languageId)"
				>
					{{ t(`language_${languageId}`) }}
				</NuxtLink>
			</div>
		</div>

		<div
			v-if="otherSpecialtiesForCity.length"
			class="doctors-related-filters__group"
		>
			<h3 class="doctors-related-filters__title">
				{{
					t('OtherSpecialtiesIn', {
						city: t(`city_${selectedCityId}_genitive`),
					})
				}}
			</h3>
			<div class="doctors-related-filters__links">
				<NuxtLink
					v-for="specialtyId in otherSpecialtiesForCity"
					:key="specialtyId"
					:to="specialtyCityLink(specialtyId, selectedCityId!)"
				>
					{{ t(`doctors_${specialtyId}`) }}
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.doctors-related-filters {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xl);
	margin-top: var(--kit-spacing-2xl);
}

.doctors-related-filters__title {
	margin: 0 0 var(--kit-spacing-md);
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-secondary);
}

.doctors-related-filters__links {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-sm);

	a {
		padding: var(--kit-spacing-xs) var(--kit-spacing-md);
		border-radius: var(--kit-border-radius-md);
		background: var(--kit-color-surface-secondary);
		color: var(--kit-color-primary);
		text-decoration: none;
		font-size: var(--kit-font-size-sm);
		transition: background var(--kit-transition-fast);

		&:hover {
			background: var(--kit-color-surface-primary);
			text-decoration: underline;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"InOtherCities": "in other cities",
		"OtherSpecialtiesIn": "Other specialties in {city}",
		"PopularSpecialties": "Popular specialties",
		"SpecialtyByLanguage": "{specialty} by spoken language",
		"AllCities": "In all cities"
	},
	"ru": {
		"InOtherCities": "в других городах",
		"OtherSpecialtiesIn": "Другие специальности в {city}",
		"PopularSpecialties": "Популярные специальности",
		"SpecialtyByLanguage": "{specialty} со знанием языка",
		"AllCities": "Во всех городах"
	},
	"sr": {
		"InOtherCities": "u drugim gradovima",
		"OtherSpecialtiesIn": "Drugi specijalisti u {city}",
		"PopularSpecialties": "Popularne specijalnosti",
		"SpecialtyByLanguage": "{specialty} po jeziku",
		"AllCities": "U svim gradovima"
	},
	"sr-cyrl": {
		"InOtherCities": "у другим градовима",
		"OtherSpecialtiesIn": "Други специјалисти у {city}",
		"PopularSpecialties": "Популарне специјалности",
		"SpecialtyByLanguage": "{specialty} по језику",
		"AllCities": "У свим градовима"
	},
	"de": {
		"InOtherCities": "in anderen Städten",
		"OtherSpecialtiesIn": "Andere Fachärzte in {city}",
		"PopularSpecialties": "Beliebte Fachrichtungen",
		"SpecialtyByLanguage": "{specialty} nach Sprache",
		"AllCities": "In allen Städten"
	},
	"tr": {
		"InOtherCities": "diğer şehirlerde",
		"OtherSpecialtiesIn": "{city} içindeki diğer uzmanlar",
		"PopularSpecialties": "Popüler uzmanlıklar",
		"SpecialtyByLanguage": "{specialty} — konuşulan dile göre",
		"AllCities": "Tüm şehirlerde"
	}
}
</i18n>
