<script setup lang="ts">
import type { DoctorData } from '~/interfaces/doctor';
import languageI18n from '~/i18n/language';

const props = defineProps<{
	doctor: DoctorData;
}>();

const { t } = useI18n(languageI18n);

const languagesText = computed(() => {
	return props.doctor.languageCodes
		?.split(',')
		.map((lang) => t(lang) || lang)
		.join(', ');
});
</script>

<template>
	<div class="languages" :title="t('Languages')">
		<IconLanguage size="18" />
		<span class="languages-text">{{ languagesText }}</span>
	</div>
</template>

<style scoped lang="less">
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
</style>
