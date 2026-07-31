# runtimeConfig и переменные окружения в проде

## Главное правило

**Прод не читает `.env`.** Значения `runtimeConfig` из `nuxt.config.ts` вычисляются
на этапе `nuxt build` и вшиваются в `.output/server/chunks/nitro/nitro.mjs`.
В рантайме Nitro перекрывает их только переменными с префиксом `NUXT_`.

```
nuxt.config.ts        runtimeConfig.telegramBotToken = process.env.TELEGRAM_BOT_TOKEN
   ↓ build            вшивается в .output значение с машины, где делали билд
   ↓ runtime          перекрывается ТОЛЬКО переменной NUXT_TELEGRAM_BOT_TOKEN
```

Имя переменной = `NUXT_` + ключ `runtimeConfig` в SCREAMING_SNAKE:
`telegramBotToken` → `NUXT_TELEGRAM_BOT_TOKEN`,
`public.telegramBotId` → `NUXT_PUBLIC_TELEGRAM_BOT_ID`.

## Из этого следует

Схема рабочая, пока сборка идёт **на сервере из того же `.env`**, из которого потом
стартует приложение. Ловушка в асимметрии: `ecosystem.config.cjs` передаёт в рантайм
только `NUXT_DB_*`, `NUXT_PUBLIC_TELEGRAM_BOT_ID` и `NUXT_PUBLIC_MIXPANEL_TOKEN`.

- Правка `DB_*` или `TELEGRAM_BOT_TOKEN` в `.env` подхватится **рестартом**
  (`pm2 restart ecosystem.config.cjs --update-env`) — но только в этих ключах,
  и в случае токена — только его публичная часть `bot_id`.
- Правка любого другого ключа (`BASE_URL`, mailgun, google, stripe, uploads,
  **сам bot token**) требует **пересборки**: `npm run build`. Один рестарт ничего
  не изменит, а расхождения никто не заметит.

Самая опасная пара — `telegramBotToken` и `public.telegramBotId`: bot_id виджета
перекрывается в рантайме, а токен для проверки подписи — нет. Если бы они разъехались
(смена бота, ротация токена без пересборки), пользователь авторизовался бы у одного
бота, а сервер проверял подпись токеном другого. Симптом коварный: Telegram
авторизацию подтверждает и бот пишет пользователю «вы вошли», а сайт молча
редиректит на `/login`.

Страховка: `server/plugins/oauth-config-check.ts` сверяет на старте `bot_id` из токена
с публичным `bot_id` и пишет в лог ошибку при расхождении.

Проверено 2026-07-30 при разборе жалоб на вход через Telegram: расхождения на проде
не было — в бандле вшит тот же бот, что и в `.env`. Реальной причиной оказался
popup-поток виджета, см. `composables/use-telegram-auth.ts`.

## Диагностика

```bash
# что реально вшито в собранный бандл (bot_id — публичная часть токена)
grep -ohE 'telegramBot(Token"?:\s*"[0-9]+|Id"?:\s*"[0-9]*")' \
  .output/server/chunks/nitro/nitro.mjs

# что реально видит процесс
pm2 describe docta | grep -i telegram

# ошибки конфигурации и авторизации
pm2 logs docta --lines 200 --nostream | grep -iE "misconfigured|telegram"
```

Связано: [BASE_URL_CONFIG.md](BASE_URL_CONFIG.md).
