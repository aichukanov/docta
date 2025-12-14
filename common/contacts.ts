import type { ContactList } from '~/interfaces/contacts';

const ABSOLUTE_URL_RE = /^(https?:)?\/\//i;
const SPECIAL_SCHEMES_RE = /^(mailto|tel):/i;

export function splitContacts(value?: string): string[] {
	if (!value) return [];
	return value
		.split(';')
		.map((item) => item.trim())
		.filter((item) => item.length > 0);
}

export function isPhoneNumber(contact: string): boolean {
	return /^\+?[\d\s\-\(\)]+$/.test(contact);
}

// todo: форматировать 0 как +382
export function formatPhoneNumber(phone: string): string {
	if (phone.startsWith('+382')) {
		const number = phone.substring(4); // убираем +382
		return `+382 ${number.substring(0, 2)} ${number.substring(
			2,
			5,
		)} ${number.substring(5)}`;
	}

	return phone;
}

export function isAbsoluteUrl(value: string): boolean {
	return ABSOLUTE_URL_RE.test(value) || SPECIAL_SCHEMES_RE.test(value);
}

export function normalizeWebsiteUrl(value?: string): string | undefined {
	if (!value) return undefined;
	const trimmed = value.trim();
	if (!trimmed) return undefined;
	if (isAbsoluteUrl(trimmed)) return trimmed;
	return `https://${trimmed}`;
}

export function normalizeFacebookUrl(value: string): string {
	const trimmed = value.trim();
	if (isAbsoluteUrl(trimmed)) return trimmed;
	return `https://${trimmed}`;
}

export function normalizeInstagramUrl(value: string): string {
	const trimmed = value.trim();
	if (isAbsoluteUrl(trimmed)) return trimmed;
	if (trimmed.toLowerCase().includes('instagram.com'))
		return `https://${trimmed}`;

	const handle = trimmed.replace('@', '').trim();
	return `https://instagram.com/${handle}`;
}

export function normalizeTelegramUrl(value: string): string {
	const trimmed = value.trim();
	if (isAbsoluteUrl(trimmed)) return trimmed;
	if (trimmed.toLowerCase().includes('t.me/')) return `https://${trimmed}`;

	const handle = trimmed.replace('@', '').trim();
	return `https://t.me/${handle}`;
}
