# 3. Архитектура

[← Назад к оглавлению](index.md)

---

## 3.1 Стек технологий

### Frontend

- **Framework:** Nuxt 3, Vue 3, TypeScript
- **UI Library:** Element Plus (для TimePicker, Button, Switch)
- **State Management:** Pinia (для локального состояния редактора)
- **Styling:** SCSS modules

### Backend

- **API:** Nuxt 3 Server API
- **Database:** MySQL
- **Validation:** Zod (схемы валидации)

### Утилиты

- **Date/Time:** Native JavaScript Date API
- **Локализация:** Nuxt I18n

---

## 3.2 Структура данных

### WorkingHours Interface

```typescript
// interfaces/clinic-working-hours.ts

export type DayType =
	| 'regular'
	| '24/7'
	| 'closed'
	| 'on_demand'
	| 'not_specified';

export type DayOfWeek =
	| 'monday'
	| 'tuesday'
	| 'wednesday'
	| 'thursday'
	| 'friday'
	| 'saturday'
	| 'sunday';

export interface TimeInterval {
	start: string; // HH:mm формат, например "09:00"
	end: string; // HH:mm формат, например "18:00"
}

export interface DaySchedule {
	type: DayType;
	intervals?: TimeInterval[]; // Только для type = 'regular'
}

export interface WorkingHours {
	clinicId: number;
	monday: DaySchedule;
	tuesday: DaySchedule;
	wednesday: DaySchedule;
	thursday: DaySchedule;
	friday: DaySchedule;
	saturday: DaySchedule;
	sunday: DaySchedule;
}

export interface WorkingHoursStatus {
	isOpen: boolean;
	message: string; // "Открыто до 18:00" или "Откроется в 09:00"
	nextChange?: string; // Время следующего изменения статуса
}
```

### Пример данных

**Стандартная клиника:**

```json
{
	"clinicId": 123,
	"monday": {
		"type": "regular",
		"intervals": [{ "start": "08:00", "end": "20:00" }]
	},
	"tuesday": {
		"type": "regular",
		"intervals": [{ "start": "08:00", "end": "20:00" }]
	},
	// ... остальные дни
	"saturday": {
		"type": "regular",
		"intervals": [{ "start": "09:00", "end": "15:00" }]
	},
	"sunday": {
		"type": "closed"
	}
}
```

**Клиника с перерывом:**

```json
{
	"clinicId": 456,
	"monday": {
		"type": "regular",
		"intervals": [
			{ "start": "09:00", "end": "13:00" },
			{ "start": "15:00", "end": "19:00" }
		]
	}
	// ...
}
```

**Круглосуточная клиника:**

```json
{
	"clinicId": 789,
	"monday": { "type": "24/7" },
	"tuesday": { "type": "24/7" }
	// ... все дни "24/7"
}
```

---

## 3.3 API Endpoints

### GET /api/clinics/[id]/working-hours

Получение графика работы клиники.

**Request:**

```http
GET /api/clinics/123/working-hours
```

**Response (200 OK):**

```json
{
	"success": true,
	"data": {
		"clinicId": 123,
		"monday": {
			"type": "regular",
			"intervals": [{ "start": "08:00", "end": "20:00" }]
		}
		// ... остальные дни
	}
}
```

**Response (404 Not Found):**

```json
{
	"success": false,
	"error": "Clinic not found"
}
```

**Примечания:**

- Публичный endpoint (не требует авторизации)
- Если график не заполнен, возвращается дефолтное значение (`not_specified` для всех дней)

---

### PUT /api/clinics/[id]/working-hours

Обновление графика работы клиники.

**Request:**

```http
PUT /api/clinics/123/working-hours
Content-Type: application/json
Authorization: Bearer <token>

{
  "monday": {
    "type": "regular",
    "intervals": [
      { "start": "08:00", "end": "20:00" }
    ]
  },
  // ... остальные дни
}
```

**Response (200 OK):**

```json
{
  "success": true,
  "data": {
    "clinicId": 123,
    "monday": { ... },
    // ... обновленный график
  }
}
```

**Response (400 Bad Request) - ошибка валидации:**

```json
{
	"success": false,
	"error": "Validation error",
	"details": [
		{
			"field": "monday.intervals[0].start",
			"message": "Start time must be before end time"
		}
	]
}
```

**Response (403 Forbidden) - нет прав:**

```json
{
	"success": false,
	"error": "You don't have permission to edit this clinic"
}
```

**Валидация:**

- Проверка прав доступа (clinic_admin для данной клиники)
- Валидация формата времени (HH:mm)
- Проверка, что start < end
- Проверка отсутствия пересечений интервалов
- Максимум 3 интервала на день

---

## 3.4 Компоненты

### Структура компонентов

