-- Insert medical service categories
-- Run: mysql -u root -p docta_me < server/sql/insert-service-categories-and-relations.sql

-- Add new categories (20-31)
INSERT INTO medical_service_categories (id, name, created_at) VALUES
(1, 'MRI', NOW()),
(2, 'MSCT', NOW()),
(3, 'X-Ray', NOW()),
(4, 'Ultrasound', NOW()),
(5, 'Physiotherapy', NOW()),
(6, 'Gastroenterology', NOW()),
(7, 'Gynecology', NOW()),
(8, 'Cardiology', NOW()),
(9, 'General Medicine', NOW()),
(10, 'Orthopedics', NOW()),
(11, 'ENT', NOW()),
(12, 'Pulmonology', NOW()),
(13, 'Medical Transport', NOW()),
(14, 'Surgical Examination', NOW()),
(15, 'Ambulatory Surgery', NOW()),
(16, 'Gynecological Surgery', NOW()),
(17, 'General & Abdominal Surgery', NOW()),
(18, 'Plastic Surgery', NOW()),
(19, 'Pain Therapy', NOW()),
(20, 'Dentistry', NOW()),
(21, 'Neurology', NOW()),
(22, 'Urology', NOW()),
(23, 'Ophthalmology', NOW()),
(24, 'Dermatology', NOW()),
(25, 'Pediatrics', NOW()),
(26, 'Endocrinology', NOW()),
(27, 'Allergology', NOW()),
(28, 'Laboratory Services', NOW()),
(29, 'Injections & Infusions', NOW()),
(30, 'Home Visits', NOW()),
(31, 'Wound Care', NOW())
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert service-category relations
INSERT INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) VALUES
-- Laboratory Services (28)
(254, 28), -- Swim-Up Procedure I
(259, 28), -- Blood Collection Fee
(261, 28), -- Swim-Up Procedure II
(263, 28), -- Genital Sampling
(264, 28), -- Plasma Separation 10ml
(265, 28), -- Field Sampling

-- Home Visits (30)
(260, 30), -- Home Visit Center
(262, 30), -- Home Visit Periphery
(1968, 30), -- Home Visit Doctor and Nurse
(2067, 30), -- Home Visit City Center
(2068, 30), -- Home Visit up to 3km
(2069, 30), -- Home Visit over 3km
(2070, 30), -- Home Visit Follow-up
(2182, 30), -- Home Visit City Center Technician
(2183, 30), -- Home Visit Suburban Technician
(2184, 30), -- Home Visit Suburban
(2185, 30), -- Home Visit Outside City
(2299, 30), -- Home Visit Type 1
(2300, 30), -- Home Visit Type 2
(2301, 30), -- Home Visit Type 3

-- ENT (11)
(1468, 11), -- Inhalation Administration
(1469, 11), -- Nasal Irrigation
(1470, 11), -- Tympanometry
(1471, 11), -- Audiometry
(1472, 11), -- Extended Tympanometry
(1473, 11), -- Single Use Forceps
(1474, 11), -- Pharyngeal Endoscopy
(1475, 11), -- Foreign Body Removal
(1476, 11), -- Abscess Incision
(1510, 11), -- First ENT Examination
(1511, 11), -- Follow-up ENT Examination
(1512, 11), -- Foreign Body Removal Throat
(1513, 11), -- Cerumen Ear Irrigation
(1955, 11), -- ENT Specialist Examination
(1956, 11), -- Follow-up ENT Specialist Examination
(1978, 11), -- Ear Examination and Irrigation
(2082, 11), -- Ear Irrigation
(2090, 11), -- Ear Wick Placement

-- Physiotherapy (5)
(1477, 5), -- Kinesiotherapy for Children with Deformities
(1478, 5), -- Shock Wave Therapy
(1479, 5), -- Spinal Decompression
(1480, 5), -- Tecar Therapy
(1481, 5), -- Electrotherapy 2 Agents
(1482, 5), -- Electrotherapy 3 Agents
(1483, 5), -- Kinesiotherapy
(1484, 5), -- Electrotherapy 1 Agent
(1485, 5), -- Electrophoresis Therapy
(1486, 5), -- Therapeutic Massage Partial
(1487, 5), -- Therapeutic Massage Complete
(1488, 5), -- Lymphatic Drainage Partial
(1489, 5), -- Lymphatic Drainage Complete
(1531, 5), -- Tecar Leg
(1532, 5), -- Tecar Stomach Leg Back
(1537, 5), -- First Physiatrist Examination
(1538, 5), -- Follow-up Physiatrist Examination
(1629, 5), -- Shock Wave Therapy
(1630, 5), -- Spinal Decompression Therapy
(1631, 5), -- Electrophoresis

-- Neurology (21)
(1490, 21), -- First Neurologist Examination
(1491, 21), -- Follow-up Neurologist Examination
(1492, 21), -- Electroencephalography
(1493, 21), -- EMNG DE and GE
(1494, 21), -- EMNG DE or GE
(1495, 21), -- First Neurosurgeon Examination
(1496, 21), -- Follow-up Neurosurgeon Examination
(1934, 21), -- Pediatric Neurologist Examination
(1934, 25), -- Pediatric Neurologist Examination (also Pediatrics)

