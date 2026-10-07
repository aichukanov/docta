# Ручная транскрипция амбулаторной части изменений 2025 (стр. 24-27 PDF), сверена с рендером scale 2.2.
import json, sys
sys.stdout.reconfigure(encoding='utf-8')
F, C = 33.36, 16.68
rows = """
24|Y01004|Konsultativni pregled specijaliste|25.02
24|Y11001|Specijalistički pregled dežurnog ljekara|25.02
24|K05001|Prvi pregled klinički genetičar|F
24|K05002|Ponovni kontrolni pregled (klinički genetičar)|C
24|K06001|Prvi pregled klinički imunologa|F
24|E02001|Prvi pregled - internista|F
24|E02002|Kontrolni pregled internista|C
24|E07001|Prvi pregled - pulmolog|F
24|E07002|Kontrolni pregled - pulmolog|C
24|E07003|Prvi pregled - pneumoftiziolog|F
24|E07004|Kontrolni pregled - pneumoftiziolog|C
24|E08001|Prvi pregled - dječiji endokrinolog|F
24|E08002|Ponovni (kontrolni) pregled dječiji endokrinolog|C
24|E08003|Prvi pregled odojčeta - dječiji endokrinolog|F
24|E08004|Ponovni (kontrolni) pregled djeteta - dječiji endokrinolog|F
24|E08005|Ponovni (kontrolni) pregled odojčeta - dječiji endokrinolog|C
24|E08006|Ponovni (kontrolni) pregled djeteta - dječiji endokrinolog|C
24|E04001|Prvi pregled - kardiolog|F
24|E04002|Kontrolni pregled - kardiolog|C
24|E09001|Prvi pregled - nefrolog|F
24|E09002|Kontrolni pregled - nefrolog|C
24|E09003|Prvi pregled odojčeta - dječiji nefrolog|F
24|E09004|Prvi pregled djeteta - dječiji nefrolog|F
24|E09005|Ponovni pregled odojčeta - dječiji nefrolog|C
24|E09006|Ponovni pregled djeteta - dječiji nefrolog|C
24|E03001|Prvi pregled - reumatolog|F
24|E03002|Ponovni pregled reumatolog|C
24|E10001|Prvi pregled - gastroenterohepatolog|F
24|E10002|Ponovni pregled - gastroenterohepatolog|C
25|E11001|Prvi pregled - hematolog|F
25|E11002|Ponovni pregled - hematolog|C
25|P01001|Prvi pregled - dermatovenerolog|F
25|P01002|Ponovni pregled - dermatovenerolog|C
25|I01001|Prvi pregled - infektolog|F
25|I01002|Ponovni pregled - infektolog|C
25|H01001|Prvi pregled - psihijatar|F
25|H01002|Ponovni pregled - psihijatar|C
25|H05001|Prvi pregled - neurolog|F
25|H05002|Ponovni pregled - neurolog|C
25|S01001|Prvi pregled - hirurg|F
25|S01002|Ponovni pregled - hirurg|C
25|S02001|Prvi pregled - digestivni hirurg|F
25|S02002|Ponovni pregled - digestivni hirurg|C
25|S03001|Prvi pregled - vaskularni hirurg|F
25|S03002|Ponovni pregled - vaskularni hirurg|C
25|G09001|Prvi pregled ljekara specijaliste - HBO|F
25|G09002|Kontrolni pregled ljekara specijaliste - HBO|C
25|S04001|Prvi pregled - grudni hirurg|F
25|S04002|Ponovni pregled - grudni hirurg|C
25|S05001|Prvi pregled - plastični hirurg|F
25|S05002|Ponovni pregled - plastični hirurg|C
25|S06001|Prvi pregled - kardiohirurg|F
25|S06002|Ponovni pregled - kardiohirurg|C
25|R01001|Prvi pregled - ortoped|F
25|R01002|Ponovni pregled - ortoped|C
25|T01001|Prvi pregled - urolog|F
25|T01002|Ponovni pregled - urolog|C
25|S07001|Prvi pregled - neurohirurg|F
25|S07002|Ponovni pregled - neurohirurg|C
25|O01001|Prvi pregled - otorinolaringolog|F
26|O01002|Ponovni pregled - otorinolaringolog|C
26|N01001|Prvi pregled - oftalmolog|F
26|N01002|Ponovni pregled - oftalmolog|C
26|S08001|Prvi pregled - maksilofacijalni hirurg|F
26|S08002|Ponovni pregled - maksilofacijalni hirurg|C
26|S09001|Prvi pregled - dječiji hirurg|F
26|S09002|Ponovni pregled - dječiji hirurg|C
26|C03001|Prvi pregled - ginekolog - akušer|F
26|C03002|Ponovni pregled - ginekolog - akušer|C
26|C03003|Prvi specijalistički pregled u dječijoj i adolescentnoj dobi|F
26|C03004|Ponovni specijalistički pregled u dječijoj i adolescentnoj dobi|C
26|A01001|Prvi pregled - anesteziolog|F
26|B01001|Prvi pregled djeteta - pedijatar|F
26|B01002|Ponovni pregled odojčeta - pedijatar|C
26|B01005|Prvi pregled odojčeta - pedijatar|F
26|B01006|Prvi pregled novorođenčeta - neonatolog|F
26|B01007|Ponovni pregled odojčeta - pedijatar|C
26|B01008|Ponovni pregled odojčeta - neonatolog|C
26|S10001|Prvi pregled odojčeta - dječiji gastroenterohepatolog|F
26|S10002|Prvi pregled djeteta - dječiji gastroenterohepatolog|F
26|S10003|Ponovni (kontrolni) pregled odojčeta - dječiji gastroenterohepatolog|C
26|S10004|Ponovni (kontrolni) pregled djeteta - dječiji gastroenterohepatolog|C
26|S11001|Prvi pregled odojčeta - dječiji pulmolog|F
26|S11002|Prvi pregled djeteta - dječiji pulmolog|F
26|S11003|Ponovni (kontrolni) pregled odojčeta - dječiji pulmolog|C
26|S11004|Ponovni (kontrolni) pregled djeteta - dječiji pulmolog|C
26|S12001|Prvi pregled odojčeta - dječiji alergolog|F
26|S12002|Prvi pregled djeteta - dječiji alergolog|F
26|S12003|Ponovni (kontrolni) pregled odojčeta - dječiji alergolog|C
26|S12004|Ponovni (kontrolni) pregled djeteta - dječiji alergolog|C
26|S13001|Prvi pregled odojčeta - dječiji hematolog|F
26|S13002|Prvi pregled djeteta - dječiji hematolog|F
26|S13003|Ponovni (kontrolni) pregled odojčeta - dječiji hematolog|C
26|S13004|Ponovni (kontrolni) pregled djeteta - dječiji hematolog|C
27|S14001|Prvi pregled odojčeta - dječiji kardiolog|F
27|S14002|Prvi pregled djeteta - dječiji kardiolog|F
27|S14003|Ponovni (kontrolni) pregled odojčeta - dječiji kardiolog|C
27|S14004|Ponovni (kontrolni) pregled djeteta - dječiji kardiolog|C
27|S15001|Prvi pregled odojčeta - dječiji neurolog|F
27|S15002|Prvi pregled djeteta - dječiji neurolog|F
27|S15003|Ponovni (kontrolni) pregled odojčeta - dječiji neurolog|C
27|S15004|Ponovni (kontrolni) pregled djeteta - dječiji neurolog|C
27|Q02001|Prvi pregled - radiolog - radioterapeut|F
27|Q02002|Ponovni (kontrolni) pregled - radiolog - radioterapeut|C
27|X34001|Prvi pregled - onkolog|F
27|X34002|Ponovni (kontrolni) pregled - onkolog|C
27|X34003|Aplikacija hemoterapije|752.58
27|Q03001|Prvi pregled - specijalista nuklearne medicine|F
27|Q03002|Ponovni (kontrolni) pregled - specijalista nuklearne medicine|C
27|H06001|Prvi pregled - epidemiolog|F
27|H06002|Ponovni (kontrolni) pregled - epidemiolog|C
27|H06003|Specijalistički pregled lica u međunarodnom transportu|F
27|H06004|Specijalistički pregledi lica u međunarodnom transportu prilikom povratka u zemlju|F
27|H06005|Pregled ljekara specijaliste epidemiologije u specijalističkoj ambulanti za praćenje kliconoštva|F
27|H06006|Ponovni (kontrolni) pregled - epidemiolog za praćenje kliconoštva|C
27|H07001|Prvi pregled - specijalista higijene|F
27|H07002|Prvi pregled - specijalista higijene - nutricionista|F
27|H07003|Ponovni (kontrolni) pregled specijalista higijene|C
27|H07004|Ponovni (kontrolni) pregled specijalista higijene - nutricionista|C
27|M03001|Prvi pregled - fizijatar|F
27|M03002|Ponovni (kontrolni) pregled - fizijatar|C
27|M03003|Prvi pregled djece sa posebnim potrebama - fizijatar|F
27|M03004|Ponovni pregled djece sa posebnim potrebama - fizijatar|C
27|H08001|Prvi pregled - specijalista urgentne medicine|34.68
"""
items = []
for line in rows.strip().splitlines():
    p, code, name, price = line.split('|')
    items.append({'code': code, 'name': name, 'page': int(p),
                  'price_eur': F if price == 'F' else C if price == 'C' else float(price)})
