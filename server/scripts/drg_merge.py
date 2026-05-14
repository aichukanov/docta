"""
Merge DRG paddle OCR + LLM-OCR source into drg-akutno-bolnicko-FINAL.json.

DRG schema differs from other FZOCG pricelists (coefficient + price_eur columns,
no Odjeljenje/Ambulanta), so this gets its own script instead of a category entry
in merge_to_final.py.

Strategy:
  - Use paddle when paddle item has scheme=dual + non-null coef + non-null price
    (paddle is structurally aligned to the PDF; LLM has occasional row shifts).
  - Fall back to LLM when paddle is missing or mangled (e.g. Pre-MDC rows where
    paddle merged A01Z..A07Z into one cell).
  - Cross-check coefficient × base_coefficient ≈ price_eur for every final item.

Inputs:
  data/fzocg/drg-akutno-bolnicko/paddleocr/<base>.items.json
  data/fzocg/drg-akutno-bolnicko/drg-2025-01-01.json    (LLM source)

Output:
  data/fzocg/drg-akutno-bolnicko/drg-akutno-bolnicko-FINAL.json
"""

import sys, json, re, unicodedata
from pathlib import Path
from datetime import date

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]
CAT_DIR = ROOT / 'data' / 'fzocg' / 'drg-akutno-bolnicko'

PADDLE_BASE = CAT_DIR / 'paddleocr' / 'Cjenovnik-zdravstvenih-usluga-po-DRG-od-01.01.2025.g.items.json'
LLM_SOURCE  = CAT_DIR / 'drg-2025-01-01.json'
OUT_PATH    = CAT_DIR / 'drg-akutno-bolnicko-FINAL.json'

BASE_COEFFICIENT = 760.18


_SPECIAL_LATIN = str.maketrans({
    'đ': 'd', 'Đ': 'D',
})

def strip_diacritics(s):
    if not s: return ''
    s = s.translate(_SPECIAL_LATIN)
    nfd = unicodedata.normalize('NFD', s)
    return ''.join(c for c in nfd if unicodedata.category(c) != 'Mn')


def normalize_name(s):
    if not s: return ''
    s = strip_diacritics(s.lower())
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def cross_validate(coef, price):
    """Returns abs diff between coef*base and price; None if either missing."""
    if coef is None or price is None:
        return None
    return round(abs(coef * BASE_COEFFICIENT - price), 2)


def paddle_is_clean(p_it):
    """A paddle item is usable when it's dual-scheme and both prices are present."""
    return (
        p_it.get('scheme') == 'dual'
        and p_it.get('odjeljenje_eur') is not None
        and p_it.get('ambulanta_eur') is not None
    )


