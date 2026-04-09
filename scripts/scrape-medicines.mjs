#!/usr/bin/env node
/**
 * Scrape the Montenegro Ministry of Health (CInMED) medicines register.
 * Source: https://cinmed.me/en/register-of-medicines-for-human-use/
 * Output: data/medicines.json (~5 MB, ~3500 medicines)
 *
 * ─── How it works ────────────────────────────────────────────────────────
 *
 * Phase 1 — list (~2 min):
 *   Playwright opens the register page, iterates through all 9 dispensing
 *   mode filters (prescription, OTC, hospital-only, etc.), submits the form
 *   for each, and collects every medicine link with its cinmed_id.
 *   Pharmaceutical forms containing commas (e.g. "Kapi za oči, rastvor")
 *   are parsed correctly using the known forms list from the site dropdown.
 *
 * Phase 2 — enrich (~10 min):
 *   For each medicine, fetches its detail page via HTTP (no browser needed)
 *   and extracts all structured fields: INN/active substance, ATC code,
 *   full manufacturer address, authorization holder, approval number/date,
 *   packaging details, and document links (.doc/.docx).
 *   Saves progress every 50 records — safe to interrupt and resume.
 *   Skips already-enriched records (checks for `inn` field presence).
 *
 * ─── Usage ───────────────────────────────────────────────────────────────
 *
 *   # Full scrape: list all medicines + enrich each with detail page data
 *   node scripts/scrape-medicines.mjs
 *
 *   # Re-enrich only (e.g. after interrupted run, or to retry errors)
 *   # Reads existing data/medicines.json, fetches missing detail data
 *   node scripts/scrape-medicines.mjs --enrich-only
 *
 *   # Dry run: collect list, print sample, don't write files
 *   node scripts/scrape-medicines.mjs --dry-run
 *
 *   # Debug: visible browser window (for troubleshooting list phase)
 *   node scripts/scrape-medicines.mjs --debug
 *
 * ─── Output fields per medicine ──────────────────────────────────────────
 *
 *   cinmed_id            - CInMED internal ID (unique, stable)
 *   name                 - Brand name (e.g. "ASPIRIN® PROTECT")
 *   inn                  - INN / active substance (e.g. "Acetilsalicilna kiselina")
 *   atc_code             - ATC classification (e.g. "B01AC06")
 *   pharmaceutical_form  - Dosage form (e.g. "Gastrorezistentna tableta")
 *   strength             - Dosage strength (e.g. "100mg")
 *   packaging            - Short packaging (from list)
 *   detail_packaging     - Full packaging description (from detail page)
 *   manufacturer         - Manufacturer name (short, from list)
 *   detail_manufacturer  - Manufacturer with full address (from detail page)
 *   country              - Country of origin
 *   authorization_holder - Marketing authorization holder in Montenegro
 *   authorization_number - Approval decision number
 *   authorization_date   - Approval date (YYYY-MM-DD)
 *   dispensing_mode      - Prescription requirement (Montenegrin)
 *   license_status       - null = active, "Dozvola prestala da važi" = expired
 *   advertising_manner   - Advertising classification
 *   detail_url           - Link to CInMED detail page
 *   documents            - Array of {url, label} for SPC/PIL .doc files
 *
 * ─── Prerequisites ───────────────────────────────────────────────────────
 *
 *   npm install (needs @playwright/test from devDependencies)
 *   npx playwright install chromium  (if not already installed)
 *
 * ─── When to re-run ─────────────────────────────────────────────────────
 *
 *   CInMED updates the register periodically. Re-run every 1-3 months to
 *   pick up newly approved medicines and expired licenses. A full run
 *   takes ~12 minutes and overwrites data/medicines.json completely.
 *   The --enrich-only flag is useful if the list phase succeeded but
 *   enrichment was interrupted (e.g. network issues).
 */

import { chromium } from '@playwright/test';
import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT      = resolve(__dirname, '..');
const OUT_PATH  = resolve(ROOT, 'data/medicines.json');

