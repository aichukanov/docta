<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		doctors: DoctorData[];
		clinics: ClinicData[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'selected', doctorId: number): void;
	(e: 'updated'): void;
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

const nameModified = computed(
	() => selectedDoctor.value?.name !== doctorModel.value?.name,
);

const nameRuModified = computed(
	() => selectedDoctor.value?.name_ru !== doctorModel.value?.name_ru,
);

const nameSrCyrlModified = computed(
	() => selectedDoctor.value?.name_sr_cyrl !== doctorModel.value?.name_sr_cyrl,
);

const professionalTitleModified = computed(
	() =>
		selectedDoctor.value?.professionalTitle !==
		doctorModel.value?.professionalTitle,
);

const photoUrlModified = computed(
	() => selectedDoctor.value?.photoUrl !== doctorModel.value?.photoUrl,
);

const emailModified = computed(
	() => selectedDoctor.value?.email !== doctorModel.value?.email,
);

const phoneModified = computed(
	() => selectedDoctor.value?.phone !== doctorModel.value?.phone,
);

const websiteModified = computed(
	() => selectedDoctor.value?.website !== doctorModel.value?.website,
);

const facebookModified = computed(
	() => selectedDoctor.value?.facebook !== doctorModel.value?.facebook,
);

const instagramModified = computed(
	() => selectedDoctor.value?.instagram !== doctorModel.value?.instagram,
);

const telegramModified = computed(
	() => selectedDoctor.value?.telegram !== doctorModel.value?.telegram,
);

const whatsappModified = computed(
	() => selectedDoctor.value?.whatsapp !== doctorModel.value?.whatsapp,
);

const viberModified = computed(
	() => selectedDoctor.value?.viber !== doctorModel.value?.viber,
);

const clinicIdsModified = computed(() => {
	if (!selectedDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = selectedDoctor.value.clinicIds
		.split(',')
		.map(Number)
		.sort();
	const modelIds = [...doctorModel.value.clinicIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const specialtyIdsModified = computed(() => {
	if (!selectedDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = selectedDoctor.value.specialtyIds
		.split(',')
		.map(Number)
		.sort();
	const modelIds = [...doctorModel.value.specialtyIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const languageIdsModified = computed(() => {
	if (!selectedDoctor.value || !doctorModel.value) {
		return false;
	}
	const originalIds = selectedDoctor.value.languageIds
		.split(',')
		.map(Number)
		.sort();
	const modelIds = [...doctorModel.value.languageIds].sort();
	return JSON.stringify(originalIds) !== JSON.stringify(modelIds);
});

const hasChanges = computed(() => {
	return (
		nameModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		professionalTitleModified.value ||
		photoUrlModified.value ||
		emailModified.value ||
		phoneModified.value ||
		websiteModified.value ||
		facebookModified.value ||
		instagramModified.value ||
		telegramModified.value ||
		whatsappModified.value ||
		viberModified.value ||
		clinicIdsModified.value ||
		specialtyIdsModified.value ||
		languageIdsModified.value
	);
});

const saveChanges = async () => {
	if (!doctorModel.value || !hasChanges.value) {
		return;
	}

	if (
		!doctorModel.value.name ||
		!doctorModel.value.clinicIds.length ||
		!doctorModel.value.specialtyIds.length ||
		!doctorModel.value.languageIds.length
	) {
		alert('Имя, клиника, специализация и язык обязательны');
		return;
	}

	if (!confirm('Вы уверены, что хотите сохранить изменения?')) {
		return;
	}

	await $fetch('/api/doctors/update', {
		method: 'POST',
		body: doctorModel.value,
	});

	emit('updated');
};

const deleteDoctor = async () => {
	if (!doctorId.value) {
		alert('Выберите врача');
		return;
	}

	if (!confirm('Вы уверены, что хотите удалить врача?')) {
		return;
	}

	await $fetch('/api/doctors/remove', {
		method: 'POST',
		body: {
			doctorId: doctorId.value,
		},
	});

	doctorId.value = null;
	doctorModel.value = null;

	emit('updated');
	alert('Врач удален');
};

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
				:modified="nameModified"
				@reset="doctorModel.name = selectedDoctor?.name"
			/>
			<AdminEditableField
				label="Имя (RU)"
				v-model:value="doctorModel.name_ru"
				:modified="nameRuModified"
				@reset="doctorModel.name_ru = selectedDoctor?.name_ru"
			/>
			<AdminEditableField
				label="Имя (SR кириллица)"
				v-model:value="doctorModel.name_sr_cyrl"
				:modified="nameSrCyrlModified"
				@reset="doctorModel.name_sr_cyrl = selectedDoctor?.name_sr_cyrl"
			/>
			<AdminEditableField
				label="Профессиональное звание"
				v-model:value="doctorModel.professionalTitle"
				:readonly="!editable"
				:modified="professionalTitleModified"
				@reset="
					doctorModel.professionalTitle = selectedDoctor?.professionalTitle
				"
			/>
			<AdminEditableField
				label="Фото"
				v-model:value="doctorModel.photoUrl"
				type="photo"
				:modified="photoUrlModified"
				@reset="doctorModel.photoUrl = selectedDoctor?.photoUrl"
			/>
			<AdminEditableField
				label="Email"
				v-model:value="doctorModel.email"
				:readonly="!editable"
				:modified="emailModified"
				@reset="doctorModel.email = selectedDoctor?.email"
			/>
			<AdminEditableField
				label="Телефон"
				v-model:value="doctorModel.phone"
				:readonly="!editable"
				:modified="phoneModified"
				@reset="doctorModel.phone = selectedDoctor?.phone"
			/>
			<AdminEditableField
				label="Вебсайт"
				v-model:value="doctorModel.website"
				:readonly="!editable"
				:modified="websiteModified"
				@reset="doctorModel.website = selectedDoctor?.website"
			/>
			<AdminEditableField
				label="Facebook"
				v-model:value="doctorModel.facebook"
				:readonly="!editable"
				:modified="facebookModified"
				@reset="doctorModel.facebook = selectedDoctor?.facebook"
			/>
			<AdminEditableField
				label="Instagram"
				v-model:value="doctorModel.instagram"
				:readonly="!editable"
				:modified="instagramModified"
				@reset="doctorModel.instagram = selectedDoctor?.instagram"
			/>
			<AdminEditableField
				label="Telegram"
				v-model:value="doctorModel.telegram"
				:readonly="!editable"
				:modified="telegramModified"
				@reset="doctorModel.telegram = selectedDoctor?.telegram"
			/>
			<AdminEditableField
				label="Whatsapp"
				v-model:value="doctorModel.whatsapp"
				:readonly="!editable"
				:modified="whatsappModified"
				@reset="doctorModel.whatsapp = selectedDoctor?.whatsapp"
			/>
			<AdminEditableField
				label="Viber"
				v-model:value="doctorModel.viber"
				:readonly="!editable"
				:modified="viberModified"
				@reset="doctorModel.viber = selectedDoctor?.viber"
			/>

			<FilterClinicSelect
				:clinics="clinics"
				v-model:value="doctorModel.clinicIds"
			/>

			<FilterSpecialtySelect v-model:value="doctorModel.specialtyIds" />

			<FilterLanguageSelect v-model:value="doctorModel.languageIds" />

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteDoctor"> Удалить </el-button>
			</div>
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

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
