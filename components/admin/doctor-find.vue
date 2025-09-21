<script setup lang="ts">
const props = defineProps<{
	doctors: DoctorData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const doctorId = ref<number | null>(null);

const deleteDoctor = async () => {
	if (!doctorId.value) {
		alert('Выберите врача');
		return;
	}

	if (!confirm('Вы уверены, что хотите удалить врача?')) {
		return;
	}

	await useFetch('/api/doctors/remove', {
		key: 'doctors-remove',
		method: 'POST',
		body: {
			doctorId: doctorId.value,
		},
	});

	doctorId.value = null;

	emit('updated');
	alert('Врач удален');
};
</script>

<template>
	<div class="flex-block">
		<AdminDoctorInfo :doctors="doctors" @selected="doctorId = $event" />
		<div>
			<el-button type="danger" :disabled="!doctorId" @click="deleteDoctor()">
				Удалить
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.flex-block {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}
</style>
