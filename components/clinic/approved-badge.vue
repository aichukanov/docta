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
			'Information about the clinic (doctors, services and contacts) confirmed by a clinic representative.',
	},
	'ru': {
		ApprovedTooltip:
			'Информация о клинике (врачи, услуги и контакты) подтверждена представителем клиники.',
	},
	'de': {
		ApprovedTooltip:
			'Informationen über die Klinik (Ärzte, Dienstleistungen und Kontakte) wurden von einem Klinikvertreter bestätigt.',
	},
	'tr': {
		ApprovedTooltip:
			'Klinik hakkındaki bilgiler (doktorlar, hizmetler ve iletişim bilgileri) klinik temsilcisi tarafından onaylanmıştır.',
	},
	'sr': {
		ApprovedTooltip:
			'Informacije o klinici (lekari, usluge i kontakti) potvrđene su od strane predstavnika klinike.',
	},
	'sr-cyrl': {
		ApprovedTooltip:
			'Информације о клиници (лекари, услуге и контакти) потврђене су од стране представника клинике.',
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
	color: var(--color-success);
	font-size: var(--font-size-lg);
	flex-shrink: 0;
	margin-top: 2px;
	margin-left: 2px;
	cursor: help;

	&--small {
		font-size: var(--font-size-md);
	}
}
</style>
