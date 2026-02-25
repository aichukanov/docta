<script setup lang="ts">
import {
	defaultLocale,
	localeNames,
	localeShortNames,
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

async function updateLocale(value: string) {
	locale.value = value;
	cookieLocale.value = value;

	const user = await fetchUser();

	if (user) {
		try {
			await $fetch('/api/auth/update-locale', {
				method: 'POST',
				body: { locale: value },
			});
		} catch (error) {
			console.error('Failed to update user locale:', error);
		}
	}

	router.replace({
		query: {
			...route.query,
			lang:
				locale.value === defaultLocale
					? undefined
					: formatLocaleAsQuery(locale.value),
		},
	});
}

function handleVisibleChange(visible: boolean) {
	isExpanded.value = visible;
}
</script>

<template>
	<div
		class="language-switcher-wrapper"
		role="group"
		:aria-label="t('LanguageSelector')"
	>
		<el-select
			:size="smaller ? 'default' : 'large'"
			:modelValue="locale"
			@update:modelValue="updateLocale($event)"
			@visible-change="handleVisibleChange"
			:aria-label="t('LanguageSelector')"
			role="combobox"
			:aria-expanded="isExpanded"
		>
			<el-option
				v-for="value in locales"
				:key="value"
				:label="localeShortNames[value]"
				:value="value"
				role="option"
				:aria-selected="locale === value"
				:aria-label="localeNames[value]"
			>
				{{ localeNames[value] }}
			</el-option>
		</el-select>
	</div>
</template>

<style lang="less" scoped>
.language-switcher-wrapper {
	width: 80px;
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
