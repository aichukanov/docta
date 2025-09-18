<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';

const props = defineProps<{
	clinics: ClinicData[];
	isLoadingClinics: boolean;
}>();

const emit = defineEmits<{
	(e: 'add', doctor: DoctorData): void;
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

const clinicId = ref<number | null>(null);
const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);

const addDoctor = () => {
	if (
		!doctorName.value ||
		!clinicId.value ||
		!specialtyIds.value.length ||
		!languageIds.value.length
	) {
		alert('Имя, клиника, специализация и язык обязательны');
		return;
	}

	emit('add', {
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
		clinicIds: clinicId.value ? [clinicId.value] : [],
		specialtyIds: specialtyIds.value,
		languageIds: languageIds.value,
	});
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

		<div v-if="isLoadingClinics">
			<div class="loading-spinner"></div>
			<p>Загрузка клиник...</p>
		</div>
		<div v-else>
			<el-select v-model="clinicId" placeholder="Клиника" size="large">
				<el-option
					v-for="{ id, name } in clinics"
					:key="id"
					:label="name"
					:value="id"
				/>
			</el-select>
		</div>

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
