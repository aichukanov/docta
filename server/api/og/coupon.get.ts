import sharp from 'sharp';
import { readFile } from 'node:fs/promises';
import { OG_IMAGE } from '~/common/constants';
import { validateNonNegativeInteger } from '~/common/validation';
import { executeQuery } from '~/server/common/db-mysql';
import { resolveUploadPath } from '~/server/utils/image-processing';

// Facebook просит 1200×630 (1.91:1) и надёжно жуёт JPEG, тогда как загрузки у
// нас в WebP. Поэтому картинку купона отдаём отдельным роутом в JPEG, а не
// ссылаемся на файл из /uploads напрямую.
const OG_WIDTH = 1200;
const OG_HEIGHT = 630;
const JPEG_QUALITY = 85;

/**
 * og:image для купона — превью ссылки в Telegram, Facebook и мессенджерах.
 *
 * Путь к файлу берётся из БД по id купона, а не из параметра запроса: иначе
 * это был бы способ прочитать произвольный файл. Параметр `v` только сбивает
 * кэш соцсетей при замене картинки, в выборке не участвует.
 */
export default defineEventHandler(async (event) => {
	const query = getQuery(event);

	try {
		if (!validateNonNegativeInteger(String(query.couponId ?? ''))) {
			return sendRedirect(event, OG_IMAGE, 302);
		}

		const rows = await executeQuery<{ imageUrl: string | null }>(
			`SELECT image_url AS imageUrl
			 FROM clinic_coupons
			 WHERE id = ? AND is_active = 1
			 LIMIT 1`,
			[Number(query.couponId)],
		);

		const imageUrl = rows[0]?.imageUrl;
		const filePath = imageUrl ? resolveUploadPath(imageUrl) : null;
		// Нет купона, нет картинки или она внешняя (resolveUploadPath вернёт null)
		if (!filePath) {
			return sendRedirect(event, OG_IMAGE, 302);
		}

		const source = await readFile(filePath);
		const image = await sharp(source)
			// contain, а не cover: купон нельзя обрезать, на нём условия акции
			.resize(OG_WIDTH, OG_HEIGHT, {
				fit: 'contain',
				background: { r: 255, g: 255, b: 255 },
			})
			.flatten({ background: { r: 255, g: 255, b: 255 } })
			.jpeg({ quality: JPEG_QUALITY })
			.toBuffer();

		setHeader(event, 'content-type', 'image/jpeg');
		// URL содержит версию файла (?v=), поэтому кэшировать можно надолго
		setHeader(event, 'cache-control', 'public, max-age=31536000, immutable');
		return image;
	} catch (error) {
		console.error('API Error - coupon og image:', error);
		// Ошибка не должна оставлять ссылку вообще без превью
		return sendRedirect(event, OG_IMAGE, 302);
	}
});
