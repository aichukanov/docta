<template>
	<div
		class="search__wrapper"
		:class="[isFocused ? 'search__wrapper-focused' : null]"
		role="search"
	>
		<el-input
			ref="inputRef"
			v-model="searchString"
			size="large"
			clearable
			tabindex="0"
			:autofocus="route.name === 'search'"
			:placeholder="t('SiteSearch')"
			:aria-label="t('SiteSearch')"
			@focus="isFocused = true"
			@blur="blurFocus"
			@keydown.enter="gotoSearch()"
		>
			<template #append>
				<el-button
					:icon="Search"
					@click="gotoSearch()"
					:aria-label="t('SearchButton')"
				/>
			</template>
		</el-input>

		<KeepAlive>
			<SearchContent
				v-if="isContentVisible"
				:searchString="searchString"
				:searchResultsPath="searchResultsPath"
				id="search-content"
				role="listbox"
				:aria-label="t('SearchResults')"
			/>
		</KeepAlive>
	</div>
</template>

<script setup lang="ts">
import { Search } from '@element-plus/icons-vue';
import { refDebounced } from '@vueuse/core';
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n();
const route = useRoute();
const router = useRouter();
const { country } = useCountry();
const { locale } = useI18n({ useScope: 'global' });
const { uiCurrency } = useCurrency();

const searchString = ref<string>((route.query.text as string) || '');
const isContentDisabled = ref(false);
const isFocused = ref(false);
const inputRef = ref<{ blur: () => void }>();

const isContentVisible = computed(
	() => !isContentDisabled.value && isFocused.value,
);

if (route.name === 'search') {
	watch(refDebounced(searchString, 300), (text) => {
		router.push({
			name: 'search',
			query: Object.assign(
				{
					text,
				},
				getRegionalQuery(country.value, locale.value, uiCurrency.value),
			),
		});
	});

	isContentDisabled.value = true;
}

const searchResultsPath = computed(() => ({
	name: 'search',
	query: Object.assign(
		{
			text: searchString.value.trim(),
		},
		getRegionalQuery(country.value, locale.value, uiCurrency.value),
	),
}));

function gotoSearch() {
	router.push(searchResultsPath.value);
}

function blurFocus(evt: FocusEvent) {
	const target = evt.relatedTarget as HTMLElement;
	if (target?.classList.contains('search__content-link')) {
		// do nothing to prevent closing the dropdown and stop redirecting
	} else {
		isFocused.value = false;
	}
}

onMounted(() => {
	watch(router.currentRoute, async () => {
		isFocused.value = false;
	});
});
</script>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.search__wrapper {
	position: relative;
	flex-grow: 1;
	z-index: 2;

	.search-input {
		display: block;
	}

	.el-dropdown {
		display: initial;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"SiteSearch": "Site search",
		"SearchButton": "Search",
		"SearchResults": "Search results"
	},
	"ru": {
		"SiteSearch": "Поиск по сайту",
		"SearchButton": "Поиск",
		"SearchResults": "Результаты поиска"
	},
	"sr": {
		"SiteSearch": "Pretraga na sajtu",
		"SearchButton": "Pretraži",
		"SearchResults": "Rezultati pretrage"
	},
	"ba": {
		"SiteSearch": "Pretraga na sajtu",
		"SearchButton": "Pretraži",
		"SearchResults": "Rezultati pretrage"
	},
	"me": {
		"SiteSearch": "Pretraga na sajtu",
		"SearchButton": "Pretraži",
		"SearchResults": "Rezultati pretrage"
	},
	"de": {
		"SiteSearch": "Webseite durchsuchen",
		"SearchButton": "Suchen",
		"SearchResults": "Suchergebnisse"
	},
	"tr": {
		"SiteSearch": "Site araması",
		"SearchButton": "Ara",
		"SearchResults": "Arama sonuçları"
	}
}
</i18n>
