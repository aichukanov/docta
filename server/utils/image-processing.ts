import sharp from 'sharp';
import { randomUUID } from 'node:crypto';
import { writeFile, mkdir, unlink } from 'node:fs/promises';
import { join, basename } from 'node:path';

const MAX_DIMENSION = 1600;
const WEBP_QUALITY = 82;

/**
 * Корневая директория хранилища загрузок.
 * В production — /home/docta/uploads (вне проекта, nginx отдаёт как /uploads/).
 * В dev — public/uploads (для удобства, отдаётся Nuxt dev-сервером).
 */
export function getUploadsRoot(): string {
	const config = useRuntimeConfig();
	return config.uploadsDir || join(process.cwd(), 'public', 'uploads');
}

/**
 * Корневая директория файлов верификации отзывов (чеки, направления).
 * Персональные данные — хранится ВНЕ public/, отдаётся только автору отзыва
 * и админу через /api/reviews/verification-file.
 */
export function getVerificationsRoot(): string {
	const config = useRuntimeConfig();
	return config.verificationsDir || join(process.cwd(), 'storage', 'verifications');
}

const ALLOWED_MIME_TYPES = [
	'image/jpeg',
	'image/png',
	'image/webp',
	'image/gif',
	'image/avif',
	'image/tiff',
];

const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB

export const VALID_CATEGORIES = ['avatars', 'doctors', 'clinics'] as const;

export type ImageCategory = (typeof VALID_CATEGORIES)[number];

/**
 * Валидация загружаемого файла изображения.
 * Возвращает null если файл валиден, или строку с ошибкой.
 */
export function validateImageFile(
	file: { type?: string; size?: number } | null,
): string | null {
	if (!file) return 'NO_FILE';
	if (!file.type || !ALLOWED_MIME_TYPES.includes(file.type))
		return 'INVALID_FILE_TYPE';
	if (file.size && file.size > MAX_FILE_SIZE) return 'FILE_TOO_LARGE';
	return null;
}

/**
 * Резолвит путь на диске по публичному URL (/uploads/avatars/xxx.webp).
 * Возвращает null для внешних URL.
 */
export function resolveUploadPath(url: string): string | null {
	if (!url || !url.startsWith('/uploads/')) return null;
	const relative = url.replace(/^\/uploads\//, '');
	return join(getUploadsRoot(), relative);
}

/**
 * Скачивает изображение по внешнему URL и сохраняет локально через processAndSaveImage.
 * Возвращает публичный URL.
 */
export async function downloadAndSaveImage(
	url: string,
	category: ImageCategory,
): Promise<string> {
	const response = await fetch(url);
	if (!response.ok) {
		throw new Error(`Failed to download image from ${url}: ${response.status}`);
	}
	const arrayBuffer = await response.arrayBuffer();
	return processAndSaveImage(Buffer.from(arrayBuffer), category);
}

/**
 * Возвращает true если URL — внешний (http/https).
 */
export function isExternalUrl(url: string): boolean {
	return url.startsWith('http://') || url.startsWith('https://');
}

/**
 * Сжимает изображение до MAX_DIMENSION по большей стороне,
 * конвертирует в WebP, сохраняет на диск.
 * Возвращает публичный URL.
 */
export async function processAndSaveImage(
	buffer: Buffer,
	category: ImageCategory,
): Promise<string> {
	const processed = await sharp(buffer)
		.rotate()
		.resize(MAX_DIMENSION, MAX_DIMENSION, {
			fit: 'inside',
			withoutEnlargement: true,
		})
		.webp({ quality: WEBP_QUALITY })
		.toBuffer();

	const filename = `${randomUUID()}.webp`;
	const uploadsRoot = getUploadsRoot();
	const categoryDir = join(uploadsRoot, category);
	const filePath = join(categoryDir, filename);

	await mkdir(categoryDir, { recursive: true });
	await writeFile(filePath, processed);

	return `/uploads/${category}/${filename}`;
}

/**
 * Сохраняет файл верификации отзыва в непубличное хранилище.
 * Возвращает имя файла на диске и размер после обработки.
 */
export async function processAndSaveVerificationImage(
	buffer: Buffer,
): Promise<{ storedName: string; size: number }> {
	const processed = await sharp(buffer)
		.rotate()
		.resize(MAX_DIMENSION, MAX_DIMENSION, {
			fit: 'inside',
			withoutEnlargement: true,
		})
		.webp({ quality: WEBP_QUALITY })
		.toBuffer();

	const storedName = `${randomUUID()}.webp`;
	const verificationsRoot = getVerificationsRoot();
	await mkdir(verificationsRoot, { recursive: true });
	await writeFile(join(verificationsRoot, storedName), processed);

	return { storedName, size: processed.length };
}

/**
 * Удаляет файл верификации с диска (замена отклонённого файла, откат
 * неудавшейся загрузки). Отсутствие файла — не ошибка.
 */
export async function deleteVerificationImage(storedName: string): Promise<void> {
	try {
		await unlink(join(getVerificationsRoot(), basename(storedName)));
	} catch (error: any) {
		if (error?.code !== 'ENOENT') throw error;
	}
}
