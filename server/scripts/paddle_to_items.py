"""
Parse PaddleOCR PP-StructureV3 JSON into a flat items[] list.

Reads:  data/fzocg/<category>/paddleocr/<pdf-stem>.json
Writes: data/fzocg/<category>/paddleocr/<pdf-stem>.items.json

Per item:
  {
    "code": "...",          # SIFRA from column 0
    "name": "...",          # NAZIV from column 1 (no diacritics yet)
    "section": "...",       # current numbered section from figure_title context
    "prices": {...},        # depends on table scheme (dual / operacija / single)
    "scheme": "dual" | "operacija" | "single-uncertain",
    "page": N,              # PDF page (1-based)
  }

Usage:
  py -3.12 server/scripts/paddle_to_items.py <input.json> <output.json>
or batch all in data/fzocg/*/paddleocr/:
  py -3.12 server/scripts/paddle_to_items.py --all
"""
import sys, re, json
from pathlib import Path
from collections import Counter

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')
if sys.stderr.encoding.lower() not in ('utf-8','utf8'):
    sys.stderr.reconfigure(encoding='utf-8')

# --- HTML helpers ---------------------------------------------------------

TR_RE = re.compile(r'<tr\b[^>]*>(.*?)</tr>', re.S | re.I)
TD_RE = re.compile(r'<t[dh]\b([^>]*)>(.*?)</t[dh]>', re.S | re.I)
COLSPAN_RE = re.compile(r'colspan\s*=\s*"?(\d+)"?', re.I)
ROWSPAN_RE = re.compile(r'rowspan\s*=\s*"?(\d+)"?', re.I)
TAG_RE = re.compile(r'<[^>]+>')
ENTITY_RE = re.compile(r'&(amp|lt|gt|nbsp|quot|#\d+);')

ENT_MAP = {'amp':'&','lt':'<','gt':'>','nbsp':' ','quot':'"'}

def strip_html(s):
    if not s: return ''
    s = TAG_RE.sub('', s)
    def rep(m):
        e = m.group(1)
        if e.startswith('#'):
            try: return chr(int(e[1:]))
            except: return ''
        return ENT_MAP.get(e, '')
    s = ENTITY_RE.sub(rep, s)
    return s.strip()

def parse_table(html):
    """Yield (row_cells) where row_cells is list of (text, colspan, rowspan)."""
    rows = []
    for tr_m in TR_RE.finditer(html or ''):
        cells = []
        for td_m in TD_RE.finditer(tr_m.group(1)):
            attrs, content = td_m.group(1), td_m.group(2)
            colspan = int(COLSPAN_RE.search(attrs).group(1)) if COLSPAN_RE.search(attrs) else 1
            rowspan = int(ROWSPAN_RE.search(attrs).group(1)) if ROWSPAN_RE.search(attrs) else 1
            cells.append((strip_html(content), colspan, rowspan))
        rows.append(cells)
    return rows

# --- Cell value helpers ---------------------------------------------------

# Accepted SIFRA patterns:
#   Y01001  X12001  G05001  K03181        ([A-Z]\d{5,6})
#   A05Z    B01A    F07C                  ([A-Z]\d{2}[A-Z])    (DRG)
#   AA1101  CC2305                        ([A-Z]{2}\d{4})      (MEDICINSKO POMAGALA)
#   10  20  450                           (\d{2,6})            (APOTEKARSKA)
CODE_RE = re.compile(r'^([A-Z]{1,2}\d{2,5}[A-Z]?|\d{2,6})$')
PRICE_RE = re.compile(r'^\d{1,4}(?:[.\s]\d{3})*[,.]\d{2}$')

def is_code(s):
    return bool(CODE_RE.match((s or '').strip()))

def parse_price(s):
    if not s: return None
    s = s.strip().replace(' ', '').replace(' ','')
    if not s: return None
    # Serbian/EU format: 1.234,56  ->  1234.56
    # Also handle: 1234,56  or  1234.56
    if ',' in s and '.' in s:
        # 1.234,56 — dots are thousands, comma is decimal
        s = s.replace('.', '').replace(',', '.')
    elif ',' in s:
        s = s.replace(',', '.')
    try:
        return float(s)
    except ValueError:
        return None

# --- Section header detection --------------------------------------------

