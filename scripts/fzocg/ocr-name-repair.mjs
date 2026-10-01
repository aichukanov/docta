/**
 * Ремонт OCR-строки прайса FZOCG до читаемого названия.
 *
 * Построчный OCR (PaddleOCR) читает код, имя и цену из одной строки таблицы и
 * поэтому не путает позиции — но пишет без диакритики, склеивает слова и
 * ошибается на букву: «Incizijaidrenaza furunkula,karbunkula», «Trazenie
 * simptoma fistule», «Kateterizaciia Eustahjieve tube». Имена в FINAL, наоборот,
 * чистые, но местами съехали на соседний код (см. find-shifted-tariff-names.mjs).
 *
 * Ремонт идёт по словарю из ЧИСТЫХ названий — тех, что не прошли через OCR:
 * LLM-имена FINAL и name_sr услуг и анализов. OCR-имена в словарь не берутся,
 * иначе он впитывает «illi», «Incizijai» и признаёт их словами.
 *   1) слово есть в словаре без учёта диакритики → берётся его написание;
 *   2) склейка словарного слова со служебным: «jedinicii» → «jedinici i»,
 *      «Incizijaidrenaza» → «Incizija i drenaža»;
 *   3) одна правка до однозначного словарного слова (включая перестановку
 *      двух соседних букв): «Kateterizaciia» → «Kateterizacija», «iili» → «ili»;
 *   4) не вышло — слово помечается нераспознанным, и строка уходит на ручную
 *      сверку: выдумывать название по догадке нельзя.
 * Регистр: первое слово — с заглавной, аббревиатуры (BO, MR) — как в OCR,
 * заглавная посреди строки сохраняется только если это не «Š/Ž/Č», прочитанная
 * OCR как «S/Z/C» (тогда это обычное слово: «Stitne» — это «štitne»).
 */

const fold = (s) => s.toLowerCase().normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/g, 'd');

/** Служебные слова, которые можно выделять при разрезании склеек. */
const GLUE = new Set(['i', 'u', 'sa', 'na', 'za', 'od', 'do', 'ili', 'bez', 'po', 'kod', 'iz', 's', 'uz']);

export function createRepairer(cleanNames) {
	const counts = new Map();
	for (const name of cleanNames.filter(Boolean)) {
		for (const w of name.match(/\p{L}+/gu) || []) {
			const f = fold(w);
			if (!counts.has(f)) counts.set(f, new Map());
			const m = counts.get(f);
			const low = w.toLowerCase();
			m.set(low, (m.get(low) || 0) + 1);
		}
	}
	const dict = new Map();
	for (const [f, m] of counts) dict.set(f, [...m].sort((a, b) => b[1] - a[1])[0][0]);
	for (const g of GLUE) if (!dict.has(g)) dict.set(g, g);
	const byLength = new Map();
	for (const f of dict.keys()) {
		if (!byLength.has(f.length)) byLength.set(f.length, []);
		byLength.get(f.length).push(f);
	}

	/** Расстояние Дамерау ≤ 1: замена, вставка, удаление или перестановка соседних букв. */
	const oneEdit = (a, b) => {
		if (a === b) return false;
		if (a.length === b.length) {
			const diff = [];
			for (let i = 0; i < a.length; i++) if (a[i] !== b[i]) diff.push(i);
			if (diff.length === 1) return true;
			return diff.length === 2 && diff[1] === diff[0] + 1 && a[diff[0]] === b[diff[1]] && a[diff[1]] === b[diff[0]];
		}
		const [s, l] = a.length < b.length ? [a, b] : [b, a];
		if (l.length - s.length !== 1) return false;
		for (let i = 0; i < l.length; i++) if (l.slice(0, i) + l.slice(i + 1) === s) return true;
		return false;
	};

	const longWord = (p) => p.length >= 4 && dict.has(p);
	function fixWord(f) {
		if (dict.has(f)) return [dict.get(f)];
		// склейка: хотя бы одна часть — полноценное слово, служебные — только из GLUE
		for (let a = 1; a < f.length; a++) {
			const l = f.slice(0, a);
			const r = f.slice(a);
			if ((longWord(l) && (longWord(r) || GLUE.has(r))) || (GLUE.has(l) && longWord(r))) return [dict.get(l), dict.get(r)];
		}
		if (f.length >= 3) {
			const cands = [f.length - 1, f.length, f.length + 1].flatMap((l) => byLength.get(l) || []).filter((d) => oneEdit(f, d));
			if (cands.length === 1) return [dict.get(cands[0])];
			// Неоднозначно, но ровно один кандидат — служебное слово: «iili», «lli» → «ili».
			const glue = cands.filter((c) => GLUE.has(c));
			if (glue.length === 1) return [glue[0]];
		}
		for (let a = 1; a < f.length - 1; a++) {
			for (let b = a + 1; b < f.length; b++) {
				const parts = [f.slice(0, a), f.slice(a, b), f.slice(b)];
				if (parts.filter(longWord).length >= 2 && parts.every((p) => longWord(p) || GLUE.has(p))) return parts.map((p) => dict.get(p));
			}
		}
		return null;
	}

	const DIACRITIC_START = /^[šžčćđ]/;
	/** @returns {{ name: string, unresolved: string[] }} */
	return function repair(ocr) {
		const unresolved = [];
		let first = true;
		const text = ocr
			.replace(/\s+/g, ' ')
			.replace(/\s*,\s*/g, ', ')
			// точка посреди перечисления — это запятая, прочитанная OCR: «funikulocele. spermatocele»
			.replace(/(\p{Ll})\.\s+(?=\p{Ll})/gu, '$1, ')
			.replace(/\s+-\s*|\s*-\s+/g, ' - ')
			.trim()
			.replace(/\p{L}+/gu, (w) => {
				const isFirst = first;
				first = false;
				if (w.length >= 2 && w === w.toUpperCase()) return w; // аббревиатура: BO, MR, CT
				const parts = fixWord(fold(w));
				if (!parts) {
					unresolved.push(w);
					return w;
				}
				let out = parts.join(' ');
				const keepCap = /^\p{Lu}/u.test(w) && (isFirst || !DIACRITIC_START.test(out));
				if (keepCap) out = out[0].toUpperCase() + out.slice(1);
				return out;
			});
		return { name: text, unresolved };
	};
}
