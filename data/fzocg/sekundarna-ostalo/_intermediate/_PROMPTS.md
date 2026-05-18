# Промпты для параллельной обработки SEKUNDARNA OSTALO

Открой 8 новых окон Claude Code в этом же репозитории и вставляй в каждое соответствующий промпт ниже. После того как все 8 закончат — запусти Stage 2 (merge) в отдельной сессии.

---

## БАТЧ 1 — База, секции 1–3 (PDF p.5–21)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 1–3.

Это один из 7 параллельных батчей основной части документа + 1 батч поправок (отдельно). См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md и оглавление в _SECTIONS.md.

**Твой диапазон**: PDF страницы 5–21 (документная нумерация 2–18)
**Твои секции**:
- 1. OPŠTE USLUGE SEKUNDARNOG I TERCIJARNOG NIVOA ZDRAVSTVENE ZAŠTITE (PDF p.5)
- 2. BIOHEMIJSKO-HEMATOLOŠKA I IMUNOLOŠKA LABORATORIJSKA DIJAGNOSTIKA (PDF p.8)
- 3. MIKROBIOLOŠKA DIJAGNOSTIKA (PDF p.15)
Заканчивается перед началом секции 4 (KLINIČKA I MEDICINSKA GENETIKA на PDF p.22) — НЕ включай позиции секции 4.

**Картинки уже отрендерены**: e:/tmp/fzocg_pages/sekundarna_ostalo/base/page-NNN-top.png и page-NNN-bot.png (N=005..021), scale 3.0, ~1797×1296px каждая половина.

**Структура таблицы**:
ŠIFRA | NAZIV USLUGE | CIJENA — где CIJENA имеет ДВА подстолбца: **Odjeljenje** (стационар) и **Ambulanta** (амбулаторно). Одна из цен может быть пустой, либо обе заполнены.

Секции имеют numbered headers ("1. OPŠTE USLUGE...", "2. BIOHEMIJSKO...") и могут иметь подсекции без номера (например "Usluge u prijemnoj ambulanti", "Rad sestara - njega bolesnika za 24 sata po jednom bolesniku"). Сохраняй и section, и subsection (если есть).

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-1-base-pages-005-021.json`

**Схема JSON**:
```json
{
  "batch": "base-1",
  "pdf_pages": "5-21",
  "doc_pages": "2-18",
  "sections": ["1. OPŠTE USLUGE...", "2. BIOHEMIJSKO...", "3. MIKROBIOLOŠKA..."],
  "items": [
    {
      "code": "Y01001",
      "name_sr_latin": "Početna bolnička obrada",
      "price_odjeljenje_eur": 2.60,
      "price_ambulanta_eur": null,
      "section": "1. OPŠTE USLUGE SEKUNDARNOG I TERCIJARNOG NIVOA ZDRAVSTVENE ZAŠTITE",
      "subsection": null
    },
    {
      "code": "Y01004",
      "name_sr_latin": "Konsultativni pregled specijaliste",
      "price_odjeljenje_eur": 2.60,
      "price_ambulanta_eur": 5.56,
      "section": "1. OPŠTE USLUGE SEKUNDARNOG I TERCIJARNOG NIVOA ZDRAVSTVENE ZAŠTITE",
      "subsection": null
    },
    {
      "code": "Y11001",
      "name_sr_latin": "Specijalistički pregled dežurnog ljekara",
      "price_odjeljenje_eur": null,
      "price_ambulanta_eur": 4.17,
      "section": "1. OPŠTE USLUGE SEKUNDARNOG I TERCIJARNOG NIVOA ZDRAVSTVENE ZAŠTITE",
      "subsection": "Usluge u prijemnoj ambulanti"
    }
  ]
}
```

**Правила**:
- Цены — числа (десятичная точка). `2,60` → `2.60`. Пустые ячейки → `null`.
- `name_sr_latin` — точно как в PDF, с š/č/ć/ž/đ
- `section` — полная строка с номером секции
- `subsection` — null если нет, иначе текст подсекции (без номера)
- Дубликаты строк от перекрытия top/bot не записывай
- VERIFY-пометки: добавляй `"note": "VERIFY: <причина>"` при неуверенности
- В конце отчитайся: сколько позиций, какие секции, последний код, путь к файлу

Когда закончишь — закрывай окно или жди следующего задания.
```

