/**
 * Composable для работы с API кодами
 * Возвращает коды ответов API как есть для обработки компонентом
 */

import { SUCCESS_CODES, ERROR_CODES } from '~/server/utils/api-codes';

export const useApiMessages = () => {
	/**
	 * Получить код из API ответа
	 */
	const getCode = (code: string): string => {
		return code;
	};

	/**
	 * Вывести успешный код в консоль
	 * Компонент должен самостоятельно обработать код и показать сообщение
	 */
	const logSuccess = (response: { code?: string; success?: boolean }) => {
		if (response.code) {
			console.log('✅', response.code);
		}
	};

	/**
	 * Вывести код ошибки в консоль
	 * Компонент должен самостоятельно обработать код и показать сообщение
	 */
	const logError = (error: any) => {
		const code = error?.data?.code || error?.statusMessage;
		if (code) {
			console.error('❌', code);

			if (error?.data?.details) {
				console.error('Details:', error.data.details);
			}
		} else {
			console.error('❌', 'Unknown error');
		}
	};

	return {
		getCode,
		logSuccess,
		logError,
		SUCCESS_CODES,
		ERROR_CODES,
	};
};
