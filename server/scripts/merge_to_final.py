"""
Merge raw OCR sources into final document per category.

Inputs:
  - data/fzocg/<category>/paddleocr/<base-stem>.items.json     (paddleocr base, parsed)
  - data/fzocg/<category>/paddleocr/<amend-stem>.items.json    (paddleocr amendments, parsed)
  - data/fzocg/<category>/<llm-file>.json                       (optional: LLM source for diacritics + section names)

Output:
  - data/fzocg/<category>/<category>-FINAL.json                  (clean, DB-ready)

Merge rules:
  - Prices and codes: from paddle (more reliable on numbers/codes)
  - Names: from LLM if it differs from paddle ONLY by diacritics/whitespace;
           else keep paddle name and emit `name_paddle` + `name_llm` for review
  - Sections: from LLM (better classified) if available, else paddle
  - Amendments applied chronologically; latest write wins per code

Each item gets a `_sources` block tracking provenance and disagreements.
"""

import sys, json, re, unicodedata
from pathlib import Path
from datetime import date

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]


_SPECIAL_LATIN = str.maketrans({
    'đ': 'd', 'Đ': 'D',   # not decomposable via NFD
    'ø': 'o', 'Ø': 'O',
    'æ': 'ae', 'Æ': 'AE',
    'ł': 'l', 'Ł': 'L',
})

def strip_diacritics(s):
    if not s: return ''
    s = s.translate(_SPECIAL_LATIN)
    nfd = unicodedata.normalize('NFD', s)
    return ''.join(c for c in nfd if unicodedata.category(c) != 'Mn')


def normalize_name(s):
    """Make names comparable: lowercase, strip diacritics, collapse whitespace."""
    if not s: return ''
    s = strip_diacritics(s.lower())
    s = re.sub(r'\s+', ' ', s).strip()
    # Normalize punctuation differences
    s = s.replace(' - ', '-').replace('- ', '-').replace(' -', '-')
    s = s.replace(' ,', ',').replace(', ', ',')
    return s


def load_json(path):
    return json.load(open(path, encoding='utf-8'))


