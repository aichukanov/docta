# Вопросы из вычитки названий — и что с ними стало

Агенты вычитки отмечали то, что не решали сами: подозрительные дубли, «ошибочные» привязки тарифов FZOCG, спорные толкования. Очевидные правки вне ростеров вошли в ручной батч `fix-90` (миграция 036). Дубли и тарифы разобрала миграция 038 — как именно, см. `docs/audit/service-names-2026-09.md`, раздел «038». Здесь — итог по каждому вопросу и то, что осталось.

## Закрыто миграцией 038

### «Ошибочные привязки к тарифам» — в основном это были сдвинутые имена

Агенты сравнивали название услуги с `name_sr_latin` тарифа и видели чужую процедуру. Но почти всегда **привязка была верной, а съехало имя тарифа**: при слиянии OCR и LLM в `FINAL.json` имена местами встали на соседний код, иногда вместе с ценой. 038 чинит 140 таких строк; все решения лежат в `data/fzocg/_tariff-name-fixes.json`.

| Услуга | Код | Было в тарифе | Стало |
|---|---|---|---|
| thyroid-biopsy | X01036 | «катетеризация у мужчин» + чужая цена | «Punkciona biopsija štitne žlijezde», цена 1,30 / 2,78 |
| urinary-catheter-placement | X01032 | «Uzimanje sputuma» + чужая цена | «Kateterizacija … kod žene», 0,65 / 1,39 |
| electrocochleography | X07112 | «Aspiraciona biopsija tankom iglom» | «Elektrokohleografija odraslih» |
| tongue-tumors | X07060 | «лимфоузел шеи» | «Ekscizija benignih tumora jezika sa primarnom plastikom» |
| metatarsal-bone-fracture | D05083 | имя соседа D05082 («tarzalnih») | «…metatarzalnih kostiju…» |
| half-palmar-fasciectomy | D05114 | «više od jedne polovine» | «do jedne polovine» — как в услуге |
| subcutaneous-plantar-or-toe-fasciotomy | D05033 | «тенолиз сгибателей» | «Fasciotomija, plantarna i/ili prsta subkutana» |
| excision-of-malignant-skin-lesions | X10001 | «manjih lezija» | «malignih lezija» |
| abdominal-paracentesis | X01046 | «Endotrahealna intubacija» | «Dijagnostička ili terapijska punkcija peritonealne šupljine sa uzimanjem uzorka» |
| optical-coherence-tomography-oct | X06080 | «Skijaskopija kod djece» | «OCT (optička koherentna tomografija)» |
| body-plethysmography | X17006 | «градиент CO2» | «Tjelesna pletismografija» |
| inhalation-therapy | X01010 | «Tuberkulinsko testiranje» | «Inhalaciona terapija» |
| oxygen-administration | X01006 | «клизма» | «Davanje kiseonika» |
| suture-removal | X01015 | «первичная обработка раны» + цена | «Skidanje hirurških konaca» |
| mri-soft-tissue-neck | J09020 | «MR hipofize» | «MR pregled vrata - bez kontrasta» (цену сверить нечем — не менялась) |
| aspiration-puncture-of-abscess-or-hematoma | X01011 | «Inhalaciona terapija» + цена | «Aspiraciona punkcija abscesa ili hematoma» |
| forearm-and-hand-splint-under-10-years | Y10012 | «od ramena do šake» | «podlaktice i šake» |
| follow-up-pediatric-nephrologist | E09004/E09005 | имена переставлены, цены чужие | по OCR и прайсу Данило |

### PZZ-тариф на больничной услуге — перенесено

Коды первичного и секундарного прайсов пересекаются. 038 переносит 16 PZZ-тарифов на свои услуги и отвязывает один (`data/fzocg/_pzz-relinks.json`):

| Код | PZZ-позиция | Висела на | Теперь |
|---|---|---|---|
| X01025 | Stavljanje IUD | биопсии лимфоузла | установка ВМС |
| X01023 | Davanje metadona | назогастральном зонде | выдача метадона |
| X01011 | Punkcija potkožnih hematoma | 5294 (аспирация абсцесса) | 7048 (пункция подкожной гематомы) |
| L01001…L01012 | патронаж | гистологиях | патронажных визитах |
| I01001/I01002 | осмотр неонатуса группы риска | осмотрах инфекциониста | неонатальных осмотрах |
| A01001 | профосмотр ребёнка до 1 года | осмотре анестезиолога | профосмотре до 1 года |

### Дубли — слито 46, отказов 11

Все решения с обоснованием — `data/service-names/_dedup-decisions.json`. Правило то же, что в 027–034: решает код прайса. Дополнительно найдено: **коды ДЗ Херцег-Нови в блоках X01/X02 сдвинуты на единицу** (их «X02011» — это ЭКГ, а в FZOCG X02011 — спирометрия), поэтому там решало дословное совпадение названия с позицией прайса.

