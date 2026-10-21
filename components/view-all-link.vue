<script setup lang="ts">
import { NuxtLink } from '#components';
import IconArrowRight from '~/components/icon/arrow-right.vue';
import type { RouteLocationRaw } from 'vue-router';

/*
 * Переход к полному списку («все отзывы», «все услуги»). Своего оформления
 * не имеет: это `KitButton` в безрамочном весе, отрендеренный ссылкой, —
 * `as` отдаёт корень `NuxtLink`, поэтому остаются и префетч, и настоящий
 * `href` в серверной разметке. Обёртка живёт ради маршрута объектом:
 * в пакете дизайн-системы знания о роутере нет.
 */
defineProps<{
	to: RouteLocationRaw;
	label: string;
}>();
</script>

<template>
	<KitButton appearance="text" variant="primary" :as="NuxtLink" :to="to">
		{{ label }}
		<template #icon-right><IconArrowRight :size="16" /></template>
	</KitButton>
</template>
