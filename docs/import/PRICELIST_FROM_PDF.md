# Промпт для извлечения данных прейскуранта из PDF

## Задача

Преобразовать **отсканированный PDF прейскуранта** в структурированный JSON, пригодный для последующего импорта в БД через [CLINIC_SERVICES_IMPORT.md](./CLINIC_SERVICES_IMPORT.md) или [CLINIC_DOCTORS_IMPORT.md](./CLINIC_DOCTORS_IMPORT.md).

## Входные данные

PDF-файл прейскуранта. Любой объём (1 страница … 120+). Обычно отсканированный (нет текстового слоя), реже — экспорт из Word с текстом.

> 💡 **Если в PDF уже есть текстовый слой** — просто извлеки текст через `pypdfium2` и обработай как обычный текст. Шаги ниже нужны только для сканов.

## Алгоритм по умолчанию: PaddleOCR → LLM (fallback)

1. **PaddleOCR PP-StructureV3** — основной OCR. Распознаёт таблицы как таблицы (с колонками), даёт детерминированный результат, не галлюцинирует, корректно ловит цифры/коды.
2. **Парсер** — превращает paddleocr JSON в плоский `items[]`.
3. **LLM-OCR (мультимодал Read)** — **только** если paddle не справился с layout (см. таблицу ниже). Дороже, медленнее, может галлюцинировать на плотных таблицах.

> ⚠️ **Не начинай с LLM**. На прейскурантах с длинными таблицами LLM путает строки/коды (мы это уже проходили на FZOCG SEKUNDARNA OSTALO — было 10+ дубликатов кодов из-за сдвига строк, paddleocr выдал чистый результат).

---

## Шаг 1: PaddleOCR

### Когда инструменты уже установлены

```powershell
# Один PDF
py -3.12 server/scripts/paddleocr_pdf.py "путь/к/файлу.pdf" "data/.../paddleocr/output.json"

# Batch (все PDF из заранее настроенных категорий FZOCG)
py -3.12 server/scripts/paddleocr_all_fzocg.py
```

Выход: `<output>.json` с массивом `layoutParsingResults[]`, по одному элементу на страницу. Каждый блок типизирован (`table`, `text`, `figure_title`, `paragraph_title`, `number`, `image`, ...). Таблицы — как HTML внутри `block_content`.

### Если PaddleOCR ещё не установлен на машине

