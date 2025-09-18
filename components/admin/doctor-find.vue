<script setup lang="ts">
const props = defineProps<{
	doctors: DoctorData[];
	isLoadingDoctors: boolean;
}>();

const doctorId = ref<number | null>(null);

const searchDoctorName = ref('');
const searchDoctorNameInput = ref<HTMLInputElement | null>(null);

const selectedDoctor = computed(() => {
	return props.doctors.find((doctor) => doctor.id === doctorId.value);
});

const doctorOptions = computed(() => {
	return props.doctors.map((doctor) => ({
		label: doctor.name,
		value: doctor.id,
	}));
});
</script>

<template>
	<div>
		<div v-if="isLoadingDoctors">
			<div class="loading-spinner"></div>
			<p>Загрузка врачей...</p>
		</div>
		<div v-else>
			<FilterableSelect
				:items="doctorOptions"
				v-model:value="doctorId"
				placeholder="Выберите врача"
				placeholderSearch="Введите часть имени врача"
			/>

			<div v-if="selectedDoctor" class="doctor-info">
				<h3>Имя: {{ selectedDoctor.name }}</h3>
				<div>
					Фото:
					{{ selectedDoctor.photoUrl }}
					<img :src="selectedDoctor.photoUrl" width="100" height="100" />
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
