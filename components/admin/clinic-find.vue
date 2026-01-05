<script setup lang="ts">
import { CityId } from '~/enums/cities';
import type { ClinicData } from '~/interfaces/clinic';

interface ClinicAdminModel extends ClinicData {
	name_sr: string;
	address_sr: string;
	address_sr_cyrl: string;
	town_sr: string;
	town_sr_cyrl: string;
	description_sr: string;
	description_en: string;
	description_ru: string;
	description_de: string;
	description_tr: string;
	languageIds: number[];
}

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
const clinicModel = ref<ClinicAdminModel | null>(null);
const cityIds = ref<CityId[]>([]);

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

const nameSrModified = computed(
	() => selectedClinic.value?.name_sr !== clinicModel.value?.name_sr,
);

const addressSrModified = computed(
	() => selectedClinic.value?.address_sr !== clinicModel.value?.address_sr,
);

const addressSrCyrlModified = computed(
	() =>
		selectedClinic.value?.address_sr_cyrl !==
		clinicModel.value?.address_sr_cyrl,
);

const townSrModified = computed(
	() => selectedClinic.value?.town_sr !== clinicModel.value?.town_sr,
);

const townSrCyrlModified = computed(
	() =>
		selectedClinic.value?.town_sr_cyrl !== clinicModel.value?.town_sr_cyrl,
);

const postalCodeModified = computed(
	() => selectedClinic.value?.postalCode !== clinicModel.value?.postalCode,
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

const descriptionSrModified = computed(
	() =>
		selectedClinic.value?.description_sr !== clinicModel.value?.description_sr,
);

const descriptionEnModified = computed(
	() =>
		selectedClinic.value?.description_en !== clinicModel.value?.description_en,
);

const descriptionRuModified = computed(
	() =>
		selectedClinic.value?.description_ru !== clinicModel.value?.description_ru,
);

const descriptionDeModified = computed(
	() =>
		selectedClinic.value?.description_de !== clinicModel.value?.description_de,
);

const descriptionTrModified = computed(
	() =>
		selectedClinic.value?.description_tr !== clinicModel.value?.description_tr,
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
		nameSrModified.value ||
		addressSrModified.value ||
		addressSrCyrlModified.value ||
		townSrModified.value ||
		townSrCyrlModified.value ||
		postalCodeModified.value ||
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
		descriptionSrModified.value ||
		descriptionEnModified.value ||
		descriptionRuModified.value ||
		descriptionDeModified.value ||
		descriptionTrModified.value ||
		languageIdsModified.value
	);
});