-- Urology (22)
(1497, 22), -- Urologist Examination with Ultrasound
(1498, 22), -- Urologist Examination
(2071, 22), -- Systematic Exam Package Urology Hormones Men
(2151, 22), -- Hydrocele Surgery
(2152, 22), -- Circumcision Local Anesthesia
(2153, 22), -- Circumcision Spinal General Anesthesia
(2154, 22), -- Subcapsular Orchiectomy Local Anesthesia
(2155, 22), -- Subcapsular Orchiectomy Spinal General Anesthesia
(2156, 22), -- Condyloma Removal Small Lesion
(2157, 22), -- Condyloma Removal Large Lesion
(2158, 22), -- Frenulotomy
(2199, 22), -- Circumcision General Anesthesia
(2200, 22), -- Cystoscopy Male
(2201, 22), -- Cystoscopy Female
(2202, 22), -- Frenulotomy General Anesthesia
(2203, 22), -- Subcapsular Orchiectomy General Anesthesia

-- Dermatology & Aesthetics (24)
(1499, 24), -- PRP Facial Treatment
(1500, 24), -- Botox 1 Region
(1501, 24), -- Botox 2 Regions
(1502, 24), -- Botox 3 Regions
(1503, 24), -- Hyaluron Stylage
(1504, 24), -- Profhilo Treatment
(1505, 24), -- Skin Lesion Removal
(1506, 24), -- Lipolysis
(1507, 24), -- Plexr Shower Treatment
(1508, 24), -- Jalupro Superhydro
(1509, 24), -- Jalupro Young Eye
(1524, 24), -- Facial Biorevitalization
(1525, 24), -- Mesotherapy 3
(1526, 24), -- Mesotherapy 1
(1527, 24), -- Mesotherapy 2
(1528, 24), -- Therapeutic Aesthetic Peeling
(1529, 24), -- Therapeutic Aesthetic Peeling Pro
(1530, 24), -- Therapeutic Aesthetic Peeling Max
(1958, 24), -- Dermatologist Examination
(2163, 24), -- Botox Injection
(2164, 24), -- Skin Hydration Treatment
(2165, 24), -- Hyaluronic Acid Filler
(2166, 24), -- Hyaluronic Acid Filler Charmony
(2167, 24), -- Jalupro Biorevitalization
(2168, 24), -- Jalupro Super Hydro Treatment
(2169, 24), -- Kenalog Injection Zone 1
(2170, 24), -- Kenalog Injection Zone 2
(2187, 24), -- Dermatoscopy
(2188, 24), -- Demodex Test
(2298, 24), -- Follow-up Dermatologist Examination
(2311, 24), -- Dermatologist Examination with Dermatoscopy

-- Gastroenterology (6)
(1533, 6), -- First Gastroenterologist Examination
(1534, 6), -- Follow-up Gastroenterologist Examination
(1535, 6), -- Gastroenterologist Examination with Ultrasound
(1536, 6), -- Gastroenterology Ultrasound Examination
(1932, 6), -- Pediatric Gastroenterologist Examination
(1932, 25), -- Pediatric Gastroenterologist Examination (also Pediatrics)
(1966, 6), -- Gastroenterologist Examination
(2119, 6), -- Anoscopy
(2121, 6), -- Anorectal Clinical Examination
(2134, 6), -- Rectoscopy
(2173, 6), -- Professor Gastroenterologist Examination with Ultrasound
(2215, 6), -- Gastroscopy without Anesthesia
(2216, 6), -- Gastroscopy with Anesthesia
(2217, 6), -- Colonoscopy without Anesthesia
(2218, 6), -- Colonoscopy with Anesthesia
(2219, 6), -- Colonoscopy and Gastroscopy with Anesthesia
(2220, 6), -- Liver Biopsy Local Anesthesia
(2307, 6), -- Gastroscopy with Foreign Body Removal

