import { LanguageId } from '~/enums/language';

// Языки для статьи «Клиники с языковой поддержкой» (без сербского — он по умолчанию).
// Используется и на /articles для подсчёта цифр в мета-строке карточки.
export const CLINIC_SUPPORT_LANGUAGE_IDS = [
	LanguageId.EN,
	LanguageId.RU,
	LanguageId.DE,
	LanguageId.TR,
	LanguageId.IT,
	LanguageId.FR,
];
