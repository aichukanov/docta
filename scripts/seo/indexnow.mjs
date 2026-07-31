// Отправка URL в IndexNow — протокол мгновенного уведомления об изменениях.
// Участники: Яндекс, Bing, Seznam, Naver. Google в IndexNow НЕ участвует.
//
// Зачем: после итераций 1–3 prd/silent-200-index-hygiene в индексе Яндекса
// осталось 602 числовых URL, которые теперь отдают 301 на слаг. Яндекс не
// обходил их с 01.06.2026, то есть сам он узнает об этом через месяцы.
// IndexNow — способ продавить переобход адресно.
//
// Запускать ИЗ КОРНЯ репозитория (пути относительные, как у остальных скриптов):
//   node scripts/seo/indexnow.mjs data/yandex/numeric-urls-2026-07-28.txt
//   node scripts/seo/indexnow.mjs <файл> --send
//
// Без --send только печатает, что будет отправлено, и ничего не делает.
//
// Ключ ищется автоматически среди public/*.txt по правилу IndexNow
// (содержимое файла == имя файла без .txt). Если подходящих несколько —
// скрипт остановится и попросит указать --key=<ключ>.

import { readFileSync, readdirSync } from 'node:fs';
import { join, basename } from 'node:path';

const HOST = 'docta.me';
const ORIGIN = `https://${HOST}`;
const ENDPOINT = 'https://api.indexnow.org/indexnow';
const MAX_URLS_PER_REQUEST = 10000; // лимит протокола

const args = process.argv.slice(2);
const listPath = args.find((a) => !a.startsWith('--'));
const send = args.includes('--send');
const keyArg = args.find((a) => a.startsWith('--key='))?.slice('--key='.length);

// Через throw, а не process.exit(): при живых сокетах fetch мгновенный выход
// роняет libuv с «Assertion failed: !(handle->flags & UV_HANDLE_CLOSING)»,
// и настоящее сообщение об ошибке теряется в этом шуме.
class Abort extends Error {}
function fail(message) {
	throw new Abort(message);
}

function findKey() {
	if (keyArg) return keyArg;

	const candidates = readdirSync('public')
		.filter((f) => f.endsWith('.txt'))
		.filter((f) => {
			const stem = basename(f, '.txt');
			try {
				return readFileSync(join('public', f), 'utf-8').trim() === stem;
			} catch {
				return false;
			}
		})
		.map((f) => basename(f, '.txt'));

	if (candidates.length === 0) {
		fail(
			'в public/ нет ни одного ключ-файла IndexNow (файл <key>.txt с содержимым <key>)',
		);
	}
	if (candidates.length > 1) {
		fail(
			`в public/ несколько ключ-файлов, укажи нужный явно через --key=<ключ>:\n  ${candidates.join('\n  ')}`,
		);
	}
	return candidates[0];
}

async function main() {
	if (!listPath) {
		fail(
			'не передан файл со списком URL.\n  node scripts/seo/indexnow.mjs data/yandex/numeric-urls-2026-07-28.txt [--send]',
		);
	}

	const urls = readFileSync(listPath, 'utf-8')
		.split(/\r?\n/)
		.map((l) => l.trim())
		.filter(Boolean);

	if (urls.length === 0) fail(`в ${listPath} нет ни одного URL`);

	// IndexNow отвечает 422, если хоть один URL не принадлежит host — проверяем сами,
	// чтобы не гадать по коду ответа.
	const foreign = urls.filter((u) => !u.startsWith(`${ORIGIN}/`));
	if (foreign.length > 0) {
		fail(
			`${foreign.length} URL не принадлежат ${HOST}, например:\n  ${foreign.slice(0, 3).join('\n  ')}`,
		);
	}

	if (urls.length > MAX_URLS_PER_REQUEST) {
		fail(
			`${urls.length} URL — больше лимита ${MAX_URLS_PER_REQUEST} на один запрос. Разбей файл на части.`,
		);
	}

	const key = findKey();
	const keyLocation = `${ORIGIN}/${key}.txt`;

	console.log(`host:        ${HOST}`);
	console.log(`key:         ${key}`);
	console.log(`keyLocation: ${keyLocation}`);
	console.log(`список:      ${listPath}`);
	console.log(`URL:         ${urls.length}`);
	console.log(`первые 3:    ${urls.slice(0, 3).join(', ')}`);

	// Ключ обязан быть доступен по HTTPS до отправки — IndexNow проверяет владение
	// доменом, скачивая keyLocation. Проверяем заранее: иначе получим 403 и будем
	// думать, что дело в самом ключе.
	const keyCheck = await fetch(keyLocation).catch((e) => ({
		ok: false,
		status: `сеть: ${e.message}`,
	}));
	if (!keyCheck.ok) {
		fail(
			`ключ-файл недоступен по ${keyLocation} (${keyCheck.status}). Ключ должен быть ВЫКАЧЕН НА ПРОД до отправки.`,
		);
	}
	const keyBody = (await keyCheck.text()).trim();
	if (keyBody !== key) {
		fail(
			`${keyLocation} отдаёт "${keyBody}", а ожидается "${key}" — на проде другой (старый) билд`,
		);
	}
	console.log('ключ-файл на проде: OK');

	if (!send) {
		console.log('\nЭто прогон без отправки. Добавь --send, чтобы отправить.');
		return;
	}

	const response = await fetch(ENDPOINT, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json; charset=utf-8' },
		body: JSON.stringify({ host: HOST, key, keyLocation, urlList: urls }),
	});

	const text = await response.text();
	console.log(`\nответ: ${response.status} ${response.statusText}`);
	if (text) console.log(text);

	// 200 — принято, 202 — принято, ключ ещё проверяется.
	if (response.status !== 200 && response.status !== 202) {
		fail(
			'IndexNow не принял запрос. 403 — ключ не прошёл проверку, 422 — URL не с этого хоста, 429 — слишком часто.',
		);
	}
	console.log('Готово.');
}

try {
	await main();
} catch (error) {
	if (error instanceof Abort) {
		console.error(`ОШИБКА: ${error.message}`);
		process.exitCode = 1;
	} else {
		throw error;
	}
}
