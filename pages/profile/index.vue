<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

// Редирект на первую вкладку — в middleware, а не `await navigateTo` в setup.
// При клиентском переходе на /profile редирект из setup вложенной
// index-страницы менял URL на /profile/basic, но Suspense родителя так и не
// разрешался: на экране оставалась предыдущая страница (с любой страницы,
// в том числе с /login сразу после входа). Middleware срабатывает до смены
// маршрута, компонент страницы вообще не монтируется.
definePageMeta({
	middleware: [
		(to) =>
			navigateTo(
				{
					name: 'profile-basic',
					query: getRegionalQuery(to.query.lang as string),
				},
				{ redirectCode: 301, replace: true },
			),
	],
});
</script>
