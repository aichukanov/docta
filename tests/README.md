# E2E тесты для docta.me

Автоматические E2E тесты на Playwright для проверки основной функциональности сайта docta.me.

## Установка

```bash
# Установить зависимости
npm install

# Установить браузеры Playwright
npx playwright install
```

## Запуск тестов

### Локальное окружение

```bash
# Запустить dev сервер (в отдельном терминале)
npm run dev

# Запустить все тесты
npm run test:e2e

# Запустить конкретный тест
npm run test:e2e -- clinics.spec.ts
```

### Продакшн окружение

```bash
# Запустить все тесты на проде
npm run test:e2e:prod

# Запустить конкретный тест на проде
E2E_BASE_URL=https://docta.me npm run test:e2e -- home.spec.ts
```

## Отчеты

```bash
# Посмотреть HTML отчет
npm run test:e2e:report
```

Отчеты сохраняются в:

- `playwright-report/` - HTML отчет
- `test-results/` - скриншоты, видео, трейсы

## Структура тестов

```
tests/
├── e2e/              # Тесты
│   ├── home.spec.ts
│   ├── navigation.spec.ts
│   ├── clinics.spec.ts
│   ├── doctors.spec.ts
│   ├── services.spec.ts
│   ├── medications.spec.ts
│   └── articles.spec.ts
│
├── pages/            # Page Object Model
│   ├── base.page.ts
│   ├── home.page.ts
│   ├── components/
│   ├── lists/
│   └── details/
│
└── utils/            # Утилиты
    ├── constants.ts
    └── test-helpers.ts
```

## Покрытие

- ✅ Главная страница
- ✅ Навигация (хедер, футер)
- ✅ Списки: клиники, врачи, услуги, лекарства, статьи
- ✅ Пагинация на всех списках
- ✅ Детальные страницы всех типов
- ✅ Кнопка "К поиску" на детальных страницах

## Troubleshooting

### Тесты падают локально

1. Убедитесь что dev сервер запущен (`npm run dev`)
2. Проверьте что порт 3000 свободен
3. Очистите кеш: `rm -rf .nuxt node_modules/.cache`

### Тесты падают на проде

1. Проверьте что сайт доступен: `curl https://docta.me`
2. Увеличьте таймауты в конфигурации
3. Проверьте скриншоты в `test-results/`

### Флаки-тесты

1. Добавьте больше ожиданий (`waitForLoadState`)
2. Используйте более стабильные селекторы
3. Увеличьте количество retry
