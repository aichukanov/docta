<script setup lang="ts">
import { getDetailLinkQuery } from '~/common/url-utils';
import { LIST_CARD_MAX_CLINICS } from '~/common/constants';
import type {
	ClinicData,
	ClinicPrice,
	ClinicServicesByClinicId,
} from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		title?: string;
		localName?: string;
		itemId?: number;
		itemSlug?: string;
		// Полный список клиник (отсортирован бэкендом по цене) —
		// карточка показывает только первые LIST_CARD_MAX_CLINICS.
		clinicIds?: string;
		// Общее число клиник, в которых доступна услуга — для подписи кнопки «показать все».
		clinicCount?: number;
		clinicPrices?: ClinicPrice[];
		detailsRouteName?: string;
		detailsParamName?: string;
		clinicServices?: ClinicServicesByClinicId;
		showPrice?: boolean;
		// Активный фильтр городов на listing-странице. Прокидываем в URL детальной,
		// чтобы выбор пользователя сохранялся при переходе и каждый город имел
		// свой канонический URL для краулеров.
		filterCityIds?: number[];
	}>(),
	{
		showPrice: true,
		filterCityIds: () => [],
	},
);

defineEmits<{
	(e: 'show-on-map', clinic: ClinicData): void;
}>();

const { t, locale } = useI18n({ useScope: 'local' });
const clinicsStore = useClinicsStore();

const getPriceInfo = (clinicId: number) =>
	props.clinicPrices?.find((p) => p.clinicId === clinicId);

const getServices = (clinicId: number) => props.clinicServices?.[clinicId];

// Состав первых LIST_CARD_MAX_CLINICS фиксирует сервер (композитный скор без
// локации — цены обрезаны до этого же числа); клиент лишь переупорядочивает
// видимые с учётом расстояния и показывает его на карточке.
const { getDistanceKm, rankClinics } = useClinicRanking();
const visibleClinics = computed(() =>
	rankClinics(
		clinicsStore.getClinicsByIds(props.clinicIds, LIST_CARD_MAX_CLINICS),
		props.clinicPrices,
	),
);

const hasMoreClinics = computed(
	() => (props.clinicCount ?? 0) > LIST_CARD_MAX_CLINICS,
);

const detailsLink = computed(() => {
	if (!props.detailsRouteName || !props.detailsParamName || !props.itemSlug) {
		return null;
	}
	return {
		name: props.detailsRouteName,
		params: { [props.detailsParamName]: props.itemSlug },
		query: getDetailLinkQuery(locale.value, props.filterCityIds),
	};
});

const viewAllLink = computed(() => {
	if (!detailsLink.value) return null;
	return {
		...detailsLink.value,
		query: { ...detailsLink.value.query, tab: 'clinics' },
	};
});

const { trackEvent } = useAnalytics();

const trackDetailsLinkClick = () => {
	const entityType = getEntityTypeByRouteName(props.detailsRouteName);
	if (!entityType || !props.itemId || !props.itemSlug) return;
	trackEvent('entity_link_clicked', {
		entity_type: entityType,
		entity_id: props.itemId,
		entity_slug: props.itemSlug,
		entity_name: props.title,
	});
};
</script>

<template>
	<div class="list-card">
		<slot>
			<div v-if="title" class="list-card-header-wrapper">
				<h2 class="list-card-header">
					<NuxtLink
						v-if="detailsLink"
						:to="detailsLink"
						class="list-card-link"
						@click="trackDetailsLinkClick"
					>
						{{ title }}
					</NuxtLink>
					<template v-else>{{ title }}</template>
				</h2>
				<div v-if="localName" class="list-card-local-name">
					{{ localName }}
				</div>
			</div>
		</slot>

		<div class="clinics-list">
			<ClinicSummary
				v-for="clinic in visibleClinics"
				:key="clinic.id"
				:clinic="clinic"
				:price-info="getPriceInfo(clinic.id)"
				:services="getServices(clinic.id)"
				:showPrice="showPrice"
				:distance="getDistanceKm(clinic)"
				@show-on-map="$emit('show-on-map', clinic)"
			/>
			<NuxtLink
				v-if="hasMoreClinics && viewAllLink"
				:to="viewAllLink"
				class="view-all-clinics"
				:aria-label="t('ViewAllClinics', { count: clinicCount })"
				@click="trackDetailsLinkClick"
			>
				<span class="view-all-clinics__icon" aria-hidden="true">
					<IconClinic :size="18" />
				</span>
				<span class="view-all-clinics__label">
					{{ t('ViewAllClinics', { count: clinicCount }) }}
				</span>
				<svg
					class="view-all-clinics__arrow"
					xmlns="http://www.w3.org/2000/svg"
					width="18"
					height="18"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
					aria-hidden="true"
				>
					<path d="M5 12h14" />
					<path d="m13 5 7 7-7 7" />
				</svg>
			</NuxtLink>
		</div>
	</div>
