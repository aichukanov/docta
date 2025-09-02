<template>
	<el-button
		:title="isCopied ? t('Copied') : t('CopyNumber')"
		:class="isCopied ? 'copy-button copied' : 'copy-button'"
		@click="copyToClipboard"
	>
		<template #icon>
			<IconCheck v-if="isCopied" :size="14" color="var(--color-success)" />
			<IconCopy v-else :size="14" color="var(--color-text-secondary)" />
		</template>
	</el-button>
</template>

<script setup lang="ts">
const props = defineProps<{
	phoneNumber: string;
}>();

const { t } = useI18n();

const isCopied = ref(false);

async function copyToClipboard(): Promise<void> {
	try {
		await navigator.clipboard.writeText(props.phoneNumber);
		isCopied.value = true;

		setTimeout(() => {
			isCopied.value = false;
		}, 2000);
	} catch (err) {
		console.error('Failed to copy to clipboard:', err);
	}
}
</script>

<style scoped>
.copy-button {
	min-width: 16px;
	width: 16px;
	height: 16px;
	padding: 0;
	border: none;
}

.copy-button:hover {
	background: var(--color-bg-secondary);
}

@media (max-width: 768px) {
	.copy-button {
		width: 28px;
		height: 28px;
		min-width: 28px;
	}
}
</style>

<i18n>
{
	"en": {
		"Copied": "Copied",
		"CopyNumber": "Copy Number"
	},
	"sr": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj broj"
	},
	"me": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj broj"
	},
	"ba": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj broj"
	},
	"ru": {
		"Copied": "Скопировано",
		"CopyNumber": "Скопировать номер"
	},
	"de": {
		"Copied": "Kopiert",
		"CopyNumber": "Nummer kopieren"
	},
	"tr": {
		"Copied": "Kopyalandı",
		"CopyNumber": "Numarayı kopyala"
	}
}
</i18n>
