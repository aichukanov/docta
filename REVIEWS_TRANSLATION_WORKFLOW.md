# Workflow: перевод отзывов из Google Places

## Обзор ситуации

- **918 JSON файлов** в `data/google-places/<city>/`
- **760 с отзывами** (~3511 отзывов суммарно)
- **4 клиники уже обработаны** (Bar: buntic, just-dental, dental-esthetic-studio, pavlin)
- Большинство файлов содержат **5 отзывов** (лимит API)
- **5 файлов с ответами клиник** (`ownerResponse`) — все в Bar, все обработаны

## Целевые языки

| Ключ | Язык |
|------|------|
| `ru` | Русский |
| `sr_cyrl` | Српски (ћирилица) |
| `sr` | Srpski (latinica, čćžšđ) |
| `en` | English |
| `de` | Deutsch |
| `tr` | Türkçe |

---

## Что нужно получить от LLM

Для каждого файла с отзывами — JSON с переводами всех текстов + конвертация относительных дат.

---

## Промпт-шаблон для LLM

Скопировать промпт ниже, приложить содержимое JSON файла.

````
Обработай отзывы из приложенного JSON файла Google Places.

### Задача 1: Переводы

Для каждого отзыва (review) переведи `originalText.text` на все 6 языков:
- `ru` — русский
- `sr_cyrl` — сербская кириллица
- `sr` — сербская латиница (обязательно č, ć, ž, š, đ)
- `en` — английский
- `de` — немецкий
- `tr` — турецкий

Если `originalText.languageCode` совпадает с целевым языком — скопируй оригинал как есть.
Если `text.languageCode` = "sr" (Google-перевод на сербскую кириллицу) — используй его для `sr_cyrl`, а для `sr` транслитерируй.

Если есть `ownerResponse` — переведи его тоже по тем же правилам.

### Задача 2: Даты

Конвертируй `relativePublishTimeDescription` в примерную дату ISO (YYYY-MM-DD).
Данные собраны **2026-03-18** (вчера), если в промпте не указано иначе.

Примеры:
- "пре 2 недеље" / "2 недели назад" → ~2026-03-04
- "пре 2 месеца" / "2 месяца назад" → ~2026-01-18
- "пре 4 месеца" → ~2025-11-18
- "пре годину дана" / "год назад" → ~2025-03-18

Если есть `publishTime` — используй его (он точный), дату вычислять не нужно.

### Формат вывода

```json
{
  "clinicPlaceId": "<id из JSON>",
  "clinicName": "<displayName.text>",
  "dataCollectedDate": "2026-03-18",
  "reviews": [
    {
      "reviewId": "<последний сегмент из name после /reviews/>",
      "publishDate": "2026-03-04",
      "publishDateSource": "publishTime" | "relativeCalculated",
      "rating": 5,
      "originalLanguage": "<originalText.languageCode || 'ru'>",
      "originalText": "<originalText.text>",
      "translations": {
        "ru": "...",
        "sr_cyrl": "...",
        "sr": "...",
        "en": "...",
        "de": "...",
        "tr": "..."
      },
      "ownerResponse": {
        "originalLanguage": "...",
        "originalText": "...",
        "translations": {
          "ru": "...",
          "sr_cyrl": "...",
          "sr": "...",
          "en": "...",
          "de": "...",
          "tr": "..."
        }
      }
    }
  ]
}
```

Поле `ownerResponse` включай только если оно есть в исходном отзыве.

### Правила перевода
- Сохраняй тон и стиль оригинала (разговорный, эмоциональный, формальный)
- Не исправляй фактические ошибки автора
- Имена врачей и названия клиник НЕ переводи
- Эмодзи оставляй как есть
- Если текст содержит ненормативную лексику — переводи корректно, но сохраняя эмоцию
- Кавычки: сербский и немецкий используют „" (U+201E / U+201C)
````

---

## Пошаговый процесс обработки одного файла

### Вариант А: Через LLM UI (ручной)

1. Открыть JSON файл из `data/google-places/<city>/<clinic>.json`
2. Скопировать промпт-шаблон выше + содержимое JSON в окно LLM
3. Получить JSON с переводами
4. Сохранить результат в `data/review-translations/<city>-<clinic-slug>-translations.json`

### Вариант Б: Через существующий скрипт (двухпроходный)

```bash
# 1. Извлечь тексты
node scripts/generate-reviews-sql.mjs data/review-import-configs/<slug>.json --extract

# 2. Перевести через LLM (формат совместим с текущим скриптом)

# 3. Сгенерировать SQL
node scripts/generate-reviews-sql.mjs <config.json> --translations data/review-translations/<slug>-translations.json
```

### Вариант В: Автоматический (с API ключом)

```bash
# Всё за один шаг
node scripts/generate-reviews-sql.mjs data/review-import-configs/<slug>.json
```

---

## Приоритеты обработки

