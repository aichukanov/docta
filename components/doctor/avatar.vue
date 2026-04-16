<script setup lang="ts">
import { generateAvatarColor } from '~/common/avatar-colors';

const props = withDefaults(
	defineProps<{
		name: string;
		photoUrl?: string | null;
		size: number;
		class?: string;
		zoomable?: boolean;
	}>(),
	{
		photoUrl: null,
		class: '',
		zoomable: false,
	},
);

const customClass = computed(() => props.class || '');

function letterAvatarUrl(name: string, size: number) {
	const bg = generateAvatarColor(name).substring(1);
	return `https://ui-avatars.com/api/?name=${encodeURIComponent(
		name,
	)}&size=${size}&background=${bg}&color=ffffff&font-size=0.4`;
}

const isRealPhoto = ref(!!props.photoUrl?.trim());

const avatarUrl = ref(
	props.photoUrl?.trim()
		? props.photoUrl
		: letterAvatarUrl(props.name, props.size),
);

watch(
	() => props.photoUrl,
	(url) => {
		const hasPhoto = !!url?.trim();
		isRealPhoto.value = hasPhoto;
		avatarUrl.value = hasPhoto ? url! : letterAvatarUrl(props.name, props.size);
	},
);

function onError() {
	isRealPhoto.value = false;
	avatarUrl.value = letterAvatarUrl(props.name, props.size);
}

const mounted = ref(false);
onMounted(() => {
	mounted.value = true;
});

const canZoom = computed(() => props.zoomable && isRealPhoto.value);
const zoomed = ref(false);
</script>

<template>
	<img
		:src="avatarUrl"
		:alt="name"
		:class="[
			'doctor-avatar',
			customClass,
			{ 'doctor-avatar--zoomable': canZoom },
		]"
		:width="size"
		:height="size"
		:referrerpolicy="mounted ? 'no-referrer' : undefined"
		@error="onError"
		@click="canZoom && (zoomed = true)"
	/>
	<ImageZoomOverlay v-model="zoomed" :src="avatarUrl" :alt="name" />
</template>

<style scoped>
.doctor-avatar {
	border-radius: 10%;
	object-fit: contain;
	background-color: white;
	flex-shrink: 0;
}

.doctor-avatar--zoomable {
	cursor: zoom-in;
}
</style>
