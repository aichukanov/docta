<script setup lang="ts">
const props = defineProps<{
	doctors: DoctorData[];
}>();

const emit = defineEmits<{
	(e: 'selected', doctorId: number): void;
}>();

const doctorId = ref<number | null>(null);

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
</script>

<template>
	<div>
		<FilterableSelect
			:items="doctorOptions"
			v-model:value="doctorId"
			placeholder="Выберите врача"
			placeholderSearch="Введите часть имени врача"
		/>

		<div v-if="selectedDoctor" class="doctor-info">
			<h3>Имя: {{ selectedDoctor.name }}</h3>
			<div>
				<img :src="selectedDoctor.photoUrl" width="100" height="100" />
				<el-input v-model="selectedDoctor.photoUrl" type="textarea" rows="3" />
			</div>

			<div>email: {{ selectedDoctor.email }}</div>
			<div>Телефон: {{ selectedDoctor.phone }}</div>
			<div>Вебсайт: {{ selectedDoctor.website }}</div>
			<div>Facebook: {{ selectedDoctor.facebook }}</div>
			<div>Instagram: {{ selectedDoctor.instagram }}</div>
			<div>Telegram: {{ selectedDoctor.telegram }}</div>
			<div>Whatsapp: {{ selectedDoctor.whatsapp }}</div>
			<div>Viber: {{ selectedDoctor.viber }}</div>
		</div>
	</div>
</template>

<style scoped>
.doctor-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);

	& > div {
		display: flex;
		flex-direction: row;
		align-items: center;
		gap: var(--spacing-lg);
	}
}
</style>
