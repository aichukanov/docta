"""
Merge paddle (ambulanta-2019.json) with the independent LLM transcription
(llm/pages-*.json) -> ambulanta-2019-final.json + _VERIFY_LIST.md.

Price decision per code:
  paddle == llm                          -> accepted ('both')
  differ, one equals Danilo or 3xFZOCG   -> that one ('xcheck')
  only one source has the row            -> that one if cross-checked, else VERIFY
  otherwise                              -> VERIFY (manual look at the page)
Name: LLM (diacritics), paddle as fallback. Section: LLM.
Manual decisions after looking at the page go to manual-fixes.json
({code: {"price": .., "name": .., "drop": true, "why": ..}}) and win over everything.
"""
import json, glob, csv, re, sys
from pathlib import Path
sys.stdout.reconfigure(encoding='utf-8')

def price(s):
    if s in (None, ''):
        return None
    if isinstance(s, (int, float)):
        return round(float(s), 2)
    s = s.strip().replace(' ', '')
    m = re.match(r'^(.*)[.,](\d{2})$', s)
    if not m:
        return None
    return round(float(re.sub(r'[.,]', '', m.group(1)) + '.' + m.group(2)), 2)

paddle = {i['code']: i for i in json.load(open('ambulanta-2019.json', encoding='utf-8'))['items']}
llm, llm_dups = {}, []
for f in sorted(glob.glob('llm/pages-*.json')):
    for pg in json.load(open(f, encoding='utf-8'))['pages']:
        for r in pg['rows']:
            code = r['code'].strip().replace(' ', '').upper()
            row = {'code': code, 'name': r['name'].strip(), 'price': price(r.get('price')), 'section': r.get('section'),
                   'page': pg['page'], 'unsure': r.get('unsure'), 'file': Path(f).name}
            if code in llm:
                llm_dups.append((code, llm[code]['page'], llm[code]['price'], pg['page'], row['price']))
                if llm[code]['price'] == row['price']:
                    continue
                row['dup_of'] = llm[code]
            llm[code] = row
manual = json.load(open('manual-fixes.json', encoding='utf-8')) if Path('manual-fixes.json').exists() else {}

danilo = {i['code']: i['price_eur'] for i in json.load(open('../bolnica-danilo-cetinje/_full.json', encoding='utf-8'))['items']}
fz = {}
with open('ref/tariffs.tsv', encoding='utf-8') as f:
    for t in csv.DictReader(f, delimiter='\t'):
        if t['tariff_source'] == 'fzocg-sekundarna':
            fz[t['code']] = [float(t[c]) for c in ('price_ambulanta_eur', 'price_odjeljenje_eur', 'price_eur', 'price_ukupno_eur') if t[c] not in ('', 'NULL')]

def xok(code, p):
    if p is None:
        return False
    if danilo.get(code) and abs(danilo[code] - p) < 0.015:
        return True
    return any(abs(round(3 * v, 2) - p) < 0.015 for v in fz.get(code, []))

final, verify = [], []
for code in sorted(set(paddle) | set(llm)):
    P, L = paddle.get(code), llm.get(code)
    pp, lp = (P or {}).get('price_eur'), (L or {}).get('price')
    row = {'code': code, 'name': (L or {}).get('name') or (P or {}).get('name'), 'name_paddle': (P or {}).get('name'),
           'section': (L or {}).get('section') or (P or {}).get('section'), 'page': (L or P)['page']}
    if P and L and pp is not None and pp == lp:
        row['price_eur'], row['price_src'] = pp, 'both'
    elif P and L and xok(code, lp) and not xok(code, pp):
        row['price_eur'], row['price_src'] = lp, 'llm+xcheck'
    elif P and L and xok(code, pp) and not xok(code, lp):
        row['price_eur'], row['price_src'] = pp, 'paddle+xcheck'
    elif L and not P and xok(code, lp):
        row['price_eur'], row['price_src'] = lp, 'llm-only+xcheck'
    elif P and not L and xok(code, pp):
        row['price_eur'], row['price_src'] = pp, 'paddle-only+xcheck'
    else:
        row['price_eur'], row['price_src'] = (lp if lp is not None else pp), 'VERIFY'
        row['candidates'] = {'paddle': pp if P else 'absent', 'llm': lp if L else 'absent',
                             'danilo': danilo.get(code), 'fzocg_x3': [round(3 * v, 2) for v in fz.get(code, [])]}
    if L and L.get('unsure'):
        row['unsure'] = L['unsure']
    if L and L.get('dup_of'):
        row['llm_duplicate'] = {'page': L['dup_of']['page'], 'price': L['dup_of']['price']}
    if code in manual:
        m = manual[code]
        if m.get('drop'):
            continue
        for k in ('price_eur', 'name', 'section'):
            if k in m:
                row[k] = m[k]
        row['price_src'] = 'manual'
        row['manual_why'] = m.get('why')
    if row['price_src'] == 'VERIFY':
        verify.append(row)
    final.append(row)

final.sort(key=lambda r: (r['page'], r['code']))
json.dump({'items_total': len(final), 'items': final}, open('ambulanta-2019-final.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
with open('_VERIFY_LIST.md', 'w', encoding='utf-8') as f:
    f.write('# KCCG 2019: строки для ручной проверки по скану\n\n| page | code | name | paddle | llm | danilo | 3×FZOCG |\n|---|---|---|---|---|---|---|\n')
    for r in sorted(verify, key=lambda r: (r['page'], r['code'])):
        c = r['candidates']
        f.write(f"| {r['page']} | {r['code']} | {r['name']} | {c['paddle']} | {c['llm']} | {c['danilo']} | {c['fzocg_x3']} |\n")
from collections import Counter
print('final', len(final), Counter(r['price_src'] for r in final))
print('only paddle', sorted(c for c in paddle if c not in llm))
print('only llm', sorted(c for c in llm if c not in paddle))
print('llm duplicates', llm_dups)