```
components/
└── clinic/
    └── working-hours/
        ├── ScheduleEditor.vue          # Главный редактор графика
        ├── DaySchedule.vue             # Редактор для одного дня
        ├── TimeRangeSelector.vue       # Выбор временного интервала
        ├── DayTypeSelector.vue         # Выбор типа дня (regular/24/7/closed/...)
        ├── ScheduleDisplay.vue         # Отображение графика на публичной странице
        └── CurrentStatus.vue           # Статус "Открыто/Закрыто"
```

### ScheduleEditor.vue

Главный редактор графика работы.

**Props:**

- `clinicId: number` - ID клиники

**События:**

- `@save` - сохранение графика
- `@cancel` - отмена изменений

**Функции:**

- Загрузка текущего графика
- Редактирование графика
- Копирование графика между днями
- Валидация перед сохранением
- Вызов API для сохранения

**Примерная структура:**

```vue
<template>
	<div class="schedule-editor">
		<h3>График работы</h3>

		<div class="quick-actions">
			<el-button @click="copyToWeekdays">Копировать на Пн-Пт</el-button>
			<el-button @click="copyToWeekend">Копировать на Сб-Вс</el-button>
			<el-button @click="copyToAll">Копировать на все дни</el-button>
			<el-button @click="set24x7">Установить 24/7</el-button>
		</div>

		<DaySchedule
			v-for="day in days"
			:key="day"
			:day="day"
			v-model="schedule[day]"
		/>

		<div class="actions">
			<el-button type="primary" @click="save">Сохранить</el-button>
			<el-button @click="cancel">Отменить</el-button>
		</div>
	</div>
</template>
```

### DaySchedule.vue

Редактор графика для одного дня недели.

**Props:**

- `day: DayOfWeek` - день недели
- `modelValue: DaySchedule` - график дня

**События:**

- `@update:modelValue` - изменение графика

**Функции:**

- Выбор типа дня
- Добавление/удаление интервалов
- Редактирование времени

### TimeRangeSelector.vue

Выбор временного интервала (start - end).

**Props:**

- `modelValue: TimeInterval`

**События:**

- `@update:modelValue`
- `@remove` - удаление интервала

### ScheduleDisplay.vue

Отображение графика на публичной странице клиники.

**Props:**

- `clinicId: number`

**Функции:**

- Загрузка графика через API
- Отображение графика по дням
- Выделение текущего дня
- Отображение статуса "Открыто/Закрыто"

**Примерная структура:**

```vue
<template>
	<div class="schedule-display">
		<CurrentStatus :clinicId="clinicId" />

		<div class="schedule-list">
			<div
				v-for="day in days"
				:key="day"
				:class="{ 'current-day': isCurrentDay(day) }"
				class="schedule-day"
			>
				<div class="day-name">{{ t(`days.${day}`) }}</div>
				<div class="day-hours">
					<template v-if="schedule[day].type === 'regular'">
						{{ formatIntervals(schedule[day].intervals) }}
					</template>
					<template v-else>
						{{ formatSpecialType(schedule[day].type) }}
					</template>
				</div>
			</div>
		</div>
	</div>
</template>
```

### CurrentStatus.vue

Отображение текущего статуса (открыто/закрыто).

**Props:**

- `clinicId: number`

**Функции:**

- Загрузка графика
- Расчет текущего статуса на основе текущего времени
- Отображение времени до следующего изменения статуса
- Автоматическое обновление каждую минуту

---

## 3.5 Утилиты

### Расчет статуса "Открыто/Закрыто"

```typescript
// utils/clinic-working-hours.ts

export function calculateStatus(
	schedule: WorkingHours,
	currentTime: Date = new Date(),
): WorkingHoursStatus {
	const dayOfWeek = getDayOfWeek(currentTime);
	const daySchedule = schedule[dayOfWeek];

	if (daySchedule.type === '24/7') {
		return {
			isOpen: true,
			message: 'Открыто круглосуточно',
		};
	}

	if (daySchedule.type === 'closed') {
		const nextOpenDay = findNextOpenDay(schedule, currentTime);
		return {
			isOpen: false,
			message: `Откроется ${nextOpenDay}`,
		};
	}

	if (daySchedule.type === 'on_demand') {
		return {
			isOpen: false,
			message: 'По требованию',
		};
	}

	if (daySchedule.type === 'not_specified') {
		return {
			isOpen: false,
			message: 'Уточняйте по телефону',
		};
	}

	// type === 'regular'
	const currentMinutes = currentTime.getHours() * 60 + currentTime.getMinutes();

	for (const interval of daySchedule.intervals) {
		const startMinutes = timeToMinutes(interval.start);
		const endMinutes = timeToMinutes(interval.end);

		if (currentMinutes >= startMinutes && currentMinutes < endMinutes) {
			return {
				isOpen: true,
				message: `Открыто до ${interval.end}`,
				nextChange: interval.end,
			};
		}
	}

	// Клиника закрыта
	const nextInterval = findNextInterval(daySchedule.intervals, currentMinutes);
	if (nextInterval) {
		return {
			isOpen: false,
			message: `Откроется в ${nextInterval.start}`,
			nextChange: nextInterval.start,
		};
	}

	// Следующий интервал завтра или позже
	const nextOpenTime = findNextOpenTime(schedule, currentTime);
	return {
		isOpen: false,
		message: `Откроется ${nextOpenTime}`,
	};
}

function timeToMinutes(time: string): number {
	const [hours, minutes] = time.split(':').map(Number);
	return hours * 60 + minutes;
}

function getDayOfWeek(date: Date): DayOfWeek {
	const days: DayOfWeek[] = [
		'sunday',
		'monday',
		'tuesday',
		'wednesday',
		'thursday',
		'friday',
		'saturday',
	];
	return days[date.getDay()];
}
```

