<script setup lang="ts">
import IconAlertCircle from '~/components/icon/alert-circle.vue';

// Иконка в плашке цены для строки прайса, которой у клиники больше нет
// (is_obsolete): цена рядом зачёркнута, объяснение — в подсказке.
// Устроена как PriceOutdatedBadge.

const obsoleteBadgeI18n = {
	'en': {
		ObsoleteTooltip:
			"When we checked, this item was no longer in the clinic's price list, though it used to be",
	},
	'ru': {
		ObsoleteTooltip:
			'При проверке мы не нашли эту позицию в прайсе клиники, хотя раньше она там была',
	},
	'de': {
		ObsoleteTooltip:
			'Bei unserer Prüfung fehlte dieser Eintrag in der Preisliste der Klinik, obwohl er früher dort stand',
	},
	'tr': {
		ObsoleteTooltip:
			'Kontrolümüzde bu kalem kliniğin fiyat listesinde yoktu, oysa daha önce vardı',
	},
	'sr': {
		ObsoleteTooltip:
			'Pri provjeri nismo našli ovu stavku u cjenovniku klinike, iako je ranije bila tamo',
	},
	'sr-cyrl': {
		ObsoleteTooltip:
			'При провјери нисмо нашли ову ставку у цјеновнику клинике, иако је раније била тамо',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: obsoleteBadgeI18n,
});
</script>

<template>
	<el-tooltip :content="t('ObsoleteTooltip')" placement="top" effect="light">
		<IconAlertCircle class="obsolete-icon" size="1em" />
	</el-tooltip>
</template>

<style scoped lang="less">
// Контраст (расчёт): danger #ef4444 на серой плашке surface-secondary
// #f8fafc — 3.60:1, для графики нужно ≥ 3:1.
.obsolete-icon {
	color: var(--kit-color-danger);
	font-size: var(--kit-font-size-lg);
	flex-shrink: 0;
	cursor: help;
}
</style>
