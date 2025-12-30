<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

const props = defineProps<{
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const name = ref('');
const nameSr = ref('');
const nameRu = ref('');
const nameDe = ref('');
const nameTr = ref('');
const categoryIds = ref<number[]>([]);
const clinicIds = ref<number[]>([]);

const clearFields = () => {
	name.value = '';
	nameSr.value = '';
	nameRu.value = '';
	nameDe.value = '';
	nameTr.value = '';
	categoryIds.value = [];
	clinicIds.value = [];
};

const addLabTest = async () => {
	if (!nameSr.value) {
		alert('Название (SR) обязательно');
		return;
	}

	const labTestId = await $fetch<number | null>('/api/labtests/add', {
		method: 'POST',
		body: {
			name: name.value || nameSr.value,
			name_sr: nameSr.value,
			name_ru: nameRu.value,
			name_de: nameDe.value,
			name_tr: nameTr.value,
			categoryIds: categoryIds.value,
			clinicIds: clinicIds.value,
		},
	});

	if (labTestId) {
		clearFields();
		emit('updated');
		alert(`Анализ добавлен (ID: ${labTestId})`);
	}
};
</script>

<template>
	<div class="labtest-add">
		<AdminEditableField label="Название (EN)" v-model:value="name" />
		<AdminEditableField label="Название (SR)" v-model:value="nameSr" />
		<AdminEditableField label="Название (RU)" v-model:value="nameRu" />
		<AdminEditableField label="Название (DE)" v-model:value="nameDe" />
		<AdminEditableField label="Название (TR)" v-model:value="nameTr" />

		<FilterCategorySelect v-model:value="categoryIds" />
		<FilterClinicSelect :clinics="clinics" v-model:value="clinicIds" />

		<div>
			<el-button type="primary" @click="addLabTest">Добавить анализ</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.labtest-add {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}
</style>
