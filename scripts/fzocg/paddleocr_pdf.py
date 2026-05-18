"""
PaddleOCR PP-StructureV3 wrapper.

Usage:
    py -3.12 scripts/fzocg/paddleocr_pdf.py <input.pdf> <output.json>

Produces JSON in the same shape as the web-version output we already have
(layoutParsingResults[].prunedResult with page_count, parsing_res_list, etc.).
"""
import sys
import json
import os
from pathlib import Path

if len(sys.argv) != 3:
    print("Usage: paddleocr_pdf.py <input.pdf> <output.json>", file=sys.stderr)
    sys.exit(1)

input_pdf = Path(sys.argv[1]).resolve()
output_json = Path(sys.argv[2]).resolve()

if not input_pdf.exists():
    print(f"Error: PDF not found: {input_pdf}", file=sys.stderr)
    sys.exit(2)

output_json.parent.mkdir(parents=True, exist_ok=True)

print(f"[1/3] Loading PP-StructureV3 pipeline (first run downloads ~500MB of models)...")
from paddleocr import PPStructureV3
pipeline = PPStructureV3(
    use_doc_orientation_classify=False,
    use_doc_unwarping=False,
    use_textline_orientation=False,
    use_seal_recognition=False,
    use_chart_recognition=False,
    use_formula_recognition=False,
)

print(f"[2/3] Processing {input_pdf.name}...")
results = pipeline.predict(str(input_pdf))

print(f"[3/3] Serializing results to {output_json}...")
# Collect each page's result into the same structure as web version
layout_results = []
for i, res in enumerate(results):
    pruned = res.json["res"] if isinstance(res.json, dict) and "res" in res.json else res.json
    layout_results.append({"prunedResult": pruned})

payload = {
    "layoutParsingResults": layout_results,
    "preprocessedImages": None,
    "dataInfo": {
        "source_pdf": input_pdf.name,
        "page_count": len(layout_results),
        "generator": "paddleocr PPStructureV3 (local)",
    },
}

with open(output_json, "w", encoding="utf-8") as f:
    json.dump(payload, f, ensure_ascii=False, indent=2)

print(f"Done. {len(layout_results)} pages → {output_json}")
print(f"File size: {output_json.stat().st_size / 1024:.1f} KB")
