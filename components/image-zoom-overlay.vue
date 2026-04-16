<script setup lang="ts">
defineProps<{
	src: string;
	alt: string;
}>();

const visible = defineModel<boolean>({ default: false });

function onKeydown(e: KeyboardEvent) {
	if (e.key === 'Escape') visible.value = false;
}

watch(visible, (open) => {
	if (open) {
		document.addEventListener('keydown', onKeydown);
		document.body.style.overflow = 'hidden';
	} else {
		document.removeEventListener('keydown', onKeydown);
		document.body.style.overflow = '';
	}
});

onBeforeUnmount(() => {
	document.removeEventListener('keydown', onKeydown);
	document.body.style.overflow = '';
});
</script>

<template>
	<Teleport to="body">
		<Transition name="image-zoom">
			<div
				v-if="visible"
				class="image-zoom-overlay"
				@click="visible = false"
			>
				<img
					:src="src"
					:alt="alt"
					class="image-zoom-image"
					@click.stop
				/>
			</div>
		</Transition>
	</Teleport>
</template>

<style scoped>
.image-zoom-overlay {
	position: fixed;
	inset: 0;
	z-index: 9999;
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(0, 0, 0, 0.7);
	backdrop-filter: blur(4px);
	cursor: zoom-out;
	padding: 24px;
}

.image-zoom-image {
	max-width: min(90vw, 600px);
	max-height: 85vh;
	border-radius: 8px;
	object-fit: contain;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

.image-zoom-enter-active,
.image-zoom-leave-active {
	transition: opacity 0.2s ease;
}

.image-zoom-enter-from,
.image-zoom-leave-to {
	opacity: 0;
}
</style>
