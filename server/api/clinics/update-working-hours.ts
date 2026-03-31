import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { validateWorkingHoursData } from '~/common/clinic-working-hours';
import type { WorkingHours } from '~/interfaces/clinic-working-hours';
import { DAYS_OF_WEEK } from '~/interfaces/clinic-working-hours';

export default defineEventHandler(
	async (event): Promise<WorkingHours | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/update-working-hours')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.clinicId)) {
				setResponseStatus(event, 400, 'Invalid clinic id');
				return null;
			}

			const errors = validateWorkingHoursData(body);
			if (errors.length > 0) {
				setResponseStatus(event, 400, 'Validation error');
				return { errors } as any;
			}

			const connection = await getConnection();

			try {
				await connection.execute(
					`INSERT INTO clinic_working_hours
						(clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
					 VALUES (?, ?, ?, ?, ?, ?, ?, ?)
					 ON DUPLICATE KEY UPDATE
						monday = VALUES(monday),
						tuesday = VALUES(tuesday),
						wednesday = VALUES(wednesday),
						thursday = VALUES(thursday),
						friday = VALUES(friday),
						saturday = VALUES(saturday),
						sunday = VALUES(sunday),
						updated_at = CURRENT_TIMESTAMP`,
					[
						body.clinicId,
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

				return {
					clinicId: body.clinicId,
					monday: body.monday,
					tuesday: body.tuesday,
					wednesday: body.wednesday,
					thursday: body.thursday,
					friday: body.friday,
					saturday: body.saturday,
					sunday: body.sunday,
				};
			} catch (err) {
				await connection.end();
				throw err;
			}
		} catch (error) {
			if ((error as any).statusCode) throw error; // re-throw auth errors
			console.error('API Error - update clinic working hours:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to update clinic working hours',
			});
		}
	},
);
