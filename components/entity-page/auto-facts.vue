<script setup lang="ts">
import {
	priceFormatOptions,
	type EntityAutoFacts,
} from '~/common/entity-auto-facts';
import { combineI18nMessages } from '~/i18n/utils';
import cityI18n from '~/i18n/city';
import clinicCommonI18n from '~/i18n/clinic-common';
import entityAutoFactsI18n from '~/i18n/entity-auto-facts';

// Полоса авто-фактов под заголовком услуги/анализа: цифры из БД, которые уже
// приехали на клиент вместе с деталями (см. common/entity-auto-facts.ts).
//
// Раскладка «цена в фокусе»: слева крупный ведущий факт, справа остальные.
// Цены — уникальный актив каталога, поэтому по умолчанию ведущий факт именно
// цена. Если цен нет ни у одной клиники, ведущим становится их количество —
// иначе блок остался бы визуально пустой рамкой.
const props = defineProps<{
	facts: EntityAutoFacts;
}>();

const { t, n } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		cityI18n,
		clinicCommonI18n,
		entityAutoFactsI18n,
	]),
});

/** Города перечисляем поимённо, пока список не начинает занимать всю строку */
const MAX_CITIES_TO_NAME = 4;

const formatPrice = (value: number) => n(value, priceFormatOptions(value));

const hasPrice = computed(() => props.facts.priceMin != null);

const citiesText = computed(() => {
	const { cityIds } = props.facts;
	const names = cityIds.map((cityId) => t(`city_${cityId}`));
	if (names.length <= MAX_CITIES_TO_NAME) {
		return names.join(', ');
	}
	// Длинный список ужимаем, но названия остаются — «5» без имён читается хуже
	const shown = names.slice(0, MAX_CITIES_TO_NAME - 1);
	return `${shown.join(', ')} +${names.length - shown.length}`;
});

const priceText = computed(() => {
	const { priceMin, priceMax } = props.facts;
	if (priceMin == null) return null;
	// Потолка нет — все цены вида «от X»
	if (priceMax == null) {
		return t('PriceFrom', { price: formatPrice(priceMin) });
	}
	if (priceMax > priceMin) {
		return `${formatPrice(priceMin)} – ${formatPrice(priceMax)}`;
	}
	return formatPrice(priceMin);
});
</script>

<template>
	<dl class="auto-facts">
		<div class="auto-facts__lead">
			<dt class="auto-facts__label">
				{{ hasPrice ? t('AutoFactsPrice') : t('AutoFactsClinics') }}
			</dt>
			<dd class="auto-facts__lead-value">
				{{ hasPrice ? priceText : facts.clinicCount }}
			</dd>
			<dd v-if="hasPrice && facts.priceAvg != null" class="auto-facts__lead-sub">
				{{ t('AutoFactsAvgInline', { avg: formatPrice(facts.priceAvg) }) }}
			</dd>
		</div>

		<div class="auto-facts__rest">
			<div v-if="hasPrice" class="auto-facts__item">
				<dt class="auto-facts__label">{{ t('AutoFactsClinics') }}</dt>
				<dd class="auto-facts__value">{{ facts.clinicCount }}</dd>
			</div>

			<div v-if="facts.cityIds.length" class="auto-facts__item">
				<dt class="auto-facts__label">{{ t('AutoFactsCities') }}</dt>
				<dd class="auto-facts__value">{{ citiesText }}</dd>
			</div>
		</div>
	</dl>
</template>

<style scoped lang="less">
.auto-facts {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	gap: var(--spacing-xl);
	margin: var(--spacing-xl) 0 0;
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-bg-tips);
	border: 1px solid var(--color-border-accent);
	border-radius: var(--border-radius-lg);
}

.auto-facts__lead {
	display: flex;
	flex-direction: column;
	gap: 2px;
	min-width: 0;
	padding-right: var(--spacing-xl);
	border-right: 1px solid var(--color-border-secondary);
}

.auto-facts__lead-value {
	margin: 0;
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-bold);
	line-height: 1.2;
	color: var(--color-primary-dark);
	overflow-wrap: break-word;
}

.auto-facts__lead-sub {
	margin: 0;
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.auto-facts__rest {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-md) var(--spacing-xl);
	min-width: 0;
}

.auto-facts__item {
	display: flex;
	flex-direction: column;
	gap: 2px;
	min-width: 0;
}

.auto-facts__label {
	font-size: var(--font-size-xs);
	font-weight: var(--font-weight-medium);
	text-transform: uppercase;
	letter-spacing: 0.04em;
	color: var(--color-text-muted);
}

.auto-facts__value {
	margin: 0;
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	overflow-wrap: break-word;
}

// Узкие экраны: колонки складываются в строки, вертикальный разделитель
// ведущего факта становится горизонтальным
@media (max-width: 600px) {
	.auto-facts {
		flex-direction: column;
		align-items: stretch;
		gap: var(--spacing-md);
		padding: var(--spacing-md) var(--spacing-lg);
	}

	.auto-facts__lead {
		padding-right: 0;
		padding-bottom: var(--spacing-md);
		border-right: none;
		border-bottom: 1px solid var(--color-border-secondary);
	}

	.auto-facts__lead-value {
		font-size: var(--font-size-xl);
	}

	.auto-facts__rest {
		gap: var(--spacing-sm) var(--spacing-xl);
	}
}
</style>
