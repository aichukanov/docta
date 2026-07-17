# PRD: Настройка Mixpanel UI

**Статус:** 🔴 Not Started
**Тип работы:** конфигурация в интерфейсе Mixpanel — кода нет
**Основание:** [events-catalog.md](events-catalog.md) (источник истины по событиям)
**Закрывает:** [итерацию 4](iterations/iteration-04-funnels.md) PRD аналитики
**Оценка:** ~0.5 дня настройки + 1–2 недели накопления данных + 1 час ревизии

---

## 1. Цель

Код трекинга готов (фазы А и Б): в Mixpanel едут 9 продуктовых событий +
авто-pageview, super properties `locale`/`page_type`, identify по
`auth_provider`. Но сырой поток событий — это ещё не аналитика. Цель этого
PRD — настроить Mixpanel так, чтобы без ручного ковыряния в Events были
видны ответы на продуктовые вопросы:

1. **Ценность каталога:** сколько просмотров конвертируется в контактное
   действие (звонок/мессенджер/сайт)? Какие клиники/услуги генерируют
   контакты?
2. **Путь пользователя:** где отваливаются на цепочке
   «услуга/врач → клиника → контакт»?
3. **Каналы связи:** что предпочитают — телефон, WhatsApp/Viber/Telegram,
   сайт клиники?
4. **Возвращаемость:** приходят ли пользователи повторно?
5. **Поиск и фильтры:** что ищут, какие фильтры используют, какие запросы
   возвращают ноль результатов (= дыры каталога)?

Ключевая конверсия продукта — **контактное действие**: записи/бронирования
в продукте нет, поэтому `contact_clicked`/`contact_copied` — прокси-метрика
ценности для пользователя и клиник.

---

## 2. Контекст: что уже едет в Mixpanel

Подробно — в [events-catalog.md](events-catalog.md). Краткая сводка:

| Событие               | Смысл                            | Ключевые свойства                         |
| --------------------- | -------------------------------- | ----------------------------------------- |
| `$mp_web_page_view`   | Авто-pageview (вкл. SPA-переходы) | `$current_url`, `page_type`, `locale`     |
| `entity_viewed`       | Просмотр детальной страницы      | `entity_type/id/slug`, `entity_name`, `clinics_count` |
| `entity_link_clicked` | Переход между сущностями         | `entity_*` (цель), `position`, `page_type` (источник) |
| `contact_clicked`     | Клик по контакту                 | `contact_type`, `entity_*` (владелец)     |
| `contact_copied`      | Копирование контакта             | `contact_type`, `entity_*` (владелец)     |
| `search_performed`    | Поиск на листинге (debounced)    | `query`, `results_count`                  |
| `filter_applied`      | Применение фильтра               | `filter_name`, `filter_value`             |
| `filter_cleared`      | Сброс фильтра(ов)                | `filters_count`                           |
| `map_opened`          | Карта смонтирована               | `markers_count`                           |
| `map_marker_clicked`  | Клик по маркеру клиники          | `entity_*`                                |

Во **всех** событиях: super properties `locale`, `page_type`; Mixpanel
добавляет `$city`, `$referrer`, устройство. PII в свойствах нет. После
логина события связаны с `$user_id`, в профиле — `auth_provider`.

---

## 3. Шаг 0. Подготовка проекта (Project Settings)

- [ ] Убедиться, что проект на **EU residency** (данные едут на
      `api-eu.mixpanel.com` — проект обязан быть EU, иначе события теряются).
- [ ] **Timezone** проекта: `Europe/Podgorica` (CET) — иначе «дни» в отчётах
      съедут относительно реального трафика.
- [ ] **Session settings:** timeout-based, 30 минут (дефолт ок).
- [ ] Проверить, что dev-трафик не льётся в прод-проект: в dev должен быть
      отдельный token или debug-режим без отправки. Если dev-события есть —
      завести второй проект «docta dev» и развести токены.

## 4. Шаг 1. Data Management

