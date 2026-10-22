import type { ClinicComplaintType } from '~/enums/clinic-complaint-type';

export type ClinicComplaintStatus = 'confirmed' | 'unconfirmed';

/**
 * Публичная жалоба раздела «Репутация» (prd/clinic-reputation/).
 * Формулировка берётся из i18n по `type`; свободного текста здесь нет,
 * внутренняя заметка об источнике (source_note) наружу не отдаётся.
 */
export interface ClinicComplaint {
	type: ClinicComplaintType;
	status: ClinicComplaintStatus;
	/** Закреплённый отзыв-основание — якорь в секцию отзывов */
	reviewId?: number;
	/** Слаг статьи-разбора (/articles/<slug>) */
	articleSlug?: string;
	/** Дата инцидента (YYYY-MM-DD) */
	incidentDate?: string;
	/** Официальный ответ клиники */
	clinicResponse?: string;
}

/** Полная строка жалобы для админки (включая внутренние поля) */
export interface ClinicComplaintAdmin extends ClinicComplaint {
	id: number;
	clinicId: number;
	isActive: boolean;
	sourceNote?: string;
	createdAt: string;
	updatedAt: string;
}
