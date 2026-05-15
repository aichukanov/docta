# TODO: Translation batch for clinic 131 (JZU Specijalna bolnica Risan)

Following the canonical [CLINIC_SERVICES_IMPORT.md](../../../docs/import/CLINIC_SERVICES_IMPORT.md) flow.

## Status

Batch 1 (765 items matching clinic-88 imports) is in `server/sql/insert-clinic-131-fzocg-batch-01.sql`.
This file tracks the remaining 147 items that need a translation batch before they can be linked.

- **122 items** are in [FZOCG sekundarna FINAL](../../fzocg/sekundarna-ostalo/sekundarna-ostalo-FINAL.json) with clean Serbian names but missing from clinic-88.
- **25 items** are OCR-garbled in source PDF and absent from FZOCG (need manual name cleanup).

## Price scheme

Where both ambulanta (×3.0) and odjeljenja (×2.5) prices exist, store as a range: `price = min`, `price_max = max`.
Where only one exists, store as fixed price.

---

## Section A: 122 FZOCG-known items (need translation only)

### 11. KARDIOLOGIJA (8 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| X14001 | svc | Holter EKG | — | 48.75 |
| X14002 | svc | Ehokardiografija | — | 32.50 |
| X14003 | svc | Dinamska elektrokardiografija (ergometrija) | — | 19.50 |
| X14004 | svc | Test opterećenja na ergociklu sa kompletnim EKG snimkom, prije i poslije opterećenja sa submaksimalnim testom opterećenja | — | 32.50 |
| X14005 | svc | Dinamska ehokardiografija (stres eho test) | — | 48.75 |
| X14006 | svc | Farmakološki testovi za procjenu ishemije i/ili vijabilnosti miokarda (stres eho test) | — | 48.75 |
| X14007 | svc | Telemetrija | — | 14.63 |
| X14008 | svc | Holter krvnog pritiska | — | 32.50 |

### 19. NEUROLOGIJA (1 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| H14001 | svc | Izoelektrično fokusiranje likvora i seruma (IEFL) | — | 51.35 |

### 2. BIOHEMIJSKO-HEMATOLOŠKA I IMUNOLOŠKA LABORATORIJSKA DIJAGNOSTIKA (24 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| Z03006 | lab | Protrombinski fragment 1+2 | — | 15.20 |
| Z03007 | lab | Antitrombin III, antigen | — | 0.00 |
| Z03008 | lab | Faktor koagulacije XIII | — | 24.30 |
| Z03009 | lab | Faktor koagulacije II | — | 21.03 |
| Z03010 | lab | Faktor koagulacije V | — | 36.30 |
| Z03011 | lab | Faktor koagulacije VII | — | 24.28 |
| Z03012 | lab | Faktor koagulacije VIII, aktivnost | — | 0.00 |
| Z03013 | lab | Faktor koagulacije VIII, antigen | — | 29.98 |
| Z03144 | lab | Apo A2 | — | 17.50 |
| Z03145 | lab | Apo B | — | 17.50 |
| Z03146 | lab | Apo E | — | 0.00 |
| Z03147 | lab | Alfa 1-mikroglobulin | — | 26.25 |
| Z03148 | lab | Alfa 2-makroglobulin | — | 26.25 |
| Z03149 | lab | Elektroforeza proteina seruma, plazme | — | 8.75 |
| Z03150 | lab | Elektroforeza hemoglobina | — | 8.75 |
| Z03152 | lab | Analiza sinovijalne tečnosti | — | 87.50 |
| Z03153 | lab | Analiza punktata ciste | — | 26.25 |
| Z03154 | lab | Porfirin u urinu (kvalitativno) | — | 26.25 |
| Z03155 | lab | Porfobilinogen u urinu (kvalitativno) | — | 26.25 |
| Z03156 | lab | Melanin u urinu (kvalitativno) | — | 0.00 |
| Z03157 | lab | Masne kapi u urinu | — | 26.25 |
| Z03159 | lab | Osmolarnost urina | — | 61.25 |
| Z03160 | lab | Jonotoreza | — | 61.25 |
| Z03161 | lab | Hloridi u znoju | — | 52.50 |

### 21. DIGESTIVNA HIRURGIJA (1 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| S02002 | svc | Ponovni (kontrolni) pregled - digestivni hirurg | 8.34 | — |

### 25. PLASTIČNA I REKONSTRUKTIVNA HIRURGIJA (1 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| S05002 | svc | Ponovni (kontrolni) pregled - plastični hirurg | 8.34 | — |

