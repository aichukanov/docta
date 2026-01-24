import mysql from 'mysql2/promise';

let pool: mysql.Pool | null = null;

export async function getConnection() {
	try {
		const config = useRuntimeConfig();
		const { host, user, password } = config.public.connection;

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
