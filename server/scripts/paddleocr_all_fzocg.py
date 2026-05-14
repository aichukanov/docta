"""
Batch OCR all FZOCG PDFs through PaddleOCR PP-StructureV3.

Loads the pipeline once, processes all 26 PDFs in sequence.
Skips a PDF if its output JSON already exists (idempotent — re-run to
process only what's new).

Output layout:
  data/fzocg/<category-slug>/paddleocr/<pdf-basename>.json

Usage:
    py -3.12 server/scripts/paddleocr_all_fzocg.py
"""
import sys
import json
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC_ROOT = Path(r'e:/pet/docta.me/прейскуранты/fzocg').resolve()
OUT_ROOT = ROOT / 'data' / 'fzocg'

# Map source subfolder name -> output category slug under data/fzocg/
CATEGORY_MAP = {
    'APOTEKARSKA DJELATNOST': 'apotekarska-djelatnost',
    'MEDICINSKO TEHNIČKA POMAGALA': 'medicinsko-pomagala',
    'SEKUNDARNA I TERCIJARNA ZDRAVSTVENA ZAŠTITA – AKUTNO BOLNIČKO LIJEČENJE (DRG)': 'drg-akutno-bolnicko',
    'SEKUNDARNA I TERCIJARNA ZDRAVSTVENA ZAŠTITA – OSTALO BOLNIČKO LIJEČENJE I SPECIJALISTIČKO KONSULATATIVNA I DIJAGNOSTIČKA ZDRAVSTVENE ZAŠTITA': 'sekundarna-ostalo',
    'TRANSFUZIOLOGIJA': 'transfuziologija',
    'ZDRAVSTVENE USTANOVE VAN ZDRAVSTVENE MREŽE': 'van-mreze',
    'primarna zdravsvena zastita': 'primarna-zdravstvena-zastita',
}

# Enumerate jobs first
jobs = []
for src_subfolder, slug in CATEGORY_MAP.items():
    src_dir = SRC_ROOT / src_subfolder
    if not src_dir.exists():
        print(f'SKIP missing source dir: {src_dir}')
        continue
    out_dir = OUT_ROOT / slug / 'paddleocr'
    out_dir.mkdir(parents=True, exist_ok=True)
    for pdf in sorted(src_dir.glob('*.pdf')):
        out_path = out_dir / (pdf.stem + '.json')
        jobs.append((pdf, out_path, slug))

print(f'Found {len(jobs)} PDFs across {len(CATEGORY_MAP)} categories.')

# Filter pending
pending = [(pdf, out, slug) for pdf, out, slug in jobs if not out.exists()]
done = len(jobs) - len(pending)
print(f'Already done: {done}.  Pending: {len(pending)}.')
print()
if not pending:
    print('Nothing to do.')
    sys.exit(0)

print(f'Loading PP-StructureV3 pipeline (one-time setup)...')
t0 = time.time()
from paddleocr import PPStructureV3
pipeline = PPStructureV3(
    use_doc_orientation_classify=False,
    use_doc_unwarping=False,
    use_textline_orientation=False,
    use_seal_recognition=False,
    use_chart_recognition=False,
    use_formula_recognition=False,
)
print(f'Pipeline loaded in {time.time()-t0:.1f}s\n')

for idx, (pdf, out_path, slug) in enumerate(pending, 1):
    print(f'[{idx}/{len(pending)}] {slug}/  {pdf.name}')
    t1 = time.time()
    try:
        results = pipeline.predict(str(pdf))
        layout_results = []
        for res in results:
            pruned = res.json["res"] if isinstance(res.json, dict) and "res" in res.json else res.json
            layout_results.append({"prunedResult": pruned})
        payload = {
            "layoutParsingResults": layout_results,
            "preprocessedImages": None,
            "dataInfo": {
                "source_pdf": pdf.name,
                "source_dir": pdf.parent.name,
                "page_count": len(layout_results),
                "generator": "paddleocr PPStructureV3 (local, paddlepaddle-gpu 3.3.0)",
            },
        }
        with open(out_path, 'w', encoding='utf-8') as f:
            json.dump(payload, f, ensure_ascii=False, indent=2)
        elapsed = time.time() - t1
        size_kb = out_path.stat().st_size / 1024
        print(f'         → {len(layout_results)}p  {size_kb:6.1f}KB  ({elapsed:.1f}s)')
    except Exception as e:
        print(f'         ERROR: {e}')
        # Save error marker
        out_path.with_suffix('.error.txt').write_text(str(e), encoding='utf-8')

print()
print(f'Total wall time: {(time.time()-t0)/60:.1f} min')
