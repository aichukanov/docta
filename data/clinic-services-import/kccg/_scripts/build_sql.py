"""
matched.json + match/out/*.json -> server/sql/insert-clinic-prices-klinicki-centar-crne-gore-podgorica.sql
plus final.json (one row per catalog entry) and new-entries.json (catalog additions).

Run from data/clinic-services-import/kccg:
  py -3.12 _scripts/build_sql.py
"""
import json, csv, glob, re, subprocess, sys
from collections import defaultdict, Counter
from pathlib import Path
sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path('../../..').resolve()          # nuxt/
SQL_OUT = ROOT / 'server/sql/insert-clinic-prices-klinicki-centar-crne-gore-podgorica.sql'
CLINIC_SLUG = 'klinicki-centar-crne-gore-podgorica'
OUTDATED_2019 = 0    # user 2026-10-06: age alone is not a reason; KCCG republished the 2019 pricelist in 2026-08 as current

def tsv(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f, delimiter='\t'))

def enum(path):
    return {m.group(1): int(m.group(2)) for m in re.finditer(r'(\w+)\s*=\s*(\d+)', (ROOT / path).read_text(encoding='utf-8'))}

SVC_CAT, LAB_CAT, SPEC = enum('enums/medical-service-category.ts'), enum('enums/labtest-category.ts'), enum('enums/specialty.ts')
# category -> specialty (CLINIC_SERVICES_IMPORT.md 1.5)
CAT_SPEC = {'CARDIOLOGY': 'CARDIOLOGY', 'GASTROENTEROLOGY': 'GASTROENTEROLOGY', 'GYNECOLOGY': 'GYNECOLOGY_OBSTETRICS',
            'GENERAL_MEDICINE': 'GENERAL_MEDICINE', 'ORTHOPEDICS': 'ORTHOPEDICS_TRAUMATOLOGY', 'ENT': 'OTORHINOLARYNGOLOGY',
            'PULMONOLOGY': 'PULMONOLOGY', 'NEUROLOGY': 'NEUROLOGY', 'UROLOGY': 'UROLOGY', 'OPHTHALMOLOGY': 'OPHTHALMOLOGY',
            'DERMATOLOGY': 'DERMATOVENEROLOGY', 'PEDIATRICS': 'PEDIATRICS', 'ENDOCRINOLOGY': 'ENDOCRINOLOGY',
            'ALLERGOLOGY': 'ALLERGOLOGY', 'DENTISTRY': 'DENTISTRY', 'ORTHODONTICS': 'ORTHODONTIST',
            'PEDIATRIC_DENTISTRY': 'PEDIATRIC_DENTISTRY', 'PLASTIC_SURGERY': 'PLASTIC_SURGERY',
            'GENERAL_SURGERY': 'GENERAL_SURGERY', 'PHYSIOTHERAPY': 'PHYSICAL_MEDICINE',
            'OPHTHALMIC_SURGERY': 'OPHTHALMIC_SURGERY', 'ABDOMINAL_SURGERY': 'GASTROINTESTINAL_SURGERY', 'PODOLOGY': 'PODIATRY'}

cat_svc = {int(r['id']): r for r in tsv('ref/catalog-services.tsv')}
cat_lab = {int(r['id']): r for r in tsv('ref/catalog-labtests.tsv')}
slug_svc = {r['slug']: r for r in cat_svc.values()}
slug_lab = {r['slug']: r for r in cat_lab.values()}
name_svc = {r['name_en'].lower() for r in cat_svc.values()}
name_lab = {r['name_en'].lower() for r in cat_lab.values()}

rows = json.load(open('matched.json', encoding='utf-8'))['items']
decisions = {}
for f in sorted(glob.glob('match/out/*.json') + glob.glob('match-drg/out/*.json')):
    for it in json.load(open(f, encoding='utf-8'))['items']:
        it['_batch'] = Path(f).stem
        decisions[it['code']] = it
# my overrides after review (match/overrides.json: {code: {decision fields}})
if Path('match/overrides.json').exists():
    overrides = json.load(open('match/overrides.json', encoding='utf-8'))
    for code, o in overrides.items():
        if code.startswith('_'):
            continue
        base = decisions.get(code, {})
        if 'copy_from' in o:
            src = decisions[o['copy_from']]
            base = {**base, **{k: v for k, v in src.items() if k not in ('code', 'note', '_batch')}}
        decisions[code] = {**base, **{k: v for k, v in o.items() if k != 'copy_from'},
                           '_batch': base.get('_batch', 'override'), 'override_why': o.get('why')}

