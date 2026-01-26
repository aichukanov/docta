<script setup lang="ts">
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';
import { DoctorSpecialty } from '~/enums/specialty';
import { MedicalServiceCategory } from '~/enums/medical-service-category';
import specialtyI18n from '~/i18n/specialty';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';
import { combineI18nMessages } from '~/i18n/utils';

interface ServiceListItem {
	id: number;
	name: string;
}

interface ServiceAdminDetails {
	id: number;
	name_en: string;
	name_sr: string;
	name_sr_cyrl: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
	sort_order: number | null;
	specialtyIds: number[];
	categoryIds: number[];
	clinicPrices: ClinicPrice[];
}

const props = withDefaults(
	defineProps<{
		services: ServiceListItem[];
		clinics: ClinicData[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'selected', serviceId: number): void;
	(e: 'updated'): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([specialtyI18n, medicalServiceCategoryI18n]),
});

const serviceId = ref<number | null>(null);
const serviceModel = ref<ServiceAdminDetails | null>(null);
const originalService = ref<ServiceAdminDetails | null>(null);
const isLoading = ref(false);

const serviceOptions = computed(() =>
	props.services.map((s) => ({
		label: s.name,
		value: s.id,
	})),
);

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

const categoryOptions = computed(() =>
	Object.values(MedicalServiceCategory)
		.filter(Number)
		.map((key) => ({
			label: t(`medical_service_category_${key}`),
			value: key as number,
		}))
		.sort((a, b) => a.label.localeCompare(b.label)),
);

const addClinicPrice = () => {
	if (!serviceModel.value) return;
	serviceModel.value.clinicPrices.push({
		clinicId: 0,
		price: null,
		priceMin: null,
		code: null,
	});
};

const removeClinicPrice = (index: number) => {
	if (!serviceModel.value) return;
	serviceModel.value.clinicPrices.splice(index, 1);
};

// Модифицированные поля
const nameModified = computed(
	() => originalService.value?.name_en !== serviceModel.value?.name_en,
);
const nameSrModified = computed(
	() => originalService.value?.name_sr !== serviceModel.value?.name_sr,
);
const nameSrCyrlModified = computed(
	() =>
		originalService.value?.name_sr_cyrl !== serviceModel.value?.name_sr_cyrl,
);
const nameRuModified = computed(
	() => originalService.value?.name_ru !== serviceModel.value?.name_ru,
);
const nameDeModified = computed(
	() => originalService.value?.name_de !== serviceModel.value?.name_de,
);
const nameTrModified = computed(
	() => originalService.value?.name_tr !== serviceModel.value?.name_tr,
);
const specialtyIdsModified = computed(() => {
	if (!originalService.value || !serviceModel.value) return false;
	const orig = [...originalService.value.specialtyIds].sort();
	const model = [...serviceModel.value.specialtyIds].sort();
	return JSON.stringify(orig) !== JSON.stringify(model);
});
const categoryIdsModified = computed(() => {
	if (!originalService.value || !serviceModel.value) return false;
	const orig = [...originalService.value.categoryIds].sort();
	const model = [...serviceModel.value.categoryIds].sort();
	return JSON.stringify(orig) !== JSON.stringify(model);
});
const clinicPricesModified = computed(() => {
	if (!originalService.value || !serviceModel.value) return false;
	return (
		JSON.stringify(originalService.value.clinicPrices) !==
		JSON.stringify(serviceModel.value.clinicPrices)
	);
});
const sortOrderModified = computed(
	() => originalService.value?.sort_order !== serviceModel.value?.sort_order,
);

const hasChanges = computed(
	() =>
		nameModified.value ||
		sortOrderModified.value ||
		nameSrModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		nameDeModified.value ||
		nameTrModified.value ||
		specialtyIdsModified.value ||
		categoryIdsModified.value ||
		clinicPricesModified.value,
);

const loadServiceDetails = async (id: number) => {
	isLoading.value = true;
	try {
		const data = await $fetch<ServiceAdminDetails | null>(
			'/api/services/admin-details',
			{
				method: 'POST',
				body: { serviceId: id },
			},
		);

		if (data) {
			originalService.value = JSON.parse(JSON.stringify(data));
			serviceModel.value = data;
		}
	} catch (e) {
		console.error('Failed to load service details:', e);
	} finally {
		isLoading.value = false;
	}
};

const saveChanges = async () => {
	if (!serviceModel.value || !hasChanges.value) return;

	if (!serviceModel.value.name_sr) {
		alert('Название (SR) обязательно');
		return;
	}

	if (!confirm('Сохранить изменения?')) return;

	await $fetch('/api/services/update', {
		method: 'POST',
		body: serviceModel.value,
	});

	emit('updated');
	alert('Услуга обновлена');

	// Перезагружаем данные
	if (serviceId.value) {
		await loadServiceDetails(serviceId.value);
	}
};

const deleteService = async () => {
	if (!serviceId.value) {
		alert('Выберите услугу');
		return;
	}

	if (!confirm('Удалить услугу? Это действие необратимо!')) return;

	await $fetch('/api/services/remove', {
		method: 'POST',
		body: { serviceId: serviceId.value },
	});

	serviceId.value = null;
	serviceModel.value = null;
	originalService.value = null;

	emit('updated');
	alert('Услуга удалена');
};