-- Ultrasound (4)
(1536, 4), -- Gastroenterology Ultrasound Examination
(1540, 4), -- Upper Abdomen Ultrasound
(1541, 4), -- Lower Abdomen Ultrasound
(1542, 4), -- Complete Abdomen Ultrasound
(1543, 4), -- Thyroid Ultrasound
(1544, 4), -- Neck Ultrasound Salivary Glands
(1545, 4), -- Breast Ultrasound with Axilla
(1546, 4), -- Peripheral Region Ultrasound
(1547, 4), -- Soft Tissue Ultrasound Muscle
(1548, 4), -- Lung Base Ultrasound
(1549, 4), -- Complete Female Ultrasound
(1550, 4), -- Complete Male Ultrasound
(1551, 4), -- Doppler Neck Blood Vessels
(1552, 4), -- Doppler Upper Extremity Blood Vessels
(1553, 4), -- Doppler Lower Extremity Blood Vessels
(1997, 4), -- Hip Ultrasound
(1998, 4), -- Soft Tissue Ultrasound
(1999, 4), -- Urinary Tract Ultrasound
(2000, 4), -- Breast Ultrasound
(2001, 4), -- Abdomen and Kidney Ultrasound
(2002, 4), -- Neck Doppler
(2003, 4), -- Upper Extremity Doppler
(2004, 4), -- Lower Extremity Doppler
(2103, 4), -- Upper and Lower Extremity Doppler
(2104, 4), -- Blood Vessels Doppler
(2105, 4), -- Abdomen Ultrasound
(2106, 4), -- Abdomen and Urinary Tract Ultrasound
(2107, 4), -- Abdomen Urinary Tract and Thyroid Ultrasound
(2108, 4), -- Breast and Thyroid Ultrasound
(2109, 4), -- Hip and Kidney Ultrasound
(2110, 4), -- Lung Ultrasound
(2111, 4), -- Hand Ultrasound
(2112, 4), -- Heart Ultrasound
(2113, 4), -- Neck Ultrasound
(2271, 4), -- Ophthalmological Ultrasound

-- X-Ray (3)
(1554, 3), -- X-Ray Reading
(1555, 3), -- CT Scan Reading
(2006, 3), -- X-Ray Skull Towne Altchul
(2007, 3), -- X-Ray Sinuses
(2008, 3), -- X-Ray Sinuses with Profiles
(2009, 3), -- X-Ray Maxillary Sinuses
(2010, 3), -- X-Ray Orbits
(2011, 3), -- X-Ray Optic Canal Rhese
(2012, 3), -- X-Ray Mastoid Shuller
(2013, 3), -- X-Ray Temporal Bones
(2014, 3), -- X-Ray Sella Turcica
(2015, 3), -- X-Ray Facial Bones
(2016, 3), -- X-Ray Facial Bones with Profiles
(2017, 3), -- X-Ray Nose Profiles
(2018, 3), -- X-Ray Nose with Profiles
(2019, 3), -- X-Ray Maxilla Mandible TMJ
(2020, 3), -- X-Ray Cervical Spine
(2021, 3), -- X-Ray Thoracic Spine
(2022, 3), -- X-Ray Lumbar Spine and Sacrum
(2023, 3), -- X-Ray Full Spine
(2024, 3), -- X-Ray Shoulder
(2025, 3), -- X-Ray Upper Arm
(2026, 3), -- X-Ray Both Upper Arms
(2027, 3), -- X-Ray Elbow
(2028, 3), -- X-Ray Both Elbows
(2029, 3), -- X-Ray Forearm
(2030, 3), -- X-Ray Both Forearms
(2031, 3), -- X-Ray Hand
(2032, 3), -- X-Ray Both Hands
(2033, 3), -- X-Ray Wrist
(2034, 3), -- X-Ray Both Wrists
(2035, 3), -- X-Ray Chest Heart
(2036, 3), -- X-Ray Chest with Profile
(2037, 3), -- X-Ray Abdomen Native
(2038, 3), -- X-Ray Urinary Tract
(2039, 3), -- X-Ray Pelvis
(2040, 3), -- X-Ray Hip
(2041, 3), -- X-Ray Thigh
(2042, 3), -- X-Ray Both Thighs
(2043, 3), -- X-Ray Knee
(2044, 3), -- X-Ray Both Knees
(2045, 3), -- X-Ray Lower Leg
(2046, 3), -- X-Ray Both Lower Legs
(2047, 3), -- X-Ray Ankle
(2048, 3), -- X-Ray Both Ankles
(2049, 3), -- X-Ray Foot
(2050, 3), -- X-Ray Both Feet
(2051, 3), -- X-Ray Heel
(2052, 3), -- X-Ray Both Heels
(2291, 3), -- X-Ray Pelvis with Hips
(2292, 3), -- X-Ray Both Knees Rosenberg
(2293, 3), -- X-Ray Knee Patella
(2294, 3), -- X-Ray Both Knees Patella
(2295, 3), -- X-Ray Both Shoulders
(2296, 3), -- X-Ray Sinuses Paranasal
(2297, 3), -- X-Ray Chest

