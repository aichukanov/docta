import { LabTest } from '~/enums/lab-test';

export default {
	messages: {
		en: {
			// Hematology
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT}`]: 'Complete Blood Count',
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT_WITH_LEUKOCYTE_FORMULA}`]:
				'Complete Blood Count with Leukocyte Formula',
			[`lab_test_${LabTest.SEDIMENTATION_RATE}`]: 'Sedimentation Rate',
			[`lab_test_${LabTest.LEUKOCYTE_FORMULA}`]: 'Leukocyte Formula',
			[`lab_test_${LabTest.RETICULOCYTES}`]: 'Reticulocytes',
			[`lab_test_${LabTest.PLATELETS}`]: 'Platelets',
			[`lab_test_${LabTest.BLOOD_GROUP}`]: 'Blood Group',

			// Coagulation
			[`lab_test_${LabTest.FIBRINOGEN}`]: 'Fibrinogen',
			[`lab_test_${LabTest.BLEEDING_TIME}`]: 'Bleeding Time',
			[`lab_test_${LabTest.COAGULATION_TIME}`]: 'Coagulation Time',
			[`lab_test_${LabTest.ACTIVATED_PARTIAL_THROMBOPLASTIN_TIME}`]:
				'Activated Partial Thromboplastin Time (aPTT)',
			[`lab_test_${LabTest.D_DIMER}`]: 'D-Dimer',
			[`lab_test_${LabTest.INR}`]: 'INR',

			// Biochemistry
			[`lab_test_${LabTest.GLUCOSE}`]: 'Glucose',
			[`lab_test_${LabTest.HBA1C}`]: 'HbA1c',
			[`lab_test_${LabTest.CHOLESTEROL}`]: 'Cholesterol',
			[`lab_test_${LabTest.HDL_CHOLESTEROL}`]: 'HDL Cholesterol',
			[`lab_test_${LabTest.LDL_CHOLESTEROL}`]: 'LDL Cholesterol',
			[`lab_test_${LabTest.TRIGLYCERIDES}`]: 'Triglycerides',
			[`lab_test_${LabTest.CREATININE}`]: 'Creatinine',
			[`lab_test_${LabTest.UREA}`]: 'Urea',
			[`lab_test_${LabTest.URIC_ACID}`]: 'Uric Acid',
			[`lab_test_${LabTest.TOTAL_PROTEIN}`]: 'Total Protein',
			[`lab_test_${LabTest.ALBUMIN}`]: 'Albumin',
			[`lab_test_${LabTest.TOTAL_BILIRUBIN}`]: 'Total Bilirubin',
			[`lab_test_${LabTest.DIRECT_BILIRUBIN}`]: 'Direct Bilirubin',
			[`lab_test_${LabTest.AST}`]: 'AST (SGOT)',
			[`lab_test_${LabTest.ALT}`]: 'ALT (SGPT)',
			[`lab_test_${LabTest.GAMMA_GT}`]: 'Gamma-GT',
			[`lab_test_${LabTest.ALKALINE_PHOSPHATASE}`]: 'Alkaline Phosphatase',
			[`lab_test_${LabTest.AMYLASE}`]: 'Amylase',
			[`lab_test_${LabTest.LIPASE}`]: 'Lipase',
			[`lab_test_${LabTest.CK}`]: 'Creatine Kinase (CK)',
			[`lab_test_${LabTest.CK_MB}`]: 'CK-MB',
			[`lab_test_${LabTest.LDH}`]: 'LDH',

			// Electrolytes
			[`lab_test_${LabTest.SODIUM}`]: 'Sodium',
			[`lab_test_${LabTest.POTASSIUM}`]: 'Potassium',
			[`lab_test_${LabTest.CALCIUM}`]: 'Calcium',
			[`lab_test_${LabTest.IONIZED_CALCIUM}`]: 'Ionized Calcium',
			[`lab_test_${LabTest.MAGNESIUM}`]: 'Magnesium',
			[`lab_test_${LabTest.PHOSPHORUS}`]: 'Phosphorus',
			[`lab_test_${LabTest.CHLORIDE}`]: 'Chloride',
			[`lab_test_${LabTest.IRON}`]: 'Iron',
			[`lab_test_${LabTest.FERRITIN}`]: 'Ferritin',

			// Hormones
			[`lab_test_${LabTest.TSH}`]: 'TSH',
			[`lab_test_${LabTest.T3}`]: 'T3',
			[`lab_test_${LabTest.T4}`]: 'T4',
			[`lab_test_${LabTest.FREE_T3}`]: 'Free T3',
			[`lab_test_${LabTest.FREE_T4}`]: 'Free T4',
			[`lab_test_${LabTest.CORTISOL}`]: 'Cortisol',
			[`lab_test_${LabTest.TESTOSTERONE}`]: 'Testosterone',
			[`lab_test_${LabTest.ESTRADIOL}`]: 'Estradiol',
			[`lab_test_${LabTest.PROGESTERONE}`]: 'Progesterone',
			[`lab_test_${LabTest.PROLACTIN}`]: 'Prolactin',
			[`lab_test_${LabTest.FSH}`]: 'FSH',
			[`lab_test_${LabTest.LH}`]: 'LH',
			[`lab_test_${LabTest.INSULIN}`]: 'Insulin',
			[`lab_test_${LabTest.C_PEPTIDE}`]: 'C-Peptide',
			[`lab_test_${LabTest.PTH}`]: 'PTH',
			[`lab_test_${LabTest.VITAMIN_D_25_OH}`]: 'Vitamin D (25-OH)',
			[`lab_test_${LabTest.VITAMIN_B12}`]: 'Vitamin B12',

			// Tumor Markers
			[`lab_test_${LabTest.PSA}`]: 'PSA',
			[`lab_test_${LabTest.FREE_PSA}`]: 'Free PSA',
			[`lab_test_${LabTest.CEA}`]: 'CEA',
			[`lab_test_${LabTest.CA_125}`]: 'CA 125',
			[`lab_test_${LabTest.CA_15_3}`]: 'CA 15-3',
			[`lab_test_${LabTest.CA_19_9}`]: 'CA 19-9',
			[`lab_test_${LabTest.AFP}`]: 'AFP',

			// Inflammatory Markers
			[`lab_test_${LabTest.C_REACTIVE_PROTEIN}`]: 'C-Reactive Protein (CRP)',
			[`lab_test_${LabTest.PROCALCITONIN}`]: 'Procalcitonin',

			// Urinalysis
			[`lab_test_${LabTest.COMPLETE_URINALYSIS}`]: 'Complete Urinalysis',
			[`lab_test_${LabTest.MICROALBUMIN}`]: 'Microalbumin',

			// Infectious Diseases
			[`lab_test_${LabTest.COVID_19_PCR}`]: 'COVID-19 PCR',
			[`lab_test_${LabTest.COVID_19_ANTIGEN}`]: 'COVID-19 Antigen Test',
			[`lab_test_${LabTest.HIV_AG_AB}`]: 'HIV Ag-Ab',
			[`lab_test_${LabTest.HBSAG}`]: 'HBsAg',
			[`lab_test_${LabTest.ANTI_HCV}`]: 'Anti-HCV',

			// Additional Tests - Biochemistry & Electrolytes
			[`lab_test_${LabTest.CHOLINESTERASE}`]: 'Cholinesterase',
			[`lab_test_${LabTest.PANCREATIC_AMYLASE}`]: 'Pancreatic Amylase',
			[`lab_test_${LabTest.LIPOPROTEIN_A}`]: 'Lipoprotein(a)',
			[`lab_test_${LabTest.APOLIPOPROTEIN_B}`]: 'Apolipoprotein B',
			[`lab_test_${LabTest.INDIRECT_BILIRUBIN}`]: 'Indirect Bilirubin',
			[`lab_test_${LabTest.FRUCTOSAMINE}`]: 'Fructosamine',
			[`lab_test_${LabTest.VLDL}`]: 'VLDL Cholesterol',
			[`lab_test_${LabTest.PREALBUMIN}`]: 'Prealbumin',
			[`lab_test_${LabTest.PROSTATIC_ACID_PHOSPHATASE}`]:
				'Prostatic Acid Phosphatase',
			[`lab_test_${LabTest.ACID_PHOSPHATASE}`]: 'Acid Phosphatase',
			[`lab_test_${LabTest.EGFR}`]: 'eGFR',
			[`lab_test_${LabTest.SERUM_OSMOLALITY}`]: 'Serum Osmolality',
			[`lab_test_${LabTest.IL_6}`]: 'Interleukin-6 (IL-6)',
			[`lab_test_${LabTest.TOTAL_BILE_ACIDS}`]: 'Total Bile Acids',
			[`lab_test_${LabTest.TIBC}`]: 'TIBC (Total Iron Binding Capacity)',
			[`lab_test_${LabTest.UIBC}`]: 'UIBC (Unsaturated Iron Binding Capacity)',
			[`lab_test_${LabTest.TRANSFERRIN}`]: 'Transferrin',
			[`lab_test_${LabTest.TRANSFERRIN_SATURATION}`]: 'Transferrin Saturation',
			[`lab_test_${LabTest.ACE}`]: 'ACE (Angiotensin Converting Enzyme)',
			[`lab_test_${LabTest.ALPHA_1_ANTITRYPSIN}`]: 'Alpha-1-Antitrypsin',
			[`lab_test_${LabTest.ANTITHROMBIN_III}`]: 'Antithrombin III',
			[`lab_test_${LabTest.VALPROIC_ACID}`]: 'Valproic Acid',

			// Profiles & Panels
			[`lab_test_${LabTest.LIPID_PROFILE}`]: 'Lipid Profile',
			[`lab_test_${LabTest.PANEL_2}`]: 'Panel 2',
			[`lab_test_${LabTest.GLUCOSE_PROFILE}`]: 'Glucose Profile',
			[`lab_test_${LabTest.PANEL_3}`]: 'Panel 3',
			[`lab_test_${LabTest.PACKAGE_32}`]: 'Package 32',
			[`lab_test_${LabTest.PACKAGE_132}`]: 'Package 132',

			// Glucose Tests
			[`lab_test_${LabTest.GLUCOSE_7H}`]: 'Glucose 7 AM',
			[`lab_test_${LabTest.GLUCOSE_240_MIN}`]: 'Glucose 240 min',
			[`lab_test_${LabTest.GLUCOSE_17H}`]: 'Glucose 5 PM',
			[`lab_test_${LabTest.GLUCOSE_20H}`]: 'Glucose 8 PM',
			[`lab_test_${LabTest.ORAL_GLUCOSE_TOLERANCE_TEST}`]:
				'Oral Glucose Tolerance Test (OGTT)',
			[`lab_test_${LabTest.GLUCOSE_AFTER_180_MIN}`]: 'Glucose after 180 min',
			[`lab_test_${LabTest.GLUCOSE_AFTER_30_MIN}`]: 'Glucose after 30 min',
			[`lab_test_${LabTest.GLUCOSE_BEFORE_AND_AFTER_MEAL}`]:
				'Glucose Before and After Meal',
			[`lab_test_${LabTest.GLUCOSE_BEFORE_AND_2H_AFTER_MEAL}`]:
				'Glucose Before and 2h After Meal',
			[`lab_test_${LabTest.GLUCOSE_FROM_CAPILLARY_BLOOD}`]:
				'Glucose from Capillary Blood',

			// Urine Tests
			[`lab_test_${LabTest.EGFR_GLOMERULAR_FILTRATION_RATE}`]:
				'eGFR (Glomerular Filtration Rate)',
			[`lab_test_${LabTest.CREATININE_IN_URINE}`]: 'Creatinine in Urine',
			[`lab_test_${LabTest.CREATININE_IN_24H_URINE}`]:
				'Creatinine in 24h Urine',
			[`lab_test_${LabTest.CREATININE_CLEARANCE}`]: 'Creatinine Clearance',
			[`lab_test_${LabTest.UREA_IN_URINE}`]: 'Urea in Urine',
			[`lab_test_${LabTest.UREA_IN_24H_URINE}`]: 'Urea in 24h Urine',
			[`lab_test_${LabTest.UREA_CLEARANCE}`]: 'Urea Clearance',
			[`lab_test_${LabTest.PROTEIN_IN_URINE}`]: 'Protein in Urine',
			[`lab_test_${LabTest.PROTEIN_IN_24H_URINE}`]: 'Protein in 24h Urine',
			[`lab_test_${LabTest.AMYLASE_IN_URINE}`]: 'Amylase in Urine',
			[`lab_test_${LabTest.URIC_ACID_IN_URINE}`]: 'Uric Acid in Urine',
			[`lab_test_${LabTest.URIC_ACID_IN_24H_URINE}`]: 'Uric Acid in 24h Urine',
			[`lab_test_${LabTest.CALCIUM_IN_URINE}`]: 'Calcium in Urine',
			[`lab_test_${LabTest.CALCIUM_IN_24H_URINE}`]: 'Calcium in 24h Urine',
			[`lab_test_${LabTest.PHOSPHORUS_IN_URINE}`]: 'Phosphorus in Urine',
			[`lab_test_${LabTest.PHOSPHORUS_IN_24H_URINE}`]:
				'Phosphorus in 24h Urine',
			[`lab_test_${LabTest.MICROALBUMIN_24H}`]: 'Microalbumin 24h',
			[`lab_test_${LabTest.SODIUM_IN_24H_URINE}`]: 'Sodium in 24h Urine',
			[`lab_test_${LabTest.GLUCOSE_IN_URINE}`]: 'Glucose in Urine',
			[`lab_test_${LabTest.GLUCOSE_IN_24H_URINE}`]: 'Glucose in 24h Urine',
			[`lab_test_${LabTest.GLUCOSE_IN_FIRST_MORNING_URINE}`]:
				'Glucose in First Morning Urine',
			[`lab_test_${LabTest.GLUCOSE_IN_RANDOM_URINE}`]:
				'Glucose in Random Urine',
			[`lab_test_${LabTest.URIC_ACID_IN_FIRST_MORNING_URINE}`]:
				'Uric Acid in First Morning Urine',
			[`lab_test_${LabTest.CREATININE_IN_FIRST_MORNING_URINE}`]:
				'Creatinine in First Morning Urine',
			[`lab_test_${LabTest.PROTEIN_IN_RANDOM_URINE}`]:
				'Protein in Random Urine',
			[`lab_test_${LabTest.URINE_OSMOLALITY}`]: 'Urine Osmolality',
			[`lab_test_${LabTest.FREE_CORTISOL_IN_URINE}`]: 'Free Cortisol in Urine',
			[`lab_test_${LabTest.FREE_CORTISOL_IN_24H_URINE}`]:
				'Free Cortisol in 24h Urine',
			[`lab_test_${LabTest.CORTISOL_IN_URINE}`]: 'Cortisol in Urine',
			[`lab_test_${LabTest.CORTISOL_IN_24H_URINE}`]: 'Cortisol in 24h Urine',

			// Stool Tests
			[`lab_test_${LabTest.FECAL_OCCULT_BLOOD}`]: 'Fecal Occult Blood',
			[`lab_test_${LabTest.CALPROTECTIN}`]: 'Calprotectin',
			[`lab_test_${LabTest.LACTOFERRIN}`]: 'Lactoferrin',
			[`lab_test_${LabTest.PANCREATIC_ELASTASE_IN_STOOL}`]:
				'Pancreatic Elastase in Stool',
			[`lab_test_${LabTest.FOOD_DIGESTIBILITY}`]: 'Food Digestibility',

			// Urine Streams & Special Tests
			[`lab_test_${LabTest.URINE_FIRST_STREAM}`]: 'Urine First Stream',
			[`lab_test_${LabTest.URINE_SECOND_STREAM}`]: 'Urine Second Stream',
			[`lab_test_${LabTest.URINE_THIRD_STREAM}`]: 'Urine Third Stream',
			[`lab_test_${LabTest.PORPHOBILINOGEN}`]: 'Porphobilinogen',
			[`lab_test_${LabTest.PORPHOBILINOGEN_IN_24H_URINE}`]:
				'Porphobilinogen in 24h Urine',
			[`lab_test_${LabTest.PORPHYRINS_IN_URINE}`]: 'Porphyrins in Urine',
			[`lab_test_${LabTest.VMA}`]: 'VMA (Vanillylmandelic Acid)',
			[`lab_test_${LabTest.VMA_IN_URINE}`]: 'VMA in Urine',
			[`lab_test_${LabTest.FREE_METANEPHRINE_IN_URINE}`]:
				'Free Metanephrine in Urine',
			[`lab_test_${LabTest.HOMOVANILLIC_ACID}`]: 'Homovanillic Acid',
			[`lab_test_${LabTest.HOMOVANILLIC_ACID_IN_URINE}`]:
				'Homovanillic Acid in Urine',
			[`lab_test_${LabTest.BENCE_JONES_PROTEIN}`]: 'Bence Jones Protein',
			[`lab_test_${LabTest.METANEPHRINES}`]: 'Metanephrines',
			[`lab_test_${LabTest.METANEPHRINE_IN_URINE}`]: 'Metanephrine in Urine',
			[`lab_test_${LabTest.METANEPHRINES_IN_URINE}`]: 'Metanephrines in Urine',
			[`lab_test_${LabTest.FREE_NORMETANEPHRINE_IN_24H_URINE}`]:
				'Free Normetanephrine in 24h Urine',
			[`lab_test_${LabTest.HIAA_5}`]: '5-HIAA',
			[`lab_test_${LabTest.HIAA_5_IN_24H_URINE}`]: '5-HIAA in 24h Urine',
			[`lab_test_${LabTest.VMA_HVA_5_HIAA}`]: 'VMA, HVA, 5-HIAA',

			// Drug Testing
			[`lab_test_${LabTest.DRUG_PANEL_10}`]: 'Drug Panel 10',
			[`lab_test_${LabTest.DRUG_PANEL_5}`]: 'Drug Panel 5',
			[`lab_test_${LabTest.DRUG_PANEL_10_II}`]: 'Drug Panel 10 II',
			[`lab_test_${LabTest.DRUG_PANEL_5_NEW}`]: 'Drug Panel 5 (New)',
			[`lab_test_${LabTest.COCAINE}`]: 'Cocaine',
			[`lab_test_${LabTest.MARIJUANA}`]: 'Marijuana (THC)',
			[`lab_test_${LabTest.MORPHINE}`]: 'Morphine',
			[`lab_test_${LabTest.BENZODIAZEPINES}`]: 'Benzodiazepines',
			[`lab_test_${LabTest.PHENCYCLIDINE}`]: 'Phencyclidine (PCP)',
			[`lab_test_${LabTest.PHENCYCLIDINE_PCP}`]: 'Phencyclidine (PCP)',
			[`lab_test_${LabTest.ECSTASY}`]: 'Ecstasy (MDMA)',
			[`lab_test_${LabTest.ECSTASY_MDMA}`]: 'Ecstasy (MDMA)',
			[`lab_test_${LabTest.AMPHETAMINE}`]: 'Amphetamine',
			[`lab_test_${LabTest.METHAMPHETAMINE}`]: 'Methamphetamine',
			[`lab_test_${LabTest.CANNABINOIDS_THC}`]: 'Cannabinoids (THC)',
			[`lab_test_${LabTest.OPIATES}`]: 'Opiates',
			[`lab_test_${LabTest.METHADONE}`]: 'Methadone',
			[`lab_test_${LabTest.METHAQUALONE}`]: 'Methaqualone',
			[`lab_test_${LabTest.PROPOXYPHENE}`]: 'Propoxyphene',
			[`lab_test_${LabTest.TRICYCLIC_ANTIDEPRESSANTS}`]:
				'Tricyclic Antidepressants',
			[`lab_test_${LabTest.BARBITURATES}`]: 'Barbiturates',
			[`lab_test_${LabTest.ALCOHOL_IN_BLOOD}`]: 'Alcohol in Blood',
			[`lab_test_${LabTest.ALCOHOL_IN_URINE}`]: 'Alcohol in Urine',

			// Hormones - Extended
			[`lab_test_${LabTest.THYROGLOBULIN_ANTIBODIES}`]:
				'Thyroglobulin Antibodies',
			[`lab_test_${LabTest.THYROGLOBULIN}`]: 'Thyroglobulin',
			[`lab_test_${LabTest.ANTI_TPO}`]: 'Anti-TPO',
			[`lab_test_${LabTest.ANTI_THYROGLOBULIN_ANTIBODIES}`]:
				'Anti-Thyroglobulin Antibodies',
			[`lab_test_${LabTest.ANTI_TSHR}`]: 'Anti-TSH Receptor Antibodies',
			[`lab_test_${LabTest.ANTI_TSHR_ANTIBODIES}`]:
				'Anti-TSH Receptor Antibodies',
			[`lab_test_${LabTest.CALCITONIN}`]: 'Calcitonin',
			[`lab_test_${LabTest.T_UPTAKE}`]: 'T3 Uptake',
			[`lab_test_${LabTest.TBG_THYROID_BINDING_GLOBULIN}`]:
				'TBG (Thyroid Binding Globulin)',
			[`lab_test_${LabTest.FREE_T4_INDEX}`]: 'Free T4 Index',
			[`lab_test_${LabTest.INTACT_PTH}`]: 'Intact PTH',

			// Sex Hormones
			[`lab_test_${LabTest.PROLACTIN_9H}`]: 'Prolactin 9 AM',
			[`lab_test_${LabTest.PROLACTIN_11H}`]: 'Prolactin 11 AM',
			[`lab_test_${LabTest.PROLACTIN_13H}`]: 'Prolactin 1 PM',
			[`lab_test_${LabTest.PROLACTIN_10H}`]: 'Prolactin 10 AM',
			[`lab_test_${LabTest.MACROPROLACTIN}`]: 'Macroprolactin',
			[`lab_test_${LabTest.PROLACTIN_PROFILE}`]: 'Prolactin Profile',
			[`lab_test_${LabTest.FREE_TESTOSTERONE}`]: 'Free Testosterone',
			[`lab_test_${LabTest.FREE_TESTOSTERONE_CALCULATED}`]:
				'Free Testosterone (Calculated)',
			[`lab_test_${LabTest.BIOAVAILABLE_TESTOSTERONE}`]:
				'Bioavailable Testosterone',
			[`lab_test_${LabTest.DHEA_S}`]: 'DHEA-S',
			[`lab_test_${LabTest.SHBG}`]: 'SHBG (Sex Hormone Binding Globulin)',
			[`lab_test_${LabTest.ANDROSTENEDIONE}`]: 'Androstenedione',
			[`lab_test_${LabTest.OH_17_PROGESTERONE}`]: '17-OH Progesterone',
			[`lab_test_${LabTest.HYDROXYPROGESTERONE_17}`]: '17-Hydroxyprogesterone',
			[`lab_test_${LabTest.DIHYDROTESTOSTERONE}`]: 'Dihydrotestosterone (DHT)',
			[`lab_test_${LabTest.PREGNENOLONE}`]: 'Pregnenolone',
			[`lab_test_${LabTest.KETOSTEROIDS_17}`]: '17-Ketosteroids',
			[`lab_test_${LabTest.OH_17_CORTICOSTEROIDS}`]: '17-OH Corticosteroids',

			// Cortisol Tests
			[`lab_test_${LabTest.CORTISOL_17H}`]: 'Cortisol 5 PM',
			[`lab_test_${LabTest.CORTISOL_12H}`]: 'Cortisol 12 PM',
			[`lab_test_${LabTest.CORTISOL_20H}`]: 'Cortisol 8 PM',
			[`lab_test_${LabTest.CORTISOL_MORNING_6_10H}`]:
				'Cortisol Morning 6-10 AM',
			[`lab_test_${LabTest.CORTISOL_PROFILE}`]: 'Cortisol Profile',

			// Pregnancy & Fertility
			[`lab_test_${LabTest.ANTI_MULLERIAN_HORMONE}`]:
				'Anti-Müllerian Hormone (AMH)',
			[`lab_test_${LabTest.BETA_HCG}`]: 'Beta hCG',
			[`lab_test_${LabTest.FREE_BETA_HCG}`]: 'Free Beta hCG',
			[`lab_test_${LabTest.TRIPLE_TEST}`]: 'Triple Test',
			[`lab_test_${LabTest.DOUBLE_TEST}`]: 'Double Test',
			[`lab_test_${LabTest.QUADRUPLE_TEST}`]: 'Quadruple Test',
			[`lab_test_${LabTest.FREE_ESTRIOL}`]: 'Free Estriol',
			[`lab_test_${LabTest.INHIBIN_B}`]: 'Inhibin B',
			[`lab_test_${LabTest.INHIBIN_A}`]: 'Inhibin A',
			[`lab_test_${LabTest.PAPP_A}`]: 'PAPP-A',
			[`lab_test_${LabTest.HUMAN_PLACENTAL_LACTOGEN}`]:
				'Human Placental Lactogen',
			[`lab_test_${LabTest.PREECLAMPSIA_SCREENING_UP_TO_12_WEEKS}`]:
				'Preeclampsia Screening (up to 12 weeks)',
			[`lab_test_${LabTest.PREECLAMPSIA_SCREENING_AFTER_12_WEEKS}`]:
				'Preeclampsia Screening (after 12 weeks)',

			// Insulin Tests
			[`lab_test_${LabTest.INSULIN_AFTER_30_MIN}`]: 'Insulin after 30 min',
			[`lab_test_${LabTest.INSULIN_AFTER_60_MIN}`]: 'Insulin after 60 min',
			[`lab_test_${LabTest.INSULIN_AFTER_120_MIN}`]: 'Insulin after 120 min',
			[`lab_test_${LabTest.INSULIN_AFTER_90_MIN}`]: 'Insulin after 90 min',
			[`lab_test_${LabTest.INSULIN_AFTER_180_MIN}`]: 'Insulin after 180 min',
			[`lab_test_${LabTest.INSULIN_AFTER_240_MIN}`]: 'Insulin after 240 min',
			[`lab_test_${LabTest.INSULIN_RESISTANCE}`]: 'Insulin Resistance',
			[`lab_test_${LabTest.HOMA_INSULIN_RESISTANCE}`]:
				'HOMA-IR (Insulin Resistance)',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_30_MIN}`]: 'C-Peptide after 30 min',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_60_MIN}`]: 'C-Peptide after 60 min',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_90_MIN}`]: 'C-Peptide after 90 min',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_120_MIN}`]:
				'C-Peptide after 120 min',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_150_MIN}`]:
				'C-Peptide after 150 min',
			[`lab_test_${LabTest.C_PEPTIDE_AFTER_180_MIN}`]:
				'C-Peptide after 180 min',
			[`lab_test_${LabTest.C_PEPTIDE_IN_URINE}`]: 'C-Peptide in Urine',

			// Other Hormones
			[`lab_test_${LabTest.ACTH}`]: 'ACTH',
			[`lab_test_${LabTest.RENIN}`]: 'Renin',
			[`lab_test_${LabTest.ALDOSTERONE}`]: 'Aldosterone',
			[`lab_test_${LabTest.ALDOSTERONE_IN_24H_URINE}`]:
				'Aldosterone in 24h Urine',
			[`lab_test_${LabTest.GROWTH_HORMONE}`]: 'Growth Hormone (GH)',
			[`lab_test_${LabTest.IGF_1}`]: 'IGF-1',
			[`lab_test_${LabTest.IGFBP_3}`]: 'IGFBP-3',
			[`lab_test_${LabTest.LEPTIN}`]: 'Leptin',
			[`lab_test_${LabTest.ADIPONECTIN}`]: 'Adiponectin',
			[`lab_test_${LabTest.GHRELIN}`]: 'Ghrelin',
			[`lab_test_${LabTest.OXYTOCIN}`]: 'Oxytocin',
			[`lab_test_${LabTest.ADH_ANTIDIURETIC_HORMONE}`]:
				'ADH (Antidiuretic Hormone)',
			[`lab_test_${LabTest.GASTRIN}`]: 'Gastrin',
			[`lab_test_${LabTest.GLUCAGON}`]: 'Glucagon',
			[`lab_test_${LabTest.VASOACTIVE_INTESTINAL_POLYPEPTIDE}`]:
				'Vasoactive Intestinal Polypeptide (VIP)',
			[`lab_test_${LabTest.SEROTONIN}`]: 'Serotonin',
			[`lab_test_${LabTest.SEROTONIN_IN_24H_URINE}`]: 'Serotonin in 24h Urine',
			[`lab_test_${LabTest.MELATONIN}`]: 'Melatonin',
			[`lab_test_${LabTest.MELATONIN_IN_URINE}`]: 'Melatonin in Urine',

			// Cardiac Markers
			[`lab_test_${LabTest.PRO_BNP}`]: 'Pro-BNP',
			[`lab_test_${LabTest.NT_PROBNP}`]: 'NT-proBNP',
			[`lab_test_${LabTest.TROPONIN_T_HS}`]: 'Troponin T HS',
			[`lab_test_${LabTest.TROPONIN_I}`]: 'Troponin I',
			[`lab_test_${LabTest.MYOGLOBIN}`]: 'Myoglobin',
			[`lab_test_${LabTest.HOMOCYSTEINE}`]: 'Homocysteine',

			// Tumor Markers - Extended
			[`lab_test_${LabTest.PSA_PLUS_FREE_PSA}`]: 'PSA + Free PSA',
			[`lab_test_${LabTest.PSA_PROFILE}`]: 'PSA Profile',
			[`lab_test_${LabTest.CA_72_4}`]: 'CA 72-4',
			[`lab_test_${LabTest.HE4}`]: 'HE4',
			[`lab_test_${LabTest.CA_50}`]: 'CA 50',
			[`lab_test_${LabTest.ROMA_INDEX}`]: 'ROMA Index',
			[`lab_test_${LabTest.CYFRA_21_1}`]: 'CYFRA 21-1',
			[`lab_test_${LabTest.NSE}`]: 'NSE (Neuron-Specific Enolase)',
			[`lab_test_${LabTest.BETA_CROSSLAPS}`]: 'Beta-CrossLaps',
			[`lab_test_${LabTest.OSTEOCALCIN}`]: 'Osteocalcin',
			[`lab_test_${LabTest.CHROMOGRANIN_A}`]: 'Chromogranin A',
			[`lab_test_${LabTest.BETA_2_MICROGLOBULIN}`]: 'Beta-2-Microglobulin',
			[`lab_test_${LabTest.BETA_2_MICROGLOBULIN_IN_URINE}`]:
				'Beta-2-Microglobulin in Urine',
			[`lab_test_${LabTest.TPA_TISSUE_POLYPEPTIDE_ANTIGEN}`]:
				'TPA (Tissue Polypeptide Antigen)',
			[`lab_test_${LabTest.TATI}`]: 'TATI',
			[`lab_test_${LabTest.SCC_SQUAMOUS_CELL_CARCINOMA_ANTIGEN}`]:
				'SCC (Squamous Cell Carcinoma Antigen)',
			[`lab_test_${LabTest.UBC}`]: 'UBC (Urinary Bladder Cancer Antigen)',
			[`lab_test_${LabTest.PTHRP}`]: 'PTHrP',
			[`lab_test_${LabTest.MELANIN}`]: 'Melanin',
			[`lab_test_${LabTest.MELANIN_IN_URINE}`]: 'Melanin in Urine',
			[`lab_test_${LabTest.PROTEIN_S_100}`]: 'Protein S-100',
			[`lab_test_${LabTest.PCA3_SCORE_PROSTATE_CANCER}`]:
				'PCA3 Score (Prostate Cancer)',

			// Infectious Diseases - Extended
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGM}`]: 'Cytomegalovirus IgM',
			[`lab_test_${LabTest.HELICOBACTER_PYLORI}`]: 'Helicobacter Pylori',
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGG}`]: 'Cytomegalovirus IgG',
			[`lab_test_${LabTest.CMV_AVIDITY}`]: 'CMV Avidity',
			[`lab_test_${LabTest.ADENOVIRUS_IGM}`]: 'Adenovirus IgM',
			[`lab_test_${LabTest.ADENOVIRUS_IGG}`]: 'Adenovirus IgG',
			[`lab_test_${LabTest.ADENOVIRUS_IGA}`]: 'Adenovirus IgA',
			[`lab_test_${LabTest.ADENOVIRUS_IGG_AVIDITY}`]: 'Adenovirus IgG Avidity',
			[`lab_test_${LabTest.TPHA_TREPONEMA_PALLIDUM}`]:
				'TPHA (Treponema pallidum)',
			[`lab_test_${LabTest.TOXOPLASMA_IGM}`]: 'Toxoplasma IgM',
			[`lab_test_${LabTest.TOXOPLASMA_IGG}`]: 'Toxoplasma IgG',
			[`lab_test_${LabTest.TOXOPLASMA_IGG_AVIDITY}`]: 'Toxoplasma IgG Avidity',
			[`lab_test_${LabTest.TORCH}`]: 'TORCH',
			[`lab_test_${LabTest.RUBELLA_IGM}`]: 'Rubella IgM',
			[`lab_test_${LabTest.RUBELLA_IGG}`]: 'Rubella IgG',
			[`lab_test_${LabTest.RUBELLA_IGG_AVIDITY}`]: 'Rubella IgG Avidity',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGM}`]: 'Herpes Simplex I IgM',
			[`lab_test_${LabTest.MUMPS_IGM}`]: 'Mumps IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGG}`]: 'Herpes Simplex I IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGM}`]: 'Herpes Simplex II IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGG}`]: 'Herpes Simplex II IgG',
			[`lab_test_${LabTest.HSV_I_IGG_AVIDITY}`]: 'HSV I IgG Avidity',
			[`lab_test_${LabTest.HSV_II_IGG_AVIDITY}`]: 'HSV II IgG Avidity',
			[`lab_test_${LabTest.HSV2_IGG}`]: 'HSV-2 IgG',
			[`lab_test_${LabTest.HSV1_IGG}`]: 'HSV-1 IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_PLUS_II_IGG}`]:
				'Herpes Simplex I+II IgG',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGM}`]: 'Epstein-Barr IgM',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGG}`]: 'Epstein-Barr IgG',
			[`lab_test_${LabTest.EPSTEIN_BARR_EBNA_IGG}`]: 'Epstein-Barr EBNA IgG',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGG_AVIDITY}`]:
				'Epstein-Barr IgG Avidity',
			[`lab_test_${LabTest.HAV_IGM}`]: 'HAV IgM',
			[`lab_test_${LabTest.HAV_TOTAL_ANTIBODIES}`]: 'HAV Total Antibodies',
			[`lab_test_${LabTest.ANTI_HCV}`]: 'Anti-HCV',
			[`lab_test_${LabTest.HCV_TOTAL_ANTIBODIES}`]: 'HCV Total Antibodies',
			[`lab_test_${LabTest.HBSAG}`]: 'HBsAg',
			[`lab_test_${LabTest.HBEAG}`]: 'HBeAg',
			[`lab_test_${LabTest.HBSAB}`]: 'HBsAb',
			[`lab_test_${LabTest.HIV_AG_AB}`]: 'HIV Ag-Ab',
			[`lab_test_${LabTest.HIV_1_PLUS_2_AG_AB}`]: 'HIV 1+2 Ag-Ab',
			[`lab_test_${LabTest.VARICELLA_ZOSTER_VIRUS_IGM}`]:
				'Varicella-Zoster Virus IgM',
			[`lab_test_${LabTest.VARICELLA_ZOSTER_VIRUS_IGG}`]:
				'Varicella-Zoster Virus IgG',
			[`lab_test_${LabTest.VARICELLA_ZOSTER_IGG_AVIDITY}`]:
				'Varicella-Zoster IgG Avidity',
			[`lab_test_${LabTest.MONOSTICON}`]: 'Monosticon',
			[`lab_test_${LabTest.MONOSTICON_TEST}`]: 'Monosticon Test',
			[`lab_test_${LabTest.VDRL}`]: 'VDRL',
			[`lab_test_${LabTest.COXSACKIE_B_IGM}`]: 'Coxsackie B IgM',
			[`lab_test_${LabTest.COXSACKIE_B_IGG}`]: 'Coxsackie B IgG',
			[`lab_test_${LabTest.COXSACKIE_VIRUS_IGM}`]: 'Coxsackie Virus IgM',
			[`lab_test_${LabTest.COXSACKIE_VIRUS_IGG}`]: 'Coxsackie Virus IgG',
			[`lab_test_${LabTest.MUMPS_IGG}`]: 'Mumps IgG',
			[`lab_test_${LabTest.MUMPS_VIRUS_IGM}`]: 'Mumps Virus IgM',
			[`lab_test_${LabTest.MUMPS_VIRUS_IGG}`]: 'Mumps Virus IgG',
			[`lab_test_${LabTest.HEV}`]: 'HEV',
			[`lab_test_${LabTest.MEASLES_IGM}`]: 'Measles IgM',
			[`lab_test_${LabTest.MEASLES_IGG}`]: 'Measles IgG',
			[`lab_test_${LabTest.RSV_IGM}`]: 'RSV IgM',
			[`lab_test_${LabTest.RSV_IGG}`]: 'RSV IgG',
			[`lab_test_${LabTest.PARVOVIRUS_B19_IGM}`]: 'Parvovirus B19 IgM',
			[`lab_test_${LabTest.PARVOVIRUS_B19_IGG}`]: 'Parvovirus B19 IgG',

			// COVID-19
			[`lab_test_${LabTest.ANTI_SARS_COV}`]: 'Anti-SARS-CoV',
			[`lab_test_${LabTest.SARS_COV_AB_IGG_PLUS_IGM}`]: 'SARS-CoV-2 IgG+IgM',
			[`lab_test_${LabTest.SARS_COV_IGG}`]: 'SARS-CoV-2 IgG',
			[`lab_test_${LabTest.SARS_COV_IGM}`]: 'SARS-CoV-2 IgM',
			[`lab_test_${LabTest.SARS_COV_2_IGG_SPIKE_PROTEIN}`]:
				'SARS-CoV-2 IgG Spike Protein',
			[`lab_test_${LabTest.COVID_19_IGM}`]: 'COVID-19 IgM',
			[`lab_test_${LabTest.COVID_19_IGG_SPIKE}`]: 'COVID-19 IgG Spike',
			[`lab_test_${LabTest.URGENT_PCR}`]: 'Urgent PCR',
			[`lab_test_${LabTest.COVID_19_ANTIGEN_TEST}`]: 'COVID-19 Antigen Test',
			[`lab_test_${LabTest.PCR_MULTIPLEX_INFLUENZA_PLUS_SARS_COV}`]:
				'PCR Multiplex Influenza + SARS-CoV-2',
			[`lab_test_${LabTest.PCR_COV_2}`]: 'PCR CoV-2',
			[`lab_test_${LabTest.PCR_COV_4}`]: 'PCR CoV-4',
			[`lab_test_${LabTest.INFLUENZA_A_PLUS_B_IHT}`]: 'Influenza A+B (IHT)',

			// Bacterial Infections
			[`lab_test_${LabTest.HELICOBACTER_PYLORI_IGA}`]:
				'Helicobacter Pylori IgA',
			[`lab_test_${LabTest.HELICOBACTER_PYLORI_IGG}`]:
				'Helicobacter Pylori IgG',
			[`lab_test_${LabTest.HELICOBACTER_PYLORI_ANTIGEN_IN_FECES}`]:
				'Helicobacter Pylori Antigen in Feces',
			[`lab_test_${LabTest.MYCOPLASMA_PNEUMONIAE_IGM}`]:
				'Mycoplasma Pneumoniae IgM',
			[`lab_test_${LabTest.MYCOPLASMA_PNEUMONIAE_IGG}`]:
				'Mycoplasma Pneumoniae IgG',
			[`lab_test_${LabTest.BORRELIA_BURGDORFERI_IGM}`]:
				'Borrelia Burgdorferi IgM',
			[`lab_test_${LabTest.BORRELIA_BURGDORFERI_IGG}`]:
				'Borrelia Burgdorferi IgG',
			[`lab_test_${LabTest.BORRELIA_BURGDORFERI_IGG_WESTERN_BLOT}`]:
				'Borrelia Burgdorferi IgG Western Blot',
			[`lab_test_${LabTest.BORRELIA_BURGDORFERI_IGM_WESTERN_BLOT}`]:
				'Borrelia Burgdorferi IgM Western Blot',
			[`lab_test_${LabTest.CHLAMYDIA_PNEUMONIAE_IGM}`]:
				'Chlamydia Pneumoniae IgM',
			[`lab_test_${LabTest.BORDETELLA_PERTUSSIS_IGG}`]:
				'Bordetella Pertussis IgG',
			[`lab_test_${LabTest.CHLAMYDIA_TRACHOMATIS_IGM}`]:
				'Chlamydia Trachomatis IgM',
			[`lab_test_${LabTest.CHLAMYDIA_TRACHOMATIS_IGG}`]:
				'Chlamydia Trachomatis IgG',
			[`lab_test_${LabTest.CHLAMYDIA_PNEUMONIAE_IGG}`]:
				'Chlamydia Pneumoniae IgG',
			[`lab_test_${LabTest.BORDETELLA_PERTUSSIS_IGA}`]:
				'Bordetella Pertussis IgA',
			[`lab_test_${LabTest.LEGIONELLA_PNEUMOPHILA_IGM}`]:
				'Legionella Pneumophila IgM',
			[`lab_test_${LabTest.LEGIONELLA_PNEUMOPHILA_IGG}`]:
				'Legionella Pneumophila IgG',
			[`lab_test_${LabTest.LEGIONELLA_PNEUMOPHILA_ANTIGEN_URINE}`]:
				'Legionella Pneumophila Antigen (Urine)',
			[`lab_test_${LabTest.BARTONELLA_HENSELAE_IGM}`]:
				'Bartonella Henselae IgM',
			[`lab_test_${LabTest.BARTONELLA_HENSELAE_IGG}`]:
				'Bartonella Henselae IgG',
			[`lab_test_${LabTest.BARTONELLA_QUINTANA_IGM}`]:
				'Bartonella Quintana IgM',
			[`lab_test_${LabTest.BARTONELLA_QUINTANA_IGG}`]:
				'Bartonella Quintana IgG',
			[`lab_test_${LabTest.UREAPLASMA_UREALYTICUM_IGA}`]:
				'Ureaplasma Urealyticum IgA',
			[`lab_test_${LabTest.UREAPLASMA_UREALYTICUM_IGM}`]:
				'Ureaplasma Urealyticum IgM',
			[`lab_test_${LabTest.UREAPLASMA_UREALYTICUM_IGG}`]:
				'Ureaplasma Urealyticum IgG',
			[`lab_test_${LabTest.LISTERIA_MONOCYTOGENES_IGM}`]:
				'Listeria Monocytogenes IgM',
			[`lab_test_${LabTest.BRUCELLA_IGM}`]: 'Brucella IgM',
			[`lab_test_${LabTest.QUANTIFERON}`]: 'QuantiFERON-TB',

			// Parasites
			[`lab_test_${LabTest.TRICHINELLA_SPIRALIS_IGG}`]:
				'Trichinella Spiralis IgG',
			[`lab_test_${LabTest.TRICHINELLA_SPIRALIS_TOTAL_ANTIBODIES}`]:
				'Trichinella Spiralis Total Antibodies',
			[`lab_test_${LabTest.TOXOCARA_CANIS_IGM_ANTIBODIES}`]:
				'Toxocara Canis IgM',
			[`lab_test_${LabTest.TOXOCARA_CANIS_IGG}`]: 'Toxocara Canis IgG',
			[`lab_test_${LabTest.LEISHMANIA_IGM_ANTIBODIES}`]: 'Leishmania IgM',
			[`lab_test_${LabTest.ECHINOCOCCUS_IGG_ELISA}`]:
				'Echinococcus IgG (ELISA)',
			[`lab_test_${LabTest.ECHINOCOCCUS_IGG_WESTERN_BLOT}`]:
				'Echinococcus IgG Western Blot',
			[`lab_test_${LabTest.STRONGYLOIDES_STERCORALIS_IGG}`]:
				'Strongyloides Stercoralis IgG',
			[`lab_test_${LabTest.CYSTICERCOSIS_IGG}`]: 'Cysticercosis IgG',
			[`lab_test_${LabTest.STOOL_PARASITES}`]: 'Stool Parasites',
			[`lab_test_${LabTest.MALARIA}`]: 'Malaria Test',

			// Hematology - Extended
			[`lab_test_${LabTest.BLOOD_COUNT_SELECTED_PARAMETERS}`]:
				'Blood Count - Selected Parameters',
			[`lab_test_${LabTest.ERYTHROCYTE_SEDIMENTATION_RATE}`]:
				'Erythrocyte Sedimentation Rate (ESR)',
			[`lab_test_${LabTest.ERYTHROCYTE_RESISTANCE}`]: 'Erythrocyte Resistance',
			[`lab_test_${LabTest.LEUKOCYTES}`]: 'Leukocytes',
			[`lab_test_${LabTest.BLOOD_EOSINOPHILS}`]: 'Blood Eosinophils',
			[`lab_test_${LabTest.NASAL_EOSINOPHILS}`]: 'Nasal Eosinophils',
			[`lab_test_${LabTest.PLATELET_COUNT_MICROSCOPIC}`]:
				'Platelet Count (Microscopic)',
			[`lab_test_${LabTest.HAPTOGLOBIN}`]: 'Haptoglobin',
			[`lab_test_${LabTest.ERYTHROPOIETIN}`]: 'Erythropoietin',
			[`lab_test_${LabTest.HEMOGLOBIN_ELECTROPHORESIS}`]:
				'Hemoglobin Electrophoresis',
			[`lab_test_${LabTest.LYMPHOCYTE_SUBPOPULATIONS_NK_CELLS}`]:
				'Lymphocyte Subpopulations (NK Cells)',
			[`lab_test_${LabTest.T_LYMPHOCYTES_CD4_PLUS}`]: 'T Lymphocytes CD4+',

			// Coagulation - Extended
			[`lab_test_${LabTest.ANTI_RH_ANTIBODIES}`]: 'Anti-Rh Antibodies',
			[`lab_test_${LabTest.RH_ANTIBODIES}`]: 'Rh Antibodies',
			[`lab_test_${LabTest.BLOOD_GROUP_AND_RH_FACTOR}`]:
				'Blood Group and Rh Factor',
			[`lab_test_${LabTest.COAGULATION_FACTOR_VII}`]: 'Coagulation Factor VII',
			[`lab_test_${LabTest.PROTHROMBIN_TIME_PT_INR}`]:
				'Prothrombin Time (PT/INR)',
			[`lab_test_${LabTest.THROMBIN_TIME}`]: 'Thrombin Time',
			[`lab_test_${LabTest.LUPUS_ANTICOAGULANT}`]: 'Lupus Anticoagulant',
			[`lab_test_${LabTest.HEPARIN_ANTI_XA_ACTIVITY}`]:
				'Heparin Anti-Xa Activity',
			[`lab_test_${LabTest.COAGULATION_FACTOR_II}`]: 'Coagulation Factor II',
			[`lab_test_${LabTest.COAGULATION_FACTOR_V}`]: 'Coagulation Factor V',
			[`lab_test_${LabTest.COAGULATION_FACTOR_VIII}`]:
				'Coagulation Factor VIII',
			[`lab_test_${LabTest.COAGULATION_FACTOR_XIII}`]:
				'Coagulation Factor XIII',
			[`lab_test_${LabTest.FACTOR_VII_PROCONVERTIN}`]:
				'Factor VII (Proconvertin)',
			[`lab_test_${LabTest.FACTOR_IX}`]: 'Factor IX',
			[`lab_test_${LabTest.FACTOR_X}`]: 'Factor X',
			[`lab_test_${LabTest.FACTOR_XI}`]: 'Factor XI',
			[`lab_test_${LabTest.FACTOR_XII_HAGEMAN}`]: 'Factor XII (Hageman)',
			[`lab_test_${LabTest.PROTEIN_S}`]: 'Protein S',
			[`lab_test_${LabTest.PROTEIN_C}`]: 'Protein C',
			[`lab_test_${LabTest.EUGLOBULIN_FIBRINOLYSIS}`]:
				'Euglobulin Fibrinolysis',
			[`lab_test_${LabTest.APCR_RESISTANCE_TO_ACTIVATED_PROTEIN_C}`]:
				'APCR (Resistance to Activated Protein C)',
			[`lab_test_${LabTest.VON_WILLEBRAND_FACTOR_ACTIVITY}`]:
				'von Willebrand Factor Activity',
			[`lab_test_${LabTest.VON_WILLEBRAND_FACTOR_ANTIGEN}`]:
				'von Willebrand Factor Antigen',
			[`lab_test_${LabTest.DIRECT_COOMBS_TEST}`]: 'Direct Coombs Test',
			[`lab_test_${LabTest.INDIRECT_COOMBS_TEST}`]: 'Indirect Coombs Test',
			[`lab_test_${LabTest.CARBOXYHEMOGLOBIN}`]: 'Carboxyhemoglobin',
			[`lab_test_${LabTest.METHEMOGLOBIN}`]: 'Methemoglobin',

			// Special Biochemistry
			[`lab_test_${LabTest.AMYLASE_TOTAL_ALPHA_AMYLASE}`]:
				'Amylase (Total Alpha-Amylase)',
			[`lab_test_${LabTest.LACTATE}`]: 'Lactate',
			[`lab_test_${LabTest.PYRUVATE}`]: 'Pyruvate',
			[`lab_test_${LabTest.AMMONIA_NH3}`]: 'Ammonia (NH3)',
			[`lab_test_${LabTest.COENZYME_Q10}`]: 'Coenzyme Q10',
			[`lab_test_${LabTest.DIAMINE_OXIDASE_DAO_HISTAMINE}`]:
				'Diamine Oxidase (DAO/Histamine)',
			[`lab_test_${LabTest.DIAMINE_OXIDASE}`]: 'Diamine Oxidase',
			[`lab_test_${LabTest.HISTAMINE_IN_BLOOD}`]: 'Histamine in Blood',
			[`lab_test_${LabTest.HISTAMINE_IN_URINE}`]: 'Histamine in Urine',
			[`lab_test_${LabTest.CHITOTRIOSIDASE}`]: 'Chitotriosidase',
			[`lab_test_${LabTest.APOA_I}`]: 'ApoA-I',
			[`lab_test_${LabTest.APOB}`]: 'ApoB',
			[`lab_test_${LabTest.GLUCOSE_6_PHOSPHATE_DEHYDROGENASE}`]:
				'Glucose-6-Phosphate Dehydrogenase (G6PD)',
			[`lab_test_${LabTest.NON_ESTERIFIED_FATTY_ACIDS}`]:
				'Non-Esterified Fatty Acids (NEFA)',
			[`lab_test_${LabTest.HYDROXYLASE_21_CYP21A2}`]:
				'21-Hydroxylase (CYP21A2)',
			[`lab_test_${LabTest.PHENYLALANINE}`]: 'Phenylalanine',
			[`lab_test_${LabTest.CYSTATIN_C}`]: 'Cystatin C',
			[`lab_test_${LabTest.TYROSINE}`]: 'Tyrosine',
			[`lab_test_${LabTest.TAS_TOTAL_ANTIOXIDANT_STATUS}`]:
				'TAS (Total Antioxidant Status)',
			[`lab_test_${LabTest.GLOBULINS}`]: 'Globulins',
			[`lab_test_${LabTest.GLUTATHIONE_S_TRANSFERASE}`]:
				'Glutathione S-Transferase',
			[`lab_test_${LabTest.ALBUMIN_GLOBULIN_INDEX}`]: 'Albumin/Globulin Ratio',
			[`lab_test_${LabTest.BONE_ALKALINE_PHOSPHATASE}`]:
				'Bone Alkaline Phosphatase',
			[`lab_test_${LabTest.ALKALINE_PHOSPHATASE_ISOENZYMES}`]:
				'Alkaline Phosphatase Isoenzymes',
			[`lab_test_${LabTest.CHOLINESTERASE_PSEUDOCHOLINESTERASE}`]:
				'Cholinesterase (Pseudocholinesterase)',
			[`lab_test_${LabTest.ERYTHROCYTE_CHOLINESTERASE}`]:
				'Erythrocyte Cholinesterase',
			[`lab_test_${LabTest.ALDOLASE}`]: 'Aldolase',
			[`lab_test_${LabTest.INTERLEUKIN_6}`]: 'Interleukin-6 (IL-6)',
			[`lab_test_${LabTest.INTERLEUKIN_1_BETA}`]: 'Interleukin-1 Beta',
			[`lab_test_${LabTest.TNF_ALPHA_TUMOR_NECROSIS_FACTOR}`]:
				'TNF-alpha (Tumor Necrosis Factor)',
			[`lab_test_${LabTest.ALPHA_1_ACID_GLYCOPROTEIN}`]:
				'Alpha-1-Acid Glycoprotein',
			[`lab_test_${LabTest.ALPHA_2_MACROGLOBULIN}`]: 'Alpha-2-Macroglobulin',
			[`lab_test_${LabTest.CERULOPLASMIN}`]: 'Ceruloplasmin',
			[`lab_test_${LabTest.TOTAL_TAU_PROTEIN}`]: 'Total Tau Protein',

			// Trace Elements & Heavy Metals
			[`lab_test_${LabTest.SELENIUM}`]: 'Selenium',
			[`lab_test_${LabTest.NICKEL_IN_SERUM}`]: 'Nickel in Serum',
			[`lab_test_${LabTest.NICKEL_IN_URINE}`]: 'Nickel in Urine',
			[`lab_test_${LabTest.MERCURY_IN_BLOOD}`]: 'Mercury in Blood',
			[`lab_test_${LabTest.MERCURY_IN_URINE}`]: 'Mercury in Urine',
			[`lab_test_${LabTest.MERCURY_IN_24H_URINE}`]: 'Mercury in 24h Urine',
			[`lab_test_${LabTest.ZINC_IN_SERUM}`]: 'Zinc in Serum',
			[`lab_test_${LabTest.ZINC_IN_24H_URINE}`]: 'Zinc in 24h Urine',
			[`lab_test_${LabTest.ALUMINUM}`]: 'Aluminum',
			[`lab_test_${LabTest.ALUMINUM_IN_URINE}`]: 'Aluminum in Urine',
			[`lab_test_${LabTest.ARSENIC_IN_SERUM}`]: 'Arsenic in Serum',
			[`lab_test_${LabTest.ARSENIC_IN_URINE}`]: 'Arsenic in Urine',
			[`lab_test_${LabTest.ANTIMONY_IN_URINE}`]: 'Antimony in Urine',
			[`lab_test_${LabTest.COPPER_IN_SERUM}`]: 'Copper in Serum',
			[`lab_test_${LabTest.COPPER_IN_24H_URINE}`]: 'Copper in 24h Urine',
			[`lab_test_${LabTest.COPPER_IN_SINGLE_URINE_SAMPLE}`]:
				'Copper in Single Urine Sample',
			[`lab_test_${LabTest.CHROMIUM_IN_BLOOD}`]: 'Chromium in Blood',
			[`lab_test_${LabTest.LEAD_IN_BLOOD}`]: 'Lead in Blood',
			[`lab_test_${LabTest.LEAD_IN_24H_URINE}`]: 'Lead in 24h Urine',
			[`lab_test_${LabTest.COBALT_IN_SERUM}`]: 'Cobalt in Serum',
			[`lab_test_${LabTest.COBALT_IN_URINE}`]: 'Cobalt in Urine',
			[`lab_test_${LabTest.MANGANESE_IN_BLOOD}`]: 'Manganese in Blood',
			[`lab_test_${LabTest.MANGANESE_IN_URINE}`]: 'Manganese in Urine',
			[`lab_test_${LabTest.CADMIUM_IN_BLOOD}`]: 'Cadmium in Blood',
			[`lab_test_${LabTest.CADMIUM_IN_24H_URINE}`]: 'Cadmium in 24h Urine',
			[`lab_test_${LabTest.IODINE_IN_SERUM}`]: 'Iodine in Serum',
			[`lab_test_${LabTest.IODINE_IN_24H_URINE}`]: 'Iodine in 24h Urine',
			[`lab_test_${LabTest.BICARBONATES}`]: 'Bicarbonates',
			[`lab_test_${LabTest.LITHIUM}`]: 'Lithium',
			[`lab_test_${LabTest.MAGNESIUM_IN_URINE}`]: 'Magnesium in Urine',
			[`lab_test_${LabTest.MAGNESIUM_IN_24H_URINE}`]: 'Magnesium in 24h Urine',
			[`lab_test_${LabTest.PHOSPHATE_IN_24H_URINE}`]: 'Phosphate in 24h Urine',
			[`lab_test_${LabTest.POTASSIUM_IN_24H_URINE}`]: 'Potassium in 24h Urine',
			[`lab_test_${LabTest.CHLORIDE_IN_24H_URINE}`]: 'Chloride in 24h Urine',

			// Catecholamines & Metabolites
			[`lab_test_${LabTest.NORMETANEPHRINE_IN_PLASMA}`]:
				'Normetanephrine in Plasma',
			[`lab_test_${LabTest.FREE_METANEPHRINE}`]: 'Free Metanephrine',
			[`lab_test_${LabTest.FREE_METANEPHRINE_IN_PLASMA}`]:
				'Free Metanephrine in Plasma',
			[`lab_test_${LabTest.CATECHOLAMINES_IN_PLASMA}`]:
				'Catecholamines in Plasma',
			[`lab_test_${LabTest.CATECHOLAMINES_IN_24H_URINE}`]:
				'Catecholamines in 24h Urine',

			// Additional Urine Tests
			[`lab_test_${LabTest.ALPHA_AMYLASE_IN_URINE}`]: 'Alpha-Amylase in Urine',
			[`lab_test_${LabTest.PANCREATIC_AMYLASE_IN_URINE}`]:
				'Pancreatic Amylase in Urine',
			[`lab_test_${LabTest.FREE_KAPPA_LIGHT_CHAINS_IN_URINE}`]:
				'Free Kappa Light Chains in Urine',
			[`lab_test_${LabTest.FREE_LAMBDA_LIGHT_CHAINS_IN_URINE}`]:
				'Free Lambda Light Chains in Urine',
			[`lab_test_${LabTest.COPROPORPHYRINS}`]: 'Coproporphyrins',
			[`lab_test_${LabTest.DELTA_AMINOLEVULINIC_ACID}`]:
				'Delta-Aminolevulinic Acid',
			[`lab_test_${LabTest.PHENOL_IN_URINE}`]: 'Phenol in Urine',
			[`lab_test_${LabTest.HIPPURIC_ACID}`]: 'Hippuric Acid',
			[`lab_test_${LabTest.OXALATE_IN_24H_URINE}`]: 'Oxalate in 24h Urine',
			[`lab_test_${LabTest.CYSTINE_IN_24H_URINE}`]: 'Cystine in 24h Urine',
			[`lab_test_${LabTest.CITRATE_IN_24H_URINE}`]: 'Citrate in 24h Urine',
			[`lab_test_${LabTest.HYDROXYPROLINE}`]: 'Hydroxyproline',
			[`lab_test_${LabTest.ALPHA_1_MICROGLOBULIN}`]: 'Alpha-1-Microglobulin',
			[`lab_test_${LabTest.NGAL_IN_URINE}`]: 'NGAL in Urine',
			[`lab_test_${LabTest.MICROALBUMIN_IN_24H_URINE}`]:
				'Microalbumin in 24h Urine',
			[`lab_test_${LabTest.MICROALBUMIN_IN_URINE}`]: 'Microalbumin in Urine',

			// Immunology - Immunoglobulins
			[`lab_test_${LabTest.IGA}`]: 'IgA',
			[`lab_test_${LabTest.IGG}`]: 'IgG',
			[`lab_test_${LabTest.IGM}`]: 'IgM',
			[`lab_test_${LabTest.IGE}`]: 'IgE',
			[`lab_test_${LabTest.IGD}`]: 'IgD',
			[`lab_test_${LabTest.IGG_SUBCLASSES}`]: 'IgG Subclasses',
			[`lab_test_${LabTest.C3_COMPLEMENT}`]: 'C3 Complement',
			[`lab_test_${LabTest.C4_COMPLEMENT}`]: 'C4 Complement',
			[`lab_test_${LabTest.TOTAL_COMPLEMENT_CH50}`]: 'Total Complement (CH50)',
			[`lab_test_${LabTest.C1_INHIBITOR}`]: 'C1 Inhibitor',
			[`lab_test_${LabTest.C1_INACTIVATOR}`]: 'C1 Inactivator',
			[`lab_test_${LabTest.KAPPA_LIGHT_CHAIN}`]: 'Kappa Light Chain',
			[`lab_test_${LabTest.LAMBDA_LIGHT_CHAIN}`]: 'Lambda Light Chain',
			[`lab_test_${LabTest.KAPPA_LAMBDA_LIGHT_CHAIN_INDEX}`]:
				'Kappa/Lambda Light Chain Index',
			[`lab_test_${LabTest.IMMUNE_COMPLEXES_PEG}`]: 'Immune Complexes (PEG)',
			[`lab_test_${LabTest.C1Q_IMMUNE_COMPLEXES}`]: 'C1q Immune Complexes',
			[`lab_test_${LabTest.CRYOGLOBULINS}`]: 'Cryoglobulins',
			[`lab_test_${LabTest.ECP_EOSINOPHIL_CATIONIC_PROTEIN}`]:
				'ECP (Eosinophil Cationic Protein)',

			// Autoimmune Antibodies - Thyroid
			[`lab_test_${LabTest.ASTO}`]: 'ASTO (Anti-Streptolysin O)',
			[`lab_test_${LabTest.RHEUMATOID_FACTOR}`]: 'Rheumatoid Factor (RF)',
			[`lab_test_${LabTest.WAALER_ROSE_TEST}`]: 'Waaler-Rose Test',

			// Autoimmune Antibodies - Connective Tissue
			[`lab_test_${LabTest.DSDNA_ANTIBODIES}`]: 'dsDNA Antibodies',
			[`lab_test_${LabTest.DSDNA_IGG_ANTIBODIES}`]: 'dsDNA IgG Antibodies',
			[`lab_test_${LabTest.ANTI_CCP_ANTIBODIES}`]: 'Anti-CCP Antibodies',
			[`lab_test_${LabTest.ANA_HEP_2}`]: 'ANA (HEp-2)',
			[`lab_test_${LabTest.ANA_ANTINUCLEAR_ANTIBODIES}`]:
				'ANA (Antinuclear Antibodies)',
			[`lab_test_${LabTest.ANTI_LA_SSB_ANTIBODIES}`]:
				'Anti-La (SS-B) Antibodies',
			[`lab_test_${LabTest.ANTI_RO_SSA_ANTIBODIES}`]:
				'Anti-Ro (SS-A) Antibodies',
			[`lab_test_${LabTest.ANTI_JO_1_ANTIBODIES}`]: 'Anti-Jo-1 Antibodies',
			[`lab_test_${LabTest.ANTI_SCL_70_ANTIBODIES}`]: 'Anti-Scl-70 Antibodies',
			[`lab_test_${LabTest.ANTI_SM_ANTIBODIES}`]: 'Anti-Sm Antibodies',
			[`lab_test_${LabTest.LUPUS_CELLS}`]: 'Lupus Cells (LE Cells)',
			[`lab_test_${LabTest.LUPUS_ANTIBODIES}`]: 'Lupus Antibodies',
			[`lab_test_${LabTest.CENTROMERE_PROTEIN_B_ANTIBODIES}`]:
				'Centromere Protein B Antibodies',
			[`lab_test_${LabTest.ANTI_C1Q_ANTIBODIES}`]: 'Anti-C1q Antibodies',
			[`lab_test_${LabTest.NUCLEOSOMAL_ANTIBODIES}`]: 'Nucleosomal Antibodies',

			// ANCA & Vasculitis
			[`lab_test_${LabTest.ANCA_P_ANTI_MPO}`]: 'ANCA-P (Anti-MPO)',
			[`lab_test_${LabTest.ANCA_C_ANTI_PR3}`]: 'ANCA-C (Anti-PR3)',
			[`lab_test_${LabTest.GBM_ANTIBODIES}`]: 'GBM Antibodies',

			// Organ-Specific Autoantibodies
			[`lab_test_${LabTest.ANTI_GAD_ANTIBODIES}`]: 'Anti-GAD Antibodies',
			[`lab_test_${LabTest.ICA_ANTIBODIES}`]: 'ICA (Islet Cell Antibodies)',
			[`lab_test_${LabTest.ANTI_INSULIN_ANTIBODIES}`]:
				'Anti-Insulin Antibodies',
			[`lab_test_${LabTest.IGE_ANTIBODIES_TO_HUMAN_INSULIN}`]:
				'IgE Antibodies to Human Insulin',
			[`lab_test_${LabTest.IA_2_ANTIBODIES}`]: 'IA-2 Antibodies',
			[`lab_test_${LabTest.AMA_ANTIMITOCHONDRIAL_M2}`]:
				'AMA (Antimitochondrial M2)',
			[`lab_test_${LabTest.LKM_1_ANTIBODIES}`]: 'LKM-1 Antibodies',
			[`lab_test_${LabTest.ANTI_SMOOTH_MUSCLE_ANTIBODIES_ASMA}`]:
				'Anti-Smooth Muscle Antibodies (ASMA)',
			[`lab_test_${LabTest.ANTI_SLA_LP_ANTIBODIES}`]: 'Anti-SLA/LP Antibodies',
			[`lab_test_${LabTest.LMA_ANTIBODIES}`]: 'LMA Antibodies',
			[`lab_test_${LabTest.ANTI_PARIETAL_CELL_ANTIBODIES_APA}`]:
				'Anti-Parietal Cell Antibodies (APA)',
			[`lab_test_${LabTest.INTRINSIC_FACTOR_ANTIBODIES}`]:
				'Intrinsic Factor Antibodies',
			[`lab_test_${LabTest.ADRENAL_ANTIBODIES}`]: 'Adrenal Antibodies',
			[`lab_test_${LabTest.OVARIAN_ANTIBODIES}`]: 'Ovarian Antibodies',

			// Celiac Disease
			[`lab_test_${LabTest.TRANSGLUTAMINASE_IGA_ANTIBODIES}`]:
				'Transglutaminase IgA Antibodies',
			[`lab_test_${LabTest.TRANSGLUTAMINASE_IGG_ANTIBODIES}`]:
				'Transglutaminase IgG Antibodies',
			[`lab_test_${LabTest.GLIADIN_IGA_ANTIBODIES}`]: 'Gliadin IgA Antibodies',
			[`lab_test_${LabTest.GLIADIN_IGG_ANTIBODIES}`]: 'Gliadin IgG Antibodies',
			[`lab_test_${LabTest.ENDOMYSIAL_IGA_ANTIBODIES}`]:
				'Endomysial IgA Antibodies',
			[`lab_test_${LabTest.RETICULIN_ANTIBODIES}`]: 'Reticulin Antibodies',

			// IBD & GI
			[`lab_test_${LabTest.ASCA_IGG}`]: 'ASCA IgG',
			[`lab_test_${LabTest.ASCA_IGA}`]: 'ASCA IgA',

			// Neurological Autoantibodies
			[`lab_test_${LabTest.AQUAPORIN_ANTIBODIES}`]: 'Aquaporin Antibodies',
			[`lab_test_${LabTest.AQUAPORIN_4_ANTIBODIES}`]: 'Aquaporin-4 Antibodies',
			[`lab_test_${LabTest.MOG_MYELIN_OLIGODENDROCYTE_GLYCOPROTEIN}`]:
				'MOG (Myelin Oligodendrocyte Glycoprotein)',
			[`lab_test_${LabTest.NMDAR_ANTIBODIES_IN_SERUM}`]:
				'NMDAR Antibodies in Serum',
			[`lab_test_${LabTest.ACETYLCHOLINE_RECEPTOR_ANTIBODIES}`]:
				'Acetylcholine Receptor Antibodies',
			[`lab_test_${LabTest.MUSK_ANTIBODIES}`]: 'MuSK Antibodies',
			[`lab_test_${LabTest.NEURONAL_ANTIBODIES}`]: 'Neuronal Antibodies',

			// Antiphospholipid Syndrome
			[`lab_test_${LabTest.ANTICARDIOLIPIN_IGM}`]: 'Anticardiolipin IgM',
			[`lab_test_${LabTest.ANTICARDIOLIPIN_IGG}`]: 'Anticardiolipin IgG',
			[`lab_test_${LabTest.PHOSPHOLIPID_IGM_ANTIBODIES}`]:
				'Phospholipid IgM Antibodies',
			[`lab_test_${LabTest.PHOSPHOLIPID_IGG_ANTIBODIES}`]:
				'Phospholipid IgG Antibodies',
			[`lab_test_${LabTest.BETA_2_GLYCOPROTEIN_I_IGG}`]:
				'Beta-2-Glycoprotein I IgG',
			[`lab_test_${LabTest.BETA_2_GLYCOPROTEIN_I_IGM}`]:
				'Beta-2-Glycoprotein I IgM',

			// Other Autoantibodies
			[`lab_test_${LabTest.ANTI_HEART_ANTIBODIES_ASA}`]:
				'Anti-Heart Antibodies (ASA)',
			[`lab_test_${LabTest.ANTI_CARDIAC_ANTIBODIES}`]:
				'Anti-Cardiac Antibodies',
			[`lab_test_${LabTest.SPERMATOZOA_ANTIBODIES_ASA}`]:
				'Spermatozoa Antibodies (ASA)',
			[`lab_test_${LabTest.PLATELET_IGA_IGM_IGG_ANTIBODIES}`]:
				'Platelet IgA/IgM/IgG Antibodies',

			// Allergy Tests - General
			[`lab_test_${LabTest.LATEX}`]: 'Latex Allergy',
			[`lab_test_${LabTest.LATEX_IGE_K82}`]: 'Latex IgE (K82)',
			[`lab_test_${LabTest.NUTRITIONAL_ALLERGENS}`]: 'Nutritional Allergens',
			[`lab_test_${LabTest.INHALANT_ALLERGENS}`]: 'Inhalant Allergens',
			[`lab_test_${LabTest.ALLERGIES}`]: 'Allergy Panel',
			[`lab_test_${LabTest.ATOPY_SCREEN_FOOD_PLUS_INHALANTS}`]:
				'Atopy Screen (Food + Inhalants)',
			[`lab_test_${LabTest.ALLERGIES_20_ALLERGENS}`]:
				'Allergy Panel 20 Allergens',
			[`lab_test_${LabTest.ALLERGIES_6_ALLERGENS}`]:
				'Allergy Panel 6 Allergens',
			[`lab_test_${LabTest.ALLERGENS_10}`]: 'Allergen Panel 10',

			// Food Allergens - Animal Products
			[`lab_test_${LabTest.BEEF_IGE_F27}`]: 'Beef IgE (F27)',
			[`lab_test_${LabTest.MILK_IGE_F2}`]: 'Milk IgE (F2)',
			[`lab_test_${LabTest.COOKED_MILK_IGE_F231}`]: 'Cooked Milk IgE (F231)',
			[`lab_test_${LabTest.MILK_POWDER_IGE_F228}`]: 'Milk Powder IgE (F228)',
			[`lab_test_${LabTest.ALPHA_LACTALBUMIN_IGE_F76}`]:
				'Alpha-Lactalbumin IgE (F76)',
			[`lab_test_${LabTest.BETA_LACTOGLOBULIN_IGE_F77}`]:
				'Beta-Lactoglobulin IgE (F77)',
			[`lab_test_${LabTest.CASEIN_IGE_F78}`]: 'Casein IgE (F78)',
			[`lab_test_${LabTest.LACTOSE_IGE_B312}`]: 'Lactose IgE (B312)',
			[`lab_test_${LabTest.CHEESE_IGE}`]: 'Cheese IgE',
			[`lab_test_${LabTest.EDAM_CHEESE_IGE_F150}`]: 'Edam Cheese IgE (F150)',
			[`lab_test_${LabTest.YOGURT_IGE_F69}`]: 'Yogurt IgE (F69)',
			[`lab_test_${LabTest.EGG_WHITE_IGE_E1}`]: 'Egg White IgE (E1)',
			[`lab_test_${LabTest.EGG_YOLK_IGE_E75}`]: 'Egg Yolk IgE (E75)',
			[`lab_test_${LabTest.EGG_MIX_RF245}`]: 'Egg Mix (RF245)',
			[`lab_test_${LabTest.CHICKEN_MEAT_IGE_F83}`]: 'Chicken Meat IgE (F83)',
			[`lab_test_${LabTest.TURKEY_MEAT_IGE_F284}`]: 'Turkey Meat IgE (F284)',
			[`lab_test_${LabTest.PORK_IGE_F26}`]: 'Pork IgE (F26)',
			[`lab_test_${LabTest.LAMB_MEAT_IGE_F88}`]: 'Lamb Meat IgE (F88)',
			[`lab_test_${LabTest.MEAT_MIX_FX23}`]: 'Meat Mix (FX23)',

			// Seafood Allergens
			[`lab_test_${LabTest.FISH_MIX_FP2}`]: 'Fish Mix (FP2)',
			[`lab_test_${LabTest.COD_IGE_F3}`]: 'Cod IgE (F3)',
			[`lab_test_${LabTest.SALMON_IGE_F41}`]: 'Salmon IgE (F41)',
			[`lab_test_${LabTest.TUNA_IGE_F40}`]: 'Tuna IgE (F40)',
			[`lab_test_${LabTest.TUNA_MEAT_IGE_F40}`]: 'Tuna Meat IgE (F40)',
			[`lab_test_${LabTest.MACKEREL_IGE_F174}`]: 'Mackerel IgE (F174)',
			[`lab_test_${LabTest.HERRING_IGE_F21}`]: 'Herring IgE (F21)',
			[`lab_test_${LabTest.REDFISH_IGE_F303}`]: 'Redfish IgE (F303)',
			[`lab_test_${LabTest.HAKE_IGE_F307}`]: 'Hake IgE (F307)',
			[`lab_test_${LabTest.SEA_BREAM_IGE}`]: 'Sea Bream IgE',
			[`lab_test_${LabTest.SEA_BASS_IGE}`]: 'Sea Bass IgE',
			[`lab_test_${LabTest.SARDINE_IGE}`]: 'Sardine IgE',
			[`lab_test_${LabTest.CRAB_IGE_F24}`]: 'Crab IgE (F24)',
			[`lab_test_${LabTest.CRAB_F24}`]: 'Crab (F24)',
			[`lab_test_${LabTest.CRAB_IGE_F23}`]: 'Crab IgE (F23)',
			[`lab_test_${LabTest.CRAB_ALLERGY}`]: 'Crab Allergy',
			[`lab_test_${LabTest.LOBSTER_IGE_F80}`]: 'Lobster IgE (F80)',
			[`lab_test_${LabTest.LOBSTER_F80}`]: 'Lobster (F80)',
			[`lab_test_${LabTest.SHRIMP_IGE}`]: 'Shrimp IgE',
			[`lab_test_${LabTest.SQUID_IGE_F258}`]: 'Squid IgE (F258)',
			[`lab_test_${LabTest.SQUID_F258}`]: 'Squid (F258)',
			[`lab_test_${LabTest.OCTOPUS_IGE_F59}`]: 'Octopus IgE (F59)',
			[`lab_test_${LabTest.OCTOPUS_F59}`]: 'Octopus (F59)',
			[`lab_test_${LabTest.MUSSEL_IGE_F37}`]: 'Mussel IgE (F37)',
			[`lab_test_${LabTest.MUSSEL_F37}`]: 'Mussel (F37)',

			// Grains & Cereals
			[`lab_test_${LabTest.GLUTEN_IGE_F79}`]: 'Gluten IgE (F79)',
			[`lab_test_${LabTest.WHEAT_FLOUR_IGE_F4}`]: 'Wheat Flour IgE (F4)',
			[`lab_test_${LabTest.RYE_FLOUR_IGE_F5}`]: 'Rye Flour IgE (F5)',
			[`lab_test_${LabTest.RYE_IGE_F4}`]: 'Rye IgE (F4)',
			[`lab_test_${LabTest.RICE_IGE_F9}`]: 'Rice IgE (F9)',
			[`lab_test_${LabTest.BARLEY_IGE_F6}`]: 'Barley IgE (F6)',
			[`lab_test_${LabTest.BARLEY_IGE_G18}`]: 'Barley IgE (G18)',
			[`lab_test_${LabTest.OAT_IGE_F7}`]: 'Oat IgE (F7)',
			[`lab_test_${LabTest.CORN_FLOUR_IGE_F8}`]: 'Corn Flour IgE (F8)',

			// Legumes & Nuts
			[`lab_test_${LabTest.SOY_IGE_F14}`]: 'Soy IgE (F14)',
			[`lab_test_${LabTest.PEANUT_IGE_F13}`]: 'Peanut IgE (F13)',
			[`lab_test_${LabTest.BEAN_IGE_F15}`]: 'Bean IgE (F15)',
			[`lab_test_${LabTest.GREEN_BEAN_IGE_F132}`]: 'Green Bean IgE (F132)',
			[`lab_test_${LabTest.PEA_IGE_F287}`]: 'Pea IgE (F287)',
			[`lab_test_${LabTest.LENTIL_IGE_F65}`]: 'Lentil IgE (F65)',
			[`lab_test_${LabTest.HAZELNUT_IGE_F17}`]: 'Hazelnut IgE (F17)',
			[`lab_test_${LabTest.ALMOND_IGE_F20}`]: 'Almond IgE (F20)',
			[`lab_test_${LabTest.WALNUT_IGE_F256}`]: 'Walnut IgE (F256)',
			[`lab_test_${LabTest.CASHEW_NUT_IGE_F202}`]: 'Cashew Nut IgE (F202)',
			[`lab_test_${LabTest.PISTACHIO_IGE_F203}`]: 'Pistachio IgE (F203)',
			[`lab_test_${LabTest.SESAME_IGE_F10}`]: 'Sesame IgE (F10)',

			// Fruits
			[`lab_test_${LabTest.APPLE_IGE_F49}`]: 'Apple IgE (F49)',
			[`lab_test_${LabTest.PEAR_IGE_F271}`]: 'Pear IgE (F271)',
			[`lab_test_${LabTest.PEACH_IGE_F95}`]: 'Peach IgE (F95)',
			[`lab_test_${LabTest.APRICOT_IGE_F94}`]: 'Apricot IgE (F94)',
			[`lab_test_${LabTest.CHERRY_IGE}`]: 'Cherry IgE',
			[`lab_test_${LabTest.STRAWBERRY_IGE_F44}`]: 'Strawberry IgE (F44)',
			[`lab_test_${LabTest.STRAWBERRY_0127}`]: 'Strawberry (0127)',
			[`lab_test_${LabTest.RASPBERRY_IGE_F156}`]: 'Raspberry IgE (F156)',
			[`lab_test_${LabTest.BLUEBERRY_IGE_F229}`]: 'Blueberry IgE (F229)',
			[`lab_test_${LabTest.BLACKBERRY_IGE_F211}`]: 'Blackberry IgE (F211)',
			[`lab_test_${LabTest.CURRANT_IGE_F171}`]: 'Currant IgE (F171)',
			[`lab_test_${LabTest.GRAPE_IGE_F50}`]: 'Grape IgE (F50)',
			[`lab_test_${LabTest.ORANGE_IGE_F33}`]: 'Orange IgE (F33)',
			[`lab_test_${LabTest.MANDARIN_IGE_F34}`]: 'Mandarin IgE (F34)',
			[`lab_test_${LabTest.LEMON_IGE_F208}`]: 'Lemon IgE (F208)',
			[`lab_test_${LabTest.BANANA_IGE_F92}`]: 'Banana IgE (F92)',
			[`lab_test_${LabTest.KIWI_IGE_F84}`]: 'Kiwi IgE (F84)',
			[`lab_test_${LabTest.PINEAPPLE_IGE_F72}`]: 'Pineapple IgE (F72)',
			[`lab_test_${LabTest.WATERMELON_IGE_F239}`]: 'Watermelon IgE (F239)',
			[`lab_test_${LabTest.FIG_IGE_F328}`]: 'Fig IgE (F328)',
			[`lab_test_${LabTest.LYCHEE_IGE_F348}`]: 'Lychee IgE (F348)',

			// Vegetables
			[`lab_test_${LabTest.TOMATO_IGE_F25}`]: 'Tomato IgE (F25)',
			[`lab_test_${LabTest.POTATO_IGE_F35}`]: 'Potato IgE (F35)',
			[`lab_test_${LabTest.CARROT_IGE_F31}`]: 'Carrot IgE (F31)',
			[`lab_test_${LabTest.CELERY_IGE_F85}`]: 'Celery IgE (F85)',
			[`lab_test_${LabTest.GARLIC_IGE_F47}`]: 'Garlic IgE (F47)',
			[`lab_test_${LabTest.ONION_IGE_F48}`]: 'Onion IgE (F48)',
			[`lab_test_${LabTest.CABBAGE_IGE_F216}`]: 'Cabbage IgE (F216)',
			[`lab_test_${LabTest.PAPRIKA_IGE_F218}`]: 'Paprika IgE (F218)',
			[`lab_test_${LabTest.SPINACH_IGE_F214}`]: 'Spinach IgE (F214)',
			[`lab_test_${LabTest.MUSHROOM_IGE_F127}`]: 'Mushroom IgE (F127)',

			// Spices & Others
			[`lab_test_${LabTest.COCOA_IGE_F93}`]: 'Cocoa IgE (F93)',
			[`lab_test_${LabTest.CHOCOLATE_IGE_F105}`]: 'Chocolate IgE (F105)',
			[`lab_test_${LabTest.COFFEE_IGE_F221}`]: 'Coffee IgE (F221)',
			[`lab_test_${LabTest.MUSTARD_IGE_F89}`]: 'Mustard IgE (F89)',
			[`lab_test_${LabTest.BAY_LEAF_IGE_F275}`]: 'Bay Leaf IgE (F275)',
			[`lab_test_${LabTest.ANISE_IGE_S1}`]: 'Anise IgE (S1)',
			[`lab_test_${LabTest.BLACK_PEPPER_IGE_S7}`]: 'Black Pepper IgE (S7)',
			[`lab_test_${LabTest.CINNAMON_IGE_S8}`]: 'Cinnamon IgE (S8)',
			[`lab_test_${LabTest.VANILLA_IGE_F234}`]: 'Vanilla IgE (F234)',
			[`lab_test_${LabTest.HONEY_IGE_F247}`]: 'Honey IgE (F247)',
			[`lab_test_${LabTest.OLIVE_IGE_F342}`]: 'Olive IgE (F342)',
			[`lab_test_${LabTest.YEAST_IGE_F45}`]: 'Yeast IgE (F45)',
			[`lab_test_${LabTest.HOPS_HUMULUS_LUPULUS_IGE}`]:
				'Hops (Humulus lupulus) IgE',

			// Inhalant Allergens - Weeds
			[`lab_test_${LabTest.AMBROSIA_ELATIOR_IGE_W1}`]:
				'Ambrosia elatior IgE (W1)',
			[`lab_test_${LabTest.SUNFLOWER_IGE_W11}`]: 'Sunflower IgE (W11)',
			[`lab_test_${LabTest.TALL_BUTTERCUP_IGE}`]: 'Tall Buttercup IgE',
			[`lab_test_${LabTest.PLANTAIN_IGE_W9}`]: 'Plantain IgE (W9)',
			[`lab_test_${LabTest.MUGWORT_IGE_W6}`]: 'Mugwort IgE (W6)',
			[`lab_test_${LabTest.CHENOPODIUM_ALBUM_IGE_W10}`]:
				'Chenopodium album IgE (W10)',
			[`lab_test_${LabTest.SORREL_IGE_W19}`]: 'Sorrel IgE (W19)',
			[`lab_test_${LabTest.NETTLE_IGE_W20}`]: 'Nettle IgE (W20)',
			[`lab_test_${LabTest.DANDELION_IGE_W8}`]: 'Dandelion IgE (W8)',
			[`lab_test_${LabTest.GOOSEFOOT_IGE_W15}`]: 'Goosefoot IgE (W15)',
			[`lab_test_${LabTest.WEED_POLLEN_MIX_WX1}`]: 'Weed Pollen Mix (WX1)',
			[`lab_test_${LabTest.WEED_POLLEN_MIX_WX2}`]: 'Weed Pollen Mix (WX2)',
			[`lab_test_${LabTest.WEED_AND_FLOWER_POLLEN_MIX_WP}`]:
				'Weed and Flower Pollen Mix (WP)',

			// Grass Pollen
			[`lab_test_${LabTest.WHEAT_POLLEN_IGE_G15}`]: 'Wheat Pollen IgE (G15)',
			[`lab_test_${LabTest.MEADOW_FESCUE_IGE_G4}`]: 'Meadow Fescue IgE (G4)',
			[`lab_test_${LabTest.TIMOTHY_GRASS_IGE_G16}`]: 'Timothy Grass IgE (G16)',
			[`lab_test_${LabTest.TIMOTHY_IGE_G2}`]: 'Timothy IgE (G2)',
			[`lab_test_${LabTest.DACTYLIS_GLOMERATA_IGE_G3}`]:
				'Dactylis glomerata IgE (G3)',
			[`lab_test_${LabTest.ENGLISH_RYEGRASS_IGE_G5}`]:
				'English Ryegrass IgE (G5)',
			[`lab_test_${LabTest.RYEGRASS_IGE_G12}`]: 'Ryegrass IgE (G12)',
			[`lab_test_${LabTest.MEADOW_GRASS_IGE_G8}`]: 'Meadow Grass IgE (G8)',
			[`lab_test_${LabTest.CORN_POLLEN_IGE_G20}`]: 'Corn Pollen IgE (G20)',
			[`lab_test_${LabTest.HAIR_GRASS_IGE_G4}`]: 'Hair Grass IgE (G4)',
			[`lab_test_${LabTest.PYRETHRUM_IGE_G21}`]: 'Pyrethrum IgE (G21)',
			[`lab_test_${LabTest.RYE_POLLEN_IGE_G14}`]: 'Rye Pollen IgE (G14)',
			[`lab_test_${LabTest.REED_IGE_G7}`]: 'Reed IgE (G7)',
			[`lab_test_${LabTest.CAT_HAIR_IGE_G6}`]: 'Cat Hair IgE (G6)',
			[`lab_test_${LabTest.GRASS_POLLEN_MIX_GX1}`]: 'Grass Pollen Mix (GX1)',
			[`lab_test_${LabTest.GRASS_POLLEN_MIX_GX2}`]: 'Grass Pollen Mix (GX2)',
			[`lab_test_${LabTest.GRASS_POLLEN_MIX_GX3}`]: 'Grass Pollen Mix (GX3)',
			[`lab_test_${LabTest.GRASS_POLLEN_MIX_GX4}`]: 'Grass Pollen Mix (GX4)',

			// Trees
			[`lab_test_${LabTest.WALNUT_TREE_IGE_T10}`]: 'Walnut Tree IgE (T10)',
			[`lab_test_${LabTest.ELDER_IGE}`]: 'Elder IgE',
			[`lab_test_${LabTest.ELM_IGE_T8}`]: 'Elm IgE (T8)',
			[`lab_test_${LabTest.OAK_IGE_T70}`]: 'Oak IgE (T70)',
			[`lab_test_${LabTest.OAK_TREE_IGE_T7}`]: 'Oak Tree IgE (T7)',
			[`lab_test_${LabTest.HAZELNUT_TREE_IGE_T4}`]: 'Hazelnut Tree IgE (T4)',
			[`lab_test_${LabTest.PINE_IGE_T16}`]: 'Pine IgE (T16)',
			[`lab_test_${LabTest.ASH_IGE_T15}`]: 'Ash IgE (T15)',
			[`lab_test_${LabTest.SYCAMORE_MAPLE_IGE_T1}`]: 'Sycamore Maple IgE (T1)',
			[`lab_test_${LabTest.LINDEN_IGE_T208}`]: 'Linden IgE (T208)',
			[`lab_test_${LabTest.SPRUCE_IGE}`]: 'Spruce IgE',
			[`lab_test_${LabTest.OLIVE_TREE_IGE_T9}`]: 'Olive Tree IgE (T9)',
			[`lab_test_${LabTest.BIRCH_IGE_T3}`]: 'Birch IgE (T3)',
			[`lab_test_${LabTest.VIBURNUM_IGE_T210}`]: 'Viburnum IgE (T210)',
			[`lab_test_${LabTest.ALDER_IGE_T2}`]: 'Alder IgE (T2)',
			[`lab_test_${LabTest.POPLAR_IGE_T14}`]: 'Poplar IgE (T14)',
			[`lab_test_${LabTest.CYPRESS_IGE_T23}`]: 'Cypress IgE (T23)',
			[`lab_test_${LabTest.WILLOW_IGE_T12}`]: 'Willow IgE (T12)',
			[`lab_test_${LabTest.PLANE_TREE_IGE_T11}`]: 'Plane Tree IgE (T11)',
			[`lab_test_${LabTest.TREE_POLLEN_MIX_TX1}`]: 'Tree Pollen Mix (TX1)',
			[`lab_test_${LabTest.TREE_POLLEN_MIX_TX9}`]: 'Tree Pollen Mix (TX9)',

			// Animals
			[`lab_test_${LabTest.CAT_EPITHELIUM_AND_HAIR_IGE_E1}`]:
				'Cat Epithelium and Hair IgE (E1)',
			[`lab_test_${LabTest.DOG_EPITHELIUM_IGE_E2}`]: 'Dog Epithelium IgE (E2)',
			[`lab_test_${LabTest.DOG_HAIR_IGE_E2}`]: 'Dog Hair IgE (E2)',
			[`lab_test_${LabTest.HORSE_IGE_E3}`]: 'Horse IgE (E3)',
			[`lab_test_${LabTest.COW_DANDER_IGE_E4}`]: 'Cow Dander IgE (E4)',
			[`lab_test_${LabTest.HAMSTER_IGE_E6}`]: 'Hamster IgE (E6)',
			[`lab_test_${LabTest.GUINEA_PIG_IGE_E84}`]: 'Guinea Pig IgE (E84)',
			[`lab_test_${LabTest.RABBIT_IGE_E82}`]: 'Rabbit IgE (E82)',
			[`lab_test_${LabTest.SHEEP_IGE_E81}`]: 'Sheep IgE (E81)',
			[`lab_test_${LabTest.MINK_IGE_E8}`]: 'Mink IgE (E8)',
			[`lab_test_${LabTest.CANARY_IGE_E9}`]: 'Canary IgE (E9)',
			[`lab_test_${LabTest.PIGEON_IGE_E11}`]: 'Pigeon IgE (E11)',
			[`lab_test_${LabTest.PARROT_IGE_E213}`]: 'Parrot IgE (E213)',
			[`lab_test_${LabTest.HAIR_MIX_EX1}`]: 'Hair Mix (EX1)',
			[`lab_test_${LabTest.FEATHER_MIX_EX71}`]: 'Feather Mix (EX71)',
			[`lab_test_${LabTest.PET_MIX_EX2}`]: 'Pet Mix (EX2)',

			// Mites & Insects
			[`lab_test_${LabTest.HOUSE_DUST_MITE_IGE_H1}`]:
				'House Dust Mite IgE (H1)',
			[`lab_test_${LabTest.HOUSE_DUST_MITE_IGE_H2}`]:
				'House Dust Mite IgE (H2)',
			[`lab_test_${LabTest.HOUSE_DUST_MITE_IGE_H3}`]:
				'House Dust Mite IgE (H3)',
			[`lab_test_${LabTest.ACARUS_SIRO_IGE_D2}`]: 'Acarus siro IgE (D2)',
			[`lab_test_${LabTest.STORAGE_MITE_IGE_D1}`]: 'Storage Mite IgE (D1)',
			[`lab_test_${LabTest.HOUSE_DUST_MIX_HX1}`]: 'House Dust Mix (HX1)',
			[`lab_test_${LabTest.SPIDER_IGE_76}`]: 'Spider IgE (76)',
			[`lab_test_${LabTest.BEE_IGE_I1}`]: 'Bee IgE (I1)',
			[`lab_test_${LabTest.WASP_IGE_I3}`]: 'Wasp IgE (I3)',
			[`lab_test_${LabTest.HORNET_IGE_I75}`]: 'Hornet IgE (I75)',
			[`lab_test_${LabTest.COCKROACH_IGE_I6}`]: 'Cockroach IgE (I6)',
			[`lab_test_${LabTest.MOSQUITO_IGE_I71}`]: 'Mosquito IgE (I71)',

			// Molds
			[`lab_test_${LabTest.MOLD_MIX_MX1}`]: 'Mold Mix (MX1)',
			[`lab_test_${LabTest.MOLD_MIX_MX4}`]: 'Mold Mix (MX4)',
			[`lab_test_${LabTest.STAPHYLOCOCCAL_ENTEROTOXIN_A}`]:
				'Staphylococcal Enterotoxin A',
			[`lab_test_${LabTest.STAPHYLOCOCCAL_ENTEROTOXIN_B}`]:
				'Staphylococcal Enterotoxin B',
			[`lab_test_${LabTest.PITYROSPORUM_ORBICULARE}`]:
				'Pityrosporum orbiculare',

			// Drug Allergens
			[`lab_test_${LabTest.PENICILLOYL_G_HSA_C1}`]: 'Penicilloyl G-HSA (C1)',
			[`lab_test_${LabTest.PENICILLOYL_V_HSA_C2}`]: 'Penicilloyl V-HSA (C2)',
			[`lab_test_${LabTest.PENICILLOYL_G_IGE_C1}`]: 'Penicilloyl G IgE (C1)',
			[`lab_test_${LabTest.PENICILLOYL_V_IGE_C2}`]: 'Penicilloyl V IgE (C2)',
			[`lab_test_${LabTest.LIDOCAINE_XYLOCAINE_C232}`]:
				'Lidocaine (Xylocaine) (C232)',
			[`lab_test_${LabTest.IBUPROFEN_IGE_C286}`]: 'Ibuprofen IgE (C286)',
			[`lab_test_${LabTest.DICLOFENAC_IGE_C281}`]: 'Diclofenac IgE (C281)',
			[`lab_test_${LabTest.PARACETAMOL_ACETAMINOPHEN_IGE_C2}`]:
				'Paracetamol (Acetaminophen) IgE (C2)',

			// Others
			[`lab_test_${LabTest.TOBACCO_IGE_0201}`]: 'Tobacco IgE (0201)',
			[`lab_test_${LabTest.COTTON_IGE_K2}`]: 'Cotton IgE (K2)',
			[`lab_test_${LabTest.WOOL_PROCESSED_IGE_K20}`]:
				'Wool (processed) IgE (K20)',
			[`lab_test_${LabTest.FRAGRANCE_MIX_IGE_G1}`]: 'Fragrance Mix IgE (G1)',
			[`lab_test_${LabTest.FOOD_INTOLERANCE_108_PANEL}`]:
				'Food Intolerance (108 Panel)',
			[`lab_test_${LabTest.LACTOSE_INTOLERANCE_PCR}`]:
				'Lactose Intolerance (PCR)',
			[`lab_test_${LabTest.LACTOSE_INTOLERANCE}`]: 'Lactose Intolerance',

			// Vitamins
			[`lab_test_${LabTest.FOLIC_ACID}`]: 'Folic Acid',
			[`lab_test_${LabTest.VITAMIN_A_LEVEL}`]: 'Vitamin A Level',
			[`lab_test_${LabTest.VITAMIN_A}`]: 'Vitamin A',
			[`lab_test_${LabTest.VITAMIN_E_LEVEL}`]: 'Vitamin E Level',
			[`lab_test_${LabTest.VITAMIN_B6_LEVEL}`]: 'Vitamin B6 Level',
			[`lab_test_${LabTest.VITAMIN_C_LEVEL}`]: 'Vitamin C Level',
			[`lab_test_${LabTest.VITAMIN_B1_LEVEL}`]: 'Vitamin B1 Level',
			[`lab_test_${LabTest.VITAMIN_H_B7_BIOTIN_LEVEL}`]:
				'Vitamin H (B7, Biotin) Level',
			[`lab_test_${LabTest.VITAMIN_B2}`]: 'Vitamin B2',
			[`lab_test_${LabTest.VITAMIN_K1_LEVEL}`]: 'Vitamin K1 Level',
			[`lab_test_${LabTest.BETA_CAROTENE}`]: 'Beta-Carotene',
			[`lab_test_${LabTest.VITAMIN_1_25_OH2_D}`]: 'Vitamin 1,25-(OH)2-D',
			[`lab_test_${LabTest.METHYLMALONIC_ACID}`]: 'Methylmalonic Acid',
			[`lab_test_${LabTest.OMEGA_6_OMEGA_3_FATTY_ACIDS}`]:
				'Omega-6/Omega-3 Fatty Acids',

			// Therapeutic Drug Monitoring
			[`lab_test_${LabTest.VALPROIC_ACID_LEVEL}`]: 'Valproic Acid Level',
			[`lab_test_${LabTest.CARBAMAZEPINE_LEVEL}`]: 'Carbamazepine Level',
			[`lab_test_${LabTest.PHENOBARBITAL_LEVEL}`]: 'Phenobarbital Level',
			[`lab_test_${LabTest.DIGOXIN_LEVEL}`]: 'Digoxin Level',
			[`lab_test_${LabTest.LAMOTRIGINE_LEVEL}`]: 'Lamotrigine Level',
			[`lab_test_${LabTest.CYCLOSPORINE_LEVEL}`]: 'Cyclosporine Level',
			[`lab_test_${LabTest.LEVETIRACETAM_LEVEL}`]: 'Levetiracetam Level',
			[`lab_test_${LabTest.SIROLIMUS_LEVEL}`]: 'Sirolimus Level',
			[`lab_test_${LabTest.AMIODARONE_LEVEL}`]: 'Amiodarone Level',
			[`lab_test_${LabTest.TACROLIMUS_LEVEL}`]: 'Tacrolimus Level',
			[`lab_test_${LabTest.VANCOMYCIN_LEVEL}`]: 'Vancomycin Level',
			[`lab_test_${LabTest.ADALIMUMAB_LEVEL}`]: 'Adalimumab Level',
			[`lab_test_${LabTest.INFLIXIMAB_LEVEL}`]: 'Infliximab Level',
			[`lab_test_${LabTest.ADALIMUMAB_ANTIBODIES}`]: 'Adalimumab Antibodies',
			[`lab_test_${LabTest.INFLIXIMAB_ANTIBODIES}`]: 'Infliximab Antibodies',
			[`lab_test_${LabTest.OXCARBAZEPINE_LEVEL}`]: 'Oxcarbazepine Level',

			// Reproductive & Andrology
			[`lab_test_${LabTest.SPERMOGRAM}`]: 'Spermogram',
			[`lab_test_${LabTest.POST_EJACULATORY_URINE}`]: 'Post-Ejaculatory Urine',
			[`lab_test_${LabTest.DNA_FRAGMENTATION_INDEX}`]:
				'DNA Fragmentation Index',
			[`lab_test_${LabTest.BIOCHEMICAL_ANALYSIS_SEMINAL_PLASMA}`]:
				'Biochemical Analysis of Seminal Plasma',

			// Microbiology - Swabs & Cultures (Bacteria)
			[`lab_test_${LabTest.THROAT_SWAB_BACTERIA}`]: 'Throat Swab - Bacteria',
			[`lab_test_${LabTest.THROAT_SWAB_BACTERIA_AEROBIC}`]:
				'Throat Swab - Bacteria (Aerobic)',
			[`lab_test_${LabTest.RAPID_STREP_A}`]: 'Rapid Strep A Test',
			[`lab_test_${LabTest.SPUTUM_BACTERIA}`]: 'Sputum - Bacteria',
			[`lab_test_${LabTest.NOSE_SWAB_BACTERIA}`]: 'Nose Swab - Bacteria',
			[`lab_test_${LabTest.NASOPHARYNGEAL_SWAB_BACTERIA}`]:
				'Nasopharyngeal Swab - Bacteria',
			[`lab_test_${LabTest.NOSE_SINUS_CONTENT_BACTERIA}`]:
				'Nose Sinus Content - Bacteria',
			[`lab_test_${LabTest.ORAL_CAVITY_SWAB_BACTERIA}`]:
				'Oral Cavity Swab - Bacteria',
			[`lab_test_${LabTest.TONGUE_SWAB_BACTERIA}`]: 'Tongue Swab - Bacteria',
			[`lab_test_${LabTest.GUM_SWAB_BACTERIA}`]: 'Gum Swab - Bacteria',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_PHARYNGEAL_SWAB}`]:
				'Pharyngeal Swab - Bacteriological',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_THROAT_SWAB}`]:
				'Throat Swab - Bacteriological',
			[`lab_test_${LabTest.RIGHT_EYE_SWAB_BACTERIA}`]:
				'Right Eye Swab - Bacteria',
			[`lab_test_${LabTest.LEFT_EYE_SWAB}`]: 'Left Eye Swab',
			[`lab_test_${LabTest.RIGHT_EAR_SWAB_BACTERIA}`]:
				'Right Ear Swab - Bacteria',
			[`lab_test_${LabTest.LEFT_EAR_SWAB_BACTERIA}`]:
				'Left Ear Swab - Bacteria',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_EAR_SWAB}`]:
				'Ear Swab - Bacteriological',
			[`lab_test_${LabTest.ACNE_SWAB_BACTERIA}`]: 'Acne Swab - Bacteria',
			[`lab_test_${LabTest.SKIN_SWAB_BACTERIA}`]: 'Skin Swab - Bacteria',
			[`lab_test_${LabTest.SKIN_SWAB_BACTERIA_II}`]: 'Skin Swab - Bacteria II',
			[`lab_test_${LabTest.WOUND_SWAB_BACTERIA}`]: 'Wound Swab - Bacteria',
			[`lab_test_${LabTest.WOUND_SWAB_II}`]: 'Wound Swab II',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_WOUND_CONTENT}`]:
				'Wound Content - Bacteriological',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_ABSCESS_CONTENT}`]:
				'Abscess Content - Bacteriological',
			[`lab_test_${LabTest.PUNCTATE_AEROBIC}`]: 'Punctate - Aerobic',

			// Genital & Urinary Cultures
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_URETHRAL_SWAB}`]:
				'Urethral Swab - Bacteriological',
			[`lab_test_${LabTest.URETHRAL_SWAB_BACTERIA}`]:
				'Urethral Swab - Bacteria',
			[`lab_test_${LabTest.URETHRAL_SWAB_FOR_GONORRHEA}`]:
				'Urethral Swab for Gonorrhea',
			[`lab_test_${LabTest.GLANS_SWAB_BACTERIA}`]: 'Glans Swab - Bacteria',
			[`lab_test_${LabTest.PREPUCE_SWAB_BACTERIA}`]: 'Prepuce Swab - Bacteria',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_VAGINAL_SWAB}`]:
				'Vaginal Swab - Bacteriological',
			[`lab_test_${LabTest.VAGINAL_SWAB_BACTERIA}`]: 'Vaginal Swab - Bacteria',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_CERVICAL_SWAB}`]:
				'Cervical Swab - Bacteriological',
			[`lab_test_${LabTest.CERVICAL_SWAB_BACTERIA}`]:
				'Cervical Swab - Bacteria',
			[`lab_test_${LabTest.ENDOCERVICAL_SWAB_FOR_GONORRHEA}`]:
				'Endocervical Swab for Gonorrhea',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_VULVAR_SWAB}`]:
				'Vulvar Swab - Bacteriological',
			[`lab_test_${LabTest.VULVAR_SWAB_BACTERIA}`]: 'Vulvar Swab - Bacteria',
			[`lab_test_${LabTest.BARTHOLIN_GLAND_SWAB_BACTERIA}`]:
				'Bartholin Gland Swab - Bacteria',
			[`lab_test_${LabTest.VAGINAL_SECRETION}`]: 'Vaginal Secretion',
			[`lab_test_${LabTest.VAGINAL_SECRETION_GROUP}`]:
				'Vaginal Secretion Group',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_LOCHIA}`]:
				'Lochia - Bacteriological',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_URINE_CULTURE}`]:
				'Urine Culture - Bacteriological',
			[`lab_test_${LabTest.URINE_CULTURE}`]: 'Urine Culture',
			[`lab_test_${LabTest.BACTERIOLOGICAL_EXAMINATION_SEMEN}`]:
				'Semen - Bacteriological',
			[`lab_test_${LabTest.SPERM_CULTURE_BACTERIA}`]:
				'Sperm Culture - Bacteria',
			[`lab_test_${LabTest.PROSTATIC_FLUID_BACTERIA}`]:
				'Prostatic Fluid - Bacteria',
			[`lab_test_${LabTest.RIGHT_NIPPLE_SWAB_BACTERIA}`]:
				'Right Nipple Swab - Bacteria',
			[`lab_test_${LabTest.LEFT_NIPPLE_SWAB_BACTERIA}`]:
				'Left Nipple Swab - Bacteria',
			[`lab_test_${LabTest.BREAST_MILK_BACTERIA}`]: 'Breast Milk - Bacteria',
			[`lab_test_${LabTest.NIPPLE_DISCHARGE_BACTERIA}`]:
				'Nipple Discharge - Bacteria',

			// Stool Cultures
			[`lab_test_${LabTest.STOOL_CULTURE}`]: 'Stool Culture',
			[`lab_test_${LabTest.PERIANAL_SWAB}`]: 'Perianal Swab',
			[`lab_test_${LabTest.GBS_CULTURE}`]:
				'GBS Culture (Group B Streptococcus)',
			[`lab_test_${LabTest.MYCOPLASMA_HOMINIS_UREAPLASMA}`]:
				'Mycoplasma hominis & Ureaplasma',
			[`lab_test_${LabTest.MYCOPLASMA_HOMINIS_UREAPLASMA_CULTURE}`]:
				'Mycoplasma hominis & Ureaplasma Culture',

			// Fungal Cultures
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_URETHRAL_SWAB}`]:
				'Urethral Swab - Fungal',
			[`lab_test_${LabTest.URETHRAL_SWAB_FUNGI}`]: 'Urethral Swab - Fungi',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_VAGINAL_SWAB}`]:
				'Vaginal Swab - Fungal',
			[`lab_test_${LabTest.VAGINAL_SWAB_FUNGI}`]: 'Vaginal Swab - Fungi',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_CERVICAL_SWAB}`]:
				'Cervical Swab - Fungal',
			[`lab_test_${LabTest.CERVICAL_SWAB_FUNGI}`]: 'Cervical Swab - Fungi',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_VULVAR_SWAB}`]:
				'Vulvar Swab - Fungal',
			[`lab_test_${LabTest.VULVAR_SWAB_FUNGI}`]: 'Vulvar Swab - Fungi',
			[`lab_test_${LabTest.BARTHOLIN_GLAND_SWAB_FUNGI}`]:
				'Bartholin Gland Swab - Fungi',
			[`lab_test_${LabTest.GLANS_SWAB_FUNGI}`]: 'Glans Swab - Fungi',
			[`lab_test_${LabTest.PREPUCE_SWAB_FUNGI}`]: 'Prepuce Swab - Fungi',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_URINE}`]: 'Urine - Fungal',
			[`lab_test_${LabTest.URINE_FUNGI}`]: 'Urine - Fungi',
			[`lab_test_${LabTest.SEMINAL_FLUID_FUNGAL_TEST}`]:
				'Seminal Fluid - Fungal',
			[`lab_test_${LabTest.SPERM_CULTURE_FUNGI}`]: 'Sperm Culture - Fungi',
			[`lab_test_${LabTest.PROSTATIC_FLUID_FUNGI}`]: 'Prostatic Fluid - Fungi',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_PHARYNGEAL_SWAB}`]:
				'Pharyngeal Swab - Fungal',
			[`lab_test_${LabTest.FUNGAL_EXAMINATION_THROAT_SWAB}`]:
				'Throat Swab - Fungal',
			[`lab_test_${LabTest.THROAT_SWAB_FUNGI}`]: 'Throat Swab - Fungi',
			[`lab_test_${LabTest.THROAT_SWAB_FUNGI_CULTURE}`]:
				'Throat Swab - Fungi Culture',
			[`lab_test_${LabTest.ORAL_CAVITY_FUNGI}`]: 'Oral Cavity - Fungi',
			[`lab_test_${LabTest.GUM_SWAB_FUNGI}`]: 'Gum Swab - Fungi',
			[`lab_test_${LabTest.NASOPHARYNGEAL_SWAB_FUNGI}`]:
				'Nasopharyngeal Swab - Fungi',
			[`lab_test_${LabTest.NOSE_SWAB_FUNGI}`]: 'Nose Swab - Fungi',
			[`lab_test_${LabTest.RIGHT_EYE_SWAB_FUNGI}`]: 'Right Eye Swab - Fungi',
			[`lab_test_${LabTest.LEFT_EYE_SWAB_FUNGI}`]: 'Left Eye Swab - Fungi',
			[`lab_test_${LabTest.RIGHT_EAR_SWAB_FUNGI}`]: 'Right Ear Swab - Fungi',
			[`lab_test_${LabTest.LEFT_EAR_SWAB_FUNGI}`]: 'Left Ear Swab - Fungi',
			[`lab_test_${LabTest.ACNE_FUNGI}`]: 'Acne - Fungi',
			[`lab_test_${LabTest.SKIN_SWAB_FUNGI}`]: 'Skin Swab - Fungi',
			[`lab_test_${LabTest.SKIN_SCRAPING_FUNGI}`]: 'Skin Scraping - Fungi',
			[`lab_test_${LabTest.DERMATOPHYTES_SKIN_SCRAPING}`]:
				'Dermatophytes - Skin Scraping',
			[`lab_test_${LabTest.NATIVE_MYCOLOGICAL_SKIN}`]:
				'Native Mycological Examination - Skin',
			[`lab_test_${LabTest.NAIL_SWAB_FUNGI}`]: 'Nail Swab - Fungi',
			[`lab_test_${LabTest.NAIL_SCRAPING_FUNGI}`]: 'Nail Scraping - Fungi',
			[`lab_test_${LabTest.DERMATOPHYTES_NAIL_SCRAPING}`]:
				'Dermatophytes - Nail Scraping',
			[`lab_test_${LabTest.NATIVE_MYCOLOGICAL_NAIL}`]:
				'Native Mycological Examination - Nail',
			[`lab_test_${LabTest.WOUND_SWAB_FUNGI}`]: 'Wound Swab - Fungi',
			[`lab_test_${LabTest.WOUND_II_FUNGI}`]: 'Wound II - Fungi',
			[`lab_test_${LabTest.PERIANAL_SWAB_FUNGI}`]: 'Perianal Swab - Fungi',
			[`lab_test_${LabTest.SPUTUM_FUNGI}`]: 'Sputum - Fungi',
			[`lab_test_${LabTest.STOOL_FUNGI}`]: 'Stool - Fungi',
			[`lab_test_${LabTest.RIGHT_NIPPLE_SWAB_FUNGI}`]:
				'Right Nipple Swab - Fungi',
			[`lab_test_${LabTest.BREAST_MILK_FUNGI}`]: 'Breast Milk - Fungi',
			[`lab_test_${LabTest.NIPPLE_DISCHARGE_FUNGI}`]:
				'Nipple Discharge - Fungi',
			[`lab_test_${LabTest.CANDIDA_IGM_ANTIBODIES}`]: 'Candida IgM Antibodies',
			[`lab_test_${LabTest.CANDIDA_IGG_ANTIBODIES}`]: 'Candida IgG Antibodies',
			[`lab_test_${LabTest.GALACTOMANNAN_TEST_ASPERGILLUS}`]:
				'Galactomannan Test (Aspergillus)',

			// Microscopy
			[`lab_test_${LabTest.DIRECT_MICROSCOPIC_PREPARATION_CERVICAL}`]:
				'Direct Microscopic Preparation - Cervical',
			[`lab_test_${LabTest.DIRECT_MICROSCOPIC_PREPARATION_VAGINAL}`]:
				'Direct Microscopic Preparation - Vaginal',
			[`lab_test_${LabTest.DIRECT_MICROSCOPIC_PREPARATION}`]:
				'Direct Microscopic Preparation',
			[`lab_test_${LabTest.VAGINAL_MICROSCOPIC_PREPARATION}`]:
				'Vaginal Microscopic Preparation',
			[`lab_test_${LabTest.CERVICAL_MICROSCOPIC_PREPARATION}`]:
				'Cervical Microscopic Preparation',
			[`lab_test_${LabTest.DIRECT_MICROSCOPIC_PREPARATION_SWAB}`]:
				'Direct Microscopic Preparation - Swab',
			[`lab_test_${LabTest.DEMODEX_SPECIES}`]: 'Demodex Species',
			[`lab_test_${LabTest.PERIANAL_IMPRESSION}`]: 'Perianal Impression',

			// STD & IHT Tests
			[`lab_test_${LabTest.TRICHOMONAS_TEST}`]: 'Trichomonas Test',
			[`lab_test_${LabTest.TRICHOMONAS_TEST_URETHRAL}`]:
				'Trichomonas Test - Urethral',
			[`lab_test_${LabTest.TRICHOMONAS_VAGINALIS_IHT}`]:
				'Trichomonas vaginalis (IHT)',
			[`lab_test_${LabTest.CHLAMYDIA_ELISA_CERVICAL}`]:
				'Chlamydia ELISA - Cervical',
			[`lab_test_${LabTest.CHLAMYDIA_ELISA_URETHRAL}`]:
				'Chlamydia ELISA - Urethral',
			[`lab_test_${LabTest.CHLAMYDIA_TRACHOMATIS_IHT}`]:
				'Chlamydia trachomatis (IHT)',
			[`lab_test_${LabTest.GENITAL_MYCOPLASMA_TEST_VAGINAL}`]:
				'Genital Mycoplasma Test - Vaginal',
			[`lab_test_${LabTest.GENITAL_MYCOPLASMA_TEST_URETHRAL}`]:
				'Genital Mycoplasma Test - Urethral',
			[`lab_test_${LabTest.MYCOPLASMA_TEST_URINE}`]: 'Mycoplasma Test - Urine',
			[`lab_test_${LabTest.MYCOPLASMA_TEST_EAR}`]: 'Mycoplasma Test - Ear',
			[`lab_test_${LabTest.GONOCOCCUS_IHT}`]: 'Gonococcus (IHT)',
			[`lab_test_${LabTest.AMINE_TEST}`]: 'Amine Test',
			[`lab_test_${LabTest.IMMUNOCHROMATOGRAPHIC_TEST_DETECTION}`]:
				'Immunochromatographic Test Detection',

			// Stool Tests - IHT
			[`lab_test_${LabTest.ADENOVIRUS_ROTAVIRUS_IN_STOOL}`]:
				'Adenovirus & Rotavirus in Stool',
			[`lab_test_${LabTest.ENTAMOEBA_HISTOLYTICA_IHT}`]:
				'Entamoeba histolytica (IHT)',
			[`lab_test_${LabTest.GIARDIA_LAMBLIA_IHT}`]: 'Giardia lamblia (IHT)',
			[`lab_test_${LabTest.CLOSTRIDIUM_DIFFICILE_TOXIN_A_AND_B}`]:
				'Clostridium difficile Toxin A & B',
			[`lab_test_${LabTest.CAMPYLOBACTER_IHT}`]: 'Campylobacter (IHT)',

			// PCR - Viral
			[`lab_test_${LabTest.HCV_PCR_QUANTITATIVE}`]: 'HCV PCR (Quantitative)',
			[`lab_test_${LabTest.HCV_PCR_RNA_QUALITATIVE}`]:
				'HCV PCR RNA (Qualitative)',
			[`lab_test_${LabTest.HCV_PCR_RNA_QUANTITATIVE}`]:
				'HCV PCR RNA (Quantitative)',
			[`lab_test_${LabTest.HCV_RNA_GENOTYPING}`]: 'HCV RNA Genotyping',
			[`lab_test_${LabTest.HBV_DNA_QUANTITATIVE}`]: 'HBV DNA (Quantitative)',
			[`lab_test_${LabTest.HBV_PCR_DNA_QUANTITATIVE}`]:
				'HBV PCR DNA (Quantitative)',
			[`lab_test_${LabTest.HIV_PCR_RNA_QUANTITATIVE}`]:
				'HIV PCR RNA (Quantitative)',
			[`lab_test_${LabTest.HIV_HCV_HBV_PCR_QUALITATIVE}`]:
				'HIV, HCV, HBV PCR (Qualitative)',
			[`lab_test_${LabTest.HUMAN_HERPESVIRUS_6_PCR}`]:
				'Human Herpesvirus 6 PCR',
			[`lab_test_${LabTest.HHV_6}`]: 'HHV-6',
			[`lab_test_${LabTest.HUMAN_HERPESVIRUS_8_PCR}`]:
				'Human Herpesvirus 8 PCR',
			[`lab_test_${LabTest.HERPES_SIMPLEX_VIRUS_TYPE_1_2_PCR}`]:
				'Herpes Simplex Virus Type 1+2 PCR',
			[`lab_test_${LabTest.BK_VIRUS_PCR}`]: 'BK Virus PCR',
			[`lab_test_${LabTest.BK_VIRUS_PCR_URINE}`]: 'BK Virus PCR (Urine)',

			// PCR - Bacterial
			[`lab_test_${LabTest.BORRELIA_BURGDORFERI_PCR}`]:
				'Borrelia Burgdorferi PCR',
			[`lab_test_${LabTest.BORDETELLA_PERTUSSIS_PCR}`]:
				'Bordetella Pertussis PCR',

			// PCR - STD Panels
			[`lab_test_${LabTest.STD_4_HPV_CHLAMYDIA}`]:
				'STD Panel 4 (HPV, Chlamydia)',
			[`lab_test_${LabTest.STD_3_MYCOPLASMA_UREAPLASMA}`]:
				'STD Panel 3 (Mycoplasma, Ureaplasma)',
			[`lab_test_${LabTest.STD_7}`]: 'STD Panel 7',
			[`lab_test_${LabTest.CHLAMYDIA_TRACHOMATIS_PCR_URINE}`]:
				'Chlamydia trachomatis PCR (Urine)',
			[`lab_test_${LabTest.CHLAMYDIA_TRACHOMATIS_PLUS_UREAPLASMA}`]:
				'Chlamydia trachomatis + Ureaplasma',
			[`lab_test_${LabTest.MYCOPLASMA_PANEL_PCR}`]: 'Mycoplasma Panel PCR',
			[`lab_test_${LabTest.UREAPLASMA_PARVUM_PCR}`]: 'Ureaplasma parvum PCR',
			[`lab_test_${LabTest.UREAPLASMA_UREALYTICUM_PCR_URINE}`]:
				'Ureaplasma urealyticum PCR (Urine)',
			[`lab_test_${LabTest.UREAPLASMA_UREALYTICUM_PCR}`]:
				'Ureaplasma urealyticum PCR',
			[`lab_test_${LabTest.NEISSERIA_GONORRHOEAE_PCR_URINE}`]:
				'Neisseria gonorrhoeae PCR (Urine)',
			[`lab_test_${LabTest.GONOCOCCUS_PCR_SWAB}`]: 'Gonococcus PCR (Swab)',
			[`lab_test_${LabTest.STD_LARGE_PANEL_PCR_SWAB}`]:
				'STD Large Panel PCR (Swab)',
			[`lab_test_${LabTest.STD_MEDIUM_PANEL_PCR_SWAB}`]:
				'STD Medium Panel PCR (Swab)',
			[`lab_test_${LabTest.STD_LARGE_PANEL_PCR_URINE}`]:
				'STD Large Panel PCR (Urine)',
			[`lab_test_${LabTest.STD_MEDIUM_PANEL_PCR_URINE}`]:
				'STD Medium Panel PCR (Urine)',

			// HPV
			[`lab_test_${LabTest.HPV_14_TYPES_PCR}`]: 'HPV 14 Types PCR',
			[`lab_test_${LabTest.HPV_41_GENOTYPES_PCR}`]: 'HPV 41 Genotypes PCR',
			[`lab_test_${LabTest.PAP_PAPANICOLAOU_TEST}`]: 'PAP (Papanicolaou) Test',

			// Genetics - Thrombophilia
			[`lab_test_${LabTest.MTHFR}`]: 'MTHFR',
			[`lab_test_${LabTest.MTHFR_LOCUS_677_PCR}`]: 'MTHFR Locus 677 PCR',
			[`lab_test_${LabTest.MTHFR_LOCUS_1298}`]: 'MTHFR Locus 1298',
			[`lab_test_${LabTest.MTHFR_2_LOCI}`]: 'MTHFR 2 Loci',
			[`lab_test_${LabTest.PAI_1}`]: 'PAI-1',
			[`lab_test_${LabTest.PAI_1_675_4G_5G}`]: 'PAI-1 -675 (4G/5G)',
			[`lab_test_${LabTest.FACTOR_V}`]: 'Factor V',
			[`lab_test_${LabTest.FACTOR_II}`]: 'Factor II (Prothrombin)',
			[`lab_test_${LabTest.PROTHROMBIN_II_LOCUS_20210_PCR}`]:
				'Prothrombin II Locus 20210 PCR',
			[`lab_test_${LabTest.FACTOR_V_HR2_LOCUS_4070}`]:
				'Factor V HR2 Locus 4070',
			[`lab_test_${LabTest.FACTOR_V_LEIDEN_LOCUS_1691}`]:
				'Factor V Leiden Locus 1691',
			[`lab_test_${LabTest.FACTOR_XIII_LOCUS_V34L}`]: 'Factor XIII Locus V34L',
			[`lab_test_${LabTest.FACTOR_V_2_LOCI}`]: 'Factor V (2 Loci)',
			[`lab_test_${LabTest.THROMBOPHILIA_3_GENES_3_LOCI}`]:
				'Thrombophilia (3 Genes, 3 Loci)',
			[`lab_test_${LabTest.THROMBOPHILIA_3_GENES_5_LOCI}`]:
				'Thrombophilia (3 Genes, 5 Loci)',
			[`lab_test_${LabTest.THROMBOPHILIA_4_GENES_6_LOCI}`]:
				'Thrombophilia (4 Genes, 6 Loci)',

			// Genetics - HLA & Immunogenetics
			[`lab_test_${LabTest.HLA_B27}`]: 'HLA-B27',
			[`lab_test_${LabTest.HLA_B27_ANTIGEN}`]: 'HLA-B27 Antigen',
			[`lab_test_${LabTest.HLA_DQ_2_8}`]: 'HLA-DQ 2/8',
			[`lab_test_${LabTest.HLA_DQ2_DQ8_TYPING}`]: 'HLA-DQ2/DQ8 Typing',
			[`lab_test_${LabTest.HLA_B5701}`]: 'HLA-B*5701',
			[`lab_test_${LabTest.ANTIGEN_D_GENOTYPING_RHD}`]:
				'Antigen D Genotyping (RhD)',

			// Genetics - Paternity & Identity
			[`lab_test_${LabTest.DNA_TEST_2_PERSONS}`]: 'DNA Test (2 Persons)',
			[`lab_test_${LabTest.DNA_TEST_3_PERSONS}`]: 'DNA Test (3 Persons)',
			[`lab_test_${LabTest.PATERNITY_TESTING_PCR}`]: 'Paternity Testing PCR',
			[`lab_test_${LabTest.PATERNITY_REPORT}`]: 'Paternity Report',

			// Genetics - Karyotype & Chromosomes
			[`lab_test_${LabTest.KARYOTYPE}`]: 'Karyotype',
			[`lab_test_${LabTest.KARYOTYPE_FROM_PERIPHERAL_BLOOD}`]:
				'Karyotype from Peripheral Blood',
			[`lab_test_${LabTest.Y_CHROMOSOME_MICRODELETION}`]:
				'Y Chromosome Microdeletion',
			[`lab_test_${LabTest.Y_CHROMOSOME_MICRODELETION_11}`]:
				'Y Chromosome Microdeletion (11)',
			[`lab_test_${LabTest.NUMERICAL_ABERRATION_ANALYSIS_CHROMOSOMES}`]:
				'Numerical Aberration Analysis (Chromosomes)',
			[`lab_test_${LabTest.MICROSATELLITE_INSTABILITY}`]:
				'Microsatellite Instability',
			[`lab_test_${LabTest.MICRODELETION_SYNDROMES_ANGELMAN}`]:
				'Microdeletion Syndromes (Angelman)',
			[`lab_test_${LabTest.NIPT_SILVER}`]: 'NIPT Silver',
			[`lab_test_${LabTest.MICRONUCLEUS_TEST}`]: 'Micronucleus Test',

			// Genetics - Hereditary Diseases
			[`lab_test_${LabTest.CYSTIC_FIBROSIS_34_MUTATIONS}`]:
				'Cystic Fibrosis (34 Mutations)',
			[`lab_test_${LabTest.HEMOCHROMATOSIS_PCR_C282Y}`]:
				'Hemochromatosis PCR (C282Y)',
			[`lab_test_${LabTest.BETA_THALASSEMIA_PCR}`]: 'Beta-Thalassemia PCR',
			[`lab_test_${LabTest.SMA_SMN1_GENE_COPY_NUMBER}`]:
				'SMA - SMN1 Gene Copy Number',
			[`lab_test_${LabTest.SMA_SMN1_AND_SMN2_COPY_NUMBER}`]:
				'SMA - SMN1 and SMN2 Copy Number',
			[`lab_test_${LabTest.WILSON_DISEASE_PCR}`]: 'Wilson Disease PCR',
			[`lab_test_${LabTest.ALPHA_1_ANTITRYPSIN_GENOTYPING}`]:
				'Alpha-1-Antitrypsin Genotyping',
			[`lab_test_${LabTest.UGT1A1_GILBERT_SYNDROME}`]:
				'UGT1A1 (Gilbert Syndrome)',
			[`lab_test_${LabTest.TPMT_GENE_MUTATION_DETECTION}`]:
				'TPMT Gene Mutation Detection',
			[`lab_test_${LabTest.DIHYDROPYRIMIDINE_DEHYDROGENASE}`]:
				'Dihydropyrimidine Dehydrogenase',

			// Genetics - Neurological
			[`lab_test_${LabTest.FRAGILE_X_SYNDROME_GENE_ANALYSIS}`]:
				'Fragile X Syndrome Gene Analysis',
			[`lab_test_${LabTest.HUNTINGTON_DISEASE_ANALYSIS}`]:
				'Huntington Disease Analysis',
			[`lab_test_${LabTest.SPINOCEREBELLAR_ATAXIAS_SCA}`]:
				'Spinocerebellar Ataxias (SCA)',
			[`lab_test_${LabTest.RETT_SYNDROME_EXONS_3_AND_4}`]:
				'Rett Syndrome (Exons 3 and 4)',
			[`lab_test_${LabTest.AMYOTROPHIC_LATERAL_SCLEROSIS}`]:
				'Amyotrophic Lateral Sclerosis',
			[`lab_test_${LabTest.FRIEDREICH_ATAXIA}`]: 'Friedreich Ataxia',
			[`lab_test_${LabTest.DYT1}`]: 'DYT1 (Dystonia)',
			[`lab_test_${LabTest.DUCHENNE_MUSCULAR_DYSTROPHY}`]:
				'Duchenne Muscular Dystrophy',
			[`lab_test_${LabTest.ARX_GENE}`]: 'ARX Gene',
			[`lab_test_${LabTest.ALDH7A_GENE}`]: 'ALDH7A Gene',
			[`lab_test_${LabTest.SRY_GENE_PCR_DETECTION}`]: 'SRY Gene PCR Detection',

			// Genetics - Cancer
			[`lab_test_${LabTest.BRCA1_BRCA2}`]: 'BRCA1/BRCA2',
			[`lab_test_${LabTest.BRCA1_2_SOMATIC_MUTATIONS}`]:
				'BRCA1/2 Somatic Mutations',
			[`lab_test_${LabTest.ONCOTYPEDX}`]: 'OncotypeDX',
			[`lab_test_${LabTest.NRAS_2_LOCI_12_13}`]: 'NRAS (2 Loci 12,13)',
			[`lab_test_${LabTest.BRAF_MUTATION}`]: 'BRAF Mutation',
			[`lab_test_${LabTest.EGF_EPIDERMAL_GROWTH_FACTOR}`]:
				'EGF (Epidermal Growth Factor)',
			[`lab_test_${LabTest.ALK_FISH}`]: 'ALK (FISH)',
			[`lab_test_${LabTest.HER2_ESTROGEN_PROGESTERONE_RECEPTORS}`]:
				'HER2, Estrogen & Progesterone Receptors',
			[`lab_test_${LabTest.BCR_ABL_MOLECULAR_DETECTION}`]:
				'BCR-ABL Molecular Detection',
			[`lab_test_${LabTest.POLYP_BIOPSY_CERVICAL}`]: 'Polyp Biopsy (Cervical)',

			// Genetics - Panels
			[`lab_test_${LabTest.SENTIS_PANEL_HEREDITARY_CANCER}`]:
				'Sentis Panel - Hereditary Cancer',
			[`lab_test_${LabTest.SENTIS_PANEL_BRCA_1_2}`]: 'Sentis Panel - BRCA 1/2',
			[`lab_test_${LabTest.SENTIS_PANEL_HEREDITARY_THROMBOPHILIA}`]:
				'Sentis Panel - Hereditary Thrombophilia',
			[`lab_test_${LabTest.SENTIS_PANEL_HEREDITARY_CARDIOMYOPATHY}`]:
				'Sentis Panel - Hereditary Cardiomyopathy',
			[`lab_test_${LabTest.SENTIS_PANEL_HEREDITARY_KIDNEY_DISEASE}`]:
				'Sentis Panel - Hereditary Kidney Disease',
			[`lab_test_${LabTest.SENTIS_PANEL_HEREDITARY_EPILEPSY}`]:
				'Sentis Panel - Hereditary Epilepsy',
			[`lab_test_${LabTest.HEREDIGEN_33}`]: 'Heredigen 33',
			[`lab_test_${LabTest.GENETIC_ANALYSIS_STOOL}`]:
				'Genetic Analysis (Stool)',
			[`lab_test_${LabTest.PHARMACOGENOMIC_TEST}`]: 'Pharmacogenomic Test',
			[`lab_test_${LabTest.CLINICAL_EXOME_SEQUENCING}`]:
				'Clinical Exome Sequencing',

			// Protein Electrophoresis
			[`lab_test_${LabTest.PROTEIN_ELECTROPHORESIS_SERUM}`]:
				'Protein Electrophoresis (Serum)',
			[`lab_test_${LabTest.PROTEIN_ELECTROPHORESIS_URINE}`]:
				'Protein Electrophoresis (Urine)',
			[`lab_test_${LabTest.IMMUNOELECTROPHORESIS_PROTEIN_SERUM}`]:
				'Immunoelectrophoresis Protein (Serum)',
			[`lab_test_${LabTest.IMMUNOELECTROPHORESIS_PROTEIN_URINE}`]:
				'Immunoelectrophoresis Protein (Urine)',
			[`lab_test_${LabTest.OLIGOCLONAL_IGG_BANDS_IN_SERUM}`]:
				'Oligoclonal IgG Bands in Serum',

			// Profiles & Panels
			[`lab_test_${LabTest.GLYCEMIA_PROFILE_9_12_17H}`]:
				'Glycemia Profile (9, 12, 17h)',
			[`lab_test_${LabTest.GLYCEMIA_PROFILE_7_9_12_17_21H}`]:
				'Glycemia Profile (7, 9, 12, 17, 21h)',
			[`lab_test_${LabTest.ANA_ENA_PROFILE_15_ANTIBODIES}`]:
				'ANA/ENA Profile (15 Antibodies)',
			[`lab_test_${LabTest.ANA_ENA_PROFILE_25_ANTIBODIES}`]:
				'ANA/ENA Profile (25 Antibodies)',
			[`lab_test_${LabTest.MYOSITIS_PROFILE}`]: 'Myositis Profile',
			[`lab_test_${LabTest.ACYLCARNITINE_PROFILE}`]: 'Acylcarnitine Profile',
			[`lab_test_${LabTest.CARNITINE_ACYLCARNITINE_PROFILE}`]:
				'Carnitine & Acylcarnitine Profile',
			[`lab_test_${LabTest.HIRSUTISM_PROFILE}`]: 'Hirsutism Profile',
			[`lab_test_${LabTest.ANEMIA_BASIC_PANEL}`]: 'Anemia Basic Panel',
			[`lab_test_${LabTest.ANEMIA_EXTENDED_PANEL}`]: 'Anemia Extended Panel',
			[`lab_test_${LabTest.EXECUTIVE_PANEL}`]: 'Executive Panel',
			[`lab_test_${LabTest.OVARIAN_TUMOR_MARKERS}`]: 'Ovarian Tumor Markers',
			[`lab_test_${LabTest.FEMALE_HORMONE_PANEL}`]: 'Female Hormone Panel',
			[`lab_test_${LabTest.FEMALE_HORMONE_PANEL_EXTENDED}`]:
				'Female Hormone Panel (Extended)',
			[`lab_test_${LabTest.FEMALE_PANEL_BASIC}`]: 'Female Panel (Basic)',
			[`lab_test_${LabTest.PREGNANCY_PANEL}`]: 'Pregnancy Panel',
			[`lab_test_${LabTest.TORCH_PANEL}`]: 'TORCH Panel',
			[`lab_test_${LabTest.MALE_PANEL}`]: 'Male Panel',
			[`lab_test_${LabTest.PEDIATRIC_PANEL}`]: 'Pediatric Panel',
			[`lab_test_${LabTest.OSTEOPOROSIS_PANEL}`]: 'Osteoporosis Panel',
			[`lab_test_${LabTest.OSTEOPOROSIS_PANEL_2}`]: 'Osteoporosis Panel 2',
			[`lab_test_${LabTest.PIIINP}`]: 'PIIINP',
			[`lab_test_${LabTest.PROCOLLAGEN_1_INTACT_N_TERMINAL}`]:
				'Procollagen 1 Intact N-Terminal',
		},
		ru: {
			LabTestName: 'Лабораторный анализ',
			AnyLabTest: 'Любой анализ',
			SearchLabTest: 'Поиск анализа',
			NotFound: 'Анализ не найден',

			// Гематология
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT}`]: 'Общий анализ крови',
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT_WITH_LEUKOCYTE_FORMULA}`]:
				'Общий анализ крови с лейкоцитарной формулой',
			[`lab_test_${LabTest.SEDIMENTATION_RATE}`]: 'СОЭ',
			[`lab_test_${LabTest.LEUKOCYTE_FORMULA}`]: 'Лейкоцитарная формула',
			[`lab_test_${LabTest.RETICULOCYTES}`]: 'Ретикулоциты',
			[`lab_test_${LabTest.PLATELETS}`]: 'Тромбоциты',
			[`lab_test_${LabTest.BLOOD_GROUP}`]: 'Группа крови',

			// Коагуляция
			[`lab_test_${LabTest.FIBRINOGEN}`]: 'Фибриноген',
			[`lab_test_${LabTest.BLEEDING_TIME}`]: 'Время кровотечения',
			[`lab_test_${LabTest.COAGULATION_TIME}`]: 'Время свертывания',
			[`lab_test_${LabTest.ACTIVATED_PARTIAL_THROMBOPLASTIN_TIME}`]:
				'АЧТВ (активированное частичное тромбопластиновое время)',
			[`lab_test_${LabTest.D_DIMER}`]: 'Д-димер',
			[`lab_test_${LabTest.INR}`]: 'МНО',

			// Биохимия
			[`lab_test_${LabTest.GLUCOSE}`]: 'Глюкоза',
			[`lab_test_${LabTest.HBA1C}`]: 'Гликированный гемоглобин (HbA1c)',
			[`lab_test_${LabTest.CHOLESTEROL}`]: 'Холестерин',
			[`lab_test_${LabTest.HDL_CHOLESTEROL}`]: 'Холестерин ЛПВП',
			[`lab_test_${LabTest.LDL_CHOLESTEROL}`]: 'Холестерин ЛПНП',
			[`lab_test_${LabTest.TRIGLYCERIDES}`]: 'Триглицериды',
			[`lab_test_${LabTest.CREATININE}`]: 'Креатинин',
			[`lab_test_${LabTest.UREA}`]: 'Мочевина',
			[`lab_test_${LabTest.URIC_ACID}`]: 'Мочевая кислота',
			[`lab_test_${LabTest.TOTAL_PROTEIN}`]: 'Общий белок',
			[`lab_test_${LabTest.ALBUMIN}`]: 'Альбумин',
			[`lab_test_${LabTest.TOTAL_BILIRUBIN}`]: 'Билирубин общий',
			[`lab_test_${LabTest.DIRECT_BILIRUBIN}`]: 'Билирубин прямой',
			[`lab_test_${LabTest.AST}`]: 'АСТ',
			[`lab_test_${LabTest.ALT}`]: 'АЛТ',
			[`lab_test_${LabTest.GAMMA_GT}`]: 'Гамма-ГТ',
			[`lab_test_${LabTest.ALKALINE_PHOSPHATASE}`]: 'Щелочная фосфатаза',
			[`lab_test_${LabTest.AMYLASE}`]: 'Амилаза',
			[`lab_test_${LabTest.LIPASE}`]: 'Липаза',
			[`lab_test_${LabTest.CK}`]: 'Креатинкиназа (КК)',
			[`lab_test_${LabTest.CK_MB}`]: 'КК-МВ',
			[`lab_test_${LabTest.LDH}`]: 'ЛДГ',

			// Электролиты
			[`lab_test_${LabTest.SODIUM}`]: 'Натрий',
			[`lab_test_${LabTest.POTASSIUM}`]: 'Калий',
			[`lab_test_${LabTest.CALCIUM}`]: 'Кальций',
			[`lab_test_${LabTest.IONIZED_CALCIUM}`]: 'Ионизированный кальций',
			[`lab_test_${LabTest.MAGNESIUM}`]: 'Магний',
			[`lab_test_${LabTest.PHOSPHORUS}`]: 'Фосфор',
			[`lab_test_${LabTest.CHLORIDE}`]: 'Хлор',
			[`lab_test_${LabTest.IRON}`]: 'Железо',
			[`lab_test_${LabTest.FERRITIN}`]: 'Ферритин',

			// Гормоны
			[`lab_test_${LabTest.TSH}`]: 'ТТГ',
			[`lab_test_${LabTest.T3}`]: 'Т3',
			[`lab_test_${LabTest.T4}`]: 'Т4',
			[`lab_test_${LabTest.FREE_T3}`]: 'Свободный Т3',
			[`lab_test_${LabTest.FREE_T4}`]: 'Свободный Т4',
			[`lab_test_${LabTest.CORTISOL}`]: 'Кортизол',
			[`lab_test_${LabTest.TESTOSTERONE}`]: 'Тестостерон',
			[`lab_test_${LabTest.ESTRADIOL}`]: 'Эстрадиол',
			[`lab_test_${LabTest.PROGESTERONE}`]: 'Прогестерон',
			[`lab_test_${LabTest.PROLACTIN}`]: 'Пролактин',
			[`lab_test_${LabTest.FSH}`]: 'ФСГ',
			[`lab_test_${LabTest.LH}`]: 'ЛГ',
			[`lab_test_${LabTest.INSULIN}`]: 'Инсулин',
			[`lab_test_${LabTest.C_PEPTIDE}`]: 'С-пептид',
			[`lab_test_${LabTest.PTH}`]: 'Паратгормон',
			[`lab_test_${LabTest.VITAMIN_D_25_OH}`]: 'Витамин D (25-ОН)',
			[`lab_test_${LabTest.VITAMIN_B12}`]: 'Витамин B12',

			// Онкомаркеры
			[`lab_test_${LabTest.PSA}`]: 'ПСА',
			[`lab_test_${LabTest.FREE_PSA}`]: 'Свободный ПСА',
			[`lab_test_${LabTest.CEA}`]: 'РЭА',
			[`lab_test_${LabTest.CA_125}`]: 'СА 125',
			[`lab_test_${LabTest.CA_15_3}`]: 'СА 15-3',
			[`lab_test_${LabTest.CA_19_9}`]: 'СА 19-9',
			[`lab_test_${LabTest.AFP}`]: 'АФП',

			// Маркеры воспаления
			[`lab_test_${LabTest.C_REACTIVE_PROTEIN}`]: 'С-реактивный белок (СРБ)',
			[`lab_test_${LabTest.PROCALCITONIN}`]: 'Прокальцитонин',

			// Анализ мочи
			[`lab_test_${LabTest.COMPLETE_URINALYSIS}`]: 'Общий анализ мочи',
			[`lab_test_${LabTest.MICROALBUMIN}`]: 'Микроальбумин',

			// Инфекционные заболевания
			[`lab_test_${LabTest.COVID_19_PCR}`]: 'COVID-19 ПЦР',
			[`lab_test_${LabTest.COVID_19_ANTIGEN}`]: 'COVID-19 Антиген',
			[`lab_test_${LabTest.HIV_AG_AB}`]: 'ВИЧ Антиген-Антитела',
			[`lab_test_${LabTest.HBSAG}`]: 'HBsAg',
			[`lab_test_${LabTest.ANTI_HCV}`]: 'Анти-HCV',
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGM}`]: 'Цитомегаловирус IgM',
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGG}`]: 'Цитомегаловирус IgG',
			[`lab_test_${LabTest.TOXOPLASMA_IGM}`]: 'Токсоплазма IgM',
			[`lab_test_${LabTest.TOXOPLASMA_IGG}`]: 'Токсоплазма IgG',
			[`lab_test_${LabTest.RUBELLA_IGM}`]: 'Краснуха IgM',
			[`lab_test_${LabTest.RUBELLA_IGG}`]: 'Краснуха IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGM}`]: 'Герпес симплекс I IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGG}`]: 'Герпес симплекс I IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGM}`]: 'Герпес симплекс II IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGG}`]: 'Герпес симплекс II IgG',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGM}`]: 'Эпштейна-Барр IgM',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGG}`]: 'Эпштейна-Барр IgG',
			[`lab_test_${LabTest.TORCH}`]: 'TORCH',
			[`lab_test_${LabTest.HELICOBACTER_PYLORI}`]: 'Хеликобактер пилори',
			[`lab_test_${LabTest.SPERMOGRAM}`]: 'Спермограмма',

			// Генетические тесты
			[`lab_test_${LabTest.KARYOTYPE}`]: 'Кариотип',
			[`lab_test_${LabTest.MTHFR}`]: 'MTHFR',
			[`lab_test_${LabTest.FACTOR_V}`]: 'Фактор V',
			[`lab_test_${LabTest.BRCA1_BRCA2}`]: 'BRCA1/BRCA2',

			// Аллергены
			[`lab_test_${LabTest.IGE}`]: 'IgE',
			[`lab_test_${LabTest.IGA}`]: 'IgA',
			[`lab_test_${LabTest.IGG}`]: 'IgG',
			[`lab_test_${LabTest.IGM}`]: 'IgM',

			// Витамины
			[`lab_test_${LabTest.FOLIC_ACID}`]: 'Фолиевая кислота',
			[`lab_test_${LabTest.VITAMIN_A}`]: 'Витамин A',
			[`lab_test_${LabTest.VITAMIN_E_LEVEL}`]: 'Витамин E',
			[`lab_test_${LabTest.VITAMIN_C_LEVEL}`]: 'Витамин C',
			[`lab_test_${LabTest.VITAMIN_B1_LEVEL}`]: 'Витамин B1',
			[`lab_test_${LabTest.VITAMIN_B2}`]: 'Витамин B2',
			[`lab_test_${LabTest.VITAMIN_B6_LEVEL}`]: 'Витамин B6',

			// Профили и панели
			[`lab_test_${LabTest.LIPID_PROFILE}`]: 'Липидный профиль',
			[`lab_test_${LabTest.CORTISOL_PROFILE}`]: 'Профиль кортизола',
			[`lab_test_${LabTest.PROLACTIN_PROFILE}`]: 'Профиль пролактина',
			[`lab_test_${LabTest.PSA_PROFILE}`]: 'Профиль ПСА',
			[`lab_test_${LabTest.ANEMIA_BASIC_PANEL}`]: 'Базовая панель анемии',
			[`lab_test_${LabTest.ANEMIA_EXTENDED_PANEL}`]:
				'Расширенная панель анемии',
			[`lab_test_${LabTest.TORCH_PANEL}`]: 'TORCH панель',
			[`lab_test_${LabTest.FEMALE_HORMONE_PANEL}`]:
				'Женская гормональная панель',
			[`lab_test_${LabTest.MALE_PANEL}`]: 'Мужская панель',
			[`lab_test_${LabTest.PREGNANCY_PANEL}`]: 'Панель для беременных',
			[`lab_test_${LabTest.TRIPLE_TEST}`]: 'Тройной тест',
			[`lab_test_${LabTest.DOUBLE_TEST}`]: 'Двойной тест',
			[`lab_test_${LabTest.QUADRUPLE_TEST}`]: 'Четверной тест',
		},
		sr: {
			// Hematologija
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT}`]: 'Kompletna krvna slika',
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT_WITH_LEUKOCYTE_FORMULA}`]:
				'Kompletna krvna slika sa leukocitarnom formulom',
			[`lab_test_${LabTest.SEDIMENTATION_RATE}`]: 'Sedimentacija eritrocita',
			[`lab_test_${LabTest.LEUKOCYTE_FORMULA}`]: 'Leukocitarna formula',
			[`lab_test_${LabTest.RETICULOCYTES}`]: 'Retikulociti',
			[`lab_test_${LabTest.PLATELETS}`]: 'Trombociti',
			[`lab_test_${LabTest.BLOOD_GROUP}`]: 'Krvna grupa',

			// Koagulacija
			[`lab_test_${LabTest.FIBRINOGEN}`]: 'Fibrinogen',
			[`lab_test_${LabTest.BLEEDING_TIME}`]: 'Vreme krvarenja',
			[`lab_test_${LabTest.COAGULATION_TIME}`]: 'Vreme koagulacije',
			[`lab_test_${LabTest.ACTIVATED_PARTIAL_THROMBOPLASTIN_TIME}`]:
				'Aktivirano parcijalno tromboplastinsko vreme (aPTT)',
			[`lab_test_${LabTest.D_DIMER}`]: 'D-dimer',
			[`lab_test_${LabTest.INR}`]: 'INR',

			// Biohemija
			[`lab_test_${LabTest.GLUCOSE}`]: 'Glukoza',
			[`lab_test_${LabTest.HBA1C}`]: 'Glikozilirani hemoglobin (HbA1c)',
			[`lab_test_${LabTest.CHOLESTEROL}`]: 'Holesterol',
			[`lab_test_${LabTest.HDL_CHOLESTEROL}`]: 'HDL holesterol',
			[`lab_test_${LabTest.LDL_CHOLESTEROL}`]: 'LDL holesterol',
			[`lab_test_${LabTest.TRIGLYCERIDES}`]: 'Trigliceridi',
			[`lab_test_${LabTest.CREATININE}`]: 'Kreatinin',
			[`lab_test_${LabTest.UREA}`]: 'Urea',
			[`lab_test_${LabTest.URIC_ACID}`]: 'Mokraćna kiselina',
			[`lab_test_${LabTest.TOTAL_PROTEIN}`]: 'Ukupni proteini',
			[`lab_test_${LabTest.ALBUMIN}`]: 'Albumin',
			[`lab_test_${LabTest.TOTAL_BILIRUBIN}`]: 'Ukupni bilirubin',
			[`lab_test_${LabTest.DIRECT_BILIRUBIN}`]: 'Direktni bilirubin',
			[`lab_test_${LabTest.AST}`]: 'AST',
			[`lab_test_${LabTest.ALT}`]: 'ALT',
			[`lab_test_${LabTest.GAMMA_GT}`]: 'Gama-GT',
			[`lab_test_${LabTest.ALKALINE_PHOSPHATASE}`]: 'Alkalna fosfataza',
			[`lab_test_${LabTest.AMYLASE}`]: 'Amilaza',
			[`lab_test_${LabTest.LIPASE}`]: 'Lipaza',
			[`lab_test_${LabTest.CK}`]: 'Kreatin kinaza (CK)',
			[`lab_test_${LabTest.CK_MB}`]: 'CK-MB',
			[`lab_test_${LabTest.LDH}`]: 'LDH',

			// Elektroliti
			[`lab_test_${LabTest.SODIUM}`]: 'Natrijum',
			[`lab_test_${LabTest.POTASSIUM}`]: 'Kalijum',
			[`lab_test_${LabTest.CALCIUM}`]: 'Kalcijum',
			[`lab_test_${LabTest.IONIZED_CALCIUM}`]: 'Jonizovani kalcijum',
			[`lab_test_${LabTest.MAGNESIUM}`]: 'Magnezijum',
			[`lab_test_${LabTest.PHOSPHORUS}`]: 'Fosfor',
			[`lab_test_${LabTest.CHLORIDE}`]: 'Hloridi',
			[`lab_test_${LabTest.IRON}`]: 'Gvožđe',
			[`lab_test_${LabTest.FERRITIN}`]: 'Feritin',

			// Hormoni
			[`lab_test_${LabTest.TSH}`]: 'TSH',
			[`lab_test_${LabTest.T3}`]: 'T3',
			[`lab_test_${LabTest.T4}`]: 'T4',
			[`lab_test_${LabTest.FREE_T3}`]: 'Slobodni T3',
			[`lab_test_${LabTest.FREE_T4}`]: 'Slobodni T4',
			[`lab_test_${LabTest.CORTISOL}`]: 'Kortizol',
			[`lab_test_${LabTest.TESTOSTERONE}`]: 'Testosteron',
			[`lab_test_${LabTest.ESTRADIOL}`]: 'Estradiol',
			[`lab_test_${LabTest.PROGESTERONE}`]: 'Progesteron',
			[`lab_test_${LabTest.PROLACTIN}`]: 'Prolaktin',
			[`lab_test_${LabTest.FSH}`]: 'FSH',
			[`lab_test_${LabTest.LH}`]: 'LH',
			[`lab_test_${LabTest.INSULIN}`]: 'Insulin',
			[`lab_test_${LabTest.C_PEPTIDE}`]: 'C-peptid',
			[`lab_test_${LabTest.PTH}`]: 'Parathormon',
			[`lab_test_${LabTest.VITAMIN_D_25_OH}`]: 'Vitamin D (25-OH)',
			[`lab_test_${LabTest.VITAMIN_B12}`]: 'Vitamin B12',

			// Tumorski markeri
			[`lab_test_${LabTest.PSA}`]: 'PSA',
			[`lab_test_${LabTest.FREE_PSA}`]: 'Slobodni PSA',
			[`lab_test_${LabTest.CEA}`]: 'CEA',
			[`lab_test_${LabTest.CA_125}`]: 'CA 125',
			[`lab_test_${LabTest.CA_15_3}`]: 'CA 15-3',
			[`lab_test_${LabTest.CA_19_9}`]: 'CA 19-9',
			[`lab_test_${LabTest.AFP}`]: 'AFP',

			// Markeri zapaljenja
			[`lab_test_${LabTest.C_REACTIVE_PROTEIN}`]: 'C-reaktivni protein (CRP)',
			[`lab_test_${LabTest.PROCALCITONIN}`]: 'Prokalcitonin',

			// Analiza urina
			[`lab_test_${LabTest.COMPLETE_URINALYSIS}`]: 'Celokupan pregled urina',
			[`lab_test_${LabTest.MICROALBUMIN}`]: 'Mikroalbumini',

			// Infektivne bolesti
			[`lab_test_${LabTest.COVID_19_PCR}`]: 'COVID-19 PCR',
			[`lab_test_${LabTest.COVID_19_ANTIGEN}`]: 'COVID-19 Antigen',
			[`lab_test_${LabTest.HIV_AG_AB}`]: 'HIV Ag-Ab',
			[`lab_test_${LabTest.HBSAG}`]: 'HBsAg',
			[`lab_test_${LabTest.ANTI_HCV}`]: 'Anti-HCV',
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGM}`]: 'Citomegalovirus IgM',
			[`lab_test_${LabTest.CYTOMEGALOVIRUS_IGG}`]: 'Citomegalovirus IgG',
			[`lab_test_${LabTest.TOXOPLASMA_IGM}`]: 'Toxoplasma IgM',
			[`lab_test_${LabTest.TOXOPLASMA_IGG}`]: 'Toxoplasma IgG',
			[`lab_test_${LabTest.RUBELLA_IGM}`]: 'Rubella IgM',
			[`lab_test_${LabTest.RUBELLA_IGG}`]: 'Rubella IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGM}`]: 'Herpes Simplex I IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_I_IGG}`]: 'Herpes Simplex I IgG',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGM}`]: 'Herpes Simplex II IgM',
			[`lab_test_${LabTest.HERPES_SIMPLEX_II_IGG}`]: 'Herpes Simplex II IgG',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGM}`]: 'Epstein-Barr IgM',
			[`lab_test_${LabTest.EPSTEIN_BARR_IGG}`]: 'Epstein-Barr IgG',
			[`lab_test_${LabTest.TORCH}`]: 'TORCH',
			[`lab_test_${LabTest.HELICOBACTER_PYLORI}`]: 'Helicobacter pylori',
			[`lab_test_${LabTest.SPERMOGRAM}`]: 'Spermogram',

			// Genetski testovi
			[`lab_test_${LabTest.KARYOTYPE}`]: 'Kariotip',
			[`lab_test_${LabTest.MTHFR}`]: 'MTHFR',
			[`lab_test_${LabTest.FACTOR_V}`]: 'Faktor V',
			[`lab_test_${LabTest.BRCA1_BRCA2}`]: 'BRCA1/BRCA2',

			// Alergeni
			[`lab_test_${LabTest.IGE}`]: 'IgE',
			[`lab_test_${LabTest.IGA}`]: 'IgA',
			[`lab_test_${LabTest.IGG}`]: 'IgG',
			[`lab_test_${LabTest.IGM}`]: 'IgM',

			// Vitamini
			[`lab_test_${LabTest.FOLIC_ACID}`]: 'Folna kiselina',
			[`lab_test_${LabTest.VITAMIN_A}`]: 'Vitamin A',
			[`lab_test_${LabTest.VITAMIN_E_LEVEL}`]: 'Vitamin E',
			[`lab_test_${LabTest.VITAMIN_C_LEVEL}`]: 'Vitamin C',
			[`lab_test_${LabTest.VITAMIN_B1_LEVEL}`]: 'Vitamin B1',
			[`lab_test_${LabTest.VITAMIN_B2}`]: 'Vitamin B2',
			[`lab_test_${LabTest.VITAMIN_B6_LEVEL}`]: 'Vitamin B6',

			// Profili i paneli
			[`lab_test_${LabTest.LIPID_PROFILE}`]: 'Lipidni profil',
			[`lab_test_${LabTest.CORTISOL_PROFILE}`]: 'Profil kortizola',
			[`lab_test_${LabTest.PROLACTIN_PROFILE}`]: 'Profil prolaktina',
			[`lab_test_${LabTest.PSA_PROFILE}`]: 'PSA profil',
			[`lab_test_${LabTest.ANEMIA_BASIC_PANEL}`]: 'Osnovni panel anemije',
			[`lab_test_${LabTest.ANEMIA_EXTENDED_PANEL}`]: 'Prošireni panel anemije',
			[`lab_test_${LabTest.TORCH_PANEL}`]: 'TORCH panel',
			[`lab_test_${LabTest.FEMALE_HORMONE_PANEL}`]: 'Hormonski panel za žene',
			[`lab_test_${LabTest.MALE_PANEL}`]: 'Muški panel',
			[`lab_test_${LabTest.PREGNANCY_PANEL}`]: 'Panel za trudnice',
			[`lab_test_${LabTest.TRIPLE_TEST}`]: 'Tripl test',
			[`lab_test_${LabTest.DOUBLE_TEST}`]: 'Double test',
			[`lab_test_${LabTest.QUADRUPLE_TEST}`]: 'Quadruple test',

			// Mikrobiologija - brisevi
			[`lab_test_${LabTest.THROAT_SWAB_BACTERIA}`]: 'Bris grla na bakterije',
			[`lab_test_${LabTest.NOSE_SWAB_BACTERIA}`]: 'Bris nosa na bakterije',
			[`lab_test_${LabTest.VAGINAL_SWAB_BACTERIA}`]:
				'Vaginalni bris na bakterije',
			[`lab_test_${LabTest.CERVICAL_SWAB_BACTERIA}`]:
				'Cervikalni bris na bakterije',
			[`lab_test_${LabTest.URETHRAL_SWAB_BACTERIA}`]:
				'Uretralni bris na bakterije',
			[`lab_test_${LabTest.URINE_CULTURE}`]: 'Urinokultura',
			[`lab_test_${LabTest.STOOL_CULTURE}`]: 'Koprokultura',
			[`lab_test_${LabTest.SPERM_CULTURE_BACTERIA}`]:
				'Spermokultura na bakterije',

			// Koagulacija proširena
			[`lab_test_${LabTest.ANTITHROMBIN_III}`]: 'Antitrombin III',
			[`lab_test_${LabTest.PROTEIN_S}`]: 'Protein S',
			[`lab_test_${LabTest.PROTEIN_C}`]: 'Protein C',
			[`lab_test_${LabTest.COAGULATION_FACTOR_II}`]: 'Koagulacioni faktor II',
			[`lab_test_${LabTest.COAGULATION_FACTOR_V}`]: 'Koagulacioni faktor V',
			[`lab_test_${LabTest.COAGULATION_FACTOR_VIII}`]:
				'Koagulacioni faktor VIII',

			// Reumatologija
			[`lab_test_${LabTest.RHEUMATOID_FACTOR}`]: 'Reuma faktor',
			[`lab_test_${LabTest.ANTI_CCP_ANTIBODIES}`]: 'Anti-CCP antitela',
			[`lab_test_${LabTest.ANA_ANTINUCLEAR_ANTIBODIES}`]:
				'Antinuklearna antitela',
			[`lab_test_${LabTest.ASTO}`]: 'ASTO',

			// Specijalizovani
			[`lab_test_${LabTest.BETA_HCG}`]: 'Beta HCG',
			[`lab_test_${LabTest.FREE_BETA_HCG}`]: 'Slobodni beta HCG',
			[`lab_test_${LabTest.PAPP_A}`]: 'PAPP-A',
			[`lab_test_${LabTest.ROMA_INDEX}`]: 'ROMA indeks',
			[`lab_test_${LabTest.HE4}`]: 'HE4',
			[`lab_test_${LabTest.ANTI_MULLERIAN_HORMONE}`]: 'Anti Milerov hormon',
			[`lab_test_${LabTest.DHEA_S}`]: 'DHEA-S',
			[`lab_test_${LabTest.SHBG}`]: 'SHBG',
			[`lab_test_${LabTest.GROWTH_HORMONE}`]: 'Hormon rasta',
			[`lab_test_${LabTest.IGF_1}`]: 'IGF-1',
			[`lab_test_${LabTest.ACTH}`]: 'ACTH',
			[`lab_test_${LabTest.RENIN}`]: 'Renin',
			[`lab_test_${LabTest.ALDOSTERONE}`]: 'Aldosteron',
			[`lab_test_${LabTest.PRO_BNP}`]: 'Pro-BNP',
			[`lab_test_${LabTest.TROPONIN_T_HS}`]: 'Troponin T HS',
			[`lab_test_${LabTest.HOMOCYSTEINE}`]: 'Homocistein',
		},
		de: {
			LabTestName: 'Laboruntersuchung',
			AnyLabTest: 'Beliebige Untersuchung',
			SearchLabTest: 'Laboruntersuchung suchen',
			NotFound: 'Untersuchung nicht gefunden',

			// Hämatologie
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT}`]: 'Großes Blutbild',
			[`lab_test_${LabTest.SEDIMENTATION_RATE}`]: 'Blutsenkung',
			[`lab_test_${LabTest.PLATELETS}`]: 'Thrombozyten',
			[`lab_test_${LabTest.BLOOD_GROUP}`]: 'Blutgruppe',

			// Biochemie
			[`lab_test_${LabTest.GLUCOSE}`]: 'Glukose',
			[`lab_test_${LabTest.HBA1C}`]: 'HbA1c',
			[`lab_test_${LabTest.CHOLESTEROL}`]: 'Cholesterin',
			[`lab_test_${LabTest.CREATININE}`]: 'Kreatinin',
			[`lab_test_${LabTest.UREA}`]: 'Harnstoff',
			[`lab_test_${LabTest.TSH}`]: 'TSH',
		},
		tr: {
			LabTestName: 'Laboratuvar Testi',
			AnyLabTest: 'Herhangi bir test',
			SearchLabTest: 'Laboratuvar testi ara',
			NotFound: 'Test bulunamadı',

			// Hematoloji
			[`lab_test_${LabTest.COMPLETE_BLOOD_COUNT}`]: 'Tam Kan Sayımı',
			[`lab_test_${LabTest.SEDIMENTATION_RATE}`]: 'Sedimentasyon Hızı',
			[`lab_test_${LabTest.PLATELETS}`]: 'Trombosit',
			[`lab_test_${LabTest.BLOOD_GROUP}`]: 'Kan Grubu',

			// Biyokimya
			[`lab_test_${LabTest.GLUCOSE}`]: 'Glukoz',
			[`lab_test_${LabTest.HBA1C}`]: 'HbA1c',
			[`lab_test_${LabTest.CHOLESTEROL}`]: 'Kolesterol',
			[`lab_test_${LabTest.CREATININE}`]: 'Kreatinin',
			[`lab_test_${LabTest.UREA}`]: 'Üre',
			[`lab_test_${LabTest.TSH}`]: 'TSH',
		},
	},
};
