<script setup lang="ts">
import {
	buildCouponTitle,
	getCouponScopeByRoute,
	getCouponTabRoute,
	isCouponApplicable,
} from '~/common/clinic-coupon';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';

/**
 * Купонный маркер: «КУПОН −10%» пунктирным талоном. Один и тот же и в карточке
 * клиники (каталог, страницы услуг и анализов), и в заголовке таба «Купоны» —
 * чтобы купон узнавался по одной и той же метке.
 *
 * Просто «−10%» здесь не годится: пользователь прочитал такой чип как обычную
 * скидку, то есть как шум (2026-07-30). Слово «купон» в метке обязательно.
 */
const props = withDefaults(
	defineProps<{
		coupon?: ClinicCoupon | null;
		// Тултип с полным условием нужен там, где метка стоит одна (карточка
		// клиники). В заголовке таба условия написаны рядом — там он лишний.
		withTooltip?: boolean;
		// Заданы — метка становится ссылкой на таб купонов клиники. Не заданы
		// (метка уже внутри этого таба) — просто текст.
		clinicSlug?: string;
		clinicId?: number;
	}>(),
	{ withTooltip: true },
);

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicCouponI18n.messages,
});

const route = useRoute();

// На странице анализа купон «на услуги» показывать нельзя — тип позиции,
// чья цена стоит в карточке, задаёт роут (см. common/clinic-coupon.ts)
const isVisible = computed(() =>
	isCouponApplicable(props.coupon, getCouponScopeByRoute(route.name)),
);

const label = computed(() =>
	props.coupon
		? `${t('CouponWord')} ${t('CouponChip', {
				percent: props.coupon.discountPercent,
			})}`
		: '',
);

const tooltip = computed(() =>
	props.coupon ? buildCouponTitle(props.coupon, t, locale.value) : '',
);

const couponTabLink = computed(() =>
	props.clinicSlug ? getCouponTabRoute(props.clinicSlug, locale.value) : null,
);

const { trackEvent } = useAnalytics();

// Переход к клинике — то же событие, что у ссылки с названием в этой же карточке
const trackClick = () => {
	if (!props.clinicSlug || props.clinicId == null) return;
	trackEvent('entity_link_clicked', {
		entity_type: 'clinic',
		entity_id: props.clinicId,
		entity_slug: props.clinicSlug,
	});
};
</script>

<template>
	<el-tooltip
		v-if="isVisible && withTooltip"
		:content="tooltip"
		placement="top"
		effect="light"
	>
		<NuxtLink
			v-if="couponTabLink"
			:to="couponTabLink"
			class="coupon-chip coupon-chip--link"
			:aria-label="tooltip"
			@click="trackClick"
		>
			{{ label }}
		</NuxtLink>
		<span v-else class="coupon-chip" tabindex="0" :aria-label="tooltip">
			{{ label }}
		</span>
	</el-tooltip>
	<span v-else-if="isVisible" class="coupon-chip">{{ label }}</span>
</template>

<style scoped lang="less">
.coupon-chip {
	display: inline-flex;
	align-items: center;
	flex-shrink: 0;
	padding: 5px var(--spacing-md);
	line-height: 1.2;
	/* Пунктирная рамка и тёмно-зелёный на светлом — читается как талон, а не как
	   ещё одна плашка с ценой. Заливкой белый текст давал бы 3.7:1 на
	   --color-success и провалил AA */
	background: var(--color-success-bg);
	border: 1px dashed var(--color-primary-green);
	border-radius: var(--border-radius-md);
	color: var(--color-primary-green);
	font-size: var(--font-size-xs);
	font-weight: var(--font-weight-bold);
	letter-spacing: 0.04em;
	text-transform: uppercase;
	white-space: nowrap;
}

.coupon-chip--link {
	text-decoration: none;
	cursor: pointer;
	transition:
		background var(--transition-fast),
		border-color var(--transition-fast);

	&:hover {
		background: var(--color-success-border);
		border-style: solid;
	}
}

/* Некликабельная метка с тултипом: курсор-подсказка вместо руки */
.el-tooltip__trigger.coupon-chip:not(.coupon-chip--link) {
	cursor: help;
}
</style>
