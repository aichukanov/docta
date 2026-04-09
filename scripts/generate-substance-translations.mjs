#!/usr/bin/env node
/**
 * Generate substance translations JSON with proper pharmaceutical INN names.
 *
 * Output: data/med-translations/substances/batch-NNN.json (40 per file)
 * Usage: node scripts/generate-substance-translations.mjs
 */

import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..');
const OUT_DIR = resolve(ROOT, 'data/med-translations/substances');
const BATCH_SIZE = 40;

if (!existsSync(OUT_DIR)) mkdirSync(OUT_DIR, { recursive: true });

// ═══════════════════════════════════════════════════════════════════════════
// Serbian Latin → Serbian Cyrillic
// ═══════════════════════════════════════════════════════════════════════════

const SR_CYRL_MAP = {
  'lj': 'љ', 'Lj': 'Љ', 'nj': 'њ', 'Nj': 'Њ', 'dž': 'џ', 'Dž': 'Џ',
  'a':'а','b':'б','c':'ц','č':'ч','ć':'ћ','d':'д','đ':'ђ','e':'е','f':'ф',
  'g':'г','h':'х','i':'и','j':'ј','k':'к','l':'л','m':'м','n':'н','o':'о',
  'p':'п','r':'р','s':'с','š':'ш','t':'т','u':'у','v':'в','z':'з','ž':'ж',
  'A':'А','B':'Б','C':'Ц','Č':'Ч','Ć':'Ћ','D':'Д','Đ':'Ђ','E':'Е','F':'Ф',
  'G':'Г','H':'Х','I':'И','J':'Ј','K':'К','L':'Л','M':'М','N':'Н','O':'О',
  'P':'П','R':'Р','S':'С','Š':'Ш','T':'Т','U':'У','V':'В','Z':'З','Ž':'Ж',
};

function toSrCyrl(text) {
  let r = '', i = 0;
  while (i < text.length) {
    if (i + 1 < text.length) {
      const di = text.substring(i, i + 2);
      if (SR_CYRL_MAP[di]) { r += SR_CYRL_MAP[di]; i += 2; continue; }
    }
    r += SR_CYRL_MAP[text[i]] || text[i];
    i++;
  }
  return r;
}

// ═══════════════════════════════════════════════════════════════════════════
// Explicit dictionary: Serbian src → { en, ru }
// Covers the most common and tricky substances
// ═══════════════════════════════════════════════════════════════════════════

