/**
 * Проверка ошибок транслитерации сербских имён врачей на кириллицу.
 * Сравнивает name_sr (латиница) → ожидаемая кириллица с name_sr_cyrl (фактическая).
 *
 * Usage: node check-cyrillic-names.mjs
 *        node check-cyrillic-names.mjs --fix   (обновит name_sr_cyrl в БД)
 */

import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import { toCyrillic } from './common/serbian-transliteration.ts';

dotenv.config();

async function main() {
	const fix = process.argv.includes('--fix');

	const connection = await mysql.createConnection({
		host: process.env.DB_HOST || '127.0.0.1',
		user: process.env.DB_USER || 'root',
		password: process.env.DB_PASSWORD || '',
		database: process.env.DB_NAME || 'docta_me',
		port: Number(process.env.DB_PORT) || 3306,
		charset: 'utf8mb4',
	});

	const [rows] = await connection.execute(
		`SELECT id, name_sr, name_sr_cyrl FROM doctors WHERE hidden = 0 AND name_sr IS NOT NULL AND name_sr_cyrl IS NOT NULL`
	);

	const errors = [];

	for (const row of rows) {
		const expected = toCyrillic(row.name_sr);
		if (expected !== row.name_sr_cyrl) {
			errors.push({
				id: row.id,
				name_sr: row.name_sr,
				actual: row.name_sr_cyrl,
				expected,
			});
		}
	}

	if (errors.length === 0) {
		console.log('Ошибок не найдено!');
	} else {
		console.log(`Найдено ${errors.length} ошибок:\n`);
		for (const e of errors) {
			console.log(`  #${e.id} ${e.name_sr}`);
			console.log(`    факт:  ${e.actual}`);
			console.log(`    верно: ${e.expected}`);
			console.log();
		}

		if (fix) {
			console.log('Исправляем...');
			for (const e of errors) {
				await connection.execute(
					`UPDATE doctors SET name_sr_cyrl = ? WHERE id = ?`,
					[e.expected, e.id]
				);
			}
			console.log(`Исправлено ${errors.length} записей.`);
		} else {
			console.log('Для исправления запустите: node check-cyrillic-names.mjs --fix');
		}
	}

	await connection.end();
}

main().catch(err => {
	console.error('Ошибка:', err);
	process.exit(1);
});
