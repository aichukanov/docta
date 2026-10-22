<script setup lang="ts">
import IconAlertTriangle from '~/components/icon/alert-triangle.vue';
import clinicReputationI18n from '~/i18n/clinic-reputation';
import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

/**
 * Бейдж «Осторожно» рядом с названием клиники (prd/clinic-reputation/).
 * Показывается только при активных ПОДТВЕРЖДЁННЫХ жалобах (cautionTypes из
 * API); тултип перечисляет короткие ярлыки жалоб. Неинтерактивный — подробности
 * в разделе «Репутация» на странице клиники.
 */
const props = withDefaults(
	defineProps<{
		cautionTypes?: ClinicComplaintType[];
		small?: boolean;
		/** Только иконка — для тесных мест: попап карты, поиск, ссылки в тексте */
		iconOnly?: boolean;
	}>(),
	{
		small: false,
		iconOnly: false,
	},
);

const { t } = useI18n({
	useScope: 'local',
	messages: clinicReputationI18n.messages,
});

const hasCaution = computed(() => (props.cautionTypes?.length ?? 0) > 0);

const tooltipText = computed(() =>
	t('CautionTooltip', {
		labels: (props.cautionTypes ?? [])
			.map((type) => t(`Complaint${type}Short`))
			.join(', '),
	}),
);
</script>

<template>
	<el-tooltip
		v-if="hasCaution"
		:content="tooltipText"
		placement="top"
		effect="light"
	>
		<KitTag
			v-if="!iconOnly"
			variant="warning"
			appearance="light"
			size="small"
			class="caution-badge"
			:class="{ 'caution-badge--small': small }"
		>
			<IconAlertTriangle :size="12" class="caution-badge__icon" />
			{{ t('Caution') }}
		</KitTag>
		<IconAlertTriangle
			v-else
			class="caution-icon"
			:class="{ 'caution-icon--small': small }"
			size="1em"
		/>
	</el-tooltip>
</template>

<style scoped lang="less">
.caution-badge {
	cursor: help;
	flex-shrink: 0;
	white-space: nowrap;

	&__icon {
		flex-shrink: 0;
		margin-right: var(--kit-spacing-xs);
		vertical-align: -1px;
	}
}

// warning-solid: 7.09:1 на светлых поверхностях (см. токены ui-kit)
.caution-icon {
	color: var(--kit-color-warning-solid);
	font-size: var(--kit-font-size-lg);
	flex-shrink: 0;
	cursor: help;

	&--small {
		font-size: var(--kit-font-size-base);
	}
}
</style>
