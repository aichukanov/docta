# Промпт для обработки отзывов клиники

## Как использовать

1. Скопировать промпт ниже (между `---START---` и `---END---`)
2. Заменить `<ФАЙЛ>` на путь к JSON файлу клиники
3. Вставить в Claude Code из этой папки
4. Получить файл конфига, запустить скрипт

## Промпт

---START---

Обработай отзывы клиники из файла `<ФАЙЛ>`.

Прочитай:
1. Файл клиники (указан выше)
2. `data/from-db/clinic-list.txt` — список клиник в БД
3. `data/from-db/clinics-doctors.json` — врачи по клиникам
4. `data/review-import-configs/dr-zejnilovic-bar.json` — пример готового конфига
5. `REVIEWS_IMPORT.md` — документация по формату конфигов и паттернам

Выполни:

### 1. Найди клинику и врачей
- Найди клинику в `clinic-list.txt` по названию и городу из JSON (`displayName.text`, `formattedAddress`)
- Найди врачей этой клиники в `clinics-doctors.json`

### 2. Составь паттерны
- Прочитай тексты всех отзывов, определи кого из врачей упоминают
- Составь regex-паттерны по правилам из `REVIEWS_IMPORT.md`
- Добавляй паттерны только для врачей, которых реально упоминают в отзывах

### 3. Переведи отзывы
Для каждого отзыва с непустым `originalText.text` — переведи на 6 языков:
- `sr` — сербская латиница (обязательно č, ć, ž, š, đ)
- `sr_cyrl` — сербская кириллица
- `en` — английский
- `ru` — русский
- `de` — немецкий
- `tr` — турецкий

Правила:
- Если `original_language` совпадает с целевым — скопируй оригинал
- Если `text.languageCode` = `"sr"` и текст кириллицей — используй для `sr_cyrl`, транслитерируй для `sr`
- Сохраняй тон, стиль, эмодзи
- Имена врачей и клиник НЕ переводи
- Пропускай отзывы без текста

### 4. Сохрани результат

Сохрани **один JSON-файл** `data/review-import-configs/<slug>.json`:

```json
{
  "jsonPath": "data/google-places/<city>/<file>.json",
  "outputPath": "server/sql/insert-reviews-<slug>.sql",
  "dataCollectedDate": "2026-03-18",
  "clinicId": <id>,
  "clinicName": "<название>",
  "doctors": [
    {
      "id": <doctor id>,
      "varName": "<snake_case>",
      "patterns": ["<regex>"]
    }
  ],
  "translations": {
    "reviews": [
      {
        "id": "<reviewId — последний сегмент name после /reviews/, или _reviewId>",
        "original_language": "<originalText.languageCode, fallback 'ru'>",
        "text": "<originalText.text — точная копия>",
        "translations": {
          "sr": "...", "sr_cyrl": "...", "en": "...",
          "ru": "...", "de": "...", "tr": "..."
        }
      }
    ],
    "replies": [
      {
        "id": "<reviewId родительского отзыва>",
        "original_language": "<ownerResponse.languageCode, fallback 'sr'>",
        "text": "<ownerResponse.text>",
        "translations": { "sr": "...", "sr_cyrl": "...", "en": "...", "ru": "...", "de": "...", "tr": "..." }
      }
    ]
  }
}
```

Секцию `replies` включай только если есть `ownerResponse`.

### Шаг 5: Запусти генерацию SQL

После сохранения конфига выполни:
```bash
node scripts/generate-reviews-sql.mjs data/review-import-configs/<slug>.json
```

### Формат ответа

1. **Сводка**:
   - Клиника: id, название
   - Отзывов с текстом: X / всего Y
   - Ответов клиники: X
   - Языки оригиналов: ru: X, en: X, bs: X, ...
   - Врачи с паттернами: X
2. **Конфиг**: сохранённый файл `data/review-import-configs/<slug>.json`
3. **SQL**: результат работы скрипта
4. **Команда запуска**:
```
mysql -u root -p --default-character-set=utf8mb4 docta_me < d:/pet/docta.me/nuxt/server/sql/insert-reviews-<slug>.sql
```

---END---