def make_item(paddle_item, llm_item=None, scheme_fallback=None):
    """Compose a final item with provenance.

    scheme_fallback: used only when paddle's detected scheme is 'unknown'.
    Otherwise paddle's per-item scheme is trusted (dual / operacija / single).
    """
    sources = {}
    code = paddle_item['code']
    paddle_name = paddle_item.get('name','').strip()
    # LLM uses either name_sr_latin (sekundarna) or name_sr (pzz) field
    if llm_item:
        llm_name = (llm_item.get('name_sr_latin') or llm_item.get('name_sr') or '').strip() or None
    else:
        llm_name = None

    # Choose name: prefer LLM when code is in LLM (LLM has diacritics + better
    # text recognition for Serbian medical terms). Paddle name only as fallback.
    # Flag substantive disagreements for human review.
    if llm_name:
        name = llm_name
        if normalize_name(paddle_name) == normalize_name(llm_name):
            sources['name'] = 'llm-diacritic'
        else:
            sources['name'] = 'llm-substantive'  # paddle name kept for review
    else:
        name = paddle_name
        sources['name'] = 'paddle-only'

    # Build prices
    final = {
        'code': code,
        'name': name,
    }

    paddle_scheme = paddle_item.get('scheme')
    scheme = paddle_scheme if paddle_scheme in ('dual','operacija','single') else (scheme_fallback or paddle_scheme)

    if scheme == 'dual':
        p_odj = paddle_item.get('odjeljenje_eur')
        p_amb = paddle_item.get('ambulanta_eur')
        # If paddle's "dual" has only one column filled, it's likely a
        # misclassified single-column row. Re-route through single-logic
        # using LLM hints to decide which column the value belongs to.
        if (p_odj is None) ^ (p_amb is None):
            value = p_odj if p_odj is not None else p_amb
            if llm_item:
                llm_odj = llm_item.get('price_odjeljenje_eur')
                llm_amb = llm_item.get('price_ambulanta_eur')
                if llm_odj is not None and llm_amb is None:
                    final['price_odjeljenje_eur'] = value
                    final['price_ambulanta_eur']  = None
                    sources['price'] = 'paddle-as-odjeljenje-via-llm-hint'
                elif llm_amb is not None and llm_odj is None:
                    final['price_odjeljenje_eur'] = None
                    final['price_ambulanta_eur']  = value
                    sources['price'] = 'paddle-as-ambulanta-via-llm-hint'
                else:
                    final['price_odjeljenje_eur'] = p_odj
                    final['price_ambulanta_eur']  = p_amb
                    sources['price'] = 'paddle'
            else:
                final['price_odjeljenje_eur'] = p_odj
                final['price_ambulanta_eur']  = p_amb
                sources['price'] = 'paddle'
        else:
            final['price_odjeljenje_eur'] = p_odj
            final['price_ambulanta_eur']  = p_amb
            sources['price'] = 'paddle'
    elif scheme == 'operacija':
        final['price_operacija_eur']  = paddle_item.get('operacija_eur')
        final['price_anestezija_eur'] = paddle_item.get('anestezija_eur')
        final['price_ukupno_eur']     = paddle_item.get('ukupno_eur')
        sources['price'] = 'paddle'
    elif scheme == 'single':
        # Single price column.  Decide on field name based on LLM hint or context.
        p = paddle_item.get('single_eur')
        if llm_item:
            # Match against LLM's price fields
            llm_odj = llm_item.get('price_odjeljenje_eur')
            llm_amb = llm_item.get('price_ambulanta_eur')
            llm_simple = llm_item.get('price_eur')
            if llm_simple is not None:
                final['price_eur'] = p
                sources['price'] = 'paddle-single'
            elif llm_odj is not None and llm_amb is None:
                final['price_odjeljenje_eur'] = p
                final['price_ambulanta_eur']  = None
                sources['price'] = 'paddle-as-odjeljenje-via-llm-hint'
            elif llm_amb is not None and llm_odj is None:
                final['price_odjeljenje_eur'] = None
                final['price_ambulanta_eur']  = p
                sources['price'] = 'paddle-as-ambulanta-via-llm-hint'
            elif llm_odj is not None and llm_amb is not None:
                # Both set in LLM — match paddle's value to whichever is closer
                if p is None:
                    sources['price'] = 'paddle-no-value'
                elif abs(p - (llm_odj or 0)) < abs(p - (llm_amb or 0)):
                    final['price_odjeljenje_eur'] = p
                    final['price_ambulanta_eur']  = llm_amb
                    sources['price'] = 'paddle-odj-llm-amb'
                else:
                    final['price_odjeljenje_eur'] = llm_odj
                    final['price_ambulanta_eur']  = p
                    sources['price'] = 'paddle-amb-llm-odj'
            else:
                final['price_eur'] = p
                sources['price'] = 'paddle-single-fallback'
        else:
            final['price_eur'] = p
            sources['price'] = 'paddle-single'
    else:
        # unknown scheme
        final['price_eur'] = paddle_item.get('single_eur') or paddle_item.get('odjeljenje_eur') or paddle_item.get('ambulanta_eur')
        sources['price'] = 'paddle-unknown-scheme'

    # If paddle yielded no prices, try to rescue via LLM or via paddle's
    # single_eur (paddle sometimes misclassifies the row but still extracts
    # the numeric value into single_eur).
    PRICE_FIELDS = (
        'price_eur', 'price_odjeljenje_eur', 'price_ambulanta_eur',
        'price_operacija_eur', 'price_anestezija_eur', 'price_ukupno_eur',
    )
    paddle_has_any_price = any(final.get(k) is not None for k in PRICE_FIELDS)
    if not paddle_has_any_price:
        for k in PRICE_FIELDS:
            final.pop(k, None)
        if llm_item:
            llm_has_any_price = False
            for k in PRICE_FIELDS:
                if llm_item.get(k) is not None:
                    final[k] = llm_item[k]
                    llm_has_any_price = True
            if llm_has_any_price:
                sources['price'] = 'llm-fallback'
            elif paddle_item.get('single_eur') is not None:
                final['price_eur'] = paddle_item['single_eur']
                sources['price'] = 'paddle-single-rescue'
        elif paddle_item.get('single_eur') is not None:
            final['price_eur'] = paddle_item['single_eur']
            sources['price'] = 'paddle-single-rescue'

    # Section: prefer LLM if it has one
    if llm_item and llm_item.get('section'):
        final['section'] = llm_item['section']
        final['subsection'] = llm_item.get('subsection')
        sources['section'] = 'llm'
    else:
        final['section'] = paddle_item.get('section')
        final['subsection'] = None
        sources['section'] = 'paddle'

    # If paddle and llm name disagreed substantively, surface both for review
    if sources.get('name') == 'llm-substantive':
        final['name_paddle'] = paddle_name

    final['_sources'] = sources
    return final


