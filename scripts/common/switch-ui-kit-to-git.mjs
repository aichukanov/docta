/**
 * Переводит оба проекта с локального пути `file:../../ui-kit` на
 * git-зависимость от приватного репозитория пакета дизайн-системы.
 *
 *     node scripts/common/switch-ui-kit-to-git.mjs
 *
 * Запускать ОДИН раз, после того как приватный репозиторий
 * https://github.com/aichukanov/ui-kit создан на GitHub. До этого момента
 * переключать нельзя: npm не разрешит зависимость и оба проекта перестанут
 * собираться.
 *
 * Зачем: `file:` — путь наружу репозитория, на сервере его не существует,
 * поэтому `npm ci` при деплое падает. Обоснование, процедура деплоя и цикл
 * локальной разработки — docs/rules/DESIGN_SYSTEM_PACKAGE.md.
 */

import { spawnSync } from 'node:child_process';
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Путь считается от самого файла, а не от cwd: скрипт лежит в scripts/common/,
// и запускать его будут из корня проекта, но полагаться на это не стоит.
const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');

const KIT_DIR = resolve(ROOT, '..', '..', 'ui-kit');
const KIT_URL = 'https://github.com/aichukanov/ui-kit.git';
const KIT_DEP = `git+${KIT_URL}#main`;

const APPS = [ROOT, resolve(ROOT, '..', '..', 'svad', 'site')];

/** Запускает команду, наследуя вывод. Возвращает код возврата. */
function run(cmd, args, cwd) {
	// shell: true — иначе на Windows не найдётся npm (это .cmd, а не .exe)
	const res = spawnSync(cmd, args, {
		cwd,
		stdio: 'inherit',
		shell: true,
		// Не даём git открыть диалог ввода пароля и подвесить скрипт
		env: { ...process.env, GIT_TERMINAL_PROMPT: '0' },
	});
	return res.status;
}

function runQuiet(cmd, args, cwd) {
	const res = spawnSync(cmd, args, {
		cwd,
		encoding: 'utf-8',
		shell: true,
		env: { ...process.env, GIT_TERMINAL_PROMPT: '0' },
	});
	return { status: res.status, stdout: res.stdout || '', stderr: res.stderr || '' };
}

function fail(message) {
	console.error(`\nОШИБКА: ${message}`);
	process.exit(1);
}

// ---------------------------------------------------------------------------

console.log('==> Проверяю, что репозиторий пакета создан и доступен');
if (!existsSync(KIT_DIR)) {
	fail(`не нашёл рабочую копию пакета: ${KIT_DIR}`);
}
if (runQuiet('git', ['ls-remote', KIT_URL], KIT_DIR).status !== 0) {
	fail(
		`${KIT_URL} недоступен.\n` +
			'Создайте приватный репозиторий ui-kit на GitHub и запустите скрипт снова.',
	);
}

console.log('==> Отправляю пакет в origin');
if (run('git', ['push', '-u', 'origin', 'main'], KIT_DIR) !== 0) {
	fail('не смог отправить пакет в origin');
}

for (const app of APPS) {
	console.log(`\n==> ${app}`);
	const pkgPath = resolve(app, 'package.json');
	if (!existsSync(pkgPath)) fail(`не нашёл ${pkgPath}`);

	// Правим ровно строку зависимости регэкспом, а не через JSON.parse:
	// пересериализация сломала бы форматирование (в docta отступы табами,
	// в svad пробелами) и раздула бы диф на весь файл.
	const src = readFileSync(pkgPath, 'utf-8');
	const re = /("@ach\/ui-kit":\s*")[^"]*(")/;
	if (!re.test(src)) fail(`в ${pkgPath} нет зависимости @ach/ui-kit`);

	const next = src.replace(re, `$1${KIT_DEP}$2`);
	if (next === src) {
		console.log('    зависимость уже переключена, package.json не меняю');
	} else {
		writeFileSync(pkgPath, next);
		console.log(`    package.json: ${KIT_DEP}`);
	}

	if (run('npm', ['install'], app) !== 0) fail(`npm install упал в ${app}`);
	if (run('npm', ['run', 'typecheck'], app) !== 0) {
		fail(`typecheck упал в ${app}`);
	}
}

console.log('\n==> Проверяю, что в локах записан коммит, а не путь');
for (const app of APPS) {
	const lock = readFileSync(resolve(app, 'package-lock.json'), 'utf-8');
	const m = lock.match(/"resolved":\s*"(git\+[^"]*ui-kit[^"]*)"/);
	console.log(`    ${app}\n      ${m ? m[1] : 'НЕ НАЙДЕНО — проверьте вручную'}`);
}

console.log(
	[
		'',
		'Готово. Дальше:',
		'  1. Закоммитить package.json и package-lock.json в обоих проектах.',
		'  2. При первом деплое убедиться, что сервер имеет доступ к приватному',
		'     репозиторию пакета — см. docs/rules/DESIGN_SYSTEM_PACKAGE.md.',
	].join('\n'),
);