---

## БАТЧ 2 — База, секции 4–7 (PDF p.22–39)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 4–7.

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md и оглавление в _SECTIONS.md.

**Твой диапазон**: PDF страницы 22–39 (документная нумерация 19–36)
**Твои секции**:
- 4. KLINIČKA I MEDICINSKA GENETIKA I IMUNOLOGIJA (PDF p.22)
- 5. PATOLOŠKA ANATOMIJA I HISTOLOGIJA (PDF p.26)
- 6. RADIOLOŠKA DIJAGNOSTIKA (PDF p.30)
- 7. INTERVENCIJE I PROCEDURE U SPECIJALISTIČKO-KONSULTATIVNOJ ZDRAVSTVENOJ ZAŠTITI - ZAJEDNIČKE DJELATNOSTI (PDF p.36)
Заканчивается перед началом секции 8 (OPŠTA INTERNA MEDICINA на PDF p.40) — НЕ включай секцию 8.

**Картинки**: e:/tmp/fzocg_pages/sekundarna_ostalo/base/page-NNN-top.png и -bot.png (N=022..039)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-2-base-pages-022-039.json`

**Схема, правила, структура таблицы** — точно как в БАТЧЕ 1 (см. _PROMPTS.md). Колонки CIJENA имеют подколонки Odjeljenje | Ambulanta.

Когда закончишь — отчитайся: сколько позиций, какие секции, последний код.
```

---

## БАТЧ 3 — База, секции 8–34 (PDF p.40–56)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 8–34 (амбулаторные специальности, много мелких).

См. план и оглавление в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/.

**Твой диапазон**: PDF страницы 40–56 (документная нумерация 37–53)
**Твои секции** (8–34):
- 8. OPŠTA INTERNA MEDICINA (p.40)
- 9. PULMOLOGIJA/PNEUMOFTIZIOLOGIJA (p.40)
- 10. KARDIOLOGIJA (p.40)
- 11. ENDOKRINOLOGIJA (p.40)
- 12. NEFROLOGIJA (p.41)
- 13. REUMATOLOGIJA (p.41)
- 14. GASTROENTEROHEPATOLOGIJA (p.42)
- 15. HEMATOLOGIJA (p.42)
- 16. DERMATOVENEROLOGIJA (p.43)
- 17. INFEKTOLOGIJA (p.43)
- 18. PSIHIJATRIJA (p.43)
- 19. NEUROLOGIJA (p.44)
- 20. OPŠTA HIRURGIJA (p.45)
- 21. DIGESTIVNA HIRURGIJA (p.46)
- 22. VASKULARNA HIRURGIJA (p.46)
- 23. HIPERBARIČNA MEDICINA (p.46)
- 24. GRUDNA HIRURGIJA (p.47)
- 25. PLASTIČNA I REKONSTRUKTIVNA HIRURGIJA (p.47)
- 26. KARDIOHIRURGIJA (p.47)
- 27. ORTOPEDIJA I TRAUMATOLOGIJA (p.48)
- 28. UROLOGIJA (p.49)
- 29. NEUROHIRURGIJA (p.51)
- 30. OTORINOLARINGOLOGIJA (p.51)
- 31. OFTALMOLOGIJA (p.54)
- 32. MAKSILOFACIJALNA HIRURGIJA (p.57) — ОСТОРОЖНО: заходит на p.57, но твой диапазон до p.56. Заканчивай ПЕРЕД секцией 32.

Точнее: заканчивай на последней позиции секции 31 (OFTALMOLOGIJA), до начала секции 32.

**Картинки**: base/page-NNN-top.png и -bot.png (N=040..056)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-3-base-pages-040-056.json`

**Схема и правила** — как в БАТЧЕ 1.

Отчитайся: позиций, секций, последний код.
```

---

## БАТЧ 4 — База, секции 32–40 (PDF p.57–72)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 32–40.

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md.

