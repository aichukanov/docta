# SEKUNDARNA OSTALO — план обработки

> **СТАТУС: исторический документ.** Описывает первоначальный LLM-only план обработки sekundarna (декабрь 2025 — январь 2026), до того как добавили PaddleOCR. Финальный пайплайн — paddle + LLM cross-validation через `scripts/fzocg/merge_to_final.py`, см. `../../README.md` для актуальной архитектуры. Этот документ оставлен как референс структуры (8 батчей, 67 секций, 14 поправок) — пригодится, если придётся переделывать с нуля.

Большой документ FZOCG: основной cjenovnik 120 страниц + 14 поправок.

## Источник

```
e:/pet/docta.me/прейскуранты/fzocg/SEKUNDARNA I TERCIJARNA ZDRAVSTVENA ZAŠTITA – OSTALO BOLNIČKO LIJEČENJE I SPECIJALISTIČKO KONSULATATIVNA I DIJAGNOSTIČKA ZDRAVSTVENE ZAŠTITA/
```

База: `15846071842.-Cjenovnik-zdravstvenih-usluga-na-sekundarnom-i.pdf` (29.07.2015, broj 01-4596)

Поправки (по дате):
1. `01-9153` от 26.12.2016
2. `01-1696` от 22.03.2017
3. `01-6104` от 20.09.2019
4. `01-8210` от 13.12.2020
5. `01-9323` от 30.11.2020 (порядок дат странный, в исходнике именно так)
6. `01-7281` от 23.07.2021 (PCR коронавирус)
7. `01-8844` от 09.09.2021 (PCR новая цена)
8. `01-???` (MR usluge, дата 1632118391 unix?)
9. `01-4402` от 25.05.2022
10. `01-5113` от 15.06.2022
11. `01-12172` от 26.12.2022
12. `01-2643` от 14.03.2023
13. `01-9472` от 17.10.2023
14. `01-???` от 01.02.2025 (12 страниц, самая большая — консолидирующая)

## Структура

База: ŠIFRA | NAZIV USLUGE | CIJENA (Odjeljenje | Ambulanta)
- Один или оба столбца цены могут быть заполнены
- 67 numbered секций (см. _SECTIONS.md)

Поправки: те же столбцы, но патчат отдельные диапазоны кодов в конкретных секциях

## Цена — единая или формула?

Из Člana 5 базы (PDF p.4):
- Vrijednost boda medicinskog rada = 1,30 €
- Vrijednost boda nemedicinskog dijela = 1,48 €
- Vrijednost boda u specijalističko/subspecijalističkim ambulantama = 2,78 €

То есть в источнике могут быть БОДЫ (баллы), а сам цена — расчётная. Проверить при OCR: что именно стоит в колонке "CIJENA" — баллы или €. Судя по странице 5 (Y01001 = 2,60) и поправке 01.02.2025 (E07001 ambulanta = 11,12), это, вероятно, уже **готовые цены в €** (а не баллы).

## План в 8 параллельных окон

### Stage 1: 8 параллельных батчей

| Батч | Содержимое | PDF страницы | Прим. позиций |
|------|-----------|--------------|-----------------|
| B1 | sec 1–3 (Opšte + Biohem + Mikro) | 5–21 (17p) | ~400 |
| B2 | sec 4–7 (Genetika + Patolog + Radiolog + Intervencije) | 22–39 (18p) | ~400 |
| B3 | sec 8–34 (ambulatorne specijalnosti — много мелких разделов) | 40–56 (17p) | ~400 |
| B4 | sec 35–40 (Anestezija + Operacije Hirurgija + ...) | 57–72 (16p) | ~350 |
| B5 | sec 41–44 (Operacije Neuro/Grudna/Plastična/Maksilo) | 73–87 (15p) | ~350 |
| B6 | sec 45–48 (Operacije Uro/Otorino/Oftalmo/Ortoped) | 88–101 (14p) | ~350 |
| B7 | sec 49–67 (Operacije Ginek + dječije + ostalo) | 102–118 (17p) | ~400 |
| B-AMD | Все 14 поправок | ~64 страницы | ~300 изменений |

Картинки уже отрендерены в `e:/tmp/fzocg_pages/sekundarna_ostalo/`:
- База: `base/page-NNN-top.png` + `page-NNN-bot.png` (N=001..120)
- Поправки: `<slug>/page-NN-top.png` + `-bot.png` (или `page-NN.png` если страница уже < 2000px)

### Stage 2: Merge

Когда все 8 батчей готовы, ОДНА сессия делает финальный merge:
1. Читает все base-batch-N.json + amendments.json
2. Применяет каждую поправку поверх базы в хронологическом порядке
3. Для каждого кода — побеждает последнее значение (latest write wins)
4. Сохраняет в `data/fzocg/sekundarna-ostalo/sekundarna-ostalo-LATEST.json`

## Где сохранять промежуточные результаты

`data/fzocg/sekundarna-ostalo/`
- `batch-N-base-pages-XXX-YYY.json` (для каждого батча базы)
- `batch-amendments-all.json` (все поправки в одном файле, упорядочены по дате)
- `sekundarna-ostalo-LATEST.json` (финальный)