### 4.1 Lexicon (словарь данных)

- [ ] Events → Lexicon: каждому из 9 событий вписать описание из
      events-catalog.md (одной строкой) — чтобы отчёты могла собирать не
      только память автора.
- [ ] Описать ключевые свойства: `entity_type`, `entity_id`, `entity_slug`,
      `contact_type`, `page_type`, `filter_name`, `query`.
- [ ] Просмотреть полный список событий за всю историю проекта: если там
      есть легаси-события старой схемы (Title Case, событие копирования со
      значением телефона/email в свойствах) — **Hide** их в Lexicon, чтобы
      не мусорили автокомплит. Сами исторические данные не удаляем.

### 4.2 Custom event «Contact Action»

Почти все воронки и метрики используют «любое контактное действие» —
собираем его один раз:

- [ ] Events → Custom Events → New:
      **Contact Action** = `contact_clicked` OR `contact_copied`.

### 4.3 Custom property «contact_channel» (опционально)

Для отчётов по каналам удобна группировка `contact_type`:

- [ ] Custom property (formula в Insights или Lexicon → Custom Properties):
      `phone → call`; `whatsapp/viber/telegram → messenger`;
      `website → web`; `facebook/instagram → social`; `email → email`.
      Если на текущем тарифе custom properties недоступны — пропустить,
      breakdown по сырому `contact_type` достаточен.

## 5. Шаг 2. Воронки (Funnels)

Общие настройки для всех воронок: counting — **Uniques**, порядок шагов —
«in this order» (нестрогий), conversion window — **1 день** (сценарий
«нашёл врача → связался» укладывается в одну сессию; окно с запасом).

> Нюанс: контакты доступны и прямо в карточках клиник на страницах
> услуг/врачей (без перехода на страницу клиники), поэтому 3-шаговые воронки
> измеряют именно путь *через страницу клиники*. Для полной конверсии
> «посмотрел услугу → связался» рядом с каждой 3-шаговой воронкой смотреть
> 2-шаговый вариант (шаг 1 → Contact Action).

### F1. Service → Clinic → Contact

1. `entity_viewed`, фильтр `entity_type = service`
2. `entity_link_clicked`, фильтры `entity_type = clinic` AND `page_type = service_detail`
3. `Contact Action`

- Breakdown: `locale`; `entity_slug` шага 1 (какие услуги конвертят).
- Опционально: Hold property constant — `entity_id` между шагами 2–3,
  чтобы контакт засчитывался той же клинике, на которую кликнули.

### F2. Doctor → Clinic → Contact

То же, но шаг 1 `entity_type = doctor`, шаг 2 `page_type = doctor_detail`.

### F3. Clinic view → Contact (главная короткая)

1. `entity_viewed`, фильтр `entity_type = clinic`
2. `Contact Action`

- Breakdown: `contact_type` шага 2 (каким каналом конвертят), `locale`,
  `entity_slug` шага 1 (конверсия по клиникам).
- Эта воронка — single-value виджет на борде Overview.

### F4. Search → Detail → Contact

1. `search_performed`
2. `entity_viewed`
3. `Contact Action`

- Breakdown: `locale`. По `query` не разбивать (высокая кардинальность) —
  топ-запросы смотрим отдельным виджетом на борде Discovery.

### F5. Medicine → Clinic → Contact (опционально)

То же, что F1, но шаг 1 `entity_type = medicine`, шаг 2
`page_type = medicine_detail OR medication_detail`. Настроить, когда
появится заметный трафик на разделы лекарств.

Воронка «Избранное» из старого PRD **не настраивается** — избранного в
продукте нет.

## 6. Шаг 3. Дашборды (Boards)

Четыре борда. Дефолтный период виджетов — последние 30 дней, line-графики
с гранулярностью «день» (при малом трафике переключить на «неделя»).

### Board «Overview» — ежедневный пульс

