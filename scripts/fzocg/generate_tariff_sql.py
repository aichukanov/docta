"""
Generate SQL INSERT files for medical_service_tariffs from FINAL.json.

Produces one INSERT script per FZOCG category at:
  server/sql/insert-tariff-fzocg-<slug>.sql

Usage:
    py -3.12 scripts/fzocg/generate_tariff_sql.py
"""

import sys, json, re, unicodedata
from pathlib import Path
from datetime import date

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]
OUT_DIR = ROOT / 'server' / 'sql'

# Map FZOCG category slug → (tariff_source enum value, final-file glob)
CATEGORIES = [
    ('primarna-zdravstvena-zastita',    'fzocg-pzz'),
    ('sekundarna-ostalo',               'fzocg-sekundarna'),
    ('drg-akutno-bolnicko',             'fzocg-drg'),
    ('transfuziologija',                'fzocg-transfuziologija'),
    ('apotekarska-djelatnost',          'fzocg-apotekarska'),
    ('medicinsko-pomagala',             'fzocg-medicinsko-pomagala'),
    ('van-mreze',                       'fzocg-van-mreze'),
]

ROWS_PER_INSERT = 200


def sql_str(v):
    """Format a Python value as an SQL literal."""
    if v is None or v == '':
        return 'NULL'
    if isinstance(v, (int, float)):
        if isinstance(v, float) and (v != v):  # NaN
            return 'NULL'
        return str(v)
    s = str(v).replace('\\', '\\\\').replace("'", "''")
    return f"'{s}'"


def detect_scheme(item):
    """Pick scheme from item's price fields. Source-of-truth precedence:
       coefficient > operacija > dual > single."""
    if item.get('coefficient') is not None:
        return 'coefficient'
    if any(item.get(k) is not None for k in ('price_operacija_eur','price_anestezija_eur','price_ukupno_eur')):
        return 'operacija'
    if (item.get('price_odjeljenje_eur') is not None) or (item.get('price_ambulanta_eur') is not None):
        # If both ambulanta+odjeljenje are absent but price_eur exists, fall through to single.
        # If at least one is present → dual.
        return 'dual'
    if item.get('price_eur') is not None:
        return 'single'
    # No prices at all — keep as single with NULL price (flagged in VERIFY list).
    return 'single'


def _strip_diacritics(s):
    return ''.join(c for c in unicodedata.normalize('NFKD', s or '')
                   if not unicodedata.combining(c))


def _section_acronym(section):
    """Short uppercase tag from a section name, e.g.
    'RADNE TAKSE' -> 'RT', 'Jedinica za patronažu' -> 'JZP'."""
    words = re.findall(r'[A-Za-z0-9]+', _strip_diacritics(section).upper())
    return ''.join(w[0] for w in words)


def assign_sql_codes(items):
    """The DB unique key is (tariff_source, code). A source pricelist may legitimately
    reuse the same code in different sections (e.g. PZZ X01022 in the TBC centre vs the
    patronage unit; apotekarska '50' in USLUGE vs RADNE TAKSE). FINAL.json keeps the real
    printed code; here we keep the first occurrence as-is and give later occurrences a
    unique synthetic code (`<code>-<section-acronym>`), recording the real code in `notes`."""
    counts = {}
    for it in items:
        counts[it.get('code') or ''] = counts.get(it.get('code') or '', 0) + 1
    used, seen = set(), {}
    for it in items:
        code = it.get('code') or ''
        it['_orig_code_note'] = None
        if counts[code] <= 1:
            it['_sql_code'] = code
            used.add(code)
            continue
        seen[code] = seen.get(code, 0) + 1
        if seen[code] == 1:                     # first occurrence keeps the clean code
            it['_sql_code'] = code
            used.add(code)
            continue
        tag = _section_acronym(it.get('section')) or str(seen[code])
        cand = f'{code}-{tag}'
        n = 2
        while cand in used:
            cand = f'{code}-{tag}-{n}'
            n += 1
        it['_sql_code'] = cand
        used.add(cand)
        sec = it.get('section') or '?'
        it['_orig_code_note'] = (
            f'Izvorni kod: {code} (sekcija: {sec}). '
            f'Kod izmijenjen u {cand} radi jedinstvenosti (isti kod postoji u drugoj sekciji).'
        )


def build_row_values(tariff_source, item, base_meta):
    code           = item.get('_sql_code') or item.get('code') or ''
    scheme         = detect_scheme(item)
    name_sr_latin  = item.get('name')
    section        = item.get('section')
    subsection     = item.get('subsection')
    amended_from   = item.get('amended_from')
    effective_from = base_meta.get('effective_from')
    signed_number  = (base_meta.get('signed') or {}).get('number') if base_meta.get('signed') else None
    source_pdf     = base_meta.get('source_pdf')
    notes          = item.get('_orig_code_note')

    price_eur            = item.get('price_eur')
    price_odjeljenje_eur = item.get('price_odjeljenje_eur')
    price_ambulanta_eur  = item.get('price_ambulanta_eur')
    price_operacija_eur  = item.get('price_operacija_eur')
    price_anestezija_eur = item.get('price_anestezija_eur')
    price_ukupno_eur     = item.get('price_ukupno_eur')
    coefficient          = item.get('coefficient')
    base_coefficient_eur = base_meta.get('base_coefficient_eur')

    return (
        sql_str(tariff_source),
        sql_str(code),
        sql_str(scheme),
        sql_str(price_eur),
        sql_str(price_odjeljenje_eur),
        sql_str(price_ambulanta_eur),
        sql_str(price_operacija_eur),
        sql_str(price_anestezija_eur),
        sql_str(price_ukupno_eur),
        sql_str(coefficient),
        sql_str(base_coefficient_eur if scheme == 'coefficient' else None),
        sql_str(name_sr_latin),
        sql_str(section),
        sql_str(subsection),
        sql_str(amended_from),
        sql_str(effective_from),
        sql_str(signed_number),
        sql_str(source_pdf),
        sql_str(notes),
    )


