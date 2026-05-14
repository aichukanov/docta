"""
Batch OCR all KBKotor (Klinička Bolnica Kotor) pricelist PDFs through
PaddleOCR PP-StructureV3.

Same one-time pipeline load pattern as paddleocr_all_fzocg.py.

Source:  e:/pet/docta.me/прейскуранты/kbkotor/*.pdf
Output:  data/kbkotor/<slug>/paddleocr/<pdf-basename>.json

Usage:
    py -3.12 server/scripts/paddleocr_kbkotor.py
"""
import sys
import json
import time
from pathlib import Path

if sys.stdout.encoding.lower() not in ('utf-8','utf8'):
    sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path(__file__).resolve().parents[2]
SRC_DIR = Path(r'e:/pet/docta.me/прейскуранты/kbkotor').resolve()
OUT_ROOT = ROOT / 'data' / 'kbkotor'

# Map PDF basename → output slug (subfolder under data/kbkotor/)
JOBS = {
    'cjenovnik ambulanta za treca lica_compressed.pdf': 'ambulanta-treca-lica',
    'cjenovnik odjeljenja za treca lica_compressed.pdf': 'odjeljenja-treca-lica',
    'odluka uvecanje za treca lica.pdf':                 'odluka-uvecanje',
}

jobs = []
for pdf_name, slug in JOBS.items():
    pdf_path = SRC_DIR / pdf_name
    if not pdf_path.exists():
        print(f'SKIP missing PDF: {pdf_path}')
        continue
    out_dir = OUT_ROOT / slug / 'paddleocr'
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / (pdf_path.stem + '.json')
    jobs.append((pdf_path, out_path, slug))

pending = [(p, o, s) for p, o, s in jobs if not o.exists()]
done = len(jobs) - len(pending)
print(f'Found {len(jobs)} PDFs.  Already done: {done}.  Pending: {len(pending)}.')
if not pending:
    print('Nothing to do.')
    sys.exit(0)

print('\nLoading PP-StructureV3 pipeline...')
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
        out_path.with_suffix('.error.txt').write_text(str(e), encoding='utf-8')

print(f'\nTotal wall time: {(time.time()-t0)/60:.1f} min')
