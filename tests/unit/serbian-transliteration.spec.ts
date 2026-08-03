import { test, expect } from '@playwright/test';
import {
	toCyrillic,
	toLatin,
	hasCyrillic,
} from '../../common/serbian-transliteration';
import { generateSlug } from '../../common/slug-utils';

// Транслитерация кормит и локаль sr-cyrl, и генератор слагов. Два разных
// риска: в текстах — латинские аббревиатуры, которые кириллизовать нельзя
// (HbA1c → ХбА1ц), в слагах — вырожденный результат на нелатинских буквах.

test.describe('toCyrillic / toLatin', () => {
	test('диграфы обрабатываются раньше отдельных букв', () => {
		// Иначе «nj» превратилось бы в «нј», а не в «њ»
		expect(toCyrillic('Njegoš')).toBe('Његош');
		expect(toCyrillic('ljubav')).toBe('љубав');
		expect(toCyrillic('džep')).toBe('џеп');
		expect(toLatin('Његош')).toBe('Njegoš');
		expect(toLatin('љубав')).toBe('ljubav');
		expect(toLatin('џеп')).toBe('džep');
	});

	test('туда-обратно без потерь', () => {
		for (const word of [
			'Podgorica',
			'Đurđevića Tara',
			'Šavnik',
			'Herceg Novi',
			'Ljekar',
			'Džemat',
		]) {
			expect(toLatin(toCyrillic(word)), word).toBe(word);
		}
	});

	test('placeholder i18n не транслитерируется', () => {
		expect(toCyrillic('Ljekari u {city}')).toBe('Љекари у {city}');
		expect(toCyrillic('{count} klinika')).toBe('{count} клиника');
	});

	test('пустая строка проходит насквозь', () => {
		expect(toCyrillic('')).toBe('');
		expect(toLatin('')).toBe('');
	});

	// Известный подводный камень: аббревиатуры анализов и брендов набраны
	// латиницей, но не являются сербским текстом. Автоматический прогон
	// sr → sr-cyrl их ломает, поэтому такие строки нужно защищать вручную
	// на стороне вызывающего кода — сама функция символ от символа не
	// отличает. Тест фиксирует, что поведение именно такое, а не «само
	// как-нибудь разберётся».
	test('латинские аббревиатуры функция НЕ защищает — это работа вызывающего', () => {
		expect(toCyrillic('HbA1c')).not.toBe('HbA1c');
		expect(toCyrillic('PSA')).not.toBe('PSA');
	});
});

test.describe('hasCyrillic', () => {
	test('различает алфавиты', () => {
		expect(hasCyrillic('Његош')).toBe(true);
		expect(hasCyrillic('Njegoš')).toBe(false);
		expect(hasCyrillic('CRP')).toBe(false);
	});
});

test.describe('generateSlug', () => {
	test('кириллица уходит в сербскую латиницу без диакритики', () => {
		expect(generateSlug('Дом здравља Херцег Нови')).toBe(
			'dom-zdravlja-herceg-novi',
		);
		expect(generateSlug('Ђурђевића Тара')).toBe('djurdjevica-tara');
	});

	test('диакритика раскладывается в ASCII', () => {
		expect(generateSlug('Šavnik')).toBe('savnik');
		expect(generateSlug('Đorđe Čović')).toBe('djordje-covic');
	});

	test('пунктуация и повторные пробелы схлопываются', () => {
		expect(generateSlug('Dr Filimanović — stomatološka ordinacija')).toBe(
			'dr-filimanovic-stomatoloska-ordinacija',
		);
		expect(generateSlug('  Klinika   „Moj Lekar“  ')).toBe('klinika-moj-lekar');
	});

	test('слаг не начинается и не заканчивается дефисом', () => {
		for (const name of ['— Klinika —', '...Test...', '  A  ']) {
			const slug = generateSlug(name);
			expect(slug, name).not.toMatch(/^-|-$/);
		}
	});

	test('буквы вне сербского алфавита отсеиваются', () => {
		// Русские ё/ю/я не мапятся; от вырожденного слага страхует
		// ensureUniqueSlug на стороне импорта — здесь фиксируем сам факт
		expect(generateSlug('Юрий')).not.toContain('ю');
		expect(generateSlug('Юрий')).toMatch(/^[a-z0-9-]*$/);
	});
});
