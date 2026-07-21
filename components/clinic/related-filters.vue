<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import clinicTypeI18n from '~/i18n/clinic-type';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /clinics: когда выбран ровно один тип клиники — ссылки
// на него же в других городах; когда выбран ровно один город — ссылки на
// другие типы клиник в этом городе. Источник комбинаций — тот же запрос и тот
// же порог, что и sitemap-фильтр (см. docs/audit/seo-2026-07.md, пункт 1b).
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

const selectedTypeId = computed(() =>
	props.clinicTypeIds.length === 1 ? props.clinicTypeIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
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

const typeCityLink = (clinicTypeId: number, cityId: number) => ({
	name: 'clinics',
	query: {
		...getRegionalQuery(locale.value),
		clinicTypeIds: String(clinicTypeId),
		cityIds: String(cityId),
	},
});

const hasHub = computed(
	() => otherCitiesForType.value.length > 0 || otherTypesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="clinics-related-filters">
		<div v-if="otherCitiesForType.length" class="clinics-related-filters__group">
			<h3 class="clinics-related-filters__title">
				{{ t(`clinic_type_${selectedTypeId}_plural`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="clinics-related-filters__links">
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
	gap: var(--spacing-xl);
	margin-top: var(--spacing-2xl);
}

.clinics-related-filters__title {
	margin: 0 0 var(--spacing-md);
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
}

.clinics-related-filters__links {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-sm);

	a {
		padding: var(--spacing-xs) var(--spacing-md);
		border-radius: var(--border-radius-md);
		background: var(--color-surface-secondary);
		color: var(--color-primary);
		text-decoration: none;
		font-size: var(--font-size-sm);
		transition: background var(--transition-fast);

		&:hover {
			background: var(--color-surface-primary);
			text-decoration: underline;
		}
	}
}
</style>

<i18n lang="json">
{
	"en": { "InOtherCities": "in other cities", "OtherTypesIn": "Other clinic types in {city}" },
	"ru": { "InOtherCities": "в других городах", "OtherTypesIn": "Другие типы клиник в {city}" },
	"sr": { "InOtherCities": "u drugim gradovima", "OtherTypesIn": "Drugi tipovi klinika u {city}" },
	"sr-cyrl": { "InOtherCities": "у другим градовима", "OtherTypesIn": "Други типови клиника у {city}" },
	"de": { "InOtherCities": "in anderen Städten", "OtherTypesIn": "Andere Klinikarten in {city}" },
	"tr": { "InOtherCities": "diğer şehirlerde", "OtherTypesIn": "{city} içindeki diğer klinik türleri" }
}
</i18n>
