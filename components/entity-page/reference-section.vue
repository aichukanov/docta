<script setup lang="ts">
import type { ReferenceInfo } from '~/interfaces/reference-info';

defineProps<{
	referenceInfo: ReferenceInfo;
	title: string;
	sectionId?: string;
}>();

const { t } = useI18n({ useScope: 'local' });
</script>

<template>
	<EntityPageSection :sectionId="sectionId || 'reference'" :title="title">
		<template #icon><IconInfo :size="20" /></template>

		<dl class="reference-section__table">
			<div class="reference-section__row">
				<dt>{{ t('What') }}</dt>
				<dd>{{ referenceInfo.what }}</dd>
			</div>
			<div class="reference-section__row">
				<dt>{{ t('How') }}</dt>
				<dd>{{ referenceInfo.how }}</dd>
			</div>
			<div class="reference-section__row">
				<dt>{{ t('Indications') }}</dt>
				<dd>{{ referenceInfo.indications }}</dd>
			</div>
			<div class="reference-section__row">
				<dt>{{ t('Prep') }}</dt>
				<dd>{{ referenceInfo.prep }}</dd>
			</div>
			<div class="reference-section__row">
				<dt>{{ t('Abnormal') }}</dt>
				<dd>{{ referenceInfo.abnormal }}</dd>
			</div>
		</dl>

		<p class="reference-section__disclaimer">{{ t('Disclaimer') }}</p>
	</EntityPageSection>
</template>

<style lang="less" scoped>
.reference-section__table {
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.reference-section__row {
	dt {
		font-size: var(--font-size-sm);
		font-weight: var(--font-weight-bold);
		color: var(--color-text-secondary);
		margin-bottom: var(--spacing-xs);
	}

	dd {
		margin: 0;
		font-size: var(--font-size-md);
		color: var(--color-text-primary);
		line-height: 1.6;
	}
}

.reference-section__disclaimer {
	margin: 0;
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	font-style: italic;
	border-top: 1px solid var(--color-border-light);
	padding-top: var(--spacing-md);
}
</style>

<i18n lang="json">
{
	"en": {
		"What": "What it is",
		"How": "How it's done",
		"Indications": "When it's ordered",
		"Prep": "Preparation",
		"Abnormal": "What an abnormal result may indicate",
		"Disclaimer": "This information is for reference only and does not replace a doctor's consultation. Reference ranges and result interpretation depend on the lab/clinic and individual patient factors."
	},
	"ru": {
		"What": "Что это",
		"How": "Как проводится",
		"Indications": "Когда назначают",
		"Prep": "Подготовка",
		"Abnormal": "О чём может говорить отклонение",
		"Disclaimer": "Информация носит справочный характер и не заменяет консультацию врача. Референсные значения и трактовка результата зависят от лаборатории/клиники и индивидуальных особенностей пациента."
	},
	"sr": {
		"What": "Šta je to",
		"How": "Kako se izvodi",
		"Indications": "Kada se naručuje",
		"Prep": "Priprema",
		"Abnormal": "Šta može značiti odstupanje",
		"Disclaimer": "Informacija je informativnog karaktera i ne zamjenjuje konsultaciju sa ljekarom. Referentne vrijednosti i tumačenje rezultata zavise od laboratorije/klinike i individualnih karakteristika pacijenta."
	},
	"sr-cyrl": {
		"What": "Шта је то",
		"How": "Како се изводи",
		"Indications": "Када се наручује",
		"Prep": "Припрема",
		"Abnormal": "Шта може значити одступање",
		"Disclaimer": "Информација је информативног карактера и не замјењује консултацију са љекаром. Референтне вриједности и тумачење резултата зависе од лабораторије/клинике и индивидуалних карактеристика пацијента."
	},
	"de": {
		"What": "Was es ist",
		"How": "Wie es durchgeführt wird",
		"Indications": "Wann es angeordnet wird",
		"Prep": "Vorbereitung",
		"Abnormal": "Was ein abweichendes Ergebnis bedeuten kann",
		"Disclaimer": "Diese Informationen dienen nur zur Orientierung und ersetzen keine ärztliche Beratung. Referenzwerte und die Interpretation der Ergebnisse hängen vom Labor/der Klinik und individuellen Patientenfaktoren ab."
	},
	"tr": {
		"What": "Nedir",
		"How": "Nasıl yapılır",
		"Indications": "Ne zaman istenir",
		"Prep": "Hazırlık",
		"Abnormal": "Anormal bir sonuç ne anlama gelebilir",
		"Disclaimer": "Bu bilgiler yalnızca referans amaçlıdır ve bir doktor konsültasyonunun yerini tutmaz. Referans aralıkları ve sonucun yorumlanması laboratuvara/kliniğe ve hastaya özgü faktörlere bağlıdır."
	}
}
</i18n>
