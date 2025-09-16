import mysql from 'mysql2/promise';

export async function getConnection() {
	try {
		const config = useRuntimeConfig();
		const { host, user, password } = config.public.connection;

		return await mysql.createConnection({
			host,
			user,
			password,
			database: 'docta_me',
			port: 3306,
			charset: 'utf8mb4',
			timezone: '+00:00',
		});
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
