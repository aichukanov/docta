<script setup lang="ts">
import { getCouponPaymentKey } from '~/common/clinic-coupon';
import { formatDate } from '~/common/date-format';
import clinicCouponI18n from '~/i18n/clinic-coupon';
import type { ClinicCoupon } from '~/interfaces/clinic-coupon';

/**
 * «Чей купон и как он работает» — один список условий на все места показа
 * (таб на странице клиники и диалог с полным купоном).
 */
const props = defineProps<{
	coupon: ClinicCoupon;
	// Есть ли у клиники анализы: оговорку про лабораторию показываем только
	// тем, кого она касается
	hasLabtests?: boolean;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicCouponI18n.messages,
});
// Форматы дат зарегистрированы глобально (i18n/date.ts), у локальной области их нет
const { d } = useI18n({ useScope: 'global' });

const sourceLine = computed(() =>
	props.coupon.sourceName
		? t('CouponSourcePartner', { partner: props.coupon.sourceName })
		: t('CouponSourceOwn'),
);

const formattedValidUntil = computed(() => {
	if (!props.coupon.validUntil) return null;
	return formatDate(props.coupon.validUntil, d, locale.value, 'long');
});

const terms = computed(() => {
	const list = [t('CouponHowTo')];
	// Условие оплаты — сразу после механики: узнать на кассе, что скидка только
	// за наличные, хуже всего
	const paymentKey = getCouponPaymentKey(props.coupon.paymentMethod);
	if (paymentKey) {
		list.push(t(paymentKey));
	}
	if (props.coupon.code) {
		list.push(t('CouponCode', { code: props.coupon.code }));
	}
	// Скидка не на анализы, а лаборатория у клиники есть — предупреждаем прямо
	if (props.hasLabtests && !props.coupon.appliesTo.includes('labtests')) {
		list.push(t('CouponExcludesLabtests'));
	}
	if (formattedValidUntil.value) {
		list.push(t('CouponValidUntil', { date: formattedValidUntil.value }));
	}
	list.push(t('CouponProvidedByClinic'));
	return list;
});
</script>

<template>
	<div class="coupon-terms">
		<p class="coupon-terms__source">{{ sourceLine }}</p>
		<ul class="coupon-terms__list">
			<li v-for="term in terms" :key="term">{{ term }}</li>
		</ul>
	</div>
</template>

<style scoped lang="less">
.coupon-terms {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xs);
}

.coupon-terms__source {
	margin: 0;
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-text-primary);
}

.coupon-terms__list {
	margin: 0;
	padding-left: var(--kit-spacing-lg);
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-secondary);

	li + li {
		margin-top: var(--kit-spacing-xs);
	}
}
</style>
