<script setup lang="ts">
import type {
	ClinicData,
	ClinicPrice,
	LabTestListItem,
} from '~/interfaces/clinic';
import { toCyrillic } from '~/common/serbian-transliteration';

interface LabTestAdminDetails {
	id: number;
	name_en: string;
	name_sr: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
	categoryIds: number[];
	clinicPrices: ClinicPrice[];
	synonyms: { language: string; values: string[] }[];
}

const props = withDefaults(
	defineProps<{
		labTests: LabTestListItem[];
		clinics: ClinicData[];
		editable?: boolean;
	}>(),
	{
		editable: false,
	},
);

const emit = defineEmits<{
	(e: 'selected', labTestId: number): void;
	(e: 'updated'): void;
}>();

const labTestId = ref<number | null>(null);
const labTestModel = ref<LabTestAdminDetails | null>(null);
const originalLabTest = ref<LabTestAdminDetails | null>(null);
const isLoading = ref(false);

const labTestOptions = computed(() =>
	props.labTests.map((lt) => ({
		label: lt.name,
		value: lt.id,
	})),
);

const clinicOptions = computed(() =>
	props.clinics.map((c) => ({
		label: c.name,
		value: c.id,
	})),
);

const getClinicName = (clinicId: number) => {
	const clinic = props.clinics.find((c) => c.id === clinicId);
	return clinic?.name || `Клиника #${clinicId}`;
};

const addClinicPrice = () => {
	if (!labTestModel.value) return;
	labTestModel.value.clinicPrices.push({
		clinicId: 0,
		price: null,
		code: null,
	});
};

const removeClinicPrice = (index: number) => {
	if (!labTestModel.value) return;
	labTestModel.value.clinicPrices.splice(index, 1);
};

// Модифицированные поля
const nameModified = computed(
	() => originalLabTest.value?.name_en !== labTestModel.value?.name_en,
);
const nameSrCyrlModified = computed(
	() =>
		originalLabTest.value?.name_sr_cyrl !== labTestModel.value?.name_sr_cyrl,
);
const nameSrModified = computed(
	() => originalLabTest.value?.name_sr !== labTestModel.value?.name_sr,
);
const nameRuModified = computed(
	() => originalLabTest.value?.name_ru !== labTestModel.value?.name_ru,
);
const nameDeModified = computed(
	() => originalLabTest.value?.name_de !== labTestModel.value?.name_de,
);
const nameTrModified = computed(
	() => originalLabTest.value?.name_tr !== labTestModel.value?.name_tr,
);
const categoryIdsModified = computed(() => {
	if (!originalLabTest.value || !labTestModel.value) return false;
	const orig = [...originalLabTest.value.categoryIds].sort();
	const model = [...labTestModel.value.categoryIds].sort();
	return JSON.stringify(orig) !== JSON.stringify(model);
});
const clinicPricesModified = computed(() => {
	if (!originalLabTest.value || !labTestModel.value) return false;
	return (
		JSON.stringify(originalLabTest.value.clinicPrices) !==
		JSON.stringify(labTestModel.value.clinicPrices)
	);
});
const synonymsModified = computed(() => {
	if (!originalLabTest.value || !labTestModel.value) return false;
	return (
		JSON.stringify(originalLabTest.value.synonyms) !==
		JSON.stringify(labTestModel.value.synonyms)
	);
});

const hasChanges = computed(
	() =>
		nameModified.value ||
		nameSrModified.value ||
		nameSrCyrlModified.value ||
		nameRuModified.value ||
		nameDeModified.value ||
		nameTrModified.value ||
		categoryIdsModified.value ||
		clinicPricesModified.value ||
		synonymsModified.value,
);

// Управление синонимами
const getSynonymsForLanguage = (lang: string) => {
	const found = labTestModel.value?.synonyms.find((s) => s.language === lang);
	return found?.values.join('\n') || '';
};

const setSynonymsForLanguage = (lang: string, value: string) => {
	if (!labTestModel.value) return;

	// Не фильтруем пустые строки при вводе, чтобы работали переносы строк
	const values = value.split('\n');
	const existing = labTestModel.value.synonyms.find((s) => s.language === lang);

	if (existing) {
		existing.values = values;
	} else {
		labTestModel.value.synonyms.push({ language: lang, values });
	}
};

