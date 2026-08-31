<script setup lang="ts">
import { Close, Plus } from '@element-plus/icons-vue';
import {
	isValidContactValue,
	joinContacts,
	normalizeContactValue,
	sanitizeContactValue,
	splitContactInput,
	type ContactKind,
} from '~/common/contact-input';
import { splitContacts } from '~/common/contacts';

const props = defineProps<{
	modelValue: string;
	kind: ContactKind;
	/** Пример в нужном формате — он же подсказка, что мы ожидаем. */
	placeholder?: string;
	/** Сообщение об ошибке для этого типа значения. */
	invalidHint: string;
	addLabel: string;
	removeLabel: string;
}>();

const emit = defineEmits<{
	(e: 'update:modelValue', value: string): void;
}>();

// Хотя бы одна строка нужна всегда: пустой список нечем заполнять
const toRows = (value: string) => {
	const rows = splitContacts(value);
	return rows.length ? rows : [''];
};

const rows = ref<string[]>(toRows(props.modelValue));
const inputs = ref<Array<{ focus: () => void } | null>>([]);
// Ошибку показываем только после того, как пользователь ушёл из поля:
// подсвечивать недописанный номер на каждом символе — шум
const touched = ref<boolean[]>([]);

// Своё же значение обратно в rows не раскладываем — иначе пустая строка,
// в которую пользователь ещё не начал печатать, исчезнет у него под курсором
let lastEmitted = props.modelValue;

watch(
	() => props.modelValue,
	(value) => {
		if (value === lastEmitted) return;
		rows.value = toRows(value);
		touched.value = [];
	},
);

function commit() {
	lastEmitted = joinContacts(rows.value);
	emit('update:modelValue', lastEmitted);
}

function onInput(index: number, raw: string) {
	const parts = splitContactInput(raw, props.kind).map((part) =>
		sanitizeContactValue(part, props.kind),
	);

	if (parts.length <= 1) {
		rows.value[index] = parts[0] ?? '';
		commit();
		return;
	}

	// Пользователь разделил значения сам (запятая, слэш, вставка из буфера) —
	// раскладываем по строкам и уводим курсор в последнюю, иначе он продолжит
	// печатать в первую и снова получит склейку
	rows.value.splice(index, 1, ...parts);
	touched.value.splice(index, 1, ...parts.map(() => true));
	commit();

	const lastIndex = index + parts.length - 1;
	nextTick(() => inputs.value[lastIndex]?.focus());
}

function onBlur(index: number) {
	rows.value[index] = normalizeContactValue(rows.value[index], props.kind);
	touched.value[index] = true;
	commit();
}

function addRow() {
	rows.value.push('');
	nextTick(() => inputs.value[rows.value.length - 1]?.focus());
}

function removeRow(index: number) {
	rows.value.splice(index, 1);
	touched.value.splice(index, 1);
	// Иначе в хвосте останется ссылка на размонтированный input и фокус после
	// «+» уедет не туда
	inputs.value.splice(index, 1);
	if (!rows.value.length) rows.value.push('');
	commit();
}

const errors = computed(() =>
	rows.value.map(
		(row, index) =>
			touched.value[index] && !isValidContactValue(row, props.kind),
	),
);
</script>

<template>
	<div class="contact-field">
		<div v-for="(row, index) in rows" :key="index" class="contact-field__row">
			<div class="contact-field__input">
				<el-input
					:ref="(el: any) => (inputs[index] = el)"
					:model-value="row"
					:placeholder="placeholder"
					:type="kind === 'email' ? 'email' : 'text'"
					@update:model-value="onInput(index, $event)"
					@blur="onBlur(index)"
				/>
				<span v-if="errors[index]" class="contact-field__error">
					{{ invalidHint }}
				</span>
			</div>
			<el-button
				v-if="rows.length > 1 || row"
				:icon="Close"
				:title="removeLabel"
				:aria-label="removeLabel"
				circle
				size="small"
				@click="removeRow(index)"
			/>
		</div>

		<el-button
			:icon="Plus"
			link
			type="primary"
			class="contact-field__add"
			@click="addRow"
		>
			{{ addLabel }}
		</el-button>
	</div>
</template>

<style scoped>
.contact-field {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
}

.contact-field__row {
	display: flex;
	align-items: flex-start;
	gap: var(--kit-spacing-xs);
}

.contact-field__input {
	flex: 1;
	min-width: 0;
	display: flex;
	flex-direction: column;
	gap: 2px;
}

.contact-field__error {
	font-size: var(--kit-font-size-xs);
	color: var(--kit-color-danger-dark);
}

.contact-field__add {
	align-self: flex-start;
	font-size: var(--kit-font-size-sm);
}
</style>
