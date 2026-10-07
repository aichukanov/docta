# Оригиналы прайс-листов

Исходные файлы прайсов в том виде, в каком их получили: PDF, сканы, фото,
docx. Из них делались импорты цен. Здесь лежат и файлы, у которых нет
публичного URL: без этой папки такие цены проверить нечем.

Раньше папка лежала вне репозитория, в `E:\pet\docta.me\прейскуранты`.
Пути в старых выводах OCR (`input_path` в `data/fzocg/*/paddleocr/*.json`)
указывают туда — это архивный снимок прогона, их не правим.

## Что где

| Папка | Клиника (slug) | Что внутри | Публичный URL | Разбор |
|---|---|---|---|---|
| `danilo prvi/` | `bolnica-danilo-i-cetinje` | 2 PDF из Oracle Reports: специалистические амбулатории и больничное лечение | нет: страница прайса на daniloprvi.me в Maintenance Mode | `data/clinic-services-import/bolnica-danilo-cetinje/` |
| `opsta bolnica niksic/` | `opsta-bolnica-niksic` | `Cjenovnik_bolnickog_lijecenja.pdf` | нет | `data/clinic-services-import/opsta-bolnica-niksic/` |
| `herceg novi dz/` | `dom-zdravlja-herceg-novi` | `CJENOVNIK.pdf`, скан 2019 | domzdravljahn.me/wp-content/uploads/2019/03/CJENOVNIK.pdf | `data/clinic-services-import/dom-zdravlja-herceg-novi/` |
| `kolasin dz/` | `dom-zdravlja-kolasin` | прайс для неосигуранных | dzkolasin.me/…/2019/02/Cjenovnik-licima-koja-nisu-osiguranici.pdf, побайтно совпадает (проверено 2026-10-02); из меню сайта ссылка убрана | `data/clinic-services-import/dom-zdravlja-kolasin/` |
| `mojkovac dz/` | `dom-zdravlja-bosko-dedeic-mojkovac` | `02.10.2025.pdf`, скан, колонки Cijena и Cijena×3 | dzmojkovac.me/wp-content/uploads/2019/03/02.10.2025.pdf | `data/clinic-services-import/dom-zdravlja-mojkovac/` |
| `risan bolnica/` | `specijalna-bolnica-za-ortopediju-neurohirurgiju-i-neurologiju-vaso-cukovic-risan` | прайсы treća lica 2023 (амбулатория, отделения) + решение о повышении | bolnicarisan.me, Dokumenta → Cjenovnici → 2023 | `data/risan-bolnica/`, скрипты `scripts/kbkotor/` |
| `Novi Standard/` | `novi-standard-poliklinika` | PDF от 08.04.2025, docx с панелями и акциями, `photo/` (9 фото) | нет: на сайте только акции | — |
| `Zejnilovic/` | `dr-zejnilovic-pzu-dnevna-bolnica` | `photo source/` (9 фото прайса), `чеки/`, таблицы, извлечённые ChatGPT (csv, xlsx) | нет | — |
| `fzocg/` | — (тарифы фонда, не клиника) | PDF FZOCG по 7 категориям, подпапки по категориям | fzocg.me | `data/fzocg/`, скрипты `scripts/fzocg/` |

Карта прайсов на сайтах клиник: `data/clinic-pricelists/map.json`. У перечисленных
выше клиник там есть поле `localSource` со ссылкой на эту папку.

## Правила

- **Файлы не переименовывать.** OCR-скрипты ищут их по имени
  (`scripts/kbkotor/paddleocr_kbkotor.py`, `scripts/fzocg/paddleocr_all_fzocg.py`).
- **Новая клиника — папка по её `clinics.slug`.** Старые папки сохраняют
  исторические имена, потому что на них ссылаются импорты.
- **Новая редакция прайса кладётся рядом, старая не удаляется.** По двум
  редакциям видно, что изменилось. Дату редакции лучше держать в имени файла.
- **Сюда идут оригиналы, полученные вручную**: от юзера, от клиники, файлы без
  публичного URL. Автоматические снимки сайтов для перепроверок лежат отдельно,
  в `data/clinic-pricelists/sources/<slug>/<YYYY-MM-DD>.<ext>`.
