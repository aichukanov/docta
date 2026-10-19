import { test, expect } from '@playwright/test';
import { renderSafeMarkdown } from '../../common/safe-markdown';

// Описания клиник и врачей пишут не-админы (кабинет клиники, профиль врача),
// а клинику любой аккаунт может создать и опубликовать сам — то есть markdown
// в `marked-content.vue` недоверенный, и рендерится он через v-html на
// публичных страницах. marked сам ничего не санитизирует: raw-HTML проходит
// как есть, а ссылки пропускают любую схему. Каждый кейс ниже — реально
// исполняемый stored XSS до фикса, а не «плохая строка вообще».

test.describe('renderSafeMarkdown — XSS', () => {
	test('экранирует raw-HTML, блочный и внутри абзаца', () => {
		for (const payload of [
			'<img src=x onerror=alert(1)>',
			'<script>alert(1)</script>',
			'<iframe src="https://evil.example"></iframe>',
			'текст <b onmouseover=alert(1)>жирный</b> дальше',
		]) {
			const html = renderSafeMarkdown(payload);
			expect(html, payload).not.toMatch(/<(img|script|iframe|b)[\s>]/);
		}
	});

	test('ссылку с опасной схемой превращает в текст без <a>', () => {
		for (const payload of [
			'[click](javascript:alert(1))',
			'[click](JAVASCRIPT:alert(1))',
			// браузеры игнорируют управляющие символы внутри схемы
			'[click](jav\u0001ascript:alert(1))',
			'[click](data:text/html,<script>alert(1)</script>)',
			'[click](vbscript:msgbox)',
			'![x](javascript:alert(1))',
		]) {
			// схема с управляющим символом ломает разметку ссылки ещё в marked,
			// и текст с «script:» остаётся экранированным текстом — это безвредно;
			// инвариант в том, что <a>/<img> из таких пейлоадов не рождается
			const html = renderSafeMarkdown(payload);
			expect(html, payload).not.toContain('<a');
			expect(html, payload).not.toContain('<img');
		}
	});

	test('экранирует & в href — против обхода через javascript&colon;', () => {
		const html = renderSafeMarkdown('[click](javascript&colon;alert(1))');
		// браузер декодирует сущности в атрибутах, поэтому сырой `&` в href
		// дал бы рабочий javascript: после декодирования
		expect(html).not.toContain('href="javascript&colon;');
	});

	test('экранирует кавычки в title — против выхода из атрибута', () => {
		const html = renderSafeMarkdown('[a](https://e.com "x\\" onclick=\\"alert(1)")');
		expect(html).not.toContain('onclick="');
	});

	test('обычный markdown описаний не ломает', () => {
		expect(
			renderSafeMarkdown('**Уролошка ординација**\n\n- преглед\n- ултразвук'),
		).toContain('<strong>Уролошка ординација</strong>');
		expect(renderSafeMarkdown('## О нама')).toContain('<h2>О нама</h2>');
		expect(renderSafeMarkdown('[сајт](https://example.me "наш сајт")')).toBe(
			'<p><a href="https://example.me" title="наш сајт">сајт</a></p>\n',
		);
		expect(renderSafeMarkdown('[услуге](/services)')).toContain(
			'href="/services"',
		);
		expect(renderSafeMarkdown('[пошта](mailto:info@example.me)')).toContain(
			'href="mailto:info@example.me"',
		);
		// gfm-автоссылки и breaks, как было у marked-content.vue до фикса
		expect(renderSafeMarkdown('www.example.me')).toContain(
			'href="http://www.example.me"',
		);
		expect(renderSafeMarkdown('линија један\nлинија два')).toContain('<br>');
	});
});
