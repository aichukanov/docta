import { isStripeConfigured } from '~/server/utils/stripe';

// Доступна ли онлайн-оплата (заданы ли Stripe-ключи).
// Без ключей UI показывает «оплата временно недоступна», остальное работает.
export default defineEventHandler((): { enabled: boolean } => {
	return { enabled: isStripeConfigured() };
});
