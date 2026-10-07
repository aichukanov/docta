"""
KCCG (Klinički centar Crne Gore) pricelist: PaddleOCR JSON -> flat items[].

Two table kinds in both PDFs:
  ambulanta:  Šifra | Naziv | Iznos              (one price column)
  drg:        DRG   | Opis  | Koeficijent | Cijena

Rows with a single wide cell are section headers ("Usluge u prijemnoj ambulanti",
"MDC 01 Bolesti ..."); they are carried as `section` onto the following rows,
across pages.

Rows whose cells came out merged are recovered from the row text by regex
(code at start, price(s) at end) and flagged `recovered: true`.

Usage:
  py -3.12 kccg_to_items.py <paddle.json> <out.items.json>
"""
import sys, re, json
from pathlib import Path
from collections import Counter

sys.stdout.reconfigure(encoding='utf-8')

TR_RE = re.compile(r'<tr\b[^>]*>(.*?)</tr>', re.S | re.I)
TD_RE = re.compile(r'<t[dh]\b([^>]*)>(.*?)</t[dh]>', re.S | re.I)
COLSPAN_RE = re.compile(r'colspan\s*=\s*"?(\d+)"?', re.I)
TAG_RE = re.compile(r'<[^>]+>')

def strip_html(s):
    s = TAG_RE.sub(' ', s or '')
    s = s.replace('&amp;', '&').replace('&lt;', '<').replace('&gt;', '>').replace('&nbsp;', ' ').replace('&quot;', '"')
    return re.sub(r'\s+', ' ', s).strip()

def parse_rows(html):
    rows = []
    for tr in TR_RE.finditer(html or ''):
        cells = []
        for td in TD_RE.finditer(tr.group(1)):
            cs = COLSPAN_RE.search(td.group(1))
            cells.append((strip_html(td.group(2)), int(cs.group(1)) if cs else 1))
        rows.append(cells)
    return rows

# Y01004, K03181, Q02001 (services); A07Z, B70C, 801A, 960Z (DRG)
SVC_CODE_RE = re.compile(r'^[A-Z]\d{5}$')
DRG_CODE_RE = re.compile(r'^(?:[A-Z]\d{2}|\d{3})[A-Z]$')
PRICE_RE = re.compile(r'^\d{1,3}(?:\.\d{3})*,\d{2}$|^\d+,\d{2}$|^\d+\.\d{2}$')
PRICE_ANY_RE = re.compile(r'\d{1,3}(?:\.\d{3})*,\d{2}|\d+,\d{2}')

# OCR confusions in the code column: O->0 inside digits, I->1, etc.
def norm_code(s):
    s = (s or '').strip().replace(' ', '').upper()
    if len(s) >= 4 and s[0].isalpha():
        head, tail = s[0], s[1:]
        if SVC_CODE_RE.match(head + tail.translate(str.maketrans('OIlSZ', '01152'))):
            return head + tail.translate(str.maketrans('OIlSZ', '01152'))
    if s[:1] == '0' and SVC_CODE_RE.match('O' + s[1:]):
        return 'O' + s[1:]
    return s

def parse_price(s):
    s = (s or '').strip().replace(' ', '')
    if not s:
        return None
    if ',' in s:
        s = s.replace('.', '').replace(',', '.')
    try:
        return round(float(s), 2)
    except ValueError:
        return None

def kind_of(code):
    if SVC_CODE_RE.match(code): return 'ambulanta'
    if DRG_CODE_RE.match(code): return 'drg'
    return None

def main(inp, out):
    data = json.load(open(inp, encoding='utf-8'))
    items, unparsed = [], []
    section = None
    stats = Counter()
    for page_no, lp in enumerate(data['layoutParsingResults'], start=1):
        blocks = lp['prunedResult'].get('parsing_res_list', [])
        blocks = sorted(blocks, key=lambda b: (b.get('block_bbox') or [0, 0])[1])
        for b in blocks:
            label = b.get('block_label', '')
            content = b.get('block_content', '') or ''
            if label != 'table':
                continue
            stats['tables'] += 1
            for row in parse_rows(content):
                texts = [c[0] for c in row if c[0]]
                if not texts:
                    continue
                code = norm_code(texts[0].split(' ')[0]) if texts else ''
                k = kind_of(code)
                if not k:
                    joined = ' '.join(texts)
                    low = joined.lower()
                    if any(t in low for t in ('šifra', 'sifra', 'naziv usluge', 'koeficijent', 'iznos')) and len(joined) < 80:
                        stats['header_rows'] += 1
                        continue
                    if len(texts) == 1 and not PRICE_ANY_RE.search(joined):
                        section = joined
                        stats['section_rows'] += 1
                        continue
                    unparsed.append({'page': page_no, 'text': joined})
                    continue
                item = {'code': code, 'kind': k, 'page': page_no, 'section': section}
                clean = len(texts) >= 3 and texts[0].strip().upper().replace(' ', '') in (code, texts[0].strip()) and all(PRICE_RE.match(t) for t in texts[2:])
                if clean:
                    item['name'] = texts[1]
                    nums = [parse_price(t) for t in texts[2:]]
                else:
                    # recover from row text: code ... name ... price(s)
                    joined = ' '.join(texts)
                    rest = joined[len(texts[0].split(' ')[0]):].strip()
                    nums_txt = PRICE_ANY_RE.findall(rest)
                    tail_cut = rest
                    for t in reversed(nums_txt):
                        idx = tail_cut.rfind(t)
                        if idx >= 0 and tail_cut[idx + len(t):].strip() == '':
                            tail_cut = tail_cut[:idx].strip()
                    item['name'] = tail_cut
                    nums = [parse_price(t) for t in PRICE_ANY_RE.findall(rest[len(tail_cut):])]
                    item['recovered'] = True
                    stats['recovered'] += 1
                if k == 'drg':
                    if len(nums) >= 2:
                        item['coefficient'], item['price_eur'] = nums[-2], nums[-1]
                    elif len(nums) == 1:
                        item['price_eur'] = nums[0]
                else:
                    item['price_eur'] = nums[-1] if nums else None
                if item.get('price_eur') is None:
                    stats['no_price'] += 1
                items.append(item)
    payload = {
        'source': Path(inp).name,
        'items_total': len(items),
        'by_kind': dict(Counter(i['kind'] for i in items)),
        'stats': dict(stats),
        'unparsed_rows': unparsed,
        'items': items,
    }
    json.dump(payload, open(out, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(f"{Path(inp).name}: {len(items)} items {payload['by_kind']} stats={dict(stats)} unparsed={len(unparsed)}")

if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
