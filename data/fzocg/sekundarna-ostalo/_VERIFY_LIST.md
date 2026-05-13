# SEKUNDARNA OSTALO — Verification checklist

Источник: [sekundarna-ostalo-LATEST.json](sekundarna-ostalo-LATEST.json) (3941 позиций)

**Уже проверено пользователем**: 48 (`manually_reviewed: "2026-05-13"`)
**Осталось проверить**: 132 (`note: "VERIFY: ..."`)

---

## Где искать

- **База (PDF)**: `e:/pet/docta.me/прейскуранты/fzocg/SEKUNDARNA.../15846071842.-Cjenovnik-...pdf`
- **Картинки**: `e:/tmp/fzocg_pages/sekundarna_ostalo/base/page-NNN-top.png` и `-bot.png`
- **Поправки**: `e:/tmp/fzocg_pages/sekundarna_ostalo/Odluka-*/`
- **Маппинг секций**: [_SECTIONS.md](_SECTIONS.md)

---

## A.0 ⚠ Конфликты дубликатов (приоритет)

Найдено: **2** кодов. Один из двух экземпляров уже user-verified — реши со вторым.

### `X01059` — 2 вхождения

**•** `X01059` "Postavljanje kanile za testiranje katetera"
   - Цены: `odj=2.6 / amb=5.56`  scheme=`dual`
   - Секция: 7. INTERVENCIJE I PROCEDURE U SPECIJALISTIČKO-KONSULTATIVNOJ ZDRAVSTVENOJ ZAŠTIT  → subsection: `MALI ZAHVATI`
   - **Где смотреть:** base PDF p.36+
   - Note: `VERIFY: code X01059 also used for user-verified "Odstranjivanje stranog tijela". Source PDF page 36+ may have actual duplicate, or this item's code is OCR error.`

**•** `X01059` "Odstranjivanje stranog tijela iz slušnog kanala, nosne šupljine i orofarinksa"
   - Цены: `odj=3.9 / amb=8.34`  scheme=`dual`
   - Секция: 7. INTERVENCIJE I PROCEDURE U SPECIJALISTIČKO-KONSULTATIVNOJ ZDRAVSTVENOJ ZAŠTIT  → subsection: `MALI ZAHVATI`
   - **Где смотреть:** base PDF p.36+
   - Note: `VERIFY: code X01069 also used for "Piroterapija" (user-verified). Source PDF appears to have a real duplicate code — pick one to renumber.`

### `Z02098` — 2 вхождения

**•** `Z02098` "Proteini urina (kvantitativno)" ✅ user-verified
   - Цены: `amb=2.24`  scheme=`single_ambulanta`
   - Секция: 2. BIOHEMIJSKO-HEMATOLOŠKA I IMUNOLOŠKA LABORATORIJSKA DIJAGNOSTIKA  → subsection: `SEKUNDARNA ZDRAVSTVENA ZAŠTITA - BIOHEMIJSKA LABORATORIJSKA DIJAGNOSTIKA`
   - **Где смотреть:** base PDF p.8+

**•** `Z02098` "Osmotska rezistencija eritrocita"
   - Цены: `amb=8.63`  scheme=`single_ambulanta`
   - Секция: 2. BIOHEMIJSKO-HEMATOLOŠKA I IMUNOLOŠKA LABORATORIJSKA DIJAGNOSTIKA  → subsection: `HEMATOLOGIJA I KOAGULACIJA - LABORATORIJSKA DIJAGNOSTIKA`
   - **Где смотреть:** base PDF p.8+
   - Note: `VERIFY: code Z02098 also used for user-verified "Proteini urina". Source PDF page 8+ may have actual duplicate, or this item's code is OCR error.`

---

## C. OCR-неуверенность

Найдено: **16**

