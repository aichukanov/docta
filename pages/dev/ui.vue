<script setup lang="ts">
/**
 * Витрина компонентов дизайн-системы (@ach/ui-kit).
 *
 * Инструмент разработки, не часть продукта: страница закрыта от индексации
 * заголовком в routeRules и отдаётся только в dev — в проде на неё 404
 * (см. middleware ниже). Смысл — увидеть все состояния контролов рядом,
 * не открывая десяток продуктовых страниц, и ловить визуальные регрессии
 * при правках пакета.
 *
 * Тексты здесь намеренно НЕ переведены: витрина не пользовательский экран,
 * а стенд для разработчика, и ключи i18n на нём только мешали бы.
 */
definePageMeta({
	middleware() {
		if (!import.meta.dev) {
			return abortNavigation({ statusCode: 404 });
		}
	},
});

useHead({ title: 'UI kit — @ach/ui-kit' });

const toast = useToast();
const isLoading = ref(false);

const variants = [
	'default',
	'primary',
	'success',
	'warning',
	'danger',
] as const;
const appearances = ['solid', 'plain', 'text', 'link'] as const;
const sizes = ['small', 'default', 'large'] as const;
const alertVariants = ['info', 'success', 'warning', 'error'] as const;

function demoLoading() {
	isLoading.value = true;
	setTimeout(() => (isLoading.value = false), 1500);
}
</script>

<template>
	<div class="showcase">
		<h1>UI kit — @ach/ui-kit</h1>
		<p class="showcase__note">
			Стенд разработчика. Каждая ячейка — состояние компонента; наводите и жмите
			Tab, чтобы увидеть hover, active и фокус-индикаторы.
		</p>

		<section>
			<h2>KitButton — variant × appearance</h2>
			<table class="showcase__grid">
				<thead>
					<tr>
						<th />
						<th v-for="appearance in appearances" :key="appearance">
							{{ appearance }}
						</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="variant in variants" :key="variant">
						<th>{{ variant }}</th>
						<td v-for="appearance in appearances" :key="appearance">
							<KitButton :variant="variant" :appearance="appearance">
								Записаться
							</KitButton>
						</td>
					</tr>
				</tbody>
			</table>
		</section>

		<section>
			<h2>KitButton — размеры и состояния</h2>
			<div class="showcase__row">
				<KitButton
					v-for="size in sizes"
					:key="size"
					variant="primary"
					:size="size"
				>
					{{ size }}
				</KitButton>
			</div>
			<div class="showcase__row">
				<KitButton variant="primary" disabled>disabled</KitButton>
				<KitButton variant="primary" loading>loading</KitButton>
				<KitButton variant="primary" round>round</KitButton>
				<KitButton variant="danger" appearance="plain" size="small">
					small plain danger
				</KitButton>
			</div>
			<div class="showcase__row showcase__row--narrow">
				<KitButton variant="primary" block>block</KitButton>
			</div>
		</section>

		<section>
			<h2>KitTag</h2>
			<div
				v-for="appearance in ['light', 'solid', 'plain'] as const"
				:key="appearance"
				class="showcase__row"
			>
				<KitTag
					v-for="variant in variants"
					:key="variant"
					:variant="variant"
					:appearance="appearance"
				>
					{{ appearance }}/{{ variant }}
				</KitTag>
			</div>
			<div class="showcase__row">
				<KitTag
					v-for="size in sizes"
					:key="size"
					variant="primary"
					:size="size"
				>
					{{ size }}
				</KitTag>
				<KitTag variant="success" round>round</KitTag>
			</div>
		</section>

		<section>
			<h2>KitAlert</h2>
			<div class="showcase__stack">
				<KitAlert
					v-for="variant in alertVariants"
					:key="variant"
					:variant="variant"
					:title="`Алерт ${variant}`"
					show-icon
				/>
				<KitAlert
					variant="warning"
					title="С описанием и закрытием"
					description="Цены в клинике не обновлялись больше года — уточняйте по телефону."
					show-icon
					closable
					close-label="Закрыть"
				/>
			</div>
		</section>

		<section>
			<h2>useToast</h2>
			<div class="showcase__row">
				<KitButton variant="success" @click="toast.success('Профиль сохранён')">
					success
				</KitButton>
				<KitButton
					variant="danger"
					@click="toast.error('Не удалось сохранить профиль')"
				>
					error
				</KitButton>
				<KitButton
					variant="warning"
					@click="toast.warning('Проверьте номер телефона')"
				>
					warning
				</KitButton>
				<KitButton @click="toast.info('Ничего не изменилось')">info</KitButton>
			</div>
		</section>

		<section>
			<h2>KitSkeleton</h2>
			<div class="showcase__stack showcase__row--narrow">
				<KitSkeleton variant="heading" />
				<KitSkeleton variant="text" :rows="3" />
				<KitSkeleton variant="image" />
				<div class="showcase__row">
					<KitSkeleton variant="circle" />
					<KitSkeleton variant="button" />
				</div>
			</div>
		</section>

		<section>
			<h2>KitEmpty</h2>
			<div class="showcase__panel">
				<KitEmpty description="По вашему запросу ничего не найдено">
					<template #action>
						<KitButton variant="primary" size="small"
							>Сбросить фильтры</KitButton
						>
					</template>
				</KitEmpty>
			</div>
		</section>

		<section>
			<h2>KitLoadingOverlay</h2>
			<KitButton class="showcase__trigger" @click="demoLoading">
				Показать на 1,5 с
			</KitButton>
			<KitLoadingOverlay :loading="isLoading" label="Загружаем">
				<div class="showcase__panel">
					<p>Контент остаётся в DOM — высота блока не прыгает.</p>
					<p>Клики под вуалью перехватываются.</p>
					<KitButton variant="primary">Кнопка под вуалью</KitButton>
				</div>
			</KitLoadingOverlay>
		</section>
	</div>
</template>

<style scoped>
.showcase {
	max-width: 1000px;
	margin: 0 auto;
	padding: var(--kit-spacing-xl) var(--kit-spacing-lg) var(--kit-spacing-4xl);
	color: var(--kit-color-text-primary);
}

.showcase__note {
	color: var(--kit-color-text-muted);
	font-size: var(--kit-font-size-sm);
}

.showcase section {
	margin-top: var(--kit-spacing-2xl);
	padding-top: var(--kit-spacing-lg);
	border-top: var(--kit-border-width-thin) solid var(--kit-color-border-secondary);
}

.showcase h2 {
	margin: 0 0 var(--kit-spacing-lg);
	font-size: var(--kit-font-size-xl);
	color: var(--kit-color-text-heading);
}

.showcase__row {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: var(--kit-spacing-md);
	margin-bottom: var(--kit-spacing-md);
}

.showcase__row--narrow {
	max-width: 320px;
}

.showcase__stack {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
}

.showcase__grid {
	border-collapse: collapse;
}

.showcase__grid th,
.showcase__grid td {
	padding: var(--kit-spacing-sm) var(--kit-spacing-md);
	text-align: left;
	font-weight: var(--kit-font-weight-normal);
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.showcase__panel {
	padding: var(--kit-spacing-lg);
	border: var(--kit-border-width-thin) solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-lg);
	background: var(--kit-color-bg-secondary);
}

.showcase__trigger {
	margin-bottom: var(--kit-spacing-md);
}
</style>
