/**
 * Email templates with localization support
 */
import type { Language } from '~/enums/language';

export interface EmailTemplate {
	subject: string;
	heading: string;
	greeting: (name: string) => string;
	content: string[];
	buttonText?: string;
	footer: string[];
	copyright: string;
}

// === Password Reset Templates ===

const passwordResetTemplates: Record<Language, EmailTemplate> = {
	[Language.SR]: {
		subject: 'Resetovanje lozinke na docta.me',
		heading: 'Resetovanje lozinke',
		greeting: () => 'Zdravo!',
		content: [
			'Zatražili ste resetovanje lozinke za vaš nalog na docta.me.',
			'Kliknite na dugme ispod da postavite novu lozinku:',
			'Ili kopirajte link u pretraživač:',
			'<strong>Važno:</strong> Link je valjan 1 sat.',
			'Ako niste zatražili resetovanje lozinke, jednostavno ignorišite ovu poruku.',
		],
		buttonText: 'Postavite novu lozinku',
		footer: [],
		copyright: '© 2026 docta.me - Sva prava zadržana',
	},
	[Language.SR_CYRILLIC]: {
		subject: 'Ресетовање лозинке на docta.me',
		heading: 'Ресетовање лозинке',
		greeting: () => 'Здраво!',
		content: [
			'Затражили сте ресетовање лозинке за ваш налог на docta.me.',
			'Кликните на дугме испод да поставите нову лозинку:',
			'Или копирајте линк у претраживач:',
			'<strong>Важно:</strong> Линк је ваљан 1 сат.',
			'Ако нисте затражили ресетовање лозинке, једноставно игноришите ову поруку.',
		],
		buttonText: 'Поставите нову лозинку',
		footer: [],
		copyright: '© 2026 docta.me - Сва права задржана',
	},
	[Language.EN]: {
		subject: 'Password Reset on docta.me',
		heading: 'Password Reset',
		greeting: () => 'Hello!',
		content: [
			'You requested a password reset for your account on docta.me.',
			'Click the button below to set a new password:',
			'Or copy the link to your browser:',
			'<strong>Important:</strong> This link is valid for 1 hour.',
			'If you did not request a password reset, simply ignore this email.',
		],
		buttonText: 'Set New Password',
		footer: [],
		copyright: '© 2026 docta.me - All Rights Reserved',
	},
	[Language.RU]: {
		subject: 'Восстановление пароля на docta.me',
		heading: 'Восстановление пароля',
		greeting: () => 'Здравствуйте!',
		content: [
			'Вы запросили восстановление пароля для вашего аккаунта на docta.me.',
			'Нажмите кнопку ниже, чтобы установить новый пароль:',
			'Или скопируйте ссылку в браузер:',
			'<strong>Важно:</strong> Ссылка действительна в течение 1 часа.',
			'Если вы не запрашивали восстановление пароля, просто проигнорируйте это письмо.',
		],
		buttonText: 'Установить новый пароль',
		footer: [],
		copyright: '© 2026 docta.me - Все права защищены',
	},
	[Language.DE]: {
		subject: 'Passwort zurücksetzen auf docta.me',
		heading: 'Passwort zurücksetzen',
		greeting: () => 'Hallo!',
		content: [
			'Sie haben ein Zurücksetzen des Passworts für Ihr Konto auf docta.me angefordert.',
			'Klicken Sie auf die Schaltfläche unten, um ein neues Passwort festzulegen:',
			'Oder kopieren Sie den Link in Ihren Browser:',
			'<strong>Wichtig:</strong> Dieser Link ist 1 Stunde gültig.',
			'Wenn Sie kein Zurücksetzen des Passworts angefordert haben, ignorieren Sie diese E-Mail einfach.',
		],
		buttonText: 'Neues Passwort festlegen',
		footer: [],
		copyright: '© 2026 docta.me - Alle Rechte vorbehalten',
	},
	[Language.TR]: {
		subject: 'docta.me üzerinde Şifre Sıfırlama',
		heading: 'Şifre Sıfırlama',
		greeting: () => 'Merhaba!',
		content: [
			'docta.me üzerindeki hesabınız için şifre sıfırlama talebinde bulundunuz.',
			'Yeni bir şifre belirlemek için aşağıdaki düğmeye tıklayın:',
			'Veya bağlantıyı tarayıcınıza kopyalayın:',
			'<strong>Önemli:</strong> Bu bağlantı 1 saat geçerlidir.',
			'Şifre sıfırlama talebinde bulunmadıysanız, bu e-postayı görmezden gelin.',
		],
		buttonText: 'Yeni Şifre Belirle',
		footer: [],
		copyright: '© 2026 docta.me - Tüm Hakları Saklıdır',
	},
};

