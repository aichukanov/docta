import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Хеширует пароль с помощью bcrypt
 * @param password - Пароль в открытом виде
 * @returns Хеш пароля
 */
export async function hashPassword(password: string): Promise<string> {
	return bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Сравнивает пароль с хешем
 * @param password - Пароль в открытом виде
 * @param hash - Хеш пароля из БД
 * @returns true если пароль совпадает, иначе false
 */
export async function comparePassword(
	password: string,
	hash: string,
): Promise<boolean> {
	return bcrypt.compare(password, hash);
}
