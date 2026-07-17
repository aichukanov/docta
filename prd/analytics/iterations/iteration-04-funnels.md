# Итерация 4: События конверсий и воронки

**Статус:** 🟡 In Progress (кодовая часть готова, 2026-06-11)

> Реальность: свойства под воронки (`entity_*`, `page_type`, `contact_type`)
> уже едут со всеми событиями — переименований не потребуется. Сама итерация —
> конфигурация в Mixpanel UI; актуальный PRD с чеклистом —
> **[../mixpanel-setup.md](../mixpanel-setup.md)** (этот документ ниже —
> исторический план со старыми именами событий, не выполнять по нему).
> Воронки с избранным не настраиваются — избранного нет в продукте.  
**Приоритет:** P1 (высокий)  
**Оценка:** 3-4 дня  
**Зависимости:** Итерации 1, 2, 3 должны быть завершены

---

## Цель

Настроить воронки конверсий в Mixpanel, создать dashboards для мониторинга ключевых метрик, настроить cohorts для сегментации пользователей, обучить команду работе с аналитикой.

---

## Scope

### В рамках итерации

✅ Настройка ключевых воронок конверсий  
✅ Создание dashboards для основных метрик  
✅ Настройка cohorts для сегментации  
✅ Настройка retention reports  
✅ E2E тесты для критичных воронок  
✅ Финальная документация и best practices  
✅ Обучение команды работе с Mixpanel

### Вне рамок

❌ A/B тестирование (будет добавлено позже)  
❌ Custom analytics dashboard (используем Mixpanel UI)  
❌ Data warehouse integration  
❌ Server-side tracking

---

## Задачи

### 1. Настройка воронок (Funnels)

**Задача 1.1:** Воронка "Поиск → Просмотр клиники → Контакт"

В Mixpanel UI:

1. Insights → Funnels → Create Funnel
2. Добавить шаги:
   - Step 1: `Search Performed`
   - Step 2: `Clinic Viewed`
   - Step 3: `Phone Clicked` OR `Website Visited` OR `Email Clicked`
3. Настройки:
   - Conversion window: 1 день (пользователь должен пройти воронку за день)
   - Exclusion: пользователи, которые вышли с сайта между шагами
4. Сохранить как "Search to Contact Funnel"

**Метрики:**

- Overall conversion rate
- Drop-off rate на каждом шаге
- Time to convert
- Breakdown by city, device, source

**Задача 1.2:** Воронка "Услуга → Клиника → Контакт"

Шаги:

1. `Service Viewed`
2. `Clinic Viewed from Service`
3. `Phone Clicked` OR `Website Visited`

Conversion window: 1 день

**Задача 1.3:** Воронка "Врач → Клиника → Контакт"

Шаги:

1. `Doctor Viewed`
2. `Clinic Viewed from Doctor`
3. `Phone Clicked` OR `Website Visited`

Conversion window: 1 день

**Задача 1.4:** Воронка "Просмотр → Избранное → Возврат"

Шаги:

1. `Clinic Viewed` OR `Doctor Viewed`
2. `Added to Favorites`
3. `Clinic Viewed` (повторный в течение 7 дней)

Conversion window: 7 дней

**Задача 1.5:** Воронка "Регистрация и активность"

Шаги:

1. User sign up (из auth events)
2. `Page Viewed` (любая страница в течение 24ч)
3. `Phone Clicked` OR `Added to Favorites` (любое действие в течение 7 дней)

Conversion window: 7 дней

### 2. Настройка Dashboards

**Задача 2.1:** Dashboard "Overview Metrics"

Виджеты:

- **DAU/WAU/MAU trends** (линейный график)
  - Metric: Unique users performing any event
  - Time range: Last 30 days
- **Top 10 Events** (bar chart)
  - Metric: Event count
  - Breakdown: Event name
- **Page Views Breakdown** (pie chart)
  - Events: Clinic Viewed, Doctor Viewed, Service Viewed, Article Viewed
- **Conversion Rate** (single stat)
  - Funnel: Search to Contact
  - Display: Overall conversion %