def merge():
    paddle = json.load(open(PADDLE_BASE, encoding='utf-8'))
    llm    = json.load(open(LLM_SOURCE,  encoding='utf-8'))

    paddle_by = {it['code']: it for it in paddle['items']}
    llm_by    = {it['code']: it for it in llm['items']}

    # Build letter-prefix -> section map from LLM (e.g. 'I' -> 'MDC 08').
    # Used to infer section for paddle-only codes (paddle has no section data).
    prefix_to_section = {}
    for it in llm['items']:
        sec = it.get('section')
        code = it.get('code') or ''
        if sec and code:
            m = re.match(r'^([A-Z]+)', code)
            if m:
                prefix_to_section.setdefault(m.group(1), {}).setdefault(sec, 0)
                prefix_to_section[m.group(1)][sec] += 1
    # Pick most common section per prefix
    prefix_section = {p: max(secs.items(), key=lambda x: x[1])[0]
                       for p, secs in prefix_to_section.items()}

    all_codes = sorted(set(paddle_by.keys()) | set(llm_by.keys()))

    final_items = []
    stats = {
        'codes_paddle_only': [],
        'codes_llm_only': [],
        'paddle_mangled_fell_back_to_llm': [],
        'name_disagreements': [],
        'numeric_disagreements': [],   # paddle vs llm differ on coef or price
        'xval_failures': [],            # final coef*base != price
    }

    for code in all_codes:
        p = paddle_by.get(code)
        l = llm_by.get(code)

        # Choose authoritative numeric source
        if p and paddle_is_clean(p):
            coef = p['odjeljenje_eur']
            price = p['ambulanta_eur']
            num_source = 'paddle'
            # If LLM has same code but different numbers — flag for review
            if l is not None:
                lc = l.get('coefficient')
                lp = l.get('price_eur')
                cdiff = lc is None or abs(lc - coef) > 0.01
                pdiff = lp is None or abs(lp - price) > 0.5
                if cdiff or pdiff:
                    stats['numeric_disagreements'].append({
                        'code': code,
                        'paddle': {'coefficient': coef, 'price_eur': price},
                        'llm':    {'coefficient': lc,   'price_eur': lp},
                    })
        elif l is not None:
            coef = l.get('coefficient')
            price = l.get('price_eur')
            num_source = 'llm'
            if p is not None:
                stats['paddle_mangled_fell_back_to_llm'].append(code)
        else:
            # Should not happen — code is in all_codes only if present in one of them
            continue

        # Choose name: prefer LLM's (better Serbian + diacritics) when both agree
        # structurally. If only one has the row, use that name.
        paddle_name = (p.get('name') if p else '') or ''
        llm_name = ''
        if l is not None:
            llm_name = (l.get('name_sr_latin') or l.get('name_sr') or '').strip()

        if l is not None and llm_name:
            name = llm_name
            name_source = 'llm'
            if p and paddle_is_clean(p):
                # Both have data — compare normalized
                if normalize_name(paddle_name) != normalize_name(llm_name):
                    stats['name_disagreements'].append(code)
                    name_source = 'llm-substantive'
        else:
            name = paddle_name
            name_source = 'paddle-only'

        section = (l or {}).get('section')
        section_source = 'llm' if section else None
        if not section:
            m = re.match(r'^([A-Z]+)', code)
            if m and m.group(1) in prefix_section:
                section = prefix_section[m.group(1)]
                section_source = 'inferred-from-prefix'

        item = {
            'code': code,
            'name': name,
            'coefficient': coef,
            'price_eur': price,
            'section': section,
            '_sources': {
                'name': name_source,
                'price': num_source,
                'coefficient': num_source,
                'section': section_source,
            },
        }
        # Surface paddle name when LLM and paddle disagree substantively
        if name_source == 'llm-substantive':
            item['name_paddle'] = paddle_name

        # Cross-validate coef × base ≈ price
        xval = cross_validate(coef, price)
        if xval is not None and xval > 1.0:
            stats['xval_failures'].append({
                'code': code,
                'coefficient': coef,
                'price_eur': price,
                'expected_price': round(coef * BASE_COEFFICIENT, 2),
                'diff': xval,
            })

        if p is None:
            stats['codes_llm_only'].append(code)
        if l is None:
            stats['codes_paddle_only'].append(code)

        final_items.append(item)

    # Detect LLM-only codes whose (coef, price) match another paddle code.
    # These are suspicious — often LLM row-drift produces a hallucinated code
    # carrying prices from a neighboring real code. Not all are wrong (common
    # coefficients repeat across the DRG), but the user should review them.
    paddle_by_price = {}
    for it in paddle['items']:
        key = (it.get('odjeljenje_eur'), it.get('ambulanta_eur'))
        if all(v is not None for v in key):
            paddle_by_price.setdefault(key, []).append(it['code'])
    suspicious_llm_only = []
    for code in stats['codes_llm_only']:
        item = next((x for x in final_items if x['code']==code), None)
        if not item: continue
        key = (item['coefficient'], item['price_eur'])
        if key in paddle_by_price:
            suspicious_llm_only.append({
                'code': code,
                'name': item['name'][:60],
                'coefficient': key[0],
                'price_eur': key[1],
                'paddle_codes_with_same_prices': paddle_by_price[key],
            })
            item['_review'] = 'suspicious-llm-drift'
    if suspicious_llm_only:
        stats['suspicious_llm_only'] = suspicious_llm_only

    # Sort by section (Pre-MDC first, then MDC 01..23, Nepovezani last) then code
    SECTION_ORDER = {'Pre-MDC': -1, 'Nepovezani sa DRG': 999}
    def sec_key(s):
        if s in SECTION_ORDER: return SECTION_ORDER[s]
        m = re.match(r'MDC (\d+)', s or '')
        return int(m.group(1)) if m else 998
    final_items.sort(key=lambda it: (sec_key(it.get('section')), it.get('code') or ''))

    payload = {
        'category': 'drg-akutno-bolnicko',
        'level': 'sekundarna i tercijarna zdravstvena zaštita – akutno bolničko liječenje (DRG)',
        'issuer': 'Fond za zdravstveno osiguranje Crne Gore (FZOCG)',
        'price_columns': 'coefficient+price',
        'base_coefficient_eur': BASE_COEFFICIENT,
        'effective_from': llm.get('effective_from'),
        'source_pdf': llm.get('source_pdf'),
        'signed': llm.get('signed'),
        'supersedes': 'Cjenovnik br. 01-9124 of 25.12.2018 and amendments br. 01-6106 of 20.09.2019 (per Član 7)',
        'notes': llm.get('notes', []),
        'merge_info': {
            'merge_date': date.today().isoformat(),
            'paddle_engine': 'paddleocr 3.5.0 / PP-StructureV3',
            'paddle_items': len(paddle['items']),
            'llm_items': len(llm['items']),
            'final_items': len(final_items),
            'codes_only_in_paddle': len(stats['codes_paddle_only']),
            'codes_only_in_llm': len(stats['codes_llm_only']),
            'paddle_mangled_fell_back_to_llm': len(stats['paddle_mangled_fell_back_to_llm']),
            'name_disagreements': len(stats['name_disagreements']),
            'numeric_disagreements': len(stats['numeric_disagreements']),
            'xval_failures': len(stats['xval_failures']),
            'suspicious_llm_only': len(stats.get('suspicious_llm_only', [])),
        },
        'items_total': len(final_items),
        'items': final_items,
    }

    if stats['codes_paddle_only']:
        payload['merge_info']['paddle_only_codes'] = stats['codes_paddle_only']
    if stats['codes_llm_only']:
        payload['merge_info']['llm_only_codes'] = stats['codes_llm_only']
    if stats['paddle_mangled_fell_back_to_llm']:
        payload['merge_info']['paddle_mangled_codes'] = stats['paddle_mangled_fell_back_to_llm']
    if stats['name_disagreements']:
        payload['merge_info']['name_disagreement_codes'] = stats['name_disagreements']
    if stats['numeric_disagreements']:
        payload['merge_info']['numeric_disagreement_details'] = stats['numeric_disagreements']
    if stats['xval_failures']:
        payload['merge_info']['xval_failure_details'] = stats['xval_failures']
    if stats.get('suspicious_llm_only'):
        payload['merge_info']['suspicious_llm_only_details'] = stats['suspicious_llm_only']

    with open(OUT_PATH, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)

    return payload


