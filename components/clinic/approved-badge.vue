<script setup lang="ts">
import { Select } from '@element-plus/icons-vue';
import type { ClinicData } from '~/interfaces/clinic';
import { BillingService } from '~/enums/billing-service';

const props = withDefaults(
	defineProps<{
		clinic: ClinicData;
		small?: boolean;
	}>(),
	{
		small: false,
	},
);

const approvedI18n = {
	'en': {
		ApprovedTooltip:
			'Specialists, services and contacts confirmed by a representative.',
	},
	'ru': {
		ApprovedTooltip:
			'Специалисты, услуги и контакты подтверждены представителем.',
	},
	'de': {
		ApprovedTooltip:
			'Spezialisten, Leistungen und Kontakte wurden von einem Vertreter bestätigt.',
	},
	'tr': {
		ApprovedTooltip:
			'Uzmanlar, hizmetler ve iletişim bilgileri bir temsilci tarafından onaylanmıştır.',
	},
	'sr': {
		ApprovedTooltip:
			'Stručnjaci, usluge i kontakti potvrđeni su od strane predstavnika.',
	},
	'sr-cyrl': {
		ApprovedTooltip:
			'Стручњаци, услуге и контакти потврђени су од стране представника.',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: approvedI18n,
});

const hasApproved = computed(() =>
	props.clinic.features?.includes(BillingService.APPROVED),
);
</script>

<template>
	<el-tooltip
		v-if="hasApproved"
		:content="t('ApprovedTooltip')"
		placement="top"
		effect="light"
	>
		<el-icon class="approved-icon" :class="{ 'approved-icon--small': small }">
			<Select />
		</el-icon>
	</el-tooltip>
</template>

<style scoped lang="less">
.approved-icon {
	color: var(--kit-color-success-dark);
	font-size: var(--kit-font-size-lg);
	flex-shrink: 0;
	margin-top: 2px;
	margin-left: 2px;
	cursor: help;

	&--small {
		font-size: var(--kit-font-size-base);
	}
}
</style>
