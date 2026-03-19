# Импорт отзывов Google Maps

## Обзор

Двухэтапный процесс: LLM создаёт конфиг → скрипт генерирует SQL.

```
JSON (Google Places) + config → generate-reviews-sql.mjs → SQL → mysql
```

---

## Быстрый старт

### Если клиника уже есть в БД и конфиг уже создан

```bash
node scripts/generate-reviews-sql.mjs data/review-import-configs/<name>.json
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/<output>.sql
```

### Если нужно создать конфиг для новой клиники

Дай Claude:
1. Путь к JSON файлу Google Places
2. ID клиники в БД
3. Список врачей (id, имена, специфика)

Пример промпта:

```
Создай конфиг для импорта отзывов:
- JSON: data/google-places/bar/stomatologi-just-dental-clinic.json
- clinic_id = 42
- Врачи:
  - id 521 — Евдокимова Виктория (детский стоматолог)
  - id 522 — Загородных Константин Алексеевич
- В клинике 2 врача. Детский стоматолог только Виктория.
```

---

## Формат конфига

Файл: `data/review-import-configs/<clinic-slug>.json`

```json
{
  "jsonPath": "data/google-places/<city>/<file>.json",
  "outputPath": "server/sql/insert-reviews-<clinic-slug>.sql",
  "clinicId": 42,
  "clinicName": "Название клиники (город)",
  "doctors": [
    {
      "id": 521,
      "varName": "victoria",
      "patterns": ["Виктори[яюией]", "Викари[яюией]"]
    },
    {
      "id": 522,
      "varName": "konstantin",
      "patterns": ["Константин[ауе]?(?:[^а-яёА-ЯЁ]|$)"]
    }
  ],
  "childDentistDoctorVar": "victoria"
}
```

### Поля

| Поле | Описание |
|------|----------|
| `jsonPath` | Путь к JSON Google Places (относительно корня проекта) |
| `outputPath` | Куда сохранить SQL (относительно корня проекта) |
| `clinicId` | ID клиники в таблице `clinics` |
| `clinicName` | Название для комментариев в SQL |
| `doctors` | Массив врачей для привязки отзывов |
| `doctors[].id` | ID врача в таблице `doctors` |
| `doctors[].varName` | Имя SQL-переменной (латиница, snake_case) |
| `doctors[].patterns` | Regex-паттерны для поиска упоминаний в тексте отзыва |
| `childDentistDoctorVar` | `varName` детского стоматолога (опционально). Срабатывает на «детский стоматолог», «ребёнк» |

### Если врачей нет

```json
{
  "jsonPath": "...",
  "outputPath": "...",
  "clinicId": 99,
  "clinicName": "Clinic Name",
  "doctors": []
}
```

Все отзывы будут только на клинику (`doctor_id = NULL`).

---

## Правила составления паттернов для врачей

Regex применяется к `originalText.text` отзыва. Язык текста зависит от `_wasTranslated`: если Google перевёл — текст может быть на английском, а не на языке автора. Часто отзывы на английском, боснийском, хорватском, сербском, польском и т.д. Паттерны нужно составлять под фактический язык текста.

### Проблема: `\b` не работает с кириллицей в JavaScript

Вместо `\bКонстантин\b` используйте:
```
Константин(?:[^а-яёА-ЯЁ]|$)
```

Для латиницы — аналогично, но с обоими алфавитами:
```
Esad[aeu]?(?:[^a-zA-Zа-яёА-ЯЁ]|$)
```

### Типовые паттерны

**Кириллица — имя (с падежами):**
```
Виктори[яюией]           — Виктория, Викторию, Виктории, Викторией
Константин[ауе]?(?:[^а-яёА-ЯЁ]|$)  — Константин, Константина, Константину, Константине
Ирин[аеуой](?:[^а-яёА-ЯЁ]|$)       — Ирина, Ирине, Ирину, Ириной
```

**Латиница — имя (с падежами):**
```
Berin[aeu]?(?:[^a-zA-Zа-яёА-ЯЁ]|$)  — Berin, Berina, Berinu
Esad[aeu]?(?:[^a-zA-Zа-яёА-ЯЁ]|$)   — Esad, Esada, Esadu
Jakup[aeu]?(?:[^a-zA-Zа-яёА-ЯЁ]|$)  — Jakup, Jakupa
```

