# Итерация 4: Auth, профиль, кабинет клиники

[← Все итерации](README.md) | [← Навигация](../index.md)

**Статус:** 🔴 Not Started
**Зависимости:** итерации 1–3

---

## Цель

Мигрировать всю авторизованную зону (`ssr: false`): auth-страницы, профиль
пользователя/врача, кабинет клиники с биллингом. Здесь сосредоточены формы и
диалоги; деньги (Stripe-чекаут) — повышенная аккуратность (риск R-3).

## Контур

- Auth: `pages/login*`, `pages/verify-email.vue`, `pages/reset-password.vue`, `pages/forgot-password.vue`, `pages/confirm-email-change.vue`, `components/login/*` (EmailLoginForm, RegisterForm, UserInfoCard), `confirm-provider.vue`
- Профиль: `pages/profile.vue`, `components/profile/*` (включая Edit*Dialog, ChangePasswordDialog, Doctor*/Clinic* формы, ClinicWorkingHoursEditor), `components/security/*`, `localized-field-editor.vue`
- Кабинет/биллинг: `pages/profile/clinics/**` (billing index/checkout/success/error), `components/billing/*` (service-card, purchase-history)

## Задачи

- [ ] `composables/use-form-errors.ts` + `AppFormField` — финализировать паттерн валидации (см. [архитектуру](../03-architecture.md)); правила переносятся из `:rules` el-form 1:1, тексты ошибок — из существующих i18n-ключей.
- [ ] `AppResult` (7 использований: success/error состояния auth-страниц).
- [ ] `AppSwitch` (профиль: публичность; Space/Enter, `role="switch"`).
- [ ] `AppTimeInput` на `<input type="time">` → переписать `profile/ClinicWorkingHoursEditor.vue` (admin-копия — в итерации 5).
- [ ] Диалоги: `EditNameDialog`, `EditEmailDialog`, `ChangePasswordDialog` уже используют контент-формы — пересадить с el-form/el-input на кит; сами диалоги уже на `AppDialog`/вёрстке — проверить и унифицировать.
- [ ] Auth-формы (login, register, forgot/reset): `AppForm`-паттерн + нативный submit по Enter; OAuth-кнопки не трогать (`OAuthIconButton` уже кастомный).
- [ ] Биллинг: `service-card.vue` (checkbox/radio-group → AppCheckbox/AppRadio), `purchase-history.vue` (radio-buttons → AppSegmented, тэги → AppTag), страницы checkout/success/error (alert/button → кит).
- [ ] Удалить локальные `--el-*`-переменные из 4 auth-страниц по мере миграции.

## Критерии приёмки

- **AC-1.** Grep-гейт контура → 0 вхождений EP.
- **AC-2.** Полный auth-цикл вручную: регистрация → письмо → verify → login → смена пароля → forgot/reset. Ошибки валидации показываются по blur/submit, `aria-invalid` + `aria-describedby` на месте.
- **AC-3.** Сабмит форм по Enter работает (login, register).
- **AC-4.** График работы клиники: выставление/правка интервалов на десктопе и мобильном, сохранение в том же формате HH:mm (данные в БД не меняются).
- **AC-5.** Биллинг-флоу до Stripe-редиректа и обратно (test mode): выбор услуг, чекаут, success/error-страницы; история покупок фильтруется.
- **AC-6.** typecheck + e2e зелёные.

## Проверка

1. e2e auth-сценарии + ручной чек-лист AC-2.
2. Профиль: редактирование имени/email (диалоги), врач/клиника формы, переключатели приватности.
3. Stripe test mode: полный круг покупки.
