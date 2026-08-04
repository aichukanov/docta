import { isAbsoluteUrl, isPhoneNumber } from '~/common/contacts';
import type { ContactList } from '~/interfaces/contacts';

/**
 * Ввод и нормализация контактов клиники.
 *
 * Одно поле в БД хранит несколько значений через `;` (см. splitContacts), и до
 * появления этого модуля пользователь кабинета вводил их вручную одной
 * строкой. Любой другой разделитель — запятая, слэш, перевод строки — ломал
 * разбор: номера склеивались в один мусорный контакт.
 *
 * Отдельная причина строгости к телефонам: контакты группируются по ТОЧНОМУ
 * совпадению строки (components/contacts/list.vue), поэтому «+382 68 111 222»
 * в поле телефона и «+38268111222» в WhatsApp дают две несвязанные строки
 * вместо одной с иконками каналов. Канон в БД — `+382XXXXXXXX` без пробелов
 * (docs/import/GOOGLE_PLACES_IMPORT.md).
 */

/** Разделитель значений внутри одного поля контактов в БД. */
export const CONTACT_SEPARATOR = ';';

export type ContactKind = 'phone' | 'email' | 'url' | 'telegram';

/** Поля контактов; `features` в ContactList — не контакт, а платные услуги. */
export type ContactFieldName = Exclude<keyof ContactList, 'features'>;

/**
 * Тип значения для каждого поля контактов.
 *
 * whatsapp и viber — именно 'phone', а не свободная строка: не-номер в этих
 * полях страница клиники не рисует вовсе (list.vue фильтрует их через
 * isPhoneNumber), то есть значение молча исчезает с сайта.
 */
export const CONTACT_FIELD_KINDS: Record<ContactFieldName, ContactKind> = {
	phone: 'phone',
	whatsapp: 'phone',
	viber: 'phone',
	telegram: 'telegram',
	email: 'email',
	website: 'url',
	facebook: 'url',
	instagram: 'url',
};

/** Столько цифр в черногорском номере без кода страны: 68 111 222. */
const MNE_LOCAL_DIGITS = 8;
const MNE_COUNTRY_CODE = '382';

// В телефоне сохраняем то, из чего номер может состоять; всё прочее (буквы,
// запятые, точки) вырезаем сразу при вводе
const PHONE_JUNK_RE = /[^\d+\s()-]/g;
// В остальных полях пробел и разделители внутри значения не встречаются
const SPACE_RE = /\s+/g;
const SEPARATOR_JUNK_RE = /[;,]/g;

// Запятая, точка с запятой и перевод строки разделяют значения всегда
const HARD_SPLIT_RE = /[,;\n\r]+/;
// Пробел разделяет только email и ссылки: в номере он внутренний
// («+382 68 111 222»), а в Telegram может стоять номер
const WHITESPACE_SPLIT_RE = /[,;\n\r\s]+/;
/** Минимум цифр, при котором часть номера тянет на самостоятельный номер. */
const MIN_STANDALONE_DIGITS = 7;

const PHONE_VALID_RE = /^\+\d{8,15}$/;
const EMAIL_VALID_RE = /^[^\s@,;]+@[^\s@,;]+\.[^\s@,;]{2,}$/;
const TELEGRAM_HANDLE_RE = /^@?[A-Za-z0-9_]{4,32}$/;
const TELEGRAM_LINK_RE = /t\.me\//i;

/**
 * Приводит номер к канону `+382XXXXXXXX`.
 *
 * Местная запись (`068 111 222`, `068/111-222`, `33 452 805`) — то, как номер
 * печатают на визитке клиники, и без этого шага пользователь в наш формат не
 * попадёт. Номер с явным `+` не трогаем: он может быть и не черногорским.
 */
export function normalizePhoneValue(value: string): string {
	const digits = value.replace(/\D/g, '');
	if (!digits) return '';

	if (value.trim().startsWith('+')) return `+${digits}`;
	if (digits.startsWith('00')) return `+${digits.slice(2)}`;
	if (digits.startsWith(MNE_COUNTRY_CODE)) return `+${digits}`;
	if (digits.startsWith('0') && digits.length === MNE_LOCAL_DIGITS + 1) {
		return `+${MNE_COUNTRY_CODE}${digits.slice(1)}`;
	}
	if (digits.length === MNE_LOCAL_DIGITS) {
		return `+${MNE_COUNTRY_CODE}${digits}`;
	}

	// Непонятная длина: оставляем как есть, ошибку покажет валидация
	return `+${digits}`;
}

