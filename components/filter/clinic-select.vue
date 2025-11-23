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
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	clinics: ClinicData[];
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n();

const clinicIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
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
	"ba": {
		"Clinic": "Klinika",
		"AnyClinic": "Bilo koja klinika",
		"SearchClinic": "Unesite deo naziva klinike",
		"NotFoundClinic": "Klinika nije pronađena"
	},
	"me": {
		"Clinic": "Klinika",
		"AnyClinic": "Bilo koja klinika",
		"SearchClinic": "Unesite deo naziva klinike",
		"NotFoundClinic": "Klinika nije pronađena"
	}
}
</i18n>
