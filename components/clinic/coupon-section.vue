<script setup lang="ts">
import IconShare from '~/components/icon/share.vue';
import {
	buildCouponTitle,
	COUPON_TAB_ID,
	getCouponTabUrl,
} from '~/common/clinic-coupon';
import { SITE_URL } from '~/common/constants';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';
import type { AnalyticsShareChannel } from '~/types/analytics';

/**
 * Содержимое таба «Купоны». Свёрнуто — полоса купона с затуханием и кнопка на
 * ней; «Показать больше» раскрывает купон целиком, условия и шеринг, «Свернуть»
 * возвращает всё назад. Клик по картинке в любом состоянии — полный экран.
 */
const props = defineProps<{
	coupon: ClinicCoupon;
	clinicId: number;
	clinicSlug: string;
	clinicName: string;
	hasLabtests?: boolean;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicCouponI18n.messages,
});

// Свёрнуто — полоса купона с затуханием; раскрыто — купон целиком, условия и
// шеринг. Переключатель один и симметричный, как везде на сайте
// (см. CollapsibleContent): «Свернуть» возвращает блок в исходный вид.
const isExpanded = ref(false);
const isZoomed = ref(false);
const { trackEvent } = useAnalytics();

// Вход по купонной ссылке (`?tab=coupons`) — из карточки клиники, с баннера на
// подстранице или по расшаренной ссылке — это запрос показать купон, а не просто
// открыть страницу: раскрываем блок сразу. Только на монтировании: клик по
// вкладке «Купоны», когда пациент уже на странице, ничего не разворачивает.
const route = useRoute();
onMounted(() => {
	if (route.query.tab === COUPON_TAB_ID) isExpanded.value = true;
});

const title = computed(() => buildCouponTitle(props.coupon, t, locale.value));

const imageAlt = computed(() =>
	t('CouponImageAlt', {
		percent: props.coupon.discountPercent,
		clinic: props.clinicName,
	}),
);

// Пропорции картинки узнаём при загрузке: чтобы показать полосу в половину
// высоты, контейнеру задаём вдвое более «широкое» соотношение. До загрузки —
// типовой горизонтальный купон, чтобы блок не прыгал.
const FALLBACK_RATIO = 1.8;
const imageRatio = ref<number | null>(null);

const onImageLoad = (event: Event) => {
	const img = event.target as HTMLImageElement;
	if (img.naturalWidth > 0 && img.naturalHeight > 0) {
		imageRatio.value = img.naturalWidth / img.naturalHeight;
	}
};

// Раскрытый купон показываем целиком — соотношение своё, без обрезки
const previewStyle = computed(() => {
	const ratio = imageRatio.value ?? FALLBACK_RATIO;
	return { aspectRatio: String(isExpanded.value ? ratio : ratio * 2) };
});

const openFullscreen = () => {
	isZoomed.value = true;
	trackEvent('coupon_opened', {
		entity_type: 'clinic',
		entity_id: props.clinicId,
		entity_slug: props.clinicSlug,
		discount_percent: props.coupon.discountPercent,
		coupon_source: props.coupon.sourceName ?? undefined,
	});
};

// Тот же адрес таба, что у метки в карточке: у получателя ссылки купон
// откроется сразу раскрытым, а не свёрнутой полосой
const shareUrl = computed(() =>
	getCouponTabUrl(props.clinicSlug, SITE_URL, locale.value),
);

const shareText = computed(() => `${title.value} — ${props.clinicName}`);

const telegramHref = computed(
	() =>
		`https://t.me/share/url?url=${encodeURIComponent(
			shareUrl.value,
		)}&text=${encodeURIComponent(shareText.value)}`,
);

// Facebook берёт текст не из ссылки, а из og-разметки целевой страницы
const facebookHref = computed(
	() =>
		`https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
			shareUrl.value,
		)}`,
);

// navigator.share есть только в браузере и в основном на мобильных — проверяем
// после монтирования, иначе SSR и клиент разойдутся в разметке
const canShareNatively = ref(false);
onMounted(() => {
	canShareNatively.value =
		typeof navigator !== 'undefined' && typeof navigator.share === 'function';
});

const trackShare = (channel: AnalyticsShareChannel) => {
	trackEvent('coupon_shared', {
		entity_type: 'clinic',
		entity_id: props.clinicId,
		entity_slug: props.clinicSlug,
		share_channel: channel,
		discount_percent: props.coupon.discountPercent,
	});
};

const shareNatively = async () => {
	trackShare('native');
	try {
		await navigator.share({
			title: shareText.value,
			text: shareText.value,
			url: shareUrl.value,
		});
	} catch {
		// Пользователь закрыл системное меню — это не ошибка
	}
};
</script>