**Имя-отчество:**
```
Константину\\s+Алексеевичу
```

**Уменьшительные:**
```
(?:^|[^а-яёА-ЯЁ])Кост[яеи](?:[^а-яёА-ЯЁ]|$)
```

### Ловушка: фамилия врача = название клиники

Если фамилия врача совпадает с названием клиники (напр. Buntić), **нельзя** использовать фамилию как отдельный паттерн — она ложно сработает на упоминания клиники ("Buntić clinic", "ordinacija Buntić"), и отзыв с упоминанием другого врача даст два совпадения → `NULL`.

Решение — добавить контекст "Dr":
```
[Dd]r\\.?\\s+Bunti[cć]     ✅ матчит "Dr. Buntić", "dr Buntić"
Bunti[cć]                   ❌ матчит и "Buntić clinic" — ложное срабатывание
```

### Правило при нескольких врачах

- Если в отзыве упомянуты **два или более** врача → `doctor_id = NULL` (неоднозначно)
- Если упомянут **один** врач → его `doctor_id`
- Если **никто не упомянут** → `doctor_id = NULL` (только клиника)

---

## Особенности данных Google Places API

### `_wasTranslated` и оригинальный текст

Когда Google API возвращает отзыв с `_wasTranslated: true`, поля `text` и `originalText` содержат **переведённый на русский** текст, а не настоящий оригинал. Настоящий язык виден в `originalText.languageCode` (например `en`, `uk`, `sr`).

При сборе отзывов через HTML-парсинг или повторном запросе с правильной локалью `originalText` будет содержать реальный оригинал на языке автора.

**Следствия для генератора:**
- `original_language` определяется по `originalText.languageCode` (fallback на `'ru'`)
- `text_ru` заполняется автоматически только если `original_language = 'ru'`
- Для en/uk/sr оригиналов `text_ru` = NULL, если не предоставлен через `--translations`

### `_isTextTruncated`

Google API обрезает длинные отзывы (около 500 символов). HTML-парсинг может содержать полный текст. Скрипт при мёрдже отдаёт приоритет API-версии `originalText`, с fallback на HTML.

---

## Что делает скрипт

`scripts/generate-reviews-sql.mjs` читает JSON и генерирует SQL с 4 частями:

1. **Phantom users + variables** — для каждого автора: `INSERT ... SELECT ... WHERE NOT EXISTS` (по `profile_url`), затем `SET @user_xxx`. Идемпотентно: не создаёт дубликатов при повторном запуске.
2. **Reviews** — `INSERT INTO reviews` с дедупликацией API + HTML форматов
3. **Replies** — `INSERT INTO review_replies` для ответов клиники (`ownerResponse`)

### Дедупликация

JSON может содержать дубли (один отзыв в API и HTML формате). Скрипт мёрджит:
- `publishTime` и `text_sr_cyrl` — из API (полные данные)
- `likesCount` и `ownerResponse` — из HTML
- `originalText` — из API (не обрезан), fallback на HTML

### Идемпотентность

- `ON DUPLICATE KEY UPDATE` для users, reviews, replies
- Безопасно перезапускать после обновления JSON

---

## Структура файлов

```
data/
  google-places/<city>/<clinic>.json     ← входные данные (Google API + scraping)
  review-import-configs/<slug>.json      ← конфиг генерации

scripts/
  generate-reviews-sql.mjs              ← универсальный генератор

server/sql/
  insert-reviews-<slug>.sql             ← сгенерированный SQL
  migrations/
    add-review-replies-and-likes.sql    ← миграция схемы (запустить один раз)
```

---

## Переводы

Скрипт автоматически переводит отзывы и ответы на все поддерживаемые языки.

### Требуется

`ANTHROPIC_API_KEY` в `.env` или в переменных окружения.

### Языки

| Колонка | Источник |
|---------|----------|
| `text_ru` | Копия `original_text`, если `original_language = 'ru'`. Иначе — LLM-перевод. |
| `text_sr_cyrl` | Google API перевод (если доступен), иначе — LLM-перевод. |
| `text_sr` | Транслитерация из `text_sr_cyrl` (кириллица → латиница). Если нет sr_cyrl — LLM-перевод. |
| `text_en` | LLM-перевод |
| `text_de` | LLM-перевод |
| `text_tr` | LLM-перевод |

