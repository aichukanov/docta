<script setup lang="ts">
import { buildCouponTitle } from '~/common/clinic-coupon';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';

/**
 * Купон, нарисованный нами — замена картинке партнёра, когда `image_url` пуст.
 * Показывается и в табе, и в диалоге, поэтому вынесен отдельным компонентом.
 */
const props = withDefaults(
	defineProps<{
		coupon: ClinicCoupon;
		clinicName: string;
		// В табе купон вписан в полосу 100–200 px, в диалоге — во всю ширину
		compact?: boolean;
	}>(),
	{ compact: false },
);

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicCouponI18n.messages,
});

const title = computed(() => buildCouponTitle(props.coupon, t, locale.value));

const sourceLine = computed(() =>
	props.coupon.sourceName
		? t('CouponSourcePartner', { partner: props.coupon.sourceName })
		: t('CouponSourceOwn'),
);
</script>

<template>
	<div class="coupon-ticket" :class="{ 'coupon-ticket--compact': compact }">
		<span class="coupon-ticket__percent">
			{{ t('CouponChip', { percent: coupon.discountPercent }) }}
		</span>
		<div class="coupon-ticket__text">
			<span class="coupon-ticket__title">{{ title }}</span>
			<span class="coupon-ticket__clinic">{{ clinicName }}</span>
			<span class="coupon-ticket__source">{{ sourceLine }} · docta.me</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.coupon-ticket {
	display: flex;
	align-items: center;
	gap: var(--spacing-xl);
	padding: var(--spacing-xl);
	background: var(--color-success-bg);
	border: 2px dashed var(--color-primary-green);
	border-radius: var(--border-radius-lg);

	&--compact {
		padding: var(--spacing-lg);
		gap: var(--spacing-lg);
	}
}

.coupon-ticket__percent {
	font-size: var(--font-size-5xl);
	font-weight: var(--font-weight-bold);
	line-height: 1;
	color: var(--color-primary-green);
	flex-shrink: 0;

	.coupon-ticket--compact & {
		font-size: var(--font-size-4xl);
	}
}

.coupon-ticket__text {
	display: flex;
	flex-direction: column;
	gap: 2px;
	min-width: 0;
}

.coupon-ticket__title {
	font-size: var(--font-size-md);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.coupon-ticket__clinic {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.coupon-ticket__source {
	margin-top: var(--spacing-xs);
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
}

@media (max-width: 600px) {
	.coupon-ticket {
		gap: var(--spacing-md);
		padding: var(--spacing-md);
	}

	.coupon-ticket__percent {
		font-size: var(--font-size-4xl);
	}
}
</style>