См. раздел [Установка](#установка-paddleocr-разово-на-машину) в конце документа.

---

## Шаг 2: Парсер `paddle_to_items.py`

```powershell
# Один файл
py -3.12 server/scripts/paddle_to_items.py "data/.../paddleocr/output.json" "data/.../paddleocr/output.items.json"

# Batch — обработать все *.json в data/fzocg/*/paddleocr/
py -3.12 server/scripts/paddle_to_items.py --all
```

Выход: `*.items.json` — плоский список:

```json
{
  "items_total": 67,
  "by_scheme": { "single": 67 },
  "sections": { "INTERVENCIJE I PROCEDURE TRANSFUZIOLOGIJA": 57, ... },
  "items": [
    {
      "code": "G05001",
      "name": "Prvi pregled - transfuziolog",
      "section": "PREGLEDI I ADMINISTRACIJA",
      "page": 4,
      "scheme": "single",
      "cols": 3,
      "single_eur": 4.17
    }
  ]
}
```

### Схемы таблиц, которые парсер распознаёт

| `scheme`     | Структура колонок                                  | Где встречается                                |
| ------------ | -------------------------------------------------- | ---------------------------------------------- |
| `dual`       | `SIFRA \| NAZIV \| Odjeljenje \| Ambulanta`        | FZOCG SEKUNDARNA OSTALO (4 колонки)            |
| `operacija`  | `SIFRA \| NAZIV \| Operacija \| Anestezija \| Ukupno` | OPERACIJE секции в SEKUNDARNA OSTALO (5 колонок) |
| `single`     | `SIFRA \| NAZIV \| CIJENA`                          | PZZ, TRANSFUZIOLOGIJA, APOTEKARSKA, ... (3 колонки) |
| `unknown`    | паддл не определил                                  | редкие edge cases — проверять глазами          |

### Когда парсер не находит ни одной строки

Открой `*.items.json` — если `items_total: 0`, скорее всего:

- **Коды не подходят под regex** `CODE_RE` в [paddle_to_items.py](../../server/scripts/paddle_to_items.py). Текущие шаблоны:
  - `[A-Z]{1,2}\d{2,5}[A-Z]?` — `Y01001`, `A05Z`, `AA1101`
  - `\d{2,6}` — `10`, `20`, `180`
  
  Расширь regex под формат нового источника.

- **PDF — это просто текст**, не таблица. PaddleOCR разметил всё как `text`, не как `table`. Тогда либо извлекай данные через pypdfium2 + regex по тексту, либо иди в LLM-fallback.

---

## Шаг 3: Решение «нужен ли LLM-fallback»

Спот-чекни первые 20 строк `items.json`. Симптомы и реакции:

| Симптом                                                     | Причина                                            | Что делать                                                                                                              |
| ----------------------------------------------------------- | -------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| Items count в 2-3 раза меньше ожидаемого                    | Paddle не распознал часть страниц/секций           | Спот-чекни — какие страницы пропустил. Если пропущены конкретные таблицы — добавляй их через LLM-OCR.                   |
| Коды слиплись (`A07Z A06D A06C` в одной ячейке)             | Layout слишком плотный/нестандартный (DRG-style)   | **LLM-fallback** на этот документ целиком                                                                                |
| Диакритика везде потеряна (`drenaza` вместо `drenaža`)      | Известная особенность paddle                       | Если данные пойдут в БД с переводами — нужен LLM-постпроцесс на имена. Если коды и цены важнее имён — забить.            |
| Цена в неправильной колонке (oдj в ambulanta)               | Continuation page без header'a                     | Cross-ref c LLM-источником через `merge_to_final.py`. Без LLM-источника — единая колонка `price_eur`.                   |
| Появились мусорные позиции (`code=21, name="Ree-oeee-pee"`) | OCR'нул печать/подпись как текст                   | Отфильтруй в финальном JSON по правилам (см. ниже)                                                                       |

---

## Шаг 4: LLM-fallback (если paddle не справился)

Только для документа где paddle сломался. Подход:

1. **Отрендерь PDF в картинки** через `pypdfium2`:
   ```powershell
   py -3.12 -c "
   import pypdfium2 as pdfium, os
   pdf = pdfium.PdfDocument(r'путь/к/файлу.pdf')
   out = r'e:/tmp/render'
   os.makedirs(out, exist_ok=True)
   for i, page in enumerate(pdf, 1):
       img = page.render(scale=3.0).to_pil()
       w, h = img.size
       # Разрезай пополам — нужно, если страница выше 2000px
       if h > 2000:
           img.crop((0, 0, w, h//2 + 60)).save(f'{out}/page-{i:02d}-top.png')
           img.crop((0, h//2 - 60, w, h)).save(f'{out}/page-{i:02d}-bot.png')
       else:
           img.save(f'{out}/page-{i:02d}.png')
   print('done', len(pdf))
   "
   ```

2. **Читай картинки через Read** (мультимодал OCR Claude'ом). Транскрибируй таблицы построчно в JSON. Помечай неуверенные значения `"note": "VERIFY: ..."`.

3. **Сохрани результат** в `data/<category>/<llm-source>.json` — это будет LLM-источник для merge.

> ⚠️ **Не запускай LLM-fallback на 100+ страниц в одной сессии**. Лимит на 2000px по картинке (рендер scale=3.0 + split top/bot) и общий лимит изображений в контексте сессии. Если страниц много — разбивай на батчи по 5-7 страниц в параллельных сессиях (как мы делали для SEKUNDARNA OSTALO).

---

## Шаг 5: Merge → финальный JSON

```powershell
py -3.12 server/scripts/merge_to_final.py <category-slug>
```

Перед запуском в `CATEGORIES` dict внутри `merge_to_final.py` должна быть запись:

```python
'your-slug': {
    'paddle_base': 'paddleocr/<base-pdf-stem>.items.json',
    'paddle_amendments': [
        # хронологически от старых к новым
        ('paddleocr/<amend1>.items.json', '2023-01-15'),
        ('paddleocr/<amend2>.items.json', '2024-06-01'),
    ],
    'llm_source': 'llm-source.json',  // или None если LLM не делали
    'scheme_default': 'single',       // 'single' | 'dual' | 'operacija' — fallback для unknown
    'metadata': {
        'category': 'your-slug',
        'level': 'описание уровня услуг',
        'issuer': 'кто издал прейскурант',
        'price_columns': 'single',
    },
},
```

Выход: `data/.../<category>-FINAL.json` — DB-ready.

### Правила слияния (что побеждает)

| Поле                          | Источник                                                   |
| ----------------------------- | ---------------------------------------------------------- |
| Код, цены, числа              | **paddle** (детерминированный, не галлюцинирует на цифрах)   |
| Имя услуги, диакритика, текст | **LLM** если есть, paddle как fallback                       |
| Секция                        | **LLM** если есть, paddle как fallback                       |
| OCR-алиасы (`1↔I` и т.п.)     | Авто-резолв через `CODE_OCR_ALIASES` в merge_to_final.py     |
| Поправки                      | Применяются хронологически, последняя побеждает по коду     |

Каждая позиция в финале содержит `_sources` — провенанс по каждому полю.

---

## Хранение файлов

```
e:/pet/docta.me/прейскуранты/<source>/<category>/      # raw входные PDF (не в репо)
  └── *.pdf

nuxt/data/<root>/<category>/                           # OCR-выходы + финал
  ├── <llm-source>.json                                # LLM-извлечённое (если делали)
  ├── paddleocr/
  │   ├── <pdf-stem>.json                              # paddleocr raw
  │   └── <pdf-stem>.items.json                        # плоский items[]
  └── <category>-FINAL.json                            # ✦ для импорта в БД
```

> 💡 **Зачем хранить raw OCR**: если в финале нашли баг — переразбираем через `merge_to_final.py` без повторного OCR. paddleocr быстр, но модели версионируются — raw артефакт это durable снимок.

---

## Проверка качества перед импортом

```powershell
py -3.12 -c "
import json
d = json.load(open('data/.../CATEGORY-FINAL.json', encoding='utf-8'))
info = d['merge_info']
print('items:', d['items_total'])
print('paddle-only:', info['codes_only_in_paddle'], 'llm-only:', info['codes_only_in_llm'])
print('name disagreements:', info['name_disagreements'])
print('alias-resolved:', info['ocr_aliases_resolved'])
no_price = [it for it in d['items'] if not any(v for k,v in it.items() if k.endswith('_eur'))]
print('items без цены:', len(no_price))
"
```

### Чек-лист «можно импортить»

- [ ] `items_total` совпадает с ручным подсчётом по PDF ±5%
- [ ] `items без цены` = 0 (или явное объяснение каждой такой позиции)
- [ ] Дубликаты кодов проверены — либо OCR-ошибка, либо реальный дубликат в источнике
- [ ] Если есть `name_disagreements` — пройдено глазами в первых N (LLM почти всегда прав, но иногда paddle)
- [ ] Спот-чек 5-10 случайных строк против оригинала PDF

---

## Известные проблемы и обходы

| Проблема                                                                  | Решение                                                                                      |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| **DRG-style плотные таблицы** — paddle сливает коды в одну ячейку         | LLM-fallback на весь документ                                                                |
| **Печати/штампы** OCR'ятся как мусорные записи                            | Фильтруй в финале по `len(code) < 4 and price > N` или вручную удаляй из FINAL                |
| **Диакритика теряется** в paddle                                           | LLM cross-ref для имён (через `merge_to_final.py`)                                            |
| **Continuation pages с одной колонкой цены** (Odj или Amb?)              | Cross-ref c LLM. Без LLM — единое поле `price_eur`, потребитель сам решает                    |
| **Section headers распознались с битой стыковкой строк** (`32. MAKSI` / `LOFACIJALNA`) | Спот-чекни секции в `items.json`. При необходимости — поправь регex в `paddle_to_items.py` или пометь вручную |
| **Цена с запятой как разделитель тысяч** (`1.234,56`)                     | Парсер уже умеет: `1.234,56 → 1234.56`. Если что-то ломается — проверь `parse_price()` в [paddle_to_items.py](../../server/scripts/paddle_to_items.py) |

---

## Установка PaddleOCR (разово на машину)

Нужен Python 3.12 (paddleocr ещё не собран под 3.13+).

```powershell
# 1. Проверь что Python 3.12 есть
py -3.12 --version

# 2. PaddlePaddle GPU build (CUDA 12.6) — для NVIDIA GPU
py -3.12 -m pip install --user paddlepaddle-gpu==3.3.0 -i https://www.paddlepaddle.org.cn/packages/stable/cu126/

# 2 (альтернатива). CPU build — если GPU нет или с ним проблемы
py -3.12 -m pip install --user paddlepaddle==3.3.0 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/

# 3. paddleocr + зависимости для PP-StructureV3
py -3.12 -m pip install --user paddleocr "paddlex[ocr]" pypdfium2

# 4. Проверь установку
py -3.12 -c "import paddle; paddle.utils.run_check()"
# Ожидается: "PaddlePaddle works well on 1 GPU." (или CPUs)
```

> ⚠️ **CUDA Version warning при запуске** (`compiled with CUDNN 9.9, machine has CUDNN 9.5`) — игнорируй, для inference не критично.

> 💡 **Скорость**: GTX 1660 Ti обрабатывает ~6 сек/страница. CPU — в 5-10× медленнее.

---

## Формат ответа (что отдать пользователю)

1. **Сводка**:
   - Тип источника (FZOCG, частная клиника, т.п.)
   - Кол-во PDF (база + поправок)
   - Кол-во items в финале
   - Какие схемы цен встречаются (single/dual/operacija)
   - Сколько прошло чек-лист
2. **Путь к FINAL.json** — что использовать для следующего импорта
3. **VERIFY-замечания** — если есть items с пометкой `note`, перечислить (или дать ссылку на сгенерированный `_VERIFY_LIST.md`)
4. **Следующий шаг** — указать какую инструкцию использовать дальше:
   - Цены клиники → [CLINIC_SERVICES_IMPORT.md](./CLINIC_SERVICES_IMPORT.md)
   - Список врачей → [CLINIC_DOCTORS_IMPORT.md](./CLINIC_DOCTORS_IMPORT.md)
   - Если данные общие/госплан (например, FZOCG) — отдельный воркфлоу импорта (TBD)

---

## Полезные команды

### Посмотреть структуру paddleocr-вывода для отладки

```powershell
py -3.12 -c "
import json, re
d = json.load(open('data/.../paddleocr/file.json', encoding='utf-8'))
for i, lp in enumerate(d['layoutParsingResults'][:5]):
    print(f'=== page {i+1} ===')
    for b in lp['prunedResult']['parsing_res_list']:
        c = re.sub(r'<[^>]+>',' ', b.get('block_content','') or '')[:120]
        print(f'  {b[\"block_label\"]:18s}  {c}')
"
```

### Извлечь все таблицы в одном файле как HTML

```powershell
py -3.12 -c "
import json, re
d = json.load(open('data/.../paddleocr/file.json', encoding='utf-8'))
for i, lp in enumerate(d['layoutParsingResults'], 1):
    for b in lp['prunedResult']['parsing_res_list']:
        if b['block_label']=='table':
            print(f'--- page {i} ---')
            print(b['block_content'])
" > tables.html
```

### Сравнить итоги paddle vs LLM

```powershell
py -3.12 -c "
import json
p = json.load(open('data/.../paddleocr/X.items.json', encoding='utf-8'))
l = json.load(open('data/.../X-llm.json', encoding='utf-8'))
pc = set(it['code'] for it in p['items'])
lc = set(it['code'] for it in l['items'])
print(f'paddle: {len(pc)}, llm: {len(lc)}, common: {len(pc&lc)}')
print(f'paddle-only: {sorted(pc-lc)[:10]}')
print(f'llm-only: {sorted(lc-pc)[:10]}')
"
```

---

## Справочник: что использовать для следующего шага

После того как у тебя есть `<category>-FINAL.json` — для импорта в БД смотри:

- **Услуги/анализы клиники** (с фиксированным `clinic_id`) → [CLINIC_SERVICES_IMPORT.md](./CLINIC_SERVICES_IMPORT.md)
- **Список врачей клиники** → [CLINIC_DOCTORS_IMPORT.md](./CLINIC_DOCTORS_IMPORT.md)
- **Госплан / общие справочники цен** (например FZOCG) → пока вручную, отдельной инструкции нет