</template>

<style scoped lang="less">
.list-card {
	box-sizing: border-box;
	background: var(--kit-color-surface-secondary);
	border: 1px solid var(--kit-color-border-primary);
	border-radius: var(--kit-border-radius-lg);
	padding: var(--kit-spacing-xl) var(--kit-spacing-2xl);
	transition: all var(--kit-transition-base);
	box-shadow: var(--kit-shadow-xs);

	.list-card-header-wrapper {
		display: flex;
		flex-direction: column;
		gap: var(--kit-spacing-xs);
	}

	.list-card-header {
		font-size: var(--kit-font-size-lg);
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family:
			system-ui,
			-apple-system,
			sans-serif;

		.list-card-link {
			color: var(--kit-color-primary);
			text-decoration: none;

			&:hover {
				color: var(--kit-color-primary-dark);
				text-decoration: underline;
			}
		}
	}

	.list-card-local-name {
		font-size: var(--kit-font-size-sm);
		font-weight: var(--kit-font-weight-medium);
		color: var(--kit-color-text-secondary);
	}
}

.clinics-list {
	margin-top: var(--kit-spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.view-all-clinics {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
	width: 100%;
	box-sizing: border-box;
	padding: var(--kit-spacing-md) var(--kit-spacing-xl);
	background: linear-gradient(
		180deg,
		rgba(79, 70, 229, 0.04) 0%,
		rgba(79, 70, 229, 0.08) 100%
	);
	border: 1px solid var(--kit-color-border-accent);
	border-radius: var(--kit-border-radius-lg);
	color: var(--kit-color-primary);
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-semibold);
	text-decoration: none;
	transition:
		background var(--kit-transition-base),
		border-color var(--kit-transition-base),
		box-shadow var(--kit-transition-base),
		transform var(--kit-transition-base);

	&__icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 32px;
		height: 32px;
		border-radius: var(--kit-border-radius-full);
		background: var(--kit-color-bg-primary);
		color: var(--kit-color-primary);
		box-shadow: var(--kit-shadow-soft);
		flex-shrink: 0;
	}

	&__label {
		flex: 1;
		min-width: 0;
	}

	&__arrow {
		flex-shrink: 0;
		transition: transform var(--kit-transition-base);
	}

	&:hover {
		background: var(--kit-color-primary);
		border-color: var(--kit-color-primary);
		color: var(--kit-color-bg-primary);
		box-shadow: var(--kit-shadow-hover);
		transform: translateY(-1px);

		.view-all-clinics__icon {
			background: rgba(255, 255, 255, 0.18);
			color: var(--kit-color-bg-primary);
			box-shadow: none;
		}

		.view-all-clinics__arrow {
			transform: translateX(3px);
		}
	}

	&:focus-visible {
		outline: 2px solid var(--kit-color-primary);
		outline-offset: 2px;
	}

	&:active {
		transform: translateY(0);
	}
}

@media (prefers-reduced-motion: reduce) {
	.view-all-clinics,
	.view-all-clinics__arrow {
		transition: none;
	}

	.view-all-clinics:hover {
		transform: none;
	}

	.view-all-clinics:hover .view-all-clinics__arrow {
		transform: none;
	}
}

@media (max-width: 500px) {
	.list-card {
		padding: var(--kit-spacing-sm) var(--kit-spacing-xs);
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"ViewAllClinics": "Show all clinics ({count})"
	},
	"ru": {
		"ViewAllClinics": "Показать все клиники ({count})"
	},
	"sr": {
		"ViewAllClinics": "Prikaži sve klinike ({count})"
	},
	"sr-cyrl": {
		"ViewAllClinics": "Прикажи све клинике ({count})"
	},
	"de": {
		"ViewAllClinics": "Alle Kliniken anzeigen ({count})"
	},
	"tr": {
		"ViewAllClinics": "Tüm klinikleri göster ({count})"
	}
}
</i18n>
