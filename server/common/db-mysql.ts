import mysql from 'mysql2/promise';

/**
 * MySQL Database Configuration
 *
 * Environment variables needed:
 * - DB_HOST: MySQL host (default: localhost)
 * - DB_USER: MySQL username (default: root)
 * - DB_PASSWORD: MySQL password (required)
 * - DB_DATABASE: Database name (default: docta_me)
 * - DB_PORT: MySQL port (default: 3306)
 *
 * Example .env file:
 * DB_HOST=localhost
 * DB_USER=root
 * DB_PASSWORD=your_password_here
 * DB_DATABASE=docta_me
 * DB_PORT=3306
 */

// Конфигурация базы данных
const dbConfig = {
	host: process.env.DB_HOST || 'localhost',
	user: process.env.DB_USER || 'root',
	password: process.env.DB_PASSWORD,
	database: process.env.DB_DATABASE || 'docta_me',
	port: parseInt(process.env.DB_PORT || '3306'),
	charset: 'utf8mb4',
	timezone: '+00:00',
};

// Подключение к базе данных
export async function getConnection() {
	try {
		const connection = await mysql.createConnection(dbConfig);
		return connection;
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