**Твой диапазон**: PDF страницы 57–72 (документная нумерация 54–69)
**Твои секции**:
- 32. MAKSILOFACIJALNA HIRURGIJA (PDF p.57)
- 33. DJEČIJA HIRURGIJA (PDF p.57)
- 34. GINEKOLOGIJA I AKUŠERSTVO (PDF p.57)
- 35. ANESTEZIJA SA REANIMACIJOM (PDF p.60)
- 36. OPERACIJE - HIRURGIJA (PDF p.60) — большая секция, длинная
- 37. OPERACIJE - DJEČIJA HIRURGIJA (PDF p.66)
- 38. OPERACIJE - DIGESTIVNA HIRURGIJA (PDF p.67)
- 39. OPERACIJE - KARDIOHIRURGIJA (PDF p.68)
- 40. OPERACIJE - VASKULARNA HIRURGIJA (PDF p.69)
Заканчивается перед началом секции 41 (OPERACIJE - NEUROHIRURGIJA на PDF p.73).

**Картинки**: base/page-NNN-top.png и -bot.png (N=057..072)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-4-base-pages-057-072.json`

**Схема и правила** — как в БАТЧЕ 1.

Отчитайся: позиций, секций, последний код.
```

---

## БАТЧ 5 — База, секции 41–43 (PDF p.73–87)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 41–43 (большие операционные секции).

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md.

**Твой диапазон**: PDF страницы 73–87 (документная нумерация 70–84)
**Твои секции**:
- 41. OPERACIJE - NEUROHIRURGIJA (PDF p.73)
- 42. OPERACIJE - GRUDNA HIRURGIJA (PDF p.75)
- 43. OPERACIJE - PLASTIČNA I REKONSTRUKTIVNA HIRURGIJA (PDF p.77) — длинная, занимает 7 страниц до начала секции 44.
Заканчивается перед началом секции 44 (OPERACIJE - MAKSILOFACIJALNA HIRURGIJA на PDF p.84) — НЕ включай секцию 44.

Стоп: на PDF p.84 начинается секция 44, твой диапазон до p.87 включает её начало. Точно: твоя секция 43 идёт до p.83 включительно, потом начинается секция 44, которую ТЫ ВКЛЮЧАЕШЬ, она идёт до p.87. Уточнённо — у тебя секции 41, 42, 43, 44 в этом диапазоне.

Перепиши: **Твои секции 41–44**:
- 41. OPERACIJE - NEUROHIRURGIJA (p.73)
- 42. OPERACIJE - GRUDNA HIRURGIJA (p.75)
- 43. OPERACIJE - PLASTIČNA I REKONSTRUKTIVNA HIRURGIJA (p.77)
- 44. OPERACIJE - MAKSILOFACIJALNA HIRURGIJA (p.84)
Заканчивается перед началом секции 45 (OPERACIJE - UROLOGIJA на PDF p.88).

**Картинки**: base/page-NNN-top.png и -bot.png (N=073..087)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-5-base-pages-073-087.json`

**Схема и правила** — как в БАТЧЕ 1.

Отчитайся: позиций, секций, последний код.
```

---

## БАТЧ 6 — База, секции 45–48 (PDF p.88–101)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — базовая часть, секции 45–48.

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md.

**Твой диапазон**: PDF страницы 88–101 (документная нумерация 85–98)
**Твои секции**:
- 45. OPERACIJE - UROLOGIJA (PDF p.88)
- 46. OPERACIJE - OTORINOLARINGOLOGIJA (PDF p.92)
- 47. OPERACIJE - OFTALMOLOGIJA (PDF p.95)
- 48. OPERACIJE - ORTOPEDIJA (PDF p.97)
Заканчивается перед началом секции 49 (OPERACIJE - GINEKOLOGIJA на PDF p.102).

**Картинки**: base/page-NNN-top.png и -bot.png (N=088..101)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-6-base-pages-088-101.json`

**Схема и правила** — как в БАТЧЕ 1.

Отчитайся: позиций, секций, последний код.
```

---

## БАТЧ 7 — База, секции 49–67 (PDF p.102–118)

