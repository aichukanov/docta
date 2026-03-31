<script setup lang="ts">
const { t } = useI18n({ useScope: 'local' });
</script>

<template>
	<aside class="tips-section" :aria-label="t('AriaTipsSection')">
		<div class="tips-header">
			<div class="tips-header-line"></div>
			<h3 class="tips-title">{{ t('TipsTitle') }}</h3>
			<div class="tips-header-line"></div>
		</div>
		<div class="tips-grid">
			<slot />
		</div>
	</aside>
</template>

<style lang="less" scoped>
.tips-section {
	margin-top: var(--spacing-3xl);
	padding: var(--spacing-2xl);
	border-radius: var(--border-radius-xl);
	box-sizing: border-box;

	@media (max-width: 500px) {
		padding: var(--spacing-lg);
		margin-top: var(--spacing-xl);
	}
}

.tips-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-lg);
	margin-bottom: var(--spacing-xl);
}

.tips-header-line {
	flex: 1;
	height: 1px;
	background: var(--color-border-secondary);
}

.tips-title {
	margin: 0;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-secondary);
	text-transform: uppercase;
	letter-spacing: 0.08em;

	@media (max-width: 400px) {
		font-size: var(--font-size-md);
		text-align: center;
	}
}

.tips-grid {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}
</style>

<i18n lang="json">
{
	"en": {
		"AriaTipsSection": "Useful tips",
		"TipsTitle": "Useful tips"
	},
	"ru": {
		"AriaTipsSection": "Полезные советы",
		"TipsTitle": "Полезные советы"
	},
	"sr": {
		"AriaTipsSection": "Korisni saveti",
		"TipsTitle": "Korisni saveti"
	},
	"sr-cyrl": {
		"AriaTipsSection": "Корисни савети",
		"TipsTitle": "Корисни савети"
	},
	"de": {
		"AriaTipsSection": "Nützliche Tipps",
		"TipsTitle": "Nützliche Tipps"
	},
	"tr": {
		"AriaTipsSection": "Faydalı ipuçları",
		"TipsTitle": "Faydalı ipuçları"
	}
}
</i18n>
