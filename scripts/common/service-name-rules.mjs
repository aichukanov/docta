/**
 * Общие правила названий услуг: что считать дефектом в name_sr / name_ru.
 *
 * Один модуль на сканер (scan-name-quality.mjs), валидатор батчей
 * (validate-name-batches.mjs) и сборщик SQL (build-service-names-sql.mjs):
 * если словари разъедутся, валидатор пропустит то, что сканер потом опять
 * найдёт, или наоборот. Разбор — docs/audit/service-names-2026-09.md.
 */

/**
 * Экавские формы, у которых в иекавице другой корень (ср. validate-reference-batches.mjs).
 *
 * Только формы, где ять реально расходится. Сюда НЕ входят и не должны входить:
 * «vremena» (иекавица «vrijeme», но родительный — тоже «vremena») и «slezine»
 * (селезёнка одинакова в обоих наречиях) — они дают ложные срабатывания.
 * Медицинская лексика вынесена отдельно: crevo, mehur, ždrelo, zenica, veđa,
 * nega, poseta, izbeljivanje, nameštanje — в прайсах они встречаются чаще,
 * чем бытовые dete/mleko, и первыми выдают экавский прайс.
 */
export const EKAVICA = new Set([
	'lek', 'leka', 'lekovi', 'lekova', 'lekove', 'lekom', 'lekar', 'lekara', 'lekari',
	'lekarski', 'lekarsko', 'lekarske', 'lekarska', 'lekarskog', 'lekarskom',
	'beli', 'bela', 'belo', 'bele', 'belog', 'mleko', 'mleka', 'mlecni', 'mlečni', 'mlečnih',
	'vreme', 'dete', 'deteta', 'deca', 'decu', 'deci', 'decom',
	'decji', 'decja', 'decje', 'decjeg', 'decjih', 'dečji', 'dečja', 'dečje', 'dečjeg', 'dečjih', 'dečjem',
	'mesto', 'mesta', 'mestu', 'nedelja', 'nedelje', 'nedeljno', 'ceo', 'celo', 'cela', 'celog', 'celo',
	'mesec', 'meseca', 'meseci', 'mesečno', 'mesečni',
	'deo', 'dela', 'delu', 'delova', 'delimična', 'delimični', 'delimično', 'delovanje',
	'lecenje', 'lecenja', 'lečenje', 'lečenja', 'lečenjem',
	'sprecavanje', 'sprečavanje', 'predeo', 'predela', 'predelu',
	'levi', 'leva', 'levo', 'leve', 'levog', 'levom', 'levoj',
	'koleno', 'kolena', 'kolenu', 'kolenom', 'kolenog',
	'zlezda', 'zlezde', 'zlezdu', 'žlezda', 'žlezde', 'žlezdu', 'žlezdi', 'žlezda',
	'telo', 'tela', 'telu', 'telesna', 'telesne', 'telesni', 'telesnog', 'telesnih',
	'presek', 'preseka', 'secenje', 'sečenje', 'ozleda', 'ozlede', 'seme', 'semena',
	'koren', 'korena', 'korenu', 'korenski', 'korenskog', 'korenskih', 'korenske', 'korenska',
	'jednokoreni', 'jednokorenog', 'dvokoreni', 'dvokorenog', 'trokoreni', 'trokorenog',
	'višekoreni', 'višekorenog', 'visekorenog',
	'zamena', 'zamene', 'zameni', 'zamenom', 'primena', 'primene', 'primeni', 'primenom',
	'merenje', 'merenja', 'merenjem', 'mera', 'mere', 'procena', 'procene', 'procenu',
	'vežba', 'vežbe', 'vežbi', 'vežbanje', 'vezbe', 'svetlo', 'svetlom', 'svetlost', 'svetlosna', 'svetlosni',
	'izveštaj', 'izveštaja', 'izvestaj', 'izvestaja', 'savet', 'saveta',
	'nega', 'nege', 'negu', 'negom', 'negovanje', 'poseta', 'posete', 'posetu',
	'crevo', 'creva', 'crevni', 'crevne', 'crevnog', 'crevnih',
	'mehur', 'mehura', 'mehuru', 'ždrelo', 'ždrela', 'zdrelo', 'zenica', 'zenice', 'veđa', 'veđe', 'veđu',
	'slepo', 'slepog', 'slepa', 'veštački', 'veštačka', 'veštačke', 'veštačkog',
	'izbeljivanje', 'izbeljivanja', 'nameštanje', 'nameštanja', 'lepljenje', 'lepljenja',
	'deljenje', 'posle', 'pre', 'unapred', 'napred', 'uvek', 'sledeći', 'sledeća', 'sledeće',
]);

