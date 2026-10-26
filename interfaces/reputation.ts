import type { ComplaintType } from '~/enums/complaint-type';

export type ComplaintStatus = 'confirmed' | 'unconfirmed';

/**
 * Публичная жалоба раздела «Репутация» (prd/clinic-reputation/) — одинаково
 * для клиники и для врача. Формулировка берётся из i18n по `type`; свободного
 * текста здесь нет, внутренняя заметка об источнике (source_note) наружу не
 * отдаётся.
 */
export interface Complaint {
	type: ComplaintType;
	status: ComplaintStatus;
	/** Закреплённый отзыв-основание — якорь в секцию отзывов */
	reviewId?: number;
	/** Слаг статьи-разбора (/articles/<slug>) */
	articleSlug?: string;
	/** Дата инцидента (YYYY-MM-DD) */
	incidentDate?: string;
	/** Официальный ответ клиники или врача */
	response?: string;
}

/** Полная строка жалобы для админки (включая внутренние поля) */
export interface ComplaintAdmin extends Complaint {
	id: number;
	/** id клиники или врача — смотря из какой таблицы строка */
	entityId: number;
	isActive: boolean;
	sourceNote?: string;
	createdAt: string;
	updatedAt: string;
}
