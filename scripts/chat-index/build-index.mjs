// Build a fast, reusable search index + topical clustering for Telegram chat exports.
// For each export dir it writes, next to result.json:
//   - index.jsonl        one flattened message per line {id,date,from,reply,text}  (grep-friendly)
//   - _topics.json       per-topic hit counts (the "clustering" overview)
//   - _topics/<topic>.jsonl   matched messages per topic (for deep dives)
//
// Run:  node scripts/chat-index/build-index.mjs [exportDir ...]
// Default: both curated exports below.

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const BASE = join('data', 'chat-exports');
const DEFAULT_DIRS = [
  't.me-MonteLiveFamily_2026-07-17',
  't.me-medicina_montenegro-2026-03-20',
];

// Topical buckets — plain lowercased substrings (ru expat concerns). Extend freely.
const TOPICS = {
  meds_unavailable: [
    'нет в аптек', 'не найти', 'не найд', 'не продаёт', 'не продают', 'не купить',
    'не достать', 'нельзя купить', 'из белград', 'из серби', 'привез', 'привоз',
    'заказыва', 'передач', 'нет аналог', 'чем заменить', 'не зарегистр', 'тут нет',
    'здесь нет', 'нет в чг', 'нет в черногор', 'везут из', 'просроч', 'не выпускают',
  ],
  meds_named: [
    'энтеросгел', 'регидрон', 'зиртек', 'цетиризин', 'но-шпа', 'ношпа', 'смект',
    'нурофен', 'мирамистин', 'валидол', 'зелёнк', 'зеленк', 'супрастин', 'эргоферон',
    'полисорб', 'активированный уголь', 'фенистил', 'виферон', 'парацетамол', 'ибупрофен',
    'аугментин', 'амоксиклав', 'йод', 'перекис', 'мезим', 'креон', 'смекта',
  ],
  pharmacy: ['аптек', 'apotek', 'рецепт', 'recept', 'antibiot', 'антибиот'],
  doctors: ['врач', 'доктор', 'педиатр', 'терапевт', 'специалист', 'клиник', 'больниц', 'ljekar', 'doktor'],
  insurance: ['страховк', 'страхован', 'осигуран', 'osiguranj', 'внж', 'boravak', 'боравак'],
  kids: ['ребен', 'ребён', 'дети', 'детей', 'садик', 'вртич', 'школ', 'привив', 'вакцин', 'педиатр'],
  dentistry: ['зуб', 'стоматолог', 'zubar', 'zub'],
};

const flatten = (text) => {
  if (typeof text === 'string') return text;
  if (Array.isArray(text)) return text.map((t) => (typeof t === 'string' ? t : (t && t.text) || '')).join('');
  return '';
};
const oneLine = (s) => s.replace(/\s+/g, ' ').trim();

for (const dir of (process.argv.slice(2).length ? process.argv.slice(2) : DEFAULT_DIRS)) {
  const root = join(BASE, dir);
  const j = JSON.parse(readFileSync(join(root, 'result.json'), 'utf8'));
  const msgs = (j.messages || []).filter((m) => m.type === 'message');

  const indexLines = [];
  const topicHits = Object.fromEntries(Object.keys(TOPICS).map((k) => [k, []]));

  for (const m of msgs) {
    const text = oneLine(flatten(m.text));
    if (!text) continue;
    const rec = { id: m.id, date: m.date, from: m.from || null, reply: m.reply_to_message_id || null, text };
    indexLines.push(JSON.stringify(rec));
    const low = text.toLowerCase();
    for (const [topic, terms] of Object.entries(TOPICS)) {
      if (terms.some((t) => low.includes(t))) topicHits[topic].push(rec);
    }
  }

  writeFileSync(join(root, 'index.jsonl'), indexLines.join('\n') + '\n', 'utf8');

  const topicsDir = join(root, '_topics');
  mkdirSync(topicsDir, { recursive: true });
  const summary = { chat: j.name, dir, messages: msgs.length, indexed: indexLines.length, topics: {} };
  for (const [topic, hits] of Object.entries(topicHits)) {
    summary.topics[topic] = hits.length;
    writeFileSync(join(topicsDir, topic + '.jsonl'), hits.map((h) => JSON.stringify(h)).join('\n') + '\n', 'utf8');
  }
  writeFileSync(join(root, '_topics.json'), JSON.stringify(summary, null, 2) + '\n', 'utf8');
  console.log(JSON.stringify(summary, null, 2));
}
