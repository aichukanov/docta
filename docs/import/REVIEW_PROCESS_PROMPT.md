Обработай отзывы клиники из файла `<ФАЙЛ>`.

Прочитай:
1. Файл клиники (указан выше)
2. `data/from-db/clinic-list.txt` — список клиник в БД
3. `data/from-db/clinics-doctors.json` — врачи по клиникам
4. `data/review-import-configs/dr-zejnilovic-bar.json` — пример готового конфига
5. `REVIEWS_IMPORT.md` — документация по формату конфигов и паттернам
6. `data/review-import-progress.json` — лог прогресса обработки клиник

### 0. Проверь прогресс (защита от повторных запусков)

Этот промпт может быть запущен повторно случайно. Перед началом работы проверь `data/review-import-progress.json`:

- Если клиника уже есть в прогрессе со статусом `"done"` — **ничего не делай**. Сообщи:
  > Клиника `<название>` уже полностью обработана (конфиг, переводы, SQL). Повторный запуск не требуется.
- Если статус `"partial"` — проверь, что именно не завершено:
  - Если нет переводов или переводы неполные — посчитай существующие файлы в `translationsDir` и продолжи с того места, где остановился (не перезаписывай уже готовые файлы)
  - Если переводы готовы, но нет SQL — запусти только генерацию SQL (шаг 5)
  - Обнови запись в `review-import-progress.json` после завершения
- Если клиники нет в прогрессе — обработай с нуля (шаги 1–5)

После завершения обработки **обязательно обнови** `data/review-import-progress.json`: добавь или обнови запись клиники со статусом `"done"` и всеми полями.

Выполни:

### 1. Найди клинику и врачей
- Найди клинику в `clinic-list.txt` по названию и городу из JSON (`displayName.text`, `formattedAddress`)
- Найди врачей этой клиники в `clinics-doctors.json`

### 2. Составь паттерны
- Прочитай тексты всех отзывов, определи кого из врачей упоминают
- Составь regex-паттерны по правилам из `REVIEWS_IMPORT.md`
- Добавляй паттерны только для врачей, которых реально упоминают в отзывах

### 3. Сохрани конфиг

Сохрани конфиг `data/review-import-configs/<slug>.json`:

```json
{
  "jsonPath": "data/google-places/<city>/<file>.json",
  "outputPath": "server/sql/insert-reviews-<slug>.sql",
  "dataCollectedDate": "2026-03-18",
  "clinicId": <id>,
  "clinicName": "<название>",
  "translationsDir": "data/review-translations/<slug>/",
  "doctors": [
    {
      "id": <doctor id>,
      "varName": "<snake_case>",
      "patterns": ["<regex>"]
    }
  ]
}
```

### 4. Переведи отзывы

Создай папку `data/review-translations/<slug>/`.

#### Формат файлов

`data/review-translations/<slug>/review-<NNN>.json` (NNN — порядковый номер 001, 002, ...)

```json
{
  "id": "<reviewId — последний сегмент name после /reviews/, или _reviewId>",
  "original_language": "<originalText.languageCode, fallback 'ru'>",
  "text": "<originalText.text — точная копия>",
  "translations": {
    "sr": "...", "sr_cyrl": "...", "en": "...",
    "ru": "...", "de": "...", "tr": "..."
  }
}
```

Если у отзыва есть `ownerResponse` — сохрани ответ отдельным файлом:

`data/review-translations/<slug>/reply-<NNN>.json`

```json
{
  "type": "reply",
  "id": "<reviewId родительского отзыва>",
  "original_language": "<ownerResponse.languageCode, fallback 'sr'>",
  "text": "<ownerResponse.text>",
  "translations": { "sr": "...", "sr_cyrl": "...", "en": "...", "ru": "...", "de": "...", "tr": "..." }
}
```

#### Способ: выбери по количеству отзывов

**До ~30 отзывов** — переводи и сохраняй каждый отзыв по одному (Write tool). Так прогресс не потеряется при сбое.

**Больше ~30 отзывов** — используй пакетный режим со вспомогательными скриптами:

1. Извлеки сырые данные:
```bash
node -e "
  const d = require('./<google-places-file>.json');
  const r = d.reviews.filter(r => r.originalText?.text?.trim()).map((r, i) => ({
    idx: i+1,
    id: r._reviewId || r.name.split('/reviews/')[1],
    lang: r.originalText.languageCode || 'sr',
    text: r.originalText.text,
    hasReply: !!(r.ownerResponse?.text?.trim()),
    replyLang: r.ownerResponse?.languageCode || 'sr',
    replyText: r.ownerResponse?.text || ''
  }));
  require('fs').writeFileSync('data/review-translations/<slug>-raw.json', JSON.stringify(r, null, 2));
"
```

2. Создай скелеты файлов (копирует оригинал в нужное поле, остальные — пустые):
```bash
node scripts/generate-translation-files.mjs data/review-translations/<slug>-raw.json data/review-translations/<slug>/
```

3. Переводи пакетами — создай JSON-файл с переводами и влей:
```bash
node scripts/merge-translations.mjs data/review-translations/<slug>/ <batch-file>.json
```

Формат batch-файла:
```json
{
  "review-001": { "sr_cyrl": "...", "en": "...", "ru": "...", "de": "...", "tr": "..." },
  "reply-001": { "sr_cyrl": "...", "en": "...", "ru": "...", "de": "...", "tr": "..." },
  ...
}
```

4. Удали временные файлы (`<slug>-raw.json`, batch-файлы) после завершения.

#### Правила перевода:
- Если `original_language` совпадает с целевым — скопируй оригинал
- Если `text.languageCode` = `"sr"` и текст кириллицей — используй для `sr_cyrl`, транслитерируй для `sr`
- **sr_cyrl** — переводи вручную, наивная транслитерация ненадёжна (имена, бренды, иностранные слова не транслитерируются)
- Сохраняй тон, стиль, эмодзи
- Имена врачей и клиник НЕ переводи
- Пропускай отзывы без текста

### 5. Запусти генерацию SQL

После сохранения всех переводов выполни:
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
3. **Переводы**: сохранённые файлы в `data/review-translations/<slug>/`
4. **SQL**: результат работы скрипта
5. **Команда запуска**:
```
mysql -u root -p --default-character-set=utf8mb4 docta_me < e:/pet/docta.me/nuxt/server/sql/insert-reviews-<slug>.sql
```
