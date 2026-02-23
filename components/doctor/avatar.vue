<script setup lang="ts">
import { generateAvatarColor } from '~/common/avatar-colors';

const props = withDefaults(
	defineProps<{
		name: string;
		photoUrl?: string | null;
		size: number;
		class?: string;
	}>(),
	{
		photoUrl: null,
		class: '',
	},
);

const customClass = computed(() => props.class || '');

function letterAvatarUrl(name: string, size: number) {
	const bg = generateAvatarColor(name).substring(1);
	return `https://ui-avatars.com/api/?name=${encodeURIComponent(
		name,
	)}&size=${size}&background=${bg}&color=ffffff&font-size=0.4`;
}

const avatarUrl = ref(
	props.photoUrl?.trim()
		? props.photoUrl
		: letterAvatarUrl(props.name, props.size),
);

watch(
	() => props.photoUrl,
	(url) => {
		avatarUrl.value = url?.trim()
			? url
			: letterAvatarUrl(props.name, props.size);
	},
);

function onError() {
	avatarUrl.value = letterAvatarUrl(props.name, props.size);
}

const mounted = ref(false);
onMounted(() => {
	mounted.value = true;
});
</script>

<template>
	<img
		:src="avatarUrl"
		:alt="name"
		:class="`doctor-avatar ${customClass}`"
		:width="size"
		:height="size"
		:referrerpolicy="mounted ? 'no-referrer' : undefined"
		@error="onError"
	/>
</template>

<style scoped>
.doctor-avatar {
	border-radius: 10%;
	object-fit: contain;
	background-color: white;
	flex-shrink: 0;
}
</style>