/** Канонический вид значения. Вызывается на blur и перед сохранением. */
export function normalizeContactValue(
	value: string,
	kind: ContactKind,
): string {
	const trimmed = value.trim();
	if (!trimmed) return '';

	if (kind === 'phone') return normalizePhoneValue(trimmed);
	// Телефон в поле мессенджера приводим к тому же канону — иначе он не
	// склеится с телефоном в одну строку с иконками
	if (kind === 'telegram' && isPhoneNumber(trimmed)) {
		return normalizePhoneValue(trimmed);
	}
	return trimmed;
}

/**
 * Убирает символы, которых в значении быть не может. Вызывается на каждый
 * ввод, поэтому нормализацию (склейку пробелов в номере) не делает — иначе
 * печатать номер невозможно.
 */
export function sanitizeContactValue(value: string, kind: ContactKind): string {
	if (kind === 'phone') return value.replace(PHONE_JUNK_RE, '');
	return value.replace(SPACE_RE, '').replace(SEPARATOR_JUNK_RE, '');
}

/**
 * Слэш в номере бывает и разделителем двух номеров («068 111 222 / 069 333
 * 444»), и внутренней пунктуацией одного («068/111-222»). Делим только если
 * каждая часть сама тянет на номер, иначе слэш просто вырежется санитайзером.
 */
function splitPhoneBySlash(part: string): string[] {
	if (!part.includes('/')) return [part];

	const pieces = part
		.split('/')
		.map((piece) => piece.trim())
		.filter((piece) => piece.length > 0);

	const allStandalone = pieces.every(
		(piece) => piece.replace(/\D/g, '').length >= MIN_STANDALONE_DIGITS,
	);
	return allStandalone ? pieces : [part];
}

/**
 * Разбивает ввод на отдельные значения. Запятая, точка с запятой и перевод
 * строки — это то, чем пользователь сам разделяет контакты, поэтому они не
 * вырезаются, а превращаются в новую строку списка.
 */
export function splitContactInput(raw: string, kind: ContactKind): string[] {
	const pattern =
		kind === 'email' || kind === 'url' ? WHITESPACE_SPLIT_RE : HARD_SPLIT_RE;
	const parts = raw
		.split(pattern)
		.map((item) => item.trim())
		.filter((item) => item.length > 0);

	return kind === 'phone' ? parts.flatMap(splitPhoneBySlash) : parts;
}

/** Пустое значение ошибкой не считается — оно просто не сохранится. */
export function isValidContactValue(value: string, kind: ContactKind): boolean {
	const normalized = normalizeContactValue(value, kind);
	if (!normalized) return true;

	switch (kind) {
		case 'phone':
			return PHONE_VALID_RE.test(normalized);
		case 'email':
			return EMAIL_VALID_RE.test(normalized);
		case 'telegram':
			return (
				PHONE_VALID_RE.test(normalized) ||
				TELEGRAM_HANDLE_RE.test(normalized) ||
				TELEGRAM_LINK_RE.test(normalized)
			);
		case 'url':
			return (
				!/[\s,;]/.test(normalized) &&
				(isAbsoluteUrl(normalized) ||
					normalized.includes('.') ||
					normalized.startsWith('@'))
			);
	}
}

/** Собирает значения в строку для БД, отбрасывая пустые. */
export function joinContacts(values: string[]): string {
	return values
		.map((value) => value.trim())
		.filter((value) => value.length > 0)
		.join(`${CONTACT_SEPARATOR} `);
}

/**
 * Полная обработка поля контактов: разбить, нормализовать, собрать обратно.
 * Общая точка для кабинета и для сервера — в БД попадает только канон.
 */
export function normalizeContactField(
	value: string | null | undefined,
	kind: ContactKind,
): string {
	if (!value) return '';
	return joinContacts(
		splitContactInput(value, kind).map((item) =>
			normalizeContactValue(sanitizeContactValue(item, kind), kind),
		),
	);
}

/** Есть ли в поле значение, которое мы не сможем показать на сайте. */
export function hasInvalidContactValue(
	value: string | null | undefined,
	kind: ContactKind,
): boolean {
	if (!value) return false;
	return splitContactInput(value, kind).some(
		(item) => !isValidContactValue(item, kind),
	);
}
