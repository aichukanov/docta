export default defineNuxtConfig({
	compatibilityDate: '2025-11-23',

	modules: ['nuxt-gtag', '@element-plus/nuxt', '@nuxtjs/i18n', '@pinia/nuxt'],

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
	},

	devtools: { enabled: false },
});
