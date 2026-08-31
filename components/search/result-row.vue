<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';

// Одна строка выдачи глобального поиска — общий каркас для всех категорий
// (специальности, врачи, клиники, услуги, лекарства, анализы). Каркас один,
// потому что рядом в дропдауне они должны читаться как один список.
//
// Ссылка не оборачивает строку целиком: у лекарств под ней идут ссылки на
// формы (слот footer), а вложенные <a> невалидны. Поэтому ссылка — блок
// внутри строки, а footer живёт рядом с ней.
const props = defineProps<{
	to: RouteLocationRaw;
	title: string;
	// Запрос — по нему подсвечиваются название, подзаголовок и подпись-причина
	query?: string;
	subtitle?: string | null;
	// Подсвечивать совпадение и в подзаголовке — только там, где подзаголовок
	// объясняет попадание в выдачу (вещество препарата, вывеска клиники).
	// У категорий услуг/анализов подсветка была бы шумом: они не участвуют
	// в поиске, совпадение подстроки там случайное.
	highlightSubtitle?: boolean;
	// Уточнения через «·»: форма/дозировка, город, число клиник
	meta?: (string | null | undefined)[];
	// Вторая строка уточнений (производитель, адрес) — мельче и бледнее
	metaSecondary?: (string | null | undefined)[];
	// Подпись «почему это в выдаче»: ярлык + значение (значение подсвечивается)
	hintLabel?: string | null;
	hintValue?: string | null;
}>();

const emit = defineEmits<{ (e: 'navigate'): void }>();

// Уточнения склеиваем в одну строку, а не рендерим элементами с разделителем
// через ::before: разделитель тогда мог начать перенесённую строку («· 500 мг»).
// В разделителе перед точкой стоит НЕРАЗРЫВНЫЙ пробел — он привязывает точку
// к предыдущему уточнению, и перенос всегда приходится на пробел после неё.
const META_SEPARATOR = '\u00a0\u00b7 ';

const joinMeta = (items?: (string | null | undefined)[]): string =>
	(items || []).filter((item): item is string => !!item).join(META_SEPARATOR);

const metaText = computed(() => joinMeta(props.meta));
const metaSecondaryText = computed(() => joinMeta(props.metaSecondary));
</script>

<template>
	<div class="search-row">
		<NuxtLink :to="to" class="search-row__link" @click="emit('navigate')">
			<span v-if="$slots.icon" class="search-row__icon">
				<slot name="icon" />
			</span>
			<span class="search-row__body">
				<span class="search-row__head">
					<span class="search-row__title">
						<SearchHighlight :text="title" :query="query" /><slot
							name="badge"
						/>
					</span>
					<span v-if="$slots.aside" class="search-row__aside">
						<slot name="aside" />
					</span>
				</span>

				<span v-if="subtitle" class="search-row__subtitle">
					<SearchHighlight
						:text="subtitle"
						:query="highlightSubtitle ? query : ''"
					/>
				</span>

				<span v-if="metaText" class="search-row__meta">{{ metaText }}</span>

				<span v-if="metaSecondaryText" class="search-row__meta-secondary">{{
					metaSecondaryText
				}}</span>

				<span v-if="hintValue" class="search-row__hint">
					<span v-if="hintLabel" class="search-row__hint-label"
						>{{ hintLabel }}:</span
					>
					<SearchHighlight :text="hintValue" :query="query" />
				</span>
			</span>
		</NuxtLink>

		<div v-if="$slots.footer" class="search-row__footer">
			<slot name="footer" />
		</div>
	</div>
</template>

<style lang="less" scoped>
// Размер иконки задан переменной: ею же выравнивается footer (ссылки на формы)
// по левому краю текста строки.
.search-row {
	--search-row-icon: 40px;
	--search-row-inset: var(--kit-spacing-lg);

	transition: background var(--kit-transition-fast);

	// Фон наведения — на всей строке, а не на ссылке внутри: ярлыки форм
	// (слот footer) лежат рядом со ссылкой, и подсветка только её обрывалась
	// перед ними, будто карточка обрезана.
	&:hover {
		background: var(--kit-color-bg-secondary);
	}

	&__link {
		display: flex;
		align-items: flex-start;
		gap: var(--kit-spacing-md);
		padding: var(--kit-spacing-md) var(--search-row-inset);
		text-decoration: none;
		color: inherit;
	}

	&__icon {
		display: flex;
		align-items: center;
		justify-content: center;
		flex: 0 0 var(--search-row-icon);
		width: var(--search-row-icon);
		height: var(--search-row-icon);
		border-radius: var(--kit-border-radius-lg);
		background: var(--kit-color-primary-bg);
		color: var(--kit-color-primary);
		overflow: hidden;

		// Размер задаём здесь, а не пропом иконки: часть icon-компонентов
		// (IconLightbulb и другие из навигации) пропа size не имеет и
		// размеряется CSS вызывающего — без этого правила такая иконка
		// растягивалась на всю строку
		:deep(svg) {
			width: 20px;
			height: 20px;
		}
	}

	&__body {
		display: block;
		flex: 1;
		min-width: 0;
	}

	&__head {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		gap: var(--kit-spacing-sm);
	}

	&__title {
		font-size: var(--kit-font-size-base);
		font-weight: var(--kit-font-weight-semibold);
		line-height: 1.3;
		color: var(--kit-color-text-heading);
		overflow-wrap: anywhere;

		// Бейдж рецептурности приходит слотом badge
		:deep(.medicine-badge) {
			margin-left: var(--kit-spacing-sm);
			vertical-align: 1px;
		}
	}

	&__aside {
		flex: 0 0 auto;
		white-space: nowrap;
		font-size: var(--kit-font-size-sm);
		font-weight: var(--kit-font-weight-semibold);
		color: var(--kit-color-text-heading);
	}

	&__subtitle {
		display: block;
		margin-top: 2px;
		font-size: var(--kit-font-size-sm);
		color: var(--kit-color-text-secondary);
	}

	&__meta,
	&__meta-secondary {
		display: block;
		margin-top: var(--kit-spacing-xs);
		color: var(--kit-color-text-muted);
	}

	&__meta {
		font-size: var(--kit-font-size-sm);
	}

	&__meta-secondary {
		font-size: var(--kit-font-size-xs);
	}

	&__hint {
		display: flex;
		flex-wrap: wrap;
		gap: 0 var(--kit-spacing-xs);
		margin-top: var(--kit-spacing-xs);
		font-size: var(--kit-font-size-sm);
		color: var(--kit-color-text-secondary);
	}

	&__hint-label {
		color: var(--kit-color-text-muted);
	}

	&__footer {
		display: flex;
		flex-wrap: wrap;
		gap: var(--kit-spacing-xs);
		padding: 0 var(--search-row-inset) var(--kit-spacing-md)
			calc(var(--search-row-icon) + var(--kit-spacing-md) + var(--search-row-inset));
	}
}

@media (max-width: 640px) {
	.search-row {
		--search-row-icon: 36px;
		--search-row-inset: var(--kit-spacing-md);

		// На узком экране цена/рейтинг переносятся под название, а не сжимают
		// его до переноса по буквам
		&__head {
			flex-wrap: wrap;
		}
	}
}
</style>
