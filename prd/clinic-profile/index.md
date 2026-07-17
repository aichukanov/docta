# PRD: Профиль клиники

**Статус:** Complete (6/6 итераций, кабинет клиники реализован 2026-06-11)  
**Приоритет:** P1 (высокий)

---

## Навигация по документу

### 📊 Статус

- **[📈 PROGRESS.md](PROGRESS.md)** - Текущий прогресс разработки

### 📋 Основная информация

- **[1. Обзор](01-overview.md)** - Цель, контекст, ограничения
- **[2. Требования](02-requirements.md)** - Функциональные и нефункциональные требования
- **[3. Архитектура](03-architecture.md)** - API, компоненты, диаграммы
- **[4. База данных](04-database.md)** - Изменения в схеме БД
- **[5. Риски и метрики](05-risks-and-metrics.md)** - Риски, KPI

### 🔄 Итерации разработки

- **[Итерация 1: ✅ Публичная страница клиники](iterations/iteration-01-public-page.md)** [ЗАВЕРШЕНО]
- **Итерации 2–6: ✅ Кабинет клиники** [ЗАВЕРШЕНО 2026-06-11] — создание,
  редактирование, контент, markdown, draft/published; детали в
  [iterations/README.md](iterations/README.md) и [PROGRESS.md](PROGRESS.md)

---

## Краткое описание

Полноценный профиль клиники с публичной страницей, CRUD операциями, управлением контентом (врачи, услуги, анализы, лекарства), Markdown описанием и draft/published режимами.

**Текущий статус:** 🟡 Partial Implementation (1/6 итераций) - [Смотреть прогресс →](PROGRESS.md)

### ✅ Что уже реализовано (Итерация 1)

- Публичная страница клиники `/clinics/[clinicId]`
- Отображение названия, адреса, координат
- Локализованные названия (name, localName)
- Описание клиники (plain text)
- Языки сопровождения
- Контакты (телефон, email, viber, whatsapp, telegram)
- Кнопки "Показать на карте" и "Маршрут"
- Approved badge (верифицированная клиника)
- Список врачей (сгруппированные по специальностям)
- Список медицинских услуг (сгруппированные по категориям)
- Список анализов (сгруппированные по категориям)
- Список лекарств
- SEO метаданные и Schema.org разметка
- Локализация (6 языков)

### ✅ Реализовано в Итерациях 2–6 (кабинет клиники, 2026-06-11)

- Создание клиники (связь user → clinic creator, несколько клиник на пользователя)
- Таб «Мои клиники» в профиле: список, статусы, создание, редактирование
- Markdown-описание на 6 локалях (переиспользованы markdown-editor / marked-content)
- Draft/Published режимы (draft виден только владельцу/админу, исключён из списков и sitemap)
- Загрузка логотипа клиники
- Map picker координат (Leaflet)
- График работы (локализованный редактор)

Не вошло (осталось в админке, кандидат в отдельный PRD): пользовательское
управление врачами/услугами/анализами/лекарствами клиники.

### Зависимости

- **auth** PRD - базовая авторизация
- **user-profile** PRD - профиль пользователя

---

## Технологии

- **Frontend:** Nuxt 3, Vue 3, Element Plus
- **Backend:** Nuxt 3 Server API, MySQL
- **Maps:** Google Maps API (уже используется)
- **Markdown:** marked или similar library
- **Image Upload:** Cloudflare Images

---

## Scope изменений

### База данных

- Изменения в таблице `clinics` (created_by, is_draft, status)
- Новая таблица `clinic_services_custom` (кастомные услуги клиники)

### API Endpoints

- `POST /api/clinics/create` - создать клинику
- `PUT /api/clinics/[id]/update` - обновить клинику
- `GET /api/clinics/[id]/edit` - данные для редактирования
- `POST /api/clinics/[id]/services/add` - добавить услугу
- `DELETE /api/clinics/[id]/services/:serviceId` - удалить услугу
- `POST /api/clinics/[id]/doctors/add` - добавить врача
- `DELETE /api/clinics/[id]/doctors/:doctorId` - удалить врача
- `POST /api/clinics/[id]/publish` - опубликовать draft

### UI Компоненты

- `pages/profile/clinics/create.vue` - создание клиники
- `pages/profile/clinics/[id]/edit.vue` - редактирование
- `pages/profile/clinics/[id]/preview.vue` - предпросмотр
- `components/clinic/CreateForm.vue` - форма создания
- `components/clinic/EditForm.vue` - форма редактирования
- `components/clinic/ContentManager.vue` - управление контентом
- `components/clinic/MarkdownEditor.vue` - редактор описания
- `components/clinic/MapPicker.vue` - выбор координат на карте

---

---
