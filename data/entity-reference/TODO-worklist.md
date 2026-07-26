# Справки: что осталось написать

Сгенерировано из БД + выгрузок GSC (`data/gsc/perf.txt`, `perf7d.txt`).
Только услуги без карточки в `medical_service_reference_info`, у которых есть хотя бы одна клиника.

> **Тиры A (50), B (82) и C (29) сделаны 2026-07-26** тремя параллельными сессиями и влиты в базовый `medical-services.json` (224 карточки). Остался только тир D.

## Тир D — медицинские справки: НУЖЕН ДРУГОЙ ФОРМАТ (см. примечание) — 52 шт.

| slug | название | клиник | цена до | GSC показы |
|---|---|---:|---:|---:|
| `medical-certificate-for-general-work` | Медицинская справка для общей работы | 7 | 35 € |  |
| `medical-certificate-for-high-risk-and-difficult-working-conditions` | Медицинская справка для работы с повышенным риском и тяжёлыми условиями труда | 7 | 70 € |  |
| `medical-certificate-for-firearms-possession` | Медицинская справка для владения огнестрельным оружием | 7 | 70 € |  |
| `medical-certificate-for-underage-marriage` | Медицинская справка для вступления в брак несовершеннолетних | 7 | 25 € |  |
| `medical-certificate-for-child-adoption` | Медицинская справка для усыновления ребёнка | 7 | 25 € |  |
| `medical-certificate-for-study-abroad-and-visa` | Медицинская справка для продолжения обучения и пребывания за рубежом | 7 | 25 € |  |
| `medical-certificate-for-driving-license-category-a-b-c-d-e` | Медицинская справка для получения водительских прав категории A, B, C, D, E | 6 | 35 € | 4 |
| `medical-certificate-for-maritime-workers` | Медицинская справка для работы на водном транспорте | 6 | 110 € | 2 |
| `medical-certificate-for-difficult-working-conditions-without-high-risk` | Медицинская справка для работы в тяжёлых условиях без повышенного риска | 6 | 50 € |  |
| `medical-certificate-for-professional-drivers` | Медицинская справка для профессиональных водителей | 6 | 50 € |  |
| `medical-certificate-for-court-expert` | Медицинская справка для работы судебным экспертом | 6 | 35 € |  |
| `medical-certificate-for-life-insurance` | Медицинская справка для страхования жизни | 6 | 50 € |  |
| `medical-certificate-for-collective-accommodation` | Медицинская справка для коллективного проживания | 6 | 5 € |  |
| `medical-certificate-for-driving-license-renewal-category-a-b-c-d-e` | Медицинская справка для продления водительских прав категории A, B, C, D, E | 5 | 35 € |  |
| `medical-certificate-for-boat-operation-up-to-12-meters` | Медицинская справка для управления лодкой до 12 метров | 5 | 35 € |  |
| `medical-certificate-for-military-service` | Медицинская справка для военной службы | 5 | 60 € |  |
| `medical-certificate-for-athletes` | Медицинская справка для спортсменов | 5 | 70 € |  |
| `medical-certificate-for-driving-instructor-category-b-c-d-e` | Медицинская справка для инструктора по вождению категории B, C, D, E | 4 | 60 € |  |
| `medical-certificate-for-residence-and-work-in-montenegro` | Медицинская справка для проживания и работы в Черногории | 3 | 30 € | 4 |
| `medical-certificate-for-taxi-driver` | Медицинская справка для водителя такси | 3 | 50 € |  |
| `medical-certificate-for-lifeguards` | Медицинская справка для спасателей на воде | 3 | 35 € |  |
| `medical-certificate-for-secondary-school-enrollment` | Медицинская справка для поступления в среднюю школу | 3 | — |  |
| `medical-certificate-for-lifeguards-divers-and-boat-operators` | Медицинская справка для спасателей, водолазов и управления лодкой | 2 | 35 € |  |
| `medical-certificate-low-risk-work-with-examination` | Справка для работы без риска с осмотром | 2 | 35 € |  |
| `medical-certificate-for-class-a-and-b-drivers` | Справка для водителей категорий A и B | 2 | 50 € |  |
| `medical-certificate-for-other-purposes` | Справка для прочих нужд | 2 | 60 € |  |
| `medical-certificate-for-university-enrollment` | Медицинская справка для поступления в университет | 2 | — |  |
| `medical-certificate-for-divers` | Медицинская справка для дайверов | 2 | 35 € |  |
| `pre-employment-medical-certificate` | Медицинская справка при приёме на работу | 1 | 20 € |  |
| `medical-certificate-for-sports-referees-and-other-purposes` | Медицинская справка для прочих целей (спортивные судьи и др.) | 1 | 60 € |  |
| `medical-certificate-for-low-risk-work` | Медицинская справка для работы без риска | 1 | 26 € |  |
| `medical-certificate-for-high-risk-work` | Справка для работы с повышенным риском | 1 | 50 € |  |
| `medical-certificate-for-significant-risk-work` | Справка для работы со значительными рисками | 1 | 70 € |  |
| `medical-certificate-for-educational-institutions` | Справка для образовательных учреждений | 1 | 60 € |  |
| `medical-certificate-for-visits-montenegro` | Справка для посещений Черногория | 1 | 25 € |  |
| `medical-certificate-for-foreign-marriage` | Справка для брака за рубежом | 1 | 25 € |  |
| `medical-certificate-for-special-course` | Справка для специального курса | 1 | 25 € |  |
| `medical-certificate-for-licensing` | Справка для определённых лицензий | 1 | 25 € |  |
| `medical-certificate-for-continued-education` | Справка для продолжения обучения | 1 | 25 € |  |
| `medical-certificate-for-pension` | Справка для пенсии | 1 | 110 € |  |
| `medical-certificate-disability-suspicion` | Справка о подозрении на инвалидность | 1 | 70 € |  |
| `medical-certificate-observation` | Справка для наблюдения | 1 | 50 € |  |
| `medical-certificate-for-psychotropic-work-monitoring` | Справка для надзора за работой с психотропами | 1 | 85 € |  |
| `medical-certificate-for-prison-visit` | Справка для посещения заключённых | 1 | 35 € |  |
| `medical-certificate-for-special-treatment` | Справка для специальной обработки | 1 | 25 € |  |
| `medical-certificate-for-work-abroad` | Медицинская справка для работы за границей | 1 | — |  |
| `medical-certificate-for-sports-referees` | Медицинская справка для спортивных судей | 1 | 60 € |  |
| `medical-certificate-for-ionizing-radiation-workers` | Медицинская справка для работников, подвергающихся ионизирующему излучению | 1 | 85 € |  |
| `medical-certificate-for-contract-or-will-signing` | Медицинская справка для заключения договора/завещания | 1 | 40 € |  |
| `medical-certificate-for-elderly-home-accommodation` | Медицинская справка для пребывания в доме престарелых | 1 | 30 € |  |
| `medical-certificate-for-security-personnel` | Медицинская справка для сотрудников охраны с правом ношения оружия | 1 | — |  |
| `medical-certificate-for-class-b-c-d-and-e-drivers` | Медицинская справка для водителей категорий B, C, D и E | 1 | 60 € |  |

---

**Итого: 213 карточек.** Из них написано: тир A — 50/50 (батч `tierA-01`).
тир B — 82/82 (батчи `tierB-01`…`tierB-08`).
тир C — 29/29 (батч `tierC-01`).
Осталось: тир D (52, ждёт формата).

## Примечание по тиру D

`medical-certificate-*` — это не процедуры, а административные документы
(для работы, ВНЖ, оружия, учёбы за границей, брака несовершеннолетних, усыновления).
Формат справки из 5 полей к ним не подходит: у документа нет «как проводится»
и тем более «о чём может говорить отклонение».

Нужен отдельный формат, например: что это за документ → кто выдаёт и на каком
основании → что проверяют на осмотре → срок действия → что взять с собой.
Это высокоинтентные запросы экспатов («медицинская справка для ВНЖ Черногория»),
поэтому пропускать их жалко — но и писать в текущем формате нельзя.