### Модель

`claude-haiku-4-5-20251001` — быстрая и дешёвая, достаточная для переводов отзывов.

### Batch-режим

Отзывы переводятся пачками по 20 штук за один API-запрос. Для 110 отзывов — ~6 запросов на отзывы + ~3 на ответы.

### Двухпроходный режим (без API ключа)

Если API ключа нет — используй Claude через VS Code / веб-интерфейс:

```bash
# Шаг 1: извлечь тексты в JSON
node scripts/generate-reviews-sql.mjs <config.json> --extract
# → создаёт data/review-translations/<slug>-texts.json

# Шаг 2: отдать JSON на перевод в Claude:
# "Переведи тексты из файла <slug>-texts.json по инструкции в _instructions"
# Claude заполнит translations и сохранит как <slug>-translations.json

# Шаг 3: сгенерировать SQL с переводами
node scripts/generate-reviews-sql.mjs <config.json> --translations data/review-translations/<slug>-translations.json
```

Формат файла переводов совпадает с файлом текстов — те же структуры `reviews[]` и `replies[]`, но с заполненными `translations`.

**Важно:** поле `id` в файле переводов — это reviewId (последний сегмент `name`), а не полный `provider_review_id`. Поле `text` должно совпадать с `originalText.text` из Google Places JSON — если JSON обновлялся, файл переводов устаревает.

**⚠️ Кавычки в переводах:** сербский и немецкий используют кавычки `„"` (U+201E открывающая, U+201C закрывающая). При ручном создании JSON закрывающая `"` может оказаться обычной ASCII `"` (U+0022), что ломает JSON-парсер. Используйте escape-последовательности `\u201e` и `\u201c`, либо заменяйте на обычные кавычки.

### Без переводов вообще

Если ни API ключа, ни `--translations` нет, скрипт всё равно работает:
- `text_ru` = оригинал (если русский)
- `text_sr` = транслитерация из `text_sr_cyrl` (если есть от Google)
- `text_en`, `text_de`, `text_tr` = NULL

---

## Схема БД (релевантные таблицы)

### `reviews`
- `user_id` → `auth_users.id` (автор, phantom user)
- `clinic_id` → `clinics.id`
- `doctor_id` → `doctors.id` (NULL если не определён)
- `provider` = `'google_maps'`
- `provider_review_id` = `places/{place_id}/reviews/{review_id}` (unique key для дедупа)
- `rating` (1–5)
- `original_language`, `original_text` — оригинал
- `text_sr_cyrl` — перевод Google на сербскую кириллицу (только API)
- `likes_count` — денормализованный счётчик лайков

### `review_replies`
- `review_id` → `reviews.id`
- `responder_type` = `'clinic'` (ответ клиники) или `'doctor'`
- `clinic_id` → `clinics.id`
- Unique: `(review_id, responder_type)` — макс. 1 ответ клиники + 1 врача

### `auth_users` (phantom)
- `is_phantom = TRUE`
- `profile_url` — Google Maps contributor URL (unique для дедупа)

---

## Команда запуска

```bash
# 1. Сгенерировать SQL
node scripts/generate-reviews-sql.mjs data/review-import-configs/<slug>.json

# 2. Применить к БД
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-reviews-<slug>.sql
```

⚠️ Флаг `--default-character-set=utf8mb4` обязателен для кириллицы!

---

## Примеры существующих конфигов

### `just-dental-bar.json`

Клиника JUST Dental Clinic в Баре, 2 врача (Виктория — детский, Константин — взрослый). Отзывы на русском, паттерны кириллицей.

### `buntic-bar.json`

Клиника Buntić в Баре, 4 врача (Berin Buntić, Jakup Katana, Kalezić Esad, Lero Jelena). Отзывы на английском/боснийском/хорватском/польском — паттерны латиницей. Фамилия врача (Buntić) совпадает с названием клиники → используется контекст `[Dd]r\\.?\\s+Bunti[cć]`.

### `dental-esthetic-studio-bar.json`

Клиника Dental & Esthetic Studio Dr Debelja в Баре, 2 врача (Татьяна, Михаил). Смешанные паттерны: кириллица для русскоязычных отзывов.
