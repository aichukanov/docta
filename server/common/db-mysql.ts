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
		// Оборачиваем end(), чтобы он вызывал release() для пула
		const originalEnd = connection.end.bind(connection);
		(connection as any).end = async function () {
			connection.release();
		};
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
