<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { PROJECT_CONTACTS } from '~/common/constants';

const { t } = useI18n({
	useScope: 'local',
	messages: clinicBillingI18n.messages,
});
</script>

<template>
	<el-alert
		type="warning"
		:title="t('PaymentUnavailable')"
		:closable="false"
		show-icon
	>
		{{ t('PaymentUnavailableContact') }}
		<a class="payment-alert__email" :href="`mailto:${PROJECT_CONTACTS.email}`">
			{{ PROJECT_CONTACTS.email }}
		</a>
	</el-alert>
</template>

<style scoped>
.payment-alert__email {
	color: inherit;
	font-weight: var(--font-weight-semibold);
	text-decoration: underline;
}
</style>
