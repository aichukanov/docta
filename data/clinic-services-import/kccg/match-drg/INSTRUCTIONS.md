# Сопоставление DRG-групп КЦЦГ с каталогом услуг docta.me

Прайс стационара Kliničkog centra Crne Gore (изменения 2025): DRG-группа — это цена эпизода
госпитализации (коэффициент × 1900,45 €). Каждую группу надо привязать к записи каталога
`medical_services`: существующей или новой. Анализов здесь нет.

## Вход

- Батч: `E:\pet\docta.me\nuxt\data\clinic-services-import\kccg\match-drg\in\<batch>.json`
  (`code`, `name_kccg` — название как в прайсе, главное; `name_fzocg` — то же из госпрайса FZOCG,
  с диакритикой; `section` — MDC; `price_eur`).
- Каталог услуг: `E:\pet\docta.me\nuxt\data\clinic-services-import\kccg\ref\catalog-services.tsv`
  (id, slug, name_en, name_sr, cats, syn). Искать Grep'ом по ключевым словам — выводить ВСЕ совпадения,
  не обрезать: точная запись часто редкая.
- Категории `E:\pet\docta.me\nuxt\enums\medical-service-category.ts`, специальности `E:\pet\docta.me\nuxt\enums\specialty.ts`.

## Решение по группе

1. **Процедурная группа, у которой в каталоге есть сама процедура** (название группы = конкретная
   операция/процедура: «Operacija karpalnog kanala», «Laparoskopska holecistektomija …», «Tonzilektomija i/ili
   adenoidektomija», «Zamjena kuka …», «Apendektomija …», «Transplantacija jetre», «Kolonoskopija …») →
   `existing` на эту процедуру. Варианты тяжести одной процедуры (…A/…B/…C, «sa/bez KK») привязываются
   к той же записи — цена станет диапазоном. Процедура должна совпадать по смыслу точно:
   «Zahvati na kičmenom stubu» (любые операции на позвоночнике) — НЕ конкретная «дискэктомия».
   Широкие группы («Veliki zahvati na …», «Ostali zahvati …», «Zahvati na …» без названной операции)
   — это не процедура, а класс, см. п. 2.
2. **Всё остальное** (диагнозы, лечение, широкие классы операций) → `new`, одна запись на код,
   по конвенции, уже принятой в каталоге (импорт ДЗ Мойковац, см. записи `hospitalization-for-*`):
   - `name_en`: «Hospitalization for <X>» + уточнение тяжести как в группе: «with Very Severe CC»,
     «with Severe or Moderate CC», «without CC», «without Very Severe or Severe CC», «Same Day», «Death or
     Transfer, Stay < 5 Days» и т. п. (KK = CC). Пример: «Hospitalization for Respiratory Infections with Severe or Moderate CC».
     Для операций: «Hospitalization for Spinal Procedures with Very Severe or Severe CC».
   - `name_sr`: название группы как в прайсе, но грамотно: иекавица, диакритика, без опечаток
     («idrugi» → «i drugi», «cerebovaskularni» → «cerebrovaskularni»). Бери за основу `name_fzocg`, если он
     совпадает по смыслу с `name_kccg`.
   - `name_ru`: «Госпитализация: <x>» (KK → «ОО» — осложнения и сопутствующие), `name_de`: «Stationäre
     Behandlung: <x>» (KK), `name_tr`: «Yatış: <x>» (CC). Полный перевод, не копия английского.
   - `name_en` и `slug` должны быть уникальны в каталоге и внутри твоего батча.
3. **`doubtful`** — только если группа непонятна. Группы 960Z/961Z/963Z («Ne može se grupisati»,
   «Neprihvatljiva glavna dijagnoza», «Dijagnoza novorođenčeta neusklađena…», цена 0) — `doubtful`
   с note «служебная группа, цена 0».

## Категории и специальности (для new)

Категория по профилю MDC (имена из enum услуг): нервная система — NEUROLOGY; глаз — OPHTHALMOLOGY
(операции — ещё OPHTHALMIC_SURGERY); ЛОР — ENT; дыхание — PULMONOLOGY; кровообращение — CARDIOLOGY;
пищеварение, печень, поджелудочная — GASTROENTEROLOGY (операции — ещё ABDOMINAL_SURGERY);
кости/мышцы — ORTHOPEDICS; кожа и молочная железа — DERMATOLOGY (операции на молочной железе — GENERAL_SURGERY);
эндокринные — ENDOCRINOLOGY; почки и мочевые пути, мужская репродуктивная — UROLOGY; женская репродуктивная,
беременность и роды — GYNECOLOGY (операции — ещё GYNECOLOGICAL_SURGERY); новорождённые — PEDIATRICS;
прочие (кровь, опухоли, инфекции, психиатрия, травмы, ожоги, факторы здоровья) — подходящая из enum или
GENERAL_MEDICINE; операции общего профиля — ещё GENERAL_SURGERY. Специальности — из enums/specialty.ts по профилю
(как у Мойковаца: нервная система → NEUROLOGY, дыхание → PULMONOLOGY, ЛОР → OTORHINOLARYNGOLOGY).

## Выход

`E:\pet\docta.me\nuxt\data\clinic-services-import\kccg\match-drg\out\<batch>.json` (инструментом Write
или скриптом, UTF-8):

```json
{"batch": "<batch>", "items": [
  {"code": "B05Z", "decision": "existing", "kind": "medical_service", "slug": "carpal-tunnel-surgery", "id": 2209, "note": ""},
  {"code": "B70C", "decision": "new", "kind": "medical_service", "name_en": "...", "slug": "...", "name_sr": "...",
   "name_ru": "...", "name_de": "...", "name_tr": "...", "categories": ["NEUROLOGY"], "specialties": ["NEUROLOGY"], "note": ""},
  {"code": "960Z", "decision": "doubtful", "kind": "medical_service", "note": "служебная группа, цена 0"}
]}
```

Каждый `code` входа — ровно одна запись. Ничего больше не делай: не запускай SQL, не трогай другие файлы и БД.
В ответе — одна строка: сколько existing / new / doubtful и какие existing-привязки стоит проверить.
