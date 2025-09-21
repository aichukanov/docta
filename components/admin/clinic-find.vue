<script setup lang="ts">
const props = defineProps<{
	clinics: ClinicData[];
}>();

const clinicId = ref<number | null>(null);

const selectedClinic = computed(() => {
	return props.clinics.find((clinic) => clinic.id === clinicId.value);
});

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
		value: clinic.id,
	}));
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="clinicOptions"
			v-model:value="clinicId"
			placeholder="Выберите клинику"
			placeholderSearch="Введите часть названия клиники"
		/>

		<div v-if="selectedClinic" class="clinic-info">
			<h3>Название: {{ selectedClinic.name }}</h3>
			<div>Город: {{ CityId[selectedClinic.cityId] }}</div>
			<div>Адрес: {{ selectedClinic.address }}</div>
			<div>Широта: {{ selectedClinic.latitude }}</div>
			<div>Долгота: {{ selectedClinic.longitude }}</div>
			<div> </div>
			<div>email: {{ selectedClinic.email }}</div>
			<div>Телефон: {{ selectedClinic.phone }}</div>
			<div>Вебсайт: {{ selectedClinic.website }}</div>
			<div>Facebook: {{ selectedClinic.facebook }}</div>
			<div>Instagram: {{ selectedClinic.instagram }}</div>
			<div>Telegram: {{ selectedClinic.telegram }}</div>
			<div>Whatsapp: {{ selectedClinic.whatsapp }}</div>
			<div>Viber: {{ selectedClinic.viber }}</div>
		</div>
	</div>
</template>
