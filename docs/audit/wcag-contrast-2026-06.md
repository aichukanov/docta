# Аудит контраста WCAG 2.1 AA — июнь 2026

**Дата:** 2026-06-10. **Объём:** `components/**`, `pages/**`, `layouts/**`, `app.vue`, `assets/css/design-tokens.css` (включая мост Element Plus). Тёмной темы нет, фон по умолчанию — белый (`body` → `--color-bg-primary: #ffffff`, base 16px).

> **Статус фиксов (2026-06-10):** топ-3 применены — группа 1 закрыта (18 мест light/tertiary → muted; `clinic/logo.vue:86` намеренно оставлен, см. ручную проверку п. 5), группа 2 закрыта (`--el-text-color-placeholder` → muted), группа 4 закрыта (метки; warning-рамки остались), группа 6 закрыта (success-dark → primary-green, 6 мест), группа 7 закрыта частично (3 текстовых места → danger-dark; white-on-danger кнопки EP и confirm-dialog — не тронуты); группа 3 закрыта — без обводки, затемнением цветов: `--color-rating` #ffc107 → #d17d00 (оранжево-янтарный, 3.16:1 на белом, 3.02:1 на bg-secondary; выбран вручную из hue-развёртки по живому превью), пустые звёзды border-primary → text-muted (4.76:1). На bg-tertiary заполненные дают 2.88:1 — звёзды на таком фоне не размещать.
>
> **Вторая волна фиксов (2026-06-10), все подтверждённые группы закрыты:** гр. 8 — серые хардкоды → muted (login.vue ×2, UserInfoCard, admin/index, lab-test/info — там убран лишний оверрайд); гр. 10 — Rx-бейдж #e65100 → #ba5000 (4.52:1 на #fff3e0, тот же оттенок); гр. 12 — muted → secondary (hero главной, clinics-section empty, profile «скоро»); гр. 5 — cookie-бейдж переведён на success-bg + primary-green (7.68:1) по образцу остальных бейджей, иконки approved/copy/translation-dot → success-dark (3.77 ≥ 3); гр. 9 — hover контактных кнопок → primary-bg (5.58:1); гр. 7 добита — confirm-dialog danger → danger-dark (8.31, hover через opacity .85 ≈ 6:1), для `el-button--danger` добавлен оверрайд в design-tokens.css (фон danger-dark, hover #b91c1c 6.47, active #7f1d1d 10.0; plain/text/link не тронуты); гр. 11 — градиент bento-карточки → var(primary)→var(primary-dark), desc rgba(255,255,255,.85) оставлен (5.0:1 в худшей точке). Осталась только секция «требует ручной проверки» (el-tag light-9, рамки инпутов EP, декоративные иконки).
>
> **Итог (2026-06-10): аудит закрыт.** Все 12 подтверждённых групп исправлены. Пункты секции «требует ручной проверки» **отложены сознательно** (решение владельца, не недоделка): п. 1 el-tag — при возврате начать с проверки фактических `--el-color-*-light-9` в devtools и, если подтвердится, добавить их в EP-мост; п. 2 рамки инпутов — дизайн-решение, затронет вид всех форм (нужен токен границы уровня ≈#8b919c); пп. 3–5 (иконки bento, стрелка, фолбэк логотипа) признаны декоративными — фикс не требуется. При появлении тёмной темы или новых тонированных фонов аудит повторить: запас у `--color-rating` (#d17d00) и muted-текста минимальный.

**Методика.** Все коэффициенты посчитаны по формуле относительной яркости WCAG (node-скрипт). rgba-цвета приведены к непрозрачным альфа-композицией поверх фактического фона. Текст на градиентах считался по худшей точке. Фон каждого элемента определялся трассировкой контейнеров вверх по шаблону; эвристические допущения помечены. Нормы: обычный текст ≥ 4.5:1; крупный (≥ 24px, или ≥ 18.66px bold) ≥ 3:1; нетекстовые носители смысла (1.4.11) ≥ 3:1. Disabled — исключение; placeholder — нет.

**Намеренные исключения (не флагуются):** фирменные цвета OAuth/Google (`icon/google.vue`, `icon/google-maps.vue`), мессенджеров (`#25d366` WhatsApp, `#7360f2` Viber, `#0088cc`/`#54a9eb` Telegram, `#1877F2` Facebook — `contacts/phone-group-line.vue`, `profile/tab/basic.vue`), `theme-color` в `app.vue`, скелетоны (`skeleton-card.vue`), `pages/dev/email-preview.vue` (dev-страница; её цвета #666/#555 проходят).

---

## Подтверждённые провалы

Отсортированы по серьёзности = дефицит контраста × распространённость.

### 1. `--color-text-light` / `--color-text-tertiary` (#94a3b8) как цвет текста на светлых фонах

**2.56:1 на белом, 2.45:1 на #f8fafc — требуется 4.5:1** (для иконок и 32px-крестика — 3:1, тоже провал). Это один цвет: `tertiary = var(light)`. Проваливает AA для текста **любого** размера — даже large text (3:1) не проходит. Главная группа аудита.

Размеры в местах использования: 12–14px, есть 20–32px (тоже < 3:1).

| Место | Контекст | Фон | Размер |
|---|---|---|---|
| `layouts/default.vue:431` | `.footer-brand__partner` | градиент #fff→#f8fafc (низ футера, худшая точка 2.45) | 14px |
| `layouts/default.vue:446` | `.footer-brand__partner-note` | то же | 14px |
| `layouts/default.vue:455` | `.footer-partner` (моб.) | то же | 14px |
| `layouts/default.vue:469` | `.footer-partner__note` (моб.) | то же | 14px |
| `layouts/default.vue:568` | `.footer-bottom__muted` (копирайт/дисклеймер) | то же | 14px |
| `layouts/default.vue:577` | `.footer-bottom__cookie-link` (кнопка «настройки cookie») | то же | 14px |
| `pages/privacy.vue:223` | `.privacy-page__updated` | белый | 14px |
| `pages/medicines/[medicineSlug]/index.vue:469` | `.detail-label` | белый | 14px |
| `pages/medicines/[medicineSlug]/index.vue:584` | `.source-updated` | #f8fafc | 12px |
| `pages/medicines/index.vue:335` | `.medicine-card-meta` | белый | 12px |
| `components/security/SessionsSection.vue:313` | `.session-card__meta` | белый / #f0fdf4 (текущая сессия, 2.45) | 12px |
| `components/security/LoginHistorySection.vue:292` | `.history-row__time` | белый | 12px |
| `components/security/LoginHistorySection.vue:357` | `.full-history__ua` | белый | 12px |
| `components/profile/DoctorEditForm.vue:411` | `.edit-form__markdown-hint` | белый | 12px |
| `components/profile/AccountCard.vue:175` | `.account-card__status--off` («не подключено» — статус, не disabled) | белый | 14px / 500 |
| `components/cookie-modal.vue:192` | `.cookie-modal__close` (крестик «×») | белый | 32px, нетекст → 3:1, всё равно 2.56 |
| `components/global-search.vue:640` | `.global-search__input::placeholder` | белый | 22px (не large при w400) |
| `components/global-search.vue` (блок `__icon`, hardcode `#94a3b8`) | иконка поиска в инпуте | белый | иконка → 3:1 |

Справочно: `.analog-meta` там же в medicines уже переведён на muted — образец фикса.

**Рекомендация:** `--color-text-muted` (#64748b) — ближайший проходящий токен: 4.76 на белом, 4.55 на #f8fafc. Для крестика cookie-modal подойдёт и muted (4.76), и `--color-text-secondary`. Сам токен `--color-text-light` после замен останется только для декоративных применений.

### 2. Плейсхолдеры Element Plus — токен моста

**`assets/css/design-tokens.css:148`**: `--el-text-color-placeholder: var(--color-text-light)` → **#94a3b8 на белом инпуте = 2.56:1 vs 4.5:1** (14px). Placeholder — не исключение по WCAG.

Затрагивает все формы проекта: ~35 файлов с `el-input`/`el-select` и placeholder'ами — все фильтры (`components/filter/*` — 12 файлов), `global-search`, формы логина/регистрации (`login/EmailLoginForm`, `login/RegisterForm`), восстановление пароля (`pages/forgot-password`, `pages/reset-password`), профиль (`EditEmailDialog`, `EditNameDialog`, `ChangePasswordDialog`), отзывы (`review/form`), вся админка (`admin/clinic-add`, `doctor-add`, `labtest-add`, `service-add`, `editable-field`, `user-info`), фильтры списков (`pages/services/index`, `clinic/items-page` и др.).

**Рекомендация:** `--el-text-color-placeholder: var(--color-text-muted)` — одна строка, чинит все формы разом. Кастомных `::placeholder`-правил в репо нет (проверено), конфликтов не будет.

### 3. Звёзды рейтинга #ffc107 на белом

**1.63:1 — требуется 3:1 (1.4.11, нетекстовый носитель смысла).** Самый большой дефицит в проекте. Незаполненные звёзды `--color-border-primary` #d1d5db на белом = **1.47:1** — состояние «пусто» того же индикатора тоже не читается. Различие заполненная/пустая передаётся только цветом.

| Место | Контекст |
|---|---|
| `components/rating-stars.vue:67` | `.star.filled` (#ffc107, белый фон) |
| `components/rating-stars.vue:82` | `.star.half::after` |
| `components/rating-stars.vue:60` | `.star` (незаполненная, #d1d5db) |
| `components/review/rating-input.vue:49` | `.star-btn.active` (24px, интерактивный ввод оценки) |
| `components/review/rating-input.vue:31` | `.star-btn` (незаполненная, #d1d5db) |

**Рекомендация:** проходящего жёлтого в палитре нет (`--color-accent` #f59e0b = 2.15). Варианты: (а) 1px-обводка звёзд тёмным (например #b45309 ≈ 4.5 на белом — новый токен `--color-rating-border`, существующие не подходят: `warning-dark` #92400e визуально коричневый, но формально 7.09 ✓); (б) различать заполненные/пустые формой (контур vs заливка), что заодно снимает зависимость от цвета. Рядом со звёздами уже есть числовое значение (`rating-stars.vue` `.rating-value`) — это смягчает, но не отменяет 1.4.11 для самого индикатора.

### 4. `--color-warning` #f59e0b как цвет текста на белом (метки «изменено» в админке)

**2.15:1 — требуется 4.5:1.** 14px / 500.

| Место | Контекст |
|---|---|
| `components/admin/service-info.vue:450` | `.sort-order-section.modified label` |
| `components/admin/labtest-info.vue:482` | `.field.modified label` |
| `components/admin/slug-field.vue:83` | `.field.modified label` |
| `components/admin/editable-field.vue:174` | `.field.modified label` |

Там же warning используется как **рамка** изменённых полей (`doctor-info.vue:689,737,761`, `service-info.vue:477,501`, `labtest-info.vue:508,558`, `review-info.vue:555`, `clinic-find.vue:902`) — 2.15 < 3:1 по 1.4.11, рамка является носителем состояния «изменено», но дублируется цветом метки → чинится тем же фиксом.

**Рекомендация:** `--color-warning-dark` #92400e (7.09 на белом). Админка — низкий приоритет по охвату пользователей, но фикс тривиален.

### 5. `--color-success` #10b981: белый текст на нём и иконки-носители смысла

**Белый на success = 2.54:1 (текст, нужно 4.5); success на белом = 2.54:1 (иконки, нужно 3:1).**

| Место | Контекст | Норма |
|---|---|---|
| `components/cookie-modal.vue:261` | `.cookie-status-badge` — белый текст 12px/500 на #10b981 («всегда активны») | 4.5 → факт 2.54 |
| `components/clinic/approved-badge.vue:68` | галочка «клиника подтверждена» на белом/#f8fafc | 3 → 2.54 |
| `components/contacts/copy-button.vue:14` | иконка успешного копирования (inline `color="var(--color-success)"`) | 3 → 2.54 |
| `components/localized-field-editor.vue:128` | точка-индикатор «перевод заполнен» (6px, фон точки = success на белом табе) | 3 → 2.54 |

**Рекомендация:** для иконок — `--color-success-dark` #059669 (3.77 ≥ 3 ✓). Для текста на зелёном бейдже cookie-modal зелёного с 4.5 для белого текста в палитре нет; ближайшее — `--color-primary-green` #0e5d14 как фон (белый на нём 8.09) либо инверсия: `success-dark` текст на `success-bg` — но это 3.58, тоже мало (см. группу 6); надёжный вариант из палитры — текст `--color-primary-green` на `--color-success-bg` (7.68).

### 6. `--color-success-dark` #059669 как цвет мелкого текста

**3.58:1 на #ecfdf5, 3.77:1 на белом, 2.94:1 на #a7f3d0 — требуется 4.5:1** (размеры 11–17px, не large).

| Место | Контекст | Фон | Факт |
|---|---|---|---|
| `components/profile/DoctorStatusBlock.vue:135` | бейдж «опубликован», 14px/600 uppercase | `success-border` #a7f3d0 | **2.94** |
| `pages/profile.vue:434` | `.profile-hero__badge--user`, 11px/600 | `success-bg` #ecfdf5 | 3.58 |
| `components/profile/AccountCard.vue:220` | `.account-card__verified-badge`, 12px | `success-bg` | 3.58 |
| `components/security/SessionsSection.vue:303` | `.session-card__current-tag`, 11px/600 | `success-bg` | 3.58 |
| `components/profile/AccountCard.vue:171` | `.account-card__status--on`, 14px/500 | белый | 3.77 |
| `components/clinic/working-status-badge.vue:85` | `.status-badge--open` «открыто», 17px/500 | белый (допущение: hero/карточка клиники — белые) | 3.77 |

Точка-индикатор в `working-status-badge` (`currentColor`, 10px) — нетекст, 3.77 ≥ 3 ✓.

**Рекомендация:** `--color-primary-green` #0e5d14 — единственный зелёный в палитре, проходящий для мелкого текста: 8.09 на белом, 7.68 на success-bg, ~6 на success-border. Семантически тот же «зелёный статус». Альтернатива — новый токен `--color-success-text` (например #047857 = 4.5+ на белом, но на success-bg всё ещё мало → green надёжнее).

### 7. `--color-danger` #ef4444 как цвет текста и белый текст на danger

**3.76:1 на белом, 3.44:1 на #fef2f2 — требуется 4.5:1.**

Текст danger-цветом:

| Место | Контекст | Фон | Факт |
|---|---|---|---|
| `components/clinic/working-status-badge.vue:80` | `.status-badge` «закрыто», 17px/500 | белый (допущение как в гр. 6) | 3.76 |
| `components/admin/doctor-info.vue:747` | `.hidden-hint`, 13.6px | `danger-bg` #fef2f2 | 3.44 |
| `pages/profile.vue:440` | `.profile-hero__badge--admin`, 11px/600 | `danger-bg` | 3.44 |

Белый текст на danger-фоне (14–16px, не large → 4.5, факт 3.76):

- `components/confirm-dialog.vue:81` — `.confirm-btn.danger` (16px/500, кнопки подтверждения удаления);
- `el-button type="danger"` (белый на #ef4444, 14px): `admin/service-info.vue:418`, `admin/service-add.vue:220`, `admin/labtest-info.vue:450`, `admin/labtest-add.vue:155`, `admin/review-info.vue:499`, `admin/doctor-info.vue:658`, `admin/doctor-add.vue:277`, `admin/clinic-find.vue:821`, `pages/admin/index.vue:266`, `components/security/SessionsSection.vue` (кнопка «завершить сессию», если type=danger).

Иконки на danger проходят 3:1: `DoctorCard.vue:287`, `DoctorEditForm.vue:340`, `profile.vue:393` (аватар-кнопки удаления, 3.76 ≥ 3 ✓).

**Рекомендация:** для текста — `--color-danger-dark` #991b1b (8.31 на белом, 7.60 на danger-bg; образец уже есть: `admin/clinic-find.vue:931` сделан правильно). Для кнопок — фон `danger-dark` под белый текст (8.31) или, для EP, переопределить `--el-color-danger-dark-2`; админ-кнопки — низкий приоритет.

### 8. Хардкод-серые ниже нормы

| Место | Цвет | Фон | Факт | Размер |
|---|---|---|---|---|
| `components/lab-test/info.vue:116` | `#9ca3af` (`.synonyms-label`) | белый | **2.54** | 14px |
| `pages/login.vue:231` | `#95a5a6` (текст разделителя «или») | белая карточка | **2.56** | 14px |
| `pages/login.vue:212` | `#7f8c8d` (`.login-subtitle`) | белая карточка | 3.48 | 16px |
| `components/login/UserInfoCard.vue:98` | `#7f8c8d` (`.user-details p`) | белый | 3.48 | 14px |
| `pages/admin/index.vue:473` | `#7f8c8d` (`.user-email`) | белый | 3.48 | 14px |

**Рекомендация:** `--color-text-muted` (4.76). Заодно убирает хардкоды (страницы логина — видимо, старый код до токенов; рядом `#2c3e50` 10.98 ✓ — тоже стоит токенизировать в `text-heading`, но это не контраст-баг).

### 9. Hover контактных кнопок: primary на primary-light

`components/contacts/phone-group-line.vue:114-116` — `.channel-btn:hover`: текст `--color-primary` #4f46e5 на фоне `--color-primary-light` #a5b4fc = **3.15:1 vs 4.5:1** (14px). Hover-состояние — тоже подлежит норме.

**Рекомендация:** фон `--color-primary-bg` (rgba(79,70,229,.08) → #f1f0fd поверх белого): primary на нём = 5.58 ✓ — так уже сделано в `category-tag.vue` и `owner-banner.vue`.

### 10. Бейдж рецептурного отпуска Rx

`components/medicine-badge.vue:41` — `.medicine-badge--rx`: `#e65100` на `#fff3e0` = **3.46:1 vs 4.5:1** (14px/500). Остальные бейджи проходят: otc `#2e7d32`/`#e8f5e9` = 4.56 ✓ (впритык), restricted 7.75 ✓, hospital 6.92 ✓.

**Рекомендация:** затемнить до ~`#bf360c`-класса; из палитры подходит `--color-warning-dark` #92400e (≈6.8 на #fff3e0), если допустим менее «оранжевый» оттенок. Иначе — новый локальный цвет ≥ 4.5.

### 11. Главная: подзаголовок описания на градиентной карточке

`pages/index.vue:451-452` — `.bento__card--primary .bento__desc`: `rgba(255,255,255,0.85)` на градиенте `#4f46e5→#6366f1` = **3.70:1 в худшей точке (#6366f1) vs 4.5:1** (14px). Даже чистый белый на #6366f1 = 4.47 — на грани провала. Заголовок карточки (24px, white) — large text, 4.47 ≥ 3 ✓.

**Рекомендация:** убрать прозрачность 0.85 **и** закончить градиент на `--color-primary` (#4f46e5: белый = 6.29) или `primary→primary-dark`; либо поднять desc до large (≥18.66px bold).

### 12. Muted #64748b на тонированных фонах — на грани, но ниже нормы

**4.33–4.34:1 vs 4.5:1.** Малый дефицит, фоны определены точно (заданы в тех же компонентах).

| Место | Контекст | Фон | Факт |
|---|---|---|---|
| `pages/index.vue:354` | `.hero__subtitle` (16–18px) | градиент страницы `#fafbff→#f0f4ff` (строка 330), худшая точка #f0f4ff | 4.33 |
| `components/entity-page/clinics-section.vue:96` | `.clinics-section__empty` (16px) | `bg-tertiary` #f1f5f9 | 4.34 |
| `pages/profile.vue:576` | `.profile-nav__soon` (10px/600) | `bg-tertiary` | 4.34 |

**Рекомендация:** `--color-text-secondary` #475569 (6.92 на bg-tertiary, 6.5+ на #f0f4ff). Правило на будущее: muted безопасен только на белом/`bg-secondary` (4.76/4.55), на `bg-tertiary`/`bg-muted`/`primary-bg` — уже нет (4.34/3.86/4.22).

---

## Требует ручной проверки

Спорные кейсы: эвристический фон, неопределённые дефолты EP или декоративность под вопросом. Не смешивать с подтверждёнными.

1. **Дефолтные `el-tag` (light-вариант).** `login/UserInfoCard.vue` (type danger/success), `admin/clinic-find.vue`, `admin/doctor-info.vue`, `admin/user-info.vue`, `clinic/items-page-header.vue`. Мост переопределяет `--el-color-success/danger`, но **не** их `light-9`-фоны → текст #10b981 на ~#f0f9eb ≈ **2.3–2.4**, #ef4444 на ~#fef0f0 ≈ **3.3** (оценка по EP-дефолтам, зависит от версии EP). Если подтверждается — добавить в мост `--el-color-success-light-9`/`-danger-light-9` потемнее текстовых вариантов или использовать `effect="dark"`.
2. **Рамки инпутов EP**: `--el-border-color: var(--color-border-primary)` #d1d5db на белом = **1.47 vs 3:1** (1.4.11). Обязательность рамки как «носителя идентификации компонента» — предмет интерпретации (есть label/placeholder), но у дефолтного EP тот же известный недостаток. Если чинить — `--color-border-primary` нужен уровня `#949ba5`+ (в палитре кандидата нет; ближайший по духу — поднять до ~#9ca3af, всё ещё 2.54 — т.е. нужен новый, например #8b919c ≥ 3).
3. **Иконки bento-карточек главной** (`pages/index.vue:474` — #16a34a на мятном градиенте ≈ 2.69; `:433-435` — белая иконка на rgba(255,255,255,.2) поверх градиента ≈ 3.1): рядом всегда есть текстовый заголовок → вероятно, декоративные; формально по 1.4.11 зелёная не проходит.
4. **Стрелка bento-карточки** `pages/index.vue:529` (#94a3b8, 20px) — появляется только на hover, вся карточка — ссылка; индикатор избыточен → скорее декорация.
5. **Фолбэк логотипа клиники** `components/clinic/logo.vue:86` (tertiary-иконка, 2.56) — плейсхолдер отсутствующего изображения; есть alt/название клиники рядом → вероятно, допустимо.
6. **`working-status-badge` фон** — в группах 6–7 принят белым (используется в hero клиники и `summary-header`, обе поверхности белые). Если появится использование на тонированном фоне — дефицит вырастет.

---

## Проверенные зоны риска — проходят

- **Белый на primary** #4f46e5 = 6.29 ✓: кнопка логина (`app-header.vue:390`), `confirm-btn.primary`, `el-button type="primary"` (~25 мест), маркер карты (`map/marker.vue`), активный таб (`localized-field-editor.vue`), прайс-бейджи (`priced-item-card.vue`, `clinic/summary-header.vue:219`), hover `view-all-clinics`.
- **Primary-ссылки** на белом/`bg-secondary` = 6.29/6.01 ✓ (list-card, cookie-banner, global-search «ещё», breadcrumbs hover, footer hover и т.д.); hover `primary-dark` = 9.93 ✓.
- **Тёмные бейджи на своих фонах**: `danger-dark` на `danger-bg` = 7.60 ✓ (`admin/clinic-find.vue:931`), `warning-dark` на `warning-bg` = 6.84 ✓ (`:935`), draft-бейдж `warning-dark` на `#fde68a` = 5.69 ✓, hidden-бейдж `danger-dark` на `#fecaca` = 5.74 ✓ (`DoctorStatusBlock`).
- **category-tag / own-badge / owner-banner**: primary на `primary-bg` (#f1f0fd) = 5.58 ✓ (включая 12px-вариант).
- **Auth-градиент** `#667eea→#764ba2` (`layouts/minimal.vue`, verify-email): текст лежит только на белой карточке; прямо на градиенте текста нет ✓ (белый на худшей точке #667eea был бы 3.66 — учитывать при будущих правках).
- **Бейджи лекарств** (medicines detail): active `#1565c0`/`#e3f2fd` = 5.03 ✓, expired 4.67 ✓, substance-tag 6.22 ✓.
- **Tips-блок**: текст на градиенте `--color-bg-tips` (худшая точка ≈ #f8f7fe): text-primary ≈ 12 ✓, ссылки primary 5.91 ✓.
- **Хардкоды статей/списков**: `#1f2937` 14.68, `#111827` 17.74, `#4b5563` 7.56, `#6b7280` 4.83 (впритык), `#606266` 6.11, `#2c3e50` 10.98 — все ✓ (рекомендуется токенизация, но не по контрасту).
- **Cookie-banner**: accept-кнопка белый на #0f172a = 17.85 ✓; decline muted на белом 4.76 ✓.
- **Заголовки/основной текст**: heading 17.85, text-primary 12.63, secondary 7.58, muted на белом 4.76 — ✓ на всех светлых фонах вплоть до `bg-muted` (secondary 6.15 ✓; muted на `bg-muted` 3.86 — мест использования не найдено).
- **Opacity-кейсы**: `doctor/info.vue:154` secondary при opacity .85 → 5.10 ✓; разделитель breadcrumbs (muted, opacity .5) — декоративный, исключён.
- **Фокус-индикаторы**: outline `--color-primary` на белом = 6.29 ≥ 3 ✓ (`list-card`, EP-дефолты через мост).

---

## Сводка

- **Проверено:** ~60 уникальных пар «цвет текста/иконки × фактический фон» (502 объявления `color:` в 151 файле + токены EP-моста).
- **Прошло:** ~39 пар.
- **Провалено:** 21 пара, сгруппированы в 12 групп, ≈ 60 конкретных мест в коде + ~35 форм, затронутых одним токеном плейсхолдера.
- **Ручная проверка:** 6 кейсов (el-tag дефолты, рамки инпутов, декоративные иконки главной, фолбэк логотипа, допущение о фоне статус-бейджа).

### Топ-3 фикса по соотношению «эффект / трудозатраты»

1. **`design-tokens.css:148`: `--el-text-color-placeholder: var(--color-text-muted)`** — одна строка чинит плейсхолдеры во всех ~35 формах и фильтрах (2.56 → 4.76).
2. **Замена `--color-text-light`/`--color-text-tertiary` → `--color-text-muted` в 18 текстовых местах** (группа 1: футер ×6, security ×3, medicines ×3, privacy, AccountCard, DoctorEditForm, cookie-modal, global-search ×2) — механическая замена, закрывает самую массовую группу; light остаётся только для декора.
3. **Статусные бейджи/чипы**: `success-dark` → `--color-primary-green` (6 мест, гр. 6), `danger` → `--color-danger-dark` (3 места, гр. 7-текст), `warning` → `--color-warning-dark` (4 места, гр. 4) — ~13 однотипных замен внутри существующей палитры, закрывают все «цветные» провалы статусов.

Отдельно стоит запланировать: звёзды рейтинга (гр. 3 — нужен дизайн-вариант: обводка или форма) и danger-кнопки EP в админке (гр. 7 — массовая, но низкоприоритетная).
