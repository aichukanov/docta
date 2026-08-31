<script lang="ts">
/**
 * Реальные размеры оригиналов из public/img/articles.
 *
 * Читать их в рантайме неоткуда (файлы лежат в public/, а не в сборке), а без
 * width/height обложка до загрузки имеет нулевую высоту и весь текст под ней
 * уезжает вниз — это CLS на всех 18 статьях. Соотношения сторон у картинок
 * разные (1.49–2.01), одним общим aspect-ratio не закрыть, поэтому размеры
 * зафиксированы поштучно.
 *
 * Ключ — имя файла без расширения. Новая статья без записи здесь просто
 * останется без размеров и srcset — деградация, а не поломка.
 */
export const ARTICLE_IMAGE_SIZES: Record<
	string,
	{ width: number; height: number }
> = {
	'allergy-medicines-in-montenegro': { width: 1024, height: 559 },
	'birth-in-montenegro': { width: 1264, height: 841 },
	'child-healthcare-in-montenegro': { width: 1264, height: 848 },
	'clinics-with-language-support': { width: 1536, height: 1024 },
	'dentistry-in-montenegro': { width: 1264, height: 848 },
	'health-insurance-for-residence-permit': { width: 1376, height: 768 },
	'healthcare-in-bar': { width: 1408, height: 768 },
	'healthcare-in-budva': { width: 1408, height: 768 },
	'healthcare-in-kotor': { width: 1408, height: 768 },
	'healthcare-in-podgorica': { width: 1408, height: 768 },
	'healthcare-system-in-montenegro': { width: 1264, height: 832 },
	'lab-tests-and-checkups': { width: 1264, height: 848 },
	'medications-not-available-in-montenegro': { width: 1024, height: 572 },
	'mental-health-in-montenegro': { width: 1376, height: 768 },
	'pharmacies-and-medications': { width: 1264, height: 848 },
	'russian-speaking-doctors': { width: 1536, height: 1024 },
	'tourist-healthcare-in-montenegro': { width: 1376, height: 684 },
	'weekend-medical-help-in-montenegro': { width: 1376, height: 768 },
};

/**
 * Ширины деривативов, лежащих рядом с оригиналом как `<имя>-<ширина>.webp`
 * (сгенерированы sharp'ом). Оригиналы до 1536 px отдавались в слоты ~380 px —
 * это 2.4 МБ на списке статей; с srcset браузер берёт 400w и это 0.4 МБ.
 */
const ARTICLE_IMAGE_DERIVATIVE_WIDTHS = [400, 800, 1200];

