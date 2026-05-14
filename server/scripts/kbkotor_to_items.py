"""
Parse KBKotor (JZU Specijalna bolnica Risan) cjenovnik paddle JSON → items.

The Risan tables follow a fixed 5-column layout:
   Sifra | Verzija | Naziv | Cijena | Mat.tros.

But paddle's table OCR fragments many rows (cells concatenated across columns),
so we use two strategies in tandem:
  1. Clean HTML rows where the 5-column pattern matches — extract directly.
  2. Mangled rows — fall back to scanning the row text for CODE…PRICE pairs.

Items shape:
  {
    code: 'I03017',          # letter + 5 digits
    name: '…',               # service description
    version: '4',            # internal version, may be useful for amendment tracking
    price_eur: 41.31,        # 'Cijena' column
    mat_tros_eur: 0.00,      # 'Mat. tros.' column
    section_code: 'I03',     # parent section identifier (1-3 chars)
    section_name: 'USLUGE DEFEKTOLOGA-LOGOPEDA',
    page: N,
  }

Usage:
    py -3.12 server/scripts/kbkotor_to_items.py <input.json> <output.json>
    py -3.12 server/scripts/kbkotor_to_items.py --all   (process all data/kbkotor/*/paddleocr/*.json)
"""
import sys, json, re
from pathlib import Path
from collections import Counter

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]

# Code: single letter + 5 digits. Allow OCR confusion of 1↔I (we'll normalize later).
CODE_RE       = re.compile(r'\b([A-Z]\d{5}|\d{6})\b')
SECTION_CODE_RE = re.compile(r'^([A-Z]\d{0,3})$')           # I, I03, J01, X07 etc.
PRICE_RE      = re.compile(r'^\s*(\d{1,5}[,\.]\d{2})\s*$')
PRICE_FREE_RE = re.compile(r'(\d{1,5}[,\.]\d{2})')


def normalize_code(c):
    """Treat leading '1' as 'I' for KBKotor codes — paddle frequently
    misreads the leading letter."""
    if c and re.match(r'^\d{6}$', c) and c.startswith('1'):
        return 'I' + c[1:]
    return c


def parse_price(s):
    if not s: return None
    s = s.strip().replace(',', '.')
    m = re.match(r'^(\d+\.\d{2})$', s)
    if m:
        try: return float(m.group(1))
        except: return None
    return None


def strip_html(s):
    return re.sub(r'<[^>]+>', '', s or '').strip()


def parse_table_html(html):
    """Yield (cells_list, raw_row_text) for each <tr>."""
    for row_match in re.finditer(r'<tr[^>]*>(.*?)</tr>', html, re.DOTALL):
        row = row_match.group(1)
        cells = []
        for cell in re.finditer(r'<td[^>]*>(.*?)</td>', row, re.DOTALL):
            cells.append(strip_html(cell.group(1)))
        # raw text — useful for fallback parsing
        raw = re.sub(r'\s+', ' ', strip_html(row)).strip()
        yield cells, raw


