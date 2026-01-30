export default defineNuxtConfig({
	compatibilityDate: '2025-11-23',

	modules: ['nuxt-gtag', '@element-plus/nuxt', '@nuxtjs/i18n', '@pinia/nuxt'],

	// Разрешаем ngrok домены
	vite: {
		server: {
			hmr: false, // Отключаем HMR для ngrok
		},
	},

	nitro: {
		devProxy: {
			'/__nuxt_devtools__': {
				target: 'http://localhost:3000/__nuxt_devtools__',
				changeOrigin: true,
			},
		},
	},

	devServer: {
		host: '0.0.0.0',
		port: 3000,
		https: false,
	},

	app: {
		baseURL: '/',
	},

	// gtag: {
	// 	id: process.env.GTAG_ID,
	// 	enabled: process.env.NODE_ENV === 'production',
	// 	loadingStrategy: 'async',
	// 	initCommands: [
	// 		[
	// 			'consent',
	// 			'default',
	// 			{
	// 				ad_user_data: 'denied',
	// 				ad_personalization: 'denied',
	// 				ad_storage: 'denied',
	// 				analytics_storage: 'denied',
	// 				wait_for_update: 500,
	// 			},
	// 		],
	// 	],
	// },
	components: ['~/components'],

	runtimeConfig: {
		public: {
			mixpanelToken: process.env.MIXPANEL_TOKEN,
			cloudflareToken: process.env.CLOUDFLARE_TOKEN,
			telegramBotUsername: process.env.TELEGRAM_BOT_USERNAME,
			connection: {
				host: process.env.DB_HOST,
				user: process.env.DB_USER,
				password: process.env.DB_PASSWORD,
			},
		},
	},

	routeRules: {
		'/**': { cors: true, ssr: true, prerender: false },
		'/admin/**': { cors: true, ssr: false, prerender: false },
		'/img/**': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/photos/**': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/favicon.ico': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/logo-site.png': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/tg.png': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/email.png': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/**/*.png': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/**/*.svg': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/**/*.webp': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/*.js': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/_ca/**': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
		'/site.webmanifest': {
			headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
		},
	},

	devtools: { enabled: false },
});