```
OCR FZOCG cjenovnik (sekundarna ostalo) — последний батч базы, секции 49–67.

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md.

**Твой диапазон**: PDF страницы 102–118 (документная нумерация 99–115)
**Твои секции**:
- 49. OPERACIJE - GINEKOLOGIJA i AKUŠERSTVO (p.102)
- 50. USLUGE ASISTIRANE REPRODUKCIJE (VANTJELESNE OPLODNJE) (p.104)
- 51. PORODAJNA SALA (p.104)
- 52. OPŠTA PEDIJATRIJA SA NEONATOLOGIJOM (p.105)
- 53. DJEČIJA GASTROENTEROHEPATOLOGIJA (p.106)
- 54. DJEČIJA PULMOLOGIJA (p.106)
- 55. DJEČIJA ALERGOLOGIJA (p.106)
- 56. DJEČIJA HEMATOLOGIJA I ONKOLOGIJA (p.106)
- 57. DJEČIJA KARDIOLOGIJA (p.107)
- 58. DJEČIJA NEUROLOGIJA (p.107)
- 59. ONKOLOGIJA I RADIOTERAPIJA (p.107)
- 60. NUKLEARNA MEDICINA (p.108)
- 61. PSIHOLOGIJA (p.109)
- 62. USLUGE SOCIJALNOG RADNIKA (p.109)
- 63. EPIDEMIOLOGIJA (p.109)
- 64. HIGIJENA (p.110)
- 65. FIZIKALNA MEDICINA I REHABILITACIJA (p.110)
- 66. URGENTNA MEDICINA (p.112)
- 67. STOMATOLOGIJA (p.112)

Заканчивается перед началом TOC (на PDF p.119). Если на p.117-118 текст уже отсутствует — заканчивай раньше. Проверь страницы по факту.

**Картинки**: base/page-NNN-top.png и -bot.png (N=102..118)

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-7-base-pages-102-118.json`

**Схема и правила** — как в БАТЧЕ 1.

Отчитайся: позиций, секций, последний код.
```

---

## БАТЧ 8 — Все поправки (Odluke o izmjeni/dopuni)

```
OCR FZOCG поправки к cjenovnik (sekundarna ostalo). Это отдельный батч от базы — собираем ВСЕ изменения из 14 поправочных документов в один JSON.

См. план в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/_PLAN.md.

**Источник поправок**: 14 PDF в e:/pet/docta.me/прейскуранты/fzocg/SEKUNDARNA I TERCIJARNA ZDRAVSTVENA ZAŠTITA – OSTALO BOLNIČKO LIJEČENJE I SPECIJALISTIČKO KONSULATATIVNA I DIJAGNOSTIČKA ZDRAVSTVENE ZAŠTITA/

**Картинки уже отрендерены** в e:/tmp/fzocg_pages/sekundarna_ostalo/<slug>/page-NN-top.png и -bot.png. Папки (slug):
- Odluka-o-dopuni-Cjenovnika-na-STN/ (2p, нет даты в имени)
- Odluka-o-dopuni-Cjenovnika-STN-PCR-test-na-koronav/ (2p)
- Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN/ (4p, нет даты)
- Odluka-o-izmjeni-Cjenovnika-na-STN/ (3p, нет даты)
- Odluka-o-izmjeni-i-dopuni-Cjenovnika-zdravstvenih-/ (3p)
- Odluka-o-izmjeni-Cjenovnika-STN-nova-cij_-PCR-test/ (2p)
- 1632118391Odluka-o-izmjeni-Cjenovnika-STN-usluge-MR/ (3p)
- Odluka-o-izmjeni-Cjenovnika-STN-od-25_05_2022/ (2p)
- Odluka-o-izmjeni-Cjenovnika-STN-od-15_06_2022/ (6p)
- Odluka-o-izmjeni-Cjenovnika-STN-od-26_12_2022-1/ (2p)
- Odluka-o-izmjeni-Cjenovnika-STN-od-14_03_2023/ (6p)
- Odluka-o-izmjeni-i-dopuni-Cjenovnika-STN-od-17_10_2023_g/ (4p)
- Odluka-o-izmjeni-Cjenovnika-zdravstvenih-usluga-na-STN-od-01/ (6p)
- Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN-od-01_02_2025/ (12p)

**Что извлечь из каждой поправки**:
1. Номер документа (Broj: 01-XXXX) и дату подписания/принятия — обычно на 1-й или последней странице
2. Дату вступления в силу (часто "stupa na snagu osmog dana od dana donošenja" или конкретная дата)
3. Все изменения цен / новые позиции / удалённые позиции

**Формат таблиц в поправках**: 
Обычно секции вида:
"- u tački N (название секции из базы), cijene zdravstvenih usluga označene sa šiframa XXX-YYY, mijenjaju se i glase:"
Затем таблица:
ŠIFRA | NAZIV USLUGE | CIJENA (Odjeljenje | Ambulanta)