const DICT = {
  'acetilsalicilna kiselina': { en: 'acetylsalicylic acid', ru: 'ацетилсалициловая кислота' },
  'alendronska kiselina': { en: 'alendronic acid', ru: 'алендроновая кислота' },
  'aminokapronska kiselina': { en: 'aminocaproic acid', ru: 'аминокапроновая кислота' },
  'askorbinska kiselina': { en: 'ascorbic acid', ru: 'аскорбиновая кислота' },
  'folna kiselina': { en: 'folic acid', ru: 'фолиевая кислота' },
  'fumarna kiselina': { en: 'fumaric acid', ru: 'фумаровая кислота' },
  'gadoterinska kiselina': { en: 'gadoteric acid', ru: 'гадотеровая кислота' },
  'hlorovodonična kiselina': { en: 'hydrochloric acid', ru: 'хлороводородная кислота' },
  'ibandronska kiselina': { en: 'ibandronic acid', ru: 'ибандроновая кислота' },
  'mefenaminska kiselina': { en: 'mefenamic acid', ru: 'мефенамовая кислота' },
  'mikofenolna kiselina': { en: 'mycophenolic acid', ru: 'микофеноловая кислота' },
  'obetihol kiselina': { en: 'obeticholic acid', ru: 'обетихолевая кислота' },
  'pipemidna kiselina': { en: 'pipemidic acid', ru: 'пипемидовая кислота' },
  'risedronska kiselina': { en: 'risedronic acid', ru: 'ризедроновая кислота' },
  'traneksaminska kiselina': { en: 'tranexamic acid', ru: 'транексамовая кислота' },
  'ursodeoksiholna kiselina': { en: 'ursodeoxycholic acid', ru: 'урсодезоксихолевая кислота' },
  'valproinska kiselina': { en: 'valproic acid', ru: 'вальпроевая кислота' },
  'zoledronska kiselina': { en: 'zoledronic acid', ru: 'золедроновая кислота' },
  'lizinasetilsalicilna kiselina': { en: 'lysine acetylsalicylate', ru: 'лизина ацетилсалицилат' },
  'fusidinska kiselina': { en: 'fusidic acid', ru: 'фузидовая кислота' },
  'gadoksetinska kiselina': { en: 'gadoxetic acid', ru: 'гадоксетовая кислота' },
  'gadopentetska kiselina': { en: 'gadopentetic acid', ru: 'гадопентетовая кислота' },
  'klavulanska kiselina': { en: 'clavulanic acid', ru: 'клавулановая кислота' },
  'limunska kiselina': { en: 'citric acid', ru: 'лимонная кислота' },
  'omega-3 kiselina etil estri 90': { en: 'omega-3-acid ethyl esters 90', ru: 'омега-3 кислот этиловые эфиры 90' },
  'salicilna kiselina': { en: 'salicylic acid', ru: 'салициловая кислота' },
  'tioktinska kiselina': { en: 'thioctic acid', ru: 'тиоктовая кислота' },
  'paracetamol': { en: 'paracetamol', ru: 'парацетамол' },
  'ibuprofen': { en: 'ibuprofen', ru: 'ибупрофен' },
  'amoksicilin': { en: 'amoxicillin', ru: 'амоксициллин' },
  'aciklovir': { en: 'aciclovir', ru: 'ацикловир' },
  'acetilcistein': { en: 'acetylcysteine', ru: 'ацетилцистеин' },
  'adrenalin': { en: 'epinephrine', ru: 'эпинефрин' },
  'amlodipin': { en: 'amlodipine', ru: 'амлодипин' },
  'amikacin': { en: 'amikacin', ru: 'амикацин' },
  'ampicilin': { en: 'ampicillin', ru: 'ампициллин' },
  'atorvastatin': { en: 'atorvastatin', ru: 'аторвастатин' },
  'azitromicin': { en: 'azithromycin', ru: 'азитромицин' },
  'beklometazon': { en: 'beclometasone', ru: 'беклометазон' },
  'bisoprolol': { en: 'bisoprolol', ru: 'бисопролол' },
  'budesonid': { en: 'budesonide', ru: 'будесонид' },
  'buprenorfin': { en: 'buprenorphine', ru: 'бупренорфин' },
  'bupropion': { en: 'bupropion', ru: 'бупропион' },
  'cefaleksin': { en: 'cefalexin', ru: 'цефалексин' },
  'cefepim': { en: 'cefepime', ru: 'цефепим' },
  'ceftriakson': { en: 'ceftriaxone', ru: 'цефтриаксон' },
  'ciprofloksacin': { en: 'ciprofloxacin', ru: 'ципрофлоксацин' },
  'ciklofosfamid': { en: 'cyclophosphamide', ru: 'циклофосфамид' },
  'ciklosporin': { en: 'ciclosporin', ru: 'циклоспорин' },
  'cisplatin': { en: 'cisplatin', ru: 'цисплатин' },
  'deksametazon': { en: 'dexamethasone', ru: 'дексаметазон' },
  'deksketoprofen': { en: 'dexketoprofen', ru: 'декскетопрофен' },
  'dekstran': { en: 'dextran', ru: 'декстран' },
  'dekstroza': { en: 'dextrose', ru: 'декстроза' },
  'diazepam': { en: 'diazepam', ru: 'диазепам' },
  'diklofenak': { en: 'diclofenac', ru: 'диклофенак' },
  'digoksin': { en: 'digoxin', ru: 'дигоксин' },
  'doksiciklin': { en: 'doxycycline', ru: 'доксициклин' },
  'doksorubicin': { en: 'doxorubicin', ru: 'доксорубицин' },
  'duloksetin': { en: 'duloxetine', ru: 'дулоксетин' },
  'enalapril': { en: 'enalapril', ru: 'эналаприл' },
  'enoksaparin': { en: 'enoxaparin', ru: 'эноксапарин' },
  'erlotinib': { en: 'erlotinib', ru: 'эрлотиниб' },
  'eritromicin': { en: 'erythromycin', ru: 'эритромицин' },
  'escitalopram': { en: 'escitalopram', ru: 'эсциталопрам' },
  'esomeprazol': { en: 'esomeprazole', ru: 'эзомепразол' },
  'estradiol': { en: 'estradiol', ru: 'эстрадиол' },
  'etinilestradiol': { en: 'ethinylestradiol', ru: 'этинилэстрадиол' },
  'felodipin': { en: 'felodipine', ru: 'фелодипин' },
  'fentanil': { en: 'fentanyl', ru: 'фентанил' },
  'flukonazol': { en: 'fluconazole', ru: 'флуконазол' },
  'fluoksetin': { en: 'fluoxetine', ru: 'флуоксетин' },
  'flutikazon': { en: 'fluticasone', ru: 'флутиказон' },
  'formoterol': { en: 'formoterol', ru: 'формотерол' },
  'furosemid': { en: 'furosemide', ru: 'фуросемид' },
  'gabapentin': { en: 'gabapentin', ru: 'габапентин' },
  'gemcitabin': { en: 'gemcitabine', ru: 'гемцитабин' },
  'gentamicin': { en: 'gentamicin', ru: 'гентамицин' },
  'glibenklamid': { en: 'glibenclamide', ru: 'глибенкламид' },
  'gliklazid': { en: 'gliclazide', ru: 'гликлазид' },
  'glimepirid': { en: 'glimepiride', ru: 'глимепирид' },
  'glukoza': { en: 'glucose', ru: 'глюкоза' },
  'haloperidol': { en: 'haloperidol', ru: 'галоперидол' },
  'heparin': { en: 'heparin', ru: 'гепарин' },
  'hidrohlortiazid': { en: 'hydrochlorothiazide', ru: 'гидрохлоротиазид' },
  'hidrokortizon': { en: 'hydrocortisone', ru: 'гидрокортизон' },
  'imatinib': { en: 'imatinib', ru: 'иматиниб' },
  'indapamid': { en: 'indapamide', ru: 'индапамид' },
  'insulin': { en: 'insulin', ru: 'инсулин' },
  'insulin aspart': { en: 'insulin aspart', ru: 'инсулин аспарт' },
  'insulin detemir': { en: 'insulin detemir', ru: 'инсулин детемир' },
  'insulin glargin': { en: 'insulin glargine', ru: 'инсулин гларгин' },
  'insulin lispro': { en: 'insulin lispro', ru: 'инсулин лизпро' },
  'irbesartan': { en: 'irbesartan', ru: 'ирбесартан' },
  'irinotekan': { en: 'irinotecan', ru: 'иринотекан' },
  'izoniazid': { en: 'isoniazid', ru: 'изониазид' },
  'kalcijum': { en: 'calcium', ru: 'кальций' },
  'kalcijum hlorid': { en: 'calcium chloride', ru: 'кальция хлорид' },
  'kalijum': { en: 'potassium', ru: 'калий' },
  'kalijum hlorid': { en: 'potassium chloride', ru: 'калия хлорид' },
  'karbamazepin': { en: 'carbamazepine', ru: 'карбамазепин' },
  'karvedilol': { en: 'carvedilol', ru: 'карведилол' },
  'ketoprofen': { en: 'ketoprofen', ru: 'кетопрофен' },
  'klaritromicin': { en: 'clarithromycin', ru: 'кларитромицин' },
  'klindamicin': { en: 'clindamycin', ru: 'клиндамицин' },
  'klobetazol': { en: 'clobetasol', ru: 'клобетазол' },
  'klomifen': { en: 'clomifene', ru: 'кломифен' },
  'klonazepam': { en: 'clonazepam', ru: 'клоназепам' },
  'klopidogrel': { en: 'clopidogrel', ru: 'клопидогрел' },
  'klotrimazol': { en: 'clotrimazole', ru: 'клотримазол' },
  'klozapin': { en: 'clozapine', ru: 'клозапин' },
  'kodein': { en: 'codeine', ru: 'кодеин' },
  'lamotrigin': { en: 'lamotrigine', ru: 'ламотриджин' },
  'lansoprazol': { en: 'lansoprazole', ru: 'лансопразол' },
  'leflunomid': { en: 'leflunomide', ru: 'лефлуномид' },
  'letrozol': { en: 'letrozole', ru: 'летрозол' },
  'levetiracetam': { en: 'levetiracetam', ru: 'леветирацетам' },
  'levofloksacin': { en: 'levofloxacin', ru: 'левофлоксацин' },
  'levotiroksin': { en: 'levothyroxine', ru: 'левотироксин' },
  'lidokain': { en: 'lidocaine', ru: 'лидокаин' },
  'lisinopril': { en: 'lisinopril', ru: 'лизиноприл' },
  'litijum': { en: 'lithium', ru: 'литий' },
  'lorazepam': { en: 'lorazepam', ru: 'лоразепам' },
  'losartan': { en: 'losartan', ru: 'лозартан' },
  'magnezijum': { en: 'magnesium', ru: 'магний' },
  'magnezijum sulfat': { en: 'magnesium sulfate', ru: 'магния сульфат' },
  'melfalan': { en: 'melphalan', ru: 'мелфалан' },
  'meloksikam': { en: 'meloxicam', ru: 'мелоксикам' },
  'metformin': { en: 'metformin', ru: 'метформин' },
  'metilfenidat': { en: 'methylphenidate', ru: 'метилфенидат' },
  'metilprednizolon': { en: 'methylprednisolone', ru: 'метилпреднизолон' },
  'metoklopramid': { en: 'metoclopramide', ru: 'метоклопрамид' },
  'metoprolol': { en: 'metoprolol', ru: 'метопролол' },
  'metotreksat': { en: 'methotrexate', ru: 'метотрексат' },
  'metronidazol': { en: 'metronidazole', ru: 'метронидазол' },
  'mikonazol': { en: 'miconazole', ru: 'миконазол' },
  'moksonidin': { en: 'moxonidine', ru: 'моксонидин' },
  'moksifoksacin': { en: 'moxifloxacin', ru: 'моксифлоксацин' },
  'montelukast': { en: 'montelukast', ru: 'монтелукаст' },
  'morfin': { en: 'morphine', ru: 'морфин' },
  'mometazon': { en: 'mometasone', ru: 'мометазон' },
  'naproksen': { en: 'naproxen', ru: 'напроксен' },
  'natrijum': { en: 'sodium', ru: 'натрий' },
  'natrijum hlorid': { en: 'sodium chloride', ru: 'натрия хлорид' },
  'natrijum acetat': { en: 'sodium acetate', ru: 'натрия ацетат' },
  'natrijum glicerofosfat': { en: 'sodium glycerophosphate', ru: 'натрия глицерофосфат' },
  'nebivolol': { en: 'nebivolol', ru: 'небиволол' },
  'nifedipin': { en: 'nifedipine', ru: 'нифедипин' },
  'nikotin': { en: 'nicotine', ru: 'никотин' },
  'nitroglicerin': { en: 'nitroglycerin', ru: 'нитроглицерин' },
  'noradrenalin': { en: 'norepinephrine', ru: 'норэпинефрин' },
  'oksaliplatina': { en: 'oxaliplatin', ru: 'оксалиплатин' },
  'okskarbazepin': { en: 'oxcarbazepine', ru: 'окскарбазепин' },
  'oksikodon': { en: 'oxycodone', ru: 'оксикодон' },
  'omeprazol': { en: 'omeprazole', ru: 'омепразол' },
  'ondansetron': { en: 'ondansetron', ru: 'ондансетрон' },
  'paklitaksel': { en: 'paclitaxel', ru: 'паклитаксел' },
  'pantoprazol': { en: 'pantoprazole', ru: 'пантопразол' },
  'piroksikam': { en: 'piroxicam', ru: 'пироксикам' },
  'pravastatin': { en: 'pravastatin', ru: 'правастатин' },
  'prednizolon': { en: 'prednisolone', ru: 'преднизолон' },
  'prednizon': { en: 'prednisone', ru: 'преднизон' },
  'pregabalin': { en: 'pregabalin', ru: 'прегабалин' },
  'progesteron': { en: 'progesterone', ru: 'прогестерон' },
  'propofol': { en: 'propofol', ru: 'пропофол' },
  'propranolol': { en: 'propranolol', ru: 'пропранолол' },
  'rabeprazol': { en: 'rabeprazole', ru: 'рабепразол' },
  'ramipril': { en: 'ramipril', ru: 'рамиприл' },
  'ranitidin': { en: 'ranitidine', ru: 'ранитидин' },
  'rifampicin': { en: 'rifampicin', ru: 'рифампицин' },
  'risperidon': { en: 'risperidone', ru: 'рисперидон' },
  'ritonavir': { en: 'ritonavir', ru: 'ритонавир' },
  'rituximab': { en: 'rituximab', ru: 'ритуксимаб' },
  'rivaroksaban': { en: 'rivaroxaban', ru: 'ривароксабан' },
  'rosuvastatin': { en: 'rosuvastatin', ru: 'розувастатин' },
  'salbutamol': { en: 'salbutamol', ru: 'сальбутамол' },
  'salmeterol': { en: 'salmeterol', ru: 'салметерол' },
  'sertralin': { en: 'sertraline', ru: 'сертралин' },
  'sildenafil': { en: 'sildenafil', ru: 'силденафил' },
  'simvastatin': { en: 'simvastatin', ru: 'симвастатин' },
  'sirolimus': { en: 'sirolimus', ru: 'сиролимус' },
  'spironolakton': { en: 'spironolactone', ru: 'спиронолактон' },
  'sulfasalazin': { en: 'sulfasalazine', ru: 'сульфасалазин' },
  'sumatriptan': { en: 'sumatriptan', ru: 'суматриптан' },
  'takrolimus': { en: 'tacrolimus', ru: 'такролимус' },
  'tamoksifen': { en: 'tamoxifen', ru: 'тамоксифен' },
  'tamsulosin': { en: 'tamsulosin', ru: 'тамсулозин' },
  'telmisartan': { en: 'telmisartan', ru: 'телмисартан' },
  'tenofovir': { en: 'tenofovir', ru: 'тенофовир' },
  'testosteron': { en: 'testosterone', ru: 'тестостерон' },
  'tiotropijum': { en: 'tiotropium', ru: 'тиотропий' },
  'tramadol': { en: 'tramadol', ru: 'трамадол' },
  'trastuzumab': { en: 'trastuzumab', ru: 'трастузумаб' },
  'valsartan': { en: 'valsartan', ru: 'валсартан' },
  'vankomicin': { en: 'vancomycin', ru: 'ванкомицин' },
  'varfarin': { en: 'warfarin', ru: 'варфарин' },
  'venlafaksin': { en: 'venlafaxine', ru: 'венлафаксин' },
  'verapamil': { en: 'verapamil', ru: 'верапамил' },
  'vinkristin': { en: 'vincristine', ru: 'винкристин' },
  'vitamin d3': { en: 'vitamin D3', ru: 'витамин D3' },
  'zolpidem': { en: 'zolpidem', ru: 'золпидем' },
  'gvožđe': { en: 'iron', ru: 'железо' },
  'gvožđe (iii) hidroksid polimaltozni kompleks': { en: 'iron(III) hydroxide polymaltose complex', ru: 'железа(III) гидроксид полимальтозный комплекс' },
  'albumin': { en: 'albumin', ru: 'альбумин' },
  'alanin': { en: 'alanine', ru: 'аланин' },
  'arginin': { en: 'arginine', ru: 'аргинин' },
  'asparaginska kiselina': { en: 'aspartic acid', ru: 'аспарагиновая кислота' },
  'glutaminska kiselina': { en: 'glutamic acid', ru: 'глутаминовая кислота' },
  'glicin': { en: 'glycine', ru: 'глицин' },
  'histidin': { en: 'histidine', ru: 'гистидин' },
  'izoleucin': { en: 'isoleucine', ru: 'изолейцин' },
  'leucin': { en: 'leucine', ru: 'лейцин' },
  'lizin': { en: 'lysine', ru: 'лизин' },
  'metionin': { en: 'methionine', ru: 'метионин' },
  'fenilalanin': { en: 'phenylalanine', ru: 'фенилаланин' },
  'prolin': { en: 'proline', ru: 'пролин' },
  'serin': { en: 'serine', ru: 'серин' },
  'treonin': { en: 'threonine', ru: 'треонин' },
  'triptofan': { en: 'tryptophan', ru: 'триптофан' },
  'tirozin': { en: 'tyrosine', ru: 'тирозин' },
  'valin': { en: 'valine', ru: 'валин' },
  'voda za injekciju': { en: 'water for injection', ru: 'вода для инъекций' },
  'prečišćeno sojino ulje': { en: 'purified soy oil', ru: 'масло соевое очищенное' },
};

