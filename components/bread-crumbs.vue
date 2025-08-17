<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';

const { t } = useI18n({ useScope: 'global' });
const { t: $t } = useI18n();
const route = useRoute();

interface BreadcrumbsItem {
	text: string;
	link?: RouteLocationRaw;
}

const { getArticleLink } = useRouteUtils();

const breadcrumbs = computed(() => {
	const items: BreadcrumbsItem[] = [
		{ text: t('index'), link: getArticleLink('index') },
	];

	const menuName = route.params.menuName as string;
	if (menuName) {
		items.push({ text: t(menuName), link: getArticleLink(menuName) });

		const subMenuName = route.params.subMenuName as string;
		if (subMenuName) {
			items.push({
				text: t(subMenuName),
				link: getArticleLink(`${menuName}-${subMenuName}`),
			});

			const categoryName = route.params.categoryName as string;
			if (categoryName) {
				items.push({
					text: t(categoryName),
					link: getArticleLink(`${menuName}-${subMenuName}-${categoryName}`),
				});
			}
		}
	}

	return items;
});
</script>

<template>
	<nav class="breadcrumbs-navigation" :aria-label="$t('BreadcrumbNavigation')">
		<el-breadcrumb separator="/">
			<el-breadcrumb-item v-for="(item, index) in breadcrumbs" :key="index">
				<NuxtLink :to="item.link">
					{{ item.text }}
				</NuxtLink>
			</el-breadcrumb-item>
			<el-breadcrumb-item v-if="route.params.articleId" v-show="false" />
		</el-breadcrumb>
	</nav>
</template>

<style lang="less">
@base-offset: 8px;

.breadcrumbs-navigation {
	padding: 2 * @base-offset;
	text-transform: uppercase;

	.el-breadcrumb {
		line-height: 24px;
	}

	.el-breadcrumb__inner a,
	.el-breadcrumb__inner.is-link {
		font-weight: initial;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"BreadcrumbNavigation": "Breadcrumb navigation"
	},
	"ru": {
		"BreadcrumbNavigation": "Навигационная цепочка"
	},
	"sr": {
		"BreadcrumbNavigation": "Navigaciona traka"
	},
	"me": {
		"BreadcrumbNavigation": "Navigaciona traka"
	},
	"ba": {
		"BreadcrumbNavigation": "Navigaciona traka"
	},
	"de": {
		"BreadcrumbNavigation": "Brotkrumennavigation"
	},
	"tr": {
		"BreadcrumbNavigation": "Gezinme yolu"
	}
}
</i18n>
