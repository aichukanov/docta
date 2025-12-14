<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const { t } = useI18n({ useScope: 'local' });
const { locale } = useI18n({ useScope: 'global' });

const route = useRoute();

const pageTitle = computed(() => t('Title'));
const pageDescription = computed(() => t('Description'));

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
});

const { setAboutPageSchema, setBreadcrumbs } = useSchemaOrg();

const aboutUrl = computed(() => `https://omeda.me${route.path}`);

watchEffect(() => {
	setAboutPageSchema({
		title: pageTitle.value,
		description: pageDescription.value,
		url: aboutUrl.value,
	});
});

watchEffect(() => {
	setBreadcrumbs([
		{ name: t('BreadcrumbHome'), url: '/' },
		{ name: t('BreadcrumbAbout'), url: '/about' },
	]);
});

const homeLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<div class="about-page">
		<div class="about-page__container">
			<div class="about-page__header">
				<div class="about-page__breadcrumbs">
					<NuxtLink class="about-page__crumb" :to="homeLink">{{
						t('BreadcrumbHome')
					}}</NuxtLink>
					<span class="about-page__sep">/</span>
					<span class="about-page__crumb is-current">{{
						t('BreadcrumbAbout')
					}}</span>
				</div>
				<h1 class="about-page__title">{{ t('Title') }}</h1>
				<p class="about-page__subtitle">{{ t('Subtitle') }}</p>
			</div>

			<div class="about-page__grid">
				<section class="about-card">
					<h2 class="about-card__title">{{ t('WhatWeDoTitle') }}</h2>
					<p class="about-card__text">{{ t('WhatWeDoP1') }}</p>
					<p class="about-card__text">{{ t('WhatWeDoP2') }}</p>
				</section>

				<section class="about-card">
					<h2 class="about-card__title">{{ t('SourcesTitle') }}</h2>
					<ul class="about-card__list">
						<li>{{ t('SourcesLi1') }}</li>
						<li>{{ t('SourcesLi2') }}</li>
						<li>{{ t('SourcesLi3') }}</li>
					</ul>
				</section>

				<section class="about-card about-card--warning">
					<h2 class="about-card__title">{{ t('ImportantTitle') }}</h2>
					<ul class="about-card__list">
						<li>{{ t('ImportantLi1') }}</li>
						<li>{{ t('ImportantLi2') }}</li>
						<li>{{ t('ImportantLi3') }}</li>
						<li>{{ t('ImportantLi4') }}</li>
					</ul>
				</section>

				<section class="about-card">
					<h2 class="about-card__title">{{ t('ResponsibilityTitle') }}</h2>
					<p class="about-card__text">{{ t('ResponsibilityP1') }}</p>
					<p class="about-card__text">{{ t('ResponsibilityP2') }}</p>
				</section>
			</div>
		</div>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"Title": "About the project",
		"Description": "How omeda.me collects and structures information about lab tests and medical services. Reference texts may be generated automatically and are not medical advice.",
		"Subtitle": "We collect and systematize information about lab tests and medical services from open sources.",
		"BreadcrumbHome": "Home",
		"BreadcrumbAbout": "About",
		"WhatWeDoTitle": "What this project does",
		"WhatWeDoP1": "The site collects and structures information about laboratory tests and medical services from open sources of clinics and laboratories.",
		"WhatWeDoP2": "Descriptions are formed using data from clinic and laboratory websites and medical reference sources.",
		"SourcesTitle": "How descriptions are prepared",
		"SourcesLi1": "Texts are for reference only and may be processed automatically.",
		"SourcesLi2": "Automatic processing and AI may be used to prepare descriptions.",
		"SourcesLi3": "Texts are not medical recommendations.",
		"ImportantTitle": "Important",
		"ImportantLi1": "Reference ranges and indications may differ depending on the laboratory, methodology and clinical context.",
		"ImportantLi2": "The site does not provide medical services.",
		"ImportantLi3": "The site does not replace a doctor's consultation.",
		"ImportantLi4": "The site is not responsible for the actions of clinics and doctors.",
		"ResponsibilityTitle": "Limitations of responsibility",
		"ResponsibilityP1": "Information on the site may become outdated and may contain inaccuracies from source materials.",
		"ResponsibilityP2": "Before making any decisions about health, please consult a qualified medical professional and verify details with the clinic or laboratory."
	},
	"ru": {
		"Title": "О проекте",
		"Description": "Как omeda.me собирает и систематизирует информацию об анализах и медицинских услугах. Тексты носят справочный характер, могут формироваться автоматически и не являются медицинскими рекомендациями.",
		"Subtitle": "Собираем и систематизируем информацию об анализах и медицинских услугах из открытых источников.",
		"BreadcrumbHome": "Главная",
		"BreadcrumbAbout": "О проекте",
		"WhatWeDoTitle": "Что делает этот проект",
		"WhatWeDoP1": "Сайт собирает и систематизирует информацию об анализах и медицинских услугах из открытых источников клиник и лабораторий.",
		"WhatWeDoP2": "Описания формируются на основе данных с сайтов клиник, лабораторий и медицинских справочников.",
		"SourcesTitle": "Как формируются описания",
		"SourcesLi1": "Тексты носят справочный характер и могут обрабатываться автоматически.",
		"SourcesLi2": "Для подготовки описаний используется автоматическая обработка информации и ИИ.",
		"SourcesLi3": "Тексты не являются медицинскими рекомендациями.",
		"ImportantTitle": "Важно",
		"ImportantLi1": "Нормы и показания могут отличаться в зависимости от лаборатории, методики и клинической ситуации.",
		"ImportantLi2": "Сайт не оказывает медицинские услуги.",
		"ImportantLi3": "Сайт не заменяет консультацию врача.",
		"ImportantLi4": "Сайт не несёт ответственности за действия клиник и докторов.",
		"ResponsibilityTitle": "Ограничение ответственности",
		"ResponsibilityP1": "Информация на сайте может устаревать и содержать неточности, унаследованные из исходных материалов.",
		"ResponsibilityP2": "Перед принятием решений по здоровью проконсультируйтесь с врачом и уточняйте детали в клинике или лаборатории."
	},
	"sr": {
		"Title": "O projektu",
		"Description": "Kako omeda.me prikuplja i sistematizuje informacije o analizama i medicinskim uslugama. Tekstovi su informativni, mogu biti automatski generisani i nisu medicinski saveti.",
		"Subtitle": "Prikupljamo i sistematizujemo informacije o analizama i medicinskim uslugama iz otvorenih izvora.",
		"BreadcrumbHome": "Početna",
		"BreadcrumbAbout": "O projektu",
		"WhatWeDoTitle": "Šta radi ovaj projekat",
		"WhatWeDoP1": "Sajt prikuplja i sistematizuje informacije o laboratorijskim analizama i medicinskim uslugama iz otvorenih izvora klinika i laboratorija.",
		"WhatWeDoP2": "Opisi se formiraju na osnovu podataka sa sajtova klinika, laboratorija i medicinskih referentnih izvora.",
		"SourcesTitle": "Kako se pripremaju opisi",
		"SourcesLi1": "Tekstovi su informativni i mogu biti automatski obrađeni.",
		"SourcesLi2": "Automatska obrada i AI mogu se koristiti za pripremu opisa.",
		"SourcesLi3": "Tekstovi nisu medicinske preporuke.",
		"ImportantTitle": "Važno",
		"ImportantLi1": "Referentne vrednosti i indikacije mogu se razlikovati u zavisnosti od laboratorije, metodologije i kliničkog konteksta.",
		"ImportantLi2": "Sajt ne pruža medicinske usluge.",
		"ImportantLi3": "Sajt ne zamenjuje konsultaciju sa lekarom.",
		"ImportantLi4": "Sajt ne snosi odgovornost za postupke klinika i lekara.",
		"ResponsibilityTitle": "Ograničenje odgovornosti",
		"ResponsibilityP1": "Informacije na sajtu mogu zastareti i mogu sadržati netačnosti iz izvora.",
		"ResponsibilityP2": "Pre donošenja odluka o zdravlju posavetujte se sa lekarom i proverite detalje u klinici ili laboratoriji."
	},
	"de": {
		"Title": "Über das Projekt",
		"Description": "Wie omeda.me Informationen zu Laboranalysen und medizinischen Leistungen sammelt und strukturiert. Texte sind informativ, können automatisch erstellt werden und sind keine medizinische Beratung.",
		"Subtitle": "Wir sammeln und systematisieren Informationen zu Laboranalysen und medizinischen Leistungen aus offenen Quellen.",
		"BreadcrumbHome": "Startseite",
		"BreadcrumbAbout": "Über",
		"WhatWeDoTitle": "Was dieses Projekt macht",
		"WhatWeDoP1": "Die Website sammelt und strukturiert Informationen zu Laboranalysen und medizinischen Leistungen aus offenen Quellen von Kliniken und Laboren.",
		"WhatWeDoP2": "Beschreibungen werden anhand von Daten von Klinik- und Laborwebsites sowie medizinischen Nachschlagewerken erstellt.",
		"SourcesTitle": "Wie Beschreibungen erstellt werden",
		"SourcesLi1": "Texte dienen nur zur Information und können automatisch verarbeitet werden.",
		"SourcesLi2": "Automatische Verarbeitung und KI können zur Erstellung von Beschreibungen eingesetzt werden.",
		"SourcesLi3": "Texte sind keine medizinischen Empfehlungen.",
		"ImportantTitle": "Wichtig",
		"ImportantLi1": "Referenzbereiche und Indikationen können je nach Labor, Methode und klinischem Kontext variieren.",
		"ImportantLi2": "Die Website bietet keine medizinischen Dienstleistungen an.",
		"ImportantLi3": "Die Website ersetzt keine ärztliche Beratung.",
		"ImportantLi4": "Die Website übernimmt keine Verantwortung für Handlungen von Kliniken und Ärzten.",
		"ResponsibilityTitle": "Haftungsbeschränkung",
		"ResponsibilityP1": "Informationen auf der Website können veralten und Ungenauigkeiten aus den Quellen enthalten.",
		"ResponsibilityP2": "Bevor Sie gesundheitliche Entscheidungen treffen, konsultieren Sie bitte medizinisches Fachpersonal und prüfen Sie Details bei der Klinik oder dem Labor."
	},
	"tr": {
		"Title": "Proje hakkında",
		"Description": "omeda.me'nin laboratuvar testleri ve tıbbi hizmetler hakkında bilgiyi nasıl topladığı ve düzenlediği. Metinler bilgilendirme amaçlıdır, otomatik üretilebilir ve tıbbi tavsiye değildir.",
		"Subtitle": "Laboratuvar testleri ve tıbbi hizmetler hakkında bilgiyi açık kaynaklardan topluyor ve sistematik hale getiriyoruz.",
		"BreadcrumbHome": "Ana sayfa",
		"BreadcrumbAbout": "Hakkında",
		"WhatWeDoTitle": "Bu proje ne yapar",
		"WhatWeDoP1": "Site, klinik ve laboratuvarların açık kaynaklarından laboratuvar testleri ve tıbbi hizmetler hakkında bilgiyi toplar ve düzenler.",
		"WhatWeDoP2": "Açıklamalar, klinik ve laboratuvar siteleri ile tıbbi referans kaynaklarındaki verilere dayanarak oluşturulur.",
		"SourcesTitle": "Açıklamalar nasıl hazırlanır",
		"SourcesLi1": "Metinler bilgilendirme amaçlıdır ve otomatik olarak işlenebilir.",
		"SourcesLi2": "Açıklamaların hazırlanmasında otomatik işleme ve yapay zekâ kullanılabilir.",
		"SourcesLi3": "Metinler tıbbi öneri değildir.",
		"ImportantTitle": "Önemli",
		"ImportantLi1": "Referans aralıkları ve endikasyonlar laboratuvara, yönteme ve klinik duruma göre değişebilir.",
		"ImportantLi2": "Site tıbbi hizmet sunmaz.",
		"ImportantLi3": "Site doktor danışmanlığının yerine geçmez.",
		"ImportantLi4": "Site, kliniklerin ve doktorların eylemlerinden sorumlu değildir.",
		"ResponsibilityTitle": "Sorumluluk sınırı",
		"ResponsibilityP1": "Sitedeki bilgiler zamanla güncelliğini yitirebilir ve kaynaklardan gelen hatalar içerebilir.",
		"ResponsibilityP2": "Sağlıkla ilgili kararlar almadan önce bir doktora danışın ve ayrıntıları klinik veya laboratuvarla doğrulayın."
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.about-page {
	background: linear-gradient(
		180deg,
		var(--color-bg-soft) 0%,
		var(--color-bg-secondary) 100%
	);
	padding: calc(var(--spacing-3xl)) @base-padding;
}

.about-page__container {
	max-width: 980px;
	margin: 0 auto;
}

.about-page__header {
	margin-bottom: var(--spacing-2xl);
}

.about-page__breadcrumbs {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
	margin-bottom: var(--spacing-lg);
}

.about-page__crumb {
	color: inherit;
	text-decoration: none;

	&:hover {
		text-decoration: underline;
	}

	&.is-current {
		color: var(--color-text-secondary);
		font-weight: var(--font-weight-medium);
	}
}

.about-page__sep {
	color: var(--color-text-light);
}

.about-page__title {
	margin: 0 0 var(--spacing-sm);
	font-size: clamp(1.8rem, 4vw, 2.6rem);
	letter-spacing: -0.02em;
	color: #0f172a;
	line-height: 1.15;
}

.about-page__subtitle {
	margin: 0;
	max-width: 760px;
	color: #64748b;
	font-size: var(--font-size-xl);
	line-height: 1.7;
}

.about-page__grid {
	display: grid;
	grid-template-columns: 1fr;
	gap: var(--spacing-xl);
}

.about-card {
	background: var(--color-surface-primary);
	border: 1px solid rgba(0, 0, 0, 0.05);
	border-radius: 20px;
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-2xl);
}

.about-card__title {
	margin: 0 0 var(--spacing-lg);
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: #0f172a;
	letter-spacing: -0.01em;
}

.about-card__text {
	margin: 0 0 var(--spacing-md);
	color: var(--color-text-secondary);
	line-height: 1.75;

	&:last-child {
		margin-bottom: 0;
	}
}

.about-card__list {
	margin: 0;
	padding-left: 1.1rem;
	color: var(--color-text-secondary);
	line-height: 1.75;

	li + li {
		margin-top: var(--spacing-sm);
	}
}

.about-card--warning {
	border-color: rgba(245, 158, 11, 0.25);
	background: linear-gradient(
		180deg,
		rgba(245, 158, 11, 0.06) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

@media (max-width: 640px) {
	.about-page {
		padding: var(--spacing-2xl) @base-offset;
	}

	.about-card {
		padding: var(--spacing-xl);
		border-radius: 16px;
	}
}
</style>
