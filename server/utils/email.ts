/**
 * Email утилита с интеграцией Mailgun
 */
import Mailgun from 'mailgun.js';
import formData from 'form-data';
import { emailLogger, logError } from './logger';
import { executeQuery } from '../common/db-mysql';
import {
	getPasswordResetEmail,
	getEmailVerificationEmail,
	getLoginNotificationEmail,
	getEmailChangeNotificationEmail,
} from './email-templates';
import { Language } from '~/enums/language';

interface EmailOptions {
	to: string;
	subject: string;
	html: string;
	text?: string;
}

type EmailLogStatus = 'sent' | 'failed' | 'dev';

async function logEmail(
	options: EmailOptions,
	status: EmailLogStatus,
	error?: string,
): Promise<void> {
	try {
		await executeQuery(
			`INSERT INTO auth_email_log (to_email, subject, html, text_body, status, error)
			 VALUES (?, ?, ?, ?, ?, ?)`,
			[options.to, options.subject, options.html, options.text ?? null, status, error ?? null],
		);
	} catch (err) {
		logError(emailLogger, 'Failed to save email log to DB', err);
	}
}

/**
 * Отправка email через Mailgun
 */
export async function sendEmail(options: EmailOptions): Promise<boolean> {
	const isDev = process.env.NODE_ENV === 'development';

	// В development без настроенного Mailgun - выводим в консоль и сохраняем в БД
	if (isDev) {
		emailLogger.info('Email mock (dev mode)', {
			to: options.to,
			subject: options.subject,
		});
		emailLogger.debug('Email HTML content', { html: options.html });
		await logEmail(options, 'dev');
		return true;
	}

	if (!process.env.MAILGUN_API_KEY || !process.env.MAILGUN_API_URL) {
		emailLogger.warn(
			'Mailgun not configured. Set MAILGUN_API_KEY and MAILGUN_API_URL environment variables.',
		);
		return false;
	}

	const client = new Mailgun(formData).client({
		username: 'api',
		key: process.env.MAILGUN_API_KEY,
		url: process.env.MAILGUN_API_URL,
	});

	const domain = process.env.MAILGUN_DOMAIN;
	const fromEmail = process.env.MAILGUN_FROM_EMAIL;
	const fromName = process.env.MAILGUN_FROM_NAME;

	if (!fromEmail || !fromName || !domain) {
		emailLogger.warn(
			'Mailgun not configured. Set MAILGUN_FROM_EMAIL, MAILGUN_FROM_NAME and MAILGUN_DOMAIN environment variables.',
		);
		return false;
	}

	try {
		await client.messages.create(domain, {
			from: `${fromName} <${fromEmail}>`,
			to: [options.to],
			subject: options.subject,
			html: options.html,
			text: options.text,
		});

		emailLogger.info('Email sent successfully', { to: options.to });
		await logEmail(options, 'sent');
		return true;
	} catch (error) {
		logError(emailLogger, 'Failed to send email via Mailgun', error, {
			to: options.to,
		});
		const errorMessage = error instanceof Error ? error.message : String(error);
		await logEmail(options, 'failed', errorMessage);
		return false;
	}
}

/**
 * Email для восстановления пароля
 */
export async function sendPasswordResetEmail(
	email: string,
	resetUrl: string,
	locale: Language = Language.EN,
): Promise<boolean> {
	const { subject, html, text } = getPasswordResetEmail(locale, resetUrl);

	return await sendEmail({
		to: email,
		subject,
		html,
		text,
	});
}

/**
 * Email для подтверждения регистрации
 */
export async function sendEmailVerification(
	email: string,
	verificationUrl: string,
	userName: string,
	locale: Language = Language.EN,
): Promise<boolean> {
	const { subject, html, text } = getEmailVerificationEmail(
		locale,
		verificationUrl,
		userName,
	);

	return await sendEmail({
		to: email,
		subject,
		html,
		text,
	});
}

/**
 * Email уведомление о новом входе
 */
export async function sendLoginNotification(
	email: string,
	userName: string,
	loginInfo: {
		ip: string;
		userAgent: string;
		location?: string;
		timestamp: Date;
	},
	locale: Language = Language.EN,
): Promise<boolean> {
	const { subject, html, text } = getLoginNotificationEmail(
		locale,
		userName,
		loginInfo,
	);

	return await sendEmail({
		to: email,
		subject,
		html,
		text,
	});
}

/**
 * Email уведомление об изменении email
 */
export async function sendEmailChangeNotification(
	oldEmail: string,
	newEmail: string,
	userName: string,
	locale: Language = Language.EN,
): Promise<boolean> {
	const { subject, html, text } = getEmailChangeNotificationEmail(
		locale,
		oldEmail,
		newEmail,
		userName,
	);

	return await sendEmail({
		to: oldEmail,
		subject,
		html,
		text,
	});
}