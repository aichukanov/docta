<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import clinicTypeI18n from '~/i18n/clinic-type';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /clinics. Источник комбинаций — тот же запрос и тот же
// порог (SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS), что и у sitemap-фильтра, см.
// docs/audit/seo-2026-07.md, пункт 1b, — поэтому ни одна ссылка отсюда не ведёт
// на тонкую страницу или на листинг с `noindex`.
//
// Три режима, в зависимости от того, что выбрано:
// 1. Ничего не выбрано (голый /clinics) — типы клиник и города. Раньше блок
//    здесь молчал, и в фасетную сеть неоткуда было войти: панель фильтров —
//    чекбоксы, а не ссылки, поэтому фасетные URL из sitemap не имели ни одной
//    входящей ссылки и весь внутренний вес уходил в футер.
// 2. Выбран ровно один тип клиники — он же в других городах.
// 3. Выбран ровно один город — другие типы клиник в этом городе.
// Режимы 2 и 3 совмещаются, когда выбрано и то и другое.
const props = defineProps<{
	clinicTypeIds: number[];
	cityIds: number[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, clinicTypeI18n]),
});

const { data } = await useFetch('/api/clinics/type-city-combinations', {
	key: 'clinics-type-city-combinations',
});

const combinations = computed(() => data.value?.typeCityCombinations ?? []);

// Одиночные фасеты приходят отдельными списками, а не выводятся из пар: пара
// «тип+город» живёт с порогом SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS, а
// одиночный фасет — без него. 3 типа и 8 городов не набирают порог ни с кем,
// в sitemap при этом попадают, и, пока хаб брал их из пар, ни одной входящей
// ссылки у них не было.
const allTypeIds = computed(() => data.value?.clinicTypeIds ?? []);
const allCityIds = computed(() => data.value?.cityIds ?? []);

const selectedTypeId = computed(() =>
	props.clinicTypeIds.length === 1 ? props.clinicTypeIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
);

// Голый листинг — ни типа, ни города. Остальные фильтры каталога (рейтинг,
// «открыто сейчас», язык) на выбор среза не влияют: ссылки всё равно ведут
// на чистые фасеты, а сами эти фильтры в sitemap сознательно не заводились.
const isUnfiltered = computed(
	() => props.clinicTypeIds.length === 0 && props.cityIds.length === 0,
);

/**
 * Порядок ссылок на голом листинге: сумма clinicCount по парам, где сущность
 * участвует, по убыванию; при равенстве (и у всех, кто в парах не участвует
 * вовсе, — вес 0) — по возрастанию id.
 *
 * Сумма — не точное число клиник: клиника с несколькими типами попадает в неё
 * несколько раз, а пары ниже порога в неё не входят. Но другого счётчика в
 * эндпоинте нет, а нужен нам только порядок — самые массовые типы и самые
 * «клиничные» города наверх.
 *
 * Список НЕ обрезается. У соседних хабов есть лимит: специальностей 77,
 * категорий услуг 36 — там короткий срез «самое ходовое» вместо ковра ссылок,
 * и остальные достижимы по цепочке через парные страницы. У клиник цепочки
 * нет: одиночный фасет без пар выше порога ниоткуда больше не виден, а сами
 * списки короткие и ограничены не данными, а справочниками (14 типов клиник,
 * 16 городов с клиниками из фиксированного enum'а).
 */
function orderByClinicCount<T extends Record<string, any>>(
	ids: number[],
	rows: T[],
	key: keyof T,
): number[] {
	const weights = new Map<number, number>();
	for (const row of rows) {
		const id = row[key] as number;
		weights.set(id, (weights.get(id) ?? 0) + Number(row.clinicCount ?? 1));
	}
	return [...ids].sort(
		(a, b) => (weights.get(b) ?? 0) - (weights.get(a) ?? 0) || a - b,
	);
}

const topTypes = computed(() =>
	isUnfiltered.value
		? orderByClinicCount(allTypeIds.value, combinations.value, 'clinicTypeId')
		: [],
);

const topCities = computed(() =>
	isUnfiltered.value
		? orderByClinicCount(allCityIds.value, combinations.value, 'cityId')
		: [],
);

const otherCitiesForType = computed(() => {
	if (selectedTypeId.value === null) return [];
	return combinations.value
		.filter((c) => c.clinicTypeId === selectedTypeId.value)
		.map((c) => c.cityId)
		.filter((cityId) => cityId !== selectedCityId.value);
});

const otherTypesForCity = computed(() => {
	if (selectedCityId.value === null) return [];
	return combinations.value
		.filter((c) => c.cityId === selectedCityId.value)
		.map((c) => c.clinicTypeId)
		.filter((typeId) => typeId !== selectedTypeId.value);
});

// Ссылка на тип без города: и человеку — способ расширить поиск на всю страну,
// и краулеру — единственный вход на `?clinicTypeIds=N` с фасетной страницы.
const typeLink = (clinicTypeId: number) => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		clinicTypeIds: String(clinicTypeId),
	},
});

