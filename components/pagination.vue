<template>
	<nav
		class="pagination-wrapper"
		:class="`pagination-wrapper_align_${align}`"
		:aria-label="uiText('Pagination')"
	>
		<KitPagination
			:total="total"
			:page-size="pageSize"
			:current-page="currentPage"
			:disabled="disabled"
			:href="href"
			:prev-label="uiText('PreviousPage')"
			:next-label="uiText('NextPage')"
			:page-label="pageLabel"
			@update:current-page="emit('update:current-page', $event)"
		/>
	</nav>
</template>

<script setup lang="ts">
withDefaults(
	defineProps<{
		total: number;
		currentPage: number;
		disabled?: boolean;
		pageSize?: number;
		align?: 'center' | 'right';
		/**
		 * Построитель адреса страницы: с ним номера рендерятся ссылками, без
		 * него — кнопками. Передавать обязаны все, у кого страница отражена
		 * в URL: без `href` в серверной разметке нет ни одной ссылки вглубь
		 * листинга, и краулер туда не попадает (FR-10 миграции с Element Plus).
		 *
		 * Адрес обязан совпадать с `rel=canonical` целевой страницы вплоть до
		 * порядка параметров, поэтому строится через `getCanonicalPath`, а не
		 * своей склейкой — см. `components/list-page.vue`.
		 */
		href?: (page: number) => string;
	}>(),
	{
		pageSize: 20,
		disabled: false,
		align: 'right',
		href: undefined,
	},
);

const emit = defineEmits(['update:current-page']);

const { uiText } = useUiText();
const pageLabel = (page: number) => uiText('PageN', { page });
</script>

<style lang="less" scoped>
.pagination-wrapper {
	display: flex;
	flex-direction: column;
	margin: 10px 0;
	flex: 0 0 30px;
	width: 100%;
	box-sizing: border-box;

	&_align_center {
		align-items: center;
	}

	&_align_right {
		align-items: flex-end;
	}

	@media (max-width: 600px) {
		align-items: center !important;
	}
}
</style>
