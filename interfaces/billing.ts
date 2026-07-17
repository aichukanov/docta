import type { BillingService } from '~/enums/billing-service';

export const BILLING_PERIODS = [1, 3, 6, 12] as const;
export type BillingPeriod = (typeof BILLING_PERIODS)[number];

export type BillingOrderStatus =
	| 'pending_payment'
	| 'processing'
	| 'completed'
	| 'failed'
	| 'cancelled';

// Каталог: услуга с ценами по периодам (цены в центах EUR)
export interface BillingCatalogService {
	id: BillingService;
	name: string;
	pricing: Partial<Record<BillingPeriod, number>>;
}

export interface BillingOrderItem {
	serviceId: BillingService;
	months: BillingPeriod;
	priceCents: number;
}

export interface BillingOrderDetails {
	id: string;
	clinicId: number;
	status: BillingOrderStatus;
	totalAmountCents: number;
	currency: string;
	items: BillingOrderItem[];
	createdAt: string;
}

// Покупка из истории (legacy-таблица purchases, цена в евро)
export interface BillingMyPurchase {
	id: number;
	price: number;
	purchasedAt: string;
	validUntil: string;
	deleted: boolean;
	serviceIds: BillingService[];
	isActive: boolean;
	isExpired: boolean;
}

export function formatEurCents(cents: number): string {
	return `€${(cents / 100).toFixed(2)}`;
}
