<script setup lang="ts">
import type { ClinicData } from '~/interfaces/doctor';

const props = defineProps<{
	doctors: DoctorData[];
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const doctorId1 = ref<number | null>(null);
const doctorId2 = ref<number | null>(null);

const searchDoctorName = ref('');
const searchDoctorNameInput = ref<HTMLInputElement | null>(null);

const selectedDoctor1 = computed(() => {
	return props.doctors.find((doctor) => doctor.id === doctorId1.value);
});

const selectedDoctor2 = computed(() => {
	return props.doctors.find((doctor) => doctor.id === doctorId2.value);
});

const mergeDoctors = async () => {
	if (
		!doctorId1.value ||
		!doctorId2.value ||
		doctorId1.value === doctorId2.value
	) {
		alert('Выберите две записи врача');
		return;
	}

	if (!confirm('Вы уверены, что хотите объединить записи?')) {
		return;
	}

	await $fetch('/api/doctors/merge', {
		method: 'POST',
		body: {
			primaryDoctorId: doctorId1.value,
			secondaryDoctorId: doctorId2.value,
		},
	});

	doctorId1.value = null;
	doctorId2.value = null;

	emit('updated');
	alert('Врачи объединены');
};
</script>

<template>
	<div class="flex-block-column">
		<div class="flex-block">
			<AdminDoctorInfo
				:doctors="doctors"
				:clinics="clinics"
				@selected="doctorId1 = $event"
			/>
			<AdminDoctorInfo
				:doctors="doctors"
				:clinics="clinics"
				@selected="doctorId2 = $event"
			/>
		</div>
		<div>
			<el-button type="primary" @click="mergeDoctors">Объединить</el-button>
		</div>
	</div>
</template>

<style scoped>
.flex-block-column {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.flex-block {
	display: flex;
	flex-direction: row;
	gap: var(--spacing-md);

	& > * {
		flex: 1 1 50%;
		max-width: 50%;
	}
}
</style>
