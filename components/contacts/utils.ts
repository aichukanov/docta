import type { ContactList } from '~/interfaces/contacts';

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

export function isPhoneNumber(contact: string): boolean {
	return /^\+?[\d\s\-\(\)]+$/.test(contact);
}

// Функция для разделения контактов по "; " и очистки от пустых значений
export function splitContacts(value?: string): string[] {
	if (!value) return [];
	return value
		.split(';')
		.map((item) => item.trim())
		.filter((item) => item.length > 0);
}

export function hasContacts(list: ContactList): boolean {
	return !!(
		list.website ||
		list.phone ||
		list.email ||
		list.facebook ||
		list.instagram ||
		list.telegram ||
		list.whatsapp ||
		list.viber
	);
}
