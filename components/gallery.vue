<script setup lang="ts">
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

const props = defineProps({
	images: { type: Array as PropType<string[]>, default: (): string[] => [] },
	height: { type: String, default: '500px' },
	alt: { type: String, required: true },
});

const currentIndex = ref(0);
const thumbnailsRef = ref<HTMLElement | null>(null);
const isFullscreen = ref(false);

const currentImage = computed(() => props.images[currentIndex.value]);

const setCurrentImage = (index: number) => {
	currentIndex.value = index;
	// Прокручиваем к активной миниатюре
	if (thumbnailsRef.value) {
		const thumbnail = document.querySelector(
			`.thumbnail:nth-child(${index + 1})`,
		);
		thumbnail?.scrollIntoView({
			behavior: 'smooth',
			block: 'nearest',
			inline: 'nearest',
		});
	}
};

// Используем computed для fullscreenImage, основанный на том же currentIndex
const fullscreenImage = computed(() => {
	if (!props.images[currentIndex.value]) return '';
	return props.images[currentIndex.value].replace(/\/\d+\//, '/orig/');
});

const toggleFullscreen = () => {
	isFullscreen.value = !isFullscreen.value;
	// Блокируем прокрутку body когда модальное окно открыто
	document.body.style.overflow = isFullscreen.value ? 'hidden' : '';
};

const handleKeydown = (e: KeyboardEvent) => {
	if (!isFullscreen.value) return;

	if (e.key === 'ArrowLeft') {
		currentIndex.value =
			currentIndex.value <= 0
				? props.images.length - 1
				: currentIndex.value - 1;
	} else if (e.key === 'ArrowRight') {
		currentIndex.value =
			currentIndex.value >= props.images.length - 1
				? 0
				: currentIndex.value + 1;
	} else if (e.key === 'Escape') {
		toggleFullscreen();
	}
};

const touchStart = ref({ x: 0, y: 0 });
const touchEnd = ref({ x: 0, y: 0 });
const minSwipeDistance = 50; // минимальное расстояние для свайпа

const handleTouchStart = (e: TouchEvent) => {
	touchStart.value = {
		x: e.touches[0].clientX,
		y: e.touches[0].clientY,
	};
	touchEnd.value = {
		x: e.touches[0].clientX,
		y: e.touches[0].clientY,
	};
};

const handleTouchMove = (e: TouchEvent) => {
	touchEnd.value = {
		x: e.touches[0].clientX,
		y: e.touches[0].clientY,
	};
};

const handleTouchEnd = () => {
	const deltaX = touchStart.value.x - touchEnd.value.x;
	const deltaY = touchStart.value.y - touchEnd.value.y;

	// Проверяем, что свайп был преимущественно горизонтальным
	if (
		Math.abs(deltaX) > Math.abs(deltaY) &&
		Math.abs(deltaX) > minSwipeDistance
	) {
		if (deltaX > 0) {
			// Свайп влево - следующая картинка
			currentIndex.value =
				currentIndex.value >= props.images.length - 1
					? 0
					: currentIndex.value + 1;
		} else {
			// Свайп вправо - предыдущая картинка
			currentIndex.value =
				currentIndex.value <= 0
					? props.images.length - 1
					: currentIndex.value - 1;
		}
	}
};
const scale = ref(1);
const startDistance = ref(0);
const fullscreenImageRef = ref<HTMLImageElement | null>(null);

// Добавить computed
const imageTransformStyle = computed(() => ({
	transform: `scale(${scale.value})`,
	transformOrigin: 'center center',
}));

// Новые методы для обработки зума
const getDistance = (touch1: Touch, touch2: Touch) => {
	const dx = touch1.clientX - touch2.clientX;
	const dy = touch1.clientY - touch2.clientY;
	return Math.sqrt(dx * dx + dy * dy);
};

const handleImageTouchStart = (e: TouchEvent) => {
	if (e.touches.length === 2) {
		e.preventDefault();
		startDistance.value = getDistance(e.touches[0], e.touches[1]);
		return;
	}
	// Существующая логика handleTouchStart для свайпов
	handleTouchStart(e);
};

const handleImageTouchMove = (e: TouchEvent) => {
	if (e.touches.length === 2) {
		e.preventDefault();
		const currentDistance = getDistance(e.touches[0], e.touches[1]);
		const delta = currentDistance / startDistance.value;
		scale.value = Math.min(Math.max(delta, 0.5), 3);
		return;
	}
	// Существующая логика handleTouchMove для свайпов
	handleTouchMove(e);
};

const handleImageTouchEnd = (e: TouchEvent) => {
	if (e.touches.length === 0 && scale.value !== 1) {
		scale.value = 1;
		return;
	}
	// Существующая логика handleTouchEnd для свайпов
	handleTouchEnd();
};

const activeDotsStyle = computed(() => {
	let position;
	const totalDots = Math.min(4, props.images.length);

	if (totalDots <= 1) return { transform: 'translateX(0)' };

	if (currentIndex.value === 0) {
		position = 0; // первая точка
	} else if (currentIndex.value === props.images.length - 1) {
		position = totalDots - 1; // последняя точка
	} else if (currentIndex.value === props.images.length - 2 && totalDots > 2) {
		position = totalDots - 2; // предпоследняя точка
	} else {
		position = 1; // вторая точка для всех промежуточных
	}

	return {
		transform: `translateX(${position * 14}px)`, // 14px = размер точки + gap
	};
});

// Добавить watch для сброса масштаба
watch([isFullscreen, currentIndex], () => {
	scale.value = 1;
});

// Добавляем и удаляем слушатель событий клавиатуры
onMounted(() => {
	window.addEventListener('keydown', handleKeydown);
});

onUnmounted(() => {
	window.removeEventListener('keydown', handleKeydown);
});

const getImageDescription = (index: number) => {
	return `${index + 1} / ${props.images.length}`;
};
</script>

<template>
	<div class="gallery" role="region" :aria-label="t('ImageGallery')">
		<div
			v-if="images.length > 0"
			class="thumbnails"
			role="navigation"
			:aria-label="t('ThumbnailsNavigation')"
		>
			<el-scrollbar ref="thumbnailsRef" class="thumbnails-wrapper">
				<div class="thumbnails-container">
					<div
						v-for="(image, index) in images"
						:key="index"
						class="thumbnail"
						:class="{ active: currentIndex === index }"
						@click="setCurrentImage(index)"
						role="button"
						:aria-label="getImageDescription(index)"
						:aria-current="currentIndex === index"
						tabindex="0"
						@keydown.enter="setCurrentImage(index)"
						@keydown.space="setCurrentImage(index)"
					>
						<img
							:src="image"
							:alt="`${alt} (${getImageDescription(index)})`"
							:fetchpriority="index < 3 ? 'high' : 'low'"
							:loading="index < 3 ? 'eager' : 'lazy'"
						/>
					</div>
				</div>
			</el-scrollbar>
		</div>

		<!-- Main image -->
		<div
			v-if="images.length"
			class="main-image"
			@click.stop="toggleFullscreen"
			@touchstart="handleTouchStart"
			@touchmove="handleTouchMove"
			@touchend="handleTouchEnd"
			role="button"
			:aria-label="t('ViewFullscreen')"
			tabindex="0"
			@keydown.enter="toggleFullscreen"
			@keydown.space="toggleFullscreen"
		>
			<img
				:src="currentImage"
				:alt="`${alt} (${getImageDescription(currentIndex)})`"
				:fetchpriority="currentIndex === 0 ? 'high' : 'low'"
				:loading="currentIndex === 0 ? 'eager' : 'lazy'"
			/>

			<div
				v-if="images.length > 0"
				class="dots-nav"
				role="tablist"
				:aria-label="t('ImageNavigation')"
			>
				<div class="dots-container">
					<span
						v-for="i in Math.min(4, images.length)"
						:key="i"
						class="dot"
						role="tab"
						:aria-selected="currentIndex === i - 1"
						:aria-label="
							t('NavigationDot', {
								position: i,
								total: Math.min(4, images.length),
							})
						"
					></span>
					<span class="active-dot" :style="activeDotsStyle"></span>
				</div>
			</div>
		</div>
		<NoImage v-else />

		<!-- Fullscreen modal -->
		<div
			v-if="isFullscreen"
			class="fullscreen-modal"
			@click="toggleFullscreen"
			role="dialog"
			:aria-label="t('FullscreenImage')"
		>
			<div class="modal-content" @click.stop>
				<button
					class="close-btn"
					@click="toggleFullscreen"
					:aria-label="t('CloseFullscreen')"
					>×</button
				>
				<img
					ref="fullscreenImageRef"
					:src="fullscreenImage"
					:alt="`${alt} (${getImageDescription(currentIndex)})`"
					@touchstart="handleImageTouchStart"
					@touchmove="handleImageTouchMove"
					@touchend="handleImageTouchEnd"
					:style="imageTransformStyle"
				/>
			</div>
		</div>
	</div>
</template>

<style scoped>
.gallery {
	display: flex;
	gap: 20px;
	height: v-bind(height);
}

.nav-btn {
	padding: 8px;
	width: 100px; /* ширина как у превью */
}

.thumbnails {
	width: 140px;
}

.thumbnails-wrapper {
	height: 100%;
}

.thumbnails-container {
	display: flex;
	flex-direction: column;
	gap: 12px;
	padding: 4px;
}

.thumbnail {
	width: 120px;
	height: 120px;
	cursor: pointer;
	opacity: 0.7;
	transition: all 0.2s;
	border: 2px solid transparent;
	border-radius: 4px;
}

.thumbnail.active {
	opacity: 1;
	border-color: var(--el-color-primary);
	box-shadow: 0 0 8px rgba(64, 158, 255, 0.2);
}

.thumbnail img {
	width: 100%;
	height: 100%;
	object-fit: contain;
	border-radius: 2px;
}

.main-image {
	min-width: min(100%, 350px);
	flex: 1;
	cursor: pointer;
	touch-action: pan-y pinch-zoom; /* Улучшает работу свайпов */
}

.main-image img {
	width: 100%;
	height: 100%;
	object-fit: contain;
}

.nav-btn {
	padding: 8px;
	width: 100%;
}

.fullscreen-modal {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.8);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 1000;
}