const getArticleImageKey = (src: string) =>
	src.replace(/^.*\//, '').replace(/\.webp$/, '');

export function getArticleImageSize(src: string) {
	return ARTICLE_IMAGE_SIZES[getArticleImageKey(src)] ?? null;
}

/**
 * srcset из деривативов, которые уже оригинала, плюс сам оригинал последним
 * кандидатом.
 * Без записи в ARTICLE_IMAGE_SIZES возвращает undefined — тогда картинка
 * отдаётся как раньше, одним файлом.
 */
export function buildArticleImageSrcSet(src: string): string | undefined {
	const size = getArticleImageSize(src);
	if (!size) return undefined;

	const base = src.replace(/\.webp$/, '');
	const candidates = ARTICLE_IMAGE_DERIVATIVE_WIDTHS.filter(
		(width) => width < size.width,
	).map((width) => `${base}-${width}.webp ${width}w`);

	return [...candidates, `${src} ${size.width}w`].join(', ');
}
</script>

<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';
import type { BreadcrumbItem } from '~/components/app-breadcrumbs.vue';

export interface ArticleTocItem {
	id: string;
	label: string;
	count?: number;
}

export interface ArticleCta {
	title: string;
	text: string;
	button: string;
	link: RouteLocationRaw;
}

const props = defineProps<{
	breadcrumbs: BreadcrumbItem[];
	title: string;
	meta?: string;
	description: string;
	image: string;
	toc?: ArticleTocItem[];
	cta?: ArticleCta;
}>();

const { t } = useI18n({ useScope: 'local' });

// Обложка идёт сразу под h1 на всю ширину контейнера и почти всегда является
// LCP-элементом: eager + fetchpriority, иначе загрузка откладывается до
// layout-прохода. Ширина контейнера — 800 px минус боковые отступы.
const coverSize = computed(() => getArticleImageSize(props.image));
const coverSrcSet = computed(() => buildArticleImageSrcSet(props.image));
</script>

<template>
	<div class="article-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbs" />

			<h1>{{ title }}</h1>

			<p v-if="meta" class="article-meta">{{ meta }}</p>

			<p class="description">{{ description }}</p>

			<div class="article-image">
				<img
					:src="image"
					:srcset="coverSrcSet"
					sizes="(max-width: 848px) calc(100vw - 48px), 752px"
					:alt="title"
					:width="coverSize?.width"
					:height="coverSize?.height"
					fetchpriority="high"
				/>
			</div>

			<nav
				v-if="toc && toc.length > 1"
				class="article-toc"
				:aria-label="t('AriaToc')"
			>
				<a
					v-for="item in toc"
					:key="item.id"
					:href="`#${item.id}`"
					class="toc-chip"
				>
					{{ item.label }}
					<span v-if="item.count != null" class="toc-count">
						{{ item.count }}
					</span>
				</a>
			</nav>

			<div class="article-body">
				<slot />
			</div>

			<div v-if="cta" class="article-cta">
				<div class="article-cta__text">
					<h3>{{ cta.title }}</h3>
					<p>{{ cta.text }}</p>
				</div>
				<NuxtLink :to="cta.link" class="article-cta__button">
					{{ cta.button }} →
				</NuxtLink>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.article-page {
	padding: var(--kit-spacing-xl) 0 var(--kit-spacing-3xl);

	h1 {
		margin: var(--kit-spacing-lg) 0 var(--kit-spacing-sm);
		font-size: var(--kit-font-size-4xl);
		font-weight: var(--kit-font-weight-bold);
		letter-spacing: -0.02em;
		line-height: 1.2;
		color: var(--kit-color-text-heading);
	}
}

.container {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 var(--kit-spacing-lg);
}

.article-meta {
	margin: 0 0 var(--kit-spacing-lg);
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.description {
	margin: 0 0 var(--kit-spacing-xl);
	font-size: var(--kit-font-size-lg);
	line-height: 1.7;
	color: var(--kit-color-text-secondary);
}

.article-image {
	margin-bottom: var(--kit-spacing-2xl);
	border-radius: var(--kit-border-radius-xl);
	overflow: hidden;

	img {
		display: block;
		width: 100%;
		height: auto;
	}
}

.article-toc {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-sm);
	margin-bottom: var(--kit-spacing-3xl);
}

.toc-chip {
	display: inline-flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
	padding: var(--kit-spacing-sm) var(--kit-spacing-lg);
	background: var(--kit-color-bg-tertiary);
	border-radius: 999px;
	text-decoration: none;
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-text-secondary);
	transition:
		background var(--kit-transition-base),
		color var(--kit-transition-base);

	&:hover {
		background: var(--kit-color-primary-bg);
		color: var(--kit-color-primary);
	}

	&:focus-visible {
		outline: 2px solid var(--kit-color-primary);
		outline-offset: 2px;
	}
}

.toc-count {
	// var(--kit-color-text-muted) на сером фоне чипа даёт ~4.34:1 — ниже порога WCAG AA (4.5:1)
	color: var(--kit-color-text-secondary);
	font-weight: var(--kit-font-weight-normal);
}

.article-body {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-3xl);
}

.article-cta {
	margin-top: var(--kit-spacing-3xl);
	padding: var(--kit-spacing-xl) var(--kit-spacing-2xl);
	border-radius: var(--kit-border-radius-xl);
	background: var(--kit-color-bg-tips);
	border: 1px solid var(--kit-color-border-accent);
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-xl);
	flex-wrap: wrap;

	&__text {
		h3 {
			margin: 0 0 var(--kit-spacing-xs);
			font-size: var(--kit-font-size-lg);
			font-weight: var(--kit-font-weight-semibold);
			color: var(--kit-color-text-heading);
		}

		p {
			margin: 0;
			font-size: var(--kit-font-size-sm);
			color: var(--kit-color-text-secondary);
		}
	}

	&__button {
		flex: none;
		padding: var(--kit-spacing-md) var(--kit-spacing-xl);
		border-radius: var(--kit-border-radius-md);
		background: var(--kit-color-primary);
		color: var(--kit-color-bg-primary);
		font-size: var(--kit-font-size-sm);
		font-weight: var(--kit-font-weight-medium);
		text-decoration: none;
		transition: background var(--kit-transition-base);

		&:hover {
			background: var(--kit-color-primary-dark);
		}

		&:focus-visible {
			outline: 2px solid var(--kit-color-primary-dark);
			outline-offset: 2px;
		}
	}
}
</style>

<style src="~/assets/css/article-prose.less" lang="less"></style>

<i18n lang="json">
{
	"en": {
		"AriaToc": "Article contents"
	},
	"ru": {
		"AriaToc": "Содержание статьи"
	},
	"sr": {
		"AriaToc": "Sadržaj članka"
	},
	"sr-cyrl": {
		"AriaToc": "Садржај чланка"
	},
	"de": {
		"AriaToc": "Inhalt des Artikels"
	},
	"tr": {
		"AriaToc": "Makale içeriği"
	}
}
</i18n>