NUMBERED_SECTION_RE = re.compile(r'^\s*(\d{1,2})\.\s*([A-ZŠČĆŽĐ][^\n]{3,}?)(?:\s*\.{3,}.*)?$', re.M)

def find_numbered_section(text):
    """Return (num, name) if text starts with '<num>. <NAME>'."""
    if not text: return None
    text = strip_html(text)
    # Sometimes content has dots leading to page number — strip them
    text = re.sub(r'\.{3,}.*$', '', text).strip()
    m = re.match(r'^\s*(\d{1,2})\.\s+([A-ZŠČĆŽĐ].{3,})$', text, re.S)
    if m:
        num = int(m.group(1))
        if 1 <= num <= 99:
            return num, m.group(2).strip()
    return None

# --- Table scheme classification -----------------------------------------

# Header detection: row near the top with headerish text
HEADER_TOKENS_PRICE_DUAL = {'odjeljenje', 'ambulanta'}
HEADER_TOKENS_OPERATION  = {'operacija', 'anestezija', 'ukupno'}

def classify_table(rows):
    """Look at header rows (first 1-3 rows) and decide column scheme.

    Returns one of:
      'dual'         — 4 cols: code | name | odj | amb
      'operacija'    — 5 cols: code | name | operacija | anestezija | ukupno
      'single'       — 3 cols: code | name | one_price (continuation page)
      'unknown'
    """
    if not rows:
        return 'unknown', 0
    # Look at first 3 rows for header signals
    n_data_cols_seen = []
    has_dual = False
    has_op = False
    has_header = False
    for r in rows[:5]:
        flat = ' '.join(c[0].lower() for c in r)
        cols_total = sum(c[1] for c in r)
        if any(t in flat for t in HEADER_TOKENS_PRICE_DUAL):
            has_dual = True
            has_header = True
        if any(t in flat for t in HEADER_TOKENS_OPERATION):
            has_op = True
            has_header = True
        if not any(is_code(c[0]) for c in r):
            # non-data row
            pass
        else:
            n_data_cols_seen.append(cols_total)
    # First data row's column count is the reliable signal
    first_data_cols = None
    for r in rows:
        if any(is_code(c[0]) for c in r):
            first_data_cols = sum(c[1] for c in r)
            break
    if has_op or first_data_cols == 5:
        return 'operacija', first_data_cols or 5
    if has_dual or first_data_cols == 4:
        return 'dual', first_data_cols or 4
    if first_data_cols == 3:
        return 'single', 3
    return 'unknown', first_data_cols or 0

# --- Main parser ---------------------------------------------------------

