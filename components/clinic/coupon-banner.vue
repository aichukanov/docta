<script setup lang="ts">
import {
	buildCouponTitle,
	getCouponTabRoute,
	isCouponApplicable,
} from '~/common/clinic-coupon';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import type {
	ClinicCoupon,
	ClinicCouponScope,
} from '~/interfaces/clinic-coupon';

const props = defineProps<{
	coupon?: ClinicCoupon | null;
	clinicSlug: string;
	// Тип позиций страницы — на подстранице анализов купон «на услуги» не
	// показываем. Не задан (страница клиники целиком) — показываем всегда.
	scope?: ClinicCouponScope;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicCouponI18n.messages,
});

const isVisible = computed(() =>
	isCouponApplicable(props.coupon, props.scope ?? null),
);

const title = computed(() =>
	props.coupon ? buildCouponTitle(props.coupon, t, locale.value) : '',
);

const sourceLine = computed(() => {
	if (!props.coupon) return '';
	return props.coupon.sourceName
		? t('CouponSourcePartner', { partner: props.coupon.sourceName })
		: t('CouponSourceOwn');
});

// Сам купон и условия живут в табе «Купоны» на странице клиники — ведём туда,
// а не открываем второй копией здесь. Тот же адрес, что у метки и шеринга:
// блок там раскроется сразу (см. getCouponTabRoute)
const couponTabLink = computed(() =>
	getCouponTabRoute(props.clinicSlug, locale.value),
);
</script>

<template>
	<div v-if="isVisible && coupon" class="coupon-banner">
		<p class="coupon-banner__text">
			<span class="coupon-banner__title">{{ title }}</span>
			<span class="coupon-banner__source">{{ sourceLine }}</span>
		</p>
		<NuxtLink :to="couponTabLink" class="coupon-banner__link">
			{{ t('CouponShow') }}
		</NuxtLink>
	</div>
</template>

<style scoped lang="less">
.coupon-banner {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
	flex-wrap: wrap;
	padding: var(--spacing-md) var(--spacing-lg);
	background: var(--color-success-bg);
	border: 1px solid var(--color-success-border);
	border-radius: var(--border-radius-lg);
}

.coupon-banner__text {
	display: flex;
	align-items: baseline;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
	margin: 0;
	min-width: 0;
}

.coupon-banner__title {
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.coupon-banner__source {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.coupon-banner__link {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-semibold);
	color: var(--color-primary);
	text-decoration: none;
	white-space: nowrap;

	&:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}
}
</style>
