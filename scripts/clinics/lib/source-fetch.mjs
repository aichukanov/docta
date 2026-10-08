/**
 * Общее для журналов по сайтам клиник (check-pricelists, check-doctor-teams):
 * загрузка URL через curl, видимый текст HTML, стабильный JSON, текст PDF.
 *
 * curl, а не fetch: часть сайтов (Loopia, Cloudflare) отдаёт заглушку без
 * браузерного User-Agent, у одного битый TLS (`-k`), и так же сделаны ручные проверки.
 */

import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { existsSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { promisify } from 'node:util';

const run = promisify(execFile);

export const UA =
	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0 Safari/537.36';

// битый TLS-сертификат (recheckHint в картах)
const INSECURE_HOSTS = new Set(['drkukoljac.com']);

export const sha = (buf) => createHash('sha256').update(buf).digest('hex');
export const today = () => new Date().toISOString().slice(0, 10);

const tmpName = (ext = '') => join(tmpdir(), `src-${process.pid}-${Math.random().toString(36).slice(2)}${ext}`);

/** Пробелы и кавычки в запросах API экранируются; уже экранированное не трогается. */
function safeUrl(url) {
	try {
		return encodeURI(decodeURI(url));
	} catch {
		return url;
	}
}

export async function fetchUrl(url) {
	const tmp = tmpName();
	const host = new URL(url).hostname.replace(/^www\./, '');
	const args = [
		'-sL',
		'-g', // [] и {} в URL (GROQ-запросы Sanity) — не шаблон curl
		'--max-time',
		'90',
		'-A',
		UA,
		'-H',
		'Accept: text/html,application/xhtml+xml,application/json,application/pdf,*/*;q=0.8',
		'-H',
		'Accept-Language: sr,en;q=0.8',
		'-D',
		'-',
		'-o',
		tmp,
		'-w',
		'\n@@%{http_code}|%{content_type}|%{url_effective}',
	];
	if (INSECURE_HOSTS.has(host)) args.push('-k');
	args.push(safeUrl(url));
	try {
		const { stdout } = await run('curl', args, { maxBuffer: 50e6 });
		const [headers, tail] = stdout.split('\n@@');
		const [code, contentType, finalUrl] = tail.trim().split('|');
		// при редиректах заголовков несколько блоков — нужен последний
		const lastModified = [...headers.matchAll(/^last-modified:\s*(.+)$/gim)].pop()?.[1]?.trim() ?? null;
		const body = existsSync(tmp) ? readFileSync(tmp) : Buffer.alloc(0);
		return { status: Number(code), contentType, finalUrl, lastModified, body };
	} catch (e) {
		return { error: String(e.stderr || e.message).trim().slice(0, 200) || `curl exit ${e.code}` };
	} finally {
		if (existsSync(tmp)) rmSync(tmp);
	}
}

export function visibleText(html) {
	return html
		.replace(/<!--[\s\S]*?-->/g, ' ')
		.replace(/<(script|style|svg|noscript|template)\b[\s\S]*?<\/\1>/gi, ' ')
		.replace(/<br\s*\/?>|<\/(p|div|li|tr|td|th|h\d)>/gi, '\n')
		.replace(/<[^>]+>/g, ' ')
		.replace(/&nbsp;|&#160;/g, ' ')
		.replace(/&euro;|&#8364;/g, '€')
		.replace(/&amp;/g, '&')
		.replace(/&#8211;|&ndash;/g, '–')
		.replace(/[ \t]+/g, ' ')
		.replace(/\s*\n\s*/g, '\n')
		.trim();
}

export function stableJson(value) {
	if (Array.isArray(value)) return `[${value.map(stableJson).join(',')}]`;
	if (value && typeof value === 'object')
		return `{${Object.keys(value)
			.sort()
			.map((k) => `${JSON.stringify(k)}:${stableJson(value[k])}`)
			.join(',')}}`;
	return JSON.stringify(value);
}

export const isJsonResponse = (res, url) =>
	/json/i.test(res.contentType || '') || /\/wp-json\/|\/api\/|apicdn\.sanity/.test(url);
export const isTextResponse = (res, url) =>
	isJsonResponse(res, url) || /html|text|xml|javascript/i.test(res.contentType || '');
export const isPdfResponse = (res, url) => /pdf/i.test(res.contentType || '') || /\.pdf(?:[?#]|$)/i.test(url);

// Текст PDF через PyMuPDF: pdftotext теряет ć/č/đ. PyMuPDF стоит не у всех Python
// (у юзера — у python 3.14, у py -3.12 нет), поэтому пробуем по очереди.
// Ни у одного нет fitz — null, у источника остаётся только отпечаток байтов.
const PY_CANDIDATES = [
	['python', []],
	['py', ['-3.12']],
];
const PY_SCRIPT =
	'import sys,fitz;d=fitz.open(sys.argv[1]);sys.stdout.reconfigure(encoding="utf-8");print("\\n".join(p.get_text() for p in d))';
let pyWorking; // undefined — не проверяли, null — рабочего нет, иначе [cmd, args]

export async function pdfText(buf) {
	if (pyWorking === null) return null;
	const file = tmpName('.pdf');
	writeFileSync(file, buf);
	try {
		for (const cand of pyWorking ? [pyWorking] : PY_CANDIDATES) {
			try {
				const { stdout } = await run(cand[0], [...cand[1], '-c', PY_SCRIPT, file], { maxBuffer: 50e6 });
				pyWorking = cand;
				return stdout;
			} catch {
				if (pyWorking) return null; // рабочий Python есть — сломан конкретный файл
			}
		}
		pyWorking = null;
		return null;
	} finally {
		rmSync(file, { force: true });
	}
}