| Виджет                      | Отчёт    | Конфигурация                                                     |
| --------------------------- | -------- | ---------------------------------------------------------------- |
| DAU / WAU / MAU             | Insights | All Events → Unique users; три линии (day/week/month)            |
| Топ событий                 | Insights | Total events, breakdown по Event Name, bar                       |
| Просмотры по типам страниц  | Insights | `$mp_web_page_view`, breakdown `page_type`, stacked line         |
| Конверсия Clinic → Contact  | Funnels  | F3, single value (overall conversion %)                          |
| Распределение по локалям    | Insights | Any event → Unique users, breakdown `locale`, pie                |
| География                   | Insights | `entity_viewed`, breakdown `$city`, bar (top 10)                 |

### Board «Content» — что смотрят

| Виджет                        | Конфигурация                                                              |
| ----------------------------- | ------------------------------------------------------------------------- |
| Топ-10 клиник по просмотрам   | `entity_viewed`, фильтр `entity_type = clinic`, breakdown `entity_name`   |
| Топ-10 услуг                  | то же с `entity_type = service`                                            |
| Топ-10 анализов               | то же с `entity_type = labtest`                                            |
| Топ-10 лекарств               | то же с `entity_type = medicine`                                           |
| Просмотры статей              | то же с `entity_type = article`, breakdown `entity_slug`                  |
| Тренд просмотров по типам     | `entity_viewed`, breakdown `entity_type`, line                            |

### Board «Engagement» — контакты (главная ценность)

| Виджет                          | Конфигурация                                                                  |
| ------------------------------- | ------------------------------------------------------------------------------ |
| Тренд контактных действий       | `Contact Action`, breakdown `contact_type`, line                               |
| Contact rate по типам сущностей | Formula (A/B): A = `Contact Action` uniques, B = `entity_viewed` uniques, breakdown `entity_type` |
| Топ клиник по контактам         | `Contact Action`, breakdown `entity_name` (владелец контакта), top 10          |
| Каналы контакта                 | `Contact Action`, breakdown `contact_type`, pie                                |
| Клик vs копирование             | `contact_clicked` и `contact_copied` рядом, line                               |

### Board «Discovery» — поиск, фильтры, карта

| Виджет                       | Конфигурация                                                                 |
| ---------------------------- | ----------------------------------------------------------------------------- |
| Тренд поиска                 | `search_performed`, line                                                      |
| Топ-20 запросов              | `search_performed`, breakdown `query`, table                                  |
| Запросы без результатов      | `search_performed`, фильтр `results_count = 0`, breakdown `query` — **дыры каталога**, прямой бэклог на добавление контента |
| Использование фильтров       | `filter_applied`, breakdown `filter_name`, bar                                |
| Карта: открытия и клики      | `map_opened` + `map_marker_clicked`, line                                     |
| CTR карты                    | Formula: `map_marker_clicked` / `map_opened` (uniques)                        |

## 7. Шаг 4. Когорты (Users → Cohorts)

- [ ] **High intent** — `entity_viewed` ≥ 3 за 7 дней AND `Contact Action`
      ≥ 1 за 7 дней. Использование: фильтр в отчётах «как ведут себя
      целевые пользователи».
- [ ] **Logged in** — user property `auth_provider` is set. Сравнение
      поведения залогиненных и анонимов.
- [ ] **Contacted** — `Contact Action` ≥ 1 за 30 дней. База «сконвертившихся»
      для retention и сравнения с остальными.

## 8. Шаг 5. Retention

- [ ] **Weekly retention:** first event = `entity_viewed`, return event =
      any event, weekly, 8 недель. Вопрос: возвращаются ли вообще.
- [ ] **Contact retention (опционально):** first event = `Contact Action`,
      return event = `Contact Action`, weekly, 4 недели. Вопрос:
      возвращаются ли за повторным контактом (поведение «справочник под
      рукой»).

## 9. Шаг 6. Дайджесты и алерты

- [ ] Подписать себя на **weekly email-digest** борда Overview
      (Board → Subscribe) — пассивный мониторинг без захода в Mixpanel.
