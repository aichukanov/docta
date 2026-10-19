import { Marked } from 'marked';
import { escapeHtml } from './escape-html';

function isSafeUrl(href: string): boolean {
	// браузеры вырезают управляющие символы внутри схемы (`jav\tascript:`),
	// поэтому для проверки делаем то же самое
	const stripped = href.replace(/[\u0000- \u007f]/g, '').toLowerCase();
	if (!/^[a-z][a-z0-9+.-]*:/.test(stripped)) {
		return true; // относительная ссылка или якорь
	}
	return /^(https?|mailto|tel):/.test(stripped);
}

// Сюда попадает markdown, который пишут не-админы (кабинет клиники, профиль
// врача), а marked сам ничего не санитизирует: raw-HTML экранируем, ссылки и
// картинки пропускаем только с безопасной схемой
const safeMarked = new Marked({
	breaks: true,
	gfm: true,
	renderer: {
		html(token) {
			return escapeHtml(token.text);
		},
		link(token) {
			const text = this.parser.parseInline(token.tokens);
			if (!isSafeUrl(token.href)) {
				return text;
			}
			const title = token.title ? ` title="${escapeHtml(token.title)}"` : '';
			return `<a href="${escapeHtml(token.href)}"${title}>${text}</a>`;
		},
		image(token) {
			if (!isSafeUrl(token.href)) {
				return escapeHtml(token.text);
			}
			const title = token.title ? ` title="${escapeHtml(token.title)}"` : '';
			return `<img src="${escapeHtml(token.href)}" alt="${escapeHtml(token.text)}"${title}>`;
		},
	},
});

export function renderSafeMarkdown(content: string): string {
	return safeMarked.parse(content) as string;
}