# --- Category-specific config -------------------------------------------------

CATEGORIES = {
    'transfuziologija': {
        'paddle_base': 'paddleocr/162758924911.-Cjenovnik-zdravstvenih-usluga-transfuziologije.items.json',
        'paddle_amendments': [],
        'llm_source': 'transfuziologija-2015-05-21.json',
        'scheme_default': 'single',
        'metadata': {
            'category': 'transfuziologija',
            'level': 'transfuziologija (Zavod za transfuziju krvi CG)',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'single',
        },
    },
    'primarna-zdravstvena-zastita': {
        'paddle_base': 'paddleocr/Cjenovnik-zdravstvenih-usluga-na-primarnom-nivou-zdravstvene-zastite-PZZ-od-01.05.2026.items.json',
        'paddle_amendments': [],
        'llm_source': 'pzz-2026-05-01.json',
        'scheme_default': 'single',
        'metadata': {
            'category': 'primarna-zdravstvena-zastita',
            'level': 'primarna zdravstvena zaštita (PZZ)',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'single',
        },
    },
    'apotekarska-djelatnost': {
        'paddle_base': 'paddleocr/162758926012.-Cjenovnik-usluga-apotekarske-djelatnosti.items.json',
        'paddle_amendments': [],  # 162758927013-... is procedural-only, no price changes
        'llm_source': None,
        'scheme_default': 'single',
        'metadata': {
            'category': 'apotekarska-djelatnost',
            'level': 'apotekarska djelatnost (pharmacy services)',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'single',
            'amendments_note': 'Odluka 01-7356 of 2018 added procedural clarification only — no price changes',
        },
    },
    'medicinsko-pomagala': {
        'paddle_base': 'paddleocr/Cjenovnik-medicinsko-tehnickih-pomagala-od-01.05.2026.items.json',
        'paddle_amendments': [],
        'llm_source': None,
        'scheme_default': 'single',
        'metadata': {
            'category': 'medicinsko-pomagala',
            'level': 'medicinsko-tehnička pomagala (medical technical aids)',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'single',
            'effective_from': '2026-05-01',
        },
    },
    'sekundarna-ostalo': {
        'paddle_base': 'paddleocr/15846071842.-Cjenovnik-zdravstvenih-usluga-na-sekundarnom-i.items.json',
        'paddle_amendments': [
            # chronological order: oldest first
            # date strings come from each Odluka's "stupa na snagu" / "primjenjuje se od" text
            ('paddleocr/15846071973.-Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN.items.json', '2017-01-01'),  # 01-9153
            ('paddleocr/15846072084.-Odluka-o-dopuni-Cjenovnika-na-STN.items.json',          '2017-04-01'),  # 01-1696 (paddle empty)
            ('paddleocr/15846072455.-Odluka-o-izmjeni-Cjenovnika-na-STN.items.json',          '2019-10-01'),  # 01-6104
            ('paddleocr/16037255236.-Odluka-o-dopuni-Cjenovnika-STN-PCR-test-na-koronav.items.json', '2020-10-31'),  # 01-8210 PCR add
            ('paddleocr/16086235807.-Odluka-o-izmjeni-i-dopuni-Cjenovnika-zdravstvenih-.items.json',  '2021-01-01'),  # 01-9323
            ('paddleocr/16275892028.-Odluka-o-izmjeni-Cjenovnika-STN-nova-cij.-PCR-test.items.json',  '2021-08-01'),  # 01-7281 PCR new price
            ('paddleocr/1632118391Odluka-o-izmjeni-Cjenovnika-STN-usluge-MR.items.json',      '2021-10-01'),  # 01-8844 MR
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-STN-od-25.05.2022.items.json',            '2022-06-01'),  # 01-4402
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-STN-od-15.06.2022.items.json',            '2022-07-01'),  # 01-5113
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-STN-od-26.12.2022-1.items.json',          '2023-01-01'),  # 01-10172
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-STN-od-14.03.2023.items.json',            '2023-04-01'),  # 01-2643
            ('paddleocr/Odluka-o-izmjeni-i-dopuni-Cjenovnika-STN-od-17.10.2023.g.items.json', '2023-12-01'),  # 01-9472
            ('paddleocr/Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN-od-01.02.2025.items.json','2025-02-01'),  # 01-699
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-zdravstvenih-usluga-na-STN-od-01.05.items.json', '2026-05-01'),  # 01-4081
        ],
        'llm_source': 'sekundarna-ostalo-LATEST.json',
        'scheme_default': 'single',
        'metadata': {
            'category': 'sekundarna-ostalo',
            'level': 'sekundarna i tercijarna zdravstvena zaštita – ostalo bolničko liječenje i specijalističko-konsultativna i dijagnostička zaštita',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'mixed (dual / operacija / single)',
            'base_signed': {
                'date': '2015-07-29',
                'number': '01-4396',
                'note': 'Cjenovnik br. 01-4396 od 29.07.2015. godine',
            },
        },
    },
    'van-mreze': {
        'paddle_base': 'paddleocr/1632118369Cjenovnik-usluga-koje-pruzaju-ZU-van-Mreze.items.json',
        'paddle_amendments': [
            # chronological order: oldest first
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-ZU-van-Mreze-od-26.12.2022-1.items.json', '2023-01-03'),
            ('paddleocr/Odluka-o-izmjeni-i-dopuni-Cjenovnika-ZU-van-Mreze-od-23.11.2023.g.items.json', '2023-12-01'),
            ('paddleocr/Odluka-o-izmjeni-Cjenovnika-ZU-van-Mreze-od-01.03.2025.items.json', '2025-03-09'),
        ],
        'llm_source': None,
        'scheme_default': 'single',
        'metadata': {
            'category': 'van-mreze',
            'level': 'ZU van zdravstvene mreže (institutions outside the health network)',
            'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
            'price_columns': 'single',
        },
    },
}


