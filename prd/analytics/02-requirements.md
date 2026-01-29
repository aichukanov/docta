# 2. Требования

## Функциональные требования

### F1: Базовая настройка и инициализация

**F1.1** Mixpanel SDK должен быть настроен как Nuxt plugin  
**F1.2** SDK инициализируется только на client-side  
**F1.3** Токен Mixpanel хранится в `.env` файле  
**F1.4** SDK инициализируется до первого взаимодействия пользователя

### F2: События просмотра страниц (Page Views)

**F2.1** Отслеживать просмотр страницы клиники

- Свойства: `clinic_id`, `clinic_name`, `city`, `is_verified`, `rating`, `reviews_count`

**F2.2** Отслеживать просмотр страницы врача

- Свойства: `doctor_id`, `doctor_name`, `specialization`, `clinic_id`, `experience_years`, `rating`

**F2.3** Отслеживать просмотр страницы услуги

- Свойства: `service_id`, `service_name`, `category`, `price_range`

**F2.4** Отслеживать просмотр страницы лекарства

- Свойства: `medicine_id`, `medicine_name`, `category`, `manufacturer`

**F2.5** Отслеживать просмотр статьи

- Свойства: `article_id`, `title`, `category`, `read_time`, `author`

**F2.6** Отслеживать просмотр списочных страниц

- Страницы: `/clinics`, `/doctors`, `/services`, `/medicines`, `/articles`
- Свойства: `page_type`, `filters_applied`, `sort_by`, `results_count`

### F3: События взаимодействия с контактами

**F3.1** Отслеживать копирование телефона

- Свойства: `entity_type` (clinic/doctor), `entity_id`, `phone_type` (main/mobile/reception)

**F3.2** Отслеживать копирование email

- Свойства: `entity_type`, `entity_id`

**F3.3** Отслеживать копирование адреса

- Свойства: `clinic_id`, `address_type` (full/street/city)

**F3.4** Отслеживать клик на телефон (tel: ссылка)

- Свойства: `entity_type`, `entity_id`, `phone_type`

**F3.5** Отслеживать клик на email (mailto: ссылка)

- Свойства: `entity_type`, `entity_id`

### F4: События навигации и переходов

**F4.1** Отслеживать переход на сайт клиники

- Свойства: `clinic_id`, `source_page` (clinic_page/service_page/doctor_page)

**F4.2** Отслеживать переход с услуги на клинику

- Свойства: `service_id`, `clinic_id`, `position_in_list`

**F4.3** Отслеживать переход с врача на клинику

- Свойства: `doctor_id`, `clinic_id`

**F4.4** Отслеживать переход с клиники на врача

- Свойства: `clinic_id`, `doctor_id`, `position_in_list`

**F4.5** Отслеживать клик на карточку в списках

- Свойства: `item_type`, `item_id`, `position`, `list_type`, `total_items`

### F5: События поиска и фильтрации

**F5.1** Отслеживать поисковой запрос

- Свойства: `query`, `search_type` (clinics/doctors/services/all), `results_count`, `results_found`

**F5.2** Отслеживать применение фильтров

- Свойства: `page_type`, `filter_type`, `filter_value`, `results_count`

**F5.3** Отслеживать сброс фильтров

- Свойства: `page_type`, `filters_count`

**F5.4** Отслеживать изменение сортировки

- Свойства: `page_type`, `sort_by`, `sort_order`

**F5.5** Отслеживать клик на тег/категорию

- Свойства: `tag_name`, `tag_type`, `source_page`

### F6: События взаимодействия с картой

**F6.1** Отслеживать открытие карты

- Свойства: `page_type`, `items_on_map`

**F6.2** Отслеживать клик на маркер на карте

- Свойства: `entity_type`, `entity_id`, `map_view` (list_mode/full_screen)

**F6.3** Отслеживать изменение области карты

- Свойства: `zoom_level`, `center_coords`, `visible_items`

### F7: События социальных действий

**F7.1** Отслеживать добавление в избранное

- Свойства: `entity_type`, `entity_id`, `source_page`

**F7.2** Отслеживать удаление из избранного

- Свойства: `entity_type`, `entity_id`

**F7.3** Отслеживать расшаривание

- Свойства: `entity_type`, `entity_id`, `share_method` (link/telegram/facebook/etc)

**F7.4** Отслеживать начало написания отзыва

- Свойства: `entity_type`, `entity_id`

**F7.5** Отслеживать отправку отзыва

- Свойства: `entity_type`, `entity_id`, `rating`, `has_text`, `text_length`

### F8: События рабочего времени