<template>
	<div class="coupon-section">
		<template v-if="coupon.imageUrl">
			<!-- Пока блок свёрнут, «Показать больше» лежит поверх затухания:
			     отдельной строкой кнопка добавляла бы блоку ещё ~60 px, а он стоит
			     выше информации о клинике -->
			<div class="coupon-visual">
				<button
					type="button"
					class="coupon-preview"
					:class="{ 'coupon-preview--collapsed': !isExpanded }"
					:style="previewStyle"
					:aria-label="t('CouponOpenFullscreen')"
					:title="t('CouponOpenFullscreen')"
					@click="openFullscreen"
				>
					<img
						:src="coupon.imageUrl"
						:alt="imageAlt"
						loading="lazy"
						@load="onImageLoad"
					/>
					<span
						v-if="!isExpanded"
						class="coupon-preview__fade"
						aria-hidden="true"
					/>
				</button>
				<ShowMoreButton
					v-if="!isExpanded"
					overlay
					:label="t('CouponShowMore')"
					@click="isExpanded = true"
				/>
			</div>
			<ImageZoomOverlay
				v-model="isZoomed"
				:src="coupon.imageUrl"
				:alt="imageAlt"
				maxWidth="900px"
			/>
		</template>
		<template v-else>
			<ClinicCouponTicket :coupon="coupon" :clinicName="clinicName" compact />
			<ShowMoreButton
				v-if="!isExpanded"
				:label="t('CouponShowMore')"
				@click="isExpanded = true"
			/>
		</template>
		<!-- Свёрнутый блок показывает только, что купон есть: подробности и
		     шеринг не должны отжимать информацию о клинике вниз -->
		<template v-if="isExpanded">
			<ClinicCouponTerms :coupon="coupon" :hasLabtests="hasLabtests" />

			<div class="coupon-share">
				<span class="coupon-share__label">{{ t('CouponShareLabel') }}</span>
				<a
					class="coupon-share__link"
					:href="telegramHref"
					target="_blank"
					rel="noopener nofollow"
					aria-label="Telegram"
					@click="trackShare('telegram')"
				>
					<IconTelegram :size="20" />
				</a>
				<a
					class="coupon-share__link"
					:href="facebookHref"
					target="_blank"
					rel="noopener nofollow"
					aria-label="Facebook"
					@click="trackShare('facebook')"
				>
					<IconFacebook :size="20" />
				</a>
				<!-- Системное меню «Поделиться»: иконкой, чтобы не повторять подпись
				     строки словом на кнопке -->
				<button
					v-if="canShareNatively"
					type="button"
					class="coupon-share__link"
					:aria-label="t('CouponShareLabel')"
					:title="t('CouponShareLabel')"
					@click="shareNatively"
				>
					<IconShare :size="18" />
				</button>
			</div>

			<!-- «Свернуть» возвращает блок в исходный вид целиком, включая картинку -->
			<ShowMoreButton
				:label="t('CouponShowLess')"
				@click="isExpanded = false"
			/>
		</template>
	</div>
</template>

<style scoped lang="less">
.coupon-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
	align-items: stretch;
}

.coupon-visual {
	position: relative;
}

/* Видна верхняя полоса купона, низ уходит в затухание — целиком он
   открывается на весь экран */
.coupon-preview {
	position: relative;
	display: block;
	width: 100%;
	padding: 0;
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-lg);
	overflow: hidden;
	background: var(--kit-color-surface-secondary);
	cursor: zoom-in;

	/* Свёрнутый блок стоит первым, выше информации о клинике: вся секция с
	   заголовком и отступами укладывается примерно в 200 px, отсюда полоса
	   в 110 px (и она же страхует от квадратных купонов) */
	&--collapsed {
		max-height: 110px;
	}

	img {
		display: block;
		width: 100%;
		height: 100%;
		object-fit: cover;
		/* В свёрнутой полосе показываем середину купона: сверху обычно логотип
		   клиники, а размер скидки — по центру, ради него и заходят */
		object-position: center;
	}

	&:not(.coupon-preview--collapsed) img {
		object-position: top center;
	}

	&:hover {
		border-color: var(--kit-color-border-accent);
	}
}

.coupon-preview__fade {
	position: absolute;
	left: 0;
	right: 0;
	bottom: 0;
	height: 45%;
	pointer-events: none;
	background: linear-gradient(
		to bottom,
		rgba(255, 255, 255, 0),
		var(--kit-color-bg-primary)
	);
}

.coupon-share {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
}

.coupon-share__label {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.coupon-share__link {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 36px;
	height: 36px;
	padding: 0;
	background: none;
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-full);
	color: var(--kit-color-text-secondary);
	cursor: pointer;
	transition:
		border-color var(--kit-transition-fast),
		color var(--kit-transition-fast);

	&:hover {
		border-color: var(--kit-color-primary);
		color: var(--kit-color-primary);
	}
}
</style>
