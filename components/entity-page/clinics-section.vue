<script setup lang="ts">
import type {
	ClinicData,
	ClinicPrice,
	ClinicDoctorsByClinicId,
} from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		cityIds: number[];
		// Полный набор клиник для услуги/анализа — нужен для подсчёта городов в фильтре.
		allClinics: ClinicData[];
		// Уже отфильтрованный по cityIds список — то, что рендерим.
		clinics: ClinicData[];
		clinicPrices?: ClinicPrice[];
		// Врачи по клиникам — только на странице услуги (см. PRD).
		clinicDoctors?: ClinicDoctorsByClinicId;
		title: string;
		sectionId?: string;
		showPrice?: boolean;
	}>(),
	{
		sectionId: 'clinics',
		showPrice: true,
	},
);

const emit = defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
	(e: 'update:cityIds', value: number[]): void;
}>();

const { t } = useI18n({ useScope: 'local' });

const cityIdsModel = computed({
	get: () => props.cityIds,
	set: (value: number[]) => emit('update:cityIds', value),
});

// Города, в которых хотя бы одна клиника предоставляет эту позицию, со счётчиком.
const availableCities = computed(() => {
	const counts = new Map<number, number>();
	for (const clinic of props.allClinics) {
		counts.set(clinic.cityId, (counts.get(clinic.cityId) ?? 0) + 1);
	}
	return Array.from(counts.entries()).map(([value, count]) => ({
		value,
		count,
	}));
});

// Показываем фильтр только когда есть из чего выбирать.
const showCityFilter = computed(() => availableCities.value.length > 1);

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

const getDoctorsInfo = (clinicId: number) => props.clinicDoctors?.[clinicId];

// Расстояние до пользователя на карточке — появляется после определения локации
const { getDistanceKm } = useClinicRanking();
</script>

<template>
	<EntityPageSection
		:sectionId="sectionId"
		:title="title"
		:count="clinics.length"
	>
		<template #icon><IconClinic :size="20" /></template>

		<template v-if="showCityFilter" #actions>
			<FilterCitySelect
				v-model:value="cityIdsModel"
				:availableCities="availableCities"
				hideLabel
			/>
		</template>

		<div v-if="clinics.length > 0" class="clinics-section__list">
			<ClinicSummary
				v-for="clinic in clinics"
				:key="clinic.id"
				:clinic="clinic"
				:priceInfo="getPriceInfo(clinic.id)"
				:doctors="getDoctorsInfo(clinic.id)"
				:showPrice="showPrice"
				:distance="getDistanceKm(clinic)"
				@show-on-map="emit('show-on-map', clinic)"
			/>
		</div>
		<p v-else class="clinics-section__empty" role="status" aria-live="polite">
			{{ t('NoClinicsForCity') }}
		</p>
	</EntityPageSection>
</template>

<style lang="less" scoped>
.clinics-section__list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.clinics-section__empty {
	margin: 0;
	padding: var(--spacing-xl);
	text-align: center;
	color: var(--color-text-secondary);
	background: var(--color-bg-tertiary);
	border-radius: var(--border-radius-md);
}
</style>

<i18n lang="json">
{
	"en": {
		"NoClinicsForCity": "No clinics in the selected city."
	},
	"ru": {
		"NoClinicsForCity": "В выбранном городе нет клиник с этой позицией."
	},
	"sr": {
		"NoClinicsForCity": "Nema klinika u izabranom gradu."
	},
	"sr-cyrl": {
		"NoClinicsForCity": "Нема клиника у изабраном граду."
	},
	"de": {
		"NoClinicsForCity": "Keine Kliniken in der ausgewählten Stadt."
	},
	"tr": {
		"NoClinicsForCity": "Seçilen şehirde klinik yok."
	}
}
</i18n>
