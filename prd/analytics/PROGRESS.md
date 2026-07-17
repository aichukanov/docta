# Прогресс реализации: Система аналитики и трэкинга

**Последнее обновление:** 12 июня 2026
**Общий статус:** 🟢 Код завершён (фазы А и Б) — осталась только конфигурация Mixpanel UI

---

## Общая информация

- **PRD:** [analytics/index.md](index.md)
- **Каталог событий (актуальный):** [events-catalog.md](events-catalog.md)
- **Приоритет:** P1 (высокий)

Документы итераций писались до реализации и местами устарели; реальное
положение дел — здесь и в events-catalog.md.

---

## Статус итераций

| #   | Итерация                                                                 | Статус                  | Комментарий |
| --- | ------------------------------------------------------------------------ | ----------------------- | ----------- |
| 1   | [Настройка Mixpanel и базовые события](iterations/iteration-01-setup.md) | 🟢 Completed            | Сделано ранее иначе, чем в плане: без отдельного plugin — динамический импорт SDK в `use-analytics.ts` после consent; `track_pageview: true`; параллельно работают GA4 (nuxt-gtag) и Cloudflare Insights |
| 2   | [События просмотра страниц](iterations/iteration-02-page-views.md)       | 🟢 Completed (код)      | `entity_viewed` на всех детальных страницах; листинги покрыты auto-pageview (фильтры видны в URL); identify/reset подключены; super properties (locale, page_type); счётчики `incrementUserProperty` не делали — считается в Mixpanel из событий |
| 3   | [События взаимодействия](iterations/iteration-03-interactions.md)        | 🟢 Completed            | Контакты (клики+копирование без PII), переходы между сущностями, поиск/фильтры листингов (`use-filter-tracking.ts`), карта (`map_opened`/`map_marker_clicked`), карточка клиники. Избранное — пропущено, его нет в продукте |
| 4   | [События конверсий и воронки](iterations/iteration-04-funnels.md)        | 🟡 In Progress          | Кодовая часть готова (свойства `entity_*`/`page_type` под воронки). Осталась конфигурация в Mixpanel UI — отдельный PRD [mixpanel-setup.md](mixpanel-setup.md) |

---

## Что реализовано (фаза А, 2026-06-11)

### Инфраструктура

- `types/analytics.ts` — типизированный каталог событий; `trackEvent` —
  дженерик по каталогу, неправильные свойства не компилируются.
- `composables/use-analytics.ts` — enrichment `page_type`, super properties
  (locale, page_type), ручной `track_pageview()` на SPA-переходах, очередь
  до загрузки SDK, `identifyUser`/`resetUser`. Проверка consent сохранена.
- `plugins/analytics-user.client.ts` — identify при логине (user property
  `auth_provider`: google/telegram/facebook/password), reset при логауте.
- `server/utils/session.ts` — поле `auth_provider` в активном пользователе.

### События

- `entity_viewed` — детальные страницы: клиника, врач, услуга, анализ,
  лекарство (medicines + medications), 2 статьи.
- `entity_link_clicked` — карточка врача, priced-item-card (услуги/анализы/
  лекарства), list-card (заголовок + «все клиники»), ссылки в статьях.
- `contact_clicked` / `contact_copied` — все контактные компоненты;
  PII убрана (раньше `contact_copied` слал само значение). Владелец контакта
  передаётся через provide/inject (`provideAnalyticsEntity`).

### Фаза Б (2026-06-12, после завершения окна 1)

- Карточка клиники: `entity_link_clicked` в `clinic/summary-header.vue`,
  provide в `clinic/summary.vue`.
- Поиск/фильтры: `composables/use-filter-tracking.ts` + вызов на 6
  листинг-страницах (`search_performed`, `filter_applied`, `filter_cleared`;
  debounce уже в FilterName, синхронизация из URL не трекается).
- Карта: `map_opened` (mount ленивой карты), `map_marker_clicked`
  (клик по маркеру), provide + клик по имени клиники в `map/clinic-popup.vue`,
  переходы из попапа (`service-info.vue`).

### Осталось пользователю (не код)

- Конфигурация Mixpanel UI: custom event «Contact Action», воронки,
  борды, когорты, retention, дайджесты — PRD с чеклистом в
  [mixpanel-setup.md](mixpanel-setup.md).

---

## Решения и отступления от PRD

- Унифицированные события (`entity_viewed` + `entity_type`) вместо
  отдельных «Clinic Viewed»/«Doctor Viewed» — воронки строятся фильтрами по
  свойствам, каталог не разрастается.
- Snake_case имён вместо Title Case из старого PRD.
- Избранное (F7.1–7.2) — функционала нет, события не делали.
- Unit-тестов нет (в проекте нет фреймворка) — проверка typecheck + debug
  mode.
- GA4-форвардинг событий не делали: nuxt-gtag шлёт свои pageview, продуктовые
  события — только в Mixpanel.

---

## История изменений

| Дата       | Изменение                                                       | Автор |
| ---------- | --------------------------------------------------------------- | ----- |
| 2026-01-29 | Создан PRD и структура итераций                                 | -     |
| 2026-06-11 | Фаза А: каталог типов, контакты, переходы, identify, super props | -     |
| 2026-06-12 | Фаза Б: карточка клиники, поиск/фильтры листингов, карта         | -     |
