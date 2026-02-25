/**
 * Test endpoint для просмотра email шаблонов
 * Доступен только в development режиме
 * 
 * Usage:
 * GET /api/test/email-preview?type=password-reset&locale=ru
 * GET /api/test/email-preview?type=email-verification&locale=en
 * GET /api/test/email-preview?type=login-notification&locale=de
 * GET /api/test/email-preview?type=email-change&locale=tr
 */

import { Language } from '~/enums/language';
import {
	getPasswordResetEmail,
	getEmailVerificationEmail,
	getLoginNotificationEmail,
	getEmailChangeNotificationEmail,
} from '~/server/utils/email-templates';

export default defineEventHandler(async (event) => {
	if (!import.meta.dev) {
		throw createError({
			statusCode: 404,
			statusMessage: 'Not Found',
		});
	}

	const query = getQuery(event);
	const type = (query.type as string) || 'password-reset';
	const locale = (query.locale as Language) || Language.EN;

	let emailData: { subject: string; html: string; text: string };

	switch (type) {
		case 'password-reset':
			emailData = getPasswordResetEmail(
				locale,
				'https://docta.me/reset-password?token=test-token-123',
			);
			break;

		case 'email-verification':
			emailData = getEmailVerificationEmail(
				locale,
				'https://docta.me/verify-email?token=test-token-123',
				'Test User',
			);
			break;

		case 'login-notification':
			emailData = getLoginNotificationEmail(locale, 'Test User', {
				ip: '192.168.1.1',
				userAgent:
					'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
				location: 'Belgrade, Serbia',
				timestamp: new Date(),
			});
			break;

		case 'email-change':
			emailData = getEmailChangeNotificationEmail(
				locale,
				'old@example.com',
				'new@example.com',
				'Test User',
			);
			break;

		default:
			throw createError({
				statusCode: 400,
				statusMessage: 'Invalid type. Use: password-reset, email-verification, login-notification, email-change',
			});
	}

	// Возвращаем HTML для отображения в браузере
	setHeader(event, 'Content-Type', 'text/html; charset=utf-8');
	return emailData.html;
});