// ═══════════════════════════════════════════════════════════════════════════
// INN suffix rules: Serbian → English
// Ordered longest-first to avoid partial matches
// ═══════════════════════════════════════════════════════════════════════════

const EN_SUFFIX_RULES = [
  // Antibiotics
  [/ciklin$/i, 'cycline'],       // doksiciklin → doxycycline
  [/cilin$/i, 'cillin'],         // amoksicilin → amoxicillin
  [/micin$/i, 'mycin'],          // azitromicin → azithromycin
  [/floksacin$/i, 'floxacin'],   // ciprofloksacin → ciprofloxacin
  // Proton pump inhibitors
  [/prazol$/i, 'prazole'],       // omeprazol → omeprazole
  // Azoles
  [/nazol$/i, 'nazole'],         // flukonazol → fluconazole
  [/idazol$/i, 'idazole'],       // metronidazol → metronidazole
  [/tazol$/i, 'tasol'],          // klobetazol → clobetasol
  [/kazol$/i, 'casol'],
  // Beta blockers (-lol stays same mostly)
  // ACE inhibitors (-pril stays same)
  // ARBs (-sartan stays same)
  // Statins (-statin stays same)
  // -pine group
  [/dipin$/i, 'dipine'],         // amlodipin → amlodipine
  [/zapin$/i, 'zapine'],         // klozapin → clozapine
  [/zepin$/i, 'zepine'],         // karbamazepin → carbamazepine
  // -one group
  [/tizon$/i, 'tisone'],         // flutikazon → fluticasone
  [/tazon$/i, 'tasone'],         // mometazon → mometasone
  [/metazon$/i, 'methasone'],    // deksametazon → dexamethasone
  [/izolon$/i, 'isolone'],       // prednizolon → prednisolone
  [/nizon$/i, 'nisone'],
  [/lakton$/i, 'lactone'],       // spironolakton → spironolactone
  [/peron$/i, 'perone'],
  [/ridon$/i, 'ridone'],         // risperidon → risperidone
  [/setron$/i, 'setron'],
  [/ksetin$/i, 'xetine'],        // fluoksetin → fluoxetine
  [/loksetin$/i, 'loxetine'],
  // -ide group
  [/amid$/i, 'amide'],           // furosemid → furosemide
  [/amid $/i, 'amide'],
  [/klamid$/i, 'clamide'],
  // -ine group
  [/kain$/i, 'caine'],           // lidokain → lidocaine
  [/tidin$/i, 'tidine'],         // ranitidin → ranitidine
  [/nidin$/i, 'nidine'],
  [/trigin$/i, 'trigine'],       // lamotrigin → lamotrigine
  [/selin$/i, 'seline'],
  [/oksin$/i, 'oxine'],
  // Generic endings
  [/ksaban$/i, 'xaban'],         // rivaroksaban → rivaroxaban
  [/faksin$/i, 'faxine'],        // venlafaksin → venlafaxine
  [/taksel$/i, 'taxel'],         // paklitaksel → paclitaxel
  [/treksat$/i, 'trexate'],      // metotreksat → methotrexate
  [/oza$/i, 'ose'],              // glukoza → glucose, dekstroza → dextrose
];

