/**
 * Справочный контент (что/как/когда/подготовка/отклонение) для страницы
 * услуги/анализа — из `lab_test_reference_info` / `medical_service_reference_info`.
 */
export interface ReferenceInfo {
	what: string;
	how: string;
	indications: string;
	prep: string;
	abnormal: string;
}
