// Категория лекарственной формы по стабильному med_pharma_forms.id (не по тексту).
// Определяет иконку (MedicineFormIcon) и сопоставление форм (formMatch) во всём
// каталоге лекарств. Карта сгенерирована из med_pharma_forms и выверяется вручную
// (правь здесь при добавлении форм в справочник). См. также enums/dispensing-mode.ts.
import type { MedicineFormCategory } from '~/common/medicine-form-icon';

// med_pharma_forms.id → категория формы
export const PHARMA_FORM_CATEGORY: Record<number, MedicineFormCategory> = {
	1: 'other', // BEZ ŠEĆERA
	2: 'tablet', // Disperzibilna tableta
	3: 'injection', // Disperzija za injekciju
	4: 'injection', // Emulzija za infuziju
	5: 'injection', // Emulzija za injekciju/infuziju
	6: 'tablet', // Film tableta
	7: 'tablet', // Film tableta sa modifikovanim oslobađanjem
	8: 'capsule', // Gastrorezistentna kapsula, tvrda
	9: 'tablet', // Gastrorezistentna tableta
	10: 'topical', // Gel
	11: 'topical', // Gel za oči
	12: 'powder', // Granule
	13: 'capsule', // Granule u kapsulama za otvaranje
	14: 'syrup', // Granule za oralni rastvor
	15: 'syrup', // Granule za oralnu suspenziju
	16: 'injection', // Implant u napunjenom injekcionom špricu
	17: 'other', // Intrauterini dostavni sistem
	18: 'drops', // Kapi za nos, rastvor
	19: 'drops', // Kapi za oči, rastvor
	20: 'drops', // Kapi za oči, suspenzija
	21: 'drops', // Kapi za uši, rastvor
	22: 'drops', // Kapi za uši, rastvor u jednodoznom kontejneru
	23: 'drops', // Kapi za uši/oči, rastvor
	24: 'capsule', // Kapsula
	25: 'capsule', // Kapsula sa modifikovanim oslobađanjem, tvrda
	26: 'capsule', // Kapsula sa produženim oslobađanjem, tvrda
	27: 'capsule', // Kapsula, meka
	28: 'capsule', // Kapsula, tvrda
	29: 'tablet', // Komprimovana lozenga
	30: 'injection', // Koncentrat i rastvarač za rastvor za infuziju
	31: 'injection', // Koncentrat za disperziju za infuziju
	32: 'injection', // Koncentrat za disperziju za injekciju
	33: 'syrup', // Koncentrat za oralni rastvor
	34: 'injection', // Koncentrat za rastvor za infuziju
	35: 'injection', // Koncentrat za rastvor za injekciju/infuziju
	36: 'topical', // Krem
	37: 'injection', // Liofilizat za rastvor za infuziju
	38: 'injection', // Liofilizat za rastvor za injekciju sa rastvaračem za parenteralnu upotrebu
	39: 'tablet', // Ljekovita guma za žvakanje
	40: 'topical', // Ljekoviti lak za nokte
	41: 'tablet', // Lozenga
	42: 'topical', // Mast
	43: 'topical', // Mast za oči
	44: 'other', // Matriks sa lijepkom za tkivo
	45: 'other', // Medicinski gas, djelimično tečni
	46: 'other', // Medicinski gas, komprimovani
	47: 'tablet', // Obložena tableta
	48: 'tablet', // Oralna disperzibilna tableta
	49: 'syrup', // Oralna suspenzija
	50: 'drops', // Oralne kapi, emulzija
	51: 'drops', // Oralne kapi, rastvor
	52: 'topical', // Oralni gel
	53: 'syrup', // Oralni liofilizat
	54: 'powder', // Oralni prašak
	55: 'syrup', // Oralni rastvor
	56: 'spray', // Oralni rastvor/koncentrat za rastvor za raspršivanje
	57: 'spray', // Para za inhalaciju, tečnost
	58: 'tablet', // Pastila
	59: 'other', // Pjena za kožu
	60: 'injection', // Prašak i rastvarac za koncentrat za rastvor za infuziju
	61: 'injection', // Prašak i rastvarač za rastvor za infuziju
	62: 'injection', // Prašak i rastvarač za rastvor za injekciju
	63: 'injection', // Prašak i rastvarač za rastvor za injekciju u napunjenom injekcionom penu
	64: 'injection', // Prašak i rastvarač za rastvor za injekciju u penu sa uloškom
	65: 'injection', // Prašak i rastvarač za rastvor za injekciju/infuziju
	66: 'topical', // Prašak i rastvarač za rastvor za kožu
	67: 'injection', // Prašak i rastvarač za suspenziju za injekciju
	68: 'injection', // Prašak i rastvarač za suspenziju za injekciju sa produženim oslobađanjem
	69: 'injection', // Prašak i rastvarač za suspenziju za injekciju u napunjenom injekcionom špricu
	70: 'injection', // Prašak i suspenzija za suspenziju za injekciju
	71: 'injection', // Prašak i suspenzija za suspenziju za injekciju u napunjenom injekcionom špricu
	72: 'injection', // Prašak za disperziju za infuziju
	73: 'spray', // Prašak za inhalaciju
	74: 'spray', // Prašak za inhalaciju, podijeljen
	75: 'spray', // Prašak za inhalaciju, tvrda kapsula
	76: 'injection', // Prašak za injekciju
	77: 'powder', // Prašak za intravezikalni rastvor
	78: 'injection', // Prašak za koncentrat za rastvor za infuziju
	79: 'injection', // Prašak za koncentrat za rastvor za injekciju/infuziju
	80: 'powder', // Prašak za kožu
	81: 'syrup', // Prašak za oralni rastvor
	82: 'syrup', // Prašak za oralni rastvor u kesici
	83: 'syrup', // Prašak za oralnu suspenziju
	84: 'injection', // Prašak za rastvor za infuziju
	85: 'injection', // Prašak za rastvor za injekciju
	86: 'injection', // Prašak za rastvor za injekciju ili infuziju
	87: 'injection', // Prašak za rastvor za injekciju/infuziju
	88: 'injection', // Prašak za suspenziju za injekciju
	89: 'injection', // Rastvarač za parenteralnu upotrebu
	90: 'syrup', // Rastvor za grgljanje/ispiranje usta
	91: 'injection', // Rastvor za infuziju
	92: 'spray', // Rastvor za inhalaciju
	93: 'spray', // Rastvor za inhalaciju pod pritiskom
	94: 'injection', // Rastvor za injekciju
	95: 'injection', // Rastvor za injekciju u napunjenom injekcionom penu
	96: 'injection', // Rastvor za injekciju u napunjenom injekcionom špricu
	97: 'injection', // Rastvor za injekciju u penu sa uloškom
	98: 'injection', // Rastvor za injekciju u ulošku
	99: 'injection', // Rastvor za injekciju/infuziju
	100: 'injection', // Rastvor za injekciju/infuziju u napunjenom injekcionom špricu
	101: 'other', // Rastvor za ispiranje bešike
	102: 'syrup', // Rastvor za ispiranje usta
	103: 'topical', // Rastvor za kožu
	104: 'other', // Rastvor za peritonealnu dijalizu
	105: 'spray', // Rastvor za raspršivanje
	106: 'syrup', // Rastvor za usnu sluznicu
	107: 'topical', // Rektalna mast
	108: 'other', // Rektalna suspenzija
	109: 'syrup', // Sirup
	110: 'spray', // Sprej za kožu, prašak
	111: 'spray', // Sprej za kožu, rastvor
	112: 'spray', // Sprej za nos, rastvor
	113: 'spray', // Sprej za nos, suspenzija
	114: 'spray', // Sprej za usnu sluznicu, rastvor
	115: 'tablet', // Sublingvalna tableta
	116: 'spray', // Sublingvalni sprej, rastvor
	117: 'suppository', // Supozitorija
	118: 'spray', // Suspenzija za inhalaciju pod pritiskom
	119: 'injection', // Suspenzija za injekciju
	120: 'injection', // Suspenzija za injekciju sa produženim oslobađanjem
	121: 'injection', // Suspenzija za injekciju sa produženim oslobađanjem u napunjenom injekcionom špricu
	122: 'injection', // Suspenzija za injekciju u napunjenom injekcionom špricu
	123: 'injection', // Suspenzija za injekciju u ulošku
	124: 'spray', // Suspenzija za raspršivanje
	125: 'tablet', // Tableta
	126: 'tablet', // Tableta sa modifikovanim oslobađanjem
	127: 'tablet', // Tableta sa produženim oslobađanjem
	128: 'tablet', // Tableta za oralnu suspenziju
	129: 'tablet', // Tableta za žvakanje
	130: 'tablet', // Tableta za žvakanje/oralnu disperziju
	131: 'patch', // Transdermalni flaster
	132: 'spray', // Transdermalni sprej, rastvor
	133: 'capsule', // Vaginalna kapsula, meka
	134: 'capsule', // Vaginalna kapsula, tvrda
	135: 'tablet', // Vaginalna tableta
	136: 'topical', // Vaginalni krem
	137: 'suppository', // Vagitorija
	138: 'other', // blister
	139: 'capsule', // kapsula tvrda
	140: 'injection', // prašak za koncentrat za rastvor za injekciju
	141: 'injection', // rastvor za injekciju u napunjenom injekcijonom špricu
	143: 'spray', // sprej za kožu
	144: 'injection', // suspenzija za injekciju u penu sa uloškom
	145: 'other', // tvrda
	146: 'topical', // Šampon
	147: 'tablet', // Šumeća tableta
	148: 'powder', // Šumeće granule
};

// Категория по id формы (fallback 'other' для неизвестных/отсутствующих).
export function getPharmaFormCategory(
	formId: number | null | undefined,
): MedicineFormCategory {
	if (formId == null) return 'other';
	return PHARMA_FORM_CATEGORY[formId] || 'other';
}