const synonymsSR = computed({
	get: () => getSynonymsForLanguage('sr'),
	set: (v) => setSynonymsForLanguage('sr', v),
});
const synonymsSrCyrl = computed({
	get: () => getSynonymsForLanguage('sr-cyrl'),
	set: (v) => setSynonymsForLanguage('sr-cyrl', v),
});
const synonymsEN = computed({
	get: () => getSynonymsForLanguage('en'),
	set: (v) => setSynonymsForLanguage('en', v),
});
const synonymsRU = computed({
	get: () => getSynonymsForLanguage('ru'),
	set: (v) => setSynonymsForLanguage('ru', v),
});
const synonymsDE = computed({
	get: () => getSynonymsForLanguage('de'),
	set: (v) => setSynonymsForLanguage('de', v),
});
const synonymsTR = computed({
	get: () => getSynonymsForLanguage('tr'),
	set: (v) => setSynonymsForLanguage('tr', v),
});

const translateSynonymsToCyrillic = () => {
	synonymsSrCyrl.value = toCyrillic(synonymsSR.value);
};

const loadLabTestDetails = async (id: number) => {
	isLoading.value = true;
	try {
		const data = await $fetch<LabTestAdminDetails | null>(
			'/api/labtests/admin-details',
			{
				method: 'POST',
				body: { labTestId: id },
			},
		);

		if (data) {
			originalLabTest.value = JSON.parse(JSON.stringify(data));
			labTestModel.value = data;
		}
	} catch (e) {
		console.error('Failed to load lab test details:', e);
	} finally {
		isLoading.value = false;
	}
};

const saveChanges = async () => {
	if (!labTestModel.value || !hasChanges.value) return;

	if (!labTestModel.value.name_sr) {
		alert('Название (SR) обязательно');
		return;
	}

	if (!confirm('Сохранить изменения?')) return;

	// Очищаем синонимы перед сохранением (trim и фильтр пустых строк)
	const cleanedSynonyms = labTestModel.value.synonyms
		.map((s) => ({
			language: s.language,
			values: s.values.map((v) => v.trim()).filter(Boolean),
		}))
		.filter((s) => s.values.length > 0);

	await $fetch('/api/labtests/update', {
		method: 'POST',
		body: { ...labTestModel.value, synonyms: cleanedSynonyms },
	});

	emit('updated');
	alert('Анализ обновлён');

	// Перезагружаем данные
	if (labTestId.value) {
		await loadLabTestDetails(labTestId.value);
	}
};

const deleteLabTest = async () => {
	if (!labTestId.value) {
		alert('Выберите анализ');
		return;
	}

	if (!confirm('Удалить анализ? Это действие необратимо!')) return;

	await $fetch('/api/labtests/remove', {
		method: 'POST',
		body: { labTestId: labTestId.value },
	});

	labTestId.value = null;
	labTestModel.value = null;
	originalLabTest.value = null;

	emit('updated');
	alert('Анализ удалён');
};

watch(labTestId, async (newId) => {
	emit('selected', newId!);
	if (newId) {
		await loadLabTestDetails(newId);
	} else {
		labTestModel.value = null;
		originalLabTest.value = null;
	}
});
</script>