const PAGE_URL = 'https://cinmed.me/en/register-of-medicines-for-human-use/';

// ---------------------------------------------------------------------------
// CLI args
// ---------------------------------------------------------------------------

const args         = process.argv.slice(2);
const DRY_RUN      = args.includes('--dry-run');
const DEBUG        = args.includes('--debug');
const ENRICH_ONLY  = args.includes('--enrich-only');
const CONCURRENCY  = 5;
const SAVE_EVERY   = 50;

// ---------------------------------------------------------------------------
// Parse list link text
// ---------------------------------------------------------------------------

function parseLinkText(text, knownForms) {
  let license_status = null;
  const statusMatch = text.match(/\s-\s(Dozvola prestala da važi.*)$/i);
  if (statusMatch) {
    license_status = statusMatch[1].trim();
    text = text.substring(0, text.length - statusMatch[0].length).trim();
  }

  const firstComma = text.indexOf(',');
  if (firstComma < 0) return { name: text, pharmaceutical_form: '', strength: null, packaging: null, manufacturer: '', country: null, license_status };

  const name = text.substring(0, firstComma).trim();
  const rest = text.substring(firstComma + 1).trimStart();

  let pharmaceutical_form = '';
  let afterForm = rest;

  const restLower = rest.toLowerCase();
  for (const form of knownForms) {
    const formLower = form.toLowerCase();
    if (restLower.startsWith(formLower)) {
      const nextChar = rest[form.length];
      if (nextChar === ',' || nextChar === undefined) {
        pharmaceutical_form = form;
        afterForm = rest.substring(form.length).replace(/^,\s*/, '');
        break;
      }
    }
  }

  if (!pharmaceutical_form) {
    const parts = rest.split(',').map(s => s.trim());
    pharmaceutical_form = parts[0] || '';
    afterForm = parts.slice(1).join(', ').trim();
  }

  const parts = afterForm.split(',').map(s => s.trim());

  const strength     = parts[0] || null;
  const country      = parts.length >= 2 ? parts[parts.length - 1] : null;
  const manufacturer = parts.length >= 3 ? parts[parts.length - 2] : '';
  const packaging    = parts.length >= 4 ? parts.slice(1, -2).join(', ').trim() : null;

  return { name, pharmaceutical_form, strength, packaging, manufacturer, country, license_status };
}

// ---------------------------------------------------------------------------
// Phase 1: collect list via Playwright
// ---------------------------------------------------------------------------

async function collectResults(page, dispensingMode) {
  await page.goto(PAGE_URL, { waitUntil: 'domcontentloaded', timeout: 30000 });
  await page.selectOption('[name="humani_registar_rezim_izdavanja_lijeka"]', dispensingMode);

  await Promise.all([
    page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 30000 }),
    page.click('[name="humani_lijekovi_submit"]'),
  ]);

  return page.evaluate(() => {
    const items = [];
    const container = document.querySelector('.mt-5.md\\:mt-16');
    if (!container) return items;
    for (const div of container.querySelectorAll('div.mb-2')) {
      const a = div.querySelector('a[data-id]');
      if (!a) continue;
      items.push({
        cinmed_id: parseInt(a.dataset.id, 10),
        text:      a.textContent.trim().replace(/\s+/g, ' '),
        url:       a.href,
      });
    }
    return items;
  });
}