-- General Medicine (9)
(1556, 9), -- General Practitioner Examination
(1557, 9), -- Preventive General Practitioner Examination
(1559, 9), -- Brief Doctor Visit Consultation
(1560, 9), -- Follow-up General Practitioner Examination
(1561, 9), -- Female Package
(1562, 9), -- Male Package
(1563, 9), -- MSC Male Package
(1564, 9), -- MSC Female Package
(1937, 9), -- Professor Examination
(1938, 9), -- Follow-up Professor Examination
(1942, 9), -- Internist Examination with ECG
(1954, 9), -- Expert Consultation
(1963, 9), -- Family Medicine Examination
(1969, 9), -- Systematic Examination Package 1
(1970, 9), -- Systematic Examination Package 2
(2055, 9), -- Follow-up Family Medicine Examination
(2056, 9), -- Family Medicine Examination with Ultrasound
(2057, 9), -- Medical Documentation Review and Prescription
(2058, 9), -- E-Consultation with Specialist
(2059, 9), -- Professor Examination with Ultrasound
(2060, 9), -- Specialist Examination
(2061, 9), -- Follow-up Specialist Examination
(2062, 9), -- Specialist Examination with Ultrasound
(2063, 9), -- Specialist Examination with Two Ultrasounds
(2064, 9), -- Subspecialist Examination
(2065, 9), -- Follow-up Subspecialist Examination
(2066, 9), -- Subspecialist Examination with Ultrasound
(2072, 9), -- Systematic Exam Package Hormones Breast Cancer Women
(2074, 9), -- Systematic Exam Package Metabolism Nutrition
(2075, 9), -- Systematic Exam Package Vitamins Hormones Minerals
(2077, 9), -- Systematic Exam Package General Health
(2078, 9), -- Systematic Exam Insurance
(2174, 9), -- Specialist Examination Type 1
(2175, 9), -- Specialist Examination Type 2
(2176, 9), -- Specialist Examination Type 3
(2177, 9), -- Follow-up Specialist Examination Type 1
(2178, 9), -- Follow-up Specialist Examination Type 2
(2179, 9), -- Follow-up Specialist Examination Type 3
(2180, 9), -- Specialist Examination with Additional Service
(2181, 9), -- Specialist Examination with Two Additional Services
(2186, 9), -- Systematic Examination Package 3
(2312, 9), -- Extended Specialist Examination
(2313, 9), -- After Hours Examination

-- Injections & Infusions (29)
(1558, 29), -- Intra-Articular Medication Application
(1591, 29), -- Subcutaneous Injection
(1592, 29), -- Intramuscular Injection
(1593, 29), -- Intravenous Therapy Administration
(1973, 29), -- Infusion Therapy
(1974, 29), -- Intramuscular Medication Application
(1975, 29), -- Intramuscular Therapy 1
(1976, 29), -- Intramuscular Therapy 2
(1979, 29), -- IV Cannula Application
(1980, 29), -- Intravenous Medication Application
(1981, 29), -- Intra-articular Injection
(1982, 29), -- IV Therapy Service
(2079, 29), -- Additional Intramuscular Medication
(2080, 29), -- Intramuscular Therapy
(2098, 29), -- Immune Booster IV
(2099, 29), -- Myers Cocktail IV
(2100, 29), -- After Party Cocktail IV
(2101, 29), -- Iron Power IV
(2207, 29), -- Intra-articular Injection without Ultrasound
(2208, 29), -- Follow-up Intra-articular Injection

-- Cardiology (8)
(1616, 8), -- ECG
(1621, 8), -- Cardiologist Examination
(1622, 8), -- Cardiologist Examination with Ultrasound
(1935, 8), -- Pediatric Cardiologist Examination with Echocardiography
(1935, 25), -- Pediatric Cardiologist Examination with Echocardiography (also Pediatrics)
(1943, 8), -- Cardiologist Examination with Echocardiography
(1944, 8), -- Cardiologist Examination with ECG
(1945, 8), -- Ergometry Stress Test
(1946, 8), -- Professor Cardiologist Examination
(1947, 8), -- Follow-up Professor Cardiologist Examination
(1948, 8), -- Professor Echocardiography
(1949, 8), -- Professor Cardiologist with Echocardiography
(1950, 8), -- Professor Ergometry
(1951, 8), -- Stress Echocardiography
(1952, 8), -- Professor Stress Echocardiography
(1953, 8), -- Professor Cardiology Package
(1991, 8), -- Echocardiography
(1992, 8), -- Holter ECG 24h
(1993, 8), -- Holter Blood Pressure 24h
(2112, 8), -- Heart Ultrasound
(2171, 8), -- Professor Cardiologist Examination with Ultrasound
(2302, 8), -- Ergometry ECG Stress Test

-- Pulmonology (12)
(1617, 12), -- Spirometry
(1936, 12), -- Pediatric Pulmonologist Examination
(1936, 25), -- Pediatric Pulmonologist Examination (also Pediatrics)
(1939, 12), -- Pulmonologist Examination
(1940, 12), -- Pulmonologist Examination with Diffusion Test
(1941, 12), -- Pulmonologist Examination with Body Plethysmography
(1985, 12), -- Inhalation Therapy
(1987, 12), -- Diffusion Test
(1988, 12), -- Diffusion and Spirometry
(1989, 12), -- Bronchodilator Test
(1990, 12), -- Body Plethysmography

-- Endocrinology (26)
(1618, 26), -- First Endocrinologist Examination
(1619, 26), -- Follow-up Endocrinologist Examination
(1620, 26), -- Endocrinologist Examination with Ultrasound
(1959, 26), -- Endocrinologist Examination
(1960, 26), -- Endocrinologist Examination with Thyroid Ultrasound
(1961, 26), -- Professor Endocrinologist Examination
(2073, 26), -- Systematic Exam Package Thyroid
(2076, 26), -- Systematic Exam Package Bone Health Osteoporosis
(2310, 26), -- Thyroid Biopsy
(2314, 26), -- Synacthen Test
(2315, 26), -- Prolactin Profile with IV Cannula

