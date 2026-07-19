<template>
	<div class="insurance-branch-marker" aria-hidden="true">
		<IconMapPin :size="20" color="white" />
	</div>
</template>

<style scoped>
.insurance-branch-marker {
	position: absolute;
	width: 40px;
	height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	transform: translate(-50%, -50%);
	z-index: 1000;
	background: var(--color-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
	transition: all 0.2s ease;
}

.insurance-branch-marker:hover {
	transform: translate(-50%, -50%) scale(1.1);
	z-index: 1001;
}
</style>