def extract_items_from_table(html, page):
    items = []
    current_section_code = None
    current_section_name = None

    for cells, raw in parse_table_html(html):
        if not cells: continue
        first = cells[0].strip() if cells else ''

        # Section header rows have a short letter+digits identifier in col 0
        # and a non-empty name in col 1 (or spanning), with no price.
        if SECTION_CODE_RE.match(first):
            # Section like "I", "I03", "J01"
            name_candidates = [c.strip() for c in cells[1:] if c.strip()]
            # filter out generic labels
            name_candidates = [n for n in name_candidates if n not in ('Sifra','Verzija','Cijena','Mat.tros.','Mat. tros.','Do datuma')]
            if name_candidates:
                # The longest non-numeric candidate is likely the section name
                non_num = [n for n in name_candidates if not re.match(r'^[\d.,]+$', n)]
                if non_num:
                    current_section_name = non_num[0]
                    current_section_code = first
            continue

        # Skip noise rows (headers, metadata) — they don't start with a 5-digit code
        if not CODE_RE.match(first):
            # Check if first cell contains code-with-data (mangled)
            m = CODE_RE.search(first)
            if not m:
                continue
            first_code = m.group(1)
        else:
            m = CODE_RE.match(first)
            first_code = m.group(1)

        # Clean 5-cell pattern: [code, version, name, price, mat_tros]
        # paddle's tables sometimes have 5, 6, or 7 cells. Match by content type.
        if len(cells) >= 5 and CODE_RE.match(first):
            # Identify version: usually a 1-digit number
            v_idx = 1 if len(cells) > 1 and re.match(r'^\d{1,2}$', cells[1].strip()) else None
            # Identify trailing price + mat_tros
            # Scan from end for two price-like cells
            prices = []
            for c in reversed(cells):
                p = parse_price(c)
                if p is not None:
                    prices.append(p)
                    if len(prices) == 2: break
                else:
                    break
            if len(prices) == 2:
                price_eur, mat_tros_eur = prices[1], prices[0]  # reversed
                # Name: middle cells joined
                name_cells = cells[(v_idx+1 if v_idx is not None else 1):]
                # Drop trailing price cells
                name_cells = name_cells[:-2]
                name = ' '.join(c.strip() for c in name_cells if c.strip())
                # Strip leading garbage like "1 VJEZBE..." (version digit appearing as first token)
                name = re.sub(r'^\d\s+', '', name).strip()
                if not name:
                    # try grabbing from raw
                    pass
                items.append({
                    'code': normalize_code(first_code),
                    'version': cells[1].strip() if v_idx is not None else None,
                    'name': name,
                    'price_eur': price_eur,
                    'mat_tros_eur': mat_tros_eur,
                    'section_code': current_section_code,
                    'section_name': current_section_name,
                    'page': page,
                    'source': 'html-5col',
                })
                continue

        # Fallback: row mangled. Extract every (code, price) pair from the
        # raw concatenated text of all cells.
        joined = ' '.join(c for c in cells if c)
        # Find all "CODE … PRICE" patterns
        for m in re.finditer(r'\b([A-Z]\d{5}|\d{6})\b(.*?)(?=\b[A-Z]\d{5}\b|\b\d{6}\b|$)', joined, re.DOTALL):
            code = normalize_code(m.group(1))
            tail = m.group(2)
            # Price = last price-shaped number; mat_tros = second-to-last (often 0.00)
            nums = PRICE_FREE_RE.findall(tail)
            if not nums:
                continue
            price_eur = parse_price(nums[-2] if len(nums) >= 2 else nums[-1])
            mat_tros_eur = parse_price(nums[-1]) if len(nums) >= 2 else None
            # Name = strip leading version digit and trailing prices
            name = re.sub(r'^\s*\d+\s+', '', tail).strip()
            # Drop trailing prices from name
            name = re.sub(r'\s*\d{1,5}[,\.]\d{2}\s*$', '', name).strip()
            name = re.sub(r'\s*\d{1,5}[,\.]\d{2}\s*$', '', name).strip()  # twice to drop mat_tros
            if price_eur is None: continue
            items.append({
                'code': code,
                'version': None,
                'name': name,
                'price_eur': price_eur,
                'mat_tros_eur': mat_tros_eur,
                'section_code': current_section_code,
                'section_name': current_section_name,
                'page': page,
                'source': 'fallback-text',
            })

    return items


def process(in_path, out_path):
    raw = json.load(open(in_path, encoding='utf-8'))
    pages = raw.get('layoutParsingResults', [])

    all_items = []
    seen = set()  # dedup by (code) — last write wins on later pages
    stats = Counter()
    for i, page in enumerate(pages, 1):
        first = page.get('prunedResult', {})
        tables = first.get('table_res_list', [])
        for t in tables:
            html = t.get('pred_html', '')
            for it in extract_items_from_table(html, i):
                stats[it['source']] += 1
                if it['code'] in seen:
                    # update existing (later page wins)
                    for k in range(len(all_items)):
                        if all_items[k]['code'] == it['code']:
                            all_items[k] = it
                            stats['duplicate-overwritten'] += 1
                            break
                else:
                    all_items.append(it)
                    seen.add(it['code'])

    out_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        'source_paddle_json': str(in_path.relative_to(ROOT)).replace('\\','/'),
        'items_total': len(all_items),
        'stats': dict(stats),
        'sections': dict(Counter(f"{it.get('section_code') or '?'} | {it.get('section_name') or '?'}" for it in all_items)),
        'items': all_items,
    }
    json.dump(payload, open(out_path, 'w', encoding='utf-8'), ensure_ascii=False, indent=2)
    print(f'  {in_path.name[:75]:75} → {len(all_items):4} items  ({dict(stats)})')


def main():
    if len(sys.argv) < 2:
        print('Usage: kbkotor_to_items.py <input.json> <output.json>'); sys.exit(1)
    if sys.argv[1] == '--all':
        for f in (ROOT / 'data' / 'kbkotor').glob('*/paddleocr/*.json'):
            if f.name.endswith('.items.json'): continue
            out = f.with_suffix('.items.json')
            process(f, out)
    else:
        process(Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve())


if __name__ == '__main__':
    main()
