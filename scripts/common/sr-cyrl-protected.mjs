/**
 * Латинские токены, которые в сербской кириллице остаются латиницей.
 *
 * Общий список для двух генераторов sr_cyrl: справочного контента
 * (scripts/entity-reference/generate-sr-cyrl.mjs) и названий услуг
 * (scripts/common/sr-cyrl-names.mjs). Порядок важен: составные токены
 * должны перехватываться раньше одиночных.
 */

// Токены, которые остаются латиницей: бренды, международные обозначения,
// иностранные фамилии в названиях формул/методик.
export const PROTECTED_LATIN_TOKENS = [
	'LASIK',
	'Fowler-Sabine',
	'PSA',
	'HbA1c',
	'HCG',
	'HCV',
	'TPHA',
	// PAPP-A намеренно НЕ защищён: батч 7 зафиксировал «ПАПП-А» кириллицей,
	// эта форма уже в проде и проверена (см. PROGRESS.md)
	'OCT',
	'VEGF',
	'FRC',
	'Rh',
	'IgE',
	'IgG',
	'IgM',
	// бренды имплантационных/ортодонтических систем и препаратов (тир B)
	'Nobel Biocare',
	'Straumann',
	'Bredent',
	'Invisalign',
	'Vistabel',
	'Botox',
	// протоколы, материалы, обозначения
	'All on 4',
	'All on 6',
	'E-max',
	'CAD/CAM',
	'CoCr',
	'PRP',
	'IOL',
	// римские цифры стадий: без защиты «I-III» превращается в «И-ИИИ»
	'I-III',
	'II-III',
	'I-II',

	// --- волна 2 (анализы и услуги, 2026-09) ---
	// Латинские видовые названия: транслитерация ломает их в «Хелицобацтер».
	// Идут первыми: составные токены должны перехватываться раньше одиночных.
	'Bordetella pertussis',
	'Chlamydia trachomatis',
	'Clostridium difficile',
	'Gardnerella vaginalis',
	'Helicobacter pylori',
	'Mycoplasma genitalium',
	'Mycoplasma hominis',
	'Neisseria gonorrhoeae',
	'Toxoplasma gondii',
	'Trichomonas vaginalis',
	'Ureaplasma urealyticum',
	'Epstein-Barr',
	'Candida',
	'Demodex',
	// Онкомаркеры: «CA» отдельно не защищаем — только вместе с номером,
	// иначе под защиту попадёт любое случайное «ca» в тексте.
	'CA 125',
	'CA 15-3',
	'CA 19-9',
	'CA 72-4',
	'CYFRA 21-1',
	'HE4',
	'NSE',
	'ROMA',
	// Лабораторные обозначения и методы
	'Anti-CCP',
	'Anti-Tg',
	'ANA',
	'ASA',
	'ELISA',
	'IGRA',
	'IgA',
	'IgE',
	'HBs',
	'HPV',
	'HSV1',
	'HSV2',
	'KOH',
	'LE',
	'USB',
	'SARS-CoV-2',
	'spike',
	'SHBG',
	'TSHR',
	'TSH',
	'ACE',
	// Услуги: аппаратура и материалы
	'Air-Flow',
	'Bio-Oss',
	'CBCT',
	'LBC',
	'CT',
	// Волна 3: патогистология и ИГХ — без защиты выходит «Хер2», «Ки67», «ЛЕЕП»
	'Her2',
	'Ki67',
	'LEEP',
	'H&E',
	// Волна 3, услуги: материалы и бренды из прайсов
	'NiTi',
	'FRC',
	'Ivoclar',
	'EvoCeram',
	'VIMA',
	// Волна 3: генетика, аутоантитела и лабораторные обозначения — без защиты
	// выходят «БРЦА1», «МТХФР», «ЦОВИД-19», «ЦРП»
	'BRCA1',
	'BRCA2',
	'MTHFR',
	'PAI-1',
	'AZFa',
	'AZFb',
	'AZFc',
	'AZF',
	'GAD',
	'IA-2',
	'CRP',
	'COVID-19',
	'BERA',
	'dsDNA',
	'DNA',
	'II',
	// Волна 3: эритроцитарные индексы гемограммы — без защиты выходит «МЦХЦ».
	// Составной MCHC раньше MCH, чтобы не откусывало хвост
	'MCHC',
	'MCH',
	'MCV',
	// НЕ защищаем: DNK, RNK, PCR, EKG, HOBP, ORL, B12, B6 — у них устоявшаяся
	// сербская кириллица (ДНК, ПЦР, ЕКГ, ХОБП, ОРЛ, Б12), список их только испортит.
];
