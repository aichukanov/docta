<script setup lang="ts">
import { formatDate, formatRelativeDate } from '~/common/date-format';
import type { DateFormatKey } from '~/i18n/date';

/**
 * Дата в шаблоне. Держит в одном месте оба перекоса, из-за которых сербский
 * ломался: тег локали для Intl и относительные даты мимо CLDR
 * (подробности — в common/date-format.ts).
 *
 * Рендерит только текст: обёртку (`<time>`, `<span>`) ставит вызывающий, чтобы
 * не навязывать разметку.
 *
 * Если дата нужна строкой внутри сообщения — `t('ActiveUntil', { date })` —
 * компонент не подойдёт, зовите formatDate() у себя: `d` там уже есть.
 */
const props = withDefaults(
	defineProps<{
		value: string | number | Date;
		format?: DateFormatKey | 'relative';
	}>(),
	{ format: 'short' },
);

const { d, t, locale } = useI18n({ useScope: 'global' });

const text = computed(() =>
	props.format === 'relative'
		? formatRelativeDate(props.value, t, locale.value)
		: formatDate(props.value, d, locale.value, props.format),
);
</script>

<template>{{ text }}</template>
