<script setup lang="ts">
const props = defineProps<{
	code?: number;
	title?: string;
	message?: string;
}>();

const { t } = useI18n();
</script>

<template>
	<div class="error-inline">
		<div class="error-inline__code" v-if="props.code">{{ props.code }}</div>
		<div class="error-inline__title">{{
			props.title || t('ErrorGenericTitle')
		}}</div>
		<p v-if="props.message" class="error-inline__message">{{
			props.message
		}}</p>
	</div>
</template>

<i18n lang="json">
{
	"ru": { "ErrorGenericTitle": "Произошла ошибка" },
	"en": { "ErrorGenericTitle": "Something went wrong" },
	"sr": { "ErrorGenericTitle": "Nešto je pošlo po zlu" },
	"ba": { "ErrorGenericTitle": "Nešto je pošlo po zlu" },
	"me": { "ErrorGenericTitle": "Nešto je pošlo po zlu" }
}
</i18n>

<style scoped>
.error-inline {
	border: 1px solid var(--color-border-secondary, #e5e7eb);
	border-radius: 8px;
	padding: 16px;
	background: #fff;
	text-align: center;
}
.error-inline__code {
	font-size: 32px;
	font-weight: 800;
	color: var(--color-primary, #4f46e5);
	margin-bottom: 8px;
}
.error-inline__title {
	font-weight: 700;
}
.error-inline__message {
	color: #6b7280;
	margin: 8px 0 0 0;
}
</style>
