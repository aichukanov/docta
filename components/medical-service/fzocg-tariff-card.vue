<script setup lang="ts">
import medicalServiceTariffI18n from '~/i18n/medical-service-tariff';
import type {
	MedicalServiceTariff,
	TariffSource,
} from '~/interfaces/medical-service-tariff';

const props = defineProps<{
	tariff: MedicalServiceTariff;
}>();

const { t, n } = useI18n({
	useScope: 'local',
	messages: medicalServiceTariffI18n.messages,
});

const fmt = (value: number | null | undefined): string => {
	if (value == null) return t('TariffEmpty');
	return n(value, { style: 'currency', currency: 'EUR' });
};

// Map enum to i18n key for the human-readable source label
const sourceLabel = computed(() => {
	const map: Record<TariffSource, string> = {
		'fzocg-pzz': 'TariffSourcePzz',
		'fzocg-sekundarna': 'TariffSourceSekundarna',
		'fzocg-drg': 'TariffSourceDrg',
		'fzocg-transfuziologija': 'TariffSourceTransfuziologija',
		'fzocg-apotekarska': 'TariffSourceApotekarska',
		'fzocg-medicinsko-pomagala': 'TariffSourceMedicinskoPomagala',
		'fzocg-van-mreze': 'TariffSourceVanMreze',
	};
	return t(map[props.tariff.tariffSource]);
});

// DRG-only: show the coefficient × base formula on its own row
const isDrg = computed(() => props.tariff.scheme === 'coefficient');
const isOperacija = computed(() => props.tariff.scheme === 'operacija');
const isDual = computed(() => props.tariff.scheme === 'dual');
const isSingle = computed(() => props.tariff.scheme === 'single');
</script>

<template>
	<article class="tariff-card">
		<div class="tariff-card__top">
			<div class="tariff-card__head">
				<h3 class="tariff-card__title">
					<code class="tariff-card__code-value">{{ tariff.code }}</code>
					<span v-if="tariff.nameSrLatin" class="tariff-card__name">
						{{ tariff.nameSrLatin }}
					</span>
				</h3>
				<div v-if="tariff.section" class="tariff-card__section">
					{{ tariff.section
					}}<template v-if="tariff.subsection">
						&nbsp;›&nbsp;{{ tariff.subsection }}</template
					>
				</div>
			</div>
			<span class="tariff-card__badge">FZOCG</span>
		</div>

		<dl class="tariff-card__prices">
			<template v-if="isDual">
				<div class="tariff-card__row">
					<dt>{{ t('TariffPriceOdjeljenje') }}</dt>
					<dd>{{ fmt(tariff.priceOdjeljenjeEur) }}</dd>
				</div>
				<div class="tariff-card__row">
					<dt>{{ t('TariffPriceAmbulanta') }}</dt>
					<dd>{{ fmt(tariff.priceAmbulantaEur) }}</dd>
				</div>
			</template>

			<template v-else-if="isOperacija">
				<div class="tariff-card__row">
					<dt>{{ t('TariffPriceOperacija') }}</dt>
					<dd>{{ fmt(tariff.priceOperacijaEur) }}</dd>
				</div>
				<div class="tariff-card__row">
					<dt>{{ t('TariffPriceAnestezija') }}</dt>
					<dd>{{ fmt(tariff.priceAnestezijaEur) }}</dd>
				</div>
				<div class="tariff-card__row tariff-card__row--total">
					<dt>{{ t('TariffPriceUkupno') }}</dt>
					<dd>{{ fmt(tariff.priceUkupnoEur) }}</dd>
				</div>
			</template>

			<template v-else-if="isDrg">
				<div class="tariff-card__row">
					<dt>{{ t('TariffCoefficientLabel') }}</dt>
					<dd>{{ tariff.coefficient }}</dd>
				</div>
				<div class="tariff-card__row">
					<dt>{{ t('TariffBaseLabel') }}</dt>
					<dd>{{ fmt(tariff.baseCoefficientEur) }}</dd>
				</div>
				<div class="tariff-card__row tariff-card__row--total">
					<dt>{{ t('TariffPriceUkupno') }}</dt>
					<dd>{{ fmt(tariff.priceEur) }}</dd>
				</div>
			</template>

			<template v-else-if="isSingle">
				<div class="tariff-card__row tariff-card__row--total">
					<dt>{{ t('TariffPriceLabel') }}</dt>
					<dd>{{ fmt(tariff.priceEur) }}</dd>
				</div>
			</template>
		</dl>

		<footer class="tariff-card__footer">
			<div class="tariff-card__category">{{ sourceLabel }}</div>
			<div class="tariff-card__attr">
				<span class="tariff-card__label">{{ t('TariffSource') }}:</span>
				<a
					href="https://fzocg.me/cjenovnici/"
					target="_blank"
					rel="noopener noreferrer"
					class="tariff-card__link"
					:title="
						tariff.sourceSignedNumber
							? `№ ${tariff.sourceSignedNumber}`
							: undefined
					"
				>
					fzocg.me/cjenovnici
					<span class="tariff-card__link-icon" aria-hidden="true">↗</span>
				</a>
			</div>
			<div
				v-if="tariff.amendedFrom || tariff.effectiveFrom"
				class="tariff-card__attr"
			>
				<span class="tariff-card__label">
					{{
						tariff.amendedFrom
							? t('TariffAmendedFrom')
							: t('TariffEffectiveFrom')
					}}:
				</span>
				<span>{{ tariff.amendedFrom || tariff.effectiveFrom }}</span>
			</div>
		</footer>
	</article>
