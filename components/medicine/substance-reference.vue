<script setup lang="ts">
import { capitalizeFirstLetter } from '~/common/string-utils';
import type { MedicineSubstance } from '~/interfaces/medicine';

const props = defineProps<{
	substances: MedicineSubstance[];
}>();

const { t } = useI18n({ useScope: 'local' });
const { locale } = useI18n({ useScope: 'global' });

// В реестре МНН записаны строчными («бенфотиамин»), но здесь название работает
// как подпись поля рядом с «Когда применяют» и «Важно знать», поэтому ведёт
// себя так же — с заглавной. Локаль важна: в турецком i → İ.
const substanceTitle = (name: string) => capitalizeFirstLetter(name, locale.value);

const described = computed(() =>
	(props.substances || []).filter((substance) => substance.reference?.what),
);

/**
 * Справка одна и та же на всех карточках с этим веществом (у дезлоратадина —
 * 7 лекарств, у парацетамола — 49), поэтому объём зависит от состава:
 *   1 вещество (82% карточек реестра) — три поля сразу;
 *   2-3 — строка на вещество, детали за «Показать больше»;
 *   4+ (28 карточек, в основном вакцины) — только строки.
 * Так карточка не превращается в простыню, одинаковую у соседних лекарств.
 */
const mode = computed<'full' | 'lines' | 'compact'>(() => {
	if (described.value.length === 1 && props.substances.length === 1) {
		return 'full';
	}
	return props.substances.length <= 3 ? 'lines' : 'compact';
});

const isExpanded = ref(false);

const hasDetails = computed(() =>
	described.value.some(
		(substance) => substance.reference?.usedFor || substance.reference?.caution,
	),
);
</script>

<template>
	<div v-if="described.length" class="substance-reference">
		<!-- Одно вещество: справка целиком, без лишнего клика -->
		<dl v-if="mode === 'full'" class="substance-reference__table">
			<div class="substance-reference__row">
				<dt>{{ t('What') }}</dt>
				<dd>{{ described[0].reference?.what }}</dd>
			</div>
			<div v-if="described[0].reference?.usedFor" class="substance-reference__row">
				<dt>{{ t('UsedFor') }}</dt>
				<dd>{{ described[0].reference?.usedFor }}</dd>
			</div>
			<div v-if="described[0].reference?.caution" class="substance-reference__row">
				<dt>{{ t('Caution') }}</dt>
				<dd>{{ described[0].reference?.caution }}</dd>
			</div>
		</dl>

		<!-- Несколько веществ: по строке на каждое -->
		<div v-else class="substance-reference__list">
			<div
				v-for="substance in described"
				:key="substance.id"
				class="substance-reference__item"
			>
				<!-- Название — такая же подпись, как «Когда применяют» ниже: тире
				     между строчным МНН и предложением с заглавной читалось криво -->
				<dl class="substance-reference__table">
					<div class="substance-reference__row">
						<dt>{{ substanceTitle(substance.name) }}</dt>
						<dd>{{ substance.reference?.what }}</dd>
					</div>
				</dl>
				<!-- Скрываем классом, а не v-if: текст остаётся в SSR-DOM и индексируется -->
				<dl
					v-if="mode === 'lines'"
					class="substance-reference__table substance-reference__table--nested"
					:class="{ 'substance-reference__table--hidden': !isExpanded }"
				>
					<div v-if="substance.reference?.usedFor" class="substance-reference__row">
						<dt>{{ t('UsedFor') }}</dt>
						<dd>{{ substance.reference?.usedFor }}</dd>
					</div>
					<div v-if="substance.reference?.caution" class="substance-reference__row">
						<dt>{{ t('Caution') }}</dt>
						<dd>{{ substance.reference?.caution }}</dd>
					</div>
				</dl>
			</div>
		</div>

		<ShowMoreButton
			v-if="mode === 'lines' && hasDetails"
			:label="isExpanded ? t('Less') : t('More')"
			@click="isExpanded = !isExpanded"
		/>

		<p class="substance-reference__disclaimer">{{ t('Disclaimer') }}</p>
	</div>
</template>

<style lang="less" scoped>
.substance-reference {
	margin-top: var(--spacing-lg);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.substance-reference__table {
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.substance-reference__table--hidden {
	display: none;
}

.substance-reference__table--nested {
	margin-top: var(--spacing-sm);
	padding-left: var(--spacing-md);
	border-left: 2px solid var(--color-border-secondary);
}

.substance-reference__row {
	dt {
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-bold);
		color: var(--color-text-secondary);
		margin-bottom: var(--spacing-xs);
	}

	dd {
		margin: 0;
		font-size: var(--font-size-sm);
		color: var(--color-text-primary);
		line-height: 1.5;
	}
}

.substance-reference__list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.substance-reference__disclaimer {
	margin: 0;
	font-size: var(--font-size-xs);
	color: var(--color-text-muted);
	line-height: 1.4;
}
</style>

<i18n lang="json">
{
	"en": {
		"What": "What it is",
		"UsedFor": "When it is used",
		"Caution": "Good to know",
		"More": "More about the substances",
		"Less": "Hide details",
		"Disclaimer": "This information is for reference only and does not replace a doctor's consultation. Whether a specific medicine suits you is decided by a doctor or pharmacist."
	},
	"ru": {
		"What": "Что это",
		"UsedFor": "Когда применяют",
		"Caution": "Важно знать",
		"More": "Подробнее о веществах",
		"Less": "Свернуть",
		"Disclaimer": "Информация носит справочный характер и не заменяет консультацию врача. Подходит ли конкретное лекарство именно вам, решает врач или фармацевт."
	},
	"sr": {
		"What": "Šta je to",
		"UsedFor": "Kada se primjenjuje",
		"Caution": "Važno je znati",
		"More": "Više o supstancama",
		"Less": "Sakrij detalje",
		"Disclaimer": "Informacija je informativnog karaktera i ne zamjenjuje konsultaciju sa ljekarom. Da li vam konkretan lijek odgovara, procjenjuje ljekar ili farmaceut."
	},
	"sr-cyrl": {
		"What": "Шта је то",
		"UsedFor": "Када се примјењује",
		"Caution": "Важно је знати",
		"More": "Више о супстанцама",
		"Less": "Сакриј детаље",
		"Disclaimer": "Информација је информативног карактера и не замјењује консултацију са љекаром. Да ли вам конкретан лијек одговара, процјењује љекар или фармацеут."
	},
	"de": {
		"What": "Was es ist",
		"UsedFor": "Wann es angewendet wird",
		"Caution": "Gut zu wissen",
		"More": "Mehr über die Wirkstoffe",
		"Less": "Details ausblenden",
		"Disclaimer": "Diese Informationen dienen nur zur Orientierung und ersetzen keine ärztliche Beratung. Ob ein bestimmtes Medikament für Sie geeignet ist, entscheidet ein Arzt oder Apotheker."
	},
	"tr": {
		"What": "Nedir",
		"UsedFor": "Ne zaman kullanılır",
		"Caution": "Bilinmesi gerekenler",
		"More": "Etkin maddeler hakkında daha fazla",
		"Less": "Ayrıntıları gizle",
		"Disclaimer": "Bu bilgiler yalnızca referans amaçlıdır ve bir doktor konsültasyonunun yerini tutmaz. Belirli bir ilacın size uygun olup olmadığına doktor veya eczacı karar verir."
	}
}
</i18n>