**Задача 2.2:** Dashboard "Content Performance"

Виджеты:

- **Top 10 Clinics by Views** (table)
  - Event: Clinic Viewed
  - Breakdown: clinic_name
  - Sort: Count descending
- **Top 10 Services by Views** (table)
  - Event: Service Viewed
  - Breakdown: service_name
- **Top Cities** (bar chart)
  - Event: any page view
  - Breakdown: city
- **Geographic Distribution** (map)
  - Event: Page Viewed
  - Breakdown: city

**Задача 2.3:** Dashboard "Engagement Metrics"

Виджеты:

- **Contact Interactions Trend** (line chart)
  - Events: Phone Clicked, Phone Copied, Email Clicked, Website Visited
  - Time range: Last 30 days
- **Contact Rate by Entity Type** (bar chart)
  - Metric: Phone Clicked / Clinic Viewed (%)
  - Breakdown: entity_type
- **Favorite Actions** (line chart)
  - Events: Added to Favorites, Removed from Favorites
- **Search Success Rate** (single stat)
  - Formula: (Search Result Clicked / Search Performed) \* 100

**Задача 2.4:** Dashboard "User Behavior"

Виджеты:

- **Session Duration** (line chart)
  - Metric: Average session length
  - Time range: Last 30 days
- **Pages per Session** (line chart)
  - Metric: Average page views per user
- **Return Rate** (retention chart)
  - Cohort: Users by first visit date
  - Return action: Any event
  - Time range: 30 days
- **User Journey Sankey** (flow diagram)
  - Common paths through the site

### 3. Настройка Cohorts

**Задача 3.1:** Cohort "Active Users"

Критерии:

- Performed any event in the last 7 days

Use case: Retargeting активных пользователей

**Задача 3.2:** Cohort "High Intent Users"

Критерии:

- Viewed 3+ clinics OR doctors in the last 7 days
- AND (Copied phone OR Clicked phone OR Visited website)

Use case: Пользователи с высоким намерением совершить действие

**Задача 3.3:** Cohort "Searchers"

Критерии:

- Performed search in the last 30 days
- AND results_found = true

Use case: Пользователи, использующие поиск

**Задача 3.4:** Cohort "Favorites Users"

Критерии:

- Added to Favorites at least once

Use case: Engaged пользователи, возвращающиеся к сохраненному

**Задача 3.5:** Cohort "Power Users"

Критерии:

- Performed 10+ events in the last 7 days
- AND Visited on 3+ different days

Use case: Наиболее активные пользователи

**Задача 3.6:** Cohort "Clinic Owners"

Критерии:

- User property: role = 'clinic_owner'

Use case: B2B сегмент

**Задача 3.7:** Cohort "Bounced Users"

Критерии:

- Viewed 1 page
- AND session duration < 30 seconds

Use case: Пользователи, которые сразу ушли

### 4. Retention Reports

**Задача 4.1:** Настроить недельный retention

```
Retention Report: "Weekly Active Users"
- Cohort: Users who performed any event
- Return event: Any event
- Time granularity: Weekly
- Retention period: 8 weeks
```

**Задача 4.2:** Настроить retention по действиям

```
Retention Report: "Contact Action Retention"
- Cohort: Users who clicked phone or visited website
- Return event: Phone Clicked OR Website Visited
- Time granularity: Weekly
- Retention period: 4 weeks
```

### 5. Настройка Insights

**Задача 5.1:** Insight "Conversion by Source"

```
Type: Funnel
Funnel: Search to Contact
Breakdown: $referrer (откуда пришел трафик)
Compare: Last 30 days vs Previous 30 days
```

**Задача 5.2:** Insight "Best Performing Cities"

```
Type: Segmentation
Event: Phone Clicked
Breakdown: city
Sort: Count descending
Show: Top 10
```

**Задача 5.3:** Insight "User Journey Time"

```
Type: Funnel
Funnel: Search to Contact
View: Time to convert
Breakdown: User cohort (new vs returning)
```

### 6. Alerts (опционально, если на paid plan)