.modal-content {
	position: relative;
	max-width: 95%;
	max-height: 95vh;
	margin: 20px;
	background: white;
	padding: 20px;
	border-radius: 8px;
}

.modal-content img {
	max-width: 100%;
	max-height: calc(95vh - 40px);
	object-fit: contain;
	display: block;
	transition: transform 0.1s ease;
	touch-action: none; /* Важно для работы жестов */
}

.close-btn {
	position: absolute;
	top: -40px;
	right: 0;
	background: none;
	border: none;
	color: white;
	font-size: 24px;
	cursor: pointer;
	padding: 8px;
}

.close-btn:hover {
	opacity: 0.8;
}

.dots-nav {
	display: none;
	justify-content: center;
	padding: 12px 0;
}

.dots-container {
	position: relative;
	display: flex;
	gap: 8px;
}

.dot {
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--el-border-color-lighter);
}

.active-dot {
	position: absolute;
	left: 0;
	top: 0;
	width: 6px;
	height: 6px;
	border-radius: 50%;
	background: var(--el-color-primary);
	transition: transform 0.3s ease;
}

@media (max-width: 768px) {
	.thumbnails {
		width: 90px;
	}

	.thumbnail {
		width: 80px;
		height: 80px;
	}
}

@media (max-width: 480px) {
	.gallery {
		margin-bottom: 20px;
	}

	.dots-nav {
		display: flex;
	}

	.thumbnails {
		display: none;
		width: 70px;
	}

	.thumbnail {
		display: none;
		width: 60px;
		height: 60px;
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"ImageGallery": "Image gallery",
		"ThumbnailsNavigation": "Thumbnails navigation",
		"ViewFullscreen": "View fullscreen",
		"ImageNavigation": "Image navigation",
		"FullscreenImage": "Fullscreen image view",
		"CloseFullscreen": "Close fullscreen view",
		"NavigationDot": "Navigation dot {position} of {total}"
	},
	"ru": {
		"ImageGallery": "Галерея изображений",
		"ThumbnailsNavigation": "Навигация по миниатюрам",
		"ViewFullscreen": "Открыть на весь экран",
		"ImageNavigation": "Навигация по изображениям",
		"FullscreenImage": "Просмотр изображения на весь экран",
		"CloseFullscreen": "Закрыть полноэкранный режим",
		"NavigationDot": "Точка навигации {position} из {total}"
	},
	"sr": {
		"ImageGallery": "Galerija slika",
		"ThumbnailsNavigation": "Navigacija kroz sličice",
		"ViewFullscreen": "Pogledaj na punom ekranu",
		"ImageNavigation": "Navigacija kroz slike",
		"FullscreenImage": "Prikaz slike na punom ekranu",
		"CloseFullscreen": "Zatvori prikaz na punom ekranu",
		"NavigationDot": "Navigaciona tačka {position} od {total}"
	},
	"me": {
		"ImageGallery": "Galerija slika",
		"ThumbnailsNavigation": "Navigacija kroz sličice",
		"ViewFullscreen": "Pogledaj na punom ekranu",
		"ImageNavigation": "Navigacija kroz slike",
		"FullscreenImage": "Prikaz slike na punom ekranu",
		"CloseFullscreen": "Zatvori prikaz na punom ekranu",
		"NavigationDot": "Navigaciona tačka {position} od {total}"
	},
	"ba": {
		"ImageGallery": "Galerija slika",
		"ThumbnailsNavigation": "Navigacija kroz sličice",
		"ViewFullscreen": "Pogledaj na punom ekranu",
		"ImageNavigation": "Navigacija kroz slike",
		"FullscreenImage": "Prikaz slike na punom ekranu",
		"CloseFullscreen": "Zatvori prikaz na punom ekranu",
		"NavigationDot": "Navigaciona tačka {position} od {total}"
	},
	"de": {
		"ImageGallery": "Bildergalerie",
		"ThumbnailsNavigation": "Vorschaubilder Navigation",
		"ViewFullscreen": "Vollbildansicht",
		"ImageNavigation": "Bildnavigation",
		"FullscreenImage": "Vollbildansicht",
		"CloseFullscreen": "Vollbildansicht schließen",
		"NavigationDot": "Navigationspunkt {position} von {total}"
	},
	"tr": {
		"ImageGallery": "Resim galerisi",
		"ThumbnailsNavigation": "Küçük resimler navigasyonu",
		"ViewFullscreen": "Tam ekran görüntüle",
		"ImageNavigation": "Resim navigasyonu",
		"FullscreenImage": "Tam ekran resim görüntüleme",
		"CloseFullscreen": "Tam ekranı kapat",
		"NavigationDot": "Navigasyon noktası {position}/{total}"
	}
}
</i18n>
