"""
2019 ambulatory rows: paddle items + rows recovered from `unparsed_rows`
-> ambulanta-2019.json (one row per code).

Recovery patterns in unparsed rows:
  "<name> <price> <CODE>"          code printed last (cells reordered by paddle)
  "<CODE>[.] <name> <price>"       code with OCR digit for the letter: 2->Z, 1->I, 0->O, 8->B
"""
import json, re, sys
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')

d = json.load(open('paddleocr/cjenovnik-2019.items.json', encoding='utf-8'))
PRICE = r'\d{1,3}(?:\.\d{3})*[,.]\d{2}|\d+[,.]\d{2}'
CODE = r'[A-Z0-9]\s?\d{5}'
LETTER_FOR_DIGIT = {'2': 'Z', '1': 'I', '0': 'O', '8': 'B', '5': 'S'}

def norm_code(c):
    c = c.replace(' ', '').upper()
    if re.match(r'^\d{6}$', c) and c[0] in LETTER_FOR_DIGIT:
        c = LETTER_FOR_DIGIT[c[0]] + c[1:]
    return c if re.match(r'^[A-Z]\d{5}$', c) else None

def price(s):
    s = s.strip()
    m = re.match(r'^(.*)[.,](\d{2})$', s)
    return round(float(re.sub(r'[.,]', '', m.group(1)) + '.' + m.group(2)), 2)

items = []
for it in d['items']:
    if it['kind'] != 'ambulanta':
        continue
    items.append({'code': it['code'], 'name': it.get('name', ''), 'price_eur': it.get('price_eur'),
                  'section': it.get('section'), 'page': it['page'], 'recovered': bool(it.get('recovered'))})

rec, left = 0, []
for u in d['unparsed_rows']:
    t = re.sub(r'\s+', ' ', u['text']).strip()
    m = re.match(rf'^(.*?)\s+({PRICE})\s+({CODE})\.?$', t)
    if m and norm_code(m.group(3)):
        items.append({'code': norm_code(m.group(3)), 'name': m.group(1).strip(' .'), 'price_eur': price(m.group(2)),
                      'section': None, 'page': u['page'], 'recovered': True, 'raw': t}); rec += 1; continue
    m = re.match(rf'^({CODE})[.:]?\s+(.*?)\s+({PRICE})$', t)
    if m and norm_code(m.group(1)):
        items.append({'code': norm_code(m.group(1)), 'name': m.group(2).strip(' .'), 'price_eur': price(m.group(3)),
                      'section': None, 'page': u['page'], 'recovered': True, 'raw': t}); rec += 1; continue
    left.append(u)

# section of recovered rows: inherit from the nearest earlier row on the same page
by_page = {}
for it in items:
    if it['section']:
        by_page.setdefault(it['page'], it['section'])
for it in items:
    if not it['section']:
        it['section'] = by_page.get(it['page'])

# collapse duplicates: identical rows -> one; conflicting -> keep all for review
groups = {}
for it in items:
    groups.setdefault(it['code'], []).append(it)
out, conflicts = [], {}
for code, g in groups.items():
    prices = {x['price_eur'] for x in g if x['price_eur'] is not None}
    best = sorted(g, key=lambda x: (x['recovered'], x['price_eur'] is None))[0]
    if len(prices) > 1:
        conflicts[code] = [(x['page'], x['name'], x['price_eur']) for x in g]
        best = dict(best, conflict=[(x['page'], x['name'], x['price_eur']) for x in g])
    out.append(best)
out.sort(key=lambda x: (x['page'], x['code']))
json.dump({'source': '2026-10-02-cjenovnik-2019.pdf (paddle + recovery)', 'items_total': len(out), 'items': out,
           'unrecovered_rows': left}, open('ambulanta-2019.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('items', len(out), 'recovered from unparsed', rec, 'left', len(left), 'no price', sum(1 for x in out if x['price_eur'] is None))
print('conflicting duplicates', conflicts)
for u in left:
    print('LEFT', u)
