const IMMUTABLE = {
	headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
};

export default defineNuxtConfig({
	compatibilityDate: '2026-04-06',

	modules: [
		'@ach/ui-kit/nuxt',
		'nuxt-gtag',
		'@element-plus/nuxt',
		'@nuxtjs/i18n',
		'@pinia/nuxt',
	],

	nitro: {
		// Даёт getConnection() доступ к текущему запросу через useEvent(),
		// чтобы соединение возвращалось в пул при закрытии ответа даже там,
		// где хендлер не дошёл до end() (server/common/db-mysql.ts).
		experimental: { asyncContext: true },

		// Кэш для defineCachedFunction. Драйвер по умолчанию — память процесса,
		// а pm2 поднят в кластере с `instances: 'max'` (ecosystem.config.cjs),
		// поэтому каждый воркер грел бы свою копию и попадание было бы 1/N.
		// Файловый драйвер один на машину: `cwd` у pm2 — корень проекта.
		storage: {
			cache: { driver: 'fs', base: './.data/cache' },
		},

		// Сжатия на origin не было вообще: node-пресет nitro сам не сжимает, а
		// предсжатых файлов в сборке не лежало. Cloudflare дожимает клиенту, но
		// плечо origin → CF шло сырьём, как и любой заход мимо CF.
		// Это покрывает статику; SSR-ответы так не сжать — для них нужен
		// отдельный пакет, см. отчёт.
		compressPublicAssets: { gzip: true, brotli: true },

		devProxy: {
			'/__nuxt_devtools__': {
				target: 'http://localhost:3000/__nuxt_devtools__',
				changeOrigin: true,
			},
		},
	},

	app: {
		baseURL: '/',

		head: {
			// Ни одного resource hint в проекте не было, при том что в критическом
			// пути четыре сторонних домена — на каждый браузер платил DNS + TCP +
			// TLS уже после разбора HTML, конкурируя с основным контентом.
			//
			// preconnect (дорогой, поднимает соединение целиком) — только двум
			// доменам с картинками: фото врачей и генератор аватарок-заглушек.
			// Аватар в карточке врача грузится eager и на детальной странице
			// является LCP-элементом, то есть соединение нужно немедленно.
			//
			// Карта — dns-prefetch: она есть не на всех страницах и уходит под
			// фолд, поднимать под неё соединение заранее на каждой странице
			// невыгодно, а резолв имени сэкономить стоит.
			link: [
				{ rel: 'preconnect', href: 'https://lh3.googleusercontent.com' },
				{ rel: 'preconnect', href: 'https://ui-avatars.com' },
				{ rel: 'dns-prefetch', href: 'https://unpkg.com' },
				{ rel: 'dns-prefetch', href: 'https://tile.openstreetmap.org' },
			],
		},
	},

	gtag: {
		id: process.env.GTAG_ID || 'G-CN6LNPX9NF',
		enabled: process.env.NODE_ENV === 'production',
		loadingStrategy: 'async',
		initCommands: [
			[
				'consent',
				'default',
				{
					ad_user_data: 'denied',
					ad_personalization: 'denied',
					ad_storage: 'denied',
					analytics_storage: 'denied',
					wait_for_update: 500,
				},
			],
		],
	},
	// Токены приезжают из @ach/ui-kit — модуль пакета добавляет их первыми.
	// Мост Element Plus подключён явно, чтобы его было видно и можно было
	// удалить одной строкой вместе с самим Element Plus.
	css: ['@ach/ui-kit/element-plus-bridge.css'],

	components: ['~/components'],

	runtimeConfig: {
		uploadsDir: process.env.UPLOADS_DIR || '',
		verificationsDir: process.env.VERIFICATIONS_DIR || '',
		baseUrl: process.env.BASE_URL || '',
		googleClientId: process.env.GOOGLE_CLIENT_ID || '',
		googleClientSecret: process.env.GOOGLE_CLIENT_SECRET || '',
		facebookAppId: process.env.FACEBOOK_APP_ID || '',
		facebookAppSecret: process.env.FACEBOOK_APP_SECRET || '',
		telegramBotToken: process.env.TELEGRAM_BOT_TOKEN || '',
		telegramBotUsername: process.env.TELEGRAM_BOT_USERNAME || '',
		mailgunApiKey: process.env.MAILGUN_API_KEY || '',
		mailgunApiUrl: process.env.MAILGUN_API_URL || '',
		mailgunDomain: process.env.MAILGUN_DOMAIN || '',
		mailgunFromEmail: process.env.MAILGUN_FROM_EMAIL || '',
		mailgunFromName: process.env.MAILGUN_FROM_NAME || '',
		stripeSecretKey: process.env.STRIPE_SECRET_KEY || '',
		stripeWebhookSecret: process.env.STRIPE_WEBHOOK_SECRET || '',
		dbHost: process.env.DB_HOST || '',
		dbUser: process.env.DB_USER || '',
		dbPassword: process.env.DB_PASSWORD || '',
		public: {
			telegramBotId: (process.env.TELEGRAM_BOT_TOKEN || '').split(':')[0],
			mixpanelToken: process.env.MIXPANEL_TOKEN,
			stripePublishableKey:
				process.env.NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || '',
		},
	},

	routeRules: {
		'/**': { cors: true, ssr: true, prerender: false },
		'/profile': { ssr: false },
		'/login': { ssr: false },
		'/reset-password': { ssr: false },
		'/verify-email': { ssr: false },
		'/forgot-password': { ssr: false },
		'/confirm-email-change': { ssr: false },
		// данные Telegram приезжают в hash-фрагменте — читать их может только клиент.
		// Заголовком дублируем noindex: на ssr:false странице meta появляется
		// только после выполнения JS, а краулер его может не дождаться
		'/auth/telegram/return': {
			ssr: false,
			headers: { 'X-Robots-Tag': 'noindex, nofollow' },
		},
		// Заголовком, а не только meta: страница ssr:false, её meta появляется
		// после выполнения JS — тот же приём, что и на /auth/telegram/return.
		'/admin/**': {
			cors: true,
			ssr: false,
			prerender: false,
			headers: { 'X-Robots-Tag': 'noindex, nofollow' },
		},
		// Каталоги статики целиком.
		'/img/**': IMMUTABLE,
		'/photos/**': IMMUTABLE,
		'/uploads/**': IMMUTABLE,
		'/__sitemap__/**': IMMUTABLE,

		// Файлы в корне public/ — только поимённо.
		//
		// Правила вида `/**/*.png` и `/*.js`, стоявшие здесь раньше, не матчили
		// ничего: nitro разбирает routeRules через radix3, а тот не поддерживает
		// glob-суффиксы — `**` обязан быть последним сегментом, `*.png` читается
		// как сегмент с буквальным именем «*.png». Иконки из `app.vue` в итоге
		// отдавались вообще без Cache-Control и ревалидировались каждый визит.
		// Добавляя файл в корень public/, дописывать строку сюда.
		'/favicon.ico': IMMUTABLE,
		'/favicon.svg': IMMUTABLE,
		'/favicon-96x96.png': IMMUTABLE,
		'/apple-touch-icon.png': IMMUTABLE,
		'/web-app-manifest-192x192.png': IMMUTABLE,
		'/web-app-manifest-512x512.png': IMMUTABLE,
		'/logo-site.png': IMMUTABLE,
		'/garland.svg': IMMUTABLE,
		'/tg.svg': IMMUTABLE,
		'/email.svg': IMMUTABLE,
		'/site.webmanifest': IMMUTABLE,

		// robots.txt, ads.txt, ключ IndexNow и .well-known сознательно без
		// длинного кэша: их правят руками и ждут, что правка доедет сразу.
	},

	devtools: { enabled: false },
});