// === Email Verification Templates ===

const emailVerificationTemplates: Record<Language, EmailTemplate> = {
	[Language.SR]: {
		subject: 'Potvrdite email na docta.me',
		heading: 'Dobrodošli u docta.me! 👋',
		greeting: (name) => `Zdravo, ${name}!`,
		content: [
			'Hvala vam što ste se registrovali na docta.me. Da biste završili registraciju, potvrdite svoju email adresu.',
			'',
			'Ili kopirajte link u pretraživač:',
			'Ako se niste registrovali na docta.me, jednostavno ignorišite ovu poruku.',
		],
		buttonText: 'Potvrdite email',
		footer: [],
		copyright: '© 2026 docta.me - Sva prava zadržana',
	},
	[Language.SR_CYRILLIC]: {
		subject: 'Потврдите email на docta.me',
		heading: 'Добродошли у docta.me! 👋',
		greeting: (name) => `Здраво, ${name}!`,
		content: [
			'Хвала вам што сте се регистровали на docta.me. Да бисте завршили регистрацију, потврдите своју email адресу.',
			'',
			'Или копирајте линк у претраживач:',
			'Ако се нисте регистровали на docta.me, једноставно игноришите ову поруку.',
		],
		buttonText: 'Потврдите email',
		footer: [],
		copyright: '© 2026 docta.me - Сва права задржана',
	},
	[Language.EN]: {
		subject: 'Verify your email on docta.me',
		heading: 'Welcome to docta.me! 👋',
		greeting: (name) => `Hello, ${name}!`,
		content: [
			'Thank you for signing up on docta.me. To complete your registration, please verify your email address.',
			'',
			'Or copy the link to your browser:',
			'If you did not sign up on docta.me, simply ignore this email.',
		],
		buttonText: 'Verify Email',
		footer: [],
		copyright: '© 2026 docta.me - All Rights Reserved',
	},
	[Language.RU]: {
		subject: 'Подтвердите email на docta.me',
		heading: 'Добро пожаловать в docta.me! 👋',
		greeting: (name) => `Здравствуйте, ${name}!`,
		content: [
			'Спасибо за регистрацию на docta.me. Для завершения регистрации подтвердите свой email адрес.',
			'',
			'Или скопируйте ссылку в браузер:',
			'Если вы не регистрировались на docta.me, просто проигнорируйте это письмо.',
		],
		buttonText: 'Подтвердить email',
		footer: [],
		copyright: '© 2026 docta.me - Все права защищены',
	},
	[Language.DE]: {
		subject: 'Bestätigen Sie Ihre E-Mail auf docta.me',
		heading: 'Willkommen bei docta.me! 👋',
		greeting: (name) => `Hallo, ${name}!`,
		content: [
			'Vielen Dank für Ihre Anmeldung auf docta.me. Um Ihre Registrierung abzuschließen, bestätigen Sie bitte Ihre E-Mail-Adresse.',
			'',
			'Oder kopieren Sie den Link in Ihren Browser:',
			'Wenn Sie sich nicht auf docta.me angemeldet haben, ignorieren Sie diese E-Mail einfach.',
		],
		buttonText: 'E-Mail bestätigen',
		footer: [],
		copyright: '© 2026 docta.me - Alle Rechte vorbehalten',
	},
	[Language.TR]: {
		subject: 'docta.me üzerinde e-postanızı doğrulayın',
		heading: "docta.me'ye Hoş Geldiniz! 👋",
		greeting: (name) => `Merhaba, ${name}!`,
		content: [
			"docta.me'ye kaydolduğunuz için teşekkür ederiz. Kaydınızı tamamlamak için lütfen e-posta adresinizi doğrulayın.",
			'',
			'Veya bağlantıyı tarayıcınıza kopyalayın:',
			"docta.me'ye kaydolmadıysanız, bu e-postayı görmezden gelin.",
		],
		buttonText: "E-postayı Doğrula",
		footer: [],
		copyright: '© 2026 docta.me - Tüm Hakları Saklıdır',
	},
};