COLUMNS = (
    "tariff_source", "code", "scheme",
    "price_eur", "price_odjeljenje_eur", "price_ambulanta_eur",
    "price_operacija_eur", "price_anestezija_eur", "price_ukupno_eur",
    "coefficient", "base_coefficient_eur",
    "name_sr_latin", "section", "subsection",
    "amended_from", "effective_from",
    "source_signed_number", "source_pdf", "notes",
)


def generate_for_category(slug, tariff_source):
    final_path = ROOT / 'data' / 'fzocg' / slug / f'{slug}-FINAL.json'
    if not final_path.exists():
        print(f'SKIP: {final_path} does not exist')
        return None

    payload = json.load(open(final_path, encoding='utf-8'))
    items = payload.get('items', [])
    if not items:
        print(f'SKIP: {slug} has no items')
        return None

    assign_sql_codes(items)
    dups = [(it.get('code'), it['_sql_code']) for it in items if it.get('_orig_code_note')]
    for orig, newc in dups:
        print(f'    dedup: {tariff_source} {orig!r} -> {newc!r}')

    base_meta = {
        'effective_from':       payload.get('effective_from'),
        'signed':               payload.get('signed'),
        'source_pdf':           payload.get('source_pdf'),
        'base_coefficient_eur': payload.get('base_coefficient_eur'),
    }

    out_path = OUT_DIR / f'insert-tariff-{tariff_source}.sql'

    lines = []
    lines.append(f'-- Tariff insert: {tariff_source}')
    lines.append(f'-- Source: data/fzocg/{slug}/{slug}-FINAL.json ({len(items)} items)')
    lines.append(f'-- Generated by scripts/fzocg/generate_tariff_sql.py')
    lines.append(f'-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < {out_path.relative_to(ROOT).as_posix()}')
    lines.append('')
    lines.append('SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;')
    lines.append('SET CHARACTER SET utf8mb4;')
    lines.append('')

    cols_sql = ', '.join(f'`{c}`' for c in COLUMNS)

    # Idempotency: ON DUPLICATE KEY UPDATE so re-running the file is safe.
    # Existing rows (matched by uq_source_code) get refreshed to latest values.
    update_cols = [c for c in COLUMNS if c not in ('tariff_source', 'code')]
    update_clause = ', '.join(f'`{c}` = VALUES(`{c}`)' for c in update_cols)

    for batch_start in range(0, len(items), ROWS_PER_INSERT):
        batch = items[batch_start:batch_start + ROWS_PER_INSERT]
        lines.append(f'-- rows {batch_start + 1}..{batch_start + len(batch)}')
        lines.append(f'INSERT INTO `medical_service_tariffs` ({cols_sql}) VALUES')
        value_rows = []
        for it in batch:
            vals = build_row_values(tariff_source, it, base_meta)
            value_rows.append('(' + ', '.join(vals) + ')')
        lines.append(',\n'.join(value_rows))
        lines.append(f'ON DUPLICATE KEY UPDATE {update_clause};')
        lines.append('')

    out_path.write_text('\n'.join(lines), encoding='utf-8')
    print(f'  Wrote {out_path.relative_to(ROOT).as_posix()}  ({len(items)} rows, {out_path.stat().st_size // 1024} KB)')
    return out_path


def generate_linkage_update():
    """SQL script that auto-populates medical_service_id by joining on
    clinic_medical_services.code (majority vote for codes with multiple
    medical_service_id mappings)."""
    out = OUT_DIR / 'update-medical-service-tariffs-linkage.sql'
    sql = """-- Populate medical_service_tariffs.medical_service_id by matching on `code`
-- with existing clinic_medical_services rows (e.g. clinic 88, 131 — already FZOCG-coded).
-- For codes that map to multiple medical_service_ids, picks the most frequently
-- used mapping (majority vote).
--
-- Run AFTER all insert-tariff-fzocg-*.sql scripts.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/update-medical-service-tariffs-linkage.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Single UPDATE with majority-vote subquery
UPDATE `medical_service_tariffs` t
JOIN (
  SELECT
    code,
    medical_service_id,
    COUNT(*) AS hits,
    ROW_NUMBER() OVER (PARTITION BY code ORDER BY COUNT(*) DESC, medical_service_id ASC) AS rn
  FROM `clinic_medical_services`
  WHERE code IS NOT NULL AND code <> ''
  GROUP BY code, medical_service_id
) c
  ON c.code = t.code
 AND c.rn = 1
SET t.medical_service_id = c.medical_service_id
WHERE t.medical_service_id IS NULL;

-- Report:
SELECT
  tariff_source,
  COUNT(*) AS total_rows,
  SUM(medical_service_id IS NOT NULL) AS linked,
  SUM(medical_service_id IS NULL)     AS unlinked
FROM `medical_service_tariffs`
GROUP BY tariff_source
ORDER BY tariff_source;
"""
    out.write_text(sql, encoding='utf-8')
    print(f'  Wrote {out.relative_to(ROOT).as_posix()}')


def main():
    print('Generating tariff SQL inserts...\n')
    for slug, tariff_source in CATEGORIES:
        generate_for_category(slug, tariff_source)
    print()
    print('Generating linkage UPDATE...')
    generate_linkage_update()
    print('\nDone.')


if __name__ == '__main__':
    main()
