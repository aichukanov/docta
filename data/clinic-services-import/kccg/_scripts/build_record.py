"""final.json + new-entries.json + matched.json -> data/clinic-imports/klinicki-centar-crne-gore-podgorica.json
and new-catalog.md (list of catalog additions for cross-agent review).
Run from data/clinic-services-import/kccg after build_sql.py."""
import json, csv, glob, sys
from pathlib import Path
sys.stdout.reconfigure(encoding='utf-8')

ROOT = Path('../../..').resolve()
OUT = ROOT / 'data/clinic-imports/klinicki-centar-crne-gore-podgorica.json'
SRC = 'data/clinic-pricelists/sources/klinicki-centar-crne-gore-podgorica'

def tsv(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f, delimiter='\t'))
cat = {('ms', r['slug']): r for r in tsv('ref/catalog-services.tsv')} | {('lt', r['slug']): r for r in tsv('ref/catalog-labtests.tsv')}
final = json.load(open('final.json', encoding='utf-8'))
new = json.load(open('new-entries.json', encoding='utf-8'))
newkey = {(e['kind'], e['slug']): e for e in new}
rows = {r['code']: r for r in json.load(open('matched.json', encoding='utf-8'))['items']}
dec = {}
for f in glob.glob('match/out/*.json') + glob.glob('match-drg/out/*.json'):
    for it in json.load(open(f, encoding='utf-8'))['items']:
        dec[it['code']] = it
ovr = json.load(open('match/overrides.json', encoding='utf-8'))
LAB_CAT = {}
import re
for m in re.finditer(r'(\w+)\s*=\s*(\d+)', (ROOT / 'enums/labtest-category.ts').read_text(encoding='utf-8')):
    LAB_CAT[m.group(1)] = int(m.group(2))
SVC_CAT = {m.group(1): int(m.group(2)) for m in re.finditer(r'(\w+)\s*=\s*(\d+)', (ROOT / 'enums/medical-service-category.ts').read_text(encoding='utf-8'))}

services, labs = [], []
for f in final['rows']:
    ne = newkey.get((f['kind'], f['slug']))
    name_en = ne['name_en'] if ne else cat[(f['kind'], f['slug'])]['name_en']
    for code in f['codes']:
        r = rows[code]
        e = {'code': code, 'nameEn': name_en, 'slug': f['slug'], 'source': r['name_kccg'], 'section': r['section'],
             'page': r['page'], 'price': r['price']}
        if r.get('price_2019') is not None and r['changed_2025']:
            e['price2019'] = r['price_2019']
        if r['changed_2025']:
            e['priceFrom'] = '2025'
        if len(f['codes']) > 1:
            e['sharedRow'] = '/'.join(f['codes'])
        e['match'] = sorted(f['via'])[0] if len(f['via']) == 1 else '/'.join(sorted(f['via']))
        if ne:
            e['newEntry'] = True
        why = (ovr.get(code) or {}).get('why') or (dec.get(code) or {}).get('note')
        if why and not rows[code]['target']:
            e['comment'] = why
        (services if f['kind'] == 'ms' else labs).append(e)

# prod ids of the catalog additions, from the prod listing of the clinic (prod-services.json / prod-labtests.json)
PROD_IDS = {}
for t, k in (('services', 'ms'), ('labtests', 'lt')):
    if Path(f'prod-{t}.json').exists():
        for i in json.load(open(f'prod-{t}.json', encoding='utf-8'))['items']:
            PROD_IDS[(k, i['slug'])] = i['id']
VERIFIED = ('2026-10-06: прод-API /api/services/list и /api/labtests/list с clinicIds [65] — все 2199 + 658 строк на месте, '
            'цена / price_max / code / is_price_outdated совпали с SQL у каждой (анализы с урезанным clinicPrices — через /api/labtests/details); '
            'формулировки, привязанные по названию (297), прогнаны через поиск сайта — расхождений, требующих правки, нет (search-check.json).')
