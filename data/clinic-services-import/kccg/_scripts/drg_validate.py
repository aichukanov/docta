"""
DRG rows of a KCCG pricelist: recover rows paddle mangled, then check every row
against price = coefficient x base. The base is printed in the document
(2025: 1.900,45; 2019: derived, 1.103,32).

Also compares against FZOCG DRG (medical_service_tariffs, tariff_source fzocg-drg):
the coefficient must be the same, the KCCG base is a multiple of FZOCG's 760.18.

Usage: py -3.12 drg_validate.py <items.json> <base> <out-FINAL.json>
"""
import sys, re, json, csv
from collections import Counter
sys.stdout.reconfigure(encoding='utf-8')

inp, base, out = sys.argv[1], float(sys.argv[2]), sys.argv[3]
d = json.load(open(inp, encoding='utf-8'))

DRG_RE = r'(?:[A-Z]\d{2}|\d{3})[A-Z]'
NUM_RE = r'\d{1,3}(?:[.,:;]\d{3})*[.,:;]\d{2}|\d+[.,]\d{2}'

def num(s):
    s = s.replace(':', '.').replace(';', '.')
    # last separator is the decimal one
    m = re.match(r'^(.*)[.,](\d{2})$', s)
    if not m:
        return None
    return round(float(re.sub(r'[.,]', '', m.group(1)) + '.' + m.group(2)), 2)

def fix_code(c):
    c = c.upper()
    # 8 read for B, 1 read for I at start, 0 for O
    if re.match(r'^\d{3}[A-Z]$', c) and c[0] in '1' and not c.startswith('80') and not c.startswith('96'):
        c = 'I' + c[1:]
    if re.match(r'^[A-Z]\d{2}8$', c):
        c = c[:3] + 'B'
    if c[0] == '0' and re.match(r'^0\d{2}[A-Z]$', c):
        c = 'O' + c[1:]
    return c

rows = []
for it in d['items']:
    if it['kind'] != 'drg':
        continue
    rows.append({'code': it['code'], 'text': it.get('name', ''), 'coefficient': it.get('coefficient'),
                 'price_eur': it.get('price_eur'), 'page': it['page'], 'section': it.get('section'),
                 'recovered': it.get('recovered', False)})
for u in d['unparsed_rows']:
    t = u['text'].strip()
    m = re.match(rf'^:?\s*(.*?)\s+({NUM_RE})\s+({NUM_RE})\.?\s+({DRG_RE})\s*$', t) or None
    if m:
        rows.append({'code': m.group(4), 'text': m.group(1), 'page': u['page'], 'section': None, 'recovered': True,
                     'coefficient': num(m.group(2)), 'price_eur': num(m.group(3))})
        continue
    m = re.match(rf'^({DRG_RE}|[A-Z]\d{{3}})[.:]?\s+(.*)$', t)
    if m:
        rows.append({'code': m.group(1), 'text': m.group(2), 'page': u['page'], 'section': None, 'recovered': True})

ok, fixed, bad = 0, 0, []
final = []
for r in rows:
    r['code'] = fix_code(r['code'])
    text = r['text']
    nums = re.findall(NUM_RE, text)
    name = text
    if nums:
        # strip trailing numbers from the name
        name = re.sub(rf'(\s*({NUM_RE})\.?\s*[:]?)+\s*$', '', text).strip()
        if r.get('coefficient') is None and len(nums) >= 1:
            r['coefficient'] = num(nums[0]) if len(nums) >= 1 else None
        if len(nums) >= 2 and r.get('price_eur') in (None,) or (len(nums) >= 2 and r.get('price_eur') is not None and r['price_eur'] < 1):
            r['price_eur'] = num(nums[1])
    r['name'] = re.sub(r'\s+', ' ', name).strip(' .:')
    k, p = r.get('coefficient'), r.get('price_eur')
    status = None
    if k is not None and p is not None and abs(round(k * base, 2) - p) <= 0.02:
        status = 'ok'; ok += 1
    elif k is not None:
        # trust the coefficient (2 digits, short), recompute the price
        r['price_printed_ocr'] = p
        r['price_eur'] = round(k * base, 2)
        status = 'recomputed_from_coefficient'; fixed += 1
    elif p is not None and abs(p / base - round(p / base, 2)) * base <= 0.02:
        r['coefficient'] = round(p / base, 2)
        status = 'coefficient_from_price'; fixed += 1
    else:
        status = 'unverified'; bad.append(r)
    r['check'] = status
    final.append(r)

# FZOCG DRG cross-check: same coefficient expected
fz = {}
with open('ref/tariffs.tsv', encoding='utf-8') as f:
    for t in csv.DictReader(f, delimiter='\t'):
        if t['tariff_source'] == 'fzocg-drg':
            fz[t['code']] = t
coef_same = coef_diff = not_in_fz = 0
diffs = []
for r in final:
    t = fz.get(r['code'])
    if not t:
        not_in_fz += 1; r['fzocg'] = None; continue
    fk = float(t['coefficient']) if t['coefficient'] not in ('', 'NULL') else None
    r['fzocg'] = {'coefficient': fk, 'price_eur': float(t['price_eur']) if t['price_eur'] not in ('', 'NULL') else None, 'name': t['name_sr_latin']}
    if fk is not None and r.get('coefficient') is not None and abs(fk - r['coefficient']) < 0.005:
        coef_same += 1
    else:
        coef_diff += 1; diffs.append((r['code'], r.get('coefficient'), fk))

dup = [c for c, n in Counter(r['code'] for r in final).items() if n > 1]
json.dump({'source': d['source'], 'base_eur': base, 'items_total': len(final),
           'checks': {'ok': ok, 'fixed': fixed, 'unverified': len(bad), 'duplicates': dup,
                      'fzocg_same_coefficient': coef_same, 'fzocg_diff_coefficient': coef_diff, 'not_in_fzocg': not_in_fz},
           'items': final}, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(f'rows {len(final)} ok {ok} fixed {fixed} unverified {len(bad)} dup {dup}')
print(f'fzocg: same coef {coef_same}, diff {coef_diff}, not in fzocg {not_in_fz}')
print('diffs', diffs[:20])
for b in bad[:20]:
    print('BAD', b)