/**
 * Омографы: без диакритики это тоже настоящее слово, корпусная проверка на них врёт.
 * usne — «губы» (не «ušne»/ушные), soka — «сока» (не «šoka»), luka — «порт».
 */
export const DIACRITIC_HOMOGRAPHS = new Set(['usne', 'usna', 'usnu', 'usni', 'soka', 'sok', 'luka', 'cela', 'kosa', 'rana', 'sale']);

/**
 * Окончания русских относительных прилагательных. Существительные с такими
 * окончаниями редки, но род. мн. на «-ий/-ей» встречается часто («артерий»),
 * поэтому этих окончаний в списке нет — иначе половина находок ложная.
 */
export const RU_ADJ_TAIL = /(ого|его|ому|ым|ыми|ой|ая|ое|ые|ых|ый|ним|нее)$/i;

/** Прилагательное в конце названия законно: это уточнение вида услуги, а не обрубок. */
export const RU_ADJ_TAIL_OK = new Set([
	'большая', 'малая', 'обширная', 'обычный', 'обычная', 'классическая', 'классический',
	'машинное', 'ручное', 'нативная', 'нативное', 'обзорный', 'обзорная', 'осложнённый',
	'местной', 'общей', 'полной', 'правой', 'левой', 'нижней', 'верхней', 'передней',
	'задней', 'костной', 'больным', 'больной', 'новорождённым', 'взрослой', 'скорой',
	'нагрузкой', 'подвеской', 'стому', 'слизистой', 'клетчатой', 'лампой', 'облицовкой',
	'кислотой', 'септопластикой', 'глаукому', 'поясничной', 'грудной', 'заплатой', 'зелёным',
]);

/** Аббревиатуры и бренды: латиница в name_ru для них законна. */
export const RU_LATIN_OK = /\b(NiTi|PCR|PRP|IOL|MSCT|CT|MR|MRI|RTG|EKG|ECG|CTG|LASIK|OCT|TEP|TAPP|LEEP|HIFU|SMAS|IPL|PRK|YAG|SLT|LED|LPG|EMS|EMG|ENMG|VNG|ENG|ERCP|EUS|PET|SPECT|VAC|HILT|IASTM|IUD|IUI|SFEMG|CAD|CAM|Air-Flow|E-max)\b/g;

export const tokens = (s) => (s || '').toLowerCase().split(/[^\p{L}]+/u).filter(Boolean);
export const foldSerbian = (s) => s.replace(/č/g, 'c').replace(/ć/g, 'c').replace(/ž/g, 'z').replace(/š/g, 's').replace(/đ/g, 'dj');
export const hasDiacritics = (s) => /[čćžšđ]/.test(s);
export const lastWord = (s) => ((s || '').trim().split(/[\s—–,-]+/).pop() || '').toLowerCase();

/** Слово, в котором смешаны кириллица и латиница («неурoхирург» с латинской o). */
export const mixedScriptWords = (s) =>
	(s || '').split(/[^\p{L}]+/u).filter((w) => /\p{Script=Cyrillic}/u.test(w) && /\p{Script=Latin}/u.test(w));

/**
 * Свёртка, в которой поиск сравнивает строки: регистр, диакритика (включая
 * «đ» — её складывает `utf8mb4_unicode_520_ci`, см. server/common/search-collation.ts)
 * и «ё». Пробелы схлопываются, пунктуация остаётся: поиск — это LIKE по подстроке.
 */
export const searchFold = (s) =>
	(s || '')
		.toLowerCase()
		.replace(/đ/g, 'd')
		.replace(/ё/g, 'е')
		.normalize('NFD')
		.replace(/\p{M}/gu, '')
		.replace(/\s+/g, ' ')
		.trim();