Также бывают "dopune" — добавления новых позиций.

**Куда сохранить**: `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/batch-amendments-all.json`

**Схема JSON**:
```json
{
  "batch": "amendments",
  "amendments": [
    {
      "amendment_id": "Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN-od-01_02_2025",
      "broj": "01-XXXX",
      "signed_date": "2025-02-01",
      "effective_from": "2025-02-09",
      "source_pdf": "Odluka-o-izmjeni-i-dopuni-Cjenovnika-na-STN-od-01.02.2025.pdf",
      "items": [
        {
          "code": "E07001",
          "name_sr_latin": "Prvi pregled - pulmolog",
          "price_odjeljenje_eur": null,
          "price_ambulanta_eur": 11.12,
          "section_ref": "u tački 9 (Pulmologija/pneumoftiziologija)",
          "action": "izmjena"
        }
      ]
    },
    ...
  ]
}
```

`action` — одно из: `"izmjena"` (изменение существующей цены), `"dopuna"` (добавление новой позиции), `"brisanje"` (удаление).

**Порядок поправок в массиве** — по дате (от старых к новым). Для документов без даты в имени файла — постарайся извлечь дату подписания из текста и расположи правильно. Если не получается — добавь `"date_uncertain": true`.

**Правила**:
- Цены — числа, `null` для пустых
- VERIFY-пометки для неуверенных значений
- Дубликаты позиций между поправками НЕ удаляй — каждая запись со своим amendment_id, merge будет позже

Отчитайся: сколько всего items, по сколько в каждой поправке, и есть ли поправки, которые ты не смог уверенно датировать.
```

---

## Stage 2: MERGE (после того как все 8 батчей готовы)

Промпт для финальной сессии:

```
Финальный merge для SEKUNDARNA OSTALO. Все 8 батчей готовы в e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/:
- batch-1-base-pages-005-021.json
- batch-2-base-pages-022-039.json
- batch-3-base-pages-040-056.json
- batch-4-base-pages-057-072.json
- batch-5-base-pages-073-087.json
- batch-6-base-pages-088-101.json
- batch-7-base-pages-102-118.json
- batch-amendments-all.json

**Задача**:
1. Загрузить все batch-N-base-*.json и собрать единую базу позиций (по code как ключ, проверь что нет дубликатов; если есть — добавь VERIFY-пометку и оставь обе)
2. Загрузить batch-amendments-all.json, отсортировать поправки по effective_from
3. Применить каждую поправку к базе последовательно (latest write wins):
   - action=izmjena → обновить price_odjeljenje_eur и/или price_ambulanta_eur, добавить amended_from = effective_from
   - action=dopuna → добавить новую позицию с added_in = effective_from
   - action=brisanje → удалить позицию (или пометить deleted=true)
4. Сохранить финал в `e:/pet/docta.me/nuxt/data/fzocg/sekundarna-ostalo/sekundarna-ostalo-LATEST.json`

**Финальная схема**:
```json
{
  "source": "Cjenovnik FZOCG sekundarna i tercijarna zdravstvena zaštita — ostalo bolničko + specijalističko",
  "base_pdf": "15846071842.-Cjenovnik-zdravstvenih-usluga-na-sekundarnom-i.pdf",
  "base_signed": "2015-07-29",
  "base_broj": "01-4596",
  "level": "sekundarna i tercijarna zdravstvena zaštita — ostalo bolničko liječenje i specijalističko konsultativna i dijagnostička zdravstvena zaštita",
  "amendments_applied": [
    {"effective_from": "2016-12-26", "broj": "01-9153", "items_changed": N},
    ...
  ],
  "extracted_date": "2026-05-12",
  "items_total": <count>,
  "sections": {...counts...},
  "items": [
    {
      "code": "...",
      "name_sr_latin": "...",
      "price_odjeljenje_eur": ...,
      "price_ambulanta_eur": ...,
      "section": "...",
      "subsection": "...",
      "amended_from": "YYYY-MM-DD" or null,
      "added_in": "YYYY-MM-DD" or null
    }
  ]
}
```

Также удали все промежуточные batch-*.json после успешного merge (или оставь — на твоё усмотрение).

Отчитайся: items_total, сколько было изменено / добавлено / удалено, какие amendments применены.
```
