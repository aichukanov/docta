<script setup lang="ts">
import { SITE_URL, OG_IMAGE, PROJECT_CONTACTS } from '~/common/constants';

const { t } = useI18n();
const { t: $t } = useI18n({ useScope: 'global' });
const route = useRoute();

const seoTitle = computed(
	() => t('PrivacyPageTitle') + ' | ' + $t('ApplicationName'),
);

const seoDescription = computed(() => t('PrivacyPageDescription'));

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
	<main class="privacy-page" role="main">
		<div class="privacy-page__container">
			<header class="privacy-page__header">
				<h1 class="privacy-page__title">{{ t('PrivacyPageTitle') }}</h1>
				<p class="privacy-page__subtitle">{{ t('PrivacyPageSubtitle') }}</p>
			</header>

			<article class="privacy-page__grid">
				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('WhatWeCollectTitle') }}</h2>
					<p class="privacy-card__text">{{ t('WhatWeCollectText') }}</p>
					<ul class="privacy-card__list">
						<li>{{ t('CollectItem1') }}</li>
						<li>{{ t('CollectItem2') }}</li>
						<li>{{ t('CollectItem3') }}</li>
					</ul>
				</section>

				<section class="privacy-card privacy-card--highlight">
					<h2 class="privacy-card__title">{{ t('AccountDataTitle') }}</h2>
					<p class="privacy-card__text">{{ t('AccountDataText') }}</p>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('OAuthTitle') }}</h2>
					<p class="privacy-card__text">{{ t('OAuthText') }}</p>
					<ul class="privacy-card__list">
						<li><strong>Google</strong> — {{ t('OAuthGoogle') }}</li>
						<li><strong>Facebook</strong> — {{ t('OAuthFacebook') }}</li>
						<li><strong>Telegram</strong> — {{ t('OAuthTelegram') }}</li>
					</ul>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('DataUsageTitle') }}</h2>
					<p class="privacy-card__text">{{ t('DataUsageText') }}</p>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('CookiesTitle') }}</h2>
					<p class="privacy-card__text">{{ t('CookiesText') }}</p>
				</section>

				<section id="data-deletion" class="privacy-card privacy-card--warning">
					<h2 class="privacy-card__title">{{ t('DataDeletionTitle') }}</h2>
					<p class="privacy-card__text">{{ t('DataDeletionText') }}</p>
					<ol class="privacy-card__list privacy-card__list--numbered">
						<li>{{ t('DeleteStep1') }}</li>
						<li>{{ t('DeleteStep2') }}</li>
						<li>{{ t('DeleteStep3') }}</li>
					</ol>
					<p class="privacy-card__text">{{ t('DataDeletionAlternative') }}</p>
					<a
						class="privacy-card__contact-link"
						:href="`mailto:${PROJECT_CONTACTS.email}`"
						target="_blank"
					>
						<span>{{ PROJECT_CONTACTS.email }}</span>
					</a>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('YourRightsTitle') }}</h2>
					<p class="privacy-card__text">{{ t('YourRightsText') }}</p>
				</section>

				<section class="privacy-card privacy-card--contact">
					<h2 class="privacy-card__title">{{ t('QuestionsTitle') }}</h2>
					<p class="privacy-card__text">{{ t('QuestionsText') }}</p>
					<a
						class="privacy-card__contact-link"
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

.privacy-page {
	padding: var(--spacing-2xl) @base-padding;
	min-height: calc(100vh - 200px);
}

.privacy-page__container {
	max-width: 980px;
	margin: 0 auto;
}

.privacy-page__header {
	margin-bottom: var(--spacing-2xl);
}

.privacy-page__title {
	margin: 0 0 var(--spacing-sm);
	font-size: clamp(1.8rem, 4vw, 2.6rem);
	letter-spacing: -0.02em;
	color: var(--color-text-primary);
	line-height: 1.15;
	font-weight: var(--font-weight-semibold);
}

