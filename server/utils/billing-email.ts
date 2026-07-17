/**
 * Email-подтверждение покупки платных услуг клиники.
 * Использует ту же Mailgun-инфраструктуру, что и auth-письма (sendEmail).
 */
import { Language } from '~/enums/language';
import { BillingService } from '~/enums/billing-service';
import { sendEmail } from './email';
import { generateEmailHTML } from './email-templates';
import { formatEurCents } from '~/interfaces/billing';

export interface PurchasedServiceLine {
	serviceId: number;
	months: number;
	priceCents: number;
	validUntil: Date;
}

interface PurchaseTemplate {
	subject: string;
	heading: string;
	greeting: string;
	intro: (clinicName: string) => string;
	serviceLabel: string;
	periodLabel: string;
	validUntilLabel: string;
	totalLabel: string;
	outro: string;
	copyright: string;
	monthsShort: string;
	serviceNames: Record<number, string>;
}

type EmailLocale =
	| Language.EN
	| Language.RU
	| Language.SR
	| Language.SR_CYRILLIC
	| Language.DE
	| Language.TR;

const templates: Record<EmailLocale, PurchaseTemplate> = {
	[Language.EN]: {
		subject: 'Payment confirmed — services activated on docta.me',
		heading: 'Payment confirmed',
		greeting: 'Hello!',
		intro: (clinicName) =>
			`Your payment was successful. The following services are now active for the clinic <strong>${clinicName}</strong>:`,
		serviceLabel: 'Service',
		periodLabel: 'Period',
		validUntilLabel: 'Valid until',
		totalLabel: 'Total paid',
		outro: 'You can view your purchases in the clinic cabinet on docta.me.',
		copyright: '© 2026 docta.me - All Rights Reserved',
		monthsShort: 'mo',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow links',
			[BillingService.HIGHLIGHT]: 'Highlight in listings',
			[BillingService.APPROVED]: 'Verified clinic badge',
		},
	},
	[Language.RU]: {
		subject: 'Оплата подтверждена — услуги активированы на docta.me',
		heading: 'Оплата подтверждена',
		greeting: 'Здравствуйте!',
		intro: (clinicName) =>
			`Ваш платёж прошёл успешно. Для клиники <strong>${clinicName}</strong> активированы услуги:`,
		serviceLabel: 'Услуга',
		periodLabel: 'Период',
		validUntilLabel: 'Действует до',
		totalLabel: 'Итого оплачено',
		outro: 'Покупки можно посмотреть в кабинете клиники на docta.me.',
		copyright: '© 2026 docta.me - Все права защищены',
		monthsShort: 'мес.',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow-ссылки',
			[BillingService.HIGHLIGHT]: 'Выделение в списках',
			[BillingService.APPROVED]: 'Бейдж верифицированной клиники',
		},
	},
	[Language.SR]: {
		subject: 'Plaćanje potvrđeno — usluge aktivirane na docta.me',
		heading: 'Plaćanje potvrđeno',
		greeting: 'Zdravo!',
		intro: (clinicName) =>
			`Vaše plaćanje je uspješno. Za kliniku <strong>${clinicName}</strong> aktivirane su usluge:`,
		serviceLabel: 'Usluga',
		periodLabel: 'Period',
		validUntilLabel: 'Važi do',
		totalLabel: 'Ukupno plaćeno',
		outro: 'Kupovine možete pogledati u kabinetu klinike na docta.me.',
		copyright: '© 2026 docta.me - Sva prava zadržana',
		monthsShort: 'mj.',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow linkovi',
			[BillingService.HIGHLIGHT]: 'Isticanje u listama',
			[BillingService.APPROVED]: 'Bedž verifikovane klinike',
		},
	},
	[Language.SR_CYRILLIC]: {
		subject: 'Плаћање потврђено — услуге активиране на docta.me',
		heading: 'Плаћање потврђено',
		greeting: 'Здраво!',
		intro: (clinicName) =>
			`Ваше плаћање је успјешно. За клинику <strong>${clinicName}</strong> активиране су услуге:`,
		serviceLabel: 'Услуга',
		periodLabel: 'Период',
		validUntilLabel: 'Важи до',
		totalLabel: 'Укупно плаћено',
		outro: 'Куповине можете погледати у кабинету клинике на docta.me.',
		copyright: '© 2026 docta.me - Сва права задржана',
		monthsShort: 'мј.',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow линкови',
			[BillingService.HIGHLIGHT]: 'Истицање у листама',
			[BillingService.APPROVED]: 'Беџ верификоване клинике',
		},
	},
	[Language.DE]: {
		subject: 'Zahlung bestätigt — Leistungen auf docta.me aktiviert',
		heading: 'Zahlung bestätigt',
		greeting: 'Hallo!',
		intro: (clinicName) =>
			`Ihre Zahlung war erfolgreich. Für die Klinik <strong>${clinicName}</strong> wurden folgende Leistungen aktiviert:`,
		serviceLabel: 'Leistung',
		periodLabel: 'Zeitraum',
		validUntilLabel: 'Gültig bis',
		totalLabel: 'Gesamtbetrag',
		outro: 'Ihre Käufe finden Sie im Klinik-Bereich auf docta.me.',
		copyright: '© 2026 docta.me - Alle Rechte vorbehalten',
		monthsShort: 'Mon.',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow-Links',
			[BillingService.HIGHLIGHT]: 'Hervorhebung in Listen',
			[BillingService.APPROVED]: 'Verifizierte-Klinik-Abzeichen',
		},
	},
	[Language.TR]: {
		subject: "Ödeme onaylandı — docta.me'de hizmetler etkinleştirildi",
		heading: 'Ödeme onaylandı',
		greeting: 'Merhaba!',
		intro: (clinicName) =>
			`Ödemeniz başarıyla tamamlandı. <strong>${clinicName}</strong> kliniği için şu hizmetler etkinleştirildi:`,
		serviceLabel: 'Hizmet',
		periodLabel: 'Süre',
		validUntilLabel: 'Geçerlilik',
		totalLabel: 'Ödenen toplam',
		outro: "Satın alımlarınızı docta.me'deki klinik panelinde görebilirsiniz.",
		copyright: '© 2026 docta.me - Tüm Hakları Saklıdır',
		monthsShort: 'ay',
		serviceNames: {
			[BillingService.DOFOLLOW]: 'Dofollow bağlantılar',
			[BillingService.HIGHLIGHT]: 'Listelerde öne çıkarma',
			[BillingService.APPROVED]: 'Doğrulanmış klinik rozeti',
		},
	},
};

