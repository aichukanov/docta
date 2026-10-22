<script setup lang="ts">
import IconAlertTriangle from '~/components/icon/alert-triangle.vue';
import { getRegionalQuery } from '~/common/url-utils';
import clinicReputationI18n from '~/i18n/clinic-reputation';
import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

/**
 * Бейдж «Осторожно» рядом с названием клиники (prd/clinic-reputation/).
 * Показывается только при активных ПОДТВЕРЖДЁННЫХ жалобах (cautionTypes из
 * API); тултип перечисляет короткие ярлыки жалоб. С clinicSlug бейдж —
 * ссылка в раздел «Репутация» страницы клиники; без слага (например, внутри
 * другой ссылки, где вложенный <a> невалиден) — просто метка с тултипом.
 */
const props = withDefaults(
	defineProps<{
		cautionTypes?: ClinicComplaintType[];
		/** Слаг клиники — делает бейдж ссылкой на /clinics/<slug>#reputation */
		clinicSlug?: string;
		small?: boolean;
		/** Только иконка — для тесных мест: попап карты, поиск, ссылки в тексте */
		iconOnly?: boolean;
	}>(),
	{
		small: false,
		iconOnly: false,
	},
);

const { t, locale } = useI18n({
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

const reputationLink = computed(() =>
	props.clinicSlug
		? {
				name: 'clinics-clinicSlug',
				params: { clinicSlug: props.clinicSlug },
				query: getRegionalQuery(locale.value),
				hash: '#reputation',
			}
		: null,
);
</script>

<template>
	<el-tooltip
		v-if="hasCaution"
		:content="tooltipText"
		placement="top"
		effect="light"
	>
		<!-- @click.stop: бейдж живёт внутри кликабельных карточек и строк
		     поиска — переход на репутацию не должен дублироваться их обработчиком -->
		<NuxtLink
			v-if="reputationLink"
			:to="reputationLink"
			class="caution-badge-link"
			@click.stop
		>
			<KitTag
				v-if="!iconOnly"
				variant="warning"
				appearance="light"
				size="small"
				class="caution-badge"
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
		</NuxtLink>
		<KitTag
			v-else-if="!iconOnly"
			variant="warning"
			appearance="light"
			size="small"
			class="caution-badge"
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
.caution-badge-link {
	display: inline-flex;
	align-items: center;
	text-decoration: none;
	flex-shrink: 0;

	.caution-badge,
	.caution-icon {
		cursor: pointer;
	}

	&:hover .caution-badge {
		text-decoration: underline;
		text-decoration-color: var(--kit-color-warning-dark);
	}
}

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
