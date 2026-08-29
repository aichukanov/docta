<script setup lang="ts">
/**
 * Строка активных фильтров под заголовком списка.
 *
 * Нужна не для красоты: фасетные URL приходят из поиска и из внутренних ссылок
 * (бейдж класса на карточке лекарства, старые `?atcGroupIds=` из индекса), и
 * часть таких фильтров может не иметь своего контрола в панели — тогда человек
 * видит суженный список и не понимает, чем он сужен и как это снять.
 *
 * Компонент презентационный: подписи знает только страница (у каждой сущности
 * свои справочники), сюда приходят готовые чипы.
 */
export interface ActiveFilterChip {
	/** Уникален в пределах строки: `${фильтр}:${значение}` */
	key: string;
	label: string;
	remove: () => void;
}

defineProps<{
	items: ActiveFilterChip[];
	resetLabel?: string;
}>();

const emit = defineEmits<{
	(e: 'reset'): void;
}>();

const { t } = useI18n({ useScope: 'local' });
</script>

<template>
	<div v-if="items.length" class="active-filters" role="region" :aria-label="t('ActiveFilters')">
		<span class="active-filters__title">{{ t('ActiveFilters') }}</span>
		<el-tag
			v-for="item in items"
			:key="item.key"
			closable
			size="large"
			type="info"
			@close="item.remove()"
		>
			{{ item.label }}
		</el-tag>
		<el-button
			v-if="items.length > 1"
			link
			type="primary"
			size="small"
			@click="emit('reset')"
		>
			{{ resetLabel || t('ResetAll') }}
		</el-button>
	</div>
</template>

<style lang="less" scoped>
.active-filters {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: var(--spacing-sm);
	margin-bottom: var(--spacing-lg);
}

.active-filters__title {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}
</style>

<i18n lang="json">
{
	"en": { "ActiveFilters": "Active filters", "ResetAll": "Reset all" },
	"ru": { "ActiveFilters": "Активные фильтры", "ResetAll": "Сбросить все" },
	"sr": { "ActiveFilters": "Aktivni filteri", "ResetAll": "Poništi sve" },
	"sr-cyrl": { "ActiveFilters": "Активни филтери", "ResetAll": "Поништи све" },
	"de": { "ActiveFilters": "Aktive Filter", "ResetAll": "Alle zurücksetzen" },
	"tr": { "ActiveFilters": "Aktif filtreler", "ResetAll": "Tümünü sıfırla" }
}
</i18n>