### 26. KARDIOHIRURGIJA (1 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| S06002 | svc | Ponovni (kontrolni) pregled - kardiohirurg | 8.34 | — |

### 32. MAKSILOFACIJALNA HIRURGIJA (16 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| X28001 | svc | Uklanjanje distraktora | — | 13.00 |
| X28002 | svc | Repozicija luksacije mandibularni zglob | 33.36 | 48.75 |
| X28003 | svc | Aktivacija mandibularnog odiljenja | 125.10 | 3.25 |
| X28004 | svc | Ekstraoralna incizija abscesa | 8.34 | 32.50 |
| X28005 | svc | Intraoralna incizija abscesa | 83.40 | 13.00 |
| X28006 | svc | Kauterizacija kože lica | 33.36 | 3.90 |
| X28007 | svc | Sklerozacija benignih tumora kože lica | 0.00 | 13.00 |
| X28008 | svc | Sijalometrija | 50.04 | 19.50 |
| X28009 | svc | Plasiranje kanile u angularnu venu | 83.40 | 32.50 |
| X28010 | svc | Ekstrakcija zuba - hiruška | 66.72 | 26.00 |
| X28011 | svc | Prelom-alveolarnog grebena | 75.06 | 29.25 |
| X28012 | svc | Imobilizacija vilica - privremena | 125.10 | 48.75 |
| X28013 | svc | Imobilizacija vilica - fac. šine | 125.10 | 48.75 |
| X28014 | svc | Hiruška ekscizija krune zuba | 66.72 | 26.00 |
| X28015 | svc | Konzervativno liječenje oroantralne komunikacije | 41.70 | 16.25 |
| X28016 | svc | Oroantralno zatvaranje - bez sinusa | 125.10 | 48.75 |

### 35. ANESTEZIJA SA REANIMACIJOM (17 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| X15001 | svc | Specijalna anestezija/analgezija | — | 16.25 |
| X15002 | svc | Centralni nervni blokovi za izvođenje hirurških intervencija | — | 19.50 |
| X15005 | svc | Konverziia ritma elektrosokom | — | 32.50 |
| X15006 | svc | Plasiranje centrainog venskog katetera | — | 16.25 |
| X15007 | svc | Sedacija i anestezija za izvođenje ambulantnih hirurških intervencija | — | 9.75 |
| X15008 | svc | Aplikacija u jednoj tački - farmakopunktura | — | 3.25 |
| X15009 | svc | Blokada interkostalnih nerava | — | 6.50 |
| X15010 | svc | Blokada drugih perifernih živaca | — | 6.50 |
| X15011 | svc | Lumbalna, sakralna i kokcigealna blokada | — | 9.75 |
| X15012 | svc | Pudendalna blokada | — | 9.75 |
| X15013 | svc | Ilioingvinalna ili iliohipogastrična blokada | — | 9.75 |
| X15014 | svc | Blok nervus ischiadicus | — | 9.75 |
| X15015 | svc | Blok plexus brachialis | — | 9.75 |
| X15016 | svc | VIMA (uvod i održavanje inhalacionom anestezijom) | — | 16.25 |
| X15018 | svc | Tretiranje bolesnika koji imaju respiracionu insuficijenciju sa respiratorom za 1h efektivnog rada jedna specijalisticka (najviše 2 sata) | — | 26.00 |
| X15019 | svc | Kontinuirana epiduralna anestezija/analgezija | — | 32.50 |
| X15020 | svc | Plasiranje laringealne maske | — | 16.25 |

### 52. OPŠTA PEDIJATRIJA SA NEONATOLOGIJOM (10 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| X29001 | svc | Mehanička ventilacija novorođenčeta | 66.72 | 26.00 |
| X29002 | svc | Visokofrekventna oscilatorna ventilacija novorođenčeta | 66.72 | 26.00 |
| X29003 | svc | Primjena Kontinuirajućeg pozitivnog pritiska u disajnim putevima - CPAP | 25.02 | 9.75 |
| X29004 | svc | Primjena azot oksida (NO) | 16.68 | 6.50 |
| X29005 | svc | Primjena surfaktanta kod novorođenčadi | 150.12 | 6.50 |
| X29006 | svc | Oksigenoterapija kod novorođenčeta | 16.68 | — |
| X29007 | svc | Kateterizacija umbilikalne vene | 108.42 | 42.25 |
| X29008 | svc | Eksangvinotransfuzija | 125.10 | 48.75 |
| X29009 | svc | Enteralna ishrana | 16.68 | 6.50 |
| X29010 | svc | Totalna parenteralna ishrana (TPI) | 12.51 | 4.88 |

