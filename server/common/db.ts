import sqlite3 from 'sqlite3';

const dbPath = '../db/svad.db';
const connection = new sqlite3.Database(
	dbPath,
	sqlite3.OPEN_READONLY,
	(err) => {
		if (err) {
			console.log('Error with connection to the database', err);
		}
	},
);

connection.run(`PRAGMA temp_store = memory;`);

export function runSelect<T = any>(
	query: string,
	params: Record<string, any> = {},
): Promise<Array<T>> {
	return new Promise((resolve, reject) => {
		connection.all(query, params, (err, rows) => {
			if (err) {
				console.log('failed query:', query, 'params', params);
				reject(err);
			} else {
				resolve(rows);
			}
		});
	});
}