# parallel batches may name the same new service differently: one name_sr (folded) -> one entry
def fold(s):
    import unicodedata
    s = unicodedata.normalize('NFKD', (s or '').lower())
    return re.sub(r'[^a-z0-9]+', ' ', ''.join(c for c in s if not unicodedata.combining(c))).strip()
unify_log = []
first_by_sr = {}
for code in sorted(decisions):
    d = decisions[code]
    if d.get('decision') != 'new':
        continue
    k = (d['kind'], fold(d['name_sr']))
    if k in first_by_sr and first_by_sr[k]['slug'] != d['slug']:
        f0 = first_by_sr[k]
        unify_log.append(f"{code} {d['name_en']} -> {f0['name_en']} ({d['_batch']} -> {f0['_batch']})")
        for fld in ('name_en', 'slug', 'name_sr', 'name_ru', 'name_de', 'name_tr', 'categories', 'specialties', 'synonyms', 'sort_order'):
            d[fld] = f0.get(fld)
    else:
        first_by_sr.setdefault(k, d)

problems, excluded, new_entries = [], [], {}
groups = defaultdict(list)          # (kind, slug) -> rows
for r in rows:
    t = r['target']
    if t:
        kind = 'ms' if t['kind'] == 'ms' else 'lt'
        cat = cat_svc if kind == 'ms' else cat_lab
        if t['id'] not in cat:
            problems.append(f"{r['code']}: target id {t['id']} not in catalog dump"); continue
        slug = cat[t['id']]['slug']
        r['via'] = t['via']
    else:
        d = decisions.get(r['code'])
        if not d:
            problems.append(f"{r['code']}: no decision"); continue
        kind = 'ms' if d['kind'] == 'medical_service' else 'lt'
        if d['decision'] == 'doubtful':
            excluded.append({'source': f"{r['code']} {r['name_kccg']} — {r['price']}", 'reason': d.get('note') or 'doubtful', 'batch': d['_batch']}); continue
        if d['decision'] == 'existing':
            cat, by_slug = (cat_svc, slug_svc) if kind == 'ms' else (cat_lab, slug_lab)
            slug = d.get('slug')
            if slug not in by_slug:
                problems.append(f"{r['code']}: existing slug '{slug}' not in {kind} catalog ({d['_batch']})"); continue
            if d.get('id') and int(d['id']) != int(by_slug[slug]['id']):
                problems.append(f"{r['code']}: id {d['id']} != id of slug {slug}")
            r['via'] = 'name-match'
        elif d['decision'] == 'new':
            slug = d['slug']
            key = (kind, slug)
            by_slug = slug_svc if kind == 'ms' else slug_lab
            by_name = {r['name_en'].lower(): r for r in (cat_svc if kind == 'ms' else cat_lab).values()}
            hit = by_slug.get(slug) or by_name.get(d['name_en'].lower())
            if hit:
                # appeared in the catalog after the batch was matched (other imports) — same name = same record
                unify_log.append(f"{r['code']} NEW {d['name_en']} -> existing {hit['id']} {hit['slug']}")
                slug = hit['slug']; r['via'] = 'name-match'
                groups[(kind, slug)].append(r)
                continue
            if key in new_entries:
                if new_entries[key]['name_en'] != d['name_en']:
                    problems.append(f"{r['code']}: slug {slug} reused with another name_en")
            else:
                if slug in (slug_svc if kind == 'ms' else slug_lab) or d['name_en'].lower() in (name_svc if kind == 'ms' else name_lab):
                    problems.append(f"{r['code']}: NEW collides with catalog: {slug} / {d['name_en']}")
                new_entries[key] = {**{k: d.get(k) for k in ('name_en', 'slug', 'name_sr', 'name_ru', 'name_de', 'name_tr',
                                                             'categories', 'specialties', 'synonyms', 'sort_order')},
                                    'kind': kind, 'codes': []}
            new_entries[key]['codes'].append(r['code'])
            r['via'] = 'new'
        else:
            problems.append(f"{r['code']}: bad decision {d['decision']}"); continue
    if r['price'] is None:
        problems.append(f"{r['code']}: no price"); continue
    groups[(kind, slug)].append(r)

# same name_en across kinds / duplicates among new entries
dup_names = [n for n, c in Counter(e['name_en'].lower() for e in new_entries.values()).items() if c > 1]
if dup_names:
    problems.append(f'new entries share name_en: {dup_names}')
