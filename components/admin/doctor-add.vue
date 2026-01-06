<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const doctorName = ref('');
const doctorNameRu = ref('');
const doctorNameSrCyrl = ref('');
const doctorNameEn = ref('');
const doctorProfessionalTitle = ref('');
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
const languageIds = ref<number[]>([1]);

const clearFields = () => {
	doctorName.value = '';
	doctorNameRu.value = '';
	doctorNameSrCyrl.value = '';
	doctorNameEn.value = '';
	doctorProfessionalTitle.value = '';
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
	languageIds.value = [1];
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

	await $fetch('/api/doctors/add', {
		method: 'POST',
		body: {
			name: doctorName.value,
			name_ru: doctorNameRu.value,
			name_sr_cyrl: doctorNameSrCyrl.value,
			name_en: doctorNameEn.value,
			professionalTitle: doctorProfessionalTitle.value,
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
		<AdminEditableField label="Имя" v-model:value="doctorName" />
		<AdminEditableField label="Имя (RU)" v-model:value="doctorNameRu" />
		<AdminEditableField
			label="Имя (SR кириллица)"
			v-model:value="doctorNameSrCyrl"
		/>
		<AdminEditableField label="Имя (EN)" v-model:value="doctorNameEn" />
		<AdminEditableField
			label="Профессиональное звание"
			v-model:value="doctorProfessionalTitle"
		/>
		<AdminEditableField
			label="Фото"
			type="photo"
			v-model:value="doctorPhotoUrl"
		/>
		<AdminEditableField label="Email" v-model:value="doctorEmail" />
		<AdminEditableField label="Телефон" v-model:value="doctorPhone" />
		<AdminEditableField label="Вебсайт" v-model:value="doctorWebsite" />
		<AdminEditableField label="Facebook" v-model:value="doctorFacebook" />
		<AdminEditableField label="Instagram" v-model:value="doctorInstagram" />
		<AdminEditableField label="Telegram" v-model:value="doctorTelegram" />
		<AdminEditableField label="Whatsapp" v-model:value="doctorWhatsapp" />
		<AdminEditableField label="Viber" v-model:value="doctorViber" />

		<FilterClinicSelect :clinics="clinics" v-model:value="clinicIds" />
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
