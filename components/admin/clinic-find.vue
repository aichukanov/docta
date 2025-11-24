<script setup lang="ts">
import { CityId } from '~/enums/cities';

const props = withDefaults(
	defineProps<{
		clinics: ClinicData[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const clinicId = ref<number | null>(null);
const clinicModel = ref<ClinicData | null>(null);
const cityIds = ref<number[]>([]);

const selectedClinic = computed(() => {
	return props.clinics.find((clinic) => clinic.id === clinicId.value);
});

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
		value: clinic.id,
	}));
});

watch(cityIds, (newCityIds) => {
	if (clinicModel.value && newCityIds.length > 0) {
		clinicModel.value.cityId = newCityIds[0];
	}
});

const nameModified = computed(
	() => selectedClinic.value?.name !== clinicModel.value?.name,
);

const addressModified = computed(
	() => selectedClinic.value?.address !== clinicModel.value?.address,
);

const latitudeModified = computed(
	() => selectedClinic.value?.latitude !== clinicModel.value?.latitude,
);

const longitudeModified = computed(
	() => selectedClinic.value?.longitude !== clinicModel.value?.longitude,
);

const phoneModified = computed(
	() => selectedClinic.value?.phone !== clinicModel.value?.phone,
);

const emailModified = computed(
	() => selectedClinic.value?.email !== clinicModel.value?.email,
);

const websiteModified = computed(
	() => selectedClinic.value?.website !== clinicModel.value?.website,
);

const facebookModified = computed(
	() => selectedClinic.value?.facebook !== clinicModel.value?.facebook,
);

const instagramModified = computed(
	() => selectedClinic.value?.instagram !== clinicModel.value?.instagram,
);

const telegramModified = computed(
	() => selectedClinic.value?.telegram !== clinicModel.value?.telegram,
);

const whatsappModified = computed(
	() => selectedClinic.value?.whatsapp !== clinicModel.value?.whatsapp,
);

const viberModified = computed(
	() => selectedClinic.value?.viber !== clinicModel.value?.viber,
);

const cityIdModified = computed(
	() => selectedClinic.value?.cityId !== clinicModel.value?.cityId,
);

const languageIdsModified = computed(() => {
	if (!selectedClinic.value || !clinicModel.value) {
		return false;
	}
	const originalIds = selectedClinic.value.languageIds
		.split(',')
		.map(Number)
		.sort();
	const modelIds = [...clinicModel.value.languageIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const hasChanges = computed(() => {
	return (
		nameModified.value ||
		addressModified.value ||
		latitudeModified.value ||
		longitudeModified.value ||
		phoneModified.value ||
		emailModified.value ||
		websiteModified.value ||
		facebookModified.value ||
		instagramModified.value ||
		telegramModified.value ||
		whatsappModified.value ||
		viberModified.value ||
		cityIdModified.value ||
		languageIdsModified.value
	);
});

const saveChanges = async () => {
	if (!clinicModel.value || !hasChanges.value) {
		return;
	}

	if (
		!clinicModel.value.name ||
		!clinicModel.value.address ||
		!clinicModel.value.languageIds.length
	) {
		alert('Название, адрес и язык обязательны');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/clinics/update', {
		method: 'POST',
		body: clinicModel.value,
	});

	emit('updated');
};

const deleteClinic = async () => {
	if (!clinicId.value) {
		alert('Выберите клинику');
		return;
	}

	if (!confirm('Вы уверены, что хотите удалить клинику?')) {
		return;
	}

	await $fetch('/api/clinics/remove', {
		method: 'POST',
		body: {
			clinicId: clinicId.value,
		},
	});

	clinicId.value = null;
	clinicModel.value = null;

	emit('updated');
	alert('Клиника удалена');
};

watch(selectedClinic, (clinic) => {
	if (clinic) {
		clinicModel.value = {
			...clinic,
			languageIds: clinic.languageIds.split(',').map(Number),
		};
		cityIds.value = [clinic.cityId];
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
				:modified="nameModified"
				@reset="clinicModel.name = selectedClinic?.name"
			/>
			<AdminEditableField
				label="Адрес"
				v-model:value="clinicModel.address"
				:readonly="!editable"
				:modified="addressModified"
				@reset="clinicModel.address = selectedClinic?.address"
			/>
			<AdminEditableField
				label="Широта"
				v-model:value="clinicModel.latitude"
				:readonly="!editable"
				:modified="latitudeModified"
				@reset="clinicModel.latitude = selectedClinic?.latitude"
			/>
			<AdminEditableField
				label="Долгота"
				v-model:value="clinicModel.longitude"
				:readonly="!editable"
				:modified="longitudeModified"
				@reset="clinicModel.longitude = selectedClinic?.longitude"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="clinicModel.phone"
				:readonly="!editable"
				:modified="phoneModified"
				@reset="clinicModel.phone = selectedClinic?.phone"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="clinicModel.email"
				:readonly="!editable"
				:modified="emailModified"
				@reset="clinicModel.email = selectedClinic?.email"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="clinicModel.website"
				:readonly="!editable"
				:modified="websiteModified"
				@reset="clinicModel.website = selectedClinic?.website"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="clinicModel.facebook"
				:readonly="!editable"
				:modified="facebookModified"
				@reset="clinicModel.facebook = selectedClinic?.facebook"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="clinicModel.instagram"
				:readonly="!editable"
				:modified="instagramModified"
				@reset="clinicModel.instagram = selectedClinic?.instagram"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="clinicModel.telegram"
				:readonly="!editable"
				:modified="telegramModified"
				@reset="clinicModel.telegram = selectedClinic?.telegram"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="clinicModel.whatsapp"
				:readonly="!editable"
				:modified="whatsappModified"
				@reset="clinicModel.whatsapp = selectedClinic?.whatsapp"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="clinicModel.viber"
				:readonly="!editable"
				:modified="viberModified"
				@reset="clinicModel.viber = selectedClinic?.viber"
			/>

			<FilterCitySelect v-model:value="cityIds" />

			<FilterLanguageSelect v-model:value="clinicModel.languageIds" />

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteClinic"> Удалить </el-button>
			</div>
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

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
