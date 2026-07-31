<script setup lang="ts">
import clinicI18n from '~/i18n/clinic';

/**
 * Заглушка подстраниц клиники (услуги/анализы/лекарства/врачи), когда клиники
 * нет. Раньше подстраница в этом случае рендерила пустоту: пользователь видел
 * белый экран, а краулер — страницу, в которой об ошибке нет ни слова
 * (см. prd/silent-200-index-hygiene, тот же класс дефектов).
 */
const props = defineProps<{
	// Клиника скрыта администратором — 410, а не 404 (см. common/gone.ts)
	isGone?: boolean;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicI18n.messages,
});
</script>

<template>
	<main class="clinic-items-missing" role="main">
		<ErrorBlock :code="props.isGone ? 410 : 404" :title="t('ClinicNotFound')" />
	</main>
</template>

<style scoped>
/* Та же раскладка, что у ClinicItemsPage — заглушка встаёт на её место */
.clinic-items-missing {
	max-width: 1100px;
	width: 100%;
	margin: 0 auto;
	padding: var(--spacing-xl);
	box-sizing: border-box;
}
</style>