def main():
    p = merge()
    info = p['merge_info']
    print(f'\n=== DRG merged → {OUT_PATH.relative_to(ROOT)} ===')
    print(f'  paddle_items     : {info["paddle_items"]}')
    print(f'  llm_items        : {info["llm_items"]}')
    print(f'  final_items      : {info["final_items"]}')
    print(f'  paddle-only codes: {info["codes_only_in_paddle"]}    -> {info.get("paddle_only_codes", [])[:10]}')
    print(f'  llm-only codes   : {info["codes_only_in_llm"]}')
    print(f'  paddle-mangled (fell back to LLM): {info["paddle_mangled_fell_back_to_llm"]}')
    print(f'  name disagreements: {info["name_disagreements"]}')
    print(f'  numeric disagreements: {info["numeric_disagreements"]}')
    print(f'  xval failures (coef*base != price): {info["xval_failures"]}')
    print(f'  suspicious LLM-only (likely drift): {info["suspicious_llm_only"]}')

    for nd in info.get('numeric_disagreement_details', [])[:10]:
        print(f'    {nd["code"]}: paddle coef={nd["paddle"]["coefficient"]} price={nd["paddle"]["price_eur"]}  '
              f'vs llm coef={nd["llm"]["coefficient"]} price={nd["llm"]["price_eur"]}')
    for xv in info.get('xval_failure_details', [])[:5]:
        print(f'    XVAL {xv["code"]}: coef*base={xv["expected_price"]} vs stored {xv["price_eur"]} (diff {xv["diff"]})')


if __name__ == '__main__':
    main()
