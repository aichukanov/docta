import sharp from 'sharp';
import { randomUUID } from 'node:crypto';
import { writeFile, mkdir } from 'node:fs/promises';
import { join } from 'node:path';

const MAX_DIMENSION = 1600;
const WEBP_QUALITY = 82;

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
	const relativeDir = join('uploads', category);
	const publicDir = join(process.cwd(), 'public', relativeDir);

	await mkdir(publicDir, { recursive: true });
	await writeFile(join(publicDir, filename), processed);

	return `/${relativeDir}/${filename}`.replace(/\\/g, '/');
}