- [ ] Если тариф позволяет custom alerts: алерт на падение `Contact Action`
      неделя-к-неделе > 30%. Если нет — достаточно дайджеста.

## 10. Шаг 7. Проверка качества данных

Сразу после настройки (Live View / Events):

- [ ] У событий есть `page_type`, `locale`; у entity-событий — `entity_*`.
- [ ] В `contact_*` нет телефонов/email в свойствах (только `contact_type`).
- [ ] После логина события связаны с `$user_id`; в профиле `auth_provider`.
- [ ] `$mp_web_page_view` едет и на полную загрузку, и на SPA-переходы
      (открыть листинг → перейти на детальную → проверить два pageview).
- [ ] Легаси-события скрыты, автокомплит чистый.

Через 1–2 недели данных:

- [ ] Все 4 воронки показывают ненулевую конверсию.
- [ ] Виджеты бордов заполнены; пустые — починить или убрать.
- [ ] Сверить порядок величин уникальных посетителей с GA4 / Cloudflare
      Insights → оценить долю consent-отказов и блокировщиков (см. риски).
      Зафиксировать коэффициент недоучёта в PROGRESS.md.

---

## 11. Критерии приёмки

- [ ] Custom event «Contact Action» создан и используется в воронках.
- [ ] 4 воронки (F1–F4) настроены и сохранены.
- [ ] 4 борда (Overview, Content, Engagement, Discovery) созданы,
      виджеты заполняются данными.
- [ ] 3 когорты созданы.
- [ ] Weekly retention настроен.
- [ ] Email-дайджест Overview подписан.
- [ ] Проверка качества данных пройдена, коэффициент недоучёта оценён.
- [ ] Lexicon заполнен, легаси скрыто.

После приёмки: статус итерации 4 в [PROGRESS.md](PROGRESS.md) → 🟢 Completed.

---

## 12. Порядок выполнения

1. День 1 (~0.5 дня): шаги 0–6 целиком — настройки, Lexicon, custom event,
   воронки, борды, когорты, retention, дайджест. Сразу — первая часть шага 7
   (Live View).
2. Через 1–2 недели (~1 час): вторая часть шага 7 — ревизия воронок и
   бордов на реальных данных, оценка недоучёта, корректировка гранулярности
   виджетов под фактический трафик.

---

## 13. Риски и ограничения

| Риск / ограничение | Деталь | Что делать |
| --- | --- | --- |
| Недоучёт трафика | События уходят только после cookie-consent; клиентский SDK режут блокировщики | Оценить долю сравнением с Cloudflare Insights/GA4; помнить, что абсолютные числа занижены, тренды и конверсии — валидны |
| Малый трафик | Дневные воронки и графики будут шумными | Смотреть недельную гранулярность; не делать выводов по breakdown-сегментам < 50 пользователей |
| `results_count` в `filter_applied` не шлётся | refetch асинхронный | Принято; эффективность фильтров оцениваем по использованию, не по результатам |
| Email не кликабелен в UI | только копирование | `Contact Action` уже включает `contact_copied` — покрыто |
| Листинги без отдельного события | просмотры листингов = pageview, фильтры видны в query-параметрах `$current_url` | Для разовых вопросов парсить `$current_url` фильтром «contains»; отдельное событие листинга не заводим |
| Free tier | лимиты на события/фичи могут поменяться | Все обязательные пункты PRD доступны на бесплатном тарифе; custom properties и alerts — проверить по месту, они помечены как опциональные |

---

## 14. Ритуал использования (после настройки)

- **Еженедельно** (или по email-дайджесту): Overview — тренд пользователей
  и конверсия F3; Engagement — тренд контактов.
- **Раз в месяц:** Discovery → «запросы без результатов» → пополнить бэклог
  контента; Content → топы — понять, что продвигать.
- Перед продуктовыми решениями по разделу — смотреть соответствующую
  воронку с breakdown по `entity_slug`.
