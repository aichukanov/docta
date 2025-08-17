<template>
	<div
		class="image-wrapper"
		:style="{
			'width': width,
			'min-width': width,
			'max-width': width,
			'height': height,
		}"
		role="img"
		:aria-label="alt"
	>
		<div
			class="image"
			:style="{
				'--img-src': `url('${src}')`,
			}"
		/>
	</div>
</template>

<script setup lang="ts">
defineProps({
	src: { type: String, required: true },
	width: { type: String },
	height: { type: String },
	alt: { type: String },
});
</script>

<style lang="less" scoped>
.image-wrapper {
	display: flex;
	justify-content: center;
	align-items: center;

	.image {
		height: 100%;
		width: 100%;
		background-size: contain;
		background-repeat: no-repeat;
		background-position: center center;
		background-image: var(--img-src);
	}
}
</style>
