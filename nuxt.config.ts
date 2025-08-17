export default defineNuxtConfig({
	compatibilityDate: '2025-07-02',

	modules: ['nuxt-gtag', '@element-plus/nuxt', '@nuxtjs/i18n'],

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
			cloudflareTokens: {
				svad: process.env.CLOUDFLARE_SVAD_TOKEN,
			},
		},
	},

	routeRules: {
		// '/**': { cors: true, ssr: true, prerender: false },
		'/**': { ssr: false },
	},

	devtools: { enabled: false },
});
