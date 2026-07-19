import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/insurance-companies/remove')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}
		if (!validateNonNegativeInteger(body.companyId)) {
			setResponseStatus(event, 400, 'Invalid insurance company id');
			return false;
		}

		const connection = await getConnection();

		// insurance_company_branches.insurance_company_id — ON DELETE CASCADE
		// (010-insurance-companies.sql), филиалы удаляются автоматически
		const [result]: any = await connection.execute(
			'DELETE FROM insurance_companies WHERE id = ?',
			[body.companyId],
		);
		await connection.end();

		return result.affectedRows > 0;
	} catch (error) {
		console.error('API Error - insurance company remove:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to remove insurance company',
		});
	}
});