async function phaseList() {
  console.log('── Phase 1: collecting medicine list ──\n');

  const browser = await chromium.launch({ headless: !DEBUG });
  const page    = await browser.newPage();

  await page.goto(PAGE_URL, { waitUntil: 'domcontentloaded', timeout: 30000 });

  const dispensingModes = await page.$$eval(
    '[name="humani_registar_rezim_izdavanja_lijeka"] option',
    opts => opts.filter(o => o.value).map(o => o.value),
  );
  console.log(`  ${dispensingModes.length} dispensing modes`);

  const knownForms = await page.$$eval(
    '[name="humani_registar_farmaceutski_oblik"] option',
    opts => opts.filter(o => o.value).map(o => o.value),
  );
  knownForms.sort((a, b) => b.length - a.length);
  console.log(`  ${knownForms.length} pharmaceutical forms\n`);

  const allMeds = new Map();

  for (const mode of dispensingModes) {
    process.stdout.write(`  [${mode.substring(0, 55)}...]`);
    const items = await collectResults(page, mode);
    let newCount = 0;

    for (const item of items) {
      if (allMeds.has(item.cinmed_id)) continue;
      const parsed = parseLinkText(item.text, knownForms);
      if (!parsed) continue;

      allMeds.set(item.cinmed_id, {
        cinmed_id:           item.cinmed_id,
        name:                parsed.name,
        pharmaceutical_form: parsed.pharmaceutical_form,
        strength:            parsed.strength,
        packaging:           parsed.packaging,
        manufacturer:        parsed.manufacturer,
        country:             parsed.country,
        dispensing_mode:      mode,
        license_status:      parsed.license_status,
        detail_url:          item.url,
      });
      newCount++;
    }
    console.log(` ${items.length} results, ${newCount} new (total: ${allMeds.size})`);
  }

  await browser.close();
  console.log(`\n  ✓ ${allMeds.size} unique medicines\n`);
  return [...allMeds.values()];
}

// ---------------------------------------------------------------------------
// Phase 2: enrich from detail pages via fetch()
// ---------------------------------------------------------------------------

/** Map h5 label text → field name */
const LABEL_MAP = {
  'inn/active substance':          'inn',
  'inn/aktivna supstanca':         'inn',
  'atc':                           'atc_code',
  'pharmaceutical form':           'detail_form',
  'farmaceutski oblik':            'detail_form',
  'strength':                      'detail_strength',
  'jačina':                        'detail_strength',
  'packaging':                     'detail_packaging',
  'pakovanje':                     'detail_packaging',
  'manufacturer':                  'detail_manufacturer',
  'proizvođač':                    'detail_manufacturer',
  'marketing authorisation holder': 'authorization_holder',
  'nosilac dozvole za stavljanje lijeka u promet': 'authorization_holder',
  'dispensing mode':               'detail_dispensing_mode',
  'režim izdavanja':               'detail_dispensing_mode',
  'marketing authorisation number': 'authorization_number',
  'broj dozvole':                  'authorization_number',
  'authorisation date':            'authorization_date',
  'datum dozvole':                 'authorization_date',
  'manner of advertising':         'advertising_manner',
  'način oglašavanja':             'advertising_manner',
  'special use mark':              'special_use',
  'oznaka posebne upotrebe':      'special_use',
  'educational materials':         'educational_materials',
  'edukativni materijali':         'educational_materials',
};

function parseDetailHtml(html) {
  const result = {};

  // Extract all h5/p pairs: <h5 ...>Label:</h5> ... <p ...>Value</p>
  const pairRegex = /<h5[^>]*>([\s\S]*?)<\/h5>\s*<p[^>]*>([\s\S]*?)<\/p>/gi;
  let match;
  while ((match = pairRegex.exec(html)) !== null) {
    const label = match[1].replace(/<[^>]+>/g, '').trim().replace(/:$/, '').toLowerCase();
    const value = match[2].replace(/<[^>]+>/g, '').trim();
    if (!value) continue;

    const field = LABEL_MAP[label];
    if (field) {
      result[field] = value;
    } else {
      // Store unknown fields too — more data = better
      const safeKey = 'extra_' + label.replace(/[^a-z0-9]/g, '_').replace(/_+/g, '_');
      result[safeKey] = value;
    }
  }

  // Extract document links (SPC, PIL)
  const docRegex = /<a[^>]+href="([^"]+\.docx?)"[^>]*>([\s\S]*?)<\/a>/gi;
  const documents = [];
  while ((match = docRegex.exec(html)) !== null) {
    documents.push({
      url:  match[1],
      label: match[2].replace(/<[^>]+>/g, '').trim(),
    });
  }
  if (documents.length) result.documents = documents;

  return result;
}

