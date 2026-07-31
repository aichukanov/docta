/**
 * Публичная видимость врача в одном месте.
 *
 * Три независимых причины не показывать карточку:
 * - `is_draft` — профиль ещё не прошёл ревью;
 * - `hidden` — врач сам скрыл себя из кабинета (обратимо им же);
 * - `hidden_by_admin` — скрыт администратором; врач снять этот флаг не может,
 *   а страница отдаёт 410 Gone, а не 404: удаление намеренное и постоянное.
 *
 * Условие раскидано по ~10 файлам (листинги, карточки клиник и услуг, отзывы,
 * sitemap), поэтому собирается функцией, а не пишется руками:
 * `tests/unit/doctor-visibility.spec.ts` следит, чтобы литерал не вернулся.
 * Скобки нужны для подстановки рядом с `OR` и в `ON`.
 *
 * @param alias Алиас таблицы `doctors` в запросе (или само имя таблицы).
 */
export function doctorIsPublicSql(alias = 'd'): string {
	return `(${alias}.hidden = 0 AND ${alias}.hidden_by_admin = 0 AND ${alias}.is_draft = 0)`;
}

/** Строка врача в том виде, в котором её отдаёт БД (нужны три флага). */
export interface DoctorVisibilityRow {
	hidden?: number | boolean | null;
	hidden_by_admin?: number | boolean | null;
	is_draft?: number | boolean | null;
}

/** Скрыт администратором — публично 410 Gone. */
export function isDoctorHiddenByAdmin(row: DoctorVisibilityRow): boolean {
	return Boolean(row.hidden_by_admin);
}

/** Виден публично: ни черновик, ни самоскрытие, ни скрытие админом. */
export function isDoctorPublic(row: DoctorVisibilityRow): boolean {
	return !row.hidden && !row.hidden_by_admin && !row.is_draft;
}
