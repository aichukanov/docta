<script setup lang="ts">
import type { RouteLocationNamedRaw } from 'vue-router';

/**
 * Ссылка на страницу клиники, которая исчезает вместе с клиникой.
 *
 * В статьях ссылки на клиники — часть текста и захардкожены слагами. Когда
 * админ скрывает клинику, её страница отдаёт 410, а ссылка в статье остаётся
 * битой. Компонент подставляется вместо `NuxtLink` с той же `to`: если клиники
 * нет в списке публичных, остаётся только текст — предложение не рвётся.
 *
 * Список слагов грузится один раз на страницу (общий ключ `useFetch`).
 */
const props = defineProps<{
	to: RouteLocationNamedRaw;
}>();

const { data } = await useFetch<{ slugs: string[] }>(
	'/api/clinics/public-slugs',
	{ key: 'clinic-public-slugs' },
);

const slug = computed(() => String(props.to?.params?.clinicSlug ?? ''));

// Пока список не загрузился (или эндпоинт упал), ссылку оставляем: битая
// ссылка — меньшее зло, чем текст без ссылок на всех клиниках сразу.
const isAvailable = computed(
	() => !data.value?.slugs || data.value.slugs.includes(slug.value),
);
</script>

<template>
	<NuxtLink v-if="isAvailable" :to="to"><slot /></NuxtLink>
	<span v-else><slot /></span>
</template>