CODE_OCR_ALIASES = [
    # (paddle pattern, llm pattern) — pairs that represent the same source code
    # under different OCR readings. Used to auto-merge paddle-only and llm-only sets.
    (re.compile(r'^1(\d{5})$'), lambda m: f'I{m.group(1)}'),  # leading "1" → "I"
    (re.compile(r'^I(\d{5})$'), lambda m: f'1{m.group(1)}'),  # leading "I" → "1"
    (re.compile(r'^2(\d{5})$'), lambda m: f'Z{m.group(1)}'),  # leading "2" → "Z"
    (re.compile(r'^Z(\d{5})$'), lambda m: f'2{m.group(1)}'),  # leading "Z" → "2"
]

def resolve_alias_in_llm(paddle_code, llm_by_code):
    """Return llm_code if paddle_code maps to an llm key via known OCR aliases."""
    for pat, repl in CODE_OCR_ALIASES:
        m = pat.match(paddle_code)
        if m:
            cand = repl(m)
            if cand in llm_by_code:
                return cand
    return None


def resolve_by_name(paddle_item, llm_only_index):
    """Resolve paddle code to llm code via exact normalized-name match.

    Used when regex alias fails. llm_only_index maps normalized name to llm_code.
    Returns llm_code or None. Requires paddle and llm names to be at least 8 chars
    after normalization (filters trivial 1-3 word matches that may coincide).
    """
    name = normalize_name(paddle_item.get('name', ''))
    if len(name) < 8:
        return None
    return llm_only_index.get(name)


