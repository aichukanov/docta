<script setup lang="ts">
import type { RouteLocationNamedRaw } from 'vue-router';
import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

/**
 * Ссылка на страницу клиники, которая исчезает вместе с клиникой.
 *
 * В статьях ссылки на клиники — часть текста и захардкожены слагами. Когда
 * админ скрывает клинику, её страница отдаёт 410, а ссылка в статье остаётся
 * битой. Компонент подставляется вместо `NuxtLink` с той же `to`: если клиники
 * нет в списке публичных, остаётся только текст — предложение не рвётся.
 *
 * У клиники с подтверждёнными жалобами после ссылки рисуется иконка
 * «Осторожно» (prd/clinic-reputation/).
 *
 * Список слагов грузится один раз на страницу (общий ключ `useFetch`).
 */
const props = defineProps<{
	to: RouteLocationNamedRaw;
}>();

const { data } = await useFetch<{
	slugs: string[];
	caution?: Record<string, ClinicComplaintType[]>;
}>('/api/clinics/public-slugs', { key: 'clinic-public-slugs' });

const slug = computed(() => String(props.to?.params?.clinicSlug ?? ''));

// Пока список не загрузился (или эндпоинт упал), ссылку оставляем: битая
// ссылка — меньшее зло, чем текст без ссылок на всех клиниках сразу.
const isAvailable = computed(
	() => !data.value?.slugs || data.value.slugs.includes(slug.value),
);

const cautionTypes = computed(() => data.value?.caution?.[slug.value]);
</script>

<template>
	<template v-if="isAvailable">
		<NuxtLink :to="to"><slot /></NuxtLink>
		<ClinicCautionBadge
			v-if="cautionTypes?.length"
			:cautionTypes="cautionTypes"
			:clinicSlug="slug"
			iconOnly
			small
			class="route-link-caution"
		/>
	</template>
	<span v-else><slot /></span>
</template>

<style scoped>
.route-link-caution {
	margin-left: 2px;
	vertical-align: -2px;
}
</style>