additions = []
for e in new:
    ids = [(SVC_CAT if e['kind'] == 'ms' else LAB_CAT).get(c) for c in e.get('categories') or []]
    additions.append({'table': 'medical_services' if e['kind'] == 'ms' else 'lab_tests', 'nameEn': e['name_en'], 'nameSr': e['name_sr'],
                      'slug': e['slug'], 'prodId': PROD_IDS.get((e['kind'], e['slug'])), 'categoryIds': ids, 'specialties': e.get('specialties') or [], 'codes': e['codes']})

excluded = [{'code': x['source'].split(' ')[0], 'source': x['source'], 'reason': x['reason']} for x in final['excluded']]
excluded.append({'code': 'X18001–X18006 (второй блок)', 'source': 'стр. 33: повтор «Tercijalna zdravstvena zaštita pulmologija/pneumoftiziologija» с ценами 8,34 ×5 и 41,70',
                 'reason': 'Коды напечатаны дважды. Первый блок (200,16 / 58,38 / 66,72 / 50,04 / 25,02 / 50,04) = 3 × амбулаторная цена FZOCG и взят; второй — похоже на копию с чужими ценами.'})

decisions = [
    {'topic': 'is_price_outdated', 'decision': 'is_price_outdated = 0 у всех строк (юзер 2026-10-06: возраст документа — недостаточное основание; КЦЦГ заново выложил прайс 2019 в 2026-08 как действующий рядом с изменениями 2025).'},
    {'topic': 'DRG', 'decision': 'Стационар импортирован (юзер 2026-10-06). DRG 2025: 698 групп, цена = коэффициент × 1900,45. Процедурные группы — на существующую процедуру (B05Z → carpal-tunnel-surgery, I03 → total-hip-arthroplasty, H08 → laparoscopic-cholecystectomy…; варианты тяжести дают диапазон), остальные — по записи на код по конвенции hospitalization-for-* (импорт ДЗ Мойковац; 24 их записи переиспользованы по коду). Если у процедуры у КЦЦГ есть и амбулаторная цена (PCI, ЭГДС, колоноскопия, трахеостомия, цистоскопия, перитонеальный диализ, уретероскопия, химиотерапия), DRG вынесен в отдельную hospitalization-запись, чтобы цена эпизода не слилась в диапазон с амбулаторной. Служебные 960Z/961Z/963Z (цена 0) не импортированы.'},
    {'topic': 'genetics', 'decision': 'Все позиции клинической генетики K05 импортированы, включая технические этапы (культуры, выделение ДНК/РНК, ПЦР-техники, электрофорез) — юзер 2026-10-06: пациент захочет сверить цены.'},
    {'topic': 'single-candidate-matches', 'decision': 'Z03050 «Slobodni kortizol» → 605 Free Cortisol in Urine; Z03100 «Bakar – urin» → 1436 Copper in 24h Urine (медь в моче клинически — суточная); D24016 «Tendgen [Rendgen] maxile i mandibule» → 2019 X-Ray Maxilla, Mandible and TMJ. D25019 «Terapeutska adaptacija» (протетика, объект не назван) — кандидата нет, не заведена.'},
    {'topic': 'unit-prices', 'decision': 'X32013 «Elektronsko zračenje» 1,50, X32014 «Fotonsko zračenje» 0,99, X32015 «Ozračivanje komponenata krvi» 0,84 = 3 × FZOCG за единицу дозы — не импортированы, на сайте выглядели бы ценой облучения. H07006 (диетпрограмма для коллективного питания) — услуга организациям, не импортирована.'},
    {'topic': 'price-corrections', 'decision': 'X35016 16,80 → 166,80 и X35015 18,42 → 108,42: в скане выпала цифра, подтверждено 3 × FZOCG и соседними строками (manual-fixes.json).'},
    {'topic': 'source-oddities', 'decision': 'E08004: в 2025 напечатано «Ponovni pregled djeteta» за 33,36, по FZOCG это «Prvi pregled djeteta» — привязан к первичному осмотру. H08001 34,68 (у остальных первичных 33,36) — как напечатано. Ортопед в 2019 под кодами нейрохирурга S07001/S07002 — в 2025 R01001/R01002, так и разведено.'},
    {'topic': 'catalog-growth', 'decision': 'С 2026-10-02 по 2026-10-06 другие импорты добавили ~580 записей каталога; 22 новые записи КЦЦГ совпали с ними (11 по имени, 11 по смыслу — перепроверка recheck/*.out.json) и переведены в existing.'},
]
findings = [
    {'topic': 'fzocg-name-shifts', 'note': 'В medical_service_tariffs названия, съехавшие на соседний код: fzocg-sekundarna Z03054/Z03055 (ACE и Renin переставлены — цены КЦЦГ 105,00 и 41,73 = 3 × 35,00 и 3 × 13,91 подтверждают название КЦЦГ), Z03086 (B6 вместо B1), K06029 («7 antigena» с K06030), K05058 (DNK вместо RNK), K03180 (H1 вместо H3), K05011, X01035, D23004; fzocg-drg: A05A у КЦЦГ — A03Z, у F18B коэффициент 1,30 (paddle читал 2,47 — ошибка OCR, не тарифа), D15Z name_fzocg «Vađenje i nadoknada zuba» вместо «Zahvati na mastoidu».'},
    {'topic': 'catalog-duplicates', 'note': 'Похоже на дубли (не трогал): lab 847/1647, 848/1648 (β2-гликопротеин I IgG/IgM), 155/1673, 154/1672 (double/triple test), 853/855 (C1-ингибитор); svc 1724/7981, 7970/5569, 1635/1699, 4686/6392 (эндопротез тазобедренного). У lab 306 PAI-1 категория GENETICS, по смыслу COAGULATION.'},
    {'topic': 'wide-ranges', 'note': 'Диапазоны от нескольких кодов на одну запись: композитная шина 13,68–82,08 (D22026/D23033); первичный стоматологический осмотр 11,16–22,41 по отделениям; PCI-эквиваленты разведены; TUR простаты (L05/M02) 2527,60–6955,65; ревизия колена 10 927,59–21 475,09.'},
]
open_q = []