for e in new_entries.values():
    for c in e.get('categories') or []:
        if c not in (SVC_CAT if e['kind'] == 'ms' else LAB_CAT):
            problems.append(f"{e['slug']}: unknown category {c}")
    for s in e.get('specialties') or []:
        if s not in SPEC:
            problems.append(f"{e['slug']}: unknown specialty {s}")

# sr_cyrl for new entries
tmp = Path('new-entries.raw.json')
json.dump(list(new_entries.values()), open(tmp, 'w', encoding='utf-8'), ensure_ascii=False)
subprocess.run(['node', 'data/clinic-services-import/kccg/_scripts/sr_cyrl.mjs',
                'data/clinic-services-import/kccg/new-entries.raw.json',
                'data/clinic-services-import/kccg/new-entries.json'], cwd=ROOT, check=True)
tmp.unlink()
new_list = json.load(open('new-entries.json', encoding='utf-8'))

final = []
for (kind, slug), rs in groups.items():
    prices = [x['price'] for x in rs]
    lo, hi = min(prices), max(prices)
    outdated = 0 if all(x['changed_2025'] for x in rs) else OUTDATED_2019
    final.append({'kind': kind, 'slug': slug, 'codes': [x['code'] for x in rs], 'price': lo, 'price_max': hi if hi != lo else None,
                  'is_price_outdated': outdated, 'via': sorted({x['via'] for x in rs}),
                  'source': [f"{x['code']} {x['name_kccg']} {x['price']}" for x in rs]})
