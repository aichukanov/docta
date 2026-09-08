<script setup lang="ts">
/**
 * Аватар врача — обёртка над KitAvatar с предметной частью:
 *  - инициалы без слов-званий («Prof. dr. Marko Petrović» → «MP», не «PD»);
 *  - цвет считается по имени БЕЗ звания, иначе «Marko Petrović»
 *    и «dr Marko Petrović» получили бы разные цвета;
 *  - зум по клику, если показано настоящее фото.
 *
 * Рисование (фото, фолбэк на инициалы, палитра, контраст) — в дизайн-системе.
 */
const props = withDefaults(
	defineProps<{
		name: string;
		photoUrl?: string | null;
		size: number;
		class?: string;
		zoomable?: boolean;
		loading?: 'lazy' | 'eager';
	}>(),
	{
		photoUrl: null,
		class: '',
		zoomable: false,
		loading: 'lazy',
	},
);

const customClass = computed(() => props.class || '');

// Слова-звания в инициалы попадать не должны. Список шире, чем чистка имени
// для цвета: там достаточно префиксов в начале строки, здесь звание может
// стоять и в середине.
const TITLE_WORD = /^(prof|prim|doc|dr|mr|sci|spec|med|mag)\.?$/i;

const initials = computed(() => {
	const words = props.name.trim().split(/\s+/).filter(Boolean);
	const meaningful = words.filter((word) => !TITLE_WORD.test(word));
	const source = meaningful.length ? meaningful : words;
	return source
		.slice(0, 2)
		.map((word) => Array.from(word)[0]?.toUpperCase() ?? '')
		.join('');
});

/** Имя без звания — семя для выбора цвета. */
const colorSeed = computed(() => {
	const cleaned = props.name
		.replace(/^Prof\.?\s*dr\.?\s+/i, '')
		.replace(/^prim\.?\s*dr\.?\s+/i, '')
		.replace(/^dr\.?\s+/i, '')
		.trim();
	return cleaned || props.name;
});

const hasPhoto = ref(!!props.photoUrl?.trim());
const canZoom = computed(() => props.zoomable && hasPhoto.value);
const zoomed = ref(false);
const photoSrc = computed(() => props.photoUrl?.trim() || '');
</script>

<template>
	<KitAvatar
		:name="name"
		:photo-url="photoUrl"
		:size="size"
		:initials="initials"
		:color-seed="colorSeed"
		:loading="loading"
		:class="[customClass, { 'doctor-avatar--zoomable': canZoom }]"
		@photo-state="hasPhoto = $event"
		@click="canZoom && (zoomed = true)"
	/>
	<ImageZoomOverlay
		v-if="canZoom"
		v-model="zoomed"
		:src="photoSrc"
		:alt="name"
	/>
</template>

<style scoped>
.doctor-avatar--zoomable {
	cursor: zoom-in;
}
</style>