.privacy-page__subtitle {
	margin: 0;
	max-width: 760px;
	color: var(--color-text-secondary);
	font-size: clamp(1rem, 2vw, 1.2rem);
	line-height: 1.7;
}

.privacy-page__grid {
	display: grid;
	grid-template-columns: 1fr;
	gap: var(--spacing-xl);
}

.privacy-card {
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

.privacy-card--highlight {
	border-color: rgba(43, 50, 247, 0.15);
	background: linear-gradient(
		180deg,
		rgba(43, 50, 247, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.privacy-card--warning {
	border-color: rgba(239, 68, 68, 0.25);
	background: linear-gradient(
		180deg,
		rgba(239, 68, 68, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.privacy-card--contact {
	border-color: rgba(43, 50, 247, 0.2);
	background: linear-gradient(
		180deg,
		rgba(43, 50, 247, 0.04) 0%,
		rgba(255, 255, 255, 1) 70%
	);
}

.privacy-card__title {
	margin: 0 0 var(--spacing-lg);
	font-size: 1.5rem;
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
	letter-spacing: -0.01em;
	line-height: 1.3;
}

.privacy-card__text {
	margin: 0 0 var(--spacing-md);
	color: var(--color-text-secondary);
	line-height: 1.75;
	font-size: var(--font-size-lg);

	&:last-child {
		margin-bottom: 0;
	}
}

.privacy-card__list {
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

	&--numbered {
		list-style: decimal;
	}
}

.privacy-card__contact-link {
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
	.privacy-page {
		padding: var(--spacing-xl) @base-offset;
	}

	.privacy-card {
		padding: var(--spacing-xl);
		border-radius: 16px;
	}

	.privacy-card__title {
		font-size: 1.25rem;
	}

	.privacy-card__text,
	.privacy-card__list {
		font-size: var(--font-size-md);
	}
}
</style>

<i18n lang="json">
{
	"en": {
		"PrivacyPageTitle": "Privacy Policy",
		"PrivacyPageDescription": "Learn how docta.me collects, uses, and protects your data. Your privacy matters to us.",
		"PrivacyPageSubtitle": "We value your privacy. This page explains what data we collect and how we use it.",
		"WhatWeCollectTitle": "What we collect",
		"WhatWeCollectText": "When you use docta.me, we may collect:",
		"CollectItem1": "Account information (email, name) when you register",
		"CollectItem2": "Profile data from social login providers (Google, Facebook, Telegram)",
		"CollectItem3": "Anonymous usage data to improve the service",
		"AccountDataTitle": "Your account data",
		"AccountDataText": "If you create an account, we store your email and name to provide personalized services. We never share your personal data with third parties for marketing purposes.",
		"OAuthTitle": "Social login",
		"OAuthText": "When you sign in with a social provider, we receive:",
		"OAuthGoogle": "email, name, profile picture",
		"OAuthFacebook": "email, name, profile picture",
		"OAuthTelegram": "name, username, profile picture",
		"DataUsageTitle": "How we use your data",
		"DataUsageText": "We use your data to provide and improve our services: authenticate your account, personalize your experience, and communicate important updates. We do not sell your data.",
		"CookiesTitle": "Cookies",
		"CookiesText": "We use essential cookies for authentication and session management. We may also use analytics cookies to understand how our service is used.",
		"DataDeletionTitle": "Delete your data",
		"DataDeletionText": "You can request complete deletion of your account and all associated data:",
		"DeleteStep1": "Log in to your account",
		"DeleteStep2": "Go to Settings → Account",
		"DeleteStep3": "Click \"Delete Account\" and confirm",
		"DataDeletionAlternative": "Alternatively, you can email us and we'll process your request within 48 hours:",
		"YourRightsTitle": "Your rights",
		"YourRightsText": "You have the right to access, correct, or delete your personal data at any time. You can also request a copy of all data we have about you.",
		"QuestionsTitle": "Questions?",
		"QuestionsText": "If you have questions about privacy or your data, contact us:"
	},
	"ru": {
		"PrivacyPageTitle": "Политика конфиденциальности",
		"PrivacyPageDescription": "Узнайте, как docta.me собирает, использует и защищает ваши данные. Ваша конфиденциальность важна для нас.",
		"PrivacyPageSubtitle": "Мы ценим вашу конфиденциальность. Эта страница объясняет, какие данные мы собираем и как их используем.",
		"WhatWeCollectTitle": "Что мы собираем",
		"WhatWeCollectText": "При использовании docta.me мы можем собирать:",
		"CollectItem1": "Информацию об аккаунте (email, имя) при регистрации",
		"CollectItem2": "Данные профиля от социальных сетей (Google, Facebook, Telegram)",
		"CollectItem3": "Анонимные данные об использовании для улучшения сервиса",
		"AccountDataTitle": "Данные вашего аккаунта",
		"AccountDataText": "Если вы создаете аккаунт, мы храним ваш email и имя для предоставления персонализированных услуг. Мы никогда не передаем ваши личные данные третьим лицам в маркетинговых целях.",
		"OAuthTitle": "Вход через социальные сети",
		"OAuthText": "При входе через социальную сеть мы получаем:",
		"OAuthGoogle": "email, имя, фото профиля",
		"OAuthFacebook": "email, имя, фото профиля",
		"OAuthTelegram": "имя, username, фото профиля",
		"DataUsageTitle": "Как мы используем данные",
		"DataUsageText": "Мы используем ваши данные для предоставления и улучшения сервиса: аутентификация, персонализация, важные уведомления. Мы не продаем ваши данные.",
		"CookiesTitle": "Cookies",
		"CookiesText": "Мы используем необходимые cookies для аутентификации и управления сессией. Также можем использовать аналитические cookies для понимания использования сервиса.",
		"DataDeletionTitle": "Удаление данных",
		"DataDeletionText": "Вы можете запросить полное удаление аккаунта и всех связанных данных:",
		"DeleteStep1": "Войдите в аккаунт",
		"DeleteStep2": "Перейдите в Настройки → Аккаунт",
		"DeleteStep3": "Нажмите \"Удалить аккаунт\" и подтвердите",
		"DataDeletionAlternative": "Или напишите нам, и мы обработаем запрос в течение 48 часов:",
		"YourRightsTitle": "Ваши права",
		"YourRightsText": "Вы имеете право на доступ, исправление или удаление ваших личных данных в любое время. Вы также можете запросить копию всех данных о вас.",
		"QuestionsTitle": "Вопросы?",
		"QuestionsText": "Если есть вопросы о конфиденциальности или ваших данных, свяжитесь с нами:"
	},
	"sr": {
		"PrivacyPageTitle": "Politika privatnosti",
		"PrivacyPageDescription": "Saznajte kako docta.me prikuplja, koristi i štiti vaše podatke. Vaša privatnost nam je važna.",
		"PrivacyPageSubtitle": "Cijenimo vašu privatnost. Ova stranica objašnjava koje podatke prikupljamo i kako ih koristimo.",
		"WhatWeCollectTitle": "Šta prikupljamo",
		"WhatWeCollectText": "Kada koristite docta.me, možemo prikupljati:",
		"CollectItem1": "Informacije o nalogu (email, ime) prilikom registracije",
		"CollectItem2": "Podatke profila od društvenih mreža (Google, Facebook, Telegram)",
		"CollectItem3": "Anonimne podatke o korištenju za poboljšanje servisa",
		"AccountDataTitle": "Podaci vašeg naloga",
		"AccountDataText": "Ako kreirate nalog, čuvamo vaš email i ime za pružanje personalizovanih usluga. Nikada ne dijelimo vaše lične podatke trećim stranama u marketinške svrhe.",
		"OAuthTitle": "Prijava preko društvenih mreža",
		"OAuthText": "Kada se prijavite preko društvene mreže, dobijamo:",
		"OAuthGoogle": "email, ime, profilna slika",
		"OAuthFacebook": "email, ime, profilna slika",
		"OAuthTelegram": "ime, korisničko ime, profilna slika",
		"DataUsageTitle": "Kako koristimo podatke",
		"DataUsageText": "Koristimo vaše podatke za pružanje i poboljšanje servisa: autentifikacija, personalizacija, važna obavještenja. Ne prodajemo vaše podatke.",
		"CookiesTitle": "Kolačići",
		"CookiesText": "Koristimo neophodne kolačiće za autentifikaciju i upravljanje sesijom. Takođe možemo koristiti analitičke kolačiće za razumijevanje korištenja servisa.",
		"DataDeletionTitle": "Brisanje podataka",
		"DataDeletionText": "Možete zatražiti potpuno brisanje naloga i svih povezanih podataka:",
		"DeleteStep1": "Prijavite se na nalog",
		"DeleteStep2": "Idite na Postavke → Nalog",
		"DeleteStep3": "Kliknite \"Obriši nalog\" i potvrdite",
		"DataDeletionAlternative": "Ili nam pišite i obradićemo zahtjev u roku od 48 sati:",
		"YourRightsTitle": "Vaša prava",
		"YourRightsText": "Imate pravo na pristup, ispravku ili brisanje vaših ličnih podataka u bilo koje vrijeme. Takođe možete zatražiti kopiju svih podataka o vama.",
		"QuestionsTitle": "Pitanja?",
		"QuestionsText": "Ako imate pitanja o privatnosti ili vašim podacima, kontaktirajte nas:"
	},
	"de": {
		"PrivacyPageTitle": "Datenschutzerklärung",
		"PrivacyPageDescription": "Erfahren Sie, wie docta.me Ihre Daten sammelt, verwendet und schützt. Ihre Privatsphäre ist uns wichtig.",
		"PrivacyPageSubtitle": "Wir schätzen Ihre Privatsphäre. Diese Seite erklärt, welche Daten wir sammeln und wie wir sie verwenden.",
		"WhatWeCollectTitle": "Was wir sammeln",
		"WhatWeCollectText": "Bei der Nutzung von docta.me können wir sammeln:",
		"CollectItem1": "Kontoinformationen (E-Mail, Name) bei der Registrierung",
		"CollectItem2": "Profildaten von sozialen Netzwerken (Google, Facebook, Telegram)",
		"CollectItem3": "Anonyme Nutzungsdaten zur Verbesserung des Dienstes",
		"AccountDataTitle": "Ihre Kontodaten",
		"AccountDataText": "Wenn Sie ein Konto erstellen, speichern wir Ihre E-Mail und Ihren Namen für personalisierte Dienste. Wir geben Ihre persönlichen Daten niemals zu Marketingzwecken an Dritte weiter.",
		"OAuthTitle": "Social Login",
		"OAuthText": "Bei der Anmeldung über ein soziales Netzwerk erhalten wir:",
		"OAuthGoogle": "E-Mail, Name, Profilbild",
		"OAuthFacebook": "E-Mail, Name, Profilbild",
		"OAuthTelegram": "Name, Benutzername, Profilbild",
		"DataUsageTitle": "Wie wir Ihre Daten verwenden",
		"DataUsageText": "Wir verwenden Ihre Daten zur Bereitstellung und Verbesserung unserer Dienste: Authentifizierung, Personalisierung, wichtige Updates. Wir verkaufen Ihre Daten nicht.",
		"CookiesTitle": "Cookies",
		"CookiesText": "Wir verwenden essentielle Cookies für Authentifizierung und Sitzungsverwaltung. Wir können auch Analyse-Cookies verwenden, um die Nutzung zu verstehen.",
		"DataDeletionTitle": "Daten löschen",
		"DataDeletionText": "Sie können die vollständige Löschung Ihres Kontos und aller zugehörigen Daten anfordern:",
		"DeleteStep1": "Melden Sie sich bei Ihrem Konto an",
		"DeleteStep2": "Gehen Sie zu Einstellungen → Konto",
		"DeleteStep3": "Klicken Sie auf \"Konto löschen\" und bestätigen Sie",
		"DataDeletionAlternative": "Alternativ können Sie uns eine E-Mail senden und wir bearbeiten Ihre Anfrage innerhalb von 48 Stunden:",
		"YourRightsTitle": "Ihre Rechte",
		"YourRightsText": "Sie haben jederzeit das Recht auf Zugang, Berichtigung oder Löschung Ihrer persönlichen Daten. Sie können auch eine Kopie aller Daten über Sie anfordern.",
		"QuestionsTitle": "Fragen?",
		"QuestionsText": "Wenn Sie Fragen zum Datenschutz oder Ihren Daten haben, kontaktieren Sie uns:"
	},
	"tr": {
		"PrivacyPageTitle": "Gizlilik Politikası",
		"PrivacyPageDescription": "docta.me'nin verilerinizi nasıl topladığını, kullandığını ve koruduğunu öğrenin. Gizliliğiniz bizim için önemli.",
		"PrivacyPageSubtitle": "Gizliliğinize değer veriyoruz. Bu sayfa hangi verileri topladığımızı ve nasıl kullandığımızı açıklar.",
		"WhatWeCollectTitle": "Neler topluyoruz",
		"WhatWeCollectText": "docta.me kullanırken toplayabileceğimiz veriler:",
		"CollectItem1": "Kayıt sırasında hesap bilgileri (e-posta, isim)",
		"CollectItem2": "Sosyal ağlardan profil verileri (Google, Facebook, Telegram)",
		"CollectItem3": "Hizmeti geliştirmek için anonim kullanım verileri",
		"AccountDataTitle": "Hesap verileriniz",
		"AccountDataText": "Hesap oluşturursanız, kişiselleştirilmiş hizmetler için e-postanızı ve adınızı saklarız. Kişisel verilerinizi pazarlama amaçlı üçüncü taraflarla asla paylaşmayız.",
		"OAuthTitle": "Sosyal giriş",
		"OAuthText": "Sosyal ağ üzerinden giriş yaptığınızda aldığımız veriler:",
		"OAuthGoogle": "e-posta, isim, profil fotoğrafı",
		"OAuthFacebook": "e-posta, isim, profil fotoğrafı",
		"OAuthTelegram": "isim, kullanıcı adı, profil fotoğrafı",
		"DataUsageTitle": "Verilerinizi nasıl kullanıyoruz",
		"DataUsageText": "Verilerinizi hizmetlerimizi sağlamak ve geliştirmek için kullanıyoruz: kimlik doğrulama, kişiselleştirme, önemli güncellemeler. Verilerinizi satmıyoruz.",
		"CookiesTitle": "Çerezler",
		"CookiesText": "Kimlik doğrulama ve oturum yönetimi için gerekli çerezleri kullanıyoruz. Hizmet kullanımını anlamak için analitik çerezler de kullanabiliriz.",
		"DataDeletionTitle": "Verilerinizi silin",
		"DataDeletionText": "Hesabınızın ve tüm ilişkili verilerin tamamen silinmesini talep edebilirsiniz:",
		"DeleteStep1": "Hesabınıza giriş yapın",
		"DeleteStep2": "Ayarlar → Hesap'a gidin",
		"DeleteStep3": "\"Hesabı Sil\"e tıklayın ve onaylayın",
		"DataDeletionAlternative": "Alternatif olarak bize e-posta gönderin, talebinizi 48 saat içinde işleme alacağız:",
		"YourRightsTitle": "Haklarınız",
		"YourRightsText": "Kişisel verilerinize istediğiniz zaman erişme, düzeltme veya silme hakkınız var. Ayrıca hakkınızdaki tüm verilerin bir kopyasını talep edebilirsiniz.",
		"QuestionsTitle": "Sorular?",
		"QuestionsText": "Gizlilik veya verileriniz hakkında sorularınız varsa, bizimle iletişime geçin:"
	}
}
</i18n>
