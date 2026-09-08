const IMMUTABLE = {
	headers: { 'Cache-Control': 'max-age=31536000, public, immutable' },
};

const NOINDEX = { 'X-Robots-Tag': 'noindex, nofollow' };

// Страницы без единого обращения к БД: главная, правовые, статьи. Меняются
// только выкаткой, поэтому час на общих кэшах и сутки на отдачу устаревшей
// копии во время обновления.
const CACHED_STATIC = {
	headers: {
		'Cache-Control':
			'public, max-age=0, s-maxage=3600, stale-while-revalidate=86400',
	},
};

// Каталог: карточки услуг, анализов, лекарств и листинги. Данные меняются
// импортами и правками в админке — десять минут достаточно, чтобы правка
// доехала без ручного сброса кэша.
const CACHED_CATALOG = {
	headers: {
		'Cache-Control':
			'public, max-age=0, s-maxage=600, stale-while-revalidate=86400',
	},
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
			// Resource hints в проекте не было вовсе, при том что в критическом
			// пути стояли сторонние домены — на каждый браузер платил DNS + TCP +
			// TLS уже после разбора HTML, конкурируя с основным контентом.
			//
			// Осталось два, и оба заработаны:
			//
			// preconnect (дорогой, поднимает соединение целиком) — фото врачей.
			// Аватар в карточке грузится eager и на детальной странице является
			// LCP-элементом, то есть соединение нужно немедленно.
			//
			// Тайлы карты — dns-prefetch: карта есть не на всех страницах и
			// уходит под фолд, поднимать под неё соединение заранее на каждой
			// странице невыгодно, а резолв имени сэкономить стоит.
			//
			// Здесь были ещё unpkg.com и ui-avatars.com — оба домена ушли:
			// Leaflet переехал в public/leaflet (composables/use-leaflet.ts),
			// заглушка аватара рисуется инициалами локально, без запроса
			// (components/doctor/avatar.vue). Подсказки на них стали бы
			// соединением в никуда.
			link: [
				{ rel: 'preconnect', href: 'https://lh3.googleusercontent.com' },
				{ rel: 'dns-prefetch', href: 'https://tile.openstreetmap.org' },
			],
		},
	},

	gtag: {
		id: process.env.GTAG_ID || 'G-CN6LNPX9NF',
		// Скрипт не вставляется в <head> модулем: его подключает useAnalytics
		// через initialize() в простое после гидрации, и только когда
		// public.gtagEnabled. dataLayer и consent-default модуль всё равно
		// заводит сразу, так что команды до загрузки не теряются.
		enabled: false,
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
	// Дальше стили Element Plus одним файлом и мост к токенам: мост
	// переопределяет переменные EP, поэтому обязан идти после них. Обе строки
	// удаляются вместе с самим Element Plus.
	css: ['~/assets/css/element-plus.css', '@ach/ui-kit/element-plus-bridge.css'],

	// Стили EP не тянуть из чанков компонентов: иначе каждый el-компонент
	// приносит свой CSS отдельным блокирующим <link> (до 20 на страницу).
	// Список подключаемых стилей — assets/css/element-plus.css.
	elementPlus: { importStyle: false },

	i18n: {
		// Дефолт модуля — `useCookie: true` — писал `i18n_redirected=sr` в
		// каждый первый ответ. Локаль у нас определяется адресом, а
		// предпочтение хранит своя cookie `locale`, так что эту никто не
		// читал (docs/rules/LOCALE_ARCHITECTURE.md). Но ответ с `Set-Cookie`
		// Cloudflare не кэширует вовсе: `cf-cache-status: BYPASS` на каждой
		// странице при правильно настроенном Cache Rule — это было оно.
		// Боты cookie не хранят, поэтому у них бы бypass был на КАЖДЫЙ запрос.
		detectBrowserLanguage: false,
	},

	experimental: {
		defaults: {
			// Префетч страниц по наведению, а не по попаданию ссылки во вьюпорт:
			// на листинге ~100 внутренних ссылок, и дефолтный `visibility`
			// вешал на каждую IntersectionObserver и тянул чанки + payload всех
			// видимых страниц, конкурируя с LCP (158 мс на чанке NuxtLink).
			nuxtLink: { prefetchOn: { visibility: false, interaction: true } },
		},
	},

	features: {
		// Инлайнить в HTML только стили .vue-компонентов (дефолт Nuxt 4).
		// Глобальный CSS (токены, EP, мост) остаётся одной кэшируемой ссылкой:
		// с true он и инлайнился на каждой странице, и подключался ссылкой.
		inlineStyles: (id) => !!id && id.includes('.vue'),
	},

	hooks: {
		// Nuxt инлайнит стили отрендеренных компонентов, но <link> на CSS общих
		// чанков (_KitAvatar, use-in-viewport…) при этом оставляет: его
		// собственная зачистка манифеста сравнивает имя CSS-файла с именем
		// компонента, а Rollup называет общий чанк по первому модулю. Итог —
		// половина блокирующих ссылок дублировала инлайн байт в байт
		// (docs/audit/lighthouse-perf-2026-09.md).
		//
		// Весь CSS вне entry — стили .vue, и он уже в <style>. Ссылки на него в
		// SSR-HTML лишние. При клиентской навигации CSS чанков подтягивает
		// preload-helper Vite по своему списку зависимостей, манифест Nuxt
		// для этого не используется.
		'build:manifest'(manifest) {
			for (const chunk of Object.values(manifest)) {
				if (!chunk.isEntry) chunk.css = [];
			}
		},

		// Rollup режет клиент на ~350 чанков, из них 130 меньше 2 КБ; на страницу
		// уходило ~100 <link rel="modulepreload">. Каждый — отдельный запрос с
		// приоритетом High, и Lighthouse (Lantern) считает их блокирующими
		// первую отрисовку: FCP в симуляции 5,8 с при реальных 0,6 с. Порог
		// сливает мелкие чанки с их общими зависимыми, не меняя по смыслу, что и
		// когда загружается. Замер: чанков 353 → 234, preload на странице
		// клиники 96 → 46 (docs/audit/lighthouse-perf-2026-09.md, §5).
		//
		// Через хук, а не через `vite.build.rollupOptions.output`: сборку делает
		// Vite 7 на Rollup 4 (@nuxt/vite-builder), а типы конфига Nuxt берёт из
		// вложенного Vite 8 на Rolldown, где этой опции нет — поле в конфиге не
		// проходит typecheck. Object.assign типизируется без каста. При
		// переезде на Vite 8 опцию пересмотреть.
		'vite:extendConfig'(config, { isClient }) {
			if (!isClient) return;
			const output = config.build?.rollupOptions?.output;
			if (!output || Array.isArray(output)) return;
			Object.assign(output, { experimentalMinChunkSize: 20000 });
		},
	},

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
			gtagEnabled: process.env.NODE_ENV === 'production',
			telegramBotId: (process.env.TELEGRAM_BOT_TOKEN || '').split(':')[0],
			mixpanelToken: process.env.MIXPANEL_TOKEN,
			stripePublishableKey:
				process.env.NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || '',
		},
	},

	routeRules: {
		// `cors: true` здесь стоял с первого коммита, без обоснования и без
		// единого потребителя в коде — снят 2026-09-03.
		//
		// Он не закрывал и не открывал доступ к данным: каталог публичный, и
		// любой `curl` возьмёт его в любом случае. Что он давал — это право
		// СТОРОННЕМУ САЙТУ читать наши страницы и API из браузеров своих
		// посетителей: без своего сервера, с живыми IP и настоящими
		// user-agent. То есть ровно тот слой, за который платится Cloudflare,
		// обходился штатно и бесплатно.
		//
		// Утечки не было: `Allow-Credentials` nitro не выставляет, значит
		// cookie кросс-доменно не уходили и авторизацию через это обойти было
		// нельзя. Плюс `access-control-max-age: 0` запрещал кэшировать
		// preflight — каждый кросс-доменный POST шёл двумя запросами.
		//
		// Понадобится снова (виджет, встраивание, публичное API) — включать
		// точечно на конкретных путях, а не на `/**`, и уж точно не на HTML.
		'/**': { ssr: true, prerender: false },

		// ── Кэш HTML на общих кэшах (Cloudflare) ──────────────────────────
		//
		// Замер на проде: листинг отдаётся за ~1,9–2,5 с, и это рендер Vue, а
		// не база — те же данные через API приходят за 23–66 мс. На сервере 4
		// ядра, которые docta делит с тремя соседними приложениями, поэтому
		// каждый закэшированный ответ — это освобождённое ядро-время.
		//
		// Стало возможным только после того, как локаль перестала зависеть от
		// cookie (server/common/redirect/regional-settings.ts): раньше один
		// адрес отдавал разным людям разное, и общий кэш отдал бы не тот язык.
		// Ключ кэша включает query, так что `?lang=ru` и голый URL — разные
		// записи.
		//
		// `max-age=0` — браузер каждый раз перепроверяет, поэтому правки
		// контента видны сразу; `s-maxage` действует только на общие кэши;
		// `stale-while-revalidate` отдаёт прошлую копию, пока обновляется
		// новая, то есть посетитель не ждёт рендер никогда.
		//
		// ВАЖНО: сами по себе эти заголовки ничего не включают — Cloudflare по
		// умолчанию HTML не кэширует. Нужен Cache Rule в панели; он стоит там
		// с 2026-09-08, вместе с воркером локали и правилом для sitemap
		// (docs/rules/EDGE_LOCALE_CACHE.md — там же выражение правила, его
		// придётся править синхронно с этим списком путей).
		//
		// И ещё одно условие, не видное отсюда: ответ с `Set-Cookie`
		// Cloudflare не кэширует НИКОГДА. Из-за дефолта `@nuxtjs/i18n`
		// (`i18n_redirected`) кэш не работал вообще — см. `i18n` выше.
		//
		// Карточки клиник и врачей сначала были исключены: в их серверную
		// разметку попадает баннер владельца (`isOwner`). Исключение снято —
		// оно было и слишком дорогим, и недостаточным.
		//
		// Дорогим: это самый крупный раздел. В sitemap 8196 адресов врачей и
		// 2274 клиники против 204 во всём core — то есть без них кэш накрывал
		// бы 2% поверхности сайта.
		//
		// Недостаточным: персональные данные лежат в payload КАЖДОЙ страницы,
		// а не только этих двух. Pinia сериализует стор пользователя в
		// `__NUXT_DATA__`, потому что `app.vue` зовёт `fetchUser()` в setup и
		// на сервере тот ходит в API с cookie запроса. Проверено на проде.
		//
		// Правильная граница — не путь, а наличие cookie сессии. Она проходит
		// в двух местах, и оба обязательны:
		//   * Cache Rule в Cloudflare обходит кэш при cookie `session_id` —
		//     иначе вошедший получал бы анонимную версию из кэша и владелец
		//     клиники не увидел бы баннера;
		//   * `server/plugins/private-cache.ts` меняет заголовок на
		//     `private, no-store`, если cookie есть — чтобы персональный ответ
		//     не попал в общий кэш даже при неверно настроенном правиле.
		'/': CACHED_STATIC,
		'/about': CACHED_STATIC,
		'/terms': CACHED_STATIC,
		'/privacy': CACHED_STATIC,
		'/articles/**': CACHED_STATIC,

		'/services/**': CACHED_CATALOG,
		'/labtests/**': CACHED_CATALOG,
		'/medicines/**': CACHED_CATALOG,
		'/insurance-companies/**': CACHED_CATALOG,
		'/doctors/**': CACHED_CATALOG,
		'/clinics/**': CACHED_CATALOG,
		// Отдельных `/doctors` и `/clinics` здесь больше нет: `/x/**` в radix3
		// покрывает и сам `/x`. Видно по соседям — у `/articles`, `/services`,
		// `/labtests`, `/medicines` и `/insurance-companies` голых записей
		// никогда не было, и все пятеро отдают `s-maxage` на проде. Пара
		// осталась с тех пор, когда карточки врачей и клиник из кэша
		// исключались и правила `/**` для них не существовало.
		// Кабинет и страницы авторизации: noindex заголовком, а не только метой.
		//
		// Страницы с ssr:false отдают пустую оболочку, и мета появляется в ней
		// только после выполнения JS — краулер может до неё не дождаться.
		// Заголовок виден сразу, ещё до разбора тела. Тот же приём, что на
		// /auth/telegram/return и /admin/**.
		//
		// Работает это только потому, что `Disallow` для них снят из robots.txt:
		// закрытую от обхода страницу краулер не скачивает и никакого noindex не
		// видит — см. docs/rules/ROBOTS_TXT.md.
		'/profile': { ssr: false, headers: NOINDEX },
		// Вкладки кабинета рендерятся на сервере — ssr тут не выключаем.
		'/profile/**': { headers: NOINDEX },
		'/login': { ssr: false, headers: NOINDEX },
		'/reset-password': { ssr: false, headers: NOINDEX },
		'/verify-email': { ssr: false, headers: NOINDEX },
		'/forgot-password': { ssr: false, headers: NOINDEX },
		'/confirm-email-change': { ssr: false, headers: NOINDEX },
		// данные Telegram приезжают в hash-фрагменте — читать их может только клиент.
		// Заголовком дублируем noindex: на ssr:false странице meta появляется
		// только после выполнения JS, а краулер его может не дождаться
		'/auth/telegram/return': {
			ssr: false,
			headers: NOINDEX,
		},
		// Заголовком, а не только meta: страница ssr:false, её meta появляется
		// после выполнения JS — тот же приём, что и на /auth/telegram/return.
		'/admin/**': {
			ssr: false,
			prerender: false,
			headers: NOINDEX,
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
