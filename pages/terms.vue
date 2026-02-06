<script setup lang="ts">
import { SITE_URL, OG_IMAGE, PROJECT_CONTACTS } from '~/common/constants';

const { t } = useI18n();
const { t: $t } = useI18n({ useScope: 'global' });
const route = useRoute();

const seoTitle = computed(
	() => t('TermsPageTitle') + ' | ' + $t('ApplicationName'),
);

const seoDescription = computed(() => t('TermsPageDescription'));

useSeoMeta({
	title: () => seoTitle.value,
	description: () => seoDescription.value,
	ogTitle: () => seoTitle.value,
	ogDescription: () => seoDescription.value,
	ogImage: () => OG_IMAGE,
	ogUrl: () => `${SITE_URL}${route.path}`,
});
</script>

<template>
	<main class="terms-page" role="main">
		<div class="terms-page__container">
			<header class="terms-page__header">
				<h1 class="terms-page__title">{{ t('TermsPageTitle') }}</h1>
				<p class="terms-page__subtitle">{{ t('TermsPageSubtitle') }}</p>
			</header>

			<article class="terms-page__grid">
				<section class="terms-card terms-card--highlight">
					<h2 class="terms-card__title">{{ t('WhatWeAreTitle') }}</h2>
					<p class="terms-card__text">{{ t('WhatWeAreText') }}</p>
				</section>

				<section class="terms-card terms-card--warning">
					<h2 class="terms-card__title">{{ t('MedicalDisclaimerTitle') }}</h2>
					<p class="terms-card__text">{{ t('MedicalDisclaimerText') }}</p>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{ t('AccountTitle') }}</h2>
					<p class="terms-card__text">{{ t('AccountText') }}</p>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{ t('DataAccuracyTitle') }}</h2>
					<p class="terms-card__text">{{ t('DataAccuracyText') }}</p>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{
						t('IntellectualPropertyTitle')
					}}</h2>
					<p class="terms-card__text">{{ t('IntellectualPropertyText') }}</p>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{ t('ProhibitedUseTitle') }}</h2>
					<p class="terms-card__text">{{ t('ProhibitedUseIntro') }}</p>
					<ul class="terms-card__list">
						<li>{{ t('ProhibitedUse1') }}</li>
						<li>{{ t('ProhibitedUse2') }}</li>
						<li>{{ t('ProhibitedUse3') }}</li>
						<li>{{ t('ProhibitedUse4') }}</li>
					</ul>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{ t('LiabilityLimitTitle') }}</h2>
					<p class="terms-card__text">{{ t('LiabilityLimitText') }}</p>
				</section>

				<section class="terms-card">
					<h2 class="terms-card__title">{{ t('ChangesTitle') }}</h2>
					<p class="terms-card__text">{{ t('ChangesText') }}</p>
				</section>

				<section class="terms-card terms-card--contact">
					<h2 class="terms-card__title">{{ t('ContactTitle') }}</h2>
					<p class="terms-card__text">{{ t('ContactText') }}</p>
					<a
						class="terms-card__contact-link"
						:href="`mailto:${PROJECT_CONTACTS.email}`"
						target="_blank"
					>
						<span>{{ PROJECT_CONTACTS.email }}</span>
					</a>
				</section>
			</article>
		</div>
	</main>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.terms-page {
	padding: var(--spacing-2xl) @base-padding;
	min-height: calc(100vh - 200px);
}

.terms-page__container {
	max-width: 980px;
	margin: 0 auto;
}

.terms-page__header {
	margin-bottom: var(--spacing-2xl);
}

.terms-page__title {
	margin: 0 0 var(--spacing-sm);
	font-size: clamp(1.8rem, 4vw, 2.6rem);
	letter-spacing: -0.02em;
	color: var(--color-text-primary);
	line-height: 1.15;
	font-weight: var(--font-weight-semibold);
}

.terms-page__subtitle {
	margin: 0;
	max-width: 760px;
	color: var(--color-text-secondary);
	font-size: clamp(1rem, 2vw, 1.2rem);
	line-height: 1.7;
}

.terms-page__grid {
	display: grid;
	grid-template-columns: 1fr;
	gap: var(--spacing-xl);
}

.terms-card {
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: 20px;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
	padding: var(--spacing-2xl);
	transition: box-shadow 0.2s ease;

	&:hover {
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	}
}

