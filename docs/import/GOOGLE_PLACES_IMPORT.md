# Импорт медучреждений с Google Maps

## Пререквизиты

1. Google Cloud проект с включенным **Places API (New)**
2. API ключ в `.env`:
   ```
   GOOGLE_MAPS_API_KEY=AIza...
   ```
3. Ключ ограничен только на Places API (New) в Cloud Console → Credentials → API key → API restrictions

## Этап 1: Сбор сырых данных

Скрипт: `scripts/collectors/google-places.mjs`

**Перезаписывает каталог и тратит платные запросы.** Правила и цена ошибки —
`docs/rules/GOOGLE_PLACES_DATA.md`. Без `--yes` скрипт печатает план и выходит.

```bash
# что произойдёт: какие файлы и сколько запросов
node scripts/collectors/google-places.mjs city bar

# один город → data/google-places/all-bar.json
node scripts/collectors/google-places.mjs city bar --yes

# вся страна → data/google-places/all-montenegro.json
node scripts/collectors/google-places.mjs montenegro --yes

# разложить all-montenegro.json по папкам городов (без API)
node scripts/collectors/google-places.mjs split --yes
```

Результат: `data/google-places/all-<город>.json` — сырые данные Google Places API, без трансформации.

### Как добавить новый тип учреждений

В `scripts/collectors/google-places.mjs` дописать тип в `PLACE_TYPES`.

Доступные типы Google Places:

- `dentist` — стоматологии
- `hospital` — больницы
- `doctor` — врачебные кабинеты
- `pharmacy` — аптеки
- `physiotherapist` — физиотерапия

## Этап 2: Перекладка в БД (будет позже)

Сырые данные из `data/google-places/` будут трансформироваться в SQL-скрипт:

- Клиники → таблица `clinics` (с `google_place_id` для дедупликации)
- Отзывы → таблица `reviews` (полиморфная: clinic_id / doctor_id / medical_service_id)

### Формат контактов при перекладке

| Поле      | Формат                         | Пример                      |
| --------- | ------------------------------ | --------------------------- |
| phone     | `+382XXXXXXXX` (без пробелов)  | `+38269026702`              |
| whatsapp  | `+382XXXXXXXX`                 | `+38269026702`              |
| viber     | `+382XXXXXXXX`                 | `+38269026702`              |
| instagram | `@username`                    | `@pzu.milmedika`            |
| facebook  | `facebook.com/pagename`        | `facebook.com/milmedika`    |
| website   | полный URL с https://          | `https://www.mojlab.me/`    |
| email     | `user@domain.com`              | `poliklinika.ul@mojlab.me`  |
| telegram  | `@username` или `+382XXXXXXXX` | `@a3medicalme`              |
| несколько | через `;`                      | `+38269026702;+38268026702` |

### Отзывы

Импорт отзывов описан в отдельном документе: **`REVIEWS_IMPORT.md`**

Вкратце: создаёшь конфиг в `data/review-import-configs/` → запускаешь `node scripts/generate-reviews-sql.mjs <config.json>` → получаешь SQL.