watch(serviceId, async (newId) => {
	emit('selected', newId!);
	if (newId) {
		await loadServiceDetails(newId);
	} else {
		serviceModel.value = null;
		originalService.value = null;
	}
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="serviceOptions"
			v-model:value="serviceId"
			placeholder="Выберите услугу"
			placeholderSearch="Введите название услуги"
		/>

		<div v-if="isLoading" class="loading">Загрузка...</div>

		<div v-else-if="serviceModel" class="service-info">
			<AdminFieldGroup title="Название">
				<AdminEditableField
					label="Название (EN)"
					v-model:value="serviceModel.name_en"
					:modified="nameModified"
					@reset="serviceModel.name_en = originalService?.name_en || ''"
				/>
				<AdminEditableField
					label="Название (SR)"
					v-model:value="serviceModel.name_sr"
					:modified="nameSrModified"
					@reset="serviceModel.name_sr = originalService?.name_sr || ''"
				/>
				<AdminEditableField
					label="Название (SR-CYRL)"
					v-model:value="serviceModel.name_sr_cyrl"
					:modified="nameSrCyrlModified"
					:translate-from="serviceModel.name_sr"
					@reset="serviceModel.name_sr_cyrl = originalService?.name_sr_cyrl || ''"
				/>
				<AdminEditableField
					label="Название (RU)"
					v-model:value="serviceModel.name_ru"
					:modified="nameRuModified"
					@reset="serviceModel.name_ru = originalService?.name_ru || ''"
				/>
				<AdminEditableField
					label="Название (DE)"
					v-model:value="serviceModel.name_de"
					:modified="nameDeModified"
					@reset="serviceModel.name_de = originalService?.name_de || ''"
				/>
				<AdminEditableField
					label="Название (TR)"
					v-model:value="serviceModel.name_tr"
					:modified="nameTrModified"
					@reset="serviceModel.name_tr = originalService?.name_tr || ''"
				/>
			</AdminFieldGroup>

			<div class="sort-order-section" :class="{ modified: sortOrderModified }">
				<label>Порядок сортировки</label>
				<div class="sort-order-input">
					<el-input-number
						v-model="serviceModel.sort_order"
						:min="1"
						:max="999"
						placeholder="Без приоритета"
						controls-position="right"
					/>
					<el-button
						v-if="serviceModel.sort_order !== null"
						size="small"
						@click="serviceModel.sort_order = null"
					>
						Сбросить
					</el-button>
				</div>
				<span class="hint"
					>1 = первый (Осмотр), 2 = второй (Повторный осмотр), пусто = по
					алфавиту</span
				>
			</div>

			<div
				class="specialty-section"
				:class="{ modified: specialtyIdsModified }"
			>
				<label>Специальности</label>
				<el-select
					v-model="serviceModel.specialtyIds"
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

			<div class="category-section" :class="{ modified: categoryIdsModified }">
				<label>Категории услуг</label>
				<el-select
					v-model="serviceModel.categoryIds"
					filterable
					multiple
					placeholder="Выберите категории"
					class="category-select"
				>
					<el-option
						v-for="cat in categoryOptions"
						:key="cat.value"
						:label="cat.label"
						:value="cat.value"
					/>
				</el-select>
			</div>

			<div
				class="clinic-prices-section"
				:class="{ modified: clinicPricesModified }"
			>
				<div class="section-header">
					<h4>Клиники и цены</h4>
					<el-button size="small" @click="addClinicPrice">+ Добавить</el-button>
				</div>

				<div
					v-for="(cp, index) in serviceModel.clinicPrices"
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
					<el-input
						v-model="cp.price"
						placeholder="Цена"
						type="number"
						class="price-input"
					/>
					<el-input
						v-model="cp.priceMin"
						placeholder="Мин. (от)"
						type="number"
						class="price-input"
					/>
					<el-input
						v-model="cp.priceMax"
						placeholder="Макс."
						type="number"
						class="price-input"
					/>
					<el-input v-model="cp.code" placeholder="Код" class="code-input" />
					<el-button
						type="danger"
						size="small"
						@click="removeClinicPrice(index)"
						>×</el-button
					>
				</div>

				<div v-if="!serviceModel.clinicPrices.length" class="no-clinics">
					Нет привязанных клиник
				</div>
			</div>

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteService">Удалить</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.service-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
	border-top: 1px solid var(--color-border-primary);
	padding-top: var(--spacing-lg);
}

.loading {
	padding: var(--spacing-lg);
	color: var(--color-text-secondary);
}

.sort-order-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);

	& > label {
		color: var(--color-text-secondary);
		font-size: 14px;
	}

	&.modified > label {
		color: #f59e0b;
		font-weight: 500;
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

.specialty-section,
.category-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: #f59e0b;
	}

	& > label {
		color: var(--color-text-secondary);
		font-size: 14px;
	}

	.specialty-select,
	.category-select {
		width: 100%;
	}
}

.clinic-prices-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: #f59e0b;
	}

	.section-header {
		display: flex;
		justify-content: space-between;
		align-items: center;

		h4 {
			margin: 0;
			color: var(--color-text-primary);
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
			max-width: 150px;
		}

		.code-input {
			flex: 1;
			max-width: 120px;
		}
	}

	.no-clinics {
		color: var(--color-text-secondary);
		font-style: italic;
	}
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
