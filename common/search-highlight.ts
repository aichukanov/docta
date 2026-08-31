// Подсветка совпадения с поисковым запросом в готовой строке.
//
// Сравнение идёт по нормализованному тексту, иначе «musura» не подсветится
// в «Mušura», а «хлороп» — в «Хлоропирамин». Нормализовать строку целиком
// нельзя: NFD меняет длину, и границы совпадения перестают попадать в исходный
// текст. Поэтому нормализуем посимвольно и храним карту «символ результата →
// индекс в исходной строке».
//
// Правило нормализации на весь проект ровно одно — `normalizeForSearch`, и оно
// синхронизировано с поисковой коллацией БД (`server/common/search-collation.ts`).
// Своей копии здесь быть не должно: подсветка, складывающая больше сервера,
// красит совпадения, которых сервер не делал; складывающая меньше — молчит
// на найденном.
import { normalizeForSearch } from '~/common/utils';

export interface HighlightPart {
	text: string;
	match: boolean;
}

/**
 * Делит текст на куски: совпавшие с запросом и остальные. Пустой запрос или
 * отсутствие совпадения → один кусок со всем текстом (match: false).
 */
export function highlightParts(
	text: string | null | undefined,
	query: string | null | undefined,
): HighlightPart[] {
	const source = text || '';
	const needleRaw = (query || '').trim();
	if (!source || !needleRaw) {
		return source ? [{ text: source, match: false }] : [];
	}

	// Карта: для каждого символа нормализованного текста — индекс начала
	// соответствующего символа в исходной строке.
	let normalized = '';
	const sourceIndex: number[] = [];
	let position = 0;
	for (const char of source) {
		const normalizedChar = normalizeForSearch(char);
		for (let i = 0; i < normalizedChar.length; i++) {
			normalized += normalizedChar[i];
			sourceIndex.push(position);
		}
		position += char.length;
	}
	sourceIndex.push(source.length);

	const needle = [...needleRaw].map(normalizeForSearch).join('');
	if (!needle) {
		return [{ text: source, match: false }];
	}

	const parts: HighlightPart[] = [];
	let cursor = 0;
	let from = 0;
	for (;;) {
		const found = normalized.indexOf(needle, from);
		if (found === -1) break;
		const start = sourceIndex[found];
		const end = sourceIndex[found + needle.length];
		if (start > cursor) {
			parts.push({ text: source.slice(cursor, start), match: false });
		}
		parts.push({ text: source.slice(start, end), match: true });
		cursor = end;
		from = found + needle.length;
	}

	if (!parts.length) {
		return [{ text: source, match: false }];
	}
	if (cursor < source.length) {
		parts.push({ text: source.slice(cursor), match: false });
	}
	return parts;
}
