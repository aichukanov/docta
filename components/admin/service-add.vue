<script setup lang="ts">
import type { ClinicData } from '~/interfaces/clinic';
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';

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

const { t } = useI18n(specialtyI18n);

const name = ref('');
const nameSr = ref('');
const nameSrCyrl = ref('');
const nameRu = ref('');
const nameDe = ref('');
const nameTr = ref('');
const sortOrder = ref<number | null>(null);
const specialtyIds = ref<number[]>([]);
const clinicPrices = ref<ClinicPriceEntry[]>([]);

const clinicOptions = computed(() =>
	props.clinics.map((c) => ({
		label: c.name,
		value: c.id,
	})),
);

const specialtyOptions = computed(() =>
	Object.values(DoctorSpecialty)
		.filter(Number)
		.map((key) => ({
			label: t(`specialty_${key}`),
			value: key as number,
		}))
		.sort((a, b) => a.label.localeCompare(b.label)),
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
	sortOrder.value = null;
	specialtyIds.value = [];
	clinicPrices.value = [];
};

const addService = async () => {
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

	const serviceId = await $fetch<number | null>('/api/services/add', {
		method: 'POST',
		body: {
			name: name.value || nameSr.value,
			name_sr: nameSr.value,
			name_sr_cyrl: nameSrCyrl.value,
			name_ru: nameRu.value,
			name_de: nameDe.value,
			name_tr: nameTr.value,
			sort_order: sortOrder.value,
			specialtyIds: specialtyIds.value,
			clinicPrices: validClinicPrices,
		},
	});

	if (serviceId) {
		clearFields();
		emit('updated');
		alert(`Услуга добавлена (ID: ${serviceId})`);
	}
};
</script>

<template>
	<div class="service-add">
		<AdminEditableField label="Название (EN)" v-model:value="name" />
		<AdminEditableField label="Название (SR)" v-model:value="nameSr" />
		<AdminEditableField label="Название (SR-CYRL)" v-model:value="nameSrCyrl" />
		<AdminEditableField label="Название (RU)" v-model:value="nameRu" />
		<AdminEditableField label="Название (DE)" v-model:value="nameDe" />
		<AdminEditableField label="Название (TR)" v-model:value="nameTr" />

		<div class="sort-order-section">
			<label>Порядок сортировки</label>
			<div class="sort-order-input">
				<el-input-number
					v-model="sortOrder"
					:min="1"
					:max="999"
					placeholder="Без приоритета"
					controls-position="right"
				/>
				<el-button
					v-if="sortOrder !== null"
					size="small"
					@click="sortOrder = null"
				>
					Сбросить
				</el-button>
			</div>
			<span class="hint">
				1 = первый (Осмотр), 2 = второй (Повторный осмотр), пусто = по алфавиту
			</span>
		</div>

		<div class="specialty-section">
			<label>Специальности</label>
			<el-select
				v-model="specialtyIds"
				filterable
				multiple
				placeholder="Выберите специальности"
				class="specialty-select"
			>
				<el-option
					v-for="spec in specialtyOptions"
					:key="spec.value"
					:label="spec.label"
					:value="spec.value"
				/>
			</el-select>
		</div>

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
			<el-button type="primary" @click="addService">Добавить услугу</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.service-add {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.sort-order-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);

	& > label {
		color: var(--color-text-secondary);
		font-size: 14px;
	}

	.sort-order-input {
		display: flex;
		gap: var(--spacing-sm);
		align-items: center;
	}

	.hint {
		font-size: 12px;
		color: var(--color-text-muted);
	}
}

.specialty-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);

	& > label {
		color: var(--color-text-secondary);
		font-size: 14px;
	}

	.specialty-select {
		width: 100%;
	}
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
