# Импорт медучреждений с Google Maps

## Пререквизиты

1. Google Cloud проект с включенным **Places API (New)**
2. API ключ в `.env`:
   ```
   GOOGLE_MAPS_API_KEY=AIza...
   ```
3. Ключ ограничен только на Places API (New) в Cloud Console → Credentials → API key → API restrictions

## Этап 1: Сбор сырых данных

Скрипт: `tests/scripts/parse-google-places.spec.ts`

Запускается из панели Testing в VS Code (проект **scripts**) или через CLI:

```bash
# Превью одного города (консоль, без сохранения)
npx playwright test --project=scripts -g "Bar only"

# Все города → файл
npx playwright test --project=scripts -g "all cities"
```

Результат: `data/google-places/{type}.json` — сырые данные Google Places API, без трансформации.

### Как добавить новый тип учреждений

В файле `parse-google-places.spec.ts` добавить новый `test(...)` блок по аналогии с dentist.

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

| Поле      | Формат                                      | Пример                                        |
|-----------|---------------------------------------------|-----------------------------------------------|
| phone     | `+382XXXXXXXX` (без пробелов)               | `+38269026702`                                |
| whatsapp  | `+382XXXXXXXX`                              | `+38269026702`                                |
| viber     | `+382XXXXXXXX`                              | `+38269026702`                                |
| instagram | `@username`                                 | `@pzu.milmedika`                              |
| facebook  | `facebook.com/pagename`                     | `facebook.com/milmedika`                      |
| website   | полный URL с https://                       | `https://www.mojlab.me/`                      |
| email     | `user@domain.com`                           | `poliklinika.ul@mojlab.me`                    |
| telegram  | `@username` или `+382XXXXXXXX`              | `@a3medicalme`                                |
| несколько | через `;`                                   | `+38269026702;+38268026702`                   |

### Отзывы

Импорт отзывов описан в отдельном документе: **`REVIEWS_IMPORT.md`**

Вкратце: создаёшь конфиг в `data/review-import-configs/` → запускаешь `node scripts/generate-reviews-sql.mjs <config.json>` → получаешь SQL.
