"""
Build FINAL.json for KBKotor (JZU Specijalna bolnica Risan) treca-lica pricelists.

Inputs:
  data/kbkotor/<slug>/paddleocr/*.items.json     (paddle, parsed)
  data/fzocg/sekundarna-ostalo/sekundarna-ostalo-FINAL.json   (for name enrichment)

Outputs:
  data/kbkotor/ambulanta-treca-lica/ambulanta-treca-lica-FINAL.json
  data/kbkotor/odjeljenja-treca-lica/odjeljenja-treca-lica-FINAL.json

Notes:
  - KBKotor uses FZOCG sekundarna codes with a third-party multiplier
    (3.0× for ambulanta, 2.5× for odjeljenja) per Ministarstvo zdravlja
    directive 011-25/2019-2 of 2019-02-14.
  - We use KBKotor's printed price as authoritative (effective 2022-03-01).
  - Names enriched from FZOCG sekundarna where the code matches — those
    have clean diacritics and consistent Serbian terminology.
"""
import sys, json, re, unicodedata
from pathlib import Path
from datetime import date

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]

FZOCG_SOURCE = ROOT / 'data' / 'fzocg' / 'sekundarna-ostalo' / 'sekundarna-ostalo-FINAL.json'

PRICELISTS = {
    'ambulanta-treca-lica': {
        'paddle': 'paddleocr/cjenovnik ambulanta za treca lica_compressed.items.json',
        'type': 'ambulanta',
        'multiplier': 3.0,
        'bod_value': 8.34,
    },
    'odjeljenja-treca-lica': {
        'paddle': 'paddleocr/cjenovnik odjeljenja za treca lica_compressed.items.json',
        'type': 'odjeljenja (stacionarne usluge)',
        'multiplier': 2.5,
        'bod_value': 3.25,
    },
}

INSTITUTION_META = {
    'institution': 'JZU Specijalna bolnica Risan',
    'institution_id_in_source': '609',
    'patient_category': 'treca lica (third-party self-pay)',
    'effective_from': '2022-03-01',
    'ministry_directive': {
        'issuer': 'Ministarstvo zdravlja Crne Gore',
        'number': '011-25/2019-2',
        'date': '2019-02-14',
        'rule': 'Ambulantne usluge × 3,0 ; Stacionarne (odjeljenja) usluge × 2,5 — od FZOCG cijena',
    },
}

_SPECIAL_LATIN = str.maketrans({'đ': 'd', 'Đ': 'D'})


# OCR digit↔letter confusions seen in KBKotor codes.
CODE_OCR_ALIASES = (
    (re.compile(r'^0(\d{5})$'), lambda m: 'O' + m.group(1)),
    (re.compile(r'^1(\d{5})$'), lambda m: 'I' + m.group(1)),
    (re.compile(r'^2(\d{5})$'), lambda m: 'Z' + m.group(1)),
)

def resolve_code_alias(code, fzocg_by_code):
    """Try OCR alias swaps to find a code in FZOCG."""
    for pat, repl in CODE_OCR_ALIASES:
        m = pat.match(code)
        if m:
            cand = repl(m)
            if cand in fzocg_by_code:
                return cand
    return None

def strip_diacritics(s):
    if not s: return ''
    s = s.translate(_SPECIAL_LATIN)
    nfd = unicodedata.normalize('NFD', s)
    return ''.join(c for c in nfd if unicodedata.category(c) != 'Mn')


def norm_name(s):
    if not s: return ''
    s = strip_diacritics(s.lower())
    s = re.sub(r'\s+', ' ', s).strip()
    return s