Прошлые отказы из 030 сняты в трёх парах — там отказ держался на осторожности, а не на коде: рентген бедра, эргометрия, керамика на золоте. И `panoramic-x-ray` разделён: строки J11001 (~3 €) уехали на свою услугу, а ОПТГ J11003 из двух дублей слились в него.

Уже не существуют (слиты раньше): 7045, 7064, 4186.

## Осталось решить — нужен человек или прайс клиники

| Что | Откуда | Вопрос |
|---|---|---|
| ~78 строк тарифов | 038 | OCR нечитаем, а услуги или клиник для сверки нет; либо OCR и прайс расходятся. Список — `_tariff-name-fixes.json` → `manual`. Сверять по PDF. Почти все ни к чему не привязаны, на страницах их не видно. |
| radical-mastectomy | fix-06 | FZOCG шире всех локалей (Halsted, надключичные узлы, ex tempore); en «Axillary Evacuation» — калька |
| 6477 (D05104) | fix-05 | в FZOCG «talusa ili kalkaneusa», во всех локалях пяточная кость потеряна, отдельной услуги под неё нет |
| metatarsal-osteotomy (6462, D05088) | fix-04 | в FZOCG «Ostektomija», в прайсе клиники под тем же кодом — «Osteotomija» |
| supracondylar-…-closed (D05115) | review-08 | в названии услуги «закрытая», в FZOCG «zatvorena ili otvorena» (имя тарифа 038 восстановила полностью) |
| hallux-valgus-…-x-ostectomy | review-03 | «X-ostektomija» прочитано как экзостэктомия; если толкование неверное — откатить |
| intertrochanteric-… (D05151) | review-03 | в FZOCG «otvorena (složena)», в названия не перенесено |
| incarcerated-hernia-operation (D02029) | review-15 | по тарифу — без резекции кишки, рядом 5970 «с резекцией»; дописать «без резекции»? |
| hepatectomy ↔ liver-resection | review-15 | неразличимы по названию; по FZOCG — обширная (D02261) и сегментарная (D02154) резекция. Развести названиями |
| pilonidal-sinus-surgical-treatment ↔ pilonidal-cyst-surgery-classic | review-15 | неразличимы; по FZOCG — открытое иссечение (D02001) и иссечение с первичным швом (D02023) |
| x-ray-chest-heart (2035) | 038 | несёт J06010 «Teleradiografija srca» (только сердце), а называется «лёгкие и сердце» — это 3206 (J06051) |
| hysteroscopy-asherman-syndrome (3407) | 038 | несёт D01030 «диагностическая гистероскопия», а называется «при синдроме Ашермана» |
| mri-pelvis (3812) | 038 | у клиники 137 это J09018 — с контрастом, в названии этого нет |
| epigastric-hernia-operation (3418) | 038 | несёт D02028 «супраумбиликальная и пупочная», эпигастральная — отдельная D02189 (6101) |
| emng-de-and-ge, emng-de-or-ge | review-19 | «DE/GE» прочитано как нижние/верхние конечности — сверить с клиникой |
| aspiration | review-25 | во всех локалях просто «Аспирация» — чего именно, не сказано |
| thyroidectomy | review-25 | категория Pulmonology и специальность ophthalmology похожи на ошибку |
| lacrimal-duct-probing-adults (2287) | review-23 | sr — промывание, en/ru/тариф — зондирование |
| targeted-upper-gi-tract-x-ray | review-20 | «за снимок» дописано по FZOCG; убрать, если клиники берут за исследование |
| intramuscular-therapy-2 | review-24 | что значит «2», неизвестно |
| Осмотры специалиста 2061–2066, 2174–2181, 2312 | review-29 | вне ростеров (меньше 3 клиник), остались кальками |
| Пакеты систематического осмотра (2072–2078, 2186, 7018–7020) | review-29 | переименовывать всю серию разом |
| vertebral-body-… (X09076) | review-08 | восстановлено по FZOCG (шея + Halo-тракция); если услуга клиник шире — откатить |
| pregnancy-preventive-examination-by-calendar | review-27 | ДЗ Мойковац держит на ней MO_A01010, а PZZ A01010 — эпидемический профосмотр детей; вероятно, сдвиг кодов в их прайсе |

## Решено на шаге 1 (036)

| Что | Решение |
|---|---|
| esophagogastrectomy-…-cervical-esophagostomy (6895) | FZOCG D28083 — «анастомоз на шее», а не стома |
| packed-red-blood-cells rh+/rh− | «эритроцитная масса», а не «отмытые» (это 5814) |
| breast-implant-replacement, calf-implants, inguinal-hernioplasty-with-hydrocele-excision | опечатки в sr (fix-90) |
| серии пульпита, повязок, операционных tier I/II, «Bett-Tag», рентгенов | выровнены между батчами |
| кракозябры, мягкие переносы, смешение алфавитов | вычищены |
