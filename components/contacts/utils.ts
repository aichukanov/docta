import type { ContactList } from '~/interfaces/contacts';

// todo: форматировать 0 как +382
export function formatPhoneNumber(phone: string): string {
	// Убираем все символы кроме цифр и +
	const cleaned = getCleanPhoneNumber(phone);

	// Если номер начинается с +382 (Черногория)
	if (cleaned.startsWith('+382')) {
		const number = cleaned.substring(4); // убираем +382
		if (number.length >= 8) {
			return `+382 ${number.substring(0, 2)} ${number.substring(
				2,
				5,
			)} ${number.substring(5)}`;
		}
	}

	// Если номер начинается с +, но не распознан
	if (cleaned.startsWith('+') && cleaned.length >= 10) {
		// Общий формат: +XXX XX XXX XXX
		const countryCode = cleaned.substring(0, 4);
		const number = cleaned.substring(4);
		if (number.length >= 8) {
			return `${countryCode} ${number.substring(0, 2)} ${number.substring(
				2,
				5,
			)} ${number.substring(5)}`;
		}
	}

	// Если номер без + но начинается с 382
	if (cleaned.startsWith('382') && cleaned.length >= 11) {
		const number = cleaned.substring(3);
		return `+382 ${number.substring(0, 2)} ${number.substring(
			2,
			5,
		)} ${number.substring(5)}`;
	}

	// Если ничего не подошло, возвращаем исходный номер
	return phone;
}

export function getCleanPhoneNumber(phone: string): string {
	return phone.replace(/[^\d+]/g, '');
}

// Проверка является ли контакт номером телефона
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
		list.phone ||
		list.email ||
		list.facebook ||
		list.instagram ||
		list.telegram ||
		list.whatsapp ||
		list.viber
	);
}
