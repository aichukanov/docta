/**
 * Сухой прогон SQL-файла импорта: проверка без записи в БД.
 *
 * Превращает файл в «сухой» скрипт: DML по постоянным таблицам → EXPLAIN внутри
 * START TRANSACTION … ROLLBACK; по-настоящему выполняются только SET, SELECT,
 * CREATE/DROP TEMPORARY TABLE и INSERT во временные tmp_*. Ловит синтаксические
 * ошибки и несматченные slug (блоки «страховки» в файлах импорта), ничего не меняя.
 * Режим shadow: medical_services подменяется временной копией, чтобы новые записи
 * каталога «вставились» и последующие привязки по slug нашлись.
 *
 * Usage:
 *   node scripts/sql/dryrun-import.mjs <in.sql> <out.sql> [shadow]
 *   mysql -uroot -p --default-character-set=utf8mb4 docta_me < <out.sql>
 * Ошибок быть не должно; счётчики таблиц до и после — совпадать.
 */
import fs from 'node:fs';

const src = fs.readFileSync(process.argv[2], 'utf8');
const stmts = [];
let cur = '';
let inStr = false;
for (let i = 0; i < src.length; i++) {
	const ch = src[i];
	if (inStr) {
		cur += ch;
		if (ch === "'") {
			if (src[i + 1] === "'") { cur += "'"; i++; } else inStr = false;
		}
		continue;
	}
	if (ch === '-' && src[i + 1] === '-') {
		while (i < src.length && src[i] !== '\n') i++;
		cur += '\n';
		continue;
	}
	if (ch === "'") { inStr = true; cur += ch; continue; }
	if (ch === ';') { if (cur.trim()) stmts.push(cur.trim()); cur = ''; continue; }
	cur += ch;
}
if (cur.trim()) stmts.push(cur.trim());

const SHADOW = process.argv[4] === 'shadow';
const out = SHADOW ? ['START TRANSACTION;', 'CREATE TEMPORARY TABLE ms_src AS SELECT id, slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order FROM medical_services;', 'CREATE TEMPORARY TABLE medical_services (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL, name_en VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL, name_sr VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, name_sr_cyrl VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, name_ru VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, name_de VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, name_tr VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, sort_order INT, UNIQUE KEY (name_en), UNIQUE KEY (slug)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;', 'INSERT INTO medical_services (id, slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order) SELECT id, slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order FROM ms_src;', 'SELECT COUNT(*) AS shadow_rows FROM medical_services;'] : ['START TRANSACTION;'];
for (const s of stmts) {
	const head = s.slice(0, 80).toUpperCase().replace(/\s+/g, ' ');
	if (/^(SET|SELECT)\b/.test(head)) out.push(s + ';');
	else if (/^(CREATE|DROP) TEMPORARY TABLE/.test(head)) out.push(s + ';');
	else if (/^INSERT INTO TMP_/.test(head)) out.push(s + ';');
	else if (SHADOW && /UNION ALL/i.test(s)) out.push('-- skipped in shadow pass (UNION over temp table), checked in plain pass');
	else if (SHADOW && /^INSERT INTO MEDICAL_SERVICES [(]/.test(head)) out.push(s.replace('SELECT 1 FROM medical_services WHERE', 'SELECT 1 FROM ms_src WHERE') + ';'); // shadow temp table (NOT EXISTS по исходной копии — temp нельзя открыть дважды)
	else if (/^(INSERT|UPDATE|DELETE)\b/.test(head)) out.push('EXPLAIN ' + s + ';');
	else throw new Error('unexpected statement: ' + head);
}
out.push('ROLLBACK;');
fs.writeFileSync(process.argv[3], out.join('\n\n'), 'utf8');
console.log('statements', stmts.length);