</template>

<style lang="less" scoped>
.tariff-card {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
	padding: var(--spacing-xl);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-lg);
	background: var(--color-surface-primary);
	box-shadow: var(--shadow-sm);

	&__top {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: var(--spacing-md);
	}

	&__head {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xs);
		min-width: 0;
		flex: 1;
	}

	&__badge {
		flex-shrink: 0;
		display: inline-flex;
		align-items: center;
		padding: 4px var(--spacing-md);
		background: var(--color-primary);
		color: #fff;
		font-weight: var(--font-weight-semibold);
		font-size: var(--font-size-xs);
		letter-spacing: 0.08em;
		text-transform: uppercase;
		border-radius: var(--border-radius-md);
		line-height: 1.4;
	}

	&__title {
		display: flex;
		flex-wrap: wrap;
		align-items: baseline;
		gap: var(--spacing-sm);
		margin: 0;
		font-size: var(--font-size-xl);
		font-weight: var(--font-weight-semibold);
		color: var(--color-text-heading);
		line-height: 1.3;
	}

	&__code-value {
		font-family: ui-monospace, 'SF Mono', Menlo, Consolas, monospace;
		padding: 2px var(--spacing-sm);
		background: var(--color-primary-bg);
		color: var(--color-primary);
		border-radius: var(--border-radius-sm);
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-medium);
		letter-spacing: 0.02em;
		flex-shrink: 0;
	}

	&__name {
		min-width: 0;
	}

	&__section {
		font-size: var(--font-size-sm);
		color: var(--color-text-muted);
		line-height: 1.4;
	}

	&__prices {
		margin: 0;
		padding: var(--spacing-lg);
		background: var(--color-surface-secondary);
		border-radius: var(--border-radius-md);
		display: grid;
		grid-template-columns: 1fr auto;
		row-gap: var(--spacing-sm);
		column-gap: var(--spacing-lg);
	}

	&__row {
		display: contents;

		dt {
			color: var(--color-text-secondary);
			font-size: var(--font-size-sm);
		}

		dd {
			margin: 0;
			font-weight: var(--font-weight-semibold);
			color: var(--color-text-primary);
			text-align: right;
			font-variant-numeric: tabular-nums;
			font-size: var(--font-size-md);
		}

		&--total {
			dt {
				font-size: var(--font-size-md);
				font-weight: var(--font-weight-semibold);
				color: var(--color-text-heading);
				align-self: center;
			}

			dd {
				font-size: var(--font-size-2xl);
				color: var(--color-primary);
				font-weight: var(--font-weight-bold);
			}
		}
	}

	&__footer {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-sm);
		font-size: var(--font-size-sm);
		color: var(--color-text-secondary);
		padding-top: var(--spacing-lg);
		border-top: 1px solid var(--color-border-light);
	}

	&__category {
		font-size: var(--font-size-md);
		font-weight: var(--font-weight-semibold);
		color: var(--color-text-heading);
		margin-bottom: var(--spacing-xs);
	}

	&__attr {
		display: flex;
		gap: var(--spacing-xs);
		align-items: baseline;
		flex-wrap: wrap;
	}

	&__label {
		color: var(--color-text-muted);
	}

	&__link {
		color: var(--color-primary);
		text-decoration: none;
		display: inline-flex;
		align-items: center;
		gap: 2px;

		&:hover {
			text-decoration: underline;
		}
	}

	&__link-icon {
		font-size: var(--font-size-xs);
		opacity: 0.7;
	}
}
</style>