### 6. RADIOLOŠKA DIJAGNOSTIKA (28 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| J10002 | svc | Flebografije: - selektivna - subselektivna | — | 121.80 |
| J10009 | svc | Transkutana ili transhepatalna holegrafija | — | 347.98 |
| J10010 | svc | Ventrikulografija lijevog srca | — | 347.98 |
| J10012 | svc | Kateterizacija desnog i/ili lijevog srca | — | 347.98 |
| J10015 | svc | Aortografije: - torakalne aorte - abdominalne aorte | — | 382.78 |
| J10023 | svc | Perkutana transluminalna koronarna intervencija | — | 626.38 |
| J10025 | svc | Transkateterska ugradnja kava-filtera | — | 313.18 |
| J10026 | svc | Splenoportografija | — | 313.18 |
| J10027 | svc | Arteriografija | — | 21.10 |
| J10028 | svc | Vertebralna angiografija | — | 312.75 |
| J10029 | svc | Selektivna arteriografija (arterije celijake, mezenterike superior, inferior, arterije renalis...) | — | 347.98 |
| J10031 | svc | Selektivna arteriografija (arterije hepatika proprije, gastroduodenalis, jejunalis...) | — | 347.98 |
| J10032 | svc | Limfomografija | — | 347.98 |
| J10033 | svc | Perkutana nefrostomija pod kontrolom rtg-skopskog aparata | — | 245.05 |
| J10034 | svc | Adrenalna flebografija | — | 174.00 |
| J10035 | svc | I.V. urografija sa punkcijom bubrega | — | 278.38 |
| J10037 | svc | Karotidna angiografija | — | 312.75 |
| J10038 | svc | Elektrofiziološko ispitivanje | — | 2.50 |
| J10040 | svc | Implantacija loop recordera | — | 243.58 |
| J10045 | svc | Rotabalator | — | 626.38 |
| J10046 | svc | Određivanje značajnosti graničnih lezija na koronarnim krvnim sudovima (Flow fraction reserve-FFR i intravaskularni ultrazvuk- IVUS) | — | 114.40 |
| J10047 | svc | Transezofagealna ehokardiografija | — | 215.45 |
| J10048 | svc | Kateterizacija plućnog krvotoka sa mjerenjem pritiska | — | 347.98 |
| J10049 | svc | Kateterizacija plućnog krvotoka i aorte sa venepunkcijom | — | 347.98 |
| J10050 | svc | Kateterizacija plućnog krvotoka i aorte sa 3 katetera | — | 347.98 |
| J10052 | svc | Kateterizacija lijeve predkomore i aorte sa perkutanim pritiskom preko femoralne arterije sa mjerenjem pritiska | — | 0.00 |
| J10053 | svc | Kateterizacija lijeve predkomore i aorte sa mikrotransducerima i perkutanim pritiskom preko femoralne arterije po modifikovanoj Seldinger-ovoj metodi | — | 347.98 |
| J10055 | svc | Kateterizacija lijeve predkomore preko preparirane brahijalne arterije sa mjerenjem pritiska pod opterećenjem na ergometru | — | 0.00 |

### 60. NUKLEARNA MEDICINA (15 items)

| code | kind | name_sr (FZOCG canonical) | amb_eur | odj_eur |
|------|------|---------------------------|---------|---------|
| X35004 | svc | Dinamska scintigrafija bubrega sa diuretskom stimulacijom | — | 48.75 |
| X35006 | svc | Dinamska scintigrafija transplantiranog bubrega | — | 48.75 |
| X35007 | svc | Statička scintigrafija bubrega | — | 39.00 |
| X35008 | svc | Dinamska scintigrafija pljuvačnih žlijezda | — | 32.50 |
| X35009 | svc | Dinamska scintigrafija štitaste žlijezde | — | 22.75 |
| X35010 | svc | Scintigrafija paratiroidnih žlijezda | — | 32.50 |
| X35011 | svc | Koloidna scintigrafija jetre | — | 65.00 |
| X35013 | svc | Perfuziona scintigrafija pluća | — | 58.50 |
| X35014 | svc | Perfuziona scintigrafija srca | — | 42.25 |
| X35015 | svc | Scintigrafija Meckelovog divertikuluma | — | 42.25 |
| X35019 | svc | Liječenje hipertireoidnih pacijenata terapijskom dozom I-131 | — | 65.00 |
| X35020 | svc | Radionuklidna sinovektomija sa Y-90 | — | 16.25 |
| X35021 | svc | Postoperativno liječenje DTK terapijskom dozom I-131 | — | 97.50 |
| X35023 | svc | Terapija neuroblastoma i feohromocitoma sa MIBI-I-131 | — | 97.50 |
| X35024 | svc | Terapija radioobeleženim analozima somatostatina | — | 97.50 |

