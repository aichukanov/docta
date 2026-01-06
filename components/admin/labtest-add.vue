<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';

interface ClinicPriceEntry {
	clinicId: number | null;
	price: string;
	code: string;
}

const props = defineProps<{
	clinics: ClinicData[];
}>();

const emit = defineEmits<{
	(e: 'updated'): void;
}>();

const name = ref('');
const nameSr = ref('');
const nameSrCyrl = ref('');
const nameRu = ref('');
const nameDe = ref('');
const nameTr = ref('');
const categoryIds = ref<number[]>([]);
const clinicPrices = ref<ClinicPriceEntry[]>([]);

const clinicOptions = computed(() =>
	props.clinics.map((c) => ({
		label: c.name,
		value: c.id,
	})),
);

const addClinicPrice = () => {
	clinicPrices.value.push({ clinicId: null, price: '', code: '' });
};

const removeClinicPrice = (index: number) => {
	clinicPrices.value.splice(index, 1);
};

const clearFields = () => {
	name.value = '';
	nameSr.value = '';
	nameSrCyrl.value = '';
	nameRu.value = '';
	nameDe.value = '';
	nameTr.value = '';
	categoryIds.value = [];
	clinicPrices.value = [];
};

const addLabTest = async () => {
	if (!nameSr.value) {
		alert('Название (SR) обязательно');
		return;
	}

	const validClinicPrices = clinicPrices.value
		.filter((cp) => cp.clinicId)
		.map((cp) => ({
			clinicId: cp.clinicId!,
			price: cp.price ? parseFloat(cp.price) : undefined,
			code: cp.code || undefined,
		}));

	const labTestId = await $fetch<number | null>('/api/labtests/add', {
		method: 'POST',
		body: {
			name: name.value || nameSr.value,
			name_sr: nameSr.value,
			name_sr_cyrl: nameSrCyrl.value,
			name_ru: nameRu.value,
			name_de: nameDe.value,
			name_tr: nameTr.value,
			categoryIds: categoryIds.value,
			clinicPrices: validClinicPrices,
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
		<AdminEditableField
			label="Название (SR-CYRL)"
			v-model:value="nameSrCyrl"
		/>
		<AdminEditableField label="Название (RU)" v-model:value="nameRu" />
		<AdminEditableField label="Название (DE)" v-model:value="nameDe" />
		<AdminEditableField label="Название (TR)" v-model:value="nameTr" />

		<FilterCategorySelect v-model:value="categoryIds" />

		<div class="clinic-prices-section">
			<div class="section-header">
				<label>Клиники и цены</label>
				<el-button size="small" @click="addClinicPrice"
					>+ Добавить клинику</el-button
				>
			</div>

			<div
				v-for="(cp, index) in clinicPrices"
				:key="index"
				class="clinic-price-row"
			>
				<el-select
					v-model="cp.clinicId"
					filterable
					placeholder="Клиника"
					class="clinic-select"
				>
					<el-option
						v-for="clinic in clinicOptions"
						:key="clinic.value"
						:label="clinic.label"
						:value="clinic.value"
					/>
				</el-select>
				<el-input v-model="cp.price" placeholder="Цена" class="price-input" />
				<el-input v-model="cp.code" placeholder="Код" class="code-input" />
				<el-button type="danger" size="small" @click="removeClinicPrice(index)"
					>×</el-button
				>
			</div>
		</div>

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

.clinic-prices-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);

	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;

		label {
			color: var(--color-text-secondary);
			font-size: 14px;
		}
	}

	.clinic-price-row {
		display: flex;
		gap: var(--spacing-sm);
		align-items: center;

		.clinic-select {
			flex: 2;
		}

		.price-input {
			flex: 1;
			max-width: 120px;
		}

		.code-input {
			flex: 1;
			max-width: 120px;
		}
	}
}
</style>