def build_pricelist(slug, cfg, fzocg_by_code):
    paddle = json.load(open(ROOT / 'data' / 'kbkotor' / slug / cfg['paddle'], encoding='utf-8'))

    items = []
    stats = {
        'codes_in_fzocg': 0,
        'codes_not_in_fzocg': 0,
        'names_from_fzocg': 0,
        'names_from_kbkotor': 0,
        'price_xval_match_3x': 0,
        'price_xval_match_25x': 0,
        'price_xval_mismatch': 0,
    }
    not_in_fzocg_codes = []
    xval_mismatches = []

    multiplier = cfg['multiplier']

    alias_resolved = []  # list of (paddle_code, fzocg_code) pairs

    for p_it in paddle['items']:
        code = p_it['code']
        fz = fzocg_by_code.get(code)
        if fz is None:
            alias_code = resolve_code_alias(code, fzocg_by_code)
            if alias_code is not None:
                fz = fzocg_by_code[alias_code]
                alias_resolved.append((code, alias_code))
                code = alias_code  # use canonical FZOCG code

        kbkotor_price = p_it.get('price_eur')
        kbkotor_name  = (p_it.get('name') or '').strip()

        # Pick name: prefer FZOCG (clean Serbian), fall back to KBKotor's
        # If FZOCG and KBKotor names disagree substantively, keep FZOCG (canonical)
        # and surface KBKotor for review.
        name = None
        name_source = None
        if fz and fz.get('name'):
            name = fz['name']
            name_source = 'fzocg-sekundarna'
            stats['names_from_fzocg'] += 1
        elif kbkotor_name:
            name = kbkotor_name
            name_source = 'kbkotor-paddle'
            stats['names_from_kbkotor'] += 1
        else:
            name = None
            name_source = None

        # Pick section: from FZOCG
        section = fz.get('section') if fz else None
        subsection = fz.get('subsection') if fz else None
        # Fall back to KBKotor's parsed section name (less clean)
        if not section:
            section = p_it.get('section_name')

        if fz:
            stats['codes_in_fzocg'] += 1
        else:
            stats['codes_not_in_fzocg'] += 1
            not_in_fzocg_codes.append(code)

        # Cross-validation: KBKotor price should ≈ FZOCG price × multiplier.
        # FZOCG has multiple price fields; pick the most relevant one.
        xval_status = None
        if fz and kbkotor_price is not None and kbkotor_price > 0:
            # For ambulanta multiplier, expect KBKotor ≈ FZOCG ambulanta × 3
            # For odjeljenja multiplier, expect KBKotor ≈ FZOCG odjeljenje × 2.5
            if cfg['type'] == 'ambulanta':
                fz_base = fz.get('price_ambulanta_eur') or fz.get('price_eur') or fz.get('price_odjeljenje_eur')
            else:
                fz_base = fz.get('price_odjeljenje_eur') or fz.get('price_eur') or fz.get('price_ambulanta_eur')
            if fz_base is not None and fz_base > 0:
                expected = fz_base * multiplier
                diff = abs(expected - kbkotor_price)
                if diff < max(0.5, 0.05 * expected):
                    xval_status = 'match'
                    stats[f'price_xval_match_{int(multiplier*10)}x' if multiplier == 2.5 else 'price_xval_match_3x'] += 1
                else:
                    xval_status = 'mismatch'
                    stats['price_xval_mismatch'] += 1
                    if len(xval_mismatches) < 50:
                        xval_mismatches.append({
                            'code': code,
                            'kbkotor': kbkotor_price,
                            'fzocg_base': fz_base,
                            'expected': round(expected, 2),
                            'diff': round(diff, 2),
                            'name': (name or '')[:60],
                        })

        item = {
            'code': code,
            'name': name,
            'price_eur': kbkotor_price,
            'mat_tros_eur': p_it.get('mat_tros_eur'),
            'section': section,
            'subsection': subsection,
            'page': p_it.get('page'),
            '_sources': {
                'name': name_source,
                'price': 'kbkotor-paddle',
                'section': 'fzocg-sekundarna' if (fz and fz.get('section')) else ('kbkotor-paddle' if section else None),
                'xval_vs_fzocg': xval_status,
            },
        }
        # Surface KBKotor name when FZOCG won but the OCR readings differ enough
        # that human review may help.
        if name_source == 'fzocg-sekundarna' and kbkotor_name:
            if norm_name(kbkotor_name) != norm_name(name):
                item['name_kbkotor_paddle'] = kbkotor_name

        items.append(item)

    # Sort by section then code
    items.sort(key=lambda it: (str(it.get('section') or 'zzz'), it.get('code') or ''))

    payload = dict(INSTITUTION_META)
    payload['category'] = slug
    payload['type']     = cfg['type']
    payload['multiplier_vs_fzocg'] = multiplier
    payload['bod_value_eur'] = cfg['bod_value']
    payload['source_pdf'] = paddle.get('source_paddle_json', '').split('/')[-1].replace('.items.json', '.pdf')
    payload['merge_info'] = {
        'merge_date': date.today().isoformat(),
        'paddle_engine': 'paddleocr 3.5.0 / PP-StructureV3',
        'paddle_items': paddle['items_total'],
        'fzocg_source': str(FZOCG_SOURCE.relative_to(ROOT)).replace('\\','/'),
        'final_items': len(items),
        **stats,
    }
    if not_in_fzocg_codes:
        payload['merge_info']['not_in_fzocg_codes'] = not_in_fzocg_codes
    if alias_resolved:
        payload['merge_info']['ocr_alias_resolved'] = [
            {'kbkotor': p, 'fzocg': f} for p, f in alias_resolved
        ]
    if xval_mismatches:
        payload['merge_info']['xval_mismatch_sample'] = xval_mismatches[:20]

    payload['items_total'] = len(items)
    payload['items'] = items

    out_path = ROOT / 'data' / 'kbkotor' / slug / f'{slug}-FINAL.json'
    with open(out_path, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    return out_path, payload


def main():
    fzocg = json.load(open(FZOCG_SOURCE, encoding='utf-8'))
    fzocg_by_code = {it['code']: it for it in fzocg['items']}
    print(f'FZOCG sekundarna reference: {len(fzocg_by_code)} codes\n')

    for slug, cfg in PRICELISTS.items():
        out, payload = build_pricelist(slug, cfg, fzocg_by_code)
        info = payload['merge_info']
        print(f'=== {slug} → {out.relative_to(ROOT)} ===')
        print(f'  paddle_items : {info["paddle_items"]}')
        print(f'  final_items  : {info["final_items"]}')
        print(f'  in FZOCG     : {info["codes_in_fzocg"]}')
        print(f'  not in FZOCG : {info["codes_not_in_fzocg"]}')
        print(f'  names: fzocg={info["names_from_fzocg"]}, kbkotor={info["names_from_kbkotor"]}')
        print(f'  xval: matches={info.get("price_xval_match_3x",0)+info.get("price_xval_match_25x",0)}  mismatches={info["price_xval_mismatch"]}')
        print()


if __name__ == '__main__':
    main()
