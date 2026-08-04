/**
 * Администратор клиники — аккаунт с доступом к кабинету клиники
 * (таблица `clinic_admins`). Их может быть несколько: владелец, администратор
 * ресепшена, маркетолог. Список правится только в админке сайта.
 */
export interface ClinicAdmin {
	/** id строки `clinic_admins`, не пользователя. */
	id: number;
	userId: number;
	email: string | null;
	name: string;
	/** Когда пользователю выдали доступ. */
	createdAt: string | null;
	/** Этот аккаунт создал клинику (`clinics.created_by`). */
	isCreator: boolean;
}