// Character-level substitution patterns for INN
const EN_CHAR_RULES = [
  [/ks/g, 'x'],                  // oksaliplatina → oxaliplatin
  [/ciklo/gi, 'cyclo'],          // ciklofosfamid → cyclophosphamide
  [/(?<![s])cin(?!e)/gi, 'cine'],// vinkristin → vincristine (but not clindamycin)
  [/tio/gi, 'thio'],             // tiotropijum → thiotropium... hmm, actually tio- stays
];

// Word-level replacements
const EN_WORD_MAP = {
  'gvožđe': 'iron', 'kalcijum': 'calcium', 'kalijum': 'potassium',
  'natrijum': 'sodium', 'magnezijum': 'magnesium', 'aluminijum': 'aluminium',
  'cink': 'zinc', 'litijum': 'lithium', 'barijum': 'barium',
  'hidroksid': 'hydroxide', 'hlorid': 'chloride', 'sulfat': 'sulfate',
  'karbonat': 'carbonate', 'acetat': 'acetate', 'fosfat': 'phosphate',
  'oksid': 'oxide', 'bromid': 'bromide', 'nitrat': 'nitrate',
  'citrat': 'citrate', 'laktat': 'lactate', 'sukcinat': 'succinate',
  'fumarat': 'fumarate', 'tartarat': 'tartrate', 'glukonat': 'gluconate',
  'glicerofosfat': 'glycerophosphate', 'bikarbonat': 'bicarbonate',
  'kompleks': 'complex', 'polimaltozni': 'polymaltose',
  'monohidrat': 'monohydrate', 'dihidrat': 'dihydrate',
  'trihidrat': 'trihydrate', 'bezodni': 'anhydrous',
  'prečišćeno': 'purified', 'sojino': 'soy', 'ulje': 'oil',
  'humani': 'human', 'rekombinantni': 'recombinant',
  'vakcina': 'vaccine', 'konjugovana': 'conjugated',
  '(iii)': '(III)', '(ii)': '(II)',
};