-- Ophthalmology (23)
(1623, 23), -- First Ophthalmologist Examination
(1624, 23), -- Follow-up Ophthalmologist Examination
(1625, 23), -- Diopter Determination
(1626, 23), -- Intraocular Pressure Determination
(1627, 23), -- Foreign Body Removal Eye
(1628, 23), -- Lacrimal Duct Irrigation
(2263, 23), -- Ophthalmological Examination
(2264, 23), -- Emergency Ophthalmological Examination
(2265, 23), -- Preoperative Ophthalmological Examination
(2266, 23), -- Follow-up Ophthalmological Examination
(2267, 23), -- Ophthalmological Examination Contact Lenses
(2268, 23), -- Ophthalmological Examination with Lens Calculation
(2269, 23), -- Pediatric Strabismus Examination
(2269, 25), -- Pediatric Strabismus Examination (also Pediatrics)
(2270, 23), -- Complete Glaucoma Examination
(2271, 23), -- Ophthalmological Ultrasound
(2272, 23), -- Intraocular Pressure Measurement
(2273, 23), -- Dry Eye Test Schirmer
(2274, 23), -- Visual Field Test
(2275, 23), -- OCT Pachymetry Cornea
(2276, 23), -- OCT Optic Nerve Analysis
(2277, 23), -- OCT Posterior Segment
(2278, 23), -- OCT Macula Analysis
(2279, 23), -- Daily Intraocular Pressure Profile
(2280, 23), -- Chalazion Removal Children General Anesthesia
(2280, 25), -- Chalazion Removal Children General Anesthesia (also Pediatrics)
(2281, 23), -- Chalazion Removal Local Anesthesia
(2282, 23), -- Eyelid Tumor Surgical Removal
(2283, 23), -- Ectropion Surgery
(2284, 23), -- Entropion Surgery
(2285, 23), -- Blepharoplasty
(2285, 18), -- Blepharoplasty (also Plastic Surgery)
(2286, 23), -- Lacrimal Duct Probing Children General Anesthesia
(2286, 25), -- Lacrimal Duct Probing Children General Anesthesia (also Pediatrics)
(2287, 23), -- Lacrimal Duct Probing Adults
(2288, 23), -- Anti-VEGF Injection
(2289, 23), -- Laser Photocoagulation Type 1
(2290, 23), -- Laser Photocoagulation Type 2

