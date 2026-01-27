<script setup lang="ts">
const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const cityIds = ref<number[]>([]);
const languageIds = ref<number[]>([1]);
const clinicName = ref('');
const clinicNameSrCyrl = ref('');
const clinicNameRu = ref('');
const clinicAddressSr = ref('');
const clinicAddressSrCyrl = ref('');
const clinicTownSr = ref('');
const clinicTownSrCyrl = ref('');
const clinicPostalCode = ref('');
const clinicPhone = ref('');
const clinicEmail = ref('');
const clinicWebsite = ref('');
const clinicFacebook = ref('');
const clinicInstagram = ref('');
const clinicTelegram = ref('');
const clinicWhatsapp = ref('');
const clinicViber = ref('');
const clinicLatitude = ref('');
const clinicLongitude = ref('');
const clinicDescriptionSr = ref('');
const clinicDescriptionSrCyrl = ref('');
const clinicDescriptionEn = ref('');
const clinicDescriptionRu = ref('');
const clinicDescriptionDe = ref('');
const clinicDescriptionTr = ref('');

const clearFields = () => {
	cityIds.value = [];
	clinicName.value = '';
	clinicNameSrCyrl.value = '';
	clinicNameRu.value = '';
	languageIds.value = [1];
	clinicAddressSr.value = '';
	clinicAddressSrCyrl.value = '';
	clinicTownSr.value = '';
	clinicTownSrCyrl.value = '';
	clinicPostalCode.value = '';
	clinicLatitude.value = '';
	clinicLongitude.value = '';
	clinicPhone.value = '';
	clinicEmail.value = '';
	clinicWebsite.value = '';
	clinicFacebook.value = '';
	clinicInstagram.value = '';
	clinicTelegram.value = '';
	clinicWhatsapp.value = '';
	clinicViber.value = '';
	clinicDescriptionSr.value = '';
	clinicDescriptionSrCyrl.value = '';
	clinicDescriptionEn.value = '';
	clinicDescriptionRu.value = '';
	clinicDescriptionDe.value = '';
	clinicDescriptionTr.value = '';
};

const addClinic = async () => {
	if (
		!clinicName.value ||
		cityIds.value.length !== 1 ||
		!clinicAddressSr.value ||
		!clinicLatitude.value ||
		!clinicLongitude.value
	) {
		alert('Нужно ввести название, город, адрес (SR), широту и долготу');
		return;
	}

	await $fetch('/api/clinics/add', {
		method: 'POST',
		body: {
			name_sr: clinicName.value,
			name_sr_cyrl: clinicNameSrCyrl.value,
			name_ru: clinicNameRu.value,
			cityId: cityIds.value[0],
			languageIds: languageIds.value,
			address_sr: clinicAddressSr.value,
			address_sr_cyrl: clinicAddressSrCyrl.value,
			town_sr: clinicTownSr.value,
			town_sr_cyrl: clinicTownSrCyrl.value,
			postalCode: clinicPostalCode.value,
			latitude: clinicLatitude.value,
			longitude: clinicLongitude.value,
			phone: clinicPhone.value,
			email: clinicEmail.value,
			website: clinicWebsite.value,
			facebook: clinicFacebook.value,
			instagram: clinicInstagram.value,
			telegram: clinicTelegram.value,
			whatsapp: clinicWhatsapp.value,
			viber: clinicViber.value,
			description_sr: clinicDescriptionSr.value,
			description_sr_cyrl: clinicDescriptionSrCyrl.value,
			description_en: clinicDescriptionEn.value,
			description_ru: clinicDescriptionRu.value,
			description_de: clinicDescriptionDe.value,
			description_tr: clinicDescriptionTr.value,
		},
	});

	clearFields();
	emit('updated');
	alert('Клиника добавлена');
};
</script>

<template>
	<div>
		<div class="clinic-add-form">
			<FilterCitySelect v-model:value="cityIds" />
			<AdminFieldGroup title="Название">
				<AdminEditableField label="Название (SR)" v-model:value="clinicName" />
				<AdminEditableField
					label="Название (SR-CYRL)"
					v-model:value="clinicNameSrCyrl"
					:translate-from="clinicName"
				/>
				<AdminEditableField
					label="Название (RU)"
					v-model:value="clinicNameRu"
				/>
			</AdminFieldGroup>
			<AdminFieldGroup title="Адрес">
				<AdminEditableField
					label="Адрес (SR)"
					v-model:value="clinicAddressSr"
				/>
				<AdminEditableField
					label="Адрес (SR-CYRL)"
					v-model:value="clinicAddressSrCyrl"
					:translate-from="clinicAddressSr"
				/>
			</AdminFieldGroup>
			<AdminFieldGroup title="Город">
				<AdminEditableField label="Town (SR)" v-model:value="clinicTownSr" />
				<AdminEditableField
					label="Town (SR-CYRL)"
					v-model:value="clinicTownSrCyrl"
					:translate-from="clinicTownSr"
				/>
			</AdminFieldGroup>

			<AdminEditableField
				label="Postal code"
				v-model:value="clinicPostalCode"
			/>
			<AdminEditableField label="Широта" v-model:value="clinicLatitude" />
			<AdminEditableField label="Долгота" v-model:value="clinicLongitude" />
			<AdminEditableField label="Телефон" v-model:value="clinicPhone" />
			<AdminEditableField label="Email" v-model:value="clinicEmail" />
			<AdminEditableField label="Вебсайт" v-model:value="clinicWebsite" />
			<AdminEditableField label="Facebook" v-model:value="clinicFacebook" />
			<AdminEditableField label="Instagram" v-model:value="clinicInstagram" />
			<AdminEditableField label="Telegram" v-model:value="clinicTelegram" />
			<AdminEditableField label="Whatsapp" v-model:value="clinicWhatsapp" />
			<AdminEditableField label="Viber" v-model:value="clinicViber" />

			<AdminFieldGroup title="Описание">
				<AdminEditableField
					label="Описание (SR)"
					type="textarea"
					v-model:value="clinicDescriptionSr"
				/>
				<AdminEditableField
					label="Описание (SR-CYRL)"
					type="textarea"
					v-model:value="clinicDescriptionSrCyrl"
					:translate-from="clinicDescriptionSr"
				/>
				<AdminEditableField
					label="Описание (EN)"
					type="textarea"
					v-model:value="clinicDescriptionEn"
				/>
				<AdminEditableField
					label="Описание (RU)"
					type="textarea"
					v-model:value="clinicDescriptionRu"
				/>
				<AdminEditableField
					label="Описание (DE)"
					type="textarea"
					v-model:value="clinicDescriptionDe"
				/>
				<AdminEditableField
					label="Описание (TR)"
					type="textarea"
					v-model:value="clinicDescriptionTr"
				/>
			</AdminFieldGroup>

			<FilterLanguageSelect v-model:value="languageIds" />
		</div>

		<el-button type="primary" @click="addClinic">Добавить клинику</el-button>
	</div>
</template>

<style scoped>
.clinic-add-form {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);

	margin-bottom: var(--spacing-md);
}
</style>