function formatDate(date: Date): string {
	return date.toISOString().slice(0, 10);
}

export async function sendPurchaseConfirmationEmail(params: {
	to: string;
	locale: string | null;
	clinicName: string;
	lines: PurchasedServiceLine[];
	totalCents: number;
}): Promise<boolean> {
	const template =
		templates[params.locale as EmailLocale] || templates[Language.EN];

	const rowsHtml = params.lines
		.map(
			(line) => `
		<div class="info-row">
			<span class="label">${template.serviceNames[line.serviceId] || `#${line.serviceId}`}</span>
			— ${line.months} ${template.monthsShort},
			${formatEurCents(line.priceCents)},
			${template.validUntilLabel.toLowerCase()}: ${formatDate(line.validUntil)}
		</div>`,
		)
		.join('\n');

	const contentHtml = `
		<p>${template.greeting}</p>
		<p>${template.intro(params.clinicName)}</p>
		<div class="info-box" style="background: white; padding: 15px; border-radius: 6px; margin: 15px 0;">
			${rowsHtml}
			<div class="info-row" style="margin-top: 12px;">
				<strong>${template.totalLabel}: ${formatEurCents(params.totalCents)}</strong>
			</div>
		</div>
		<p>${template.outro}</p>
	`;

	const html = generateEmailHTML(
		template.heading,
		contentHtml,
		template.copyright,
	);

	const textLines = params.lines
		.map(
			(line) =>
				`- ${template.serviceNames[line.serviceId] || `#${line.serviceId}`}: ${line.months} ${template.monthsShort}, ${formatEurCents(line.priceCents)}, ${template.validUntilLabel}: ${formatDate(line.validUntil)}`,
		)
		.join('\n');
	const text = `${template.heading}\n\n${template.greeting}\n\n${params.clinicName}\n${textLines}\n\n${template.totalLabel}: ${formatEurCents(params.totalCents)}`;

	return await sendEmail({
		to: params.to,
		subject: template.subject,
		html,
		text,
	});
}
