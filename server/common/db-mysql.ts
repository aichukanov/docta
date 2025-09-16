import mysql from 'mysql2/promise';

// Подключение к базе данных
export async function getConnection() {
	try {
		return await mysql.createConnection({
			host: process.env.DB_HOST,
			user: process.env.DB_USER,
			password: process.env.DB_PASSWORD,
			database: process.env.DB_NAME,
			port: +process.env.DB_PORT,
			charset: 'utf8mb4',
			timezone: '+00:00',
		});
	} catch (error) {
		console.error('Database connection error:', error);
		throw error;
	}
}

// Хелпер для выполнения запросов с автоматическим закрытием соединения
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
