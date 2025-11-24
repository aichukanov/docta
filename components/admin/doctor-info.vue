<script setup lang="ts">
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	doctors: DoctorData[];
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'selected', doctorId: number): void;
}>();

const doctorId = ref<number | null>(null);
const doctorModel = ref<DoctorData | null>(null);

const selectedDoctor = computed(() => {
	return props.doctors.find((doctor) => doctor.id === doctorId.value);
});

const doctorOptions = computed(() => {
	return props.doctors.map((doctor) => ({
		label: doctor.name,
		value: doctor.id,
	}));
});

watch(doctorId, (newDoctorId) => {
	emit('selected', newDoctorId);
});

watch(selectedDoctor, (doctor) => {
	if (doctor) {
		doctorModel.value = {
			...doctor,
			clinicIds: doctor.clinicIds.split(',').map(Number),
			specialtyIds: doctor.specialtyIds.split(',').map(Number),
			languageIds: doctor.languageIds.split(',').map(Number),
		};
	}
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="doctorOptions"
			v-model:value="doctorId"
			placeholder="Выберите врача"
			placeholderSearch="Введите часть имени врача"
		/>

		<div v-if="doctorModel" class="doctor-info">
			<AdminEditableField
				label="Имя"
				v-model:value="doctorModel.name"
				:modified="selectedDoctor?.name !== doctorModel.name"
				@reset="doctorModel.name = selectedDoctor?.name"
			/>
			<AdminEditableField
				label="Профессиональное звание"
				v-model:value="doctorModel.professionalTitle"
				:modified="
					selectedDoctor?.professionalTitle !== doctorModel.professionalTitle
				"
				@reset="
					doctorModel.professionalTitle = selectedDoctor?.professionalTitle
				"
			/>
			<AdminEditableField
				label="Фото"
				v-model:value="doctorModel.photoUrl"
				type="photo"
				:modified="selectedDoctor?.photoUrl !== doctorModel.photoUrl"
				@reset="doctorModel.photoUrl = selectedDoctor?.photoUrl"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="doctorModel.email"
				:modified="selectedDoctor?.email !== doctorModel.email"
				@reset="doctorModel.email = selectedDoctor?.email"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="doctorModel.phone"
				:modified="selectedDoctor?.phone !== doctorModel.phone"
				@reset="doctorModel.phone = selectedDoctor?.phone"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="doctorModel.website"
				:modified="selectedDoctor?.website !== doctorModel.website"
				@reset="doctorModel.website = selectedDoctor?.website"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="doctorModel.facebook"
				:modified="selectedDoctor?.facebook !== doctorModel.facebook"
				@reset="doctorModel.facebook = selectedDoctor?.facebook"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="doctorModel.instagram"
				:modified="selectedDoctor?.instagram !== doctorModel.instagram"
				@reset="doctorModel.instagram = selectedDoctor?.instagram"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="doctorModel.telegram"
				:modified="selectedDoctor?.telegram !== doctorModel.telegram"
				@reset="doctorModel.telegram = selectedDoctor?.telegram"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="doctorModel.whatsapp"
				:modified="selectedDoctor?.whatsapp !== doctorModel.whatsapp"
				@reset="doctorModel.whatsapp = selectedDoctor?.whatsapp"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="doctorModel.viber"
				:modified="selectedDoctor?.viber !== doctorModel.viber"
				@reset="doctorModel.viber = selectedDoctor?.viber"
			/>

			<FilterClinicSelect
				:clinics="clinics"
				v-model:value="doctorModel.clinicIds"
			/>

			<FilterSpecialtySelect v-model:value="doctorModel.specialtyIds" />

			<FilterLanguageSelect v-model:value="doctorModel.languageIds" />
		</div>
	</div>
</template>

<style scoped lang="less">
.doctor-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid black;
	padding-top: var(--spacing-lg);
}
</style>