// ═══════════════════════════════════════════════════════════════════════════
// Russian pharmaceutical transliteration (beyond simple char mapping)
// ═══════════════════════════════════════════════════════════════════════════

const RU_WORD_MAP = {
  'gvožđe': 'железо', 'kalcijum': 'кальций', 'kalijum': 'калий',
  'natrijum': 'натрий', 'magnezijum': 'магний', 'aluminijum': 'алюминий',
  'cink': 'цинк', 'litijum': 'литий', 'barijum': 'барий',
  'hidroksid': 'гидроксид', 'hlorid': 'хлорид', 'sulfat': 'сульфат',
  'karbonat': 'карбонат', 'acetat': 'ацетат', 'fosfat': 'фосфат',
  'oksid': 'оксид', 'bromid': 'бромид', 'nitrat': 'нитрат',
  'citrat': 'цитрат', 'laktat': 'лактат', 'sukcinat': 'сукцинат',
  'fumarat': 'фумарат', 'tartarat': 'тартрат', 'glukonat': 'глюконат',
  'glicerofosfat': 'глицерофосфат', 'bikarbonat': 'бикарбонат',
  'kompleks': 'комплекс', 'polimaltozni': 'полимальтозный',
  'monohidrat': 'моногидрат', 'dihidrat': 'дигидрат',
  'trihidrat': 'тригидрат', 'bezodni': 'безводный',
  'prečišćeno': 'очищенное', 'sojino': 'соевое', 'ulje': 'масло',
  'humani': 'человеческий', 'rekombinantni': 'рекомбинантный',
  'vakcina': 'вакцина', 'konjugovana': 'конъюгированная',
  '(iii)': '(III)', '(ii)': '(II)',
  'voda': 'вода', 'za': 'для', 'injekciju': 'инъекций',
};

