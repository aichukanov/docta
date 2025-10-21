<script setup lang="ts">
import { LanguageId } from '~/enums/language';
import languageI18n from '~/i18n/language';

const props = defineProps<{
	languageIds: string;
}>();

const { t } = useI18n(languageI18n);

const languagesText = computed(() => {
	return props.languageIds === LanguageId.SR.toString()
		? ''
		: props.languageIds
				?.split(',')
				.map((lang) => t(`language_${lang}`) || lang)
				.join(', ');
});
</script>

<template>
	<div v-if="languagesText" class="languages-wrapper">
		<div v-if="$slots.default" class="languages-title">
			<slot />
		</div>

		<div class="languages" :title="t('Languages')">
			<IconLanguage size="18" />
			<span class="languages-text">{{ languagesText }}</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.languages-wrapper {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);

	.languages-title {
		font-size: var(--font-size-md);
		color: var(--color-text-secondary);
	}

	.languages {
		display: flex;
		align-items: center;
		gap: var(--spacing-xs);
		flex-wrap: wrap;

		.languages-text {
			color: var(--color-primary-green);
			margin-top: -3px;
		}
	}
}
</style>
