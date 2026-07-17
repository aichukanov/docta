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

defineProps<{
	breadcrumbs: BreadcrumbItem[];
	title: string;
	meta?: string;
	description: string;
	image: string;
	toc?: ArticleTocItem[];
	cta?: ArticleCta;
}>();

const { t } = useI18n({ useScope: 'local' });
</script>

<template>
	<div class="article-page">
		<div class="container">
			<AppBreadcrumbs :items="breadcrumbs" />

			<h1>{{ title }}</h1>

			<p v-if="meta" class="article-meta">{{ meta }}</p>

			<p class="description">{{ description }}</p>

			<div class="article-image">
				<img :src="image" :alt="title" loading="lazy" />
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
	padding: var(--spacing-xl) 0 var(--spacing-3xl);

	h1 {
		margin: var(--spacing-lg) 0 var(--spacing-sm);
		font-size: var(--font-size-4xl);
		font-weight: var(--font-weight-bold);
		letter-spacing: -0.02em;
		line-height: 1.2;
		color: var(--color-text-heading);
	}
}

.container {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 var(--spacing-lg);
}

.article-meta {
	margin: 0 0 var(--spacing-lg);
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.description {
	margin: 0 0 var(--spacing-xl);
	font-size: var(--font-size-lg);
	line-height: 1.7;
	color: var(--color-text-secondary);
}

.article-image {
	margin-bottom: var(--spacing-2xl);
	border-radius: var(--border-radius-xl);
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
	gap: var(--spacing-sm);
	margin-bottom: var(--spacing-3xl);
}

.toc-chip {
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-xs);
	padding: var(--spacing-sm) var(--spacing-lg);
	background: var(--color-bg-tertiary);
	border-radius: 999px;
	text-decoration: none;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-secondary);
	transition:
		background var(--transition-base),
		color var(--transition-base);

	&:hover {
		background: var(--color-primary-bg);
		color: var(--color-primary);
	}
}

.toc-count {
	color: var(--color-text-muted);
	font-weight: var(--font-weight-normal);
}

.article-body {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-3xl);
}

.article-cta {
	margin-top: var(--spacing-3xl);
	padding: var(--spacing-xl) var(--spacing-2xl);
	border-radius: var(--border-radius-xl);
	background: var(--color-bg-tips);
	border: 1px solid var(--color-border-accent);
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-xl);
	flex-wrap: wrap;

	&__text {
		h3 {
			margin: 0 0 var(--spacing-xs);
			font-size: var(--font-size-lg);
			font-weight: var(--font-weight-semibold);
			color: var(--color-text-heading);
		}

		p {
			margin: 0;
			font-size: var(--font-size-sm);
			color: var(--color-text-secondary);
		}
	}

	&__button {
		flex: none;
		padding: var(--spacing-md) var(--spacing-xl);
		border-radius: var(--border-radius-md);
		background: var(--color-primary);
		color: var(--color-bg-primary);
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-medium);
		text-decoration: none;
		transition: background var(--transition-base);

		&:hover {
			background: var(--color-primary-dark);
		}
	}
}
</style>

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