const saveChanges = async () => {
	if (!clinicModel.value || !hasChanges.value) {
		return;
	}

	if (
		!clinicModel.value.name_sr ||
		!clinicModel.value.address_sr ||
		!clinicModel.value.languageIds.length
	) {
		alert('Название (SR), адрес (SR) и язык обязательны');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/clinics/update', {
		method: 'POST',
		body: {
			id: clinicModel.value.id,
			name_sr: clinicModel.value.name_sr,
			cityId: clinicModel.value.cityId,
			address_sr: clinicModel.value.address_sr,
			address_sr_cyrl: clinicModel.value.address_sr_cyrl,
			town_sr: clinicModel.value.town_sr,
			town_sr_cyrl: clinicModel.value.town_sr_cyrl,
			postalCode: clinicModel.value.postalCode,
			latitude: clinicModel.value.latitude,
			longitude: clinicModel.value.longitude,
			phone: clinicModel.value.phone,
			email: clinicModel.value.email,
			website: clinicModel.value.website,
			facebook: clinicModel.value.facebook,
			instagram: clinicModel.value.instagram,
			telegram: clinicModel.value.telegram,
			whatsapp: clinicModel.value.whatsapp,
			viber: clinicModel.value.viber,
			description_sr: clinicModel.value.description_sr,
			description_en: clinicModel.value.description_en,
			description_ru: clinicModel.value.description_ru,
			description_de: clinicModel.value.description_de,
			description_tr: clinicModel.value.description_tr,
			languageIds: clinicModel.value.languageIds,
		},
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

watch(selectedClinic, async (clinic) => {
	if (clinic) {
		// Получаем полные данные клиники из админского API
		const adminData = await $fetch('/api/clinics/admin-details', {
			method: 'POST',
			body: {
				clinicId: clinic.id,
			},
		});

		if (adminData) {
			clinicModel.value = {
				...clinic,
				name_sr: adminData.name_sr || '',
				address_sr: adminData.address_sr || '',
				address_sr_cyrl: adminData.address_sr_cyrl || '',
				town_sr: adminData.town_sr || '',
				town_sr_cyrl: adminData.town_sr_cyrl || '',
				description_sr: adminData.description_sr || '',
				description_en: adminData.description_en || '',
				description_ru: adminData.description_ru || '',
				description_de: adminData.description_de || '',
				description_tr: adminData.description_tr || '',
				postalCode: adminData.postalCode || '',
				languageIds: adminData.languageIds,
			};
			cityIds.value = [adminData.cityId];
		} else {
			// Fallback на данные из списка, если админский API недоступен
			clinicModel.value = {
				...clinic,
				name_sr: clinic.name || '',
				address_sr: clinic.address || '',
				address_sr_cyrl: '',
				town_sr: clinic.town || '',
				town_sr_cyrl: '',
				description_sr: clinic.description || '',
				description_en: '',
				description_ru: '',
				description_de: '',
				description_tr: '',
				postalCode: clinic.postalCode || '',
				languageIds: clinic.languageIds.split(',').map(Number),
			};
			cityIds.value = [clinic.cityId];
		}
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
				label="Название (SR)"
				v-model:value="clinicModel.name_sr"
				:modified="nameSrModified"
				@reset="clinicModel.name_sr = selectedClinic?.name_sr || selectedClinic?.name || ''"
			/>
			<AdminEditableField
				label="Адрес (SR)"
				v-model:value="clinicModel.address_sr"
				:readonly="!editable"
				:modified="addressSrModified"
				@reset="clinicModel.address_sr = selectedClinic?.address_sr || selectedClinic?.address || ''"
			/>
			<AdminEditableField
				label="Адрес (SR-CYRL)"
				v-model:value="clinicModel.address_sr_cyrl"
				:readonly="!editable"
				:modified="addressSrCyrlModified"
				@reset="clinicModel.address_sr_cyrl = selectedClinic?.address_sr_cyrl || ''"
			/>
			<AdminEditableField
				label="Town (SR)"
				v-model:value="clinicModel.town_sr"
				:readonly="!editable"
				:modified="townSrModified"
				@reset="clinicModel.town_sr = selectedClinic?.town_sr || selectedClinic?.town || ''"
			/>
			<AdminEditableField
				label="Town (SR-CYRL)"
				v-model:value="clinicModel.town_sr_cyrl"
				:readonly="!editable"
				:modified="townSrCyrlModified"
				@reset="clinicModel.town_sr_cyrl = selectedClinic?.town_sr_cyrl || ''"
			/>
			<AdminEditableField
				label="Postal code"
				v-model:value="clinicModel.postalCode"
				:readonly="!editable"
				:modified="postalCodeModified"
				@reset="clinicModel.postalCode = selectedClinic?.postalCode || ''"
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

			<AdminEditableField
				label="Описание (SR)"
				type="textarea"
				v-model:value="clinicModel.description_sr"
				:readonly="!editable"
				:modified="descriptionSrModified"
				@reset="clinicModel.description_sr = selectedClinic?.description_sr"
			/>
			<AdminEditableField
				label="Описание (EN)"
				type="textarea"
				v-model:value="clinicModel.description_en"
				:readonly="!editable"
				:modified="descriptionEnModified"
				@reset="clinicModel.description_en = selectedClinic?.description_en"
			/>
			<AdminEditableField
				label="Описание (RU)"
				type="textarea"
				v-model:value="clinicModel.description_ru"
				:readonly="!editable"
				:modified="descriptionRuModified"
				@reset="clinicModel.description_ru = selectedClinic?.description_ru"
			/>
			<AdminEditableField
				label="Описание (DE)"
				type="textarea"
				v-model:value="clinicModel.description_de"
				:readonly="!editable"
				:modified="descriptionDeModified"
				@reset="clinicModel.description_de = selectedClinic?.description_de"
			/>
			<AdminEditableField
				label="Описание (TR)"
				type="textarea"
				v-model:value="clinicModel.description_tr"
				:readonly="!editable"
				:modified="descriptionTrModified"
				@reset="clinicModel.description_tr = selectedClinic?.description_tr"
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
