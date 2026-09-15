require('dotenv').config({ path: require('path').resolve(__dirname, '.env') });

module.exports = {
	apps: [
		{
			name: 'docta',
			cwd: __dirname,
			port: '3001',
			exec_mode: 'cluster',
			// Явное число, а не 'max'.
			//
			// Размер пула MySQL задаётся НА ПРОЦЕСС (connectionLimit: 10 в
			// server/common/db-mysql.ts), поэтому суммарно к базе идёт
			// instances × 10 соединений при потолке max_connections = 151,
			// который делится ещё и с соседними приложениями на этой машине.
			// С 'max' это число молча следует за железом: переезд на сервер с
			// 16 ядрами дал бы 160 соединений и «Too many connections» в самый
			// неподходящий момент. Сейчас на сервере 4 ядра — 4 × 10 = 40.
			//
			// Меняя это число, проверить инвариант:
			//   instances × connectionLimit + запас на соседей < max_connections
			instances: 4,
			script: './.output/server/index.mjs',
			// Аварийный предохранитель от утечки, а не рабочий режим: под нагрузкой
			// воркер держит ~350-400 МБ, так что до лимита в обычной жизни не доходит.
			// На сервере с 8 ГБ это важнее, чем было на 16 ГБ: без потолка один
			// распухший процесс утягивает за собой соседние приложения через OOM.
			max_memory_restart: '1G',
			env: {
				NODE_ENV: 'production',
				// Слушаем только петлю: наружу приложение смотрит через nginx-прокси.
				// Без этого Nitro биндится на 0.0.0.0 и порт 3001 доступен из интернета
				// в обход прокси — так и было на старом сервере.
				HOST: '127.0.0.1',
				NITRO_HOST: '127.0.0.1',
				NUXT_DB_HOST: process.env.DB_HOST,
				NUXT_DB_USER: process.env.DB_USER,
				NUXT_DB_PASSWORD: process.env.DB_PASSWORD,
				NUXT_PUBLIC_TELEGRAM_BOT_ID: (process.env.TELEGRAM_BOT_TOKEN || '').split(':')[0],
				NUXT_PUBLIC_MIXPANEL_TOKEN: process.env.MIXPANEL_TOKEN,
			},
		},
	],
};
