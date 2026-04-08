require('dotenv').config({ path: require('path').resolve(__dirname, '.env') });

module.exports = {
	apps: [
		{
			name: 'docta',
			cwd: __dirname,
			port: '3001',
			exec_mode: 'cluster',
			instances: 'max',
			script: './.output/server/index.mjs',
			env: {
				NODE_ENV: 'production',
				NUXT_DB_HOST: process.env.DB_HOST,
				NUXT_DB_USER: process.env.DB_USER,
				NUXT_DB_PASSWORD: process.env.DB_PASSWORD,
				NUXT_PUBLIC_TELEGRAM_BOT_ID: (process.env.TELEGRAM_BOT_TOKEN || '').split(':')[0],
				NUXT_PUBLIC_MIXPANEL_TOKEN: process.env.MIXPANEL_TOKEN,
				NUXT_PUBLIC_CLOUDFLARE_TOKEN: process.env.CLOUDFLARE_TOKEN,
			},
		},
	],
};
