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
	background: linear-gradient(
		135deg,
		rgba(79, 70, 229, 0.03) 0%,
		rgba(6, 182, 212, 0.02) 50%,
		rgba(245, 158, 11, 0.02) 100%
	);
	border-radius: var(--border-radius-xl);
	position: relative;
	overflow: hidden;
	box-sizing: border-box;

	@media (max-width: 500px) {
		padding: var(--spacing-lg);
		margin-top: var(--spacing-xl);
	}

	&::before {
		content: '';
		position: absolute;
		top: -50%;
		right: -20%;
		width: 300px;
		height: 300px;
		background: radial-gradient(
			circle,
			rgba(79, 70, 229, 0.04) 0%,
			transparent 70%
		);
		pointer-events: none;
	}

	&::after {
		content: '';
		position: absolute;
		bottom: -30%;
		left: -10%;
		width: 200px;
		height: 200px;
		background: radial-gradient(
			circle,
			rgba(6, 182, 212, 0.04) 0%,
			transparent 70%
		);
		pointer-events: none;
	}
}

.tips-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-lg);
	margin-bottom: var(--spacing-xl);
	position: relative;
	z-index: 1;
}

.tips-header-line {
	flex: 1;
	height: 1px;
	background: linear-gradient(
		90deg,
		transparent 0%,
		var(--color-border-secondary) 50%,
		transparent 100%
	);
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
	position: relative;
	z-index: 1;
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
