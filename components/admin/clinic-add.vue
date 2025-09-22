<script setup lang="ts">
const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const cityIds = ref<number[]>([]);
const languageIds = ref<number[]>([1]);
const clinicName = ref('');
const clinicAddress = ref('');
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

const clearFields = () => {
	cityIds.value = [];
	clinicName.value = '';
	languageIds.value = [1];
	clinicAddress.value = '';
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
};

const addClinic = async () => {
	if (
		!clinicName.value ||
		!cityIds.value.length ||
		!cityIds.value.length > 1 ||
		!clinicAddress.value ||
		!clinicLatitude.value ||
		!clinicLongitude.value
	) {
		alert('Нужно ввести название, город, адрес, широту и долготу');
		return;
	}

	await useFetch('/api/clinics/add', {
		key: 'clinics-add',
		method: 'POST',
		body: {
			name: clinicName.value,
			cityId: cityIds.value[0],
			languageIds: languageIds.value,
			address: clinicAddress.value,
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

			<el-input v-model="clinicName" placeholder="Название" />
			<el-input v-model="clinicAddress" placeholder="Адрес" />
			<el-input v-model="clinicLatitude" placeholder="Широта" />
			<el-input v-model="clinicLongitude" placeholder="Долгота" />
			<el-input v-model="clinicPhone" placeholder="Телефон" />
			<el-input v-model="clinicEmail" placeholder="Email" />
			<el-input v-model="clinicWebsite" placeholder="Вебсайт" />
			<el-input v-model="clinicFacebook" placeholder="Facebook" />
			<el-input v-model="clinicInstagram" placeholder="Instagram" />
			<el-input v-model="clinicTelegram" placeholder="Telegram" />
			<el-input v-model="clinicWhatsapp" placeholder="Whatsapp" />
			<el-input v-model="clinicViber" placeholder="Viber" />

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