---

## Section B: 25 OCR-garbled items (need manual cleanup)

| code | name_sr (OCR raw) | section | amb_eur | odj_eur |
|------|-------------------|---------|---------|---------|
| D26146 | OPERACIJAPERIFERNIHVENA | — | — | 959.90 |
| I03001 | LOGOPEDSKAPROCJENA ARTIKULACIONIH SPOSOBNOSTIDJE | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03002 | LOGOPEDSKA PROCJENA STEPENAITEZINE MUCANJA | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03004 | LOGOPEDSKA PROCJENA SPECIFICNIH POREMECAJAUCENJA | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03005 | LOGOPEDSKA.SOMATOPEDSKAIOLIGOFRENOLOSKA PROCJEN 34.43 0.00 4 | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03006 | DEFEKTOLOSKO ISPITIVANJE MALOG DJETETA | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03007 | DEFEKTOLOSKO ISPITIVANJE SKOLSKOG DJETETA 34.43 0.00 4 | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03012 | DEFEKTOLOSKIILILOGOPEDSKI TRETMAN DJETETA SAPS 34.43 0.00 4 | TERCIJARNAZDRAVSTVENA ZASTITANEUROLOGIJA | — | 34.43 |
| I03017 | DEFEKTOLOSKIGRUPNI TRETMAN SKOLSKOG DJETETA | INFEKTOLOGIJA | 41.31 | 34.43 |
| I03018 | SAVJETIRODITELJIMA | INFEKTOLOGIJA | 41.31 | — |
| I03019 | NALAZIMISLJENJE DEFEKTOLOGA | INFEKTOLOGIJA | 41.31 | 34.43 |
| I03020 | SAVJET PEDAGOGU SKOLE ILIVRTICA | INFEKTOLOGIJA | 41.31 | 0.00 |
| I03021 | TIMSKAOBRADA PACIJENTA | INFEKTOLOGIJA | 41.31 | 0.00 |
| I03022 | DEFEKTOLOSKO-LOGOPEDSKI TRETMANDJETATASA SMETNJA | INFEKTOLOGIJA | 41.31 | — |
| J10013 | PNEUMOANGIOGRAFIJA 1 | RADIOLOSKADIJAGNOSTIKA | — | 347.98 |
| J10016 | KORONAROGRAFIJA 1 | RADIOLOSKADIJAGNOSTIKA | — | 417.58 |
| J10044 | POPRAVAKENDOKARDIJALNEELEKTRODE | RADIOLOSKADIJAGNOSTIKA | — | 349.28 |
| X12063 | PRIPREMAERITROCITAUOAS-U | — | — | 33.35 |
| X12064 | PRIPREMA OPRANIHERITROCITA | — | — | 33.35 |
| X12065 | PRIPREMAFILTRIRANTHERITROCITA | — | — | 33.35 |
| X13002 | DONORSKAPLAZMAFEREZA | — | — | 93.95 |
| X13003 | 一 TERAPIJSKA PLAZMAFEREZA | — | — | 93.95 |
| X13004 | TERAPIJSKACITAFEREZA | — | — | 60.55 |
| Y13002 | PRIM.TER.KROZDN.BOL.ZA DJ.UZR.OD1MJ.DO7G.UKCCG | — | — | 99.80 |
| Y13003 | PRIMJENA TERAPIJEKROZDNEVNUBOL.ZASTARIJEOD7G.UKCCG 90.88 0.00 BIOHEMIJSKO-HEMATOLOSKAIIMUNOLOSKALABORATORIJSKA | — | — | 90.88 |

---

## Next steps

1. Apply batch-01 SQL (765 items linked to existing services).
2. For section A: translate each item to 6 langs (en/sr/sr_cyrl/ru/de/tr), generate slug, and produce a `batch-02-*.sql` following [CLINIC_SERVICES_IMPORT.md](../../../docs/import/CLINIC_SERVICES_IMPORT.md) PART 1 pattern (INSERT INTO medical_services + clinic_medical_services + category/specialty relations).
3. For section B: clean up the OCR-garbled names manually (consult source PDF), then add via the same batch-02 flow.
4. Cross-reference categories from `enums/medical-service-category.ts` per section (see mapping table in CLINIC_SERVICES_IMPORT.md PART 1.5).