**Задача 6.1:** Alert на drop conversion rate

```
Alert: "Conversion Rate Drop"
Condition: Search to Contact funnel conversion < 10%
Frequency: Daily
Recipients: Product Manager, Tech Lead
```

**Задача 6.2:** Alert на spike ошибок

```
Alert: "Analytics Errors Spike"
Condition: (failed events / total events) > 10%
Frequency: Hourly
Recipients: Tech Lead
```

### 7. E2E тесты для воронок

**Задача 7.1:** Создать E2E тест для critical funnel

```typescript
// e2e/analytics/funnels.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Analytics Funnels', () => {
	test('should complete search to contact funnel', async ({ page }) => {
		const trackedEvents: string[] = [];

		await page.route('**/api.mixpanel.com/**', async (route) => {
			const postData = route.request().postData();
			if (postData) {
				// Parse и сохранить событие
				if (postData.includes('Search Performed')) {
					trackedEvents.push('Search Performed');
				}
				if (postData.includes('Clinic Viewed')) {
					trackedEvents.push('Clinic Viewed');
				}
				if (postData.includes('Phone Clicked')) {
					trackedEvents.push('Phone Clicked');
				}
			}
			await route.continue();
		});

		// 1. Perform search
		await page.goto('/');
		await page.fill('[data-testid="search-input"]', 'стоматология');
		await page.click('[data-testid="search-button"]');
		await page.waitForTimeout(500);

		// 2. Click on clinic
		await page.click('[data-testid="clinic-card"]:first-child');
		await page.waitForTimeout(500);

		// 3. Click phone
		await page.click('[data-testid="phone-button"]');
		await page.waitForTimeout(500);

		// Verify funnel steps tracked
		expect(trackedEvents).toContain('Search Performed');
		expect(trackedEvents).toContain('Clinic Viewed');
		expect(trackedEvents).toContain('Phone Clicked');

		console.log('✅ Search to Contact funnel completed');
	});

	test('should complete service to contact funnel', async ({ page }) => {
		// Similar test for Service → Clinic → Contact
	});
});
```

### 8. Документация и Best Practices

**Задача 8.1:** Обновить `docs/analytics/events.md`

Добавить полную документацию всех событий с примерами.

**Задача 8.2:** Создать `docs/analytics/funnels.md`

```markdown
# Analytics Funnels Guide

## Key Funnels

### 1. Search to Contact Funnel

**Purpose:** Отслеживает путь от поиска до контакта

**Steps:**

1. Search Performed
2. Clinic Viewed
3. Phone Clicked OR Website Visited

**Target Conversion:** ≥ 15%

**Optimization Ideas:**

- Улучшить релевантность поиска
- Оптимизировать карточки клиник
- Сделать контакты более заметными

### 2. Service to Contact Funnel

...
```

**Задача 8.3:** Создать `docs/analytics/dashboards.md`

```markdown
# Analytics Dashboards Guide

## Overview Dashboard

**Link:** [Mixpanel Dashboard](...)

**Metrics:**

- DAU/WAU/MAU
- Top Events
- Conversion Rates

**Usage:** Ежедневный мониторинг общих метрик

## Content Performance Dashboard

...
```

**Задача 8.4:** Создать `docs/analytics/best-practices.md`

```markdown
# Analytics Best Practices

## Event Naming

- Use Title Case: "Clinic Viewed", not "clinic_viewed"
- Past tense: "Clicked", not "Click"
- Entity + Action pattern

## Properties

- Use snake_case: `clinic_id`, not `clinicId`
- Required properties: always include
- Optional properties: use `?` in types

## Testing

- Always test events in development
- Use debug mode to verify properties
- Add E2E tests for critical funnels

## Privacy

- Never send PII in events
- Hash sensitive data if needed
- Respect cookie consent

## Performance

- Track only meaningful events
- Batch events when possible
- Don't track on every mouse move
```

### 9. Обучение команды

**Задача 9.1:** Создать презентацию для команды

Темы:

- Как открыть Mixpanel и найти нужные данные
- Основные dashboards и что они показывают
- Как создать простой report
- Как анализировать воронки
- Как использовать cohorts

**Задача 9.2:** Провести воркшоп (1-2 часа)

План:

1. Overview аналитики (что трэкаем, зачем)
2. Demo: как использовать Mixpanel UI
3. Hands-on: каждый создает свой report
4. Q&A

**Задача 9.3:** Создать quick reference guide

```markdown
# Mixpanel Quick Reference

## Common Tasks

### Найти топ клиник по просмотрам

1. Insights → Segmentation
2. Event: Clinic Viewed
3. Breakdown: clinic_name
4. Sort: Count descending

### Проверить conversion rate

1. Insights → Funnels
2. Select funnel: "Search to Contact"
3. View conversion %

### Сегментировать по городам

1. Any report
2. Add filter: city = Алматы (или другой)

...
```

### 10. Финальная проверка

**Задача 10.1:** Чеклист перед завершением

- [ ] Все 4 основных воронки настроены и работают
- [ ] 4 dashboards созданы и заполнены данными
- [ ] 7 cohorts настроены
- [ ] Retention reports показывают данные
- [ ] E2E тесты проходят
- [ ] Документация полная и актуальная
- [ ] Команда обучена работе с Mixpanel
- [ ] Analytics используется для принятия решений

---

## Критерии приемки

- [ ] 4 ключевых воронки настроены в Mixpanel
- [ ] 4 dashboards созданы и работают
- [ ] 7 cohorts настроены для сегментации
- [ ] Retention reports показывают корректные данные
- [ ] E2E тесты для критичных воронок проходят
- [ ] Вся документация создана и актуальна
- [ ] Команда обучена и может самостоятельно работать с аналитикой
- [ ] Минимум 1 data-driven решение принято на основе аналитики

---

## Testing Checklist

### Mixpanel UI

- [ ] Открыть каждую воронку → убедиться что есть данные
- [ ] Открыть каждый dashboard → проверить виджеты
- [ ] Проверить cohorts → убедиться что пользователи попадают
- [ ] Открыть retention report → проверить данные

### Data Quality

- [ ] Проверить что все события трэкаются корректно
- [ ] Проверить что свойства заполнены
- [ ] Проверить что user identification работает
- [ ] Проверить что super properties присутствуют

---

## Deliverables

1. **Воронки:**

   - Search to Contact Funnel
   - Service to Contact Funnel
   - Doctor to Contact Funnel
   - View to Favorites to Return Funnel

2. **Dashboards:**

   - Overview Metrics
   - Content Performance
   - Engagement Metrics
   - User Behavior

3. **Cohorts:**

   - Active Users
   - High Intent Users
   - Searchers
   - Favorites Users
   - Power Users
   - Clinic Owners
   - Bounced Users

4. **Документация:**

   - events.md (полная)
   - funnels.md
   - dashboards.md
   - best-practices.md
   - quick-reference.md

5. **Обучение:**
   - Презентация
   - Воркшоп проведен
   - Quick reference guide

---

## Метрики успеха итерации

- ✅ Команда может самостоятельно создавать reports в Mixpanel
- ✅ Dashboards проверяются минимум 2 раза в неделю
- ✅ Минимум 1 product решение принято на основе данных из аналитики
- ✅ Все ключевые воронки имеют conversion rate > 10%

---

## Следующие шаги (за рамками этого PRD)

После завершения всех итераций:

1. **Мониторинг и оптимизация** - регулярно проверять метрики и оптимизировать
2. **A/B тестирование** - внедрить experiments на основе insights
3. **Server-side tracking** - добавить server-side events для более надежного трэкинга
4. **Advanced segmentation** - более сложная сегментация пользователей
5. **Predictive analytics** - использовать ML для предсказания поведения

---

## Известные ограничения

- **Free tier limits:** Если превысим 100K users/month, нужно будет перейти на платный план
- **Data retention:** На free tier Mixpanel хранит данные ограниченное время
- **Export:** Экспорт данных ограничен на free tier