### Валидация графика

```typescript
// utils/clinic-working-hours-validation.ts

export interface ValidationError {
	field: string;
	message: string;
}

export function validateWorkingHours(
	schedule: WorkingHours,
): ValidationError[] {
	const errors: ValidationError[] = [];

	for (const day of Object.keys(schedule) as DayOfWeek[]) {
		const daySchedule = schedule[day];

		if (daySchedule.type === 'regular') {
			if (!daySchedule.intervals || daySchedule.intervals.length === 0) {
				errors.push({
					field: `${day}.intervals`,
					message: 'Regular day must have at least one interval',
				});
				continue;
			}

			if (daySchedule.intervals.length > 3) {
				errors.push({
					field: `${day}.intervals`,
					message: 'Maximum 3 intervals per day',
				});
			}

			for (let i = 0; i < daySchedule.intervals.length; i++) {
				const interval = daySchedule.intervals[i];

				// Валидация формата времени
				if (!isValidTime(interval.start)) {
					errors.push({
						field: `${day}.intervals[${i}].start`,
						message: 'Invalid time format (expected HH:mm)',
					});
				}

				if (!isValidTime(interval.end)) {
					errors.push({
						field: `${day}.intervals[${i}].end`,
						message: 'Invalid time format (expected HH:mm)',
					});
				}

				// Проверка start < end
				if (timeToMinutes(interval.start) >= timeToMinutes(interval.end)) {
					errors.push({
						field: `${day}.intervals[${i}]`,
						message: 'Start time must be before end time',
					});
				}

				// Проверка пересечений
				for (let j = i + 1; j < daySchedule.intervals.length; j++) {
					const other = daySchedule.intervals[j];
					if (intervalsOverlap(interval, other)) {
						errors.push({
							field: `${day}.intervals`,
							message: `Intervals ${i + 1} and ${j + 1} overlap`,
						});
					}
				}
			}
		}
	}

	return errors;
}

function isValidTime(time: string): boolean {
	const regex = /^([01]\d|2[0-3]):([0-5]\d)$/;
	return regex.test(time);
}

function intervalsOverlap(a: TimeInterval, b: TimeInterval): boolean {
	const aStart = timeToMinutes(a.start);
	const aEnd = timeToMinutes(a.end);
	const bStart = timeToMinutes(b.start);
	const bEnd = timeToMinutes(b.end);

	return aStart < bEnd && aEnd > bStart;
}
```

---

## 3.6 Диаграммы

### Диаграмма компонентов

```
┌─────────────────────────────────────────┐
│        pages/clinics/[id]/index.vue     │
│         (Публичная страница клиники)    │
└──────────────┬──────────────────────────┘
               │
               ├─► ScheduleDisplay.vue
               │       │
               │       ├─► CurrentStatus.vue
               │       └─► DaySchedule (read-only)
               │
┌──────────────┴──────────────────────────┐
│   pages/profile/clinics/[id]/edit.vue   │
│       (Редактирование клиники)          │
└──────────────┬──────────────────────────┘
               │
               └─► ScheduleEditor.vue
                       │
                       ├─► DaySchedule.vue
                       │       │
                       │       ├─► DayTypeSelector.vue
                       │       └─► TimeRangeSelector.vue
                       │
                       └─► API: PUT /api/clinics/[id]/working-hours
```

### Поток данных

```
1. Загрузка графика:
   ScheduleDisplay.vue
   └─► GET /api/clinics/[id]/working-hours
       └─► MySQL: clinic_working_hours table
           └─► Response: WorkingHours

2. Редактирование графика:
   ScheduleEditor.vue
   ├─► Локальное состояние (Pinia store)
   ├─► Валидация (client-side)
   └─► Сохранение
       └─► PUT /api/clinics/[id]/working-hours
           ├─► Проверка прав (auth middleware)
           ├─► Валидация (server-side)
           └─► MySQL: INSERT/UPDATE clinic_working_hours
               └─► Response: обновленный WorkingHours
```

---

**Предыдущий раздел:** [← 2. Требования](02-requirements.md)  
**Следующий раздел:** [4. База данных →](04-database.md)
