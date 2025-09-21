<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';

const props = defineProps<{
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const doctorName = ref('');
const doctorEmail = ref('');
const doctorPhone = ref('');
const doctorWebsite = ref('');
const doctorPhotoUrl = ref('');
const doctorFacebook = ref('');
const doctorInstagram = ref('');
const doctorTelegram = ref('');
const doctorWhatsapp = ref('');
const doctorViber = ref('');

const clinicIds = ref<number[]>([]);
const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);

const clinicOptions = computed(() => {
	return props.clinics.map((clinic) => ({
		label: clinic.name,
		value: clinic.id,
	}));
});

const clearFields = () => {
	doctorName.value = '';
	doctorEmail.value = '';
	doctorPhone.value = '';
	doctorWebsite.value = '';
	doctorPhotoUrl.value = '';
	doctorFacebook.value = '';
	doctorInstagram.value = '';
	doctorTelegram.value = '';
	doctorWhatsapp.value = '';
	doctorViber.value = '';
	clinicIds.value = [];
	specialtyIds.value = [];
	languageIds.value = [];
};

const addDoctor = async () => {
	if (
		!doctorName.value ||
		!clinicIds.value.length ||
		!specialtyIds.value.length ||
		!languageIds.value.length
	) {
		alert('Имя, клиника, специализация и язык обязательны');
		return;
	}

	await useFetch('/api/doctors/add', {
		key: 'doctors-add',
		method: 'POST',
		body: {
			name: doctorName.value,
			email: doctorEmail.value,
			phone: doctorPhone.value,
			website: doctorWebsite.value,
			photoUrl: doctorPhotoUrl.value,
			facebook: doctorFacebook.value,
			instagram: doctorInstagram.value,
			telegram: doctorTelegram.value,
			whatsapp: doctorWhatsapp.value,
			viber: doctorViber.value,
			clinicIds: clinicIds.value,
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
		},
	});

	clearFields();
	emit('updated');
	alert('Врач добавлен');
};
</script>

<template>
	<div class="doctor-add">
		<h2>Добавить врача</h2>

		<el-input v-model="doctorName" placeholder="Имя" required />
		<el-input v-model="doctorPhotoUrl" placeholder="Фото" />
		<el-input v-model="doctorEmail" placeholder="Email" />
		<el-input v-model="doctorPhone" placeholder="Телефон" />
		<el-input v-model="doctorWebsite" placeholder="Вебсайт" />
		<el-input v-model="doctorFacebook" placeholder="Facebook" />
		<el-input v-model="doctorInstagram" placeholder="Instagram" />
		<el-input v-model="doctorTelegram" placeholder="Telegram" />
		<el-input v-model="doctorWhatsapp" placeholder="Whatsapp" />
		<el-input v-model="doctorViber" placeholder="Viber" />

		<FilterableSelect
			:items="clinicOptions"
			v-model:value="clinicIds"
			multiple
			placeholder="Выберите клинику"
			placeholderSearch="Введите часть названия клиники"
		/>

		<FilterSpecialtySelect v-model:value="specialtyIds" />
		<FilterLanguageSelect v-model:value="languageIds" />

		<div>
			<el-button type="primary" @click="addDoctor">Добавить врача</el-button>
		</div>
	</div>
</template>

<style scoped>
.doctor-add {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}
</style>