order = {r['code']: i for i, r in enumerate(rows)}
final.sort(key=lambda f: order[f['codes'][0]])
json.dump({'rows': final, 'excluded': excluded, 'problems': problems}, open('final.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

# ── SQL ────────────────────────────────────────────────────────────────
def q(s):
    return "NULL" if s is None else "'" + str(s).replace('\\', '\\\\').replace("'", "''") + "'"
def money(v):
    return 'NULL' if v is None else f'{v:.2f}'

svc_rows = [f for f in final if f['kind'] == 'ms']
lab_rows = [f for f in final if f['kind'] == 'lt']
new_svc = [e for e in new_list if e['kind'] == 'ms']
new_lab = [e for e in new_list if e['kind'] == 'lt']
n_codes = sum(len(f['codes']) for f in final)
n25 = sum(1 for r in rows if r['changed_2025'])
a19f = json.load(open('ambulanta-2019-final.json', encoding='utf-8'))['items']
n_both, n_src = sum(1 for x in a19f if x['price_src'] == 'both'), len(a19f)

L = []
w = L.append
w('SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;')
w('')
w('-- Klinički centar Crne Gore (Podgorica) — cjenovnik za treća lica / neosigurana lica, ambulante i stacionar (DRG)')
w('-- Mode: new pricelist (clinic had 0 services and 0 lab tests locally and on prod, checked 2026-10-02 and 2026-10-06).')
w('-- Sources (scans without a text layer):')
w('--   1) https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-2019.pdf')
w('--      «CJENOVNIK ZA TREĆA LICA KCCG-a», broj 03/01-12050/1 (handwritten), 20.05.2019, «Podgorica, maj 2019»;')
w('--      78 pages: ambulante pp. 3–59, stacionar DRG pp. 60–78. HTTP Last-Modified 2026-08-20.')
w('--      snapshot: data/clinic-pricelists/sources/klinicki-centar-crne-gore-podgorica/2026-10-02-cjenovnik-2019.pdf')
w('--   2) https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-izmjene-i-dopune-2025.pdf')
w('--      Odluka Odbora direktora br. 03/01-21069/3-1, 01.08.2025 (Ministry of Health consent 18.08.2025), 27 pages:')
w('--      DRG pp. 3–23 (coefficient value 1.900,45), specialist examinations pp. 24–27 (124 codes).')
w('--      snapshot: …/2026-10-02-izmjene-i-dopune-2025.pdf')
w('-- Effective price: ambulante = 2019 price, overridden by code with the 2025 amendments; stacionar = DRG 2025')
w('--   (coefficient × 1.900,45; 698 groups, the 2019 DRG table is fully replaced). Ambulante and DRG codes do not collide.')
w(f'-- OCR: PaddleOCR + independent page-by-page LLM transcription; {n_both} of {n_src} 2019 codes agreed to the cent,')
w('--   the rest settled by cross-check (Danilo pricelist / 3 × FZOCG) or by reading the scan (manual-fixes.json).')
w('-- Price check: the 2019 price = 3.0 × FZOCG price_ambulanta_eur (or 3.0 × odjeljenje where there is no')
w('--   outpatient price) for ~1900 codes; = Danilo (clinic 88) price for ~1450 codes.')
w('-- is_price_outdated = 0 everywhere: KCCG republished the 2019 pricelist in 2026-08 next to the 2025 amendments as the current act.')
w('-- DRG: procedural groups → the procedure record (variants of severity → price range); other groups → one')
w('--   hospitalization-for-* record per code (convention of the Mojkovac import, its 24 records reused by code).')
w('--   Where KCCG also has an ambulatory price for the same procedure, the DRG gets its own hospitalization record.')
w('-- Several codes on one catalog entry: code = codes joined with «/», price = min, price_max = max.')
w(f'-- Summary: {len(svc_rows)} services ({len(new_svc)} new catalog records), {len(lab_rows)} lab tests ({len(new_lab)} new),')
w(f'--   {len(excluded)} codes not imported (unit prices, B2B, DRG 960Z/961Z/963Z with price 0, D25019) — see the import record.')
w('-- Record: data/clinic-imports/klinicki-centar-crne-gore-podgorica.json, working files: data/clinic-services-import/kccg/')
w('-- Idempotent: catalog INSERT … ON DUPLICATE KEY UPDATE name_en = name_en, prices/relations INSERT IGNORE.')
w('')
w(f"SET @clinic_id = (SELECT id FROM clinics WHERE slug = '{CLINIC_SLUG}');")
w('')

def new_block(entries, table, cat_table, cat_col, cat_enum, syn_table, syn_fk, label):
    if not entries:
        return
    w('-- ═══════════════════════════════════════════════════════════════')
    w(f'-- {label}: NEW CATALOG RECORDS ({len(entries)})')
    w('-- ═══════════════════════════════════════════════════════════════')
    w('')
    cols = 'name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr' + (', sort_order' if table == 'medical_services' else '')
    w(f'INSERT INTO {table} ({cols}) VALUES')
    vals = []
    for e in entries:
        v = [e['name_en'], e['slug'], e['name_sr'], e['name_sr_cyrl'], e['name_ru'], e['name_de'], e['name_tr']]
        s = ', '.join(q(x) for x in v)
        if table == 'medical_services':
            s += ', ' + (str(e['sort_order']) if e.get('sort_order') else 'NULL')
        vals.append((f"\t({s})", '/'.join(e['codes'])))
    w('\n'.join(f"{v}{',' if i < len(vals) - 1 else ''}  -- {c}" for i, (v, c) in enumerate(vals)))
    w('ON DUPLICATE KEY UPDATE name_en = name_en;')
    w('')
    pairs = [(e['slug'], cat_enum[c]) for e in entries for c in (e.get('categories') or [])]
    if pairs:
        w(f'INSERT IGNORE INTO {cat_table} ({syn_fk}, {cat_col})')
        w(f'SELECT t.id, p.cat FROM {table} t JOIN (')
        w('\t' + '\n\tUNION ALL '.join(f"SELECT {q(s)} AS slug, {c} AS cat" for s, c in pairs))
        w(') p ON p.slug = t.slug;')
        w('')
    if table == 'medical_services':
        sp = []
        for e in entries:
            explicit = set(e.get('specialties') or [])
            # GENERAL_MEDICINE as a category is the catch-all for specialist examinations
            # (infectologist, hematologist in the catalog: category 9, only their own specialty)
            auto = {CAT_SPEC[c] for c in (e.get('categories') or []) if c in CAT_SPEC
                    and not (c == 'GENERAL_MEDICINE' and explicit)}
            names = explicit | auto
            sp += [(e['slug'], SPEC[n]) for n in sorted(names) if n in SPEC]
        if sp:
            w('INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)')
            w('SELECT t.id, p.spec FROM medical_services t JOIN (')
            w('\t' + '\n\tUNION ALL '.join(f"SELECT {q(s)} AS slug, {n} AS spec" for s, n in sp))
            w(') p ON p.slug = t.slug;')
            w('')
    syn = []
    for e in entries:
        for s in e.get('synonyms') or []:
            if not s.get('name') or s['name'] == e['name_en'] or s['name'] == e['name_sr']:
                continue
            syn.append((e['slug'], s['name'], s['lang']))
            if s['lang'] == 'sr' and s.get('cyrl') and s['cyrl'] != s['name']:
                syn.append((e['slug'], s['cyrl'], 'sr-cyrl' if table == 'medical_services' else 'sr'))
    if syn:
        w(f'INSERT IGNORE INTO {syn_table} ({syn_fk}, another_name, language)')
        w(f'SELECT t.id, p.name, p.lang FROM {table} t JOIN (')
        w('\t' + '\n\tUNION ALL '.join(f"SELECT {q(s)} AS slug, {q(n)} AS name, {q(l)} AS lang" for s, n, l in syn))
        w(') p ON p.slug = t.slug;')
        w('')

def price_block(frows, table, cms, fk, label, with_min):
    w('-- ═══════════════════════════════════════════════════════════════')
    w(f'-- {label}: PRICES ({len(frows)})')
    w('-- ═══════════════════════════════════════════════════════════════')
    w('')
    for i in range(0, len(frows), 250):
        chunk = frows[i:i + 250]
        cols = f'clinic_id, {fk}, price, ' + ('price_min, ' if with_min else '') + 'price_max, code, is_price_outdated'
        w(f'INSERT IGNORE INTO {cms} ({cols})')
        w(f"SELECT @clinic_id, t.id, p.price, " + ('NULL, ' if with_min else '') + 'p.price_max, p.code, p.outdated')
        w('FROM (')
        lines = []
        for j, f in enumerate(chunk):
            src = ' | '.join(f['source'])
            head = 'SELECT' if j == 0 else 'UNION ALL SELECT'
            if j == 0:
                body = f"{q(f['slug'])} AS slug, {money(f['price'])} AS price, {money(f['price_max'])} AS price_max, {q('/'.join(f['codes']))} AS code, {f['is_price_outdated']} AS outdated"
            else:
                body = f"{q(f['slug'])}, {money(f['price'])}, {money(f['price_max'])}, {q('/'.join(f['codes']))}, {f['is_price_outdated']}"
            lines.append(f"\t{head} {body}  -- {src}")
        w('\n'.join(lines))
        w(f') p JOIN {table} t ON t.slug = p.slug;')
        w('')

new_block(new_svc, 'medical_services', 'medical_service_categories_relations', 'medical_service_category_id', SVC_CAT,
          'medical_service_synonyms', 'medical_service_id', 'PART 1 — SERVICES')
price_block(svc_rows, 'medical_services', 'clinic_medical_services', 'medical_service_id', 'PART 2 — SERVICES', True)
# lab_test_categories_relations uses category_id, lab_test_synonyms lab_test_id
new_block(new_lab, 'lab_tests', 'lab_test_categories_relations', 'category_id', LAB_CAT,
          'lab_test_synonyms', 'lab_test_id', 'PART 3 — LAB TESTS')
price_block(lab_rows, 'lab_tests', 'clinic_lab_tests', 'lab_test_id', 'PART 4 — LAB TESTS', False)

w('-- ═══════════════════════════════════════════════════════════════')
w('-- VERIFICATION')
w('-- ═══════════════════════════════════════════════════════════════')
w('')
w('SELECT @clinic_id AS clinic_id;')
w(f"SELECT COUNT(*) AS services, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum  -- expect {len(svc_rows)}, {sum(f['is_price_outdated'] for f in svc_rows)}, {sum(f['price'] for f in svc_rows):.2f}")
w('FROM clinic_medical_services WHERE clinic_id = @clinic_id;')
w(f"SELECT COUNT(*) AS lab_tests, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum  -- expect {len(lab_rows)}, {sum(f['is_price_outdated'] for f in lab_rows)}, {sum(f['price'] for f in lab_rows):.2f}")
w('FROM clinic_lab_tests WHERE clinic_id = @clinic_id;')
if new_svc:
    w(f"SELECT COUNT(*) AS new_services FROM medical_services WHERE slug IN ({', '.join(q(e['slug']) for e in new_svc)});  -- expect {len(new_svc)}")
if new_lab:
    w(f"SELECT COUNT(*) AS new_lab_tests FROM lab_tests WHERE slug IN ({', '.join(q(e['slug']) for e in new_lab)});  -- expect {len(new_lab)}")
w("SELECT cms.code, ms.slug, cms.price, cms.is_price_outdated FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id")
w("WHERE cms.clinic_id = @clinic_id AND cms.code IN ('Y01004', 'X34003', 'X18001', 'R01001', 'B05Z', 'R63Z', 'G48B') ORDER BY cms.code;")
w('')
SQL_OUT.write_text('\n'.join(L), encoding='utf-8')

print(f'services {len(svc_rows)} (new {len(new_svc)}), lab tests {len(lab_rows)} (new {len(new_lab)}), excluded {len(excluded)}, codes {n_codes}')
print('via', Counter(v for f in final for v in f['via']))
print('unified new entries', len(unify_log))
for u in unify_log:
    print('  ', u)
print('problems', len(problems))
for p in problems:
    print('  ', p)