rec = {
    'schemaVersion': 1, 'slug': 'klinicki-centar-crne-gore-podgorica', 'name': 'Klinički Centar Crne Gore', 'city': 'Podgorica',
    'cityId': 1, 'googlePlaceId': None,
    'sql': ['server/sql/insert-clinic-prices-klinicki-centar-crne-gore-podgorica.sql'],
    'status': {'generated': '2026-10-06', 'appliedLocal': '2026-10-06', 'appliedProd': '2026-10-06', 'clinicId': 65, 'doctorIds': {},
               'verified': VERIFIED,
               'note': f'Клиника в БД (локально и на проде id 65, сверено /api/clinics/details 2026-10-02 и 2026-10-06), до импорта 0 услуг и 0 анализов. SQL добавил цены и {len(additions)} записей каталога; применён локально и на проде 2026-10-06, VERIFICATION совпал с ожиданием (2199 услуг / 658 анализов, outdated 0, суммы 4 286 263,11 и 25 101,48).'},
    'sources': [
        {'type': 'pdf', 'ref': 'https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-2019.pdf', 'collected': '2026-10-02', 'machineReadable': False,
         'snapshot': f'{SRC}/2026-10-02-cjenovnik-2019.pdf', 'snapshotSha256': '85c59a5aadac14f810b0f9feb5eecff04647803c05a4dbbfb3d0a0d7eda9b65b',
         'documentDate': '2019-05-20', 'lastModified': '2026-08-20',
         'note': '«CJENOVNIK ZA TREĆA LICA KCCG-a», Broj 03/01-12050/1 от 20.05.2019 (вписано от руки), «Podgorica, maj 2019». 78 стр. скана без текстового слоя: стр. 3–59 «Cjenovnik ambulante» (Šifra | Naziv | Iznos, 2274 кода), стр. 60–78 «Cjenovnik – stacionar» (DRG, база 1.103,32). Ссылка стоит на /o-nama/ в блоке правовых актов. Старая копия uploads/2019/08/…_compressed.pdf — те же страницы, не использовалась.'},
        {'type': 'pdf', 'ref': 'https://www.kccg.me/wp-content/uploads/2026/08/Cjenovnik-izmjene-i-dopune-2025.pdf', 'collected': '2026-10-02', 'machineReadable': False,
         'snapshot': f'{SRC}/2026-10-02-izmjene-i-dopune-2025.pdf', 'snapshotSha256': 'e98017a1489a5b4a280151921c42d8333dc01d13a43f6308ca760056f818d1d3',
         'documentDate': '2025-08-01', 'lastModified': '2026-08-20',
         'note': 'Odluka Odbora direktora 03/01-21069/3-1 от 01.08.2025 («USVAJA se Cjenovnik … za neosigurana lica – stacionarna i ambulantna djelatnost»), согласие Минздрава 18.08.2025. 27 стр.: DRG стр. 3–23 (vrijednost koeficijenta 1.900,45 = 2,5 × 760,18 FZOCG), специалистические осмотры стр. 24–27 (124 кода: первичный 33,36, повторный 16,68, Y01004/Y11001 25,02, X34003 752,58). Амбулаторная часть транскрибирована вручную, paddle совпал по всем ценам.'},
    ],
    'method': {
        'ocr': 'PaddleOCR PP-StructureV3 (data/clinic-services-import/kccg/paddleocr/) + независимая постраничная LLM-транскрипция стр. 3–59 (llm/pages-*.json), слияние _scripts/merge_llm.py: 2214 из 2274 кодов совпали до цента, остальные решены перекрёстной проверкой или чтением скана (manual-fixes.json).',
        'priceCheck': 'Цена 2019 = 3,0 × price_ambulanta_eur FZOCG (или 3,0 × odjeljenje, где амбулаторной нет) примерно у 1900 кодов; = цене прайса Danilo (клиника 88) у ~1450 кодов. Изменения 2025 для осмотров: 33,36 = 3 × 11,12, 16,68 = 3 × 5,56 — та же кратность к текущему FZOCG. DRG 2025: база 1900,45 = 2,5 × 760,18.',
        'matching': 'По коду через строки больниц 88/141/131/137 (1617 кодов, составные коды вида J09001/J09002 разбиты), через привязку тарифа FZOCG (10), по смыслу названия КЦЦГ — 10 батчей субагентов (match/out), с ручными правками match/overrides.json. Сборщик: _scripts/build_sql.py.',
    },
    'coverage': {
        'prices': f"{len(services)} кодов услуг → {sum(1 for f in final['rows'] if f['kind']=='ms')} строк clinic_medical_services, {len(labs)} кодов анализов → {sum(1 for f in final['rows'] if f['kind']=='lt')} строк clinic_lab_tests; {len(final['excluded'])} кодов не импортированы (excluded).",
        'priceOutdated': 'is_price_outdated = 0 у всех строк — см. decisions.',
        'ranges': 'Несколько кодов на одну запись каталога: code через «/», price = min, price_max = max.',
        'drg': f"698 групп DRG 2025 (стр. 3–23 изменений), импортировано {sum(1 for x in services if len(x['code']) == 4)} кодов; paddle + независимая транскрипция (llm-drg/), 690 совпали, 7 потерянных paddle строк взяты из транскрипции (коэффициент = FZOCG), цена = коэффициент × 1900,45 совпала с напечатанной у всех. Данные: drg-2025-final.json.",
        'doctors': 'не трогались',
    },
    'catalogAdditions': additions,
    'services': services,
    'labTests': labs,
    'doctors': [],
    'excluded': excluded,
    'decisions': decisions,
    'findings': findings,
    'openQuestions': open_q,
}
OUT.write_text(json.dumps(rec, ensure_ascii=False, indent=1), encoding='utf-8')
with open('new-catalog.md', 'w', encoding='utf-8') as f:
    f.write('# КЦЦГ: новые записи каталога (для сверки между агентами)\n\n| table | name_en | name_sr | codes |\n|---|---|---|---|\n')
    for a in additions:
        f.write(f"| {a['table']} | {a['nameEn']} | {a['nameSr']} | {'/'.join(a['codes'])} |\n")
print('services', len(services), 'labs', len(labs), 'additions', len(additions), 'excluded', len(excluded))