async function fetchDetail(url, attempt = 1) {
  try {
    const resp = await fetch(url, {
      headers: {
        'Accept': 'text/html',
        'User-Agent': 'Mozilla/5.0 (compatible; docta.me scraper)',
      },
    });
    if (!resp.ok) {
      if (resp.status === 429 && attempt <= 3) {
        await new Promise(r => setTimeout(r, 2000 * attempt));
        return fetchDetail(url, attempt + 1);
      }
      throw new Error(`HTTP ${resp.status}`);
    }
    return resp.text();
  } catch (err) {
    if (attempt <= 2) {
      await new Promise(r => setTimeout(r, 1000));
      return fetchDetail(url, attempt + 1);
    }
    throw err;
  }
}

function saveJson(medicines) {
  const data = {
    scraped_at: new Date().toISOString(),
    source:     PAGE_URL,
    total:      medicines.length,
    medicines,
  };
  writeFileSync(OUT_PATH, JSON.stringify(data, null, 2), 'utf-8');
}

async function phaseEnrich(medicines) {
  const toEnrich = medicines.filter(m => !m.inn && m.detail_url);
  console.log(`── Phase 2: enriching detail pages ──`);
  console.log(`  ${toEnrich.length} to enrich (${medicines.length - toEnrich.length} already done)\n`);

  if (!toEnrich.length) return;

  let done = 0;
  let errors = 0;

  // Process in batches of CONCURRENCY
  for (let i = 0; i < toEnrich.length; i += CONCURRENCY) {
    const batch = toEnrich.slice(i, i + CONCURRENCY);

    const results = await Promise.allSettled(
      batch.map(async (med) => {
        const html = await fetchDetail(med.detail_url);
        const detail = parseDetailHtml(html);
        Object.assign(med, detail);
      })
    );

    for (const r of results) {
      if (r.status === 'fulfilled') done++;
      else { errors++; done++; }
    }

    // Progress
    process.stdout.write(`\r  ${done} / ${toEnrich.length} enriched${errors ? ` (${errors} errors)` : ''}`);

    // Save periodically
    if (done % SAVE_EVERY < CONCURRENCY) {
      saveJson(medicines);
    }

    // Polite delay
    await new Promise(r => setTimeout(r, 200));
  }

  // Final save
  saveJson(medicines);
  console.log(`\n\n  ✓ Enriched ${done - errors}/${toEnrich.length}` + (errors ? `, ${errors} errors` : ''));
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log('═══════════════════════════════════════════');
  console.log('  cinmed.me → medicines register scraper  ');
  console.log('═══════════════════════════════════════════\n');

  let medicines;

  if (ENRICH_ONLY) {
    // Load existing JSON
    if (!existsSync(OUT_PATH)) {
      throw new Error(`${OUT_PATH} not found. Run without --enrich-only first.`);
    }
    const existing = JSON.parse(readFileSync(OUT_PATH, 'utf-8'));
    medicines = existing.medicines;
    console.log(`  Loaded ${medicines.length} medicines from existing JSON\n`);
  } else {
    medicines = await phaseList();

    if (DRY_RUN) {
      console.log('Sample (first 3):');
      medicines.slice(0, 3).forEach(m => {
        console.log(`  [${m.cinmed_id}] ${m.name} — ${m.pharmaceutical_form}, ${m.strength}`);
      });
      console.log('\n  dry-run — not saved');
      return;
    }

    saveJson(medicines);
    console.log(`  ✓ List saved to ${OUT_PATH}\n`);
  }

  // Phase 2
  await phaseEnrich(medicines);

  // Stats
  const withInn = medicines.filter(m => m.inn);
  const withAtc = medicines.filter(m => m.atc_code);
  console.log(`\n═══════════════════════════════════════════`);
  console.log(`  Total:     ${medicines.length}`);
  console.log(`  With INN:  ${withInn.length}`);
  console.log(`  With ATC:  ${withAtc.length}`);
  console.log(`═══════════════════════════════════════════`);
}

main().catch((err) => {
  console.error('\nFatal:', err.message);
  process.exit(1);
});