// === Login Notification Templates ===

interface LoginInfo {
	ip: string;
	userAgent: string;
	location?: string;
	timestamp: Date;
}

interface LoginNotificationTemplate {
	subject: string;
	heading: string;
	greeting: (name: string) => string;
	intro: string;
	infoLabels: {
		time: string;
		ip: string;
		device: string;
		location: string;
	};
	wasYou: string;
	wasNotYou: string;
	buttonText: string;
	copyright: string;
}

const loginNotificationTemplates: Record<Language, LoginNotificationTemplate> = {
	[Language.SR]: {
		subject: '🔔 Nova prijava na nalog docta.me',
		heading: '🔔 Nova prijava na nalog',
		greeting: (name) => `Zdravo, ${name}!`,
		intro: 'Detektovali smo novu prijavu na vaš nalog na docta.me.',
		infoLabels: {
			time: 'Vreme:',
			ip: 'IP adresa:',
			device: 'Uređaj:',
			location: 'Lokacija:',
		},
		wasYou: 'Ako ste to bili vi, možete ignorisati ovu poruku.',
		wasNotYou:
			'<strong>Ako niste bili vi,</strong> preporučujemo da odmah promenite lozinku i završite sve aktivne sesije.',
		buttonText: 'Promenite lozinku',
		copyright: '© 2026 docta.me - Sva prava zadržana',
	},
	[Language.SR_CYRILLIC]: {
		subject: '🔔 Нова пријава на налог docta.me',
		heading: '🔔 Нова пријава на налог',
		greeting: (name) => `Здраво, ${name}!`,
		intro: 'Детектовали смо нову пријаву на ваш налог на docta.me.',
		infoLabels: {
			time: 'Време:',
			ip: 'IP адреса:',
			device: 'Уређај:',
			location: 'Локација:',
		},
		wasYou: 'Ако сте то били ви, можете игнорисати ову поруку.',
		wasNotYou:
			'<strong>Ако нисте били ви,</strong> препоручујемо да одмах промените лозинку и завршите све активне сесије.',
		buttonText: 'Промените лозинку',
		copyright: '© 2026 docta.me - Сва права задржана',
	},
	[Language.EN]: {
		subject: '🔔 New login to docta.me account',
		heading: '🔔 New Account Login',
		greeting: (name) => `Hello, ${name}!`,
		intro: 'We detected a new login to your account on docta.me.',
		infoLabels: {
			time: 'Time:',
			ip: 'IP Address:',
			device: 'Device:',
			location: 'Location:',
		},
		wasYou: 'If this was you, you can ignore this email.',
		wasNotYou:
			'<strong>If this was not you,</strong> we recommend immediately changing your password and terminating all active sessions.',
		buttonText: 'Change Password',
		copyright: '© 2026 docta.me - All Rights Reserved',
	},
	[Language.RU]: {
		subject: '🔔 Новый вход в аккаунт docta.me',
		heading: '🔔 Новый вход в аккаунт',
		greeting: (name) => `Здравствуйте, ${name}!`,
		intro: 'Мы обнаружили новый вход в ваш аккаунт на docta.me.',
		infoLabels: {
			time: 'Время:',
			ip: 'IP адрес:',
			device: 'Устройство:',
			location: 'Местоположение:',
		},
		wasYou: 'Если это были вы, можете проигнорировать это письмо.',
		wasNotYou:
			'<strong>Если это были не вы,</strong> рекомендуем немедленно изменить пароль и завершить все активные сессии.',
		buttonText: 'Изменить пароль',
		copyright: '© 2026 docta.me - Все права защищены',
	},
	[Language.DE]: {
		subject: '🔔 Neue Anmeldung bei docta.me-Konto',
		heading: '🔔 Neue Kontoanmeldung',
		greeting: (name) => `Hallo, ${name}!`,
		intro: 'Wir haben eine neue Anmeldung bei Ihrem Konto auf docta.me festgestellt.',
		infoLabels: {
			time: 'Zeit:',
			ip: 'IP-Adresse:',
			device: 'Gerät:',
			location: 'Standort:',
		},
		wasYou: 'Wenn Sie das waren, können Sie diese E-Mail ignorieren.',
		wasNotYou:
			'<strong>Wenn Sie das nicht waren,</strong> empfehlen wir, sofort Ihr Passwort zu ändern und alle aktiven Sitzungen zu beenden.',
		buttonText: 'Passwort ändern',
		copyright: '© 2026 docta.me - Alle Rechte vorbehalten',
	},
	[Language.TR]: {
		subject: '🔔 docta.me hesabına yeni giriş',
		heading: '🔔 Yeni Hesap Girişi',
		greeting: (name) => `Merhaba, ${name}!`,
		intro: 'docta.me üzerindeki hesabınıza yeni bir giriş tespit ettik.',
		infoLabels: {
			time: 'Zaman:',
			ip: 'IP Adresi:',
			device: 'Cihaz:',
			location: 'Konum:',
		},
		wasYou: 'Bu sizseniz, bu e-postayı görmezden gelebilirsiniz.',
		wasNotYou:
			'<strong>Bu siz değilseniz,</strong> hemen şifrenizi değiştirmenizi ve tüm aktif oturumları sonlandırmanızı öneririz.',
		buttonText: 'Şifreyi Değiştir',
		copyright: '© 2026 docta.me - Tüm Hakları Saklıdır',
	},
};

