# Итерация 1: База данных графика работы

[← К списку итераций](README.md) | [Следующая →](iteration-02-schedule-editor.md)

---

## Статус: ✅ Done (2026-03-31)

---

## Цель

Создать полную инфраструктуру для хранения графика работы клиник: таблицу БД, TypeScript интерфейсы, API endpoints и утилиты для работы с графиком.

## Зависимости

**Требуется перед началом:**

- ✅ **clinic-profile** - таблица `clinics` должна существовать
- ⏳ **auth** - для проверки прав доступа при редактировании

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. Создание таблицы `clinic_working_hours`

**Файл:** `server/database/migrations/XXX_create_clinic_working_hours_table.sql`

```sql
CREATE TABLE clinic_working_hours (
  id INT AUTO_INCREMENT PRIMARY KEY,
  clinic_id INT NOT NULL,

  -- График для каждого дня недели (JSON)
  monday JSON NOT NULL,
  tuesday JSON NOT NULL,
  wednesday JSON NOT NULL,
  thursday JSON NOT NULL,
  friday JSON NOT NULL,
  saturday JSON NOT NULL,
  sunday JSON NOT NULL,

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  -- Индексы
  UNIQUE KEY unique_clinic (clinic_id),

  -- Ограничения
  CONSTRAINT fk_working_hours_clinic FOREIGN KEY (clinic_id)
    REFERENCES clinics(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Выполнить миграцию:**

```bash
# Если есть система миграций
npm run migrate

# Или вручную через MySQL
mysql -u root -p docta_db < server/database/migrations/XXX_create_clinic_working_hours_table.sql
```

### 2. Создание TypeScript интерфейсов

**Файл:** `interfaces/clinic-working-hours.ts`

```typescript
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

// Дефолтный график (для клиник без заполненного графика)
export const DEFAULT_WORKING_HOURS: Omit<WorkingHours, 'clinicId'> = {
	monday: { type: 'not_specified' },
	tuesday: { type: 'not_specified' },
	wednesday: { type: 'not_specified' },
	thursday: { type: 'not_specified' },
	friday: { type: 'not_specified' },
	saturday: { type: 'not_specified' },
	sunday: { type: 'not_specified' },
};
```

### 3. Создание утилит для работы с графиком

**Файл:** `utils/clinic-working-hours.ts`

```typescript
import type {
	WorkingHours,
	WorkingHoursStatus,
	DayOfWeek,
	DaySchedule,
	TimeInterval,
} from '~/interfaces/clinic-working-hours';

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
		const nextOpenTime = findNextOpenTime(schedule, currentTime);
		return {
			isOpen: false,
			message: nextOpenTime ? `Откроется ${nextOpenTime}` : 'Выходной',
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

	for (const interval of daySchedule.intervals || []) {
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
	const nextInterval = findNextInterval(
		daySchedule.intervals || [],
		currentMinutes,
	);
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
		message: nextOpenTime ? `Откроется ${nextOpenTime}` : 'Закрыто',
	};
}

export function timeToMinutes(time: string): number {
	const [hours, minutes] = time.split(':').map(Number);
	return hours * 60 + minutes;
}

