import Stripe from 'stripe';

let stripeClient: Stripe | null = null;

/** Stripe настроен (есть секретный ключ)? Без него оплата отключена. */
export function isStripeConfigured(): boolean {
	return Boolean(useRuntimeConfig().stripeSecretKey);
}

/**
 * Ленивая инициализация Stripe-клиента.
 * Возвращает null, если STRIPE_SECRET_KEY не задан — вызывающий код
 * должен аккуратно отключить оплату, а не падать.
 */
export function getStripe(): Stripe | null {
	const key = useRuntimeConfig().stripeSecretKey;
	if (!key) return null;

	if (!stripeClient) {
		stripeClient = new Stripe(key);
	}
	return stripeClient;
}
