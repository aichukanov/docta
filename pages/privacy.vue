<script setup lang="ts">
import {
	SITE_URL,
	OG_IMAGE,
	PROJECT_CONTACTS,
	LEGAL_ENTITY,
} from '~/common/constants';

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
				<p class="privacy-page__updated">{{ t('LastUpdated') }}</p>
			</header>

			<article class="privacy-page__grid">
				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('DataControllerTitle') }}</h2>
					<p class="privacy-card__text">{{ t('DataControllerText', { registrationNumber: LEGAL_ENTITY.registrationNumber }) }}</p>
				</section>
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
					<h2 class="privacy-card__title">{{ t('LegalBasisTitle') }}</h2>
					<p class="privacy-card__text">{{ t('LegalBasisText') }}</p>
					<ul class="privacy-card__list">
						<li><strong>{{ t('LegalBasisConsent') }}</strong> — {{ t('LegalBasisConsentDesc') }}</li>
						<li><strong>{{ t('LegalBasisContract') }}</strong> — {{ t('LegalBasisContractDesc') }}</li>
						<li><strong>{{ t('LegalBasisLegitimate') }}</strong> — {{ t('LegalBasisLegitimateDesc') }}</li>
					</ul>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('ThirdPartyTitle') }}</h2>
					<p class="privacy-card__text">{{ t('ThirdPartyText') }}</p>
					<ul class="privacy-card__list">
						<li><strong>Google Analytics</strong> — {{ t('ThirdPartyGoogle') }}</li>
						<li><strong>Mixpanel</strong> — {{ t('ThirdPartyMixpanel') }}</li>
						<li><strong>Cloudflare</strong> — {{ t('ThirdPartyCloudflare') }}</li>
					</ul>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('InternationalTransfersTitle') }}</h2>
					<p class="privacy-card__text">{{ t('InternationalTransfersText') }}</p>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('CookiesTitle') }}</h2>
					<p class="privacy-card__text">{{ t('CookiesText') }}</p>
					<ul class="privacy-card__list">
						<li><strong>ncc_c</strong> — {{ t('CookieNcc') }}</li>
						<li><strong>_ga, _gid, _gat</strong> — {{ t('CookieGa') }}</li>
						<li><strong>mp_*</strong> — {{ t('CookieMixpanel') }}</li>
						<li><strong>__cf_bm, __cflb</strong> — {{ t('CookieCloudflare') }}</li>
					</ul>
					<p class="privacy-card__text">{{ t('CookiesWithdraw') }}</p>
				</section>

				<section class="privacy-card">
					<h2 class="privacy-card__title">{{ t('DataRetentionTitle') }}</h2>
					<p class="privacy-card__text">{{ t('DataRetentionText') }}</p>
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
					<ul class="privacy-card__list">
						<li>{{ t('RightAccess') }}</li>
						<li>{{ t('RightRectify') }}</li>
						<li>{{ t('RightErase') }}</li>
						<li>{{ t('RightRestrict') }}</li>
						<li>{{ t('RightPortability') }}</li>
						<li>{{ t('RightObject') }}</li>
						<li>{{ t('RightWithdraw') }}</li>
					</ul>
					<p class="privacy-card__text">{{ t('SupervisoryAuthority') }}</p>
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
.privacy-page {
	padding: var(--spacing-2xl) var(--spacing-lg);
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

.privacy-page__updated {
	margin: var(--spacing-sm) 0 0;
	color: var(--color-text-light);
	font-size: var(--font-size-sm);
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
		padding: var(--spacing-xl) var(--spacing-sm);
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
		"LastUpdated": "Last updated: April 16, 2026",
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
		"LegalBasisTitle": "Legal basis for processing",
		"LegalBasisText": "We process your personal data based on the following legal grounds under GDPR:",
		"LegalBasisConsent": "Consent (Art. 6(1)(a))",
		"LegalBasisConsentDesc": "for analytics cookies and marketing communications. You can withdraw consent at any time.",
		"LegalBasisContract": "Contract performance (Art. 6(1)(b))",
		"LegalBasisContractDesc": "for account management, authentication, and providing our core services.",
		"LegalBasisLegitimate": "Legitimate interest (Art. 6(1)(f))",
		"LegalBasisLegitimateDesc": "for essential cookies, security measures, and service improvement.",
		"ThirdPartyTitle": "Third-party services",
		"ThirdPartyText": "We share data with the following service providers who process it on our behalf:",
		"ThirdPartyGoogle": "website traffic analysis and advertising measurement (USA)",
		"ThirdPartyMixpanel": "product analytics and user behavior analysis (EU data residency)",
		"ThirdPartyCloudflare": "security, CDN, and performance analytics (global network)",
		"InternationalTransfersTitle": "International data transfers",
		"InternationalTransfersText": "Some of our service providers (Google, Cloudflare) are based in the United States. Data transfers to the US are covered by the EU-US Data Privacy Framework. We only use providers that offer adequate data protection safeguards in accordance with GDPR Article 46.",
		"CookiesTitle": "Cookies",
		"CookiesText": "We use the following cookies:",
		"CookieNcc": "stores your cookie consent preference (1 year, essential)",
		"CookieGa": "Google Analytics, website usage statistics (up to 2 years, analytics)",
		"CookieMixpanel": "Mixpanel, product analytics (1 year, analytics)",
		"CookieCloudflare": "Cloudflare, security and performance (up to 30 minutes, essential)",
		"CookiesWithdraw": "Analytics cookies are only set after you give consent. You can change your preference at any time via the \"Cookie settings\" link in the footer.",
		"DataRetentionTitle": "Data retention",
		"DataRetentionText": "Account data is retained for as long as your account is active. If you delete your account, all personal data is removed within 48 hours. Analytics data is stored in anonymized form and retained for up to 24 months. Cookie consent preferences are stored for 12 months.",
		"DataDeletionTitle": "Delete your data",
		"DataDeletionText": "You can request complete deletion of your account and all associated data:",
		"DeleteStep1": "Log in to your account",
		"DeleteStep2": "Go to Settings → Account",
		"DeleteStep3": "Click \"Delete Account\" and confirm",
		"DataDeletionAlternative": "Alternatively, you can email us and we'll process your request within 48 hours:",
		"YourRightsTitle": "Your rights",
		"YourRightsText": "Under GDPR, you have the following rights regarding your personal data:",
		"RightAccess": "Right of access — obtain a copy of your personal data",
		"RightRectify": "Right to rectification — correct inaccurate data",
		"RightErase": "Right to erasure — request deletion of your data",
		"RightRestrict": "Right to restriction — limit how we process your data",
		"RightPortability": "Right to data portability — receive your data in a structured format",
		"RightObject": "Right to object — object to processing based on legitimate interest",
		"RightWithdraw": "Right to withdraw consent — revoke consent at any time without affecting prior processing",
		"SupervisoryAuthority": "You also have the right to lodge a complaint with a data protection supervisory authority. As we operate from Armenia serving users in the EU, you may contact the supervisory authority in your country of residence.",
		"QuestionsTitle": "Questions?",
		"QuestionsText": "If you have questions about privacy or your data, contact us:",
		"DataControllerTitle": "Data controller",
		"DataControllerText": "The data controller for docta.me is an Individual Entrepreneur registered in the Republic of Armenia (state registration number: {registrationNumber}). For any data-related inquiries, contact us at contact{'@'}svad.net."
	},
	"ru": {
		"PrivacyPageTitle": "Политика конфиденциальности",
		"PrivacyPageDescription": "Узнайте, как docta.me собирает, использует и защищает ваши данные. Ваша конфиденциальность важна для нас.",
		"PrivacyPageSubtitle": "Мы ценим вашу конфиденциальность. Эта страница объясняет, какие данные мы собираем и как их используем.",
		"LastUpdated": "Последнее обновление: 16 апреля 2026",
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
		"LegalBasisTitle": "Правовые основания обработки",
		"LegalBasisText": "Мы обрабатываем ваши персональные данные на следующих правовых основаниях в соответствии с GDPR:",
		"LegalBasisConsent": "Согласие (ст. 6(1)(a))",
		"LegalBasisConsentDesc": "для аналитических cookies и маркетинговых коммуникаций. Согласие можно отозвать в любой момент.",
		"LegalBasisContract": "Исполнение договора (ст. 6(1)(b))",
		"LegalBasisContractDesc": "для управления аккаунтом, аутентификации и предоставления основных услуг.",
		"LegalBasisLegitimate": "Законный интерес (ст. 6(1)(f))",
		"LegalBasisLegitimateDesc": "для необходимых cookies, мер безопасности и улучшения сервиса.",
		"ThirdPartyTitle": "Сторонние сервисы",
		"ThirdPartyText": "Мы передаём данные следующим поставщикам услуг, которые обрабатывают их от нашего имени:",
		"ThirdPartyGoogle": "анализ трафика сайта и измерение рекламы (США)",
		"ThirdPartyMixpanel": "продуктовая аналитика и анализ поведения пользователей (хранение данных в ЕС)",
		"ThirdPartyCloudflare": "безопасность, CDN и аналитика производительности (глобальная сеть)",
		"InternationalTransfersTitle": "Международная передача данных",
		"InternationalTransfersText": "Некоторые из наших поставщиков услуг (Google, Cloudflare) базируются в США. Передача данных в США осуществляется в рамках EU-US Data Privacy Framework. Мы используем только поставщиков, обеспечивающих надлежащую защиту данных в соответствии со статьёй 46 GDPR.",
		"CookiesTitle": "Cookies",
		"CookiesText": "Мы используем следующие cookies:",
		"CookieNcc": "хранит ваше решение о cookies (1 год, необходимый)",
		"CookieGa": "Google Analytics, статистика использования сайта (до 2 лет, аналитический)",
		"CookieMixpanel": "Mixpanel, продуктовая аналитика (1 год, аналитический)",
		"CookieCloudflare": "Cloudflare, безопасность и производительность (до 30 минут, необходимый)",
		"CookiesWithdraw": "Аналитические cookies устанавливаются только после вашего согласия. Изменить решение можно в любой момент через ссылку «Настройки cookies» в подвале сайта.",
		"DataRetentionTitle": "Сроки хранения данных",
		"DataRetentionText": "Данные аккаунта хранятся, пока аккаунт активен. При удалении аккаунта все персональные данные удаляются в течение 48 часов. Аналитические данные хранятся в анонимизированном виде до 24 месяцев. Решение о cookies хранится 12 месяцев.",
		"DataDeletionTitle": "Удаление данных",
		"DataDeletionText": "Вы можете запросить полное удаление аккаунта и всех связанных данных:",
		"DeleteStep1": "Войдите в аккаунт",
		"DeleteStep2": "Перейдите в Настройки → Аккаунт",
		"DeleteStep3": "Нажмите \"Удалить аккаунт\" и подтвердите",
		"DataDeletionAlternative": "Или напишите нам, и мы обработаем запрос в течение 48 часов:",
		"YourRightsTitle": "Ваши права",
		"YourRightsText": "В соответствии с GDPR вы имеете следующие права в отношении ваших персональных данных:",
		"RightAccess": "Право на доступ — получить копию ваших персональных данных",
		"RightRectify": "Право на исправление — скорректировать неточные данные",
		"RightErase": "Право на удаление — запросить удаление ваших данных",
		"RightRestrict": "Право на ограничение — ограничить способы обработки данных",
		"RightPortability": "Право на переносимость — получить данные в структурированном формате",
		"RightObject": "Право на возражение — возразить против обработки на основе законного интереса",
		"RightWithdraw": "Право на отзыв согласия — отозвать согласие в любой момент без влияния на законность предшествующей обработки",
		"SupervisoryAuthority": "Вы также имеете право подать жалобу в надзорный орган по защите данных. Поскольку мы работаем из Армении для пользователей в ЕС, вы можете обратиться в надзорный орган вашей страны проживания.",
		"QuestionsTitle": "Вопросы?",
		"QuestionsText": "Если есть вопросы о конфиденциальности или ваших данных, свяжитесь с нами:",
		"DataControllerTitle": "Оператор данных",
		"DataControllerText": "Оператором персональных данных на docta.me является индивидуальный предприниматель, зарегистрированный в Республике Армения (ОГРН: {registrationNumber}). По вопросам обработки данных: contact{'@'}svad.net."
	},
	"sr": {
		"PrivacyPageTitle": "Politika privatnosti",
		"PrivacyPageDescription": "Saznajte kako docta.me prikuplja, koristi i štiti vaše podatke. Vaša privatnost nam je važna.",
		"PrivacyPageSubtitle": "Cijenimo vašu privatnost. Ova stranica objašnjava koje podatke prikupljamo i kako ih koristimo.",
		"LastUpdated": "Poslednje ažuriranje: 16. april 2026.",
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
		"LegalBasisTitle": "Pravni osnov obrade",
		"LegalBasisText": "Obrađujemo vaše lične podatke na sledećim pravnim osnovima prema GDPR-u:",
		"LegalBasisConsent": "Saglasnost (čl. 6(1)(a))",
		"LegalBasisConsentDesc": "za analitičke kolačiće i marketinške komunikacije. Saglasnost možete povući u bilo kom trenutku.",
		"LegalBasisContract": "Izvršenje ugovora (čl. 6(1)(b))",
		"LegalBasisContractDesc": "za upravljanje nalogom, autentifikaciju i pružanje osnovnih usluga.",
		"LegalBasisLegitimate": "Legitimni interes (čl. 6(1)(f))",
		"LegalBasisLegitimateDesc": "za neophodne kolačiće, bezbednosne mere i poboljšanje servisa.",
		"ThirdPartyTitle": "Servisi trećih strana",
		"ThirdPartyText": "Dijelimo podatke sa sledećim pružaocima usluga koji ih obrađuju u naše ime:",
		"ThirdPartyGoogle": "analiza saobraćaja na sajtu i merenje oglašavanja (SAD)",
		"ThirdPartyMixpanel": "produktna analitika i analiza ponašanja korisnika (čuvanje podataka u EU)",
		"ThirdPartyCloudflare": "bezbednost, CDN i analitika performansi (globalna mreža)",
		"InternationalTransfersTitle": "Međunarodni prenos podataka",
		"InternationalTransfersText": "Neki od naših pružalaca usluga (Google, Cloudflare) nalaze se u SAD-u. Prenos podataka u SAD pokriven je EU-US Data Privacy Framework-om. Koristimo samo pružaoce koji obezbeđuju adekvatnu zaštitu podataka u skladu sa članom 46 GDPR-a.",
		"CookiesTitle": "Kolačići",
		"CookiesText": "Koristimo sledeće kolačiće:",
		"CookieNcc": "čuva vašu odluku o kolačićima (1 godina, neophodan)",
		"CookieGa": "Google Analytics, statistika korištenja sajta (do 2 godine, analitički)",
		"CookieMixpanel": "Mixpanel, produktna analitika (1 godina, analitički)",
		"CookieCloudflare": "Cloudflare, bezbednost i performanse (do 30 minuta, neophodan)",
		"CookiesWithdraw": "Analitički kolačići se postavljaju tek nakon vaše saglasnosti. Odluku možete promeniti u bilo kom trenutku putem linka 'Podešavanja kolačića' u podnožju sajta.",
		"DataRetentionTitle": "Periodi čuvanja podataka",
		"DataRetentionText": "Podaci naloga se čuvaju dok je nalog aktivan. Ako obrišete nalog, svi lični podaci se uklanjaju u roku od 48 sati. Analitički podaci se čuvaju u anonimizovanom obliku do 24 meseca. Odluka o kolačićima se čuva 12 meseci.",
		"DataDeletionTitle": "Brisanje podataka",
		"DataDeletionText": "Možete zatražiti potpuno brisanje naloga i svih povezanih podataka:",
		"DeleteStep1": "Prijavite se na nalog",
		"DeleteStep2": "Idite na Postavke → Nalog",
		"DeleteStep3": "Kliknite \"Obriši nalog\" i potvrdite",
		"DataDeletionAlternative": "Ili nam pišite i obradićemo zahtjev u roku od 48 sati:",
		"YourRightsTitle": "Vaša prava",
		"YourRightsText": "Prema GDPR-u, imate sledeća prava u vezi sa vašim ličnim podacima:",
		"RightAccess": "Pravo na pristup — dobijte kopiju vaših ličnih podataka",
		"RightRectify": "Pravo na ispravku — ispravite netačne podatke",
		"RightErase": "Pravo na brisanje — zatražite brisanje vaših podataka",
		"RightRestrict": "Pravo na ograničenje — ograničite način obrade vaših podataka",
		"RightPortability": "Pravo na prenosivost — dobijte podatke u strukturiranom formatu",
		"RightObject": "Pravo na prigovor — prigovorite obradi zasnovanoj na legitimnom interesu",
		"RightWithdraw": "Pravo na povlačenje saglasnosti — povucite saglasnost u bilo kom trenutku bez uticaja na zakonitost prethodne obrade",
		"SupervisoryAuthority": "Takođe imate pravo da podnesete žalbu nadzornom organu za zaštitu podataka. Pošto poslujemo iz Jermenije za korisnike u EU, možete se obratiti nadzornom organu u vašoj zemlji prebivališta.",
		"QuestionsTitle": "Pitanja?",
		"QuestionsText": "Ako imate pitanja o privatnosti ili vašim podacima, kontaktirajte nas:",
		"DataControllerTitle": "Kontrolor podataka",
		"DataControllerText": "Kontrolor podataka za docta.me je individualni preduzetnik registrovan u Republici Jermeniji (registracioni broj: {registrationNumber}). Za pitanja u vezi sa podacima: contact{'@'}svad.net."
	},
	"sr-cyrl": {
		"PrivacyPageTitle": "Политика приватности",
		"PrivacyPageDescription": "Сазнајте како docta.me прикупља, користи и штити ваше податке. Ваша приватност нам је важна.",
		"PrivacyPageSubtitle": "Ценимо вашу приватност. Ова страница објашњава које податке прикупљамо и како их користимо.",
		"LastUpdated": "Последње ажурирање: 16. април 2026.",
		"WhatWeCollectTitle": "Шта прикупљамо",
		"WhatWeCollectText": "Када користите docta.me, можемо прикупљати:",
		"CollectItem1": "Информације о налогу (email, име) приликом регистрације",
		"CollectItem2": "Податке профила од друштвених мрежа (Google, Facebook, Telegram)",
		"CollectItem3": "Анонимне податке о коришћењу за побољшање сервиса",
		"AccountDataTitle": "Подаци вашег налога",
		"AccountDataText": "Ако креирате налог, чувамо ваш email и име за пружање персонализованих услуга. Никада не делимо ваше личне податке трећим странама у маркетиншке сврхе.",
		"OAuthTitle": "Пријава преко друштвених мрежа",
		"OAuthText": "Када се пријавите преко друштвене мреже, добијамо:",
		"OAuthGoogle": "email, име, профилна слика",
		"OAuthFacebook": "email, име, профилна слика",
		"OAuthTelegram": "име, корисничко име, профилна слика",
		"DataUsageTitle": "Како користимо податке",
		"DataUsageText": "Користимо ваше податке за пружање и побољшање сервиса: аутентификација, персонализација, важна обавештења. Не продајемо ваше податке.",
		"LegalBasisTitle": "Правни основ обраде",
		"LegalBasisText": "Обрађујемо ваше личне податке на следећим правним основима према GDPR-у:",
		"LegalBasisConsent": "Сагласност (чл. 6(1)(a))",
		"LegalBasisConsentDesc": "за аналитичке колачиће и маркетиншке комуникације. Сагласност можете повући у било ком тренутку.",
		"LegalBasisContract": "Извршење уговора (чл. 6(1)(b))",
		"LegalBasisContractDesc": "за управљање налогом, аутентификацију и пружање основних услуга.",
		"LegalBasisLegitimate": "Легитимни интерес (чл. 6(1)(f))",
		"LegalBasisLegitimateDesc": "за неопходне колачиће, безбедносне мере и побољшање сервиса.",
		"ThirdPartyTitle": "Сервиси трећих страна",
		"ThirdPartyText": "Делимо податке са следећим пружаоцима услуга који их обрађују у наше име:",
		"ThirdPartyGoogle": "анализа саобраћаја на сајту и мерење оглашавања (САД)",
		"ThirdPartyMixpanel": "продуктна аналитика и анализа понашања корисника (чување података у ЕУ)",
		"ThirdPartyCloudflare": "безбедност, CDN и аналитика перформанси (глобална мрежа)",
		"InternationalTransfersTitle": "Међународни пренос података",
		"InternationalTransfersText": "Неки од наших пружалаца услуга (Google, Cloudflare) налазе се у САД-у. Пренос података у САД покривен је EU-US Data Privacy Framework-ом. Користимо само пружаоце који обезбеђују адекватну заштиту података у складу са чланом 46 GDPR-а.",
		"CookiesTitle": "Колачићи",
		"CookiesText": "Користимо следеће колачиће:",
		"CookieNcc": "чува вашу одлуку о колачићима (1 година, неопходан)",
		"CookieGa": "Google Analytics, статистика коришћења сајта (до 2 године, аналитички)",
		"CookieMixpanel": "Mixpanel, продуктна аналитика (1 година, аналитички)",
		"CookieCloudflare": "Cloudflare, безбедност и перформансе (до 30 минута, неопходан)",
		"CookiesWithdraw": "Аналитички колачићи се постављају тек након ваше сагласности. Одлуку можете променити у било ком тренутку путем линка 'Подешавања колачића' у подножју сајта.",
		"DataRetentionTitle": "Периоди чувања података",
		"DataRetentionText": "Подаци налога се чувају док је налог активан. Ако обришете налог, сви лични подаци се уклањају у року од 48 сати. Аналитички подаци се чувају у анонимизованом облику до 24 месеца. Одлука о колачићима се чува 12 месеци.",
		"DataDeletionTitle": "Брисање података",
		"DataDeletionText": "Можете затражити потпуно брисање налога и свих повезаних података:",
		"DeleteStep1": "Пријавите се на налог",
		"DeleteStep2": "Идите на Поставке → Налог",
		"DeleteStep3": "Кликните \"Обриши налог\" и потврдите",
		"DataDeletionAlternative": "Или нам пишите и обрадићемо захтев у року од 48 сати:",
		"YourRightsTitle": "Ваша права",
		"YourRightsText": "Према GDPR-у, имате следећа права у вези са вашим личним подацима:",
		"RightAccess": "Право на приступ — добијте копију ваших личних података",
		"RightRectify": "Право на исправку — исправите нетачне податке",
		"RightErase": "Право на брисање — затражите брисање ваших података",
		"RightRestrict": "Право на ограничење — ограничите начин обраде ваших података",
		"RightPortability": "Право на преносивост — добијте податке у структурираном формату",
		"RightObject": "Право на приговор — приговорите обради заснованој на легитимном интересу",
		"RightWithdraw": "Право на повлачење сагласности — повуците сагласност у било ком тренутку без утицаја на законитост претходне обраде",
		"SupervisoryAuthority": "Такође имате право да поднесете жалбу надзорном органу за заштиту података. Пошто послујемо из Јерменије за кориснике у ЕУ, можете се обратити надзорном органу у вашој земљи пребивалишта.",
		"QuestionsTitle": "Питања?",
		"QuestionsText": "Ако имате питања о приватности или вашим подацима, контактирајте нас:",
		"DataControllerTitle": "Контролор података",
		"DataControllerText": "Контролор података за docta.me је индивидуални предузетник регистрован у Републици Јерменији (регистрациони број: {registrationNumber}). За питања у вези са подацима: contact{'@'}svad.net."
	},
	"de": {
		"PrivacyPageTitle": "Datenschutzerklärung",
		"PrivacyPageDescription": "Erfahren Sie, wie docta.me Ihre Daten sammelt, verwendet und schützt. Ihre Privatsphäre ist uns wichtig.",
		"PrivacyPageSubtitle": "Wir schätzen Ihre Privatsphäre. Diese Seite erklärt, welche Daten wir sammeln und wie wir sie verwenden.",
		"LastUpdated": "Letzte Aktualisierung: 16. April 2026",
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
		"LegalBasisTitle": "Rechtsgrundlage der Verarbeitung",
		"LegalBasisText": "Wir verarbeiten Ihre personenbezogenen Daten auf folgenden Rechtsgrundlagen gemäß DSGVO:",
		"LegalBasisConsent": "Einwilligung (Art. 6(1)(a))",
		"LegalBasisConsentDesc": "für Analyse-Cookies und Marketingkommunikation. Die Einwilligung kann jederzeit widerrufen werden.",
		"LegalBasisContract": "Vertragserfüllung (Art. 6(1)(b))",
		"LegalBasisContractDesc": "für Kontoverwaltung, Authentifizierung und Bereitstellung unserer Kerndienste.",
		"LegalBasisLegitimate": "Berechtigtes Interesse (Art. 6(1)(f))",
		"LegalBasisLegitimateDesc": "für essentielle Cookies, Sicherheitsmaßnahmen und Dienstverbesserung.",
		"ThirdPartyTitle": "Drittanbieter-Dienste",
		"ThirdPartyText": "Wir teilen Daten mit folgenden Dienstleistern, die sie in unserem Auftrag verarbeiten:",
		"ThirdPartyGoogle": "Website-Traffic-Analyse und Werbemessung (USA)",
		"ThirdPartyMixpanel": "Produktanalyse und Nutzerverhaltensanalyse (EU-Datenspeicherung)",
		"ThirdPartyCloudflare": "Sicherheit, CDN und Leistungsanalyse (globales Netzwerk)",
		"InternationalTransfersTitle": "Internationale Datenübermittlung",
		"InternationalTransfersText": "Einige unserer Dienstleister (Google, Cloudflare) haben ihren Sitz in den USA. Datenübermittlungen in die USA sind durch das EU-US Data Privacy Framework abgedeckt. Wir nutzen nur Anbieter, die angemessene Datenschutzgarantien gemäß Art. 46 DSGVO bieten.",
		"CookiesTitle": "Cookies",
		"CookiesText": "Wir verwenden folgende Cookies:",
		"CookieNcc": "speichert Ihre Cookie-Präferenz (1 Jahr, essentiell)",
		"CookieGa": "Google Analytics, Website-Nutzungsstatistiken (bis zu 2 Jahre, Analyse)",
		"CookieMixpanel": "Mixpanel, Produktanalyse (1 Jahr, Analyse)",
		"CookieCloudflare": "Cloudflare, Sicherheit und Leistung (bis zu 30 Minuten, essentiell)",
		"CookiesWithdraw": "Analyse-Cookies werden erst nach Ihrer Einwilligung gesetzt. Sie können Ihre Präferenz jederzeit über den Link 'Cookie-Einstellungen' in der Fußzeile ändern.",
		"DataRetentionTitle": "Datenspeicherung",
		"DataRetentionText": "Kontodaten werden gespeichert, solange Ihr Konto aktiv ist. Bei Kontolöschung werden alle personenbezogenen Daten innerhalb von 48 Stunden entfernt. Analysedaten werden anonymisiert bis zu 24 Monate gespeichert. Cookie-Präferenzen werden 12 Monate gespeichert.",
		"DataDeletionTitle": "Daten löschen",
		"DataDeletionText": "Sie können die vollständige Löschung Ihres Kontos und aller zugehörigen Daten anfordern:",
		"DeleteStep1": "Melden Sie sich bei Ihrem Konto an",
		"DeleteStep2": "Gehen Sie zu Einstellungen → Konto",
		"DeleteStep3": "Klicken Sie auf \"Konto löschen\" und bestätigen Sie",
		"DataDeletionAlternative": "Alternativ können Sie uns eine E-Mail senden und wir bearbeiten Ihre Anfrage innerhalb von 48 Stunden:",
		"YourRightsTitle": "Ihre Rechte",
		"YourRightsText": "Gemäß DSGVO haben Sie folgende Rechte bezüglich Ihrer personenbezogenen Daten:",
		"RightAccess": "Auskunftsrecht — erhalten Sie eine Kopie Ihrer personenbezogenen Daten",
		"RightRectify": "Recht auf Berichtigung — korrigieren Sie unrichtige Daten",
		"RightErase": "Recht auf Löschung — fordern Sie die Löschung Ihrer Daten an",
		"RightRestrict": "Recht auf Einschränkung — beschränken Sie die Verarbeitung Ihrer Daten",
		"RightPortability": "Recht auf Datenübertragbarkeit — erhalten Sie Ihre Daten in einem strukturierten Format",
		"RightObject": "Widerspruchsrecht — widersprechen Sie der Verarbeitung auf Basis berechtigter Interessen",
		"RightWithdraw": "Recht auf Widerruf der Einwilligung — widerrufen Sie Ihre Einwilligung jederzeit, ohne die Rechtmäßigkeit der bisherigen Verarbeitung zu berühren",
		"SupervisoryAuthority": "Sie haben auch das Recht, eine Beschwerde bei einer Datenschutzaufsichtsbehörde einzureichen. Da wir von Armenien aus für Nutzer in der EU tätig sind, können Sie sich an die Aufsichtsbehörde in Ihrem Wohnsitzland wenden.",
		"QuestionsTitle": "Fragen?",
		"QuestionsText": "Wenn Sie Fragen zum Datenschutz oder Ihren Daten haben, kontaktieren Sie uns:",
		"DataControllerTitle": "Datenverantwortlicher",
		"DataControllerText": "Der Datenverantwortliche für docta.me ist ein Einzelunternehmer, registriert in der Republik Armenien (Registrierungsnummer: {registrationNumber}). Bei Fragen zu Ihren Daten: contact{'@'}svad.net."
	},
	"tr": {
		"PrivacyPageTitle": "Gizlilik Politikası",
		"PrivacyPageDescription": "docta.me'nin verilerinizi nasıl topladığını, kullandığını ve koruduğunu öğrenin. Gizliliğiniz bizim için önemli.",
		"PrivacyPageSubtitle": "Gizliliğinize değer veriyoruz. Bu sayfa hangi verileri topladığımızı ve nasıl kullandığımızı açıklar.",
		"LastUpdated": "Son güncelleme: 16 Nisan 2026",
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
		"LegalBasisTitle": "İşlemenin hukuki dayanağı",
		"LegalBasisText": "Kişisel verilerinizi GDPR kapsamında aşağıdaki hukuki dayanaklara göre işliyoruz:",
		"LegalBasisConsent": "Onay (Md. 6(1)(a))",
		"LegalBasisConsentDesc": "analitik çerezler ve pazarlama iletişimleri için. Onayınızı istediğiniz zaman geri çekebilirsiniz.",
		"LegalBasisContract": "Sözleşme ifası (Md. 6(1)(b))",
		"LegalBasisContractDesc": "hesap yönetimi, kimlik doğrulama ve temel hizmetlerimizin sunulması için.",
		"LegalBasisLegitimate": "Meşru menfaat (Md. 6(1)(f))",
		"LegalBasisLegitimateDesc": "gerekli çerezler, güvenlik önlemleri ve hizmet iyileştirmesi için.",
		"ThirdPartyTitle": "Üçüncü taraf hizmetleri",
		"ThirdPartyText": "Verilerinizi bizim adımıza işleyen aşağıdaki hizmet sağlayıcılarla paylaşıyoruz:",
		"ThirdPartyGoogle": "web sitesi trafik analizi ve reklam ölçümü (ABD)",
		"ThirdPartyMixpanel": "ürün analitiği ve kullanıcı davranış analizi (AB veri depolama)",
		"ThirdPartyCloudflare": "güvenlik, CDN ve performans analitiği (küresel ağ)",
		"InternationalTransfersTitle": "Uluslararası veri aktarımları",
		"InternationalTransfersText": "Bazı hizmet sağlayıcılarımız (Google, Cloudflare) ABD merkezlidir. ABD'ye veri aktarımları EU-US Data Privacy Framework kapsamındadır. Yalnızca GDPR Madde 46'ya uygun yeterli veri koruma güvenceleri sunan sağlayıcıları kullanıyoruz.",
		"CookiesTitle": "Çerezler",
		"CookiesText": "Aşağıdaki çerezleri kullanıyoruz:",
		"CookieNcc": "çerez tercihinizi saklar (1 yıl, gerekli)",
		"CookieGa": "Google Analytics, web sitesi kullanım istatistikleri (2 yıla kadar, analitik)",
		"CookieMixpanel": "Mixpanel, ürün analitiği (1 yıl, analitik)",
		"CookieCloudflare": "Cloudflare, güvenlik ve performans (30 dakikaya kadar, gerekli)",
		"CookiesWithdraw": "Analitik çerezler yalnızca onay verdikten sonra ayarlanır. Tercihinizi istediğiniz zaman alt bilgideki \"Çerez ayarları\" bağlantısından değiştirebilirsiniz.",
		"DataRetentionTitle": "Veri saklama",
		"DataRetentionText": "Hesap verileri hesabınız aktif olduğu sürece saklanır. Hesabınızı silerseniz tüm kişisel veriler 48 saat içinde kaldırılır. Analitik veriler anonimleştirilmiş olarak 24 aya kadar saklanır. Çerez tercihleri 12 ay saklanır.",
		"DataDeletionTitle": "Verilerinizi silin",
		"DataDeletionText": "Hesabınızın ve tüm ilişkili verilerin tamamen silinmesini talep edebilirsiniz:",
		"DeleteStep1": "Hesabınıza giriş yapın",
		"DeleteStep2": "Ayarlar → Hesap'a gidin",
		"DeleteStep3": "\"Hesabı Sil\"e tıklayın ve onaylayın",
		"DataDeletionAlternative": "Alternatif olarak bize e-posta gönderin, talebinizi 48 saat içinde işleme alacağız:",
		"YourRightsTitle": "Haklarınız",
		"YourRightsText": "GDPR kapsamında kişisel verilerinizle ilgili aşağıdaki haklara sahipsiniz:",
		"RightAccess": "Erişim hakkı — kişisel verilerinizin bir kopyasını alın",
		"RightRectify": "Düzeltme hakkı — yanlış verileri düzeltin",
		"RightErase": "Silme hakkı — verilerinizin silinmesini talep edin",
		"RightRestrict": "Kısıtlama hakkı — verilerinizin işlenme şeklini sınırlayın",
		"RightPortability": "Veri taşınabilirliği hakkı — verilerinizi yapılandırılmış bir formatta alın",
		"RightObject": "İtiraz hakkı — meşru menfaate dayalı işlemeye itiraz edin",
		"RightWithdraw": "Onayı geri çekme hakkı — önceki işlemenin yasallığını etkilemeden onayınızı istediğiniz zaman geri çekin",
		"SupervisoryAuthority": "Ayrıca bir veri koruma denetim makamına şikayette bulunma hakkınız vardır. Ermenistan'dan AB'deki kullanıcılara hizmet verdiğimiz için, ikamet ettiğiniz ülkedeki denetim makamına başvurabilirsiniz.",
		"QuestionsTitle": "Sorular?",
		"QuestionsText": "Gizlilik veya verileriniz hakkında sorularınız varsa, bizimle iletişime geçin:",
		"DataControllerTitle": "Veri sorumlusu",
		"DataControllerText": "docta.me için veri sorumlusu, Ermenistan Cumhuriyeti'nde kayıtlı bireysel girişimcidir (kayıt numarası: {registrationNumber}). Veri ile ilgili sorularınız için: contact{'@'}svad.net."
	}
}
</i18n>