| Код | Услуга | Где смотреть | Note |
|---|---|---|---|
| `J07007` | Ultrazvuk štitne i paraštitne žlijezde | base PDF p.30+ | OCR_FIX: code corrected J07014→J07007 per PDF p.29 (J07014 does not exist in source; sequence is non-linear: J07009-J07013, J07001-J07006, J07008, J07 |
| `X04055` | Uklanjanje tumora vaginalnog zida | base PDF p.57+ | VERIFY: возможно 'vaginalnog zica' (OCR неясно) |
| `X04060` | Citološki bris po Papanikolau | base PDF p.57+ | VERIFY: имя может быть 'Citološka iglica na Papanikolau' (OCR неясно) |
| `X04065` | Uklanjanje vaginalnih septuma | base PDF p.57+ | VERIFY: код может быть X04055 (OCR неясно), но это привело бы к дубликату с предыдущим |
| `D02091` | Enteroliza | base PDF p.60+ | VERIFY: имя процедуры (OCR неясно) |
| `D02212` | Dvotrebna resekcija želuca-laparoskopska op. | base PDF p.60+ | VERIFY: имя 'Dvotrebna' / 'Dvotrečna' / 'Dvotrebna resekcija' — OCR неясно |
| `D02255` | Lijeva hemikolektomija sa anastomozom | base PDF p.60+ | VERIFY: на изображении название может быть 'sa formiranjem stome' (OCR показал то же что и D02256) |
| `D10014` | Reparacija defectus septi atriorum primum | base PDF p.68+ | VERIFY: имя могло быть 'septi atriorum trivum' (OCR неясно) |
| `D26144` | Endovaskularna procedura plasiranja stent grafta u popliteal | base PDF p.69+ | VERIFY: имя в OCR показано как 'popšiteainu' — корректно 'poplitealnu' |
| `D03055` | Ekscizija spermatokele sa epididimektomijom | base PDF p.88+ | VERIFY: OCR read 94,50 for operacija but 94.50+16.90≠101.40; value 84.50 would match the sum |
| `D03064` | Cistektomija parcijalna bez resekcije ušća | base PDF p.88+ | VERIFY: OCR shows 'C-stektomija parcijalna'; likely 'Cistektomija parcijalna' |
| `D03124` | Simfiziotomija potkovičastog bubrega | base PDF p.88+ | VERIFY: OCR showed code 'D03125' twice; first row reassigned to D03124 based on sequence |
| `D05068` | Fasciotomija, parcijalno ekscizija ciste ili benignih tumora | base PDF p.97+ | VERIFY: OCR text 'Fasciotomija, palmarna, subkutana (kod Dupuytren-ove kontrakture), otvorena' partially appears; name reconstructed |
| `D05077` | Metakarpalna fraktura - zatvorena ili otvorena (složena) rep | base PDF p.97+ | VERIFY: name OCR ambiguous |
| `D05083` | Fraktura tarzalnih kostiju - zatvorena ili otvorena (složena | base PDF p.97+ | VERIFY: same name as D05082 in OCR — likely subtle wording difference in source |
| `B01001` | Prvi pregled dijeteta - pedijatar | base PDF p.105+ | OCR_FIX: code corrected B01003→B01001 per base PDF scan (p.105 area, section 52 OPŠTA PEDIJATRIJA) |

---

## D. Цена под сомнением

Найдено: **33**

| Код | Услуга | Цены | Где смотреть | Note |
|---|---|---|---|---|
| `Z01097` | Određivanje Na+ u serumu | amb=1.26 | base PDF p.8+ | VERIFY: price partly clipped at page bottom, assumed 1.26 from neighbouring rows |
| `J06032` | Kontrola drenaže patoloških tečnih kolekcija, bili | amb=12.67 | base PDF p.30+ | VERIFY: price 12.67 is lower than surrounding entries |
| `V01001` | Intermitentna zamjena bubrežne funkcije - Hronična | odj=36.92, amb=36.92 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01002` | Funkcionalno ispitivanje bubrežne funkcije | odj=5.56, amb=5.56 | base PDF p.41+ | VERIFY: single merged price cell in PDF — applied to both columns |
| `V01003` | Ispitivanje tubulskih funkcija | odj=5.56, amb=5.56 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01004` | Testovi opterećenja kod sumnje na renalnu tubulsku | odj=5.56, amb=5.56 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01005` | Test koncentracione sposobnosti bubrega | odj=5.56, amb=5.56 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01006` | Kontinuirana zamjena bubrežne funkcije (CRRT) | odj=36.92, amb=36.92 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01007` | Intermitentna zamjena bubrežne funkcije - Urgentna | odj=36.92, amb=36.92 | base PDF p.41+ | VERIFY: single merged price cell |
| `V01008` | Intermitentna zamjena bubrežne funkcije - Peritone | odj=36.92, amb=36.92 | base PDF p.41+ | VERIFY: single merged price cell |
| `X20001` | ERCP (duodenoskopija sa kanulacijom papille Vateri | odj=55.68 | base PDF p.42+ | VERIFY: single price column shown |
| `X20002` | ERCP sa EPT | odj=87.25 | base PDF p.42+ | VERIFY: single price column |
| `X20003` | ERCP sa ekstrakcijom kalkulusa | odj=104.7 | base PDF p.42+ | VERIFY: single price column |
| `X20004` | ERCP sa plasiranjem plastičnog stenta | odj=104.7 | base PDF p.42+ | VERIFY: single price column |
| `X20005` | ERCP sa plasiranjem metalnog stenta | odj=104.7 | base PDF p.42+ | VERIFY: single price column |
| `X20006` | ERCP sa balon dilatacijom žučnih vodova | odj=104.7 | base PDF p.42+ | VERIFY: single price column |
| `X20007` | ERCP sa mehaničkom dilatacijom žučnih vodova | odj=104.7 | base PDF p.42+ | VERIFY: single price column |
| `X20008` | ERCP sa biopsijom papile | odj=64 | base PDF p.42+ | VERIFY: single price column |
| `X20009` | ERCP sa plasiranjem nazobilijarnog katetera | odj=64 | base PDF p.42+ | VERIFY: single price column |
| `X20010` | Bežična video kapsula (za tanko crijevo) | odj=51.91 | base PDF p.42+ | VERIFY: single price column |
| `X20011` | C13 urea izdisajni test na H. Pylori | odj=13.85 | base PDF p.42+ | VERIFY: single price column |
| `H14001` | Izoelektrično fokusiranje likvora i seruma (IEFL) | odj=20.54, amb=20.54 | base PDF p.44+ | VERIFY: single merged price cell |
| `D07001` | Ultra B2 | amb=336 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07002` | Sekundarna implantacija IOL | amb=567 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07003` | Keratoplastika | amb=2142 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07004` | INTACS - intraokularni prsten | amb=728 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07005` | Vađenje plombe sa plastikom konjuktive | amb=238 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07006` | Evakuacija silikonskog ulja | amb=498 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07007` | Zamjena silikonskog ulja | amb=672 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07008` | Operacija ablacije mrežnjače | amb=1125 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07009` | Vitrektomija | amb=1355 | ? | VERIFY AMEND 2017-01-01: scheme=unknown, single price applied to ambulanta |
| `D07011` | Vitrektomija sa kataraktom | amb=1610 | ? | VERIFY AMEND 2017-04-01: scheme=unknown, single price applied to ambulanta |
| `D24025` | Izrada retencionog aparata | amb=43.29 | ? | VERIFY AMEND 2021-01-01: scheme=unknown, single price applied to ambulanta |

---

## F. Прочее

Найдено: **79**

| Код | Услуга | Где смотреть | Note |
|---|---|---|---|
| `Y04010` | Nemedicinski dio BO dana u intenzivnoj njezi, koro | base PDF p.5+ | VERIFY: code Y04010 appears twice on page-005-bot; second instance may be Y04014 |
| `Y04014` | Nemedicinski dio BO dana - za kardiohirurgiju | base PDF p.5+ | VERIFY: code may be Y04010 (read as duplicate); guessed Y04014 to disambiguate |
| `Z01023` | Određivanje aktivnosti AST | base PDF p.8+ | VERIFY: duplicate code Z01023 across base (instances: 2) |
| `Z01024` | Određivanje aktivnosti CK | base PDF p.8+ | VERIFY: code Z01024 duplicates earlier entry (direktnog bilirubina) - likely OCR misread \| VERIFY: duplicate code Z01024 across base (instances: 2) |
| `Z01025` | Određivanje aktivnosti CK-MB | base PDF p.8+ | VERIFY: code Z01025 duplicates earlier entry (gvožđa) - likely OCR misread \| VERIFY: duplicate code Z01025 across base (instances: 2) |
| `Z01108` | Određivanje kalcijuma u urinu | base PDF p.8+ | VERIFY: code may be Z01106 (duplicate with uree u urinu) |
| `Z01110` | Određivanje kirensa kreatinina | base PDF p.8+ | VERIFY: code may be Z01100 (read may conflict with LDH code) |
| `Z02029` | Progesteron | base PDF p.8+ | VERIFY: code Z02029 duplicates earlier C-peptid \| VERIFY: duplicate code Z02029 across base (instances: 2) |
| `Z02038` | PSA - slobodni | base PDF p.8+ | VERIFY: code Z02038 may duplicate Z02208 'PSA - slobodni' |
| `Z02039` | Beta HCG | base PDF p.8+ | VERIFY: code may differ - Z02039 appears twice \| VERIFY: duplicate code Z02039 across base (instances: 2) |
| `Z02204` | PSA - ukupni | base PDF p.8+ | VERIFY: code Z02204 may duplicate Z02034 'PSA - ukupni' |
| `Z03082` | IgA na tkivnu transglutaminazu | base PDF p.8+ | VERIFY: code Z03082 duplicates earlier 'Biohemijski pregled likvora' \| VERIFY: duplicate code Z03082 across base (instances: 2) |
| `Z03087` | Vitamin B6 | base PDF p.8+ | VERIFY: name duplicates previous Vitamin B6 row |
| `K02008` | Detekcija antimikrobnih antitijela latex aglutinac | base PDF p.15+ | VERIFY: name duplicates K02007 |
| `K03056b` | Bakteriološko ispitivanje perikardijalne tečnosti  | base PDF p.15+ | VERIFY: code K03056 appears twice in source (likvora and perikardijalne tečnosti); appended 'b' to disambiguate |
| `K03068b` | Bakteriološko ispitivanje sinovijalne tečnosti - a | base PDF p.15+ | VERIFY: code K03068 appears twice in source; appended 'b' to disambiguate |
| `K03088` | Bakteriološko ispitivanje krvi - anaerobno | base PDF p.15+ | VERIFY: name duplicates K03085 |
| `K03180` | Ispitivanje prisustva Influenza A subtipa H1 - RT- | base PDF p.15+ | VERIFY: name duplicates K03179 - subtype may differ in source |
| `K05001` | Prvi pregled - klinički genetičar | base PDF p.22+ | single_cijena_column |
| `K05019` | Kultivacija ćelija amnionske tečnosti | base PDF p.22+ | single_cijena_column |
| `K05058` | DNK izolacija iz limfocita periferne krvi i ćelijs | base PDF p.22+ | VERIFY: duplicate name with K05055, possibly different method |
| `K06001` | Prvi pregled imunologa | base PDF p.22+ | single_cijena_column |
| `L01090` | Pregled PAPA brisa | base PDF p.26+ | single_cijena_column |
| `J01001` | Prvi specijalistički pregled (radiolog) | base PDF p.30+ | single_cijena_column; footnote: Uz svaki pregled RTG usluga fakturišu se i prvi pregled radiologa |
| `J07009` | Doppler sonografija vrata | base PDF p.30+ | single_cijena_column |
| `J08015` | Kompjuterizovana tomografija bez kontrasta | base PDF p.30+ | single_cijena_column |
| `J09001` | MR pregled mozga - glave bez kontrasta | base PDF p.30+ | single_cijena_column |
| `J09021` | MR vrata - sa kontrastom | base PDF p.30+ | VERIFY: only 'sa kontrastom' row visible; 'bez kontrasta' variant may exist but not seen |
| `J10003` | Pneumoangiografija | base PDF p.30+ | VERIFY: source code looks like 'J10015' but J10015 already assigned to Aortografije; using J10003 as best guess based on order |
| `J10015` | Aortografije: - torakalne aorte - abdominalne aort | base PDF p.30+ | single_cijena_column |
| `J11001` | Panoramska dentalna radiografija | base PDF p.30+ | single_cijena_column |
| `X01016` | Svođenje hirurških konaca | base PDF p.36+ | VERIFY: source shows duplicate code X01015 for both rows; using X01016 as likely correct code |
| `X01050` | Toaleta veće rane mokrim oblogama, jedan dnevno | base PDF p.36+ | VERIFY: source row partially overlapped; name approximated |
| `X01051` | Lokalna anestezija - regionalna | base PDF p.36+ | VERIFY: name approximated |
| `X02201` | Ispitivanje kožne preosjetljivosti na inhalacione  | base PDF p.36+ | VERIFY: source code looks like X02201, may be X02001 |
| `E08002` | Ponovni (kontrolni) pregled - endokrinolog | base PDF p.40+ | VERIFY: section number inferred — header not on page 40 |
| `X19002` | Izvođenje dinamskih testova HHN | base PDF p.40+ | VERIFY: name abbreviation (HHN vs HHO) unclear in image |
| `X19007` | Davanje insulinske terapije | base PDF p.40+ | VERIFY: code may be X19006 or X19007 |
| `E09004` | Ponovni (kontrolni) pregled odojčeta - dječiji nef | base PDF p.41+ | VERIFY: code E09004 inferred from sequence; image partially blurred |
| `E09006` | Ponovni (kontrolni) pregled djeteta - dječiji nefr | base PDF p.41+ | VERIFY: code E09006 inferred |
| `X10054` | Hirurško zbrinjavanje kondiloma analne regije | base PDF p.45+ | VERIFY: duplicate code X10054 across base (instances: 2) |
| `G09001` | Prvi pregled ljekara specijaliste - HBO | base PDF p.46+ | VERIFY: HIPERBARIČNA section uses single CIJENA column — placed in ambulanta |
| `G09002` | Kontrolni pregled ljekara specijaliste - HBO | base PDF p.46+ | VERIFY: single CIJENA column |
| `G09003` | Hiperbarična oksigena terapija (HBO) | base PDF p.46+ | VERIFY: single CIJENA column |
| `X07022` | Pozicioni test | base PDF p.51+ | VERIFY: code X07022 name from page-051-top |
| `X07039` | Akumetrijska ispitivanja | base PDF p.51+ | VERIFY: X07038 vs X07039 names similar |
| `X07070` | Epifaringoskopija sa biopsijom | base PDF p.51+ | VERIFY: code X07070 inferred |
| `X07072` | Otvorena repozicija svježih preloma nosnih kostiju | base PDF p.51+ | VERIFY: code X07072 inferred |
| `X07083` | Detamponaca nosa | base PDF p.51+ | VERIFY: code X07083 inferred |
| `X07091` | Vestibulokalorički testovi | base PDF p.51+ | VERIFY: code inferred |
| `X07097` | Repozicija svježeg preloma nosnih kostiju sa imobi | base PDF p.51+ | VERIFY: code X07097 inferred from sequence |
| `X07098` | Endoskopski pregled nosa | base PDF p.51+ | VERIFY: code X07098 inferred from sequence |
| `X07116` | Ezofagoskopija sa biopsijom, odstranjenjem tumora  | base PDF p.51+ | VERIFY: code X07116 (was X07114 on page-053-top) |
| `X07117` | Retrogradna ezofagoskopija po Tucker-u | base PDF p.51+ | VERIFY: code X07117 (was X07115) |
| `X07120` | Vježbe fonacije | base PDF p.51+ | VERIFY: code X07120 inferred — name 'Vježbe fonacije' appeared twice |
| `X07125` | Vježbe artikulacije | base PDF p.51+ | VERIFY: code |
| `X07126` | Uvjetovanje ezofagusnog govora | base PDF p.51+ | VERIFY: code X07125 or X07126 |
| `X06058` | Određivanje naočara na široku zjenicu bez astigmat | base PDF p.54+ | VERIFY: X06057 vs X06058 — one is usku, the other inferred as široku |
| `X06074` | Ekzoftalmo chalazionis kod djece | base PDF p.54+ | VERIFY: code (image showed X06073 row but X06073 was used earlier) |
| `X06076` | Određivanje i propisivanje naočara kod astigmatizm | base PDF p.54+ | VERIFY: code X06076 (image showed X06078) |
| `X06078` | Oftalmološki pregled biomikroskopom | base PDF p.54+ | VERIFY: code (saw X06079) |
| `X06079` | OCT (optička koherentna tomografija) | base PDF p.54+ | VERIFY: code (saw X06080) |
| `X06080` | Skijaskopija kod djece | base PDF p.54+ | VERIFY: code |
| `X06081` | Ispitivanje osjetljivosti na boje pomoću anomalosk | base PDF p.54+ | VERIFY: only ambulanta column visible |
| `D02048` | Transrektalna drenaža pelvičnog abscesa | base PDF p.60+ | VERIFY: Ukupno 32.50 не сходится с Operacija 19.50 + Anestezija 6.50 = 26.00 |
| `D02205` | Hernija TEP femoralna bilateralna | base PDF p.60+ | VERIFY: на изображении название может быть 'Hernija TAPP femoralna bilateralna' (дубликат с D02204) |
| `D02222` | Hemikolektomija lijeva laparoskopska sa kolorekto  | base PDF p.60+ | VERIFY: дубликат имени с D02221 — возможно одно из них имеет 'sa formiranjem stome' |
| `D02263` | Supraselektivna vagotomija-laparoskopska op. | base PDF p.60+ | VERIFY: код в источнике мог быть D02216, но D02216 уже занят 'Vađenje stranog tijela...' — присвоен временный код D02263 |
| `D02264` | Veća resekcija vene saphene externe i susjednih ve | base PDF p.60+ | VERIFY: код в источнике мог быть D02003 (дубликат с D02003 Splenektomija), присвоен временный D02264 |
| `D02265` | Cefalična duodenopankreatektomija (Whipplae) - lap | base PDF p.60+ | VERIFY: код в источнике может быть D02222 (дубликат), присвоен временный D02265 |
| `D02267` | Kolektomija sa totalnom proktektomijom i ileostomi | base PDF p.60+ | VERIFY: код в источнике может быть D02216 (дубликат), присвоен временный D02267 |
| `D02268` | Ekscizija komplikovane analne fistule | base PDF p.60+ | VERIFY: код в источнике может быть D02094 (дубликат с D02094 Laparoskopska eksploracija trbušne duplje), присвоен временный D02268 |
| `D26066` | Resekcija i anastomoza aorte (EKC) | base PDF p.69+ | VERIFY: 'EKC' возможно 'ekstrakorporalna cirkulacija' |
| `D29156` | Ekscizija ekstenzorne aponeuroze | base PDF p.77+ | VERIFY: same description as D29124, possible duplicate in source |
| `D30100` | Mandibula/parcijalna resekcija/replantacija | base PDF p.84+ | VERIFY: code not clearly visible in scan, inferred from sequential numbering between D30099 and D30101 |
| `D03010` | Cistolitotomija (samo patrijak) | base PDF p.88+ | VERIFY: 'samo patrijak' may be 'samo punktirajem' or similar |
| `D03081` | Uretrektomija (samo patrijak) | base PDF p.88+ | VERIFY: 'samo patrijak' may be 'samo punktirajem' or similar |
| `X32015` | Ozračivanje komponenata krvi | base PDF p.107+ | VERIFY: ambulanta value low-resolution |
| `J07014` | Ultrazvuk pregled vrata | ? | NEW_FROM_AMENDMENT_NO_BASE: izmjena 01-5113 for code not present in base |