<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import {
	locales,
	localeNames,
	localeShortNames,
	type Locale,
} from '~/composables/use-locale';

defineProps<{
	smaller?: boolean;
}>();

const router = useRouter();
const route = useRoute();
const { fetchUser } = useUserStore();
const { locale } = useI18n({ useScope: 'global' });
const { t } = useI18n();

const cookieLocale = useCookie<string>('locale', {
	maxAge: 1000 * 60 * 60 * 24 * 365,
});

const isExpanded = ref(false);
const triggerRef = ref<HTMLElement>();

function getLocalePath(lang: Locale) {
	const { lang: _removed, ...restQuery } = route.query;
	return {
		path: route.path,
		query: { ...restQuery, ...getRegionalQuery(lang) },
	};
}

function toggle() {
	isExpanded.value = !isExpanded.value;
}

function close() {
	isExpanded.value = false;
}

async function handleLangClick(lang: Locale) {
	close();

	locale.value = lang;
	cookieLocale.value = lang;

	router.replace(getLocalePath(lang));

	const user = await fetchUser();
	if (user) {
		try {
			await $fetch('/api/auth/update-locale', {
				method: 'POST',
				body: { locale: lang },
			});
		} catch (error) {
			console.error('Failed to update user locale:', error);
		}
	}
}

function onClickOutside(e: MouseEvent) {
	if (triggerRef.value && !triggerRef.value.contains(e.target as Node)) {
		close();
	}
}

onMounted(() => document.addEventListener('click', onClickOutside));
onBeforeUnmount(() => document.removeEventListener('click', onClickOutside));
</script>

<template>
	<div
		ref="triggerRef"
		class="language-switcher"
		:class="{ 'language-switcher--small': smaller }"
	>
		<button
			class="language-switcher__trigger"
			type="button"
			:aria-label="t('LanguageSelector')"
			:aria-expanded="isExpanded"
			aria-haspopup="menu"
			@click="toggle"
		>
			<span class="language-switcher__label">
				{{ localeShortNames[locale as Locale] }}
			</span>
			<span
				class="language-switcher__arrow"
				:class="{ 'language-switcher__arrow--up': isExpanded }"
			/>
		</button>

		<ul
			v-show="isExpanded"
			class="language-switcher__dropdown"
			role="menu"
			:aria-label="t('LanguageSelector')"
		>
			<li v-for="lang in locales" :key="lang" role="none">
				<NuxtLink
					:to="getLocalePath(lang)"
					:hreflang="lang"
					role="menuitem"
					class="language-switcher__option"
					:class="{ 'language-switcher__option--active': locale === lang }"
					:aria-label="localeNames[lang]"
					:aria-current="locale === lang ? 'true' : undefined"
					@click.prevent="handleLangClick(lang)"
				>
					{{ localeNames[lang] }}
				</NuxtLink>
			</li>
		</ul>
	</div>
</template>

<style lang="less" scoped>
.language-switcher {
	position: relative;
	width: 80px;

	&--small {
		width: 70px;

		.language-switcher__trigger {
			padding: var(--spacing-xs) var(--spacing-sm);
			font-size: var(--font-size-sm);
		}
	}

	&__trigger {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		padding: var(--spacing-sm) var(--spacing-md);
		background: var(--color-bg-primary);
		border: var(--border-width-thin) solid var(--color-border-primary);
		border-radius: var(--border-radius-md);
		cursor: pointer;
		font-size: var(--font-size-base);
		color: var(--color-text-primary);
		transition: border-color var(--transition-fast);

		&:hover {
			border-color: var(--color-primary);
		}
	}

	&__arrow {
		width: 0;
		height: 0;
		margin-left: var(--spacing-xs);
		border-left: 4px solid transparent;
		border-right: 4px solid transparent;
		border-top: 5px solid var(--color-text-muted);
		transition: transform var(--transition-fast);

		&--up {
			transform: rotate(180deg);
		}
	}

	&__dropdown {
		position: absolute;
		top: calc(100% + 4px);
		right: 0;
		margin: 0;
		padding: var(--spacing-xs) 0;
		list-style: none;
		background: var(--color-bg-primary);
		border: var(--border-width-thin) solid var(--color-border-secondary);
		border-radius: var(--border-radius-md);
		box-shadow: var(--shadow-lg);
		z-index: var(--z-dropdown);
		min-width: 180px;
	}

	&__option {
		display: block;
		padding: var(--spacing-sm) var(--spacing-md);
		color: var(--color-text-primary);
		text-decoration: none;
		font-size: var(--font-size-base);
		white-space: nowrap;
		transition: background var(--transition-fast);

		&:hover {
			background: var(--color-bg-tertiary);
		}

		&--active {
			color: var(--color-primary);
			font-weight: var(--font-weight-medium);
		}
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"LanguageSelector": "Select language",
		"Language": "Language"
	},
	"ru": {
		"LanguageSelector": "Выберите язык",
		"Language": "Язык"
	},
	"sr": {
		"LanguageSelector": "Izaberite jezik",
		"Language": "Jezik"
	},
	"sr-cyrl": {
		"LanguageSelector": "Изберете језик",
		"Language": "Језик"
	},
	"de": {
		"LanguageSelector": "Sprache auswählen",
		"Language": "Sprache"
	},
	"tr": {
		"LanguageSelector": "Dil seçin",
		"Language": "Dil"
	}
}
</i18n>
