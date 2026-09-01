import sharp from 'sharp';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { SITE_URL } from '~/common/constants';

/**
 * Дефолтная og:image сайта — 1200×630.
 *
 * Раньше дефолтом стоял `/apple-touch-icon.png` (180×180). Facebook и LinkedIn
 * отбрасывают картинки меньше 200×200 и рендерят превью вообще без картинки, а
 * это дефолт главной, всех листингов и всех карточек врачей, услуг, анализов и
 * лекарств — то есть всего, чем делятся в Telegram-промо.
 *
 * Механика та же, что у купона (`coupon.get.ts`): отдельный роут с JPEG, а не
 * ссылка на файл из public/ — там нет ни одного изображения нужного размера, а
 * логотип лежит в 352×70.
 */
const OG_WIDTH = 1200;
const OG_HEIGHT = 630;
// ~60% ширины: логотип читается и в крупном превью Facebook, и в узком Telegram
const LOGO_WIDTH = 720;
const JPEG_QUALITY = 88;
const BACKGROUND = { r: 255, g: 255, b: 255, alpha: 1 };

/**
 * Результат детерминирован (собирается из одного и того же файла логотипа),
 * поэтому рисуем один раз на процесс, а не на каждый запрос краулера соцсети.
 */
let cachedImage: Buffer | null = null;

async function renderDefaultOgImage(): Promise<Buffer> {
	// Тот же способ добраться до public/, что и у загрузок
	// (server/utils/image-processing.ts): pm2 запускает приложение из корня
	// проекта, см. cwd в ecosystem.config.cjs.
	const logoPath = join(process.cwd(), 'public', 'logo-site.png');
	const logo = await sharp(await readFile(logoPath))
		.resize({ width: LOGO_WIDTH, kernel: 'lanczos3' })
		.toBuffer();

	return sharp({
		create: {
			width: OG_WIDTH,
			height: OG_HEIGHT,
			channels: 4,
			background: BACKGROUND,
		},
	})
		.composite([{ input: logo, gravity: 'centre' }])
		.jpeg({ quality: JPEG_QUALITY })
		.toBuffer();
}

export default defineEventHandler(async (event) => {
	try {
		cachedImage ??= await renderDefaultOgImage();

		setHeader(event, 'content-type', 'image/jpeg');
		// Сутки, а не immutable как у купона: у купона в URL есть версия файла,
		// здесь версии нет, и после смены логотипа картинка не должна залипнуть
		// в кэшах соцсетей на год.
		setHeader(event, 'cache-control', 'public, max-age=86400');
		return cachedImage;
	} catch (error) {
		console.error('API Error - default og image:', error);
		// Именно на файл иконки, а не на OG_IMAGE: OG_IMAGE — это и есть данный
		// роут, редирект на него дал бы петлю. Маленькая картинка лучше, чем
		// ответ 500 в превью.
		return sendRedirect(event, `${SITE_URL}/apple-touch-icon.png`, 302);
	}
});
