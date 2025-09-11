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

const avatarUrl = computed(() => {
	// Используем photo_url если есть, иначе генерируем буквенный аватар
	if (props.photoUrl && props.photoUrl.trim() !== '') {
		return props.photoUrl;
	} else {
		const backgroundColor = generateAvatarColor(props.name).substring(1); // Убираем # для URL параметра
		return `https://ui-avatars.com/api/?name=${encodeURIComponent(
			props.name,
		)}&size=${
			props.size
		}&background=${backgroundColor}&color=ffffff&font-size=0.4`;
	}
});
</script>

<template>
	<img
		:src="avatarUrl"
		:alt="name"
		:class="`doctor-avatar ${customClass}`"
		:width="size"
		:height="size"
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
