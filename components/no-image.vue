<template>
	<div class="no-image">{{ t('NoImage') }}</div>
</template>

<script setup lang="ts">
const { t } = useI18n();
</script>

<style lang="less" scoped>
@base-offset: 8px;
@gray-color: #bbb8b8;
@light-gray-color: var(--el-card-border-color);

.no-image {
	display: flex;
	width: 100%;
	height: 200px;
	flex-grow: 1;
	justify-content: center;
	align-items: center;
	border-radius: @base-offset;
	border: 1px solid @light-gray-color;
	color: @gray-color;
	user-select: none;
	box-sizing: border-box;
}
</style>

<i18n lang="json">
{
	"en": {
		"NoImage": "No image"
	},
	"ru": {
		"NoImage": "Нет фото"
	},
	"sr": {
		"NoImage": "Nema slike"
	},
	"ba": {
		"NoImage": "Nema slike"
	},
	"me": {
		"NoImage": "Nema slike"
	},
	"de": {
		"NoImage": "Kein Bild"
	},
	"tr": {
		"NoImage": "Resim yok"
	}
}
</i18n>
