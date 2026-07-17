import { getConnection } from '~/server/common/db-mysql';
import type {
	BillingCatalogService,
	BillingPeriod,
} from '~/interfaces/billing';

// Каталог платных услуг с ценами по периодам. Публичный — цены не секрет,
// локализованные названия/описания живут на фронте (i18n/clinic-billing.ts).
export default defineEventHandler(
	async (): Promise<{ services: BillingCatalogService[] }> => {
		try {
			const connection = await getConnection();
			let rows: any;
			try {
				[rows] = await connection.execute(
					`SELECT s.id, s.name, p.months, p.price_cents
					 FROM billing_paid_services s
					 LEFT JOIN billing_service_prices p
						ON s.id = p.service_id AND p.active = TRUE
					 ORDER BY s.id, p.months`,
				);
			} finally {
				await connection.end();
			}

			const servicesMap = new Map<number, BillingCatalogService>();
			for (const row of rows as any[]) {
				if (!servicesMap.has(row.id)) {
					servicesMap.set(row.id, {
						id: row.id,
						name: row.name || '',
						pricing: {},
					});
				}
				if (row.months != null && row.price_cents != null) {
					servicesMap.get(row.id)!.pricing[row.months as BillingPeriod] =
						row.price_cents;
				}
			}

			// Услуги без активных цен покупать нельзя — не показываем
			const services = Array.from(servicesMap.values()).filter(
				(service) => Object.keys(service.pricing).length > 0,
			);

			return { services };
		} catch (error) {
			console.error('API Error - billing services catalog:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch services catalog',
			});
		}
	},
);
