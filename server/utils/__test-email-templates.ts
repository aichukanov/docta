// Пример тестирования email шаблонов
// Запустите в Nuxt DevTools Console или создайте тестовый API endpoint

import { Language } from '~/enums/language';
import {
	getPasswordResetEmail,
	getEmailVerificationEmail,
	getLoginNotificationEmail,
	getEmailChangeNotificationEmail,
} from '~/server/utils/email-templates';

// 1. Тест Password Reset для всех языков
console.log('=== Password Reset Templates ===');
[Language.SR, Language.EN, Language.RU, Language.DE, Language.TR].forEach(
	(locale) => {
		const email = getPasswordResetEmail(
			locale,
			'https://docta.me/reset-password?token=test123',
		);
		console.log(`\n${locale}:`);
		console.log('Subject:', email.subject);
		console.log('HTML length:', email.html.length);
	},
);

// 2. Тест Email Verification
console.log('\n\n=== Email Verification Templates ===');
[Language.SR, Language.EN, Language.RU].forEach((locale) => {
	const email = getEmailVerificationEmail(
		locale,
		'https://docta.me/verify-email?token=test123',
		'John Doe',
	);
	console.log(`\n${locale}:`);
	console.log('Subject:', email.subject);
});

// 3. Тест Login Notification
console.log('\n\n=== Login Notification Templates ===');
const loginInfo = {
	ip: '192.168.1.1',
	userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
	location: 'Belgrade, Serbia',
	timestamp: new Date(),
};

[Language.SR, Language.EN, Language.RU].forEach((locale) => {
	const email = getLoginNotificationEmail(locale, 'John Doe', loginInfo);
	console.log(`\n${locale}:`);
	console.log('Subject:', email.subject);
});

// 4. Тест Email Change Notification
console.log('\n\n=== Email Change Notification Templates ===');
[Language.SR, Language.EN, Language.RU].forEach((locale) => {
	const email = getEmailChangeNotificationEmail(
		locale,
		'old@example.com',
		'new@example.com',
		'John Doe',
	);
	console.log(`\n${locale}:`);
	console.log('Subject:', email.subject);
});

console.log('\n✅ All templates tested successfully!');