def merge_category(category):
    cfg = CATEGORIES[category]
    cat_dir = ROOT / 'data' / 'fzocg' / category

    paddle_base = load_json(cat_dir / cfg['paddle_base'])
    llm_source = load_json(cat_dir / cfg['llm_source']) if cfg.get('llm_source') else None

    # Index LLM items by code
    llm_by_code = {it['code']: it for it in (llm_source or {}).get('items', [])}

    # Build section-number → clean LLM section name map. Lets us replace
    # paddle's ugly section names (no diacritics, mangled spacing) with the
    # canonical LLM versions for paddle-only items.
    llm_section_by_num = {}
    for it in (llm_source or {}).get('items', []):
        sec = it.get('section')
        if not sec: continue
        m = re.match(r'^(\d+)\.\s*(.+)', sec)
        if m:
            llm_section_by_num.setdefault(int(m.group(1)), sec)

    final_items = []
    name_disagreements = []
    only_in_paddle = []
    only_in_llm = []
    scheme_fallback = cfg.get('scheme_default')

    # Build name index for LLM codes that have no direct paddle counterpart.
    # Used as fallback alias-resolution when regex aliases don't apply (e.g.
    # paddle Z02086 vs llm Z02066 = single misread digit, but names match).
    paddle_codes_in_base = {it['code'] for it in paddle_base['items']}
    llm_only_name_index = {}
    for code, it in llm_by_code.items():
        if code in paddle_codes_in_base: continue
        llm_name = (it.get('name_sr_latin') or it.get('name_sr') or '').strip()
        n = normalize_name(llm_name)
        if len(n) >= 8:
            # If multiple LLM codes share the same name, skip (ambiguous)
            if n in llm_only_name_index:
                llm_only_name_index[n] = None
            else:
                llm_only_name_index[n] = code
    # Drop ambiguous entries
    llm_only_name_index = {k: v for k, v in llm_only_name_index.items() if v}

    paddle_codes = set()
    seen_paddle_keys = set()  # (code, name, prices) — drop exact paddle duplicates
    paddle_duplicates_dropped = []
    paddle_duplicates_conflicting = []
    alias_resolved = []  # paddle_code -> llm_code mappings we applied
    name_resolved = []   # paddle_code -> llm_code mappings via name match
    for p_it in paddle_base['items']:
        # Skip paddle base duplicates — paddle frequently reads the same
        # row multiple times across page breaks. Dedup by normalized content.
        dedup_key = (
            p_it['code'],
            normalize_name(p_it.get('name') or ''),
            p_it.get('single_eur'),
            p_it.get('odjeljenje_eur'),
            p_it.get('ambulanta_eur'),
            p_it.get('operacija_eur'),
        )
        if dedup_key in seen_paddle_keys:
            paddle_duplicates_dropped.append(p_it['code'])
            continue
        # If we've seen this code with a *different* content, it's a real
        # data conflict in the source — keep the first occurrence and flag.
        if p_it['code'] in paddle_codes:
            paddle_duplicates_conflicting.append(p_it['code'])
            continue
        seen_paddle_keys.add(dedup_key)
        paddle_codes.add(p_it['code'])
        l_it = llm_by_code.get(p_it['code'])
        chosen_code = p_it['code']
        if l_it is None:
            # try regex OCR alias resolution (e.g. paddle "101002" → llm "I01002")
            alias = resolve_alias_in_llm(p_it['code'], llm_by_code)
            if alias:
                l_it = llm_by_code[alias]
                chosen_code = alias
                alias_resolved.append((p_it['code'], alias))
            else:
                # try name-based resolution (paddle Z02086 → llm Z02066 etc.)
                name_alias = resolve_by_name(p_it, llm_only_name_index)
                if name_alias and name_alias not in paddle_codes:
                    l_it = llm_by_code[name_alias]
                    chosen_code = name_alias
                    name_resolved.append((p_it['code'], name_alias))
        # If alias resolved, override the paddle item's code to the canonical form
        if chosen_code != p_it['code']:
            p_it = {**p_it, 'code': chosen_code}
        merged = make_item(p_it, l_it, scheme_fallback=scheme_fallback)
        if merged['_sources'].get('name') == 'llm-substantive':
            name_disagreements.append(merged['code'])
        final_items.append(merged)
        if l_it is None:
            only_in_paddle.append(p_it['code'])

    # Mark which LLM codes were absorbed via alias resolution
    aliased_llm_codes = {l for _, l in alias_resolved} | {l for _, l in name_resolved}
    paddle_codes_after_alias = paddle_codes | aliased_llm_codes

    # Apply amendments chronologically. Each amendment's items override base items
    # for the same code (latest write wins).
    amendments_applied = []
    final_by_code = {it['code']: i for i, it in enumerate(final_items)}
    for amend_rel, effective_from in (cfg.get('paddle_amendments') or []):
        amend_path = cat_dir / amend_rel
        if not amend_path.exists():
            print(f'  WARNING: amendment file not found: {amend_rel}', file=sys.stderr)
            continue
        amend_data = load_json(amend_path)
        changed = 0
        added = 0
        for a_it in amend_data['items']:
            # Make item using current scheme_default; no LLM cross-ref for amendments
            merged_a = make_item(a_it, llm_by_code.get(a_it['code']), scheme_fallback=scheme_fallback)
            merged_a['amended_from'] = effective_from
            merged_a['_sources']['amendment'] = amend_path.name
            if a_it['code'] in final_by_code:
                # update in place
                idx = final_by_code[a_it['code']]
                final_items[idx] = merged_a
                changed += 1
            else:
                final_items.append(merged_a)
                final_by_code[a_it['code']] = len(final_items)-1
                added += 1
        amendments_applied.append({
            'file': amend_path.name,
            'effective_from': effective_from,
            'items_changed': changed,
            'items_added': added,
        })

    # Track which codes already exist in final_items (base + amendments + aliases).
    # Without this we'd duplicate-add codes that were introduced by amendments.
    codes_in_final = set(final_by_code.keys()) | aliased_llm_codes
    for code in llm_by_code:
        if code not in codes_in_final:
            only_in_llm.append(code)
            # Synthesize from LLM (no paddle data)
            l_it = llm_by_code[code]
            llm_name = (l_it.get('name_sr_latin') or l_it.get('name_sr') or '').strip()
            synthetic = {
                'code': code,
                'name': llm_name,
                'section': l_it.get('section'),
                'subsection': l_it.get('subsection'),
                '_sources': {'name': 'llm-only', 'price': 'llm-only', 'section': 'llm-only'},
            }
            # Carry LLM prices verbatim
            for k in ('price_eur','price_odjeljenje_eur','price_ambulanta_eur',
                      'price_operacija_eur','price_anestezija_eur','price_ukupno_eur'):
                if k in l_it:
                    synthetic[k] = l_it[k]
            final_items.append(synthetic)

    # Normalize paddle-sourced sections to canonical LLM section names by
    # matching the leading section number. Falls back to paddle's own name if
    # no match (rare).
    for it in final_items:
        if it.get('_sources', {}).get('section') == 'paddle' and it.get('section'):
            m = re.match(r'^(\d+)\.\s*(.+)', it['section'])
            if m and int(m.group(1)) in llm_section_by_num:
                it['section'] = llm_section_by_num[int(m.group(1))]
                it['_sources']['section'] = 'paddle-num→llm-name'

    # Sort final items by section then code
    final_items.sort(key=lambda it: (str(it.get('section') or ''), it.get('code') or ''))

    payload = dict(cfg['metadata'])
    payload['effective_from'] = (llm_source or {}).get('effective_from')
    payload['source_pdf']     = (llm_source or {}).get('source_pdf')
    payload['signed']         = (llm_source or {}).get('signed')
    payload['supersedes']     = (llm_source or {}).get('supersedes')
    payload['merge_info'] = {
        'merge_date': date.today().isoformat(),
        'paddle_engine': 'paddleocr 3.5.0 / PP-StructureV3',
        'paddle_items': len(paddle_base['items']),
        'llm_items': len(llm_by_code),
        'final_items': len(final_items),
        'codes_only_in_paddle': len(only_in_paddle),
        'codes_only_in_llm': len(only_in_llm),
        'name_disagreements': len(name_disagreements),
        'ocr_aliases_resolved': len(alias_resolved),
        'name_resolved': len(name_resolved),
        'amendments_applied': amendments_applied,
    }
    if alias_resolved:
        payload['merge_info']['ocr_alias_pairs'] = [{'paddle': p, 'llm': l} for p, l in alias_resolved]
    if name_resolved:
        payload['merge_info']['name_resolved_pairs'] = [{'paddle': p, 'llm': l} for p, l in name_resolved]
    if name_disagreements:
        payload['merge_info']['name_disagreement_codes'] = name_disagreements
    if only_in_paddle:
        payload['merge_info']['paddle_only_codes'] = only_in_paddle
    if paddle_duplicates_dropped:
        payload['merge_info']['paddle_duplicates_dropped'] = paddle_duplicates_dropped
    if paddle_duplicates_conflicting:
        payload['merge_info']['paddle_duplicates_conflicting'] = paddle_duplicates_conflicting
    if only_in_llm:
        payload['merge_info']['llm_only_codes'] = only_in_llm

    payload['items_total'] = len(final_items)
    payload['items'] = final_items

    out_path = cat_dir / f'{category}-FINAL.json'
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    return out_path, payload


