<script setup lang="ts">
import { getDetailLinkQuery } from '~/common/url-utils';
import { LIST_CARD_MAX_CLINICS } from '~/common/constants';

interface ClinicServiceItem {
	id: number;
	name: string;
	localName: string;
	price: number | null;
}

interface ClinicServicesMap {
	[clinicId: number]: ClinicServiceItem[];
}

const props = withDefaults(
	defineProps<{
		title?: string;
		localName?: string;
		itemId?: number;
		itemSlug?: string;
		// Только первые LIST_CARD_MAX_CLINICS клиник — бэкенд уже обрезает на listing-эндпоинтах.
		clinicIds: string;
		// Общее число клиник, в которых доступна услуга — для подписи кнопки «показать все».
		clinicCount?: number;
		clinicPrices?: ClinicService[];
		detailsRouteName?: string;
		detailsParamName?: string;
		clinicServices?: ClinicServicesMap;
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

// clinicIds уже отсортированы на бэкенде по количеству услуг и обрезаны до LIST_CARD_MAX_CLINICS.
const visibleClinics = computed(() =>
	clinicsStore.getClinicsByIds(props.clinicIds),
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
</script>

<template>
	<div class="list-card">
		<slot>
			<div v-if="title" class="list-card-header-wrapper">
				<h2 class="list-card-header">
					<NuxtLink v-if="detailsLink" :to="detailsLink" class="list-card-link">
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
				@show-on-map="$emit('show-on-map', clinic)"
			/>
			<NuxtLink
				v-if="hasMoreClinics && viewAllLink"
				:to="viewAllLink"
				class="view-all-clinics"
				:aria-label="t('ViewAllClinics', { count: clinicCount })"
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
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
	transition: all var(--transition-base);
	box-shadow: var(--shadow-xs);

	.list-card-header-wrapper {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
	}

	.list-card-header {
		font-size: var(--font-size-lg);
		font-weight: 600;
		color: #1f2937;
		margin: 0;
		font-family:
			system-ui,
			-apple-system,
			sans-serif;

		.list-card-link {
			color: var(--color-primary);
			text-decoration: none;

			&:hover {
				color: var(--color-primary-dark);
				text-decoration: underline;
			}
		}
	}

	.list-card-local-name {
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-medium);
		color: var(--color-text-secondary);
	}
}

.clinics-list {
	margin-top: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.view-all-clinics {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	width: 100%;
	box-sizing: border-box;
	padding: var(--spacing-md) var(--spacing-xl);
	background: linear-gradient(
		180deg,
		rgba(79, 70, 229, 0.04) 0%,
		rgba(79, 70, 229, 0.08) 100%
	);
	border: 1px solid var(--color-border-accent);
	border-radius: var(--border-radius-lg);
	color: var(--color-primary);
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	text-decoration: none;
	transition:
		background var(--transition-base),
		border-color var(--transition-base),
		box-shadow var(--transition-base),
		transform var(--transition-base);

	&__icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 32px;
		height: 32px;
		border-radius: var(--border-radius-full);
		background: var(--color-bg-primary);
		color: var(--color-primary);
		box-shadow: var(--shadow-soft);
		flex-shrink: 0;
	}

	&__label {
		flex: 1;
		min-width: 0;
	}

	&__arrow {
		flex-shrink: 0;
		transition: transform var(--transition-base);
	}

	&:hover {
		background: var(--color-primary);
		border-color: var(--color-primary);
		color: var(--color-bg-primary);
		box-shadow: var(--shadow-hover);
		transform: translateY(-1px);

		.view-all-clinics__icon {
			background: rgba(255, 255, 255, 0.18);
			color: var(--color-bg-primary);
			box-shadow: none;
		}

		.view-all-clinics__arrow {
			transform: translateX(3px);
		}
	}

	&:focus-visible {
		outline: 2px solid var(--color-primary);
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
		padding: var(--spacing-sm) var(--spacing-xs);
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
