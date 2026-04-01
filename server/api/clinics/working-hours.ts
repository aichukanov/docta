import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';
import {
	DEFAULT_WORKING_HOURS,
	DAYS_OF_WEEK,
} from '~/interfaces/clinic-working-hours';

export default defineEventHandler(
	async (event): Promise<WorkingHours | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/working-hours')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const connection = await getConnection();

			const [rows] = await connection.execute(
				`SELECT monday, tuesday, wednesday, thursday, friday, saturday, sunday
				 FROM clinic_working_hours WHERE clinic_id = ?`,
				[body.clinicId],
			);

			await connection.end();

			const row = (rows as any[])[0];

			if (!row) {
				return {
					clinicId: body.clinicId,
					...DEFAULT_WORKING_HOURS,
				};
			}

			const workingHours: WorkingHours = {
				clinicId: body.clinicId,
				monday:
					typeof row.monday === 'string' ? JSON.parse(row.monday) : row.monday,
				tuesday:
					typeof row.tuesday === 'string'
						? JSON.parse(row.tuesday)
						: row.tuesday,
				wednesday:
					typeof row.wednesday === 'string'
						? JSON.parse(row.wednesday)
						: row.wednesday,
				thursday:
					typeof row.thursday === 'string'
						? JSON.parse(row.thursday)
						: row.thursday,
				friday:
					typeof row.friday === 'string' ? JSON.parse(row.friday) : row.friday,
				saturday:
					typeof row.saturday === 'string'
						? JSON.parse(row.saturday)
						: row.saturday,
				sunday:
					typeof row.sunday === 'string' ? JSON.parse(row.sunday) : row.sunday,
			};

			return workingHours;
		} catch (error) {
			console.error('API Error - clinic working hours:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch clinic working hours',
			});
		}
	},
);
