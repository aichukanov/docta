"""DRG 2025: paddle (drg-2025.json) + LLM transcription (llm-drg/pages-*.json) -> drg-2025-final.json.
Coefficient: paddle == llm, or the one that equals FZOCG; price = coefficient x 1900.45, checked against
the printed price of either source. Name: LLM (diacritics)."""
import json, glob, csv, re, sys
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')
BASE = 1900.45

def num(s):
    if s in (None, ''): return None
    if isinstance(s, (int, float)): return round(float(s), 2)
    m = re.match(r'^(.*)[.,](\d{2})$', s.strip().replace(' ', ''))
    return round(float(re.sub(r'[.,]', '', m.group(1)) + '.' + m.group(2)), 2) if m else None

paddle = {r['code']: r for r in json.load(open('drg-2025.json', encoding='utf-8'))['items']}
llm = {}
for f in sorted(glob.glob('llm-drg/pages-*.json')):
    for pg in json.load(open(f, encoding='utf-8'))['pages']:
        for r in pg['rows']:
            c = r['code'].strip().upper().replace(' ', '')
            llm[c] = {'name': r['name'].strip(), 'coef': num(r.get('coefficient')), 'price': num(r.get('price')),
                      'section': r.get('section'), 'page': pg['page'], 'unsure': r.get('unsure')}
fz = {t['code']: t for t in csv.DictReader(open('ref/tariffs.tsv', encoding='utf-8'), delimiter='\t') if t['tariff_source'] == 'fzocg-drg'}

out, verify = [], []
for code in sorted(set(paddle) | set(llm)):
    P, L = paddle.get(code), llm.get(code)
    fk = float(fz[code]['coefficient']) if code in fz and fz[code]['coefficient'] not in ('', 'NULL') else None
    pk, lk = (P or {}).get('coefficient'), (L or {}).get('coef')
    printed = {x for x in ((P or {}).get('price_printed_ocr'), (P or {}).get('price_eur'), (L or {}).get('price')) if x is not None}
    if pk is not None and pk == lk:
        k, src = pk, 'both'
    elif lk is not None and fk is not None and abs(lk - fk) < 0.005:
        k, src = lk, 'llm=fzocg'
    elif pk is not None and fk is not None and abs(pk - fk) < 0.005:
        k, src = pk, 'paddle=fzocg'
    else:
        k, src = (lk if lk is not None else pk), 'VERIFY'
    price = round(k * BASE, 2) if k is not None else None
    price_ok = price is not None and any(abs(price - p) <= 0.02 for p in printed)
    row = {'code': code, 'name': (L or {}).get('name') or (P or {}).get('name'), 'section': (L or {}).get('section') or (P or {}).get('section'),
           'page': (L or P)['page'], 'coefficient': k, 'price': price, 'coef_src': src, 'price_matches_print': price_ok,
           'fzocg_coefficient': fk, 'fzocg_name': fz[code]['name_sr_latin'] if code in fz else None,
           'in': 'both' if P and L else ('paddle' if P else 'llm')}
    if L and L.get('unsure'): row['unsure'] = L['unsure']
    if src == 'VERIFY' or not price_ok or row['in'] != 'both':
        verify.append(row)
    out.append(row)
out.sort(key=lambda r: (r['page'], r['code']))
json.dump({'base_eur': BASE, 'items_total': len(out), 'items': out}, open('drg-2025-final.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('rows', len(out), Counter(r['coef_src'] for r in out), 'price!=print', sum(1 for r in out if not r['price_matches_print']))
print('fzocg codes absent', [c for c in fz if c not in {r['code'] for r in out}])
for v in verify:
    print('CHECK', v['code'], v['in'], v['coef_src'], v['coefficient'], v['price'], 'fz', v['fzocg_coefficient'], '|', (v['name'] or '')[:60], v.get('unsure', ''))
