require('dotenv').config();

module.exports = {
	apps: [
		{
			name: 'omeda',
			port: '3000',
			exec_mode: 'cluster',
			instances: 'max',
			script: './.output/server/index.mjs',
			env: {
				MIXPANEL_TOKEN: process.env.MIXPANEL_TOKEN,
				NODE_ENV: 'production',
			},
		},
	],
};