.terms-card--highlight {
	border-color: rgba(43, 50, 247, 0.15);
	background: linear-gradient(
		180deg,
		rgba(43, 50, 247, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.terms-card--warning {
	border-color: rgba(245, 158, 11, 0.25);
	background: linear-gradient(
		180deg,
		rgba(245, 158, 11, 0.06) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.terms-card--contact {
	border-color: rgba(43, 50, 247, 0.2);
	background: linear-gradient(
		180deg,
		rgba(43, 50, 247, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.terms-card__title {
	margin: 0 0 var(--spacing-lg);
	font-size: 1.5rem;
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
	letter-spacing: -0.01em;
	line-height: 1.3;
}

.terms-card__text {
	margin: 0 0 var(--spacing-md);
	color: var(--color-text-secondary);
	line-height: 1.75;
	font-size: var(--font-size-lg);

	&:last-child {
		margin-bottom: 0;
	}
}

.terms-card__list {
	margin: var(--spacing-md) 0 0;
	padding-left: 1.1rem;
	color: var(--color-text-secondary);
	line-height: 1.75;
	font-size: var(--font-size-lg);

	li {
		margin-bottom: var(--spacing-sm);

		&:last-child {
			margin-bottom: 0;
		}
	}
}

.terms-card__contact-link {
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-sm);
	color: var(--color-primary);
	text-decoration: none;
	font-size: var(--font-size-lg);
	margin-top: var(--spacing-md);
	transition: opacity 0.2s ease;

	&:hover {
		opacity: 0.8;
	}
}

@media (max-width: 640px) {
	.terms-page {
		padding: var(--spacing-xl) @base-offset;
	}

	.terms-card {
		padding: var(--spacing-xl);
		border-radius: 16px;
	}

	.terms-card__title {
		font-size: 1.25rem;
	}

	.terms-card__text,
	.terms-card__list {
		font-size: var(--font-size-md);
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"TermsPageTitle": "Terms of Service",
		"TermsPageDescription": "Terms of using docta.me. Please read before using our medical information service.",
		"TermsPageSubtitle": "Please read these terms before using our service. They explain your rights and responsibilities.",
		"WhatWeAreTitle": "What we do",
		"WhatWeAreText": "docta.me is a medical information service that helps you find doctors, clinics, and healthcare facilities in Montenegro. We provide information to help you make informed decisions about your healthcare.",
		"MedicalDisclaimerTitle": "Medical disclaimer",
		"MedicalDisclaimerText": "The information on this website is for general informational purposes only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare provider with any questions you may have regarding a medical condition.",
		"AccountTitle": "Your account",
		"AccountText": "You are responsible for maintaining the confidentiality of your account credentials. You agree to provide accurate information and keep it up to date. We reserve the right to suspend or terminate accounts that violate these terms.",
		"DataAccuracyTitle": "Information accuracy",
		"DataAccuracyText": "We strive to provide accurate and up-to-date information about healthcare providers. However, details such as working hours, services, and contact information may change. Always verify important details directly with the provider.",
		"IntellectualPropertyTitle": "Intellectual property",
		"IntellectualPropertyText": "All content on docta.me, including text, graphics, logos, and software, is our property or licensed to us. You may not copy, modify, or distribute our content without permission.",
		"ProhibitedUseTitle": "Prohibited use",
		"ProhibitedUseIntro": "You agree not to:",
		"ProhibitedUse1": "Use the service for any illegal purpose",
		"ProhibitedUse2": "Attempt to gain unauthorized access to our systems",
		"ProhibitedUse3": "Upload malicious content or interfere with the service",
		"ProhibitedUse4": "Scrape or collect data without permission",
		"LiabilityLimitTitle": "Limitation of liability",
		"LiabilityLimitText": "We provide the service \"as is\" without warranties. We are not liable for any damages arising from your use of the service or reliance on information provided. Our liability is limited to the maximum extent permitted by law.",
		"ChangesTitle": "Changes to terms",
		"ChangesText": "We may update these terms at any time. Continued use of the service after changes constitutes acceptance of the new terms. We will notify you of significant changes.",
		"ContactTitle": "Questions?",
		"ContactText": "If you have questions about these terms, contact us:"
	},
	"ru": {
		"TermsPageTitle": "Условия использования",
		"TermsPageDescription": "Условия использования docta.me. Пожалуйста, прочитайте перед использованием нашего медицинского информационного сервиса.",
		"TermsPageSubtitle": "Пожалуйста, прочитайте эти условия перед использованием сервиса. Они объясняют ваши права и обязанности.",
		"WhatWeAreTitle": "Что мы делаем",
		"WhatWeAreText": "docta.me — это медицинский информационный сервис, который помогает найти врачей, клиники и медицинские учреждения в Черногории. Мы предоставляем информацию, чтобы помочь вам принимать обоснованные решения о вашем здоровье.",
		"MedicalDisclaimerTitle": "Медицинский дисклеймер",
		"MedicalDisclaimerText": "Информация на этом сайте носит общий информационный характер и не заменяет профессиональную медицинскую консультацию, диагностику или лечение. Всегда обращайтесь к квалифицированному врачу с любыми вопросами о состоянии здоровья.",
		"AccountTitle": "Ваш аккаунт",
		"AccountText": "Вы несете ответственность за сохранность учетных данных. Вы соглашаетесь предоставлять точную информацию и поддерживать её актуальность. Мы оставляем за собой право приостановить или удалить аккаунты, нарушающие эти условия.",
		"DataAccuracyTitle": "Точность информации",
		"DataAccuracyText": "Мы стремимся предоставлять точную и актуальную информацию о медицинских учреждениях. Однако детали, такие как часы работы, услуги и контакты, могут меняться. Всегда уточняйте важные детали напрямую у поставщика услуг.",
		"IntellectualPropertyTitle": "Интеллектуальная собственность",
		"IntellectualPropertyText": "Весь контент на docta.me, включая тексты, графику, логотипы и программное обеспечение, является нашей собственностью или лицензирован нам. Вы не можете копировать, изменять или распространять наш контент без разрешения.",
		"ProhibitedUseTitle": "Запрещенное использование",
		"ProhibitedUseIntro": "Вы соглашаетесь не:",
		"ProhibitedUse1": "Использовать сервис в незаконных целях",
		"ProhibitedUse2": "Пытаться получить несанкционированный доступ к нашим системам",
		"ProhibitedUse3": "Загружать вредоносный контент или мешать работе сервиса",
		"ProhibitedUse4": "Собирать данные без разрешения",
		"LiabilityLimitTitle": "Ограничение ответственности",
		"LiabilityLimitText": "Мы предоставляем сервис \"как есть\" без гарантий. Мы не несем ответственности за любой ущерб от использования сервиса или информации. Наша ответственность ограничена в пределах, допускаемых законом.",
		"ChangesTitle": "Изменения условий",
		"ChangesText": "Мы можем обновлять эти условия в любое время. Продолжение использования сервиса после изменений означает принятие новых условий. Мы уведомим вас о существенных изменениях.",
		"ContactTitle": "Вопросы?",
		"ContactText": "Если есть вопросы по условиям использования, свяжитесь с нами:"
	},
	"sr": {
		"TermsPageTitle": "Uslovi korištenja",
		"TermsPageDescription": "Uslovi korištenja docta.me. Molimo pročitajte prije korištenja našeg medicinskog informacionog servisa.",
		"TermsPageSubtitle": "Molimo pročitajte ove uslove prije korištenja servisa. Oni objašnjavaju vaša prava i obaveze.",
		"WhatWeAreTitle": "Šta radimo",
		"WhatWeAreText": "docta.me je medicinski informacioni servis koji vam pomaže da pronađete ljekare, klinike i zdravstvene ustanove u Crnoj Gori. Pružamo informacije koje vam pomažu da donesete informisane odluke o vašem zdravlju.",
		"MedicalDisclaimerTitle": "Medicinska napomena",
		"MedicalDisclaimerText": "Informacije na ovoj web stranici su samo u opšte informativne svrhe i ne zamjenjuju profesionalni medicinski savjet, dijagnozu ili liječenje. Uvijek se obratite kvalifikovanom ljekaru sa bilo kakvim pitanjima o zdravstvenom stanju.",
		"AccountTitle": "Vaš nalog",
		"AccountText": "Odgovorni ste za čuvanje povjerljivosti vaših pristupnih podataka. Slažete se da ćete pružiti tačne informacije i održavati ih ažurnim. Zadržavamo pravo da suspendujemo ili ukinemo naloge koji krše ove uslove.",
		"DataAccuracyTitle": "Tačnost informacija",
		"DataAccuracyText": "Trudimo se da pružimo tačne i ažurirane informacije o zdravstvenim ustanovama. Međutim, detalji kao što su radno vrijeme, usluge i kontakt informacije mogu se promijeniti. Uvijek provjerite važne detalje direktno kod pružaoca usluga.",
		"IntellectualPropertyTitle": "Intelektualna svojina",
		"IntellectualPropertyText": "Sav sadržaj na docta.me, uključujući tekst, grafiku, logotipe i softver, je naše vlasništvo ili nam je licencirano. Ne smijete kopirati, mijenjati ili distribuirati naš sadržaj bez dozvole.",
		"ProhibitedUseTitle": "Zabranjeno korištenje",
		"ProhibitedUseIntro": "Slažete se da nećete:",
		"ProhibitedUse1": "Koristiti servis u nezakonite svrhe",
		"ProhibitedUse2": "Pokušavati neovlašten pristup našim sistemima",
		"ProhibitedUse3": "Postavljati zlonamjerni sadržaj ili ometati rad servisa",
		"ProhibitedUse4": "Prikupljati podatke bez dozvole",
		"LiabilityLimitTitle": "Ograničenje odgovornosti",
		"LiabilityLimitText": "Pružamo servis \"kakav jeste\" bez garancija. Nismo odgovorni za bilo kakvu štetu nastalu korištenjem servisa ili oslanjanjem na pružene informacije. Naša odgovornost je ograničena u maksimalnoj mjeri dopuštenoj zakonom.",
		"ChangesTitle": "Promjene uslova",
		"ChangesText": "Možemo ažurirati ove uslove u bilo koje vrijeme. Nastavak korištenja servisa nakon promjena znači prihvatanje novih uslova. Obavijestićemo vas o značajnim promjenama.",
		"ContactTitle": "Pitanja?",
		"ContactText": "Ako imate pitanja o ovim uslovima, kontaktirajte nas:"
	},
	"de": {
		"TermsPageTitle": "Nutzungsbedingungen",
		"TermsPageDescription": "Nutzungsbedingungen von docta.me. Bitte lesen Sie diese vor der Nutzung unseres medizinischen Informationsdienstes.",
		"TermsPageSubtitle": "Bitte lesen Sie diese Bedingungen vor der Nutzung unseres Dienstes. Sie erklären Ihre Rechte und Pflichten.",
		"WhatWeAreTitle": "Was wir tun",
		"WhatWeAreText": "docta.me ist ein medizinischer Informationsdienst, der Ihnen hilft, Ärzte, Kliniken und Gesundheitseinrichtungen in Montenegro zu finden. Wir bieten Informationen, um Ihnen bei fundierten Gesundheitsentscheidungen zu helfen.",
		"MedicalDisclaimerTitle": "Medizinischer Haftungsausschluss",
		"MedicalDisclaimerText": "Die Informationen auf dieser Website dienen nur allgemeinen Informationszwecken und ersetzen keine professionelle medizinische Beratung, Diagnose oder Behandlung. Wenden Sie sich bei Fragen zu Ihrem Gesundheitszustand immer an einen qualifizierten Arzt.",
		"AccountTitle": "Ihr Konto",
		"AccountText": "Sie sind für die Geheimhaltung Ihrer Zugangsdaten verantwortlich. Sie verpflichten sich, genaue Informationen anzugeben und diese aktuell zu halten. Wir behalten uns das Recht vor, Konten zu sperren oder zu kündigen, die gegen diese Bedingungen verstoßen.",
		"DataAccuracyTitle": "Informationsgenauigkeit",
		"DataAccuracyText": "Wir bemühen uns, genaue und aktuelle Informationen über Gesundheitsdienstleister bereitzustellen. Details wie Öffnungszeiten, Dienstleistungen und Kontaktinformationen können sich jedoch ändern. Überprüfen Sie wichtige Details immer direkt beim Anbieter.",
		"IntellectualPropertyTitle": "Geistiges Eigentum",
		"IntellectualPropertyText": "Alle Inhalte auf docta.me, einschließlich Text, Grafiken, Logos und Software, sind unser Eigentum oder an uns lizenziert. Sie dürfen unsere Inhalte nicht ohne Genehmigung kopieren, ändern oder verbreiten.",
		"ProhibitedUseTitle": "Verbotene Nutzung",
		"ProhibitedUseIntro": "Sie verpflichten sich, Folgendes nicht zu tun:",
		"ProhibitedUse1": "Den Dienst für illegale Zwecke zu nutzen",
		"ProhibitedUse2": "Unbefugten Zugang zu unseren Systemen zu erlangen",
		"ProhibitedUse3": "Schädliche Inhalte hochzuladen oder den Dienst zu stören",
		"ProhibitedUse4": "Daten ohne Erlaubnis zu sammeln",
		"LiabilityLimitTitle": "Haftungsbeschränkung",
		"LiabilityLimitText": "Wir stellen den Dienst \"wie besehen\" ohne Garantien bereit. Wir haften nicht für Schäden, die durch die Nutzung des Dienstes oder das Vertrauen auf die bereitgestellten Informationen entstehen. Unsere Haftung ist auf das gesetzlich zulässige Maximum beschränkt.",
		"ChangesTitle": "Änderungen der Bedingungen",
		"ChangesText": "Wir können diese Bedingungen jederzeit aktualisieren. Die weitere Nutzung des Dienstes nach Änderungen gilt als Annahme der neuen Bedingungen. Wir werden Sie über wesentliche Änderungen informieren.",
		"ContactTitle": "Fragen?",
		"ContactText": "Wenn Sie Fragen zu diesen Bedingungen haben, kontaktieren Sie uns:"
	},
	"tr": {
		"TermsPageTitle": "Kullanım Koşulları",
		"TermsPageDescription": "docta.me kullanım koşulları. Lütfen tıbbi bilgi hizmetimizi kullanmadan önce okuyun.",
		"TermsPageSubtitle": "Lütfen hizmetimizi kullanmadan önce bu koşulları okuyun. Haklarınızı ve sorumluluklarınızı açıklarlar.",
		"WhatWeAreTitle": "Ne yapıyoruz",
		"WhatWeAreText": "docta.me, Karadağ'da doktor, klinik ve sağlık tesisleri bulmanıza yardımcı olan bir tıbbi bilgi hizmetidir. Sağlığınız hakkında bilinçli kararlar vermenize yardımcı olmak için bilgi sağlıyoruz.",
		"MedicalDisclaimerTitle": "Tıbbi sorumluluk reddi",
		"MedicalDisclaimerText": "Bu web sitesindeki bilgiler yalnızca genel bilgilendirme amaçlıdır ve profesyonel tıbbi tavsiye, teşhis veya tedavinin yerini almaz. Bir sağlık durumu hakkında herhangi bir sorunuz varsa her zaman nitelikli bir sağlık uzmanına danışın.",
		"AccountTitle": "Hesabınız",
		"AccountText": "Hesap kimlik bilgilerinizin gizliliğini korumaktan siz sorumlusunuz. Doğru bilgi vermeyi ve güncel tutmayı kabul ediyorsunuz. Bu koşulları ihlal eden hesapları askıya alma veya sonlandırma hakkını saklı tutuyoruz.",
		"DataAccuracyTitle": "Bilgi doğruluğu",
		"DataAccuracyText": "Sağlık hizmeti sağlayıcıları hakkında doğru ve güncel bilgi vermeye çalışıyoruz. Ancak çalışma saatleri, hizmetler ve iletişim bilgileri gibi ayrıntılar değişebilir. Önemli ayrıntıları her zaman doğrudan sağlayıcıyla doğrulayın.",
		"IntellectualPropertyTitle": "Fikri mülkiyet",
		"IntellectualPropertyText": "docta.me'deki metin, grafik, logolar ve yazılım dahil tüm içerik bize aittir veya bize lisanslanmıştır. İzin almadan içeriğimizi kopyalayamaz, değiştiremez veya dağıtamazsınız.",
		"ProhibitedUseTitle": "Yasaklanmış kullanım",
		"ProhibitedUseIntro": "Aşağıdakileri yapmamayı kabul ediyorsunuz:",
		"ProhibitedUse1": "Hizmeti yasadışı amaçlarla kullanmak",
		"ProhibitedUse2": "Sistemlerimize yetkisiz erişim elde etmeye çalışmak",
		"ProhibitedUse3": "Zararlı içerik yüklemek veya hizmeti bozmak",
		"ProhibitedUse4": "İzinsiz veri toplamak",
		"LiabilityLimitTitle": "Sorumluluk sınırlaması",
		"LiabilityLimitText": "Hizmeti garantisiz \"olduğu gibi\" sağlıyoruz. Hizmeti kullanmanızdan veya sağlanan bilgilere güvenmenizden kaynaklanan herhangi bir zarardan sorumlu değiliz. Sorumluluğumuz yasaların izin verdiği azami ölçüde sınırlıdır.",
		"ChangesTitle": "Koşullarda değişiklikler",
		"ChangesText": "Bu koşulları istediğimiz zaman güncelleyebiliriz. Değişikliklerden sonra hizmeti kullanmaya devam etmeniz yeni koşulları kabul ettiğiniz anlamına gelir. Önemli değişiklikler hakkında sizi bilgilendireceğiz.",
		"ContactTitle": "Sorular?",
		"ContactText": "Bu koşullar hakkında sorularınız varsa bizimle iletişime geçin:"
	}
}
</i18n>
