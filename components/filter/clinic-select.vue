<template>
	<FilterWrapper :label="t('Clinic')">
		<FilterableSelect
			:items="clinicOptions"
			v-model:value="clinicIds"
			multiple
			:placeholder="t('AnyClinic')"
			:placeholderSearch="t('SearchClinic')"
			:noDataText="t('NotFoundClinic')"
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { getLocalizedName } from '~/common/utils';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t, locale } = useI18n();

const clinicsStore = useClinicsStore();

const clinicIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const clinicOptions = computed(() => {
	return clinicsStore.clinics.map((clinic) => ({
		label: getLocalizedName(clinic, locale.value),
		value: clinic.id,
	}));
});
</script>

<i18n lang="json">
{
	"en": {
		"Clinic": "Clinic",
		"AnyClinic": "Any Clinic",
		"SearchClinic": "Type part of the clinic name",
		"NotFoundClinic": "Clinic not found"
	},
	"ru": {
		"Clinic": "Клиника",
		"AnyClinic": "Любая клиника",
		"SearchClinic": "Введите часть названия клиники",
		"NotFoundClinic": "Клиника не найдена"
	},
	"de": {
		"Clinic": "Klinik",
		"AnyClinic": "Alle Kliniken",
		"SearchClinic": "Teilen Sie den Namen der Klinik ein",
		"NotFoundClinic": "Klinik nicht gefunden"
	},
	"tr": {
		"Clinic": "Klinik",
		"AnyClinic": "Herhangi bir Klinik",
		"SearchClinic": "Klinik adının bir kısmını girin",
		"NotFoundClinic": "Klinik bulunamadı"
	},
	"sr": {
		"Clinic": "Klinika",
		"AnyClinic": "Bilo koja klinika",
		"SearchClinic": "Unesite deo naziva klinike",
		"NotFoundClinic": "Klinika nije pronađena"
	},
	"sr-cyrl": {
		"Clinic": "Клиника",
		"AnyClinic": "Било која клиника",
		"SearchClinic": "Унесите део назива клинике",
		"NotFoundClinic": "Клиника није пронађена"
	}
}
</i18n>
