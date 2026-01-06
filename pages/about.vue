<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import { buildBreadcrumbsSchema } from '~/common/schema-org-builders';
import {
	PROJECT_CONTACTS,
	SITE_URL,
	SITE_NAME,
	OG_IMAGE,
} from '~/common/constants';
import breadcrumbI18n from '~/i18n/breadcrumb';
import { combineI18nMessages } from '~/i18n/utils';

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([breadcrumbI18n]),
});

const route = useRoute();

const pageTitle = computed(() => t('Title'));
const pageDescription = computed(() =>
	t('Description', { siteName: SITE_NAME }),
);

const schemaOrgStore = useSchemaOrgStore();
const aboutUrl = computed(() => `${SITE_URL}${route.path}`);

useSeoMeta({
	title: pageTitle,
	description: pageDescription,
	ogTitle: pageTitle,
	ogDescription: pageDescription,
	ogImage: OG_IMAGE,
	ogUrl: aboutUrl,
	twitterCard: 'summary',
	twitterTitle: pageTitle,
	twitterDescription: pageDescription,
	twitterImage: OG_IMAGE,
});

watchEffect(() => {
	schemaOrgStore.setSchemas([
		{
			'@type': 'AboutPage',
			'@id': `${aboutUrl.value}#aboutpage`,
			'name': pageTitle.value,
			'description': pageDescription.value,
			'inLanguage': locale.value,
			'url': aboutUrl.value,
			'isPartOf': {
				'@type': 'WebSite',
				'name': SITE_NAME,
				'url': SITE_URL,
			},
			'about': {
				'@type': 'MedicalBusiness',
				'name': SITE_NAME,
				'url': SITE_URL,
			},
		},
		buildBreadcrumbsSchema(aboutUrl.value, [
			{ name: t('BreadcrumbHome'), url: `${SITE_URL}/` },
			{ name: t('BreadcrumbAbout') },
		]),
	]);
});

const homeLink = computed(() => ({
	name: 'index',
	query: getRegionalQuery(locale.value),
}));

const breadcrumbItems = computed(() => [
	{ label: t('BreadcrumbHome'), to: homeLink.value },
	{ label: t('BreadcrumbAbout') },
]);
</script>

<template>
	<main class="about-page" role="main" :aria-label="t('AriaMainContent')">
		<div class="about-page__container">
			<header class="about-page__header">
				<AppBreadcrumbs
					:items="breadcrumbItems"
					:aria-label="t('AriaBreadcrumbs')"
				/>
				<h1 class="about-page__title">{{ t('Title') }}</h1>
				<p class="about-page__subtitle">{{ t('Subtitle') }}</p>
			</header>

			<article class="about-page__grid" :aria-label="t('AriaAboutContent')">
				<section class="about-card about-card--highlight">
					<h2 class="about-card__title">{{ t('AboutUsTitle') }}</h2>
					<p class="about-card__text">{{ t('AboutUsP1') }}</p>
					<p class="about-card__text">{{
						t('AboutUsP2', { siteName: SITE_NAME })
					}}</p>
				</section>

				<section class="about-card">
					<h2 class="about-card__title">{{ t('WhatWeDoTitle') }}</h2>
					<p class="about-card__text">{{
						t('WhatWeDoP1', { siteName: SITE_NAME })
					}}</p>
					<p class="about-card__text">{{ t('WhatWeDoP2') }}</p>
				</section>

				<section class="about-card">
					<h2 class="about-card__title">{{ t('DataSourcesTitle') }}</h2>
					<p class="about-card__text">{{ t('DataSourcesIntro') }}</p>
					<ul class="about-card__list">
						<li>{{ t('DataSourcesLi1') }}</li>
						<li>{{ t('DataSourcesLi2') }}</li>
						<li>{{ t('DataSourcesLi3') }}</li>
						<li>{{ t('DataSourcesLi4') }}</li>
					</ul>
					<p class="about-card__text about-card__text--note">
						{{ t('DataSourcesNote') }}
					</p>
				</section>

				<section class="about-card">
					<h2 class="about-card__title">{{ t('HowWeWorkTitle') }}</h2>
					<ul class="about-card__list">
						<li>{{ t('HowWeWorkLi1') }}</li>
						<li>{{ t('HowWeWorkLi2') }}</li>
						<li>{{ t('HowWeWorkLi3') }}</li>
					</ul>
				</section>

				<section class="about-card about-card--warning" role="alert">
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

				<section class="about-card about-card--contact">
					<h2 class="about-card__title">{{ t('ContactTitle') }}</h2>
					<p class="about-card__text">{{ t('ContactIntro') }}</p>
					<div class="about-card__contacts">
						<a
							class="about-card__contact-link"
							:href="`mailto:${PROJECT_CONTACTS.email}`"
							target="_blank"
						>
							<IconEmail class="about-card__contact-icon" />
							<span>{{ PROJECT_CONTACTS.email }}</span>
						</a>
						<a
							class="about-card__contact-link"
							:href="PROJECT_CONTACTS.telegram"
							target="_blank"
						>
							<IconTelegram class="about-card__contact-icon" />
							<span>{{ t('TelegramChannel') }}</span>
						</a>
					</div>
				</section>
			</article>
		</div>
	</main>