-- Dentistry (20)
(1632, 20), -- Dental Consultation
(1633, 20), -- Dental Caries Treatment
(1634, 20), -- Front Tooth Restoration
(1635, 20), -- Tooth Restoration with Fiberglass Post
(1636, 20), -- Root Canal Treatment First Root
(1637, 20), -- Root Canal Treatment Second Root
(1638, 20), -- Root Canal Treatment Third Root
(1639, 20), -- Complete Dental Cleaning
(1640, 20), -- Teeth Whitening
(1641, 20), -- Custom Dental Guard
(1642, 20), -- Pediatric Dental Adaptation
(1642, 25), -- Pediatric Dental Adaptation (also Pediatrics)
(1643, 20), -- Pediatric Caries Treatment
(1643, 25), -- Pediatric Caries Treatment (also Pediatrics)
(1644, 20), -- Pulpitis Treatment
(1645, 20), -- Fissure Sealant
(1646, 20), -- Complete Pediatric Dental Cleaning
(1646, 25), -- Complete Pediatric Dental Cleaning (also Pediatrics)
(1647, 20), -- Primary Tooth Extraction
(1647, 25), -- Primary Tooth Extraction (also Pediatrics)
(1648, 20), -- Follow-up Dental Examination
(1649, 20), -- Specialist Dental Examination
(1650, 20), -- Dental Treatment Planning
(1651, 20), -- Insurance Report Issuance
(1652, 20), -- Intraoral X-Ray
(1653, 20), -- Temporary Filling with Medication
(1654, 20), -- Pulp Capping Direct or Indirect
(1655, 20), -- Phosphate Cement Filling
(1656, 20), -- Amalgam Filling
(1657, 20), -- Composite Filling Single Surface
(1658, 20), -- Composite Filling Two Surfaces
(1659, 20), -- Composite Filling Three Surfaces
(1660, 20), -- Premium Composite Filling Single Surface
(1661, 20), -- Premium Composite Filling Two Surfaces
(1662, 20), -- Premium Composite Filling Three Surfaces
(1663, 20), -- Direct Composite Veneer
(1664, 20), -- Ceramic Inlay Onlay
(1665, 20), -- Filling Retention with Metal Post
(1666, 20), -- Filling Retention with Fiber Post
(1667, 20), -- Pulpitis Treatment Single Root NiTi
(1668, 20), -- Pulpitis Treatment Two Root NiTi
(1669, 20), -- Pulpitis Treatment Three Root NiTi
(1670, 20), -- Pulpitis Treatment Single Root Machine
(1671, 20), -- Pulpitis Treatment Two Root Machine
(1672, 20), -- Pulpitis Treatment Three Root Machine
(1673, 20), -- Gangrene Treatment Single Root
(1674, 20), -- Gangrene Treatment Two Root
(1675, 20), -- Gangrene Treatment Three Root
(1676, 20), -- Root Canal Retreatment
(1677, 20), -- Rubber Dam Application
(1678, 20), -- Panoramic X-Ray
(1679, 20), -- Cross Section X-Ray
(1680, 20), -- 3D Dental X-Ray CBCT
(1681, 20), -- Dental Jewelry Application
(1682, 20), -- Complete Denture
(1683, 20), -- Partial Denture
(1684, 20), -- Denture with Bleach Teeth
(1685, 20), -- Skeletal Partial Denture
(1686, 20), -- Denture Retention System Bredent
(1687, 20), -- Denture Retention System CeKa
(1688, 20), -- Dolder Bar
(1689, 20), -- Indirect Denture Relining
(1690, 20), -- Direct Denture Relining
(1691, 20), -- Denture Repair
(1692, 20), -- Denture Tooth Addition
(1693, 20), -- Denture Clasp Addition
(1694, 20), -- Temporary Bridge 4 Units
(1695, 20), -- Temporary Crown
(1696, 20), -- Crown Removal
(1697, 20), -- Crown or Bridge Recementation
(1698, 20), -- Cast Post and Core
(1699, 20), -- FRC Post Build-up
(1700, 20), -- Metal Ceramic Crown CoCr
(1701, 20), -- Metal Ceramic Crown Gold
(1702, 20), -- Pressed Ceramic Crown
(1703, 20), -- Zirconia Crown with Veneer
(1704, 20), -- Zirconia Multilayer Crown
(1705, 20), -- Maryland Bridge
(1706, 20), -- Telescopic Crown
(1707, 20), -- Metal Ceramic Crown Bleach Shade
(1708, 20), -- Ceramic Crown Bleach Shade
(1709, 20), -- Implant Crown Metal Ceramic
(1710, 20), -- Screw Retained Implant Crown CoCr
(1711, 20), -- Screw Retained Implant Crown Gold
(1712, 20), -- Multi Unit Abutment with Ti Base
(1713, 20), -- Hybrid Abutment Zirconia
(1714, 20), -- Digital Smile Design
(1715, 20), -- Tooth Extraction Simple
(1716, 20), -- Tooth Extraction Moderate
(1717, 20), -- Tooth Extraction Complex
(1718, 20), -- Surgical Tooth Extraction
(1719, 20), -- Impacted Tooth Extraction
(1720, 20), -- Impacted Tooth Extraction Complex
(1721, 20), -- Root Resection Apicoectomy
(1722, 20), -- Cystectomy
(1723, 20), -- Cystectomy Extended
(1724, 20), -- Sinus Closure
(1725, 20), -- Sinus Closure with Foreign Body Removal
(1726, 20), -- Caldwell Luc Procedure
(1727, 20), -- Sinus Closure with Mucosal Graft
(1728, 20), -- Mucosal Autograft
(1729, 20), -- Sinus Lift with Augmentation
(1730, 20), -- Frenectomy
(1731, 20), -- Frenulectomy
(1732, 20), -- Alveolar Ridge Leveling
(1733, 20), -- Vestibuloplasty
(1734, 20), -- Abscess Incision Intraoral
(1735, 20), -- Abscess Incision Extraoral
(1736, 20), -- Bleeding Control Dental
(1737, 20), -- Alveolitis Treatment
(1738, 20), -- Dental Implant Bredent
(1739, 20), -- Dental Implant Zimmer
(1740, 20), -- Dental Implant Nobel Biocare
(1741, 20), -- Dental Implant Straumann
(1742, 20), -- Socket Preservation
(1743, 20), -- Bone Augmentation Biooss
(1744, 20), -- Flap Surgery Periodontal
(1745, 20), -- Periodontal Scaling Root Planing
(1746, 20), -- Gingivectomy
(1747, 20), -- Periodontal Splint
(1748, 20), -- Surgical Exposure Impacted Tooth
(1749, 20), -- All on 4 Implant Prosthesis Bredent
(1750, 20), -- All on 4 Implant Prosthesis Nobel
(1751, 20), -- All on 4 Implant Prosthesis Zimmer
(1752, 20), -- All on 4 Implant Prosthesis Straumann
(1753, 20), -- Overdenture on Mini Implants
(1754, 20), -- APRF Application
(1755, 20), -- Biooss Bone Graft 0.5g
(1756, 20), -- Biooss Membrane Small
(1757, 20), -- Biooss Membrane Large
(1758, 20), -- All on 6 Implant Prosthesis Bredent
(1759, 20), -- All on 6 Implant Prosthesis Nobel
(1760, 20), -- All on 4 Metal Ceramic Titanium
(1761, 20), -- All on 4 Metal Ceramic CoCr
(1762, 20), -- All on 6 Metal Ceramic
(1763, 20), -- All on 4 Zirconia
(1764, 20), -- All on 6 Zirconia
(1765, 20), -- Implant Overdenture Locators Bredent
(1766, 20), -- Implant Overdenture Locators Nobel
(1767, 20), -- Implant Bar Attachment
(1768, 20), -- Surgical Guide per Implant
(1769, 20), -- Surgical Guide Additional Opening
(1770, 20), -- 3D Implant Planning
(1771, 20), -- Orthodontic Follow-up Monthly
(1772, 20), -- Orthodontic Plate with Screw
(1773, 20), -- Monoblock Appliance
(1774, 20), -- Vestibular Plate
(1775, 20), -- Chin Cap
(1776, 20), -- Fixed Orthodontic Braces per Arch
(1777, 20), -- Ceramic Braces per Arch
(1778, 20), -- Braces Removal per Arch
(1779, 20), -- Complex Fixed Orthodontic Treatment
(1780, 20), -- Segmental Fixed Orthodontic Appliance
(1781, 20), -- Fixed Orthodontic Check-up
(1782, 20), -- Bracket Replacement
(1783, 20), -- Band Replacement
(1784, 20), -- Archwire Replacement
(1785, 20), -- Invisalign Analysis
(1786, 20), -- Invisalign Attachment
(1787, 20), -- Invisalign Aligner

