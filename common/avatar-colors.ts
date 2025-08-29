/**
 * Система генерации приятных цветов для аватаров врачей
 *
 * Генерирует консистентные, красивые цвета на основе имени врача,
 * избегая "грязных" серых оттенков
 */

/**
 * Палитра приятных цветов для аватаров
 * Цвета выбраны так, чтобы быть яркими, современными и хорошо читаемыми на белом тексте
 */
const PLEASANT_COLORS = [
	'#4f46e5', // Indigo (основной цвет проекта)
	'#06b6d4', // Cyan (вторичный цвет проекта)
	'#7c3aed', // Purple (хороший контраст с белым текстом)
	'#10b981', // Emerald
	'#8b5cf6', // Violet
	'#ff6b35', // Bright Orange (заменен коричневатый)
	'#ec4899', // Pink
	'#ef4444', // Red
	'#22c55e', // Green
	'#3b82f6', // Blue
	'#a855f7', // Purple
	'#14b8a6', // Teal
	'#00d4aa', // Mint (заменен дублированный оранжевый)
	'#84cc16', // Lime
	'#6366f1', // Indigo variant
	'#ff5722', // Deep Orange (яркий, не коричневый)
] as const;

/**
 * Очищает имя врача от префиксов для генерации аватара
 * Удаляет префиксы "dr.", "dr ", "Prof. dr.", "Prof. dr ", "Prof.dr.", "Prof.dr ", "prim dr", "prim. dr."
 * чтобы цвет генерировался на основе реального имени, а не префикса
 */
function cleanDoctorNameForAvatar(fullName: string): string {
	// Регулярное выражение для удаления префиксов:
	// - Prof\.?\s*dr\.?\s* (Prof. dr. или Prof dr или Prof.dr)
	// - prim\.?\s*dr\.?\s* (prim dr или prim. dr.)
	// - dr\.?\s* (dr. или dr)
	// Префиксы могут быть в начале строки (^) и после них должно идти имя
	return fullName
		.replace(/^Prof\.?\s*dr\.?\s+/i, '') // убираем "Prof. dr. " или вариации
		.replace(/^prim\.?\s*dr\.?\s+/i, '') // убираем "prim dr " или "prim. dr. "
		.replace(/^dr\.?\s+/i, '') // убираем "dr. " или "dr "
		.trim();
}

/**
 * Создает простой хеш из строки для консистентной генерации цвета
 * Использует алгоритм djb2 для быстрого и стабильного хеширования
 */
function createSimpleHash(str: string): number {
	let hash = 5381;
	for (let i = 0; i < str.length; i++) {
		hash = (hash << 5) + hash + str.charCodeAt(i);
	}
	return Math.abs(hash);
}

/**
 * Генерирует приятный цвет для аватара на основе имени врача
 *
 * @param name - Полное имя врача (может содержать префиксы типа "Dr.", "Prof. dr.")
 * @returns Hex цвет в формате "#rrggbb"
 *
 * @example
 * ```typescript
 * const color1 = generateAvatarColor('Dr. Marko Petrović');
 * const color2 = generateAvatarColor('Prof. dr. Ana Milović');
 * // Каждое имя всегда даст один и тот же цвет
 * ```
 */
export function generateAvatarColor(name: string): string {
	// Обработка edge cases
	if (!name || name.trim().length === 0) {
		return PLEASANT_COLORS[0]; // Возвращаем основной цвет проекта для пустых имен
	}

	// Очищаем имя от префиксов
	const cleanName = cleanDoctorNameForAvatar(name);

	// Если после очистки имя пустое, используем исходное
	const nameForHashing = cleanName.length > 0 ? cleanName : name;

	// Создаем хеш из очищенного имени
	const hash = createSimpleHash(nameForHashing.toLowerCase());

	// Выбираем цвет из палитры на основе хеша
	const colorIndex = hash % PLEASANT_COLORS.length;

	return PLEASANT_COLORS[colorIndex];
}

/**
 * Альтернативный метод генерации цветов через HSL
 * Генерирует цвета с высокой насыщенностью и оптимальной яркостью
 * (оставлен для возможного использования в будущем)
 */
export function generateAvatarColorHSL(name: string): string {
	if (!name || name.trim().length === 0) {
		return '#4f46e5';
	}

	const cleanName = cleanDoctorNameForAvatar(name);
	const nameForHashing = cleanName.length > 0 ? cleanName : name;
	const hash = createSimpleHash(nameForHashing.toLowerCase());

	// Генерируем HSL параметры
	const hue = hash % 360; // Полный спектр оттенков
	const saturation = 65 + (hash % 25); // 65-90% насыщенность (яркие цвета)
	const lightness = 45 + (hash % 15); // 45-60% яркость (не слишком темные/светлые)

	// Конвертируем HSL в RGB
	const h = hue / 360;
	const s = saturation / 100;
	const l = lightness / 100;

	const c = (1 - Math.abs(2 * l - 1)) * s;
	const x = c * (1 - Math.abs(((h * 6) % 2) - 1));
	const m = l - c / 2;

	let r: number, g: number, b: number;

	if (h < 1 / 6) {
		[r, g, b] = [c, x, 0];
	} else if (h < 2 / 6) {
		[r, g, b] = [x, c, 0];
	} else if (h < 3 / 6) {
		[r, g, b] = [0, c, x];
	} else if (h < 4 / 6) {
		[r, g, b] = [0, x, c];
	} else if (h < 5 / 6) {
		[r, g, b] = [x, 0, c];
	} else {
		[r, g, b] = [c, 0, x];
	}

	const toHex = (n: number): string => {
		const hex = Math.round((n + m) * 255).toString(16);
		return hex.length === 1 ? '0' + hex : hex;
	};

	return `#${toHex(r)}${toHex(g)}${toHex(b)}`;
}
