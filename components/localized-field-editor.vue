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
		// Пример значения для первичной вкладки (вторичные подсказываются
		// значением первичной, а при его отсутствии — тоже этим примером)
		placeholder?: string;
	}>(),
	{
		type: 'input',
		placeholder: '',
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

// Какие вкладки пользователь уже открывал.
//
// Раньше `v-show` по всем языкам монтировал редактор на КАЖДЫЙ язык сразу —
// шесть экземпляров CodeMirror на одно поле, из которых виден один. Теперь
// редактор создаётся при первом открытии вкладки и дальше живёт (то есть
// позиция курсора и история отмен при переключении туда-обратно не теряются,
// как и было с `v-show`).
const visitedTabs = ref(new Set<string>([activeTab.value]));

watch(activeTab, (key) => {
	visitedTabs.value = new Set(visitedTabs.value).add(key);
});

function isFilled(key: string): boolean {
	return Boolean(props.modelValue[key]?.trim());
}

function getPlaceholder(key: string): string {
	if (key === primaryKey.value) return props.placeholder;
	const primaryValue = props.modelValue[primaryKey.value]?.trim();
	return primaryValue || props.placeholder;
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
			<template v-if="type === 'markdown'">
				<LazyMarkdownEditor
					v-if="visitedTabs.has(lang.key)"
					:modelValue="modelValue[lang.key] || ''"
					@update:modelValue="updateField(lang.key, $event)"
					:placeholder="getPlaceholder(lang.key)"
				/>
			</template>
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
	gap: var(--kit-spacing-xs);
	flex-wrap: wrap;
	margin-bottom: var(--kit-spacing-sm);
}

.loc-field__tab {
	position: relative;
	display: inline-flex;
	align-items: center;
	gap: 4px;
	padding: var(--kit-spacing-xs) var(--kit-spacing-md);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-md);
	background: var(--kit-color-bg-primary);
	color: var(--kit-color-text-secondary);
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	cursor: pointer;
	transition: all 0.15s ease;
}

.loc-field__tab:hover {
	border-color: var(--kit-color-primary);
	color: var(--kit-color-primary);
}

.loc-field__tab--active {
	background: var(--kit-color-primary);
	border-color: var(--kit-color-primary);
	color: #fff;
}

.loc-field__tab--active:hover {
	color: #fff;
}

.loc-field__dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--kit-color-success-dark);
	flex-shrink: 0;
}

.loc-field__tab--active .loc-field__dot {
	background: var(--kit-color-bg-primary);
}
</style>
