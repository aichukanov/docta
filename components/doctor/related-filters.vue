<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import cityI18n from '~/i18n/city';
import specialtyI18n from '~/i18n/specialty';
import { combineI18nMessages } from '~/i18n/utils';

// Хаб перелинковки на /doctors: когда выбрана ровно одна специальность —
// ссылки на неё же в других городах; когда выбран ровно один город —
// ссылки на другие специальности в этом городе. Источник комбинаций —
// тот же запрос, что и sitemap-фильтр (только реально существующие пары,
// см. docs/audit/seo-2026-07.md, пункт 1b).
const props = defineProps<{
	specialtyIds: number[];
	cityIds: number[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([cityI18n, specialtyI18n]),
});

const { data } = await useFetch('/api/doctors/specialty-city-combinations', {
	key: 'doctors-specialty-city-combinations',
});

const combinations = computed(() => data.value?.specialtyCityCombinations ?? []);

const selectedSpecialtyId = computed(() =>
	props.specialtyIds.length === 1 ? props.specialtyIds[0] : null,
);
const selectedCityId = computed(() =>
	props.cityIds.length === 1 ? props.cityIds[0] : null,
);

const otherCitiesForSpecialty = computed(() => {
	if (selectedSpecialtyId.value === null) return [];
	return combinations.value
		.filter((c) => c.specialtyId === selectedSpecialtyId.value)
		.map((c) => c.cityId)
		.filter((cityId) => cityId !== selectedCityId.value);
});

const otherSpecialtiesForCity = computed(() => {
	if (selectedCityId.value === null) return [];
	return combinations.value
		.filter((c) => c.cityId === selectedCityId.value)
		.map((c) => c.specialtyId)
		.filter((specialtyId) => specialtyId !== selectedSpecialtyId.value);
});

const specialtyCityLink = (specialtyId: number, cityId: number) => ({
	name: 'doctors',
	query: {
		...getRegionalQuery(locale.value),
		specialtyIds: String(specialtyId),
		cityIds: String(cityId),
	},
});

const hasHub = computed(
	() =>
		otherCitiesForSpecialty.value.length > 0 ||
		otherSpecialtiesForCity.value.length > 0,
);
</script>

<template>
	<div v-if="hasHub" class="doctors-related-filters">
		<div v-if="otherCitiesForSpecialty.length" class="doctors-related-filters__group">
			<h3 class="doctors-related-filters__title">
				{{ t(`doctors_${selectedSpecialtyId}`) }}
				{{ t('InOtherCities') }}
			</h3>
			<div class="doctors-related-filters__links">
				<NuxtLink
					v-for="cityId in otherCitiesForSpecialty"
					:key="cityId"
					:to="specialtyCityLink(selectedSpecialtyId!, cityId)"
				>
					{{ t(`city_${cityId}_genitive`) }}
				</NuxtLink>
			</div>
		</div>

		<div v-if="otherSpecialtiesForCity.length" class="doctors-related-filters__group">
			<h3 class="doctors-related-filters__title">
				{{ t('OtherSpecialtiesIn', { city: t(`city_${selectedCityId}_genitive`) }) }}
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
	gap: var(--spacing-xl);
	margin-top: var(--spacing-2xl);
}

.doctors-related-filters__title {
	margin: 0 0 var(--spacing-md);
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
}

.doctors-related-filters__links {
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
	"en": { "InOtherCities": "in other cities", "OtherSpecialtiesIn": "Other specialties in {city}" },
	"ru": { "InOtherCities": "в других городах", "OtherSpecialtiesIn": "Другие специальности в {city}" },
	"sr": { "InOtherCities": "u drugim gradovima", "OtherSpecialtiesIn": "Drugi specijalisti u {city}" },
	"sr-cyrl": { "InOtherCities": "у другим градовима", "OtherSpecialtiesIn": "Други специјалисти у {city}" },
	"de": { "InOtherCities": "in anderen Städten", "OtherSpecialtiesIn": "Andere Fachärzte in {city}" },
	"tr": { "InOtherCities": "diğer şehirlerde", "OtherSpecialtiesIn": "{city} içindeki diğer uzmanlar" }
}
</i18n>
