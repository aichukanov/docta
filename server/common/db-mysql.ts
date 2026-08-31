import mysql from 'mysql2/promise';

let pool: mysql.Pool | null = null;

export async function getConnection() {
	try {
		const config = useRuntimeConfig();
		const { dbHost: host, dbUser: user, dbPassword: password } = config;

		if (!pool) {
			pool = mysql.createPool({
				host,
				user,
				password,
				database: 'docta_me',
				port: 3306,
				waitForConnections: true,
				connectionLimit: 10,
				queueLimit: 0,
				charset: 'utf8mb4',
				timezone: '+00:00',
				// mysql2 держит LRU подготовленных выражений НА КАЖДОЕ соединение
				// (дефолт 16000). Наши списки/детали генерируют массу уникальных SQL
				// (динамический WHERE, разное число плейсхолдеров в IN, а главное —
				// инлайновый LIMIT/OFFSET: каждая страница = новый statement). При
				// connectionLimit:10 дефолт даёт до 160k выражений против серверного
				// max_prepared_stmt_count=16382 → сервер начинает отвечать «Can't
				// create more than max_prepared_stmt_count statements», и падают ВСЕ
				// запросы (детали лекарства, поиск), пока MySQL не перезапустят.
				// Ограничиваем кэш: 10 × 200 = 2000 « 16382, с запасом на прочие
				// соединения; LRU закрывает старые выражения при вытеснении.
				maxPreparedStatements: 200,
			});
			// Дефолт GROUP_CONCAT — 1024 байта: clinicIds/clinicPricesData у
			// популярных услуг молча усекались бы (битые id, потерянные цены,
			// см. prd/maps §3.1). Выставляется раз на физическое соединение.
			pool.on('connection', (connection: any) => {
				connection.query('SET SESSION group_concat_max_len = 1048576');
			});
		}

		const connection = await pool.getConnection();

		// Оборачиваем end(), чтобы он вызывал release() для пула.
		//
		// release() идемпотентен: часть хендлеров зовёт end() на нескольких
		// ветках выхода (в некоторых файлах один захват и до четырёх end()),
		// а ниже к тому же добавляется автоматическое освобождение.
		let released = false;
		let inTransaction = false;
		let releaseRequested = false;
		// Снятие страховочного слушателя, см. ниже.
		let detachSafetyNet: (() => void) | null = null;

		const release = () => {
			if (released) {
				return;
			}

			// Внутри транзакции соединение отпускать нельзя: release() её не
			// откатывает, и следующий, кто возьмёт это соединение из пула,
			// унаследует незакрытую транзакцию. Транзакции есть в биллинге и
			// во всех write-эндпоинтах, так что цена ошибки здесь выше, чем
			// у самой утечки. Откладываем до commit/rollback.
			if (inTransaction) {
				releaseRequested = true;
				return;
			}

			released = true;
			detachSafetyNet?.();
			connection.release();
		};

		(connection as any).end = async function () {
			release();
		};

		// Отслеживаем границы транзакции, чтобы release() знал, можно ли сейчас.
		const trackTransaction = (
			method: 'beginTransaction' | 'commit' | 'rollback',
			open: boolean,
		) => {
			const original = (connection as any)[method].bind(connection);

			(connection as any)[method] = async function (...args: any[]) {
				const result = await original(...args);
				inTransaction = open;

				if (!open && releaseRequested) {
					release();
				}

				return result;
			};
		};

		trackTransaction('beginTransaction', true);
		trackTransaction('commit', false);
		trackTransaction('rollback', false);

		// Страховка на случай исключения между захватом и end().
		//
		// Подавляющее большинство мест держит соединение по схеме
		// «взять → поработать → end()» без try/finally, поэтому любой бросок
		// посередине навсегда сжигал слот пула. При connectionLimit: 10 и
		// queueLimit: 0 десять таких ошибок подвешивали сайт до рестарта pm2 —
		// это уже случалось.
		//
		// Вместо правки сотни точек захвата отпускаем соединение, когда ответ
		// закрыт. При нормальном завершении хендлер к этому моменту уже
		// доработал; при обрыве со стороны клиента — не обязательно, поэтому
		// выше стоит защита транзакций, а незавершённые обычные запросы
		// mysql2 всё равно ставит в очередь команд соединения.
		//
		// Требует nitro.experimental.asyncContext (включён в nuxt.config.ts).
		// Вне запроса — плагин пересчёта рейтингов на старте, скрипты —
		// контекста нет, там остаётся явный end().
		//
		// Слушатель обязательно снимается при штатном release: один запрос может
		// брать соединения десятками подряд (сборка sitemap — около двадцати), и
		// без снятия они копились бы на одном ответе, а Node на одиннадцатом
		// начал бы писать MaxListenersExceededWarning.
		try {
			const res = useEvent()?.node.res;

			if (res) {
				res.once('close', release);
				detachSafetyNet = () => res.off('close', release);
			}
		} catch {
			// нет запроса в контексте — штатная ситуация, не ошибка
		}

		return connection;
	} catch (error) {
		console.error('Database connection error:', error);
		throw error;
	}
}

export async function executeQuery<T = any>(
	query: string,
	params: any[] = [],
): Promise<T[]> {
	const connection = await getConnection();
	try {
		const [rows] = await connection.execute(query, params);
		return rows as T[];
	} catch (error) {
		console.error('Query execution error:', error, { query, params });
		throw error;
	} finally {
		await connection.end();
	}
}