// Города у /clinics — самостоятельный фасет в sitemap (`?cityIds=N`), в отличие
// от /doctors, /services и /labtests, где в sitemap есть только пары. Поэтому
// такую ссылку можно давать только здесь: перенос этого блока в соседний хаб
// завёл бы ссылки на URL, которых в sitemap нет.
const cityLink = (cityId: number) => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		cityIds: String(cityId),
	},
});

const typeCityLink = (clinicTypeId: number, cityId: number) => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		clinicTypeIds: String(clinicTypeId),
		cityIds: String(cityId),
	},
});

const hasHub = computed(
	() =>
		topTypes.value.length > 0 ||
		topCities.value.length > 0 ||
		otherCitiesForType.value.length > 0 ||
		otherTypesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="clinics-related-filters">
		<div v-if="topTypes.length" class="clinics-related-filters__group">
			<h3 class="clinics-related-filters__title">{{ t('ClinicsByType') }}</h3>
			<div class="clinics-related-filters__links">
				<NuxtLink
					v-for="typeId in topTypes"
					:key="typeId"
					:to="typeLink(typeId)"
				>
					{{ t(`clinic_type_${typeId}_plural`) }}
				</NuxtLink>
			</div>
		</div>

		<div v-if="topCities.length" class="clinics-related-filters__group">
			<h3 class="clinics-related-filters__title">{{ t('ClinicsByCity') }}</h3>
			<div class="clinics-related-filters__links">
				<NuxtLink
					v-for="cityId in topCities"
					:key="cityId"
					:to="cityLink(cityId)"
				>
					{{ t(`city_${cityId}_genitive`) }}
				</NuxtLink>
			</div>
		</div>

		<div
			v-if="otherCitiesForType.length"
			class="clinics-related-filters__group"
		>
			<h3 class="clinics-related-filters__title">
				{{ t(`clinic_type_${selectedTypeId}_plural`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="clinics-related-filters__links">
				<NuxtLink
					v-if="selectedCityId !== null"
					:to="typeLink(selectedTypeId!)"
				>
					{{ t('AllCities') }}
				</NuxtLink>
				<NuxtLink
					v-for="cityId in otherCitiesForType"
					:key="cityId"
					:to="typeCityLink(selectedTypeId!, cityId)"
				>
					{{ t(`city_${cityId}_genitive`) }}
				</NuxtLink>
			</div>
		</div>

		<div v-if="otherTypesForCity.length" class="clinics-related-filters__group">
			<h3 class="clinics-related-filters__title">
				{{ t('OtherTypesIn', { city: t(`city_${selectedCityId}_genitive`) }) }}
			</h3>
			<div class="clinics-related-filters__links">
				<NuxtLink
					v-if="selectedTypeId !== null"
					:to="cityLink(selectedCityId!)"
				>
					{{ t('AllClinics') }}
				</NuxtLink>
				<NuxtLink
					v-for="typeId in otherTypesForCity"
					:key="typeId"
					:to="typeCityLink(typeId, selectedCityId!)"
				>
					{{ t(`clinic_type_${typeId}_plural`) }}
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.clinics-related-filters {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xl);
	margin-top: var(--kit-spacing-2xl);
}

.clinics-related-filters__title {
	margin: 0 0 var(--kit-spacing-md);
	font-size: var(--kit-font-size-md);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-secondary);
}

.clinics-related-filters__links {
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
		"OtherTypesIn": "Other clinic types in {city}",
		"ClinicsByType": "Clinics by type",
		"ClinicsByCity": "Clinics by city",
		"AllCities": "In all cities",
		"AllClinics": "All clinics"
	},
	"ru": {
		"InOtherCities": "в других городах",
		"OtherTypesIn": "Другие типы клиник в {city}",
		"ClinicsByType": "Клиники по типу",
		"ClinicsByCity": "Клиники по городам",
		"AllCities": "Во всех городах",
		"AllClinics": "Все клиники"
	},
	"sr": {
		"InOtherCities": "u drugim gradovima",
		"OtherTypesIn": "Drugi tipovi klinika u {city}",
		"ClinicsByType": "Klinike po tipu",
		"ClinicsByCity": "Klinike po gradovima",
		"AllCities": "U svim gradovima",
		"AllClinics": "Sve klinike"
	},
	"sr-cyrl": {
		"InOtherCities": "у другим градовима",
		"OtherTypesIn": "Други типови клиника у {city}",
		"ClinicsByType": "Клинике по типу",
		"ClinicsByCity": "Клинике по градовима",
		"AllCities": "У свим градовима",
		"AllClinics": "Све клинике"
	},
	"de": {
		"InOtherCities": "in anderen Städten",
		"OtherTypesIn": "Andere Klinikarten in {city}",
		"ClinicsByType": "Kliniken nach Art",
		"ClinicsByCity": "Kliniken nach Stadt",
		"AllCities": "In allen Städten",
		"AllClinics": "Alle Kliniken"
	},
	"tr": {
		"InOtherCities": "diğer şehirlerde",
		"OtherTypesIn": "{city} içindeki diğer klinik türleri",
		"ClinicsByType": "Türe göre klinikler",
		"ClinicsByCity": "Şehre göre klinikler",
		"AllCities": "Tüm şehirlerde",
		"AllClinics": "Tüm klinikler"
	}
}
</i18n>
