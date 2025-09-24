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
	value: string;
}>();

const { t } = useI18n();

const isCopied = ref(false);

async function copyToClipboard(): Promise<void> {
	try {
		await navigator.clipboard.writeText(props.value);
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
</style>

<i18n lang="json">
{
	"en": {
		"Copied": "Copied",
		"CopyNumber": "Copy"
	},
	"sr": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj"
	},
	"me": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj"
	},
	"ba": {
		"Copied": "Kopirano",
		"CopyNumber": "Kopiraj"
	},
	"ru": {
		"Copied": "Скопировано",
		"CopyNumber": "Скопировать"
	},
	"de": {
		"Copied": "Kopiert",
		"CopyNumber": "Kopieren"
	},
	"tr": {
		"Copied": "Kopyalandı",
		"CopyNumber": "Kopyala"
	}
}
</i18n>