-- Pediatrics (25)
(1928, 25), -- Pediatric Examination
(1929, 25), -- Follow-up Pediatric Examination
(1930, 25), -- Subspecialist Pediatric Examination
(1931, 25), -- Follow-up Subspecialist Pediatric Examination
(1933, 25), -- Pediatric Hematologist Examination

-- Allergology (27)
(1957, 27), -- Allergist Examination
(1994, 27), -- Prick Test Nutritive Allergens
(1995, 27), -- Prick Test Inhalation Allergens
(1996, 27), -- Lactofan Intolerance Tests
(2084, 27), -- Lactofan Test
(2085, 27), -- Lactofan Package 2 Sugars
(2102, 27), -- Prick Test Nutritive and Inhalation Allergens

-- Orthopedics (10)
(1539, 10), -- PRP Joint Treatment
(1539, 19), -- PRP Joint Treatment (also Pain Therapy)
(1964, 10), -- Orthopedist Examination
(1983, 10), -- Immobilization
(2159, 10), -- Orthopedic Examination with Injection
(2160, 10), -- Orthopedic Examination with 1 PRP Treatment
(2161, 10), -- Orthopedic Examination with 2 PRP Treatments
(2162, 10), -- Joint Puncture
(2172, 10), -- Professor Orthopedist Examination with Ultrasound
(2204, 10), -- Follow-up Orthopedic with 1 PRP Treatment
(2205, 10), -- Follow-up Orthopedic with 2 PRP Treatments
(2206, 10), -- Cast Immobilization with Examination
(2209, 10), -- Carpal Tunnel Surgery
(2210, 10), -- Orthopedic Reposition
(2211, 10), -- Orthopedic Reposition with X-Ray and Cast
(2212, 10), -- ACP Therapy Plasma for Joints
(2212, 19), -- ACP Therapy Plasma for Joints (also Pain Therapy)
(2213, 10), -- ACP MAX Therapy Enhanced Plasma
(2213, 19), -- ACP MAX Therapy Enhanced Plasma (also Pain Therapy)
(2214, 10), -- Hyalubrix Injection
(2214, 19), -- Hyalubrix Injection (also Pain Therapy)

-- Wound Care (31)
(1597, 31), -- Wound Dressing I
(1598, 31), -- Wound Dressing II
(1599, 31), -- Wound Dressing III
(1977, 31), -- Wound Care
(2054, 31), -- Suture Removal
(2120, 31), -- Bandage
(2129, 31), -- Necrectomy and Wound Care
(2136, 31), -- Minor Wound Care
(2138, 31), -- Large Wound Care
(2139, 31), -- Medium Wound Care
(2140, 31), -- Small Wound Care
(2141, 31), -- Wound Care Steri-Strip
(2142, 31), -- Wound Swab
(2193, 31), -- Wound Care and Bandage
(2197, 31), -- Wound Swab Sampling

-- Surgical Examination (14)
(2053, 14), -- Surgical Intervention
(2189, 14), -- Surgical Examination
(2190, 14), -- Follow-up Surgical Examination
(2191, 14), -- Surgical Examination with Ultrasound
(2192, 14), -- Lymph Node Biopsy

-- Ambulatory Surgery (15)
(2114, 15), -- Skin and Subcutaneous Lesion Excision
(2115, 15), -- Benign Skin Tumor Removal
(2116, 15), -- Skin Tumor Excision with Reconstruction
(2117, 15), -- Atheroma and Lipoma Excision
(2118, 15), -- Surface Biopsy Punch System
(2125, 15), -- Incision
(2126, 15), -- Infiltration
(2127, 15), -- Lymph Node Extirpation
(2128, 15), -- Ingrown Toenail Surgery
(2133, 15), -- Purulent Skin and Subcutaneous Incision
(2135, 15), -- Minor Surgical Intervention
(2143, 15), -- Cyst Aspiration Puncture
(2195, 15), -- Surgical Intervention Local Anesthesia
(2196, 15), -- Surgical Intervention General Anesthesia

