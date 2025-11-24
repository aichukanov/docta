<script setup lang="ts">
import { CityId } from '~/enums/cities';

const props = defineProps<{
	clinics: ClinicData[];
}>();

const clinicId = ref<number | null>(null);
const clinicModel = ref<ClinicData | null>(null);

const selectedClinic = computed(() => {
	return props.clinics.find((clinic) => clinic.id === clinicId.value);
});

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
		value: clinic.id,
	}));
});

watch(selectedClinic, (clinic) => {
	if (clinic) {
		clinicModel.value = { ...clinic };
	}
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

		<div v-if="clinicModel" class="clinic-info">
			<AdminEditableField
				label="Название"
				v-model:value="clinicModel.name"
				:modified="selectedClinic?.name !== clinicModel.name"
				@reset="clinicModel.name = selectedClinic?.name"
			/>
			<AdminEditableField
				label="Адрес"
				v-model:value="clinicModel.address"
				:modified="selectedClinic?.address !== clinicModel.address"
				@reset="clinicModel.address = selectedClinic?.address"
			/>
			<AdminEditableField
				label="Широта"
				v-model:value="clinicModel.latitude"
				:modified="selectedClinic?.latitude !== clinicModel.latitude"
				@reset="clinicModel.latitude = selectedClinic?.latitude"
			/>
			<AdminEditableField
				label="Долгота"
				v-model:value="clinicModel.longitude"
				:modified="selectedClinic?.longitude !== clinicModel.longitude"
				@reset="clinicModel.longitude = selectedClinic?.longitude"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="clinicModel.phone"
				:modified="selectedClinic?.phone !== clinicModel.phone"
				@reset="clinicModel.phone = selectedClinic?.phone"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="clinicModel.email"
				:modified="selectedClinic?.email !== clinicModel.email"
				@reset="clinicModel.email = selectedClinic?.email"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="clinicModel.website"
				:modified="selectedClinic?.website !== clinicModel.website"
				@reset="clinicModel.website = selectedClinic?.website"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="clinicModel.facebook"
				:modified="selectedClinic?.facebook !== clinicModel.facebook"
				@reset="clinicModel.facebook = selectedClinic?.facebook"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="clinicModel.instagram"
				:modified="selectedClinic?.instagram !== clinicModel.instagram"
				@reset="clinicModel.instagram = selectedClinic?.instagram"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="clinicModel.telegram"
				:modified="selectedClinic?.telegram !== clinicModel.telegram"
				@reset="clinicModel.telegram = selectedClinic?.telegram"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="clinicModel.whatsapp"
				:modified="selectedClinic?.whatsapp !== clinicModel.whatsapp"
				@reset="clinicModel.whatsapp = selectedClinic?.whatsapp"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="clinicModel.viber"
				:modified="selectedClinic?.viber !== clinicModel.viber"
				@reset="clinicModel.viber = selectedClinic?.viber"
			/>
		</div>
	</div>
</template>

<style scoped lang="less">
.clinic-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid black;
	padding-top: var(--spacing-lg);
}
</style>