// === Email Change Notification Templates ===

interface EmailChangeNotificationTemplate {
	subject: string;
	heading: string;
	greeting: (name: string) => string;
	intro: string;
	oldEmailLabel: string;
	newEmailLabel: string;
	warning: string;
	copyright: string;
}

const emailChangeNotificationTemplates: Record<
	Language,
	EmailChangeNotificationTemplate
> = {
	[Language.SR]: {
		subject: 'Email adresa promenjena na docta.me',
		heading: 'Email adresa promenjena',
		greeting: (name) => `Zdravo, ${name}!`,
		intro: 'Vaša email adresa na docta.me je promenjena:',
		oldEmailLabel: 'Stari email:',
		newEmailLabel: 'Novi email:',
		warning: 'Ako niste menjali email, odmah kontaktirajte podršku.',
		copyright: '© 2026 docta.me - Sva prava zadržana',
	},
	[Language.SR_CYRILLIC]: {
		subject: 'Email адреса промењена на docta.me',
		heading: 'Email адреса промењена',
		greeting: (name) => `Здраво, ${name}!`,
		intro: 'Ваша email адреса на docta.me је промењена:',
		oldEmailLabel: 'Стари email:',
		newEmailLabel: 'Нови email:',
		warning: 'Ако нисте мењали email, одмах контактирајте подршку.',
		copyright: '© 2026 docta.me - Сва права задржана',
	},
	[Language.EN]: {
		subject: 'Email address changed on docta.me',
		heading: 'Email Address Changed',
		greeting: (name) => `Hello, ${name}!`,
		intro: 'Your email address on docta.me has been changed:',
		oldEmailLabel: 'Old email:',
		newEmailLabel: 'New email:',
		warning: 'If you did not change your email, contact support immediately.',
		copyright: '© 2026 docta.me - All Rights Reserved',
	},
	[Language.RU]: {
		subject: 'Email адрес изменен на docta.me',
		heading: 'Email адрес изменен',
		greeting: (name) => `Здравствуйте, ${name}!`,
		intro: 'Ваш email адрес на docta.me был изменен:',
		oldEmailLabel: 'Старый email:',
		newEmailLabel: 'Новый email:',
		warning: 'Если вы не меняли email, немедленно свяжитесь с поддержкой.',
		copyright: '© 2026 docta.me - Все права защищены',
	},
	[Language.DE]: {
		subject: 'E-Mail-Adresse auf docta.me geändert',
		heading: 'E-Mail-Adresse geändert',
		greeting: (name) => `Hallo, ${name}!`,
		intro: 'Ihre E-Mail-Adresse auf docta.me wurde geändert:',
		oldEmailLabel: 'Alte E-Mail:',
		newEmailLabel: 'Neue E-Mail:',
		warning:
			'Wenn Sie Ihre E-Mail-Adresse nicht geändert haben, kontaktieren Sie sofort den Support.',
		copyright: '© 2026 docta.me - Alle Rechte vorbehalten',
	},
	[Language.TR]: {
		subject: "docta.me'de e-posta adresi değiştirildi",
		heading: 'E-posta Adresi Değiştirildi',
		greeting: (name) => `Merhaba, ${name}!`,
		intro: "docta.me'deki e-posta adresiniz değiştirildi:",
		oldEmailLabel: 'Eski e-posta:',
		newEmailLabel: 'Yeni e-posta:',
		warning:
			'E-posta adresinizi değiştirmediyseniz, hemen desteğe başvurun.',
		copyright: '© 2026 docta.me - Tüm Hakları Saklıdır',
	},
};