notes = {
    'E08004': 'В источнике 33,36 у «Ponovni (kontrolni) pregled djeteta» — как у первичного осмотра; у соседних повторных 16,68. Перенесено как напечатано.',
    'H08001': 'В источнике 34,68, у всех остальных первичных осмотров 33,36. Перенесено как напечатано.',
}
for it in items:
    if it['code'] in notes:
        it['note'] = notes[it['code']]
codes = [i['code'] for i in items]
assert len(codes) == len(set(codes)), 'dup codes'
json.dump({'source': '2026-10-02-izmjene-i-dopune-2025.pdf, pages 24-27 (PDF numbering), manual transcription',
           'effective_from': '2025-08-01', 'items_total': len(items), 'items': items},
          open('izmjene-2025-ambulanta.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

pd = json.load(open('paddleocr/izmjene-2025.items.json', encoding='utf-8'))
pm = {i['code']: i for i in pd['items'] if i['kind'] == 'ambulanta'}
mism = [(c['code'], c['price_eur'], pm[c['code']].get('price_eur')) for c in items
        if c['code'] in pm and pm[c['code']].get('price_eur') not in (None, c['price_eur'])]
print('manual', len(items), 'paddle', len(pm))
print('missing in paddle', [c for c in codes if c not in pm])
print('paddle-only', [c for c in pm if c not in codes])
print('price mismatches', mism)
