<script setup lang="ts">
import { QuestionFilled } from '@element-plus/icons-vue';

withDefaults(
	defineProps<{
		small?: boolean;
		// Для использования поверх цветной плашки цены (белая иконка вместо серой)
		inverse?: boolean;
	}>(),
	{
		small: false,
		inverse: false,
	},
);

const priceOutdatedI18n = {
	'en': {
		PriceOutdatedTooltip:
			"The clinic's price list hasn't been updated — the price has most likely increased.",
	},
	'ru': {
		PriceOutdatedTooltip:
			'Прейскурант клиники не обновлён — цена, скорее всего, выросла.',
	},
	'de': {
		PriceOutdatedTooltip:
			'Die Preisliste der Klinik wurde noch nicht aktualisiert — der Preis ist höchstwahrscheinlich gestiegen.',
	},
	'tr': {
		PriceOutdatedTooltip:
			'Kliniğin fiyat listesi henüz güncellenmedi — fiyat büyük olasılıkla arttı.',
	},
	'sr': {
		PriceOutdatedTooltip:
			'Cjenovnik klinike nije ažuriran — cijena je najvjerovatnije porasla.',
	},
	'sr-cyrl': {
		PriceOutdatedTooltip:
			'Цјеновник клинике није ажуриран — цијена је највјероватније порасла.',
	},
};

const { t } = useI18n({
	useScope: 'local',
	messages: priceOutdatedI18n,
});
</script>

<template>
	<el-tooltip :content="t('PriceOutdatedTooltip')" placement="top" effect="light">
		<el-icon
			class="price-outdated-icon"
			:class="{
				'price-outdated-icon--small': small,
				'price-outdated-icon--inverse': inverse,
			}"
		>
			<QuestionFilled />
		</el-icon>
	</el-tooltip>
</template>

<style scoped lang="less">
.price-outdated-icon {
	color: var(--color-text-muted);
	font-size: var(--font-size-lg);
	flex-shrink: 0;
	cursor: help;

	&--small {
		font-size: var(--font-size-base);
	}

	&--inverse {
		color: rgba(255, 255, 255, 0.85);
	}
}
</style>