def parse_paddle(json_path):
    data = json.load(open(json_path, encoding='utf-8'))
    pages = data['layoutParsingResults']
    items = []
    last_table_scheme = None     # for continuation pages

    stats = {'table_blocks': 0, 'data_rows': 0, 'header_rows': 0, 'section_rows': 0,
             'price_dropped': 0, 'scheme_unknown': 0}

    # Walk blocks in y-order across all pages; switch section when we hit a
    # figure_title that matches "<N>. <NAME>". Sections persist across pages
    # (carried via current_section).
    SECTION_HEADER_RE = re.compile(r'^(\d{1,2})\.\s*(.{4,120}?)\.?\s*$')
    def detect_section_header(text):
        text = re.sub(r'\s+', ' ', strip_html(text or '')).strip()
        m = SECTION_HEADER_RE.match(text)
        if not m: return None
        num = int(m.group(1))
        if not (1 <= num <= 99): return None
        name = m.group(2).strip()
        upper_alpha = sum(1 for c in name if c.isupper())
        total_alpha = sum(1 for c in name if c.isalpha())
        if total_alpha and upper_alpha / total_alpha < 0.55:
            return None  # not a UPPERCASE section header
        return num, name

    current_section = None
    stats['detected_section_pages'] = 0

    for page_idx, lp in enumerate(pages, start=1):
        pr = lp['prunedResult']
        blocks = pr.get('parsing_res_list', [])
        def y_of(b):
            bb = b.get('block_bbox') or [0,0,0,0]
            return bb[1] if len(bb) >= 2 else 0
        blocks_sorted = sorted(blocks, key=y_of)

        for b in blocks_sorted:
            label = b.get('block_label', '')
            content = b.get('block_content', '') or ''
            if label in ('figure_title','paragraph_title'):
                sec = detect_section_header(content)
                if sec:
                    num, name = sec
                    current_section = f'{num}. {name}'
                    stats['detected_section_pages'] += 1
                continue
            if label != 'table':
                continue

            stats['table_blocks'] += 1
            rows = parse_table(content)
            scheme, ncols = classify_table(rows)
            # For "single" continuation pages, inherit previous scheme guess
            inherited = False
            if scheme == 'single' and last_table_scheme in ('dual','operacija'):
                # single column — but we don't know which (odj or amb).
                # Heuristic: most "single" continuation pages from primary tables hold odjeljenje values
                #   when previous table was dual. But we can't be certain — leave both possible.
                # Mark as single but record previous scheme.
                pass
            if scheme in ('dual','operacija'):
                last_table_scheme = scheme

            for row in rows:
                if not row:
                    continue
                # section-header row (single cell spanning full width)
                if len(row) == 1 and row[0][1] >= 2:
                    # this is a sub-section header inside the table, sometimes carries data context
                    continue
                cells = [c[0] for c in row]
                if not cells or not is_code(cells[0]):
                    # not a data row (likely header or sub-header text)
                    if any(c.lower() in HEADER_TOKENS_PRICE_DUAL | HEADER_TOKENS_OPERATION | {'sifra','šifra','cijena','naziv usluge'} for c in cells):
                        stats['header_rows'] += 1
                    continue
                stats['data_rows'] += 1
                code = cells[0].strip()
                name = cells[1].strip() if len(cells)>1 else ''
                prices = {}
                if scheme == 'operacija' and len(cells) >= 5:
                    prices['operacija_eur'] = parse_price(cells[2])
                    prices['anestezija_eur'] = parse_price(cells[3])
                    prices['ukupno_eur']    = parse_price(cells[4])
                elif scheme == 'dual' and len(cells) >= 4:
                    prices['odjeljenje_eur'] = parse_price(cells[2])
                    prices['ambulanta_eur']  = parse_price(cells[3])
                elif scheme == 'single' and len(cells) >= 3:
                    # Continuation page — single price column. We don't know which
                    # column it represents — mark scheme accordingly.
                    prices['single_eur'] = parse_price(cells[2])
                else:
                    stats['scheme_unknown'] += 1
                    if len(cells) >= 3:
                        prices['single_eur'] = parse_price(cells[-1])
                if not any(v is not None for v in prices.values()):
                    stats['price_dropped'] += 1
                items.append({
                    'code': code,
                    'name': name,
                    'section': current_section,
                    'page': page_idx,
                    'scheme': scheme,
                    'cols': len(cells),
                    **prices,
                })

    return items, stats

# --- Driver ---------------------------------------------------------------

def process_one(input_path, output_path):
    items, stats = parse_paddle(input_path)
    by_section = Counter(it['section'] for it in items)
    by_scheme  = Counter(it['scheme'] for it in items)
    payload = {
        'source_paddle_json': str(input_path.relative_to(Path.cwd())) if Path.cwd() in input_path.parents else input_path.name,
        'items_total': len(items),
        'stats': stats,
        'by_scheme': dict(by_scheme),
        'sections': dict(by_section),
        'items': items,
    }
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(payload, f, ensure_ascii=False, indent=2)
    return payload

def main():
    if len(sys.argv) == 2 and sys.argv[1] == '--all':
        root = Path(__file__).resolve().parents[2] / 'data' / 'fzocg'
        for paddle_dir in sorted(root.glob('*/paddleocr')):
            for j in sorted(paddle_dir.glob('*.json')):
                if j.name.endswith('.WEB.json') or j.name.endswith('.items.json'):
                    continue
                out = j.with_suffix('.items.json')
                payload = process_one(j, out)
                print(f'  {j.parent.parent.name}/{j.name}  →  {payload["items_total"]} items   schemes={payload["by_scheme"]}')
    elif len(sys.argv) == 3:
        inp = Path(sys.argv[1]).resolve()
        out = Path(sys.argv[2]).resolve()
        out.parent.mkdir(parents=True, exist_ok=True)
        payload = process_one(inp, out)
        print(f'  {inp.name}  →  {payload["items_total"]} items   schemes={payload["by_scheme"]}')
        print(f'  Top sections:')
        for sec, n in sorted(payload["sections"].items(), key=lambda x:-x[1])[:10]:
            print(f'    {n:5d}  {(sec or "(no section)")[:80]}')
    else:
        print(__doc__, file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