</template>

<i18n lang="json">
{
	"en": {
		"Title": "About the project",
		"Description": "{siteName} is a project by expats living in Montenegro. We aggregate information about doctors, clinics, lab tests and medical services to make healthcare search easier.",
		"Subtitle": "We help people find doctors and medical services in Montenegro by bringing together information from multiple sources.",
		"AboutUsTitle": "About us",
		"AboutUsP1": "We are a small team of expats living in Montenegro. When we moved here, we faced the same challenge many newcomers face: finding the right doctor or clinic in a new country, especially without knowing the local language.",
		"AboutUsP2": "This experience inspired us to create {siteName} — a service that aggregates and organizes information about healthcare in Montenegro, making it accessible in multiple languages.",
		"WhatWeDoTitle": "What we do",
		"WhatWeDoP1": "{siteName} collects and structures information about doctors, clinics, laboratory tests and medical services from open sources across Montenegro.",
		"WhatWeDoP2": "Our goal is to make healthcare search transparent and convenient by bringing scattered data into one system with filtering by languages, cities and specialties.",
		"DataSourcesTitle": "Our data sources",
		"DataSourcesIntro": "We use only publicly available information from official sources:",
		"DataSourcesLi1": "Official websites of clinics and medical centers",
		"DataSourcesLi2": "Websites of laboratories operating in Montenegro",
		"DataSourcesLi3": "Public price lists and service catalogs",
		"DataSourcesLi4": "Medical reference sources for general descriptions",
		"DataSourcesNote": "We provide direct contact information for each clinic so you can verify any details.",
		"HowWeWorkTitle": "How information is processed",
		"HowWeWorkLi1": "Data is collected from official clinic and laboratory websites",
		"HowWeWorkLi2": "Information is aggregated and structured for easier search",
		"HowWeWorkLi3": "Descriptions are reference material and are not medical recommendations",
		"ImportantTitle": "Important",
		"ImportantLi1": "Reference ranges and indications may differ depending on the laboratory, methodology and clinical context.",
		"ImportantLi2": "The site does not provide medical services.",
		"ImportantLi3": "The site does not replace a doctor's consultation.",
		"ImportantLi4": "The site is not responsible for the actions of clinics and doctors.",
		"ResponsibilityTitle": "Limitations of responsibility",
		"ResponsibilityP1": "Information on the site may become outdated and may contain inaccuracies from source materials.",
		"ResponsibilityP2": "Before making any decisions about health, please consult a qualified medical professional and verify details with the clinic or laboratory.",
		"ContactTitle": "Contact us",
		"ContactIntro": "Have questions, suggestions or found an error? We'd love to hear from you:",
		"TelegramChannel": "Telegram channel",
		"AriaMainContent": "Main content",
		"AriaBreadcrumbs": "Page navigation path",
		"AriaAboutContent": "Information about the project"
	},
	"ru": {
		"Title": "О проекте",
		"Description": "{siteName} — проект экспатов, живущих в Черногории. Мы собираем информацию о врачах, клиниках, анализах и медицинских услугах, чтобы упростить поиск медпомощи.",
		"Subtitle": "Помогаем находить врачей и медицинские услуги в Черногории, собирая информацию из разных источников в одном месте.",
		"AboutUsTitle": "О нас",
		"AboutUsP1": "Мы — небольшая команда экспатов, живущих в Черногории. Когда мы переехали сюда, столкнулись с той же проблемой, что и многие: как найти нужного врача или клинику в новой стране, особенно не зная местного языка.",
		"AboutUsP2": "Этот опыт вдохновил нас создать {siteName} — сервис, который собирает и систематизирует информацию о медицине в Черногории, делая её доступной на нескольких языках.",
		"WhatWeDoTitle": "Что мы делаем",
		"WhatWeDoP1": "{siteName} собирает и систематизирует информацию о врачах, клиниках, лабораторных анализах и медицинских услугах из открытых источников по всей Черногории.",
		"WhatWeDoP2": "Наша цель — сделать поиск медицинской помощи прозрачным и удобным, собрав разрозненные данные в единую систему с фильтрацией по языкам, городам и специальностям.",
		"DataSourcesTitle": "Источники данных",
		"DataSourcesIntro": "Мы используем только открытую информацию из официальных источников:",
		"DataSourcesLi1": "Официальные сайты клиник и медицинских центров",
		"DataSourcesLi2": "Сайты лабораторий, работающих в Черногории",
		"DataSourcesLi3": "Публичные прайс-листы и каталоги услуг",
		"DataSourcesLi4": "Медицинские справочники для общих описаний",
		"DataSourcesNote": "Мы указываем прямые контакты каждой клиники, чтобы вы могли проверить любую информацию.",
		"HowWeWorkTitle": "Как обрабатывается информация",
		"HowWeWorkLi1": "Данные собираются с официальных сайтов клиник и лабораторий",
		"HowWeWorkLi2": "Информация агрегируется и структурируется для удобного поиска",
		"HowWeWorkLi3": "Описания носят справочный характер и не являются медицинскими рекомендациями",
		"ImportantTitle": "Важно",
		"ImportantLi1": "Нормы и показания могут отличаться в зависимости от лаборатории, методики и клинической ситуации.",
		"ImportantLi2": "Сайт не оказывает медицинские услуги.",
		"ImportantLi3": "Сайт не заменяет консультацию врача.",
		"ImportantLi4": "Сайт не несёт ответственности за действия клиник и докторов.",
		"ResponsibilityTitle": "Ограничение ответственности",
		"ResponsibilityP1": "Информация на сайте может устаревать и содержать неточности, унаследованные из исходных материалов.",
		"ResponsibilityP2": "Перед принятием решений по здоровью проконсультируйтесь с врачом и уточняйте детали в клинике или лаборатории.",
		"ContactTitle": "Свяжитесь с нами",
		"ContactIntro": "Есть вопросы, предложения или нашли ошибку? Будем рады обратной связи:",
		"TelegramChannel": "Telegram-канал",
		"AriaMainContent": "Основное содержимое",
		"AriaBreadcrumbs": "Навигационная цепочка",
		"AriaAboutContent": "Информация о проекте"
	},
	"sr": {
		"Title": "O projektu",
		"Description": "{siteName} je projekat ekspata koji žive u Crnoj Gori. Prikupljamo informacije o lekarima, klinikama, analizama i medicinskim uslugama da bismo olakšali pretragu zdravstvene zaštite.",
		"Subtitle": "Pomažemo ljudima da pronađu lekare i medicinske usluge u Crnoj Gori prikupljanjem informacija iz više izvora na jednom mestu.",
		"AboutUsTitle": "O nama",
		"AboutUsP1": "Mi smo mali tim ekspata koji žive u Crnoj Gori. Kada smo se preselili ovde, suočili smo se sa istim izazovom sa kojim se suočavaju mnogi pridošlice: kako pronaći pravog lekara ili kliniku u novoj zemlji, posebno bez poznavanja lokalnog jezika.",
		"AboutUsP2": "Ovo iskustvo nas je inspirisalo da kreiramo {siteName} — servis koji prikuplja i organizuje informacije o zdravstvenoj zaštiti u Crnoj Gori, čineći ih dostupnim na više jezika.",
		"WhatWeDoTitle": "Šta radimo",
		"WhatWeDoP1": "{siteName} prikuplja i strukturira informacije o lekarima, klinikama, laboratorijskim testovima i medicinskim uslugama iz otvorenih izvora širom Crne Gore.",
		"WhatWeDoP2": "Naš cilj je da učinimo pretragu zdravstvene zaštite transparentnom i praktičnom, spajajući rasute podatke u jedan sistem sa filterima po jezicima, gradovima i specijalnostima.",
		"DataSourcesTitle": "Naši izvori podataka",
		"DataSourcesIntro": "Koristimo samo javno dostupne informacije iz zvaničnih izvora:",
		"DataSourcesLi1": "Zvanični sajtovi klinika i medicinskih centara",
		"DataSourcesLi2": "Sajtovi laboratorija koje rade u Crnoj Gori",
		"DataSourcesLi3": "Javni cenovnici i katalozi usluga",
		"DataSourcesLi4": "Medicinski referentni izvori za opšte opise",
		"DataSourcesNote": "Pružamo direktne kontakt informacije za svaku kliniku kako biste mogli da proverite sve detalje.",
		"HowWeWorkTitle": "Kako se informacije obrađuju",
		"HowWeWorkLi1": "Podaci se prikupljaju sa zvaničnih sajtova klinika i laboratorija",
		"HowWeWorkLi2": "Informacije se agregiraju i strukturiraju za lakšu pretragu",
		"HowWeWorkLi3": "Opisi su referentni materijal i nisu medicinske preporuke",
		"ImportantTitle": "Važno",
		"ImportantLi1": "Referentne vrednosti i indikacije mogu se razlikovati u zavisnosti od laboratorije, metodologije i kliničkog konteksta.",
		"ImportantLi2": "Sajt ne pruža medicinske usluge.",
		"ImportantLi3": "Sajt ne zamenjuje konsultaciju sa lekarom.",
		"ImportantLi4": "Sajt ne snosi odgovornost za postupke klinika i lekara.",
		"ResponsibilityTitle": "Ograničenje odgovornosti",
		"ResponsibilityP1": "Informacije na sajtu mogu zastareti i mogu sadržati netačnosti iz izvora.",
		"ResponsibilityP2": "Pre donošenja odluka o zdravlju posavetujte se sa lekarom i proverite detalje u klinici ili laboratoriji.",
		"ContactTitle": "Kontaktirajte nas",
		"ContactIntro": "Imate pitanja, predloge ili ste pronašli grešku? Rado ćemo čuti vaše mišljenje:",
		"TelegramChannel": "Telegram kanal",
		"AriaMainContent": "Glavni sadržaj",
		"AriaBreadcrumbs": "Navigaciona putanja",
		"AriaAboutContent": "Informacije o projektu"
	},
	"sr-cyrl": {
		"Title": "О пројекту",
		"Description": "{siteName} је пројекат експата који живе у Црној Гори. Прикупљамо информације о лекарима, клиникама, анализама и медицинским услугама да бисмо олакшали претрагу здравствене заштите.",
		"Subtitle": "Помажемо људима да пронађу лекаре и медицинске услуге у Црној Гори прикупљањем информација из више извора на једном месту.",
		"AboutUsTitle": "О нама",
		"AboutUsP1": "Ми смо мали тим експата који живе у Црној Гори. Када смо се преселили овде, суочили смо се са истим изазовом са којим се суочавају многи придошлице: како пронаћи правог лекара или клинику у новој земљи, посебно без познавања локалног језика.",
		"AboutUsP2": "Ово искуство нас је инспирисало да креирамо {siteName} — сервис који прикупља и организује информације о здравственој заштити у Црној Гори, чинећи их доступним на више језика.",
		"WhatWeDoTitle": "Шта радимо",
		"WhatWeDoP1": "{siteName} прикупља и структурира информације о лекарима, клиникама, лабораторијским тестовима и медицинским услугама из отворених извора широм Црне Горе.",
		"WhatWeDoP2": "Наш циљ је да учинимо претрагу здравствене заштите транспарентном и практичном, спајајући расуте податке у један систем са филтерима по језицима, градовима и специјалностима.",
		"DataSourcesTitle": "Наши извори података",
		"DataSourcesIntro": "Користимо само јавно доступне информације из званичних извора:",
		"DataSourcesLi1": "Званични сајтови клиника и медицинских центара",
		"DataSourcesLi2": "Сајтови лабораторија које раде у Црној Гори",
		"DataSourcesLi3": "Јавни ценовници и каталози услуга",
		"DataSourcesLi4": "Медицински референтни извори за опште описе",
		"DataSourcesNote": "Пружамо директне контакт информације за сваку клинику како бисте могли да проверите све детаље.",
		"HowWeWorkTitle": "Како се информације обрађују",
		"HowWeWorkLi1": "Подаци се прикупљају са званичних сајтова клиника и лабораторија",
		"HowWeWorkLi2": "Информације се агрегирају и структурирају за лакшу претрагу",
		"HowWeWorkLi3": "Описи су референтни материјал и нису медицинске препоруке",
		"ImportantTitle": "Важно",
		"ImportantLi1": "Референтне вредности и индикације могу се разликовати у зависности од лабораторије, методологије и клиничког контекста.",
		"ImportantLi2": "Сајт не пружа медицинске услуге.",
		"ImportantLi3": "Сајт не замењује консултацију са лекаром.",
		"ImportantLi4": "Сајт не сноси одговорност за поступке клиника и лекара.",
		"ResponsibilityTitle": "Ограничење одговорности",
		"ResponsibilityP1": "Информације на сајту могу застарети и могу садржати нетачности из извора.",
		"ResponsibilityP2": "Пре доношења одлука о здрављу посаветујте се са лекаром и проверите детаље у клиници или лабораторији.",
		"ContactTitle": "Контактирајте нас",
		"ContactIntro": "Имате питања, предлоге или сте пронашли грешку? Радо ћемо чути ваше мишљење:",
		"TelegramChannel": "Telegram канал",
		"AriaMainContent": "Главни садржај",
		"AriaBreadcrumbs": "Навигациона путања",
		"AriaAboutContent": "Информације о пројекту"
	},
	"de": {
		"Title": "Über das Projekt",
		"Description": "{siteName} ist ein Projekt von Expats, die in Montenegro leben. Wir sammeln Informationen über Ärzte, Kliniken, Laboruntersuchungen und medizinische Dienstleistungen, um die Suche nach Gesundheitsversorgung zu erleichtern.",
		"Subtitle": "Wir helfen Menschen, Ärzte und medizinische Dienstleistungen in Montenegro zu finden, indem wir Informationen aus verschiedenen Quellen an einem Ort zusammenführen.",
		"AboutUsTitle": "Über uns",
		"AboutUsP1": "Wir sind ein kleines Team von Expats, die in Montenegro leben. Als wir hierher gezogen sind, standen wir vor der gleichen Herausforderung wie viele Neuankömmlinge: den richtigen Arzt oder die richtige Klinik in einem neuen Land zu finden, besonders ohne die Landessprache zu kennen.",
		"AboutUsP2": "Diese Erfahrung hat uns inspiriert, {siteName} zu erstellen — einen Service, der Informationen über die Gesundheitsversorgung in Montenegro sammelt und organisiert und sie in mehreren Sprachen zugänglich macht.",
		"WhatWeDoTitle": "Was wir tun",
		"WhatWeDoP1": "{siteName} sammelt und strukturiert Informationen über Ärzte, Kliniken, Laboruntersuchungen und medizinische Dienstleistungen aus öffentlichen Quellen in ganz Montenegro.",
		"WhatWeDoP2": "Unser Ziel ist es, die Suche nach Gesundheitsversorgung transparent und bequem zu gestalten, indem wir verstreute Daten in einem System mit Filterung nach Sprachen, Städten und Fachrichtungen zusammenführen.",
		"DataSourcesTitle": "Unsere Datenquellen",
		"DataSourcesIntro": "Wir verwenden nur öffentlich zugängliche Informationen aus offiziellen Quellen:",
		"DataSourcesLi1": "Offizielle Websites von Kliniken und medizinischen Zentren",
		"DataSourcesLi2": "Websites von Laboratorien in Montenegro",
		"DataSourcesLi3": "Öffentliche Preislisten und Servicekataloge",
		"DataSourcesLi4": "Medizinische Nachschlagewerke für allgemeine Beschreibungen",
		"DataSourcesNote": "Wir stellen direkte Kontaktinformationen für jede Klinik bereit, damit Sie alle Details überprüfen können.",
		"HowWeWorkTitle": "Wie Informationen verarbeitet werden",
		"HowWeWorkLi1": "Daten werden von offiziellen Websites von Kliniken und Laboren gesammelt",
		"HowWeWorkLi2": "Informationen werden für eine einfachere Suche aggregiert und strukturiert",
		"HowWeWorkLi3": "Beschreibungen sind Referenzmaterial und keine medizinischen Empfehlungen",
		"ImportantTitle": "Wichtig",
		"ImportantLi1": "Referenzbereiche und Indikationen können je nach Labor, Methode und klinischem Kontext variieren.",
		"ImportantLi2": "Die Website bietet keine medizinischen Dienstleistungen an.",
		"ImportantLi3": "Die Website ersetzt keine ärztliche Beratung.",
		"ImportantLi4": "Die Website übernimmt keine Verantwortung für Handlungen von Kliniken und Ärzten.",
		"ResponsibilityTitle": "Haftungsbeschränkung",
		"ResponsibilityP1": "Informationen auf der Website können veralten und Ungenauigkeiten aus den Quellen enthalten.",
		"ResponsibilityP2": "Bevor Sie gesundheitliche Entscheidungen treffen, konsultieren Sie bitte medizinisches Fachpersonal und prüfen Sie Details bei der Klinik oder dem Labor.",
		"ContactTitle": "Kontaktieren Sie uns",
		"ContactIntro": "Haben Sie Fragen, Vorschläge oder einen Fehler gefunden? Wir freuen uns über Ihr Feedback:",
		"TelegramChannel": "Telegram-Kanal",
		"AriaMainContent": "Hauptinhalt",
		"AriaBreadcrumbs": "Navigationspfad",
		"AriaAboutContent": "Informationen über das Projekt"
	},
	"tr": {
		"Title": "Proje hakkında",
		"Description": "{siteName}, Karadağ'da yaşayan gurbetçilerin bir projesidir. Sağlık arama sürecini kolaylaştırmak için doktorlar, klinikler, laboratuvar testleri ve tıbbi hizmetler hakkında bilgi topluyoruz.",
		"Subtitle": "Farklı kaynaklardan bilgileri bir araya getirerek Karadağ'da doktor ve tıbbi hizmet bulmalarına yardımcı oluyoruz.",
		"AboutUsTitle": "Hakkımızda",
		"AboutUsP1": "Karadağ'da yaşayan küçük bir gurbetçi ekibiyiz. Buraya taşındığımızda, birçok yeni gelenin karşılaştığı aynı zorlukla karşılaştık: yeni bir ülkede, özellikle yerel dili bilmeden doğru doktoru veya kliniği bulmak.",
		"AboutUsP2": "Bu deneyim bizi {siteName}'yi oluşturmaya ilham verdi — Karadağ'daki sağlık hizmetleri hakkında bilgi toplayan ve düzenleyen, birden fazla dilde erişilebilir kılan bir hizmet.",
		"WhatWeDoTitle": "Ne yapıyoruz",
		"WhatWeDoP1": "{siteName}, Karadağ genelindeki açık kaynaklardan doktorlar, klinikler, laboratuvar testleri ve tıbbi hizmetler hakkında bilgi toplar ve yapılandırır.",
		"WhatWeDoP2": "Amacımız, dağınık verileri dillere, şehirlere ve uzmanlıklara göre filtreleme yapan tek bir sistemde bir araya getirerek sağlık aramasını şeffaf ve kullanışlı hale getirmektir.",
		"DataSourcesTitle": "Veri kaynaklarımız",
		"DataSourcesIntro": "Yalnızca resmi kaynaklardan kamuya açık bilgileri kullanıyoruz:",
		"DataSourcesLi1": "Kliniklerin ve tıp merkezlerinin resmi web siteleri",
		"DataSourcesLi2": "Karadağ'da faaliyet gösteren laboratuvarların web siteleri",
		"DataSourcesLi3": "Halka açık fiyat listeleri ve hizmet katalogları",
		"DataSourcesLi4": "Genel açıklamalar için tıbbi referans kaynakları",
		"DataSourcesNote": "Tüm ayrıntıları doğrulayabilmeniz için her klinik için doğrudan iletişim bilgileri sağlıyoruz.",
		"HowWeWorkTitle": "Bilgiler nasıl işlenir",
		"HowWeWorkLi1": "Veriler kliniklerin ve laboratuvarların resmi web sitelerinden toplanır",
		"HowWeWorkLi2": "Bilgiler daha kolay arama için toplanır ve yapılandırılır",
		"HowWeWorkLi3": "Açıklamalar referans materyalidir ve tıbbi öneri değildir",
		"ImportantTitle": "Önemli",
		"ImportantLi1": "Referans aralıkları ve endikasyonlar laboratuvara, yönteme ve klinik duruma göre değişebilir.",
		"ImportantLi2": "Site tıbbi hizmet sunmaz.",
		"ImportantLi3": "Site doktor danışmanlığının yerine geçmez.",
		"ImportantLi4": "Site, kliniklerin ve doktorların eylemlerinden sorumlu değildir.",
		"ResponsibilityTitle": "Sorumluluk sınırı",
		"ResponsibilityP1": "Sitedeki bilgiler zamanla güncelliğini yitirebilir ve kaynaklardan gelen hatalar içerebilir.",
		"ResponsibilityP2": "Sağlıkla ilgili kararlar almadan önce bir doktora danışın ve ayrıntıları klinik veya laboratuvarla doğrulayın.",
		"ContactTitle": "Bize ulaşın",
		"ContactIntro": "Sorularınız, önerileriniz var mı veya bir hata mı buldunuz? Geri bildiriminizi duymak isteriz:",
		"TelegramChannel": "Telegram kanalı",
		"AriaMainContent": "Ana içerik",
		"AriaBreadcrumbs": "Navigasyon yolu",
		"AriaAboutContent": "Proje hakkında bilgi"
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

	:deep(.app-breadcrumbs) {
		margin-bottom: var(--spacing-lg);
	}
}

.about-page__title {
	margin: 0 0 var(--spacing-sm);
	font-size: clamp(1.8rem, 4vw, 2.6rem);
	letter-spacing: -0.02em;
	color: var(--color-text-heading);
	line-height: 1.15;
}

.about-page__subtitle {
	margin: 0;
	max-width: 760px;
	color: var(--color-text-secondary);
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

.about-card--highlight {
	border-color: rgba(79, 70, 229, 0.15);
	background: linear-gradient(
		180deg,
		rgba(79, 70, 229, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.about-card--contact {
	border-color: rgba(6, 182, 212, 0.2);
	background: linear-gradient(
		180deg,
		rgba(6, 182, 212, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.about-card__title {
	margin: 0 0 var(--spacing-lg);
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	letter-spacing: -0.01em;
}

.about-card__text {
	margin: 0 0 var(--spacing-md);
	color: var(--color-text-secondary);
	line-height: 1.75;

	&:last-child {
		margin-bottom: 0;
	}

	&--note {
		font-size: var(--font-size-sm);
		color: var(--color-text-secondary);
		margin-top: var(--spacing-lg);
		padding-top: var(--spacing-md);
		border-top: 1px solid var(--color-border-light);
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

.about-card__contacts {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	margin-top: var(--spacing-lg);
}

.about-card__contact-link {
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-sm);
	color: var(--color-text-secondary);
	text-decoration: none;
	font-size: var(--font-size-md);

	&:hover {
		color: var(--color-primary);
	}
}

.about-card__contact-icon {
	width: 20px;
	height: 20px;
	flex-shrink: 0;
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