export function getDayOfWeek(date: Date): DayOfWeek {
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

function findNextInterval(
	intervals: TimeInterval[],
	currentMinutes: number,
): TimeInterval | null {
	for (const interval of intervals) {
		if (timeToMinutes(interval.start) > currentMinutes) {
			return interval;
		}
	}
	return null;
}

function findNextOpenTime(
	schedule: WorkingHours,
	currentTime: Date,
): string | null {
	// Упрощенная версия - ищем следующий открытый день
	// TODO: реализовать полную логику с учетом всех дней недели
	return null;
}

export function formatIntervals(intervals: TimeInterval[]): string {
	if (!intervals || intervals.length === 0) return '';
	return intervals.map((i) => `${i.start}-${i.end}`).join(', ');
}
```

### 4. Создание API endpoint: GET /api/clinics/[id]/working-hours

**Файл:** `server/api/clinics/[id]/working-hours.get.ts`

```typescript
import { getConnection } from '~/server/common/db';
import { validateNonNegativeInteger } from '~/common/validation';
import type {
	WorkingHours,
	DaySchedule,
} from '~/interfaces/clinic-working-hours';
import { DEFAULT_WORKING_HOURS } from '~/interfaces/clinic-working-hours';

export default defineEventHandler(
	async (event): Promise<WorkingHours | null> => {
		try {
			const clinicId = Number(event.context.params?.id);

			if (!validateNonNegativeInteger(clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const connection = await getConnection();

			// Проверяем существование клиники
			const [clinicRows] = await connection.execute(
				'SELECT id FROM clinics WHERE id = ?',
				[clinicId],
			);

			if (!clinicRows || clinicRows.length === 0) {
				await connection.end();
				setResponseStatus(event, 404, 'Clinic not found');
				return null;
			}

			// Получаем график работы
			const [rows] = await connection.execute(
				'SELECT * FROM clinic_working_hours WHERE clinic_id = ?',
				[clinicId],
			);

			await connection.end();

			if (!rows || rows.length === 0) {
				// Возвращаем дефолтный график
				return {
					clinicId,
					...DEFAULT_WORKING_HOURS,
				};
			}

			const row = rows[0];

			// Парсим JSON поля
			const workingHours: WorkingHours = {
				clinicId,
				monday: JSON.parse(row.monday),
				tuesday: JSON.parse(row.tuesday),
				wednesday: JSON.parse(row.wednesday),
				thursday: JSON.parse(row.thursday),
				friday: JSON.parse(row.friday),
				saturday: JSON.parse(row.saturday),
				sunday: JSON.parse(row.sunday),
			};

			return workingHours;
		} catch (error) {
			console.error('Error fetching working hours:', error);
			setResponseStatus(event, 500, 'Internal server error');
			return null;
		}
	},
);
```

### 5. Создание API endpoint: PUT /api/clinics/[id]/working-hours

**Файл:** `server/api/clinics/[id]/working-hours.put.ts`

```typescript
import { getConnection } from '~/server/common/db';
import { validateNonNegativeInteger, validateBody } from '~/common/validation';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';

export default defineEventHandler(
	async (event): Promise<WorkingHours | null> => {
		try {
			const clinicId = Number(event.context.params?.id);

			if (!validateNonNegativeInteger(clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/[id]/working-hours.put')) {
				setResponseStatus(event, 400, 'Invalid request body');
				return null;
			}

			// TODO: Добавить проверку прав доступа (clinic_admin)
			// requireClinicAdmin(event, clinicId);

			// Валидация данных
			const errors = validateWorkingHoursData(body);
			if (errors.length > 0) {
				setResponseStatus(event, 400, 'Validation error');
				return {
					success: false,
					errors,
				} as any;
			}

			const connection = await getConnection();

			// Сохраняем график работы (REPLACE INTO или INSERT ... ON DUPLICATE KEY UPDATE)
			await connection.execute(
				`REPLACE INTO clinic_working_hours 
       (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
				[
					clinicId,
					JSON.stringify(body.monday),
					JSON.stringify(body.tuesday),
					JSON.stringify(body.wednesday),
					JSON.stringify(body.thursday),
					JSON.stringify(body.friday),
					JSON.stringify(body.saturday),
					JSON.stringify(body.sunday),
				],
			);

			await connection.end();

			// Возвращаем обновленный график
			return {
				clinicId,
				monday: body.monday,
				tuesday: body.tuesday,
				wednesday: body.wednesday,
				thursday: body.thursday,
				friday: body.friday,
				saturday: body.saturday,
				sunday: body.sunday,
			};
		} catch (error) {
			console.error('Error updating working hours:', error);
			setResponseStatus(event, 500, 'Internal server error');
			return null;
		}
	},
);

function validateWorkingHoursData(data: any): string[] {
	const errors: string[] = [];
	const days = [
		'monday',
		'tuesday',
		'wednesday',
		'thursday',
		'friday',
		'saturday',
		'sunday',
	];

	for (const day of days) {
		if (!data[day]) {
			errors.push(`${day} is required`);
			continue;
		}

		const daySchedule = data[day];

		if (!daySchedule.type) {
			errors.push(`${day}.type is required`);
			continue;
		}

		const validTypes = [
			'regular',
			'24/7',
			'closed',
			'on_demand',
			'not_specified',
		];
		if (!validTypes.includes(daySchedule.type)) {
			errors.push(`${day}.type must be one of: ${validTypes.join(', ')}`);
		}

		if (daySchedule.type === 'regular') {
			if (!daySchedule.intervals || !Array.isArray(daySchedule.intervals)) {
				errors.push(`${day}.intervals is required for regular type`);
				continue;
			}

			if (daySchedule.intervals.length === 0) {
				errors.push(`${day}.intervals must have at least one interval`);
			}

			if (daySchedule.intervals.length > 3) {
				errors.push(`${day}.intervals can have maximum 3 intervals`);
			}

			// Валидация каждого интервала
			for (let i = 0; i < daySchedule.intervals.length; i++) {
				const interval = daySchedule.intervals[i];

				if (!interval.start || !interval.end) {
					errors.push(`${day}.intervals[${i}] must have start and end`);
					continue;
				}

				// Валидация формата времени
				const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/;
				if (!timeRegex.test(interval.start)) {
					errors.push(
						`${day}.intervals[${i}].start has invalid format (expected HH:mm)`,
					);
				}
				if (!timeRegex.test(interval.end)) {
					errors.push(
						`${day}.intervals[${i}].end has invalid format (expected HH:mm)`,
					);
				}

				// Проверка start < end
				const startMinutes = timeToMinutes(interval.start);
				const endMinutes = timeToMinutes(interval.end);
				if (startMinutes >= endMinutes) {
					errors.push(
						`${day}.intervals[${i}]: start time must be before end time`,
					);
				}
			}

			// Проверка пересечений интервалов
			for (let i = 0; i < daySchedule.intervals.length; i++) {
				for (let j = i + 1; j < daySchedule.intervals.length; j++) {
					if (
						intervalsOverlap(daySchedule.intervals[i], daySchedule.intervals[j])
					) {
						errors.push(`${day}: intervals ${i + 1} and ${j + 1} overlap`);
					}
				}
			}
		}
	}

	return errors;
}

function timeToMinutes(time: string): number {
	const [hours, minutes] = time.split(':').map(Number);
	return hours * 60 + minutes;
}

function intervalsOverlap(a: any, b: any): boolean {
	const aStart = timeToMinutes(a.start);
	const aEnd = timeToMinutes(a.end);
	const bStart = timeToMinutes(b.start);
	const bEnd = timeToMinutes(b.end);

	return aStart < bEnd && aEnd > bStart;
}
```

---

## Критерии приемки

- [ ] **AC-1:** Таблица `clinic_working_hours` создана в БД
- [ ] **AC-2:** Таблица имеет корректные индексы и foreign keys
- [ ] **AC-3:** TypeScript интерфейсы созданы и экспортированы
- [ ] **AC-4:** Утилита `calculateStatus()` корректно рассчитывает статус для всех типов дней
- [ ] **AC-5:** `GET /api/clinics/[id]/working-hours` возвращает график работы
- [ ] **AC-6:** `GET /api/clinics/[id]/working-hours` возвращает дефолтный график для клиник без заполненного графика
- [ ] **AC-7:** `GET /api/clinics/[id]/working-hours` возвращает 404 для несуществующих клиник
- [ ] **AC-8:** `PUT /api/clinics/[id]/working-hours` сохраняет график работы
- [ ] **AC-9:** `PUT /api/clinics/[id]/working-hours` валидирует данные
- [ ] **AC-10:** `PUT /api/clinics/[id]/working-hours` возвращает ошибки валидации в понятном формате
- [ ] **AC-11:** JSON поля корректно парсятся и сериализуются

---

## Как проверить

### 1. Проверка БД

```sql
-- Проверить, что таблица создана
DESCRIBE clinic_working_hours;

-- Проверить индексы
SHOW INDEXES FROM clinic_working_hours;
```

### 2. Проверка API через curl

**GET запрос (получение графика):**

```bash
# Для существующей клиники без графика (должен вернуть дефолтный график)
curl -X GET http://localhost:3000/api/clinics/1/working-hours

# Ожидаемый результат:
# {
#   "clinicId": 1,
#   "monday": {"type": "not_specified"},
#   ...
# }
```

**PUT запрос (сохранение графика):**

```bash
curl -X PUT http://localhost:3000/api/clinics/1/working-hours \
  -H "Content-Type: application/json" \
  -d '{
    "monday": {
      "type": "regular",
      "intervals": [{"start": "08:00", "end": "20:00"}]
    },
    "tuesday": {
      "type": "regular",
      "intervals": [{"start": "08:00", "end": "20:00"}]
    },
    "wednesday": {
      "type": "regular",
      "intervals": [{"start": "08:00", "end": "20:00"}]
    },
    "thursday": {
      "type": "regular",
      "intervals": [{"start": "08:00", "end": "20:00"}]
    },
    "friday": {
      "type": "regular",
      "intervals": [{"start": "08:00", "end": "20:00"}]
    },
    "saturday": {
      "type": "regular",
      "intervals": [{"start": "09:00", "end": "15:00"}]
    },
    "sunday": {
      "type": "closed"
    }
  }'
```

**Проверка валидации (некорректные данные):**

```bash
# Некорректный формат времени
curl -X PUT http://localhost:3000/api/clinics/1/working-hours \
  -H "Content-Type: application/json" \
  -d '{
    "monday": {
      "type": "regular",
      "intervals": [{"start": "25:00", "end": "20:00"}]
    },
    ...
  }'

# Ожидается: 400 Bad Request с ошибками валидации
```

### 3. Проверка утилиты calculateStatus()

Создать тестовый файл или проверить в Nuxt DevTools:

```typescript
import { calculateStatus } from '~/utils/clinic-working-hours';

const schedule = {
	clinicId: 1,
	monday: {
		type: 'regular',
		intervals: [{ start: '08:00', end: '20:00' }],
	},
	// ... остальные дни
};

// Тест 1: Клиника открыта (понедельник 10:00)
const status1 = calculateStatus(schedule, new Date('2026-01-27T10:00:00'));
console.log(status1); // { isOpen: true, message: "Открыто до 20:00" }

// Тест 2: Клиника закрыта (понедельник 22:00)
const status2 = calculateStatus(schedule, new Date('2026-01-27T22:00:00'));
console.log(status2); // { isOpen: false, message: "Откроется ..." }
```

---

**Предыдущий раздел:** [← К списку итераций](README.md)  
**Следующая итерация:** [Итерация 2: UI компонент редактирования графика →](iteration-02-schedule-editor.md)
