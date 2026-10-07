import sys, os, pypdfium2 as pdfium
pdf = pdfium.PdfDocument('../../clinic-pricelists/sources/klinicki-centar-crne-gore-podgorica/2026-10-02-cjenovnik-2019.pdf')
a, b = int(sys.argv[1]), int(sys.argv[2])
out = 'render/2019'
os.makedirs(out, exist_ok=True)
for p in range(a, b + 1):
    img = pdf[p - 1].render(scale=2.2).to_pil(); w, h = img.size
    img.crop((0, 0, w, h // 2 + 50)).save(f'{out}/p{p:02d}-a.png')
    img.crop((0, h // 2 - 50, w, h)).save(f'{out}/p{p:02d}-b.png')
print('rendered', a, b)