const RU_SUFFIX_RULES = [
  [/ciklin$/i, 'циклин'],
  [/cilin$/i, 'циллин'],
  [/micin$/i, 'мицин'],
  [/floksacin$/i, 'флоксацин'],
  [/prazol$/i, 'празол'],
  [/nazol$/i, 'назол'],
  [/idazol$/i, 'идазол'],
  [/statin$/i, 'статин'],
  [/sartan$/i, 'сартан'],
  [/dipin$/i, 'дипин'],
  [/pril$/i, 'прил'],
  [/olol$/i, 'олол'],
  [/ksaban$/i, 'ксабан'],
  [/lukast$/i, 'лукаст'],
  [/triptan$/i, 'триптан'],
  [/fibrat$/i, 'фибрат'],
  [/setron$/i, 'сетрон'],
  [/mab$/i, 'маб'],
  [/nib$/i, 'ниб'],
  [/lib$/i, 'либ'],
  [/tid$/i, 'тид'],
  [/vir$/i, 'вир'],
  [/mus$/i, 'мус'],
];

// ═══════════════════════════════════════════════════════════════════════════
// Translation functions
// ═══════════════════════════════════════════════════════════════════════════

function toEnglish(src) {
  // 1. Check dictionary
  const dictKey = src.toLowerCase();
  if (DICT[dictKey]) return DICT[dictKey].en;

  let result = src;

  // 2. Word-level replacements
  for (const [sr, en] of Object.entries(EN_WORD_MAP)) {
    const re = new RegExp(sr.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi');
    result = result.replace(re, en);
  }

  // 3. Suffix rules
  for (const [pattern, replacement] of EN_SUFFIX_RULES) {
    if (pattern.test(result)) {
      result = result.replace(pattern, replacement);
      break; // Only apply first matching suffix
    }
  }

  // 4. Remove diacritics
  result = result
    .replace(/đ/g, 'dj').replace(/Đ/g, 'Dj')
    .replace(/š/g, 'sh').replace(/Š/g, 'Sh')
    .replace(/č/g, 'ch').replace(/Č/g, 'Ch')
    .replace(/ć/g, 'c').replace(/Ć/g, 'C')
    .replace(/ž/g, 'zh').replace(/Ž/g, 'Zh');

  return result;
}

function toRussian(src) {
  // 1. Check dictionary
  const dictKey = src.toLowerCase();
  if (DICT[dictKey]) return DICT[dictKey].ru;

  // 2. Word-level
  let result = src;
  for (const [sr, ru] of Object.entries(RU_WORD_MAP)) {
    const re = new RegExp(sr.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'gi');
    result = result.replace(re, ru);
  }

  // If all words were replaced (no Latin chars left), return
  if (!/[a-zA-ZčćšžđČĆŠŽĐ]/.test(result)) return result;

  // 3. Try suffix rules on remaining Latin parts
  const parts = result.split(/(\s+)/);
  const mapped = parts.map(part => {
    if (!/[a-zA-ZčćšžđČĆŠŽĐ]/.test(part)) return part;

    // Apply suffix rules
    for (const [pattern, replacement] of RU_SUFFIX_RULES) {
      if (pattern.test(part)) {
        const base = part.replace(pattern, '');
        return toSrCyrl(base).replace(/ј$/,'й') + replacement;
      }
    }

    // Fallback: simple transliteration to Russian-style Cyrillic
    return toSrCyrl(part)
      .replace(/ј/g, 'й')
      .replace(/љ/g, 'ль')
      .replace(/њ/g, 'нь')
      .replace(/ђ/g, 'дж')
      .replace(/ћ/g, 'ч')
      .replace(/џ/g, 'дж');
  });

  return mapped.join('');
}

// ═══════════════════════════════════════════════════════════════════════════
// Main
// ═══════════════════════════════════════════════════════════════════════════

const substances = JSON.parse(readFileSync(resolve(ROOT, 'data/substances-list.json'), 'utf-8'))
  .filter(s => !/^\d+\)?$/.test(s) && s.length >= 3);