**F8.1** Отслеживать клик "Открыто сейчас" / "Закрыто"

- Свойства: `clinic_id`, `current_status`, `next_opening_time`

**F8.2** Отслеживать раскрытие полного расписания

- Свойства: `clinic_id`

### F9: Профили пользователей (User Identification)

**F9.1** При авторизации связывать анонимную сессию с user ID

- Метод: `mixpanel.identify(userId)`

**F9.2** Устанавливать профильные свойства пользователя

- Свойства: `$name`, `$email`, `role` (patient/clinic_owner/doctor), `created_at`, `city`

**F9.3** Обновлять профиль при изменении данных

- События: смена города, обновление профиля

**F9.4** Инкрементировать счетчики действий

- Счетчики: `total_clinics_viewed`, `total_reviews_written`, `favorites_count`

### F10: Super Properties (глобальные свойства)

**F10.1** Регистрировать глобальные свойства при инициализации

- Свойства: `platform` (web/mobile_web), `environment` (production/staging), `app_version`

**F10.2** Добавлять к каждому событию

- Свойства: `$current_url`, `$referrer`, `user_role`, `is_authenticated`, `user_city`

### F11: Воронки конверсии (для настройки в Mixpanel UI)

**F11.1** Воронка "Поиск клиники → Просмотр → Контакт"

- События: `Search Performed` → `Clinic Viewed` → `Phone Clicked` | `Website Visited` | `Email Clicked`

**F11.2** Воронка "Услуга → Клиника → Контакт"

- События: `Service Viewed` → `Clinic Viewed from Service` → `Phone Clicked` | `Website Visited`

**F11.3** Воронка "Врач → Клиника → Контакт"

- События: `Doctor Viewed` → `Clinic Viewed from Doctor` → `Phone Clicked` | `Website Visited`

**F11.4** Воронка "Просмотр → Избранное → Возврат"

- События: `Entity Viewed` → `Added to Favorites` → `Returned from Favorites`

## Нефункциональные требования

### NFR1: Performance

**NFR1.1** Analytics не должна блокировать рендеринг страницы  
**NFR1.2** Все события отправляются асинхронно  
**NFR1.3** Batch-отправка событий (если поддерживается SDK)  
**NFR1.4** Performance impact < 50ms на page load  
**NFR1.5** SDK загружается асинхронно с низким приоритетом

### NFR2: Privacy и Security

**NFR2.1** Cookie consent обязателен перед инициализацией трэкинга  
**NFR2.2** PII (Personally Identifiable Information) не отправляется в clear text  
**NFR2.3** Email и телефоны хешируются перед отправкой (если необходимо)  
**NFR2.4** Возможность opt-out из трэкинга (в настройках профиля)  
**NFR2.5** GDPR compliance - право на удаление данных

### NFR3: Reliability

**NFR3.1** Ошибки аналитики не ломают основной функционал  
**NFR3.2** Try-catch вокруг всех вызовов analytics  
**NFR3.3** Graceful degradation если Mixpanel не загрузился  
**NFR3.4** Retry mechanism для failed events

### NFR4: Maintainability

**NFR4.1** Type-safe event tracking (TypeScript interfaces)  
**NFR4.2** Centralized event naming conventions  
**NFR4.3** Документация всех событий и их свойств  
**NFR4.4** Легко добавлять новые события  
**NFR4.5** Consistent naming: `Entity Action` (e.g., "Clinic Viewed", "Phone Clicked")

### NFR5: Testability

**NFR5.1** Возможность отключить analytics в dev режиме  
**NFR5.2** Debug mode для проверки отправленных событий  
**NFR5.3** Mock analytics в unit тестах  
**NFR5.4** E2E тесты не отправляют события в production Mixpanel

### NFR6: Monitoring

**NFR6.1** Логирование критичных ошибок аналитики  
**NFR6.2** Alerting если event success rate < 95%  
**NFR6.3** Dashboard для мониторинга качества данных

## Приоритизация требований

### Must Have (P0)

- F1: Базовая настройка
- F2: События просмотра страниц (клиники, врачи, услуги)
- F3: События контактов (телефон, website)
- F4: События навигации (базовые переходы)
- F9: User identification
- F10: Super properties
- NFR2: Privacy compliance

### Should Have (P1)

- F5: События поиска и фильтрации
- F6: События карты (базовые)
- F7: Социальные действия (избранное)
- F8: Рабочее время
- F11: Настройка воронок

### Nice to Have (P2)

- F7.3-F7.5: Расширенные социальные действия (share, reviews)
- F6.3: Продвинутые события карты
- NFR6: Advanced monitoring
