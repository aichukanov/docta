<script setup lang="ts">
import medicalServiceTariffI18n from '~/i18n/medical-service-tariff';
import type { MedicalServiceTariff } from '~/interfaces/medical-service-tariff';

/**
 * Блок «Тариф ФЗОЦГ» на детальной странице каталога.
 *
 * Один и тот же на услугах и на анализах: прайс государственной страховой
 * делит позиции не по нашим каталогам, а по разделам — лабораторные коды
 * (K01/K02, L01, Z01) ссылаются на lab_tests, остальные на medical_services
 * (см. server/common/tariffs.ts).
 *
 * Ярлык вкладки страницы берут из того же i18n-файла: id секции обязан
 * совпасть с id таба в tabs.
 */
defineProps<{
	tariffs: MedicalServiceTariff[];
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: medicalServiceTariffI18n.messages,
});
</script>

<template>
	<EntityPageSection
		sectionId="fzocg-tariff"
		:title="t('TabFzocgTariff')"
		:count="tariffs.length"
	>
		<template #icon><IconClinic :size="20" /></template>
		<aside class="tariff-info">
			<strong class="tariff-info__lead">{{ t('TariffInfoLead') }}</strong>
			<p class="tariff-info__body">{{ t('TariffInfoBody') }}</p>
		</aside>
		<div class="tariff-cards">
			<MedicalServiceFzocgTariffCard
				v-for="tariffItem in tariffs"
				:key="tariffItem.id"
				:tariff="tariffItem"
			/>
		</div>
	</EntityPageSection>
</template>

<style lang="less" scoped>
.tariff-cards {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
}

.tariff-info {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	background: var(--kit-color-primary-bg);
	border-left: 4px solid var(--kit-color-primary);
	border-radius: var(--kit-border-radius-lg);
	padding: var(--kit-spacing-xl) var(--kit-spacing-2xl);
	margin-bottom: var(--kit-spacing-lg);
}

.tariff-info__lead {
	font-size: var(--kit-font-size-2xl);
	font-weight: var(--kit-font-weight-bold);
	color: var(--kit-color-text-heading);
	line-height: 1.3;
}

.tariff-info__body {
	margin: 0;
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-primary);
	line-height: 1.6;
}
</style>