<template>
	<div>
		<FilterableSelect
			:items="labTestOptions"
			v-model:value="labTestId"
			placeholder="Выберите анализ"
			placeholderSearch="Введите название анализа"
		/>

		<div v-if="isLoading" class="loading">Загрузка...</div>

		<div v-else-if="labTestModel" class="labtest-info">
			<AdminFieldGroup title="Название">
				<AdminEditableField
					label="Название (EN)"
					v-model:value="labTestModel.name_en"
					:modified="nameModified"
					@reset="labTestModel.name_en = originalLabTest?.name_en || ''"
				/>
				<AdminEditableField
					label="Название (SR)"
					v-model:value="labTestModel.name_sr"
					:modified="nameSrModified"
					@reset="labTestModel.name_sr = originalLabTest?.name_sr || ''"
				/>
				<AdminEditableField
					label="Название (SR-CYRL)"
					v-model:value="labTestModel.name_sr_cyrl"
					:modified="nameSrCyrlModified"
					:translate-from="labTestModel.name_sr"
					@reset="labTestModel.name_sr_cyrl = originalLabTest?.name_sr_cyrl || ''"
				/>
				<AdminEditableField
					label="Название (RU)"
					v-model:value="labTestModel.name_ru"
					:modified="nameRuModified"
					@reset="labTestModel.name_ru = originalLabTest?.name_ru || ''"
				/>
				<AdminEditableField
					label="Название (DE)"
					v-model:value="labTestModel.name_de"
					:modified="nameDeModified"
					@reset="labTestModel.name_de = originalLabTest?.name_de || ''"
				/>
				<AdminEditableField
					label="Название (TR)"
					v-model:value="labTestModel.name_tr"
					:modified="nameTrModified"
					@reset="labTestModel.name_tr = originalLabTest?.name_tr || ''"
				/>
			</AdminFieldGroup>

			<FilterCategorySelect v-model:value="labTestModel.categoryIds" />

			<div
				class="clinic-prices-section"
				:class="{ modified: clinicPricesModified }"
			>
				<div class="section-header">
					<h4>Клиники и цены</h4>
					<el-button size="small" @click="addClinicPrice">+ Добавить</el-button>
				</div>

				<div
					v-for="(cp, index) in labTestModel.clinicPrices"
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
						v-model="cp.priceMax"
						placeholder="Макс. цена"
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

				<div v-if="!labTestModel.clinicPrices.length" class="no-clinics">
					Нет привязанных клиник
				</div>
			</div>

			<div class="synonyms-section" :class="{ modified: synonymsModified }">
				<h4>Синонимы (по одному на строку)</h4>

				<div class="field">
					<label>Синонимы (SR)</label>
					<el-input
						v-model="synonymsSR"
						type="textarea"
						:autosize="{ minRows: 2, maxRows: 6 }"
						placeholder="Один синоним на строку"
					/>
				</div>

				<div class="field">
					<label>Синонимы (SR-CYRL)</label>
					<div class="textarea-with-button">
						<el-input
							v-model="synonymsSrCyrl"
							type="textarea"
							:autosize="{ minRows: 2, maxRows: 6 }"
							placeholder="Један синоним по реду"
						/>
						<el-button
							@click="translateSynonymsToCyrillic"
							title="Перевести с латиницы на кириллицу"
							class="translate-button"
						>
							Č → Ч
						</el-button>
					</div>
				</div>

				<div class="field">
					<label>Синонимы (EN)</label>
					<el-input
						v-model="synonymsEN"
						type="textarea"
						:autosize="{ minRows: 2, maxRows: 6 }"
						placeholder="Один синоним на строку"
					/>
				</div>

				<div class="field">
					<label>Синонимы (RU)</label>
					<el-input
						v-model="synonymsRU"
						type="textarea"
						:autosize="{ minRows: 2, maxRows: 6 }"
						placeholder="Один синоним на строку"
					/>
				</div>

				<div class="field">
					<label>Синонимы (DE)</label>
					<el-input
						v-model="synonymsDE"
						type="textarea"
						:autosize="{ minRows: 2, maxRows: 6 }"
						placeholder="Один синоним на строку"
					/>
				</div>

				<div class="field">
					<label>Синонимы (TR)</label>
					<el-input
						v-model="synonymsTR"
						type="textarea"
						:autosize="{ minRows: 2, maxRows: 6 }"
						placeholder="Один синоним на строку"
					/>
				</div>
			</div>

			<div v-if="editable" class="button-group">
				<el-button type="primary" @click="saveChanges" :disabled="!hasChanges">
					Сохранить изменения
				</el-button>
				<el-button type="danger" @click="deleteLabTest">Удалить</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.labtest-info {
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

.field {
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

	.textarea-with-button {
		display: flex;
		gap: var(--spacing-xs);
		align-items: flex-start;
	}

	.translate-button {
		font-weight: 600;
		margin-top: 4px;
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

.synonyms-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	padding: var(--spacing-md);
	background: var(--color-surface-secondary);
	border-radius: var(--border-radius-md);
	border: 1px solid var(--color-border-primary);

	&.modified {
		border-color: #f59e0b;
	}

	h4 {
		margin: 0;
		color: var(--color-text-primary);
	}
}

.button-group {
	display: flex;
	gap: var(--spacing-md);
}
</style>
