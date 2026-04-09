#!/usr/bin/env node
/**
 * Normalize medicines.json: clean up country names and other dirty data.
 * Run after scraping to fix inconsistencies from cinmed.me source.
 *
 * Usage: node scripts/normalize-medicines-json.mjs
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const JSON_PATH = resolve(ROOT, 'data/medicines.json');

const COUNTRY_MAP = {
  'BiH':                                      'Bosna i Hercegovina',
  'Italija.':                                 'Italija',
  'Njemačka.':                                'Njemačka',
  'Srbija.':                                  'Srbija',
  'KG Njemačka':                              'Njemačka',
  'Sanofi-Aventis Deutschland GmbH Njemačka': 'Njemačka',
  'HEMOMONT d.o.o. Crna Gora':               'Crna Gora',
  'Vršac':                                    'Srbija',
  'Zdravlje A.D. Leskovac':                   'Srbija',
  'Madjarska':                                'Mađarska',
  'Svedska':                                  'Švedska',
  'UK':                                       'Velika Britanija',
  'Češka Republika':                          'Češka',
  'Makedonija':                               'Severna Makedonija',
  'Republika Severna Makedonija':             'Severna Makedonija',
  'Republika Sjeverna Makedonija':            'Severna Makedonija',
};

const data = JSON.parse(readFileSync(JSON_PATH, 'utf-8'));
let fixes = 0;

for (const med of data.medicines) {
  if (med.country && COUNTRY_MAP[med.country]) {
    med.country = COUNTRY_MAP[med.country];
    fixes++;
  }
}

data.scraped_at = new Date().toISOString();
writeFileSync(JSON_PATH, JSON.stringify(data, null, 2), 'utf-8');

const countries = [...new Set(data.medicines.map(m => m.country).filter(Boolean))].sort();
console.log(`✓ Fixed ${fixes} country values`);
console.log(`✓ ${countries.length} unique countries:`);
countries.forEach(c => console.log(`  ${c}`));
