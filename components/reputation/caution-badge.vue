<script setup lang="ts">
import IconAlertTriangle from '~/components/icon/alert-triangle.vue';
import { getRegionalQuery } from '~/common/url-utils';
import reputationI18n from '~/i18n/reputation';
import type { ComplaintType, ReputationEntity } from '~/enums/complaint-type';

/**
 * Бейдж «Осторожно» рядом с названием клиники или врача
 * (prd/clinic-reputation/). Показывается только при активных ПОДТВЕРЖДЁННЫХ
 * жалобах (cautionTypes из API); тултип перечисляет короткие ярлыки жалоб.
 * Со слагом бейдж — ссылка в раздел «Репутация» карточки; без слага
 * (например, внутри другой ссылки, где вложенный <a> невалиден) — просто
 * метка с тултипом.
 */
const props = withDefaults(
	defineProps<{
		cautionTypes?: ComplaintType[];
		/** Клиника или врач — от этого зависит маршрут ссылки */
		entity?: ReputationEntity;
		/** Слаг — делает бейдж ссылкой на страницу сущности с #reputation */
		slug?: string;
		small?: boolean;
		/** Только иконка — для тесных мест: попап карты, поиск, ссылки в тексте */
		iconOnly?: boolean;
	}>(),
	{
		entity: 'clinic',
		small: false,
		iconOnly: false,
	},
);

const { t, locale } = useI18n({
	useScope: 'local',
	messages: reputationI18n.messages,
});

const hasCaution = computed(() => (props.cautionTypes?.length ?? 0) > 0);

const tooltipText = computed(() =>
	t('CautionTooltip', {
		labels: (props.cautionTypes ?? [])
			.map((type) => t(`Complaint${type}Short`))
			.join(', '),
	}),
);

const ROUTE_BY_ENTITY: Record<
	ReputationEntity,
	{ name: string; param: string }
> = {
	clinic: { name: 'clinics-clinicSlug', param: 'clinicSlug' },
	doctor: { name: 'doctors-doctorSlug', param: 'doctorSlug' },
};

const reputationLink = computed(() => {
	if (!props.slug) return null;
	const route = ROUTE_BY_ENTITY[props.entity];
	return {
		name: route.name,
		params: { [route.param]: props.slug },
		query: getRegionalQuery(locale.value),
		hash: '#reputation',
	};
});
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