console.log(`Generating translations for ${substances.length} substances...\n`);

let batchNum = 0, totalWritten = 0;

for (let i = 0; i < substances.length; i += BATCH_SIZE) {
  batchNum++;
  const batch = substances.slice(i, i + BATCH_SIZE);
  const fileName = `batch-${String(batchNum).padStart(3, '0')}.json`;
  const en_translations = batch.map(src => {
    const en = toEnglish(src);
    const ru = toRussian(src);
    return {
      src,
      en,
      sr: src,
      sr_cyrl: toSrCyrl(src),
      ru,
      de: en,  // German pharma mostly uses international INN
      tr: en,  // Turkish pharma mostly uses international INN
    };
  });

  writeFileSync(resolve(OUT_DIR, fileName), JSON.stringify(en_translations, null, 2), 'utf-8');
  totalWritten += batch.length;
  console.log(`  ${fileName}: ${batch.length} items`);
}

console.log(`\n✓ ${totalWritten} substances in ${batchNum} batches`);

// Quality check
let dictHits = 0, suffixHits = 0, unchanged = 0;
for (const src of substances) {
  const en = toEnglish(src);
  if (DICT[src.toLowerCase()]) dictHits++;
  else if (en !== src) suffixHits++;
  else unchanged++;
}
console.log(`\nQuality: ${dictHits} dict hits, ${suffixHits} rule-based, ${unchanged} unchanged (${(unchanged/substances.length*100).toFixed(0)}%)`);

// Samples
console.log('\nSamples:');
const samples = ['paracetamol','amoksicilin','ciprofloksacin','omeprazol','deksametazon','flukonazol','lamotrigin','venlafaksin','gvožđe (iii) hidroksid polimaltozni kompleks','acetilsalicilna kiselina'];
for (const s of samples) {
  if (!substances.includes(s)) continue;
  console.log(`  ${s}`);
  console.log(`    en: ${toEnglish(s)}`);
  console.log(`    ru: ${toRussian(s)}`);
}
