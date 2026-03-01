<script setup lang="ts">
interface LanguageTab {
	key: string;
	code: string;
}

const props = withDefaults(
	defineProps<{
		languages: LanguageTab[];
		modelValue: Record<string, string>;
		type?: 'input' | 'markdown';
	}>(),
	{
		type: 'input',
	},
);

const emit = defineEmits<{
	(e: 'update:modelValue', value: Record<string, string>): void;
}>();

const activeTab = ref(
	props.languages.find((l) => props.modelValue[l.key]?.trim())?.key ||
		props.languages[0]?.key ||
		'',
);

const primaryKey = computed(() => props.languages[0]?.key || '');

function isFilled(key: string): boolean {
	return Boolean(props.modelValue[key]?.trim());
}

function getPlaceholder(key: string): string {
	if (key === primaryKey.value) return '';
	const primaryValue = props.modelValue[primaryKey.value]?.trim();
	return primaryValue || '';
}

function updateField(key: string, value: string) {
	emit('update:modelValue', { ...props.modelValue, [key]: value });
}
</script>

<template>
	<div class="loc-field">
		<div class="loc-field__tabs">
			<button
				v-for="lang in languages"
				:key="lang.key"
				type="button"
				class="loc-field__tab"
				:class="{
					'loc-field__tab--active': activeTab === lang.key,
					'loc-field__tab--filled': isFilled(lang.key),
				}"
				@click="activeTab = lang.key"
			>
				{{ lang.code }}
				<span v-if="isFilled(lang.key)" class="loc-field__dot" />
			</button>
		</div>

		<div
			v-for="lang in languages"
			v-show="activeTab === lang.key"
			:key="lang.key"
		>
			<MarkdownEditor
				v-if="type === 'markdown'"
				:modelValue="modelValue[lang.key] || ''"
				@update:modelValue="updateField(lang.key, $event)"
				:placeholder="getPlaceholder(lang.key)"
			/>
			<el-input
				v-else
				:modelValue="modelValue[lang.key] || ''"
				@update:modelValue="updateField(lang.key, $event)"
				:placeholder="getPlaceholder(lang.key)"
			/>
		</div>
	</div>
</template>

<style scoped>
.loc-field__tabs {
	display: flex;
	gap: var(--spacing-xs);
	flex-wrap: wrap;
	margin-bottom: var(--spacing-sm);
}

.loc-field__tab {
	position: relative;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: var(--spacing-xs) var(--spacing-md);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-md);
	background: var(--color-bg-primary);
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	cursor: pointer;
	transition: all 0.15s ease;
}

.loc-field__tab:hover {
	border-color: var(--color-primary);
	color: var(--color-primary);
}

.loc-field__tab--active {
	background: var(--color-primary);
	border-color: var(--color-primary);
	color: #fff;
}

.loc-field__tab--active:hover {
	color: #fff;
}

.loc-field__dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--color-success);
	flex-shrink: 0;
}

.loc-field__tab--active .loc-field__dot {
	background: #fff;
}
</style>