### Этап 1: Клиники с большим количеством отзывов (уже сделано)
- ✅ just-dental (110 отзывов)
- ✅ buntic (38)
- ✅ dental-esthetic-studio (37)
- ✅ pavlin (73)
- ❌ dr-zejnilovic (111) — **самый большой, ещё не обработан**

### Этап 2: Остальные клиники Bar (83 файла)
Все остальные файлы в `data/google-places/bar/` с отзывами.

### Этап 3: По городам (от крупных к мелким)
1. Podgorica — 292 файла
2. Budva — 85
3. Bijelo Polje — 78
4. Niksic — 71
5. Herceg Novi — 59
6. Ulcinj — 54
7. Berane — 54
8. Tivat — 35
9. Kotor — 35
10. Остальные (~56 файлов)

---

## Статистика и оценка объёма

| Метрика | Значение |
|---------|----------|
| Всего файлов | 918 |
| Файлов с отзывами | 760 |
| Всего отзывов | ~3511 |
| Уже обработано отзывов | ~369 (just-dental 110 + buntic 38 + dental-esthetic 37 + pavlin 73 + dr-zejnilovic?) |
| Файлов с ownerResponse | 5 (все в Bar) |
| Файлов без отзывов | 158 (только метаданные) |
| Средний размер файла | ~5 отзывов |

### Оценка для batch-обработки
- ~755 необработанных файлов × ~5 отзывов = ~3142 отзыва
- При batch по 20 через API: ~157 запросов на отзывы
- При ручной обработке через LLM UI: можно подавать по файлу (5 отзывов за раз)

---

## Формат хранения результатов

Переводы сохраняются в `data/review-translations/`:

```
data/review-translations/
  <city>-<clinic-slug>-translations.json   ← результат от LLM
```

Пример: `bar-a3-medical-translations.json`

---

## Совместимость с существующим скриптом

Промпт выше генерирует **расширенный формат** (с датами и метаданными клиники). Для совместимости с `generate-reviews-sql.mjs --translations` нужен формат скрипта:

```json
{
  "_instructions": "...",
  "reviews": [
    {
      "id": "<reviewId>",
      "original_language": "en",
      "text": "<originalText>",
      "translations": {
        "sr": "...",
        "sr_cyrl": "...",
        "en": "...",
        "de": "...",
        "tr": "..."
      }
    }
  ],
  "replies": [...]
}
```

Ключевое отличие: в формате скрипта **нет `ru`** в translations — `text_ru` берётся из `original_text` если `original_language = 'ru'`, иначе из LLM. При ручном подходе через промпт — `ru` включён в translations для полноты.

---

## Справочные данные для маппинга

Каждый файл Google Places нужно **привязать к реальной клинике и врачам** из БД.

### Список клиник

Файл: `data/from-db/clinic-list.txt`

Формат: `<id>\t<Название (Город)>`

```
15	A3 Medical (Sutomore)
20	Pavlin Dental Clinic (Bar)
42	JUST Dental Clinic (Bar)
...
```

### Список врачей по клиникам

Файл: `data/from-db/clinics-doctors.json`

Формат: массив клиник, каждая содержит `id`, `name` и массив `doctors` с `id`, `name`, `specialties[]`.

```json
{
  "id": 15,
  "name": "A3 Medical (Sutomore)",
  "doctors": [
    { "id": 201, "name": "Vukčević Zorica", "specialties": ["pulmonology"] },
    { "id": 202, "name": "Čolaković Vesna", "specialties": ["gynecology"] }
  ]
}
```

### Обязательный шаг: маппинг

При обработке каждого файла Google Places через LLM **нужно:**

1. **Найти клинику в `clinic-list.txt`** по названию / городу из JSON (`displayName.text`, `formattedAddress`)
2. **Найти врачей клиники в `clinics-doctors.json`** по `clinicId`
3. **В промпте указать** `clinicId` и список врачей с `id` — чтобы LLM мог:
   - Проставить `clinicId` в результате
   - Определить `doctorId` по упоминаниям врачей в тексте отзыва
   - Составить regex-паттерны для имён (если создаётся конфиг)

Без маппинга переводы бесполезны — они не привяжутся к сущностям в БД.

### Дополнение к промпту (добавлять перед JSON)

```
Клиника: id=15, "A3 Medical (Sutomore)"
Врачи в этой клинике:
- id=201, Vukčević Zorica (pulmonology)
- id=202, Čolaković Vesna (gynecology)

Определи для каждого отзыва doctorId по упоминаниям врача в тексте.
Если упомянуто 2+ врача или ни одного — doctorId = null.
```

---

## Заметки

- `relativePublishTimeDescription` на сербском: "пре X недеље/месеца/година/дана"
- `relativePublishTimeDescription` на русском (если Google вернул): "X недель/месяцев назад"
- Файлы без `reviews` — пропускать (158 штук, только метаданные клиник)
- Если `_wasTranslated: true` — `originalText.text` может быть Google-переводом на русский, а не настоящим оригиналом. Настоящий язык в `originalText.languageCode`
