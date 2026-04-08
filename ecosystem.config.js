require('dotenv').config();

module.exports = {
	apps: [
		{
			name: 'docta',
			port: '3000',
			exec_mode: 'cluster',
			instances: 'max',
			script: './.output/server/index.mjs',
			env: {
				...process.env,
				NODE_ENV: 'production',
			},
		},
	],
};