def main():
    if len(sys.argv) != 2:
        print('Usage: merge_to_final.py <category>')
        print(f'  available: {", ".join(CATEGORIES.keys())}')
        sys.exit(1)
    cat = sys.argv[1]
    if cat not in CATEGORIES:
        print(f'Unknown category {cat}. Available: {list(CATEGORIES.keys())}')
        sys.exit(2)
    out_path, payload = merge_category(cat)
    info = payload['merge_info']
    print(f'\n=== {cat} merged → {out_path.relative_to(ROOT)} ===')
    print(f'  paddle_items     : {info["paddle_items"]}')
    print(f'  llm_items        : {info["llm_items"]}')
    print(f'  final_items      : {info["final_items"]}')
    print(f'  paddle-only codes: {info["codes_only_in_paddle"]}')
    print(f'  llm-only codes   : {info["codes_only_in_llm"]}')
    print(f'  name disagreements: {info["name_disagreements"]}')
    if info["name_disagreements"]:
        for c in info.get('name_disagreement_codes', [])[:5]:
            it = next(x for x in payload['items'] if x['code']==c)
            print(f'    {c}:  final/LLM="{it["name"][:55]}"')
            print(f'           paddle="{it.get("name_paddle","?")[:55]}"')


if __name__ == '__main__':
    main()
