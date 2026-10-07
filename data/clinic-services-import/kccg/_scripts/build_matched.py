"""
KCCG ambulatory pricelist -> one row per code with the effective price and
its catalog target.

Inputs (relative to data/clinic-services-import/kccg):
  ambulanta-2019.json            cleaned 2019 ambulatory rows (code, name, price_eur, section, page)
  izmjene-2025-ambulanta.json    2025 amendments, manual transcription
  ref/hospital-services.tsv      codes of hospitals 88/141/131/137 -> medical_services
  ref/hospital-labtests.tsv      same -> lab_tests
  ref/tariffs.tsv                medical_service_tariffs dump
  ../bolnica-danilo-cetinje/_full.json   Danilo pricelist (3 x FZOCG ambulanta, 2019)

Output: matched.json
"""
import json, csv, sys
from collections import Counter, defaultdict
sys.stdout.reconfigure(encoding='utf-8')

def tsv(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f, delimiter='\t'))

def num(v):
    return None if v in (None, '', 'NULL') else float(v)

a19 = json.load(open('ambulanta-2019-final.json', encoding='utf-8'))['items']
a25 = {i['code']: i for i in json.load(open('izmjene-2025-ambulanta.json', encoding='utf-8'))['items']}
danilo = {i['code']: i for i in json.load(open('../bolnica-danilo-cetinje/_full.json', encoding='utf-8'))['items']}

# code -> catalog target, by vote of hospitals that hold this code
votes = defaultdict(Counter)
info = {}
for r in tsv('ref/hospital-services.tsv'):
    key = ('ms', int(r['ms_id']))
    for c in r['code'].split('/'):
        votes[c.strip()][key] += 1
    info[key] = {'slug': r['slug'], 'name_en': r['name_en'], 'name_sr': r['name_sr']}
for r in tsv('ref/hospital-labtests.tsv'):
    key = ('lt', int(r['lt_id']))
    for c in r['code'].split('/'):
        votes[c.strip()][key] += 1
    info[key] = {'slug': r['slug'], 'name_en': r['name_en'], 'name_sr': r['name_sr']}

tariffs = {}
for t in tsv('ref/tariffs.tsv'):
    if t['tariff_source'] == 'fzocg-sekundarna':
        tariffs[t['code']] = t

rows = []
# codes that appear only in the 2025 amendments (orthopedist exams were printed in 2019
# under the neurosurgeon codes S07001/S07002; G09001 is absent from 2019)
codes19 = {i['code'] for i in a19}
only25 = [{'code': c, 'name': i['name'], 'section': '(2025)', 'page': None, 'price_eur': None, 'only_2025': True}
          for c, i in a25.items() if c not in codes19]

for it in a19 + only25:
    code = it['code']
    r = {'code': code, 'name_kccg': it['name'], 'section': it.get('section'), 'page': it['page'],
         'price_2019': it.get('price_eur')}
    if it.get('only_2025'):
        r['only_2025'] = True
    if code in a25:
        r['price_2025'] = a25[code]['price_eur']
        if a25[code].get('note'):
            r['note_2025'] = a25[code]['note']
    r['price'] = r.get('price_2025', r['price_2019'])
    r['changed_2025'] = code in a25

    # cross-checks of the 2019 price
    d = danilo.get(code)
    r['danilo_price'] = d['price_eur'] if d else None
    t = tariffs.get(code)
    if t:
        r['fzocg'] = {'scheme': t['scheme'], 'amb': num(t['price_ambulanta_eur']), 'odj': num(t['price_odjeljenje_eur']),
                      'single': num(t['price_eur']), 'ukupno': num(t['price_ukupno_eur']), 'name': t['name_sr_latin'],
                      'ms_id': num(t['medical_service_id']), 'lt_id': num(t['lab_test_id'])}
    p = r['price_2019']
    checks = []
    if p is not None and d and d['price_eur']:
        checks.append('danilo=' if abs(d['price_eur'] - p) < 0.015 else 'danilo!=')
    if p is not None and t:
        for col in ('amb', 'odj', 'single', 'ukupno'):
            v = r['fzocg'][col]
            if v:
                ratio = round(p / v, 3)
                r.setdefault('fzocg_ratio', {})[col] = ratio
    r['xcheck'] = checks

    # catalog target
    v = votes.get(code)
    if v:
        (kind, cid), n = v.most_common(1)[0]
        r['target'] = {'kind': kind, 'id': cid, **info[(kind, cid)], 'via': 'hospital-code', 'votes': dict((f'{k}:{i}', c) for (k, i), c in v.items())}
    elif t and (t['medical_service_id'] not in ('', 'NULL') or t['lab_test_id'] not in ('', 'NULL')):
        if t['medical_service_id'] not in ('', 'NULL'):
            r['target'] = {'kind': 'ms', 'id': int(t['medical_service_id']), 'via': 'fzocg-link'}
        else:
            r['target'] = {'kind': 'lt', 'id': int(t['lab_test_id']), 'via': 'fzocg-link'}
    else:
        r['target'] = None
    rows.append(r)

# stacionar: DRG groups of the 2025 amendments (price = coefficient x 1900.45), all priced by 2025
drg_links = {}
for r in tsv('ref/drg-links.tsv'):
    drg_links.setdefault(r['code'], int(r['id']))
for g in json.load(open('drg-2025-final.json', encoding='utf-8'))['items']:
    r = {'code': g['code'], 'name_kccg': g['name'], 'section': g['section'], 'page': g['page'], 'drg': True,
         'coefficient': g['coefficient'], 'price_2019': None, 'price_2025': g['price'], 'price': g['price'],
         'changed_2025': True, 'xcheck': [], 'danilo_price': None}
    r['target'] = {'kind': 'ms', 'id': drg_links[g['code']], 'via': 'drg-link'} if g['code'] in drg_links else None
    rows.append(r)

json.dump({'items_total': len(rows), 'items': rows}, open('matched.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

c = Counter((r['target'] or {}).get('via', 'none') for r in rows)
print('rows', len(rows), dict(c))
print('2025 applied', sum(r['changed_2025'] for r in rows), 'of', len(a25), '| 2025 codes not in 2019:', [k for k in a25 if k not in {r['code'] for r in rows}])
x = Counter(tuple(r['xcheck']) for r in rows)
print('danilo xcheck', dict(x))
ratios = Counter()
for r in rows:
    for col, v in (r.get('fzocg_ratio') or {}).items():
        ratios[(col, v)] += 1
print('fzocg ratios top', ratios.most_common(15))