// === Base HTML Template ===

function generateEmailHTML(
	heading: string,
	contentHtml: string,
	copyright: string,
): string {
	return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }
    .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }
    .button { display: inline-block; background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
    .button-danger { background: #dc3545; }
    .info-box { background: white; padding: 15px; border-radius: 6px; margin: 15px 0; }
    .info-row { margin: 8px 0; }
    .label { font-weight: bold; color: #667eea; }
    .footer { text-align: center; color: #999; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>${heading}</h1>
    </div>
    <div class="content">
      ${contentHtml}
    </div>
    <div class="footer">
      <p>${copyright}</p>
    </div>
  </div>
</body>
</html>
  `;
}

// === Public API ===

export function getPasswordResetEmail(
	locale: Language,
	resetUrl: string,
): { subject: string; html: string; text: string } {
	const template =
		passwordResetTemplates[locale] || passwordResetTemplates[Language.EN];

	const contentHtml = `
    <p>${template.greeting('')}</p>
    <p>${template.content[0]}</p>
    <p>${template.content[1]}</p>
    <p style="text-align: center;">
      <a href="${resetUrl}" class="button">${template.buttonText}</a>
    </p>
    <p>${template.content[2]}</p>
    <p style="word-break: break-all; color: #667eea;">${resetUrl}</p>
    <p>${template.content[3]}</p>
    <p>${template.content[4]}</p>
  `;

	const html = generateEmailHTML(
		template.heading,
		contentHtml,
		template.copyright,
	);

	const text = `${template.heading}\n\n${template.greeting('')}\n\n${template.content[0]}\n\n${resetUrl}\n\n${template.content[3]}`;

	return {
		subject: template.subject,
		html,
		text,
	};
}

export function getEmailVerificationEmail(
	locale: Language,
	verificationUrl: string,
	userName: string,
): { subject: string; html: string; text: string } {
	const template =
		emailVerificationTemplates[locale] ||
		emailVerificationTemplates[Language.EN];

	const contentHtml = `
    <p>${template.greeting(userName)}</p>
    ${template.content
			.map((line, idx) => {
				if (idx === 2) {
					// Line with URL
					return `<p>${line}</p>
      <p style="word-break: break-all; color: #667eea;">${verificationUrl}</p>`;
				}
				if (idx === 1) {
					// Button placement
					return `<p style="text-align: center;">
        <a href="${verificationUrl}" class="button">${template.buttonText}</a>
      </p>`;
				}
				if (line === '') return '';
				return `<p>${line}</p>`;
			})
			.join('\n')}
  `;

	const html = generateEmailHTML(
		template.heading,
		contentHtml,
		template.copyright,
	);

	const text = `${template.heading}\n\n${template.greeting(userName)}\n\n${template.content[0]}\n\n${verificationUrl}`;

	return {
		subject: template.subject,
		html,
		text,
	};
}

export function getLoginNotificationEmail(
	locale: Language,
	userName: string,
	loginInfo: LoginInfo,
): { subject: string; html: string; text: string } {
	const template =
		loginNotificationTemplates[locale] ||
		loginNotificationTemplates[Language.EN];

	const contentHtml = `
    <p>${template.greeting(userName)}</p>
    <p>${template.intro}</p>
    <div class="info-box">
      <div class="info-row"><span class="label">${template.infoLabels.time}</span> ${loginInfo.timestamp.toLocaleString(locale === Language.RU ? 'ru-RU' : locale === Language.EN ? 'en-US' : locale === Language.DE ? 'de-DE' : locale === Language.TR ? 'tr-TR' : 'sr-RS')}</div>
      <div class="info-row"><span class="label">${template.infoLabels.ip}</span> ${loginInfo.ip}</div>
      <div class="info-row"><span class="label">${template.infoLabels.device}</span> ${loginInfo.userAgent}</div>
      ${loginInfo.location ? `<div class="info-row"><span class="label">${template.infoLabels.location}</span> ${loginInfo.location}</div>` : ''}
    </div>
    <p>${template.wasYou}</p>
    <p>${template.wasNotYou}</p>
    <p style="text-align: center;">
      <a href="https://docta.me/profile" class="button button-danger">${template.buttonText}</a>
    </p>
  `;

	const html = generateEmailHTML(
		template.heading,
		contentHtml,
		template.copyright,
	);

	const text = `${template.heading}\n\n${template.greeting(userName)}\n\n${template.intro}\n\n${template.infoLabels.time} ${loginInfo.timestamp.toLocaleString()}\n${template.infoLabels.ip} ${loginInfo.ip}\n${template.infoLabels.device} ${loginInfo.userAgent}\n\n${template.wasYou}\n\n${template.wasNotYou}\n\nhttps://docta.me/profile`;

	return {
		subject: template.subject,
		html,
		text,
	};
}

export function getEmailChangeNotificationEmail(
	locale: Language,
	oldEmail: string,
	newEmail: string,
	userName: string,
): { subject: string; html: string; text: string } {
	const template =
		emailChangeNotificationTemplates[locale] ||
		emailChangeNotificationTemplates[Language.EN];

	const contentHtml = `
    <p>${template.greeting(userName)}</p>
    <p>${template.intro}</p>
    <p><strong>${template.oldEmailLabel}</strong> ${oldEmail}</p>
    <p><strong>${template.newEmailLabel}</strong> ${newEmail}</p>
    <p>${template.warning}</p>
  `;

	const html = generateEmailHTML(
		template.heading,
		contentHtml,
		template.copyright,
	);

	const text = `${template.heading}\n\n${template.greeting(userName)}\n\n${template.intro}\n\n${template.oldEmailLabel} ${oldEmail}\n${template.newEmailLabel} ${newEmail}\n\n${template.warning}`;

	return {
		subject: template.subject,
		html,
		text,
	};
}