-- General & Abdominal Surgery (17)
(2122, 17), -- Crossectomy Vein Removal
(2123, 17), -- Complete Extirpation
(2124, 17), -- Hernia Operation
(2130, 17), -- Pilonidal Cyst Surgery Classic
(2131, 17), -- Pleural Drainage
(2132, 17), -- Postoperative Puncture and Evacuation
(2137, 17), -- Umbilical Hernia Operation
(2144, 17), -- Benign Breast Tumor Surgery
(2145, 17), -- Perianal Fistula Surgery
(2146, 17), -- Anal Fissure Surgery
(2147, 17), -- Hemorrhoid Surgery Classic
(2148, 17), -- Hemorrhoid Rubber Band Ligation
(2194, 17), -- Bilateral Hernia Operation
(2198, 17), -- Laser Hemorrhoid Surgery
(2221, 17), -- Vein Surgery One Leg
(2222, 17), -- Vein Surgery Both Legs
(2223, 17), -- Histopathology Surgery Type 1
(2224, 17), -- Histopathology Surgery Type 2
(2225, 17), -- Histopathology Additional Sample 1
(2226, 17), -- Histopathology Additional Sample 2

-- Plastic Surgery (18)
(1505, 18), -- Skin Lesion Removal
(2114, 18), -- Skin and Subcutaneous Lesion Excision
(2115, 18), -- Benign Skin Tumor Removal
(2116, 18), -- Skin Tumor Excision with Reconstruction
(2117, 18), -- Atheroma and Lipoma Excision

-- Medical Transport (13)
(2086, 13), -- Medical Security up to 3h
(2087, 13), -- Medical Security Additional Hour
(2091, 13), -- Medical Transport BLS up to 50km
(2092, 13), -- Medical Transport BLS up to 200km
(2093, 13), -- Medical Transport ALS up to 50km
(2094, 13), -- Medical Transport ALS up to 200km

-- Gynecology (7)
(1604, 7), -- Endometrial Cell Biopsy
(2227, 7), -- Gynecological Specialist Examination
(2228, 7), -- Gynecological Specialist Examination with Ultrasound
(2229, 7), -- Gynecological Subspecialist Examination
(2230, 7), -- Gynecological Subspecialist Examination with Ultrasound
(2231, 7), -- Systematic Gynecological Examination Package
(2232, 7), -- Colposcopy
(2233, 7), -- Gynecological Ultrasound
(2234, 7), -- Expert Pregnancy Ultrasound
(2235, 7), -- IUD Insertion
(2236, 7), -- IUD Removal
(2237, 7), -- Pessary Insertion
(2238, 7), -- Gynecological Biopsy
(2239, 7), -- CTG Fetal Monitoring
(2240, 7), -- Electrocoagulation Cervix
(2241, 7), -- Gynecological Swab Collection
(2242, 7), -- PAP Smear Collection
(2257, 7), -- HPV Test
(2258, 7), -- PAP Test Lab Analysis
(2259, 7), -- PAP Test with Smear Collection
(2260, 7), -- PAP Test Liquid Cytology
(2261, 7), -- Histopathology 1 Sample
(2262, 7), -- Histopathology 2 Samples

-- Gynecological Surgery (16)
(2243, 16), -- Exploratory Curettage without Anesthesia
(2244, 16), -- Exploratory Curettage with Anesthesia
(2245, 16), -- Bartholin Gland Incision
(2246, 16), -- Cervical Canal Curettage
(2247, 16), -- Abortion without Anesthesia
(2248, 16), -- Abortion with Anesthesia
(2249, 16), -- Loop Excision Cervix without Anesthesia
(2250, 16), -- Loop Excision Cervix with Anesthesia
(2251, 16), -- Polypectomy
(2252, 16), -- Genital Condyloma Removal Grade 1
(2253, 16), -- Genital Condyloma Removal Grade 2
(2254, 16), -- Diagnostic Hysteroscopy
(2255, 16), -- Surgical Hysteroscopy
(2256, 16), -- PRP Vaginal Rejuvenation

-- Additional services
(1984, 9), -- Patient Observation per Hour (General Medicine)
(1986, 12), -- Aspiration (Pulmonology)
(2083, 9), -- Enema (General Medicine)
(2088, 9), -- Catheter Placement (General Medicine)
(2089, 9), -- Nasogastric Tube Placement (General Medicine)
(1962, 9), -- Hematologist Examination (General Medicine - single specialty)
(1965, 10), -- Rheumatologist Examination (Orthopedics related)
(1967, 9), -- Oncologist Examination (General Medicine - single specialty)
(2308, 15), -- Conscious Sedation (Ambulatory Surgery)
(2309, 15) -- General IV Anesthesia (Ambulatory Surgery)
ON DUPLICATE KEY UPDATE medical_service_id = VALUES(medical_service_id);
