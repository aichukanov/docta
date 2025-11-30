import { DoctorSpecialty } from '~/enums/specialty';

export default {
	messages: {
		en: {
			Specialty: 'Specialty',
			AnySpecialty: 'Any specialty',
			SearchSpecialty: 'Search specialty',
			NotFound: 'Specialty not found',

			[`specialty_${DoctorSpecialty.CARDIOLOGY}`]: 'Cardiology',
			[`specialty_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Internal Medicine',
			[`specialty_${DoctorSpecialty.GENERAL_SURGERY}`]: 'General Surgery',
			[`specialty_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatrics',
			[`specialty_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]:
				'Gynecology and Obstetrics',
			[`specialty_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Ophthalmology',
			[`specialty_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerology',
			[`specialty_${DoctorSpecialty.NEUROLOGY}`]: 'Neurology',
			[`specialty_${DoctorSpecialty.UROLOGY}`]: 'Urology',
			[`specialty_${DoctorSpecialty.RADIOLOGY}`]: 'Radiology',
			[`specialty_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Otorhinolaryngology',
			[`specialty_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endocrinology',
			[`specialty_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterology',
			[`specialty_${DoctorSpecialty.PULMONOLOGY}`]: 'Pulmonology',
			[`specialty_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematology',
			[`specialty_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatology',
			[`specialty_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopedics and Traumatology',
			[`specialty_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastic Surgery',
			[`specialty_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesthesiology',
			[`specialty_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Family Medicine',
			[`specialty_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiatry',
			[`specialty_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Pediatric Cardiology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Pediatric Surgery',
			[`specialty_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]:
				'Pediatric Neurology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Pediatric Pulmonology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Pediatric Gastroenterology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Pediatric Endocrinology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Pediatric Hematology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Pediatric Allergology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Pediatric ENT',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Pediatric Orthopedics',
			[`specialty_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Pediatric Urology',
			[`specialty_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vascular Surgery (Phlebology)',
			[`specialty_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endocrine Surgery',
			[`specialty_${DoctorSpecialty.PROCTOLOGY}`]: 'Proctology',
			[`specialty_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynecologic Oncology',
			[`specialty_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproductive Medicine',
			[`specialty_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Clinical Biochemistry',
			[`specialty_${DoctorSpecialty.MICROBIOLOGY}`]: 'Microbiology',
			[`specialty_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molecular Biology',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Physical Medicine',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Pediatric Physical Medicine',
			[`specialty_${DoctorSpecialty.AESTHETIC_MEDICINE}`]: 'Aesthetic Medicine',
			[`specialty_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'General Medicine',
			[`specialty_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrology',
			[`specialty_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurosurgery',
			[`specialty_${DoctorSpecialty.ONCOLOGY}`]: 'Oncology',
			[`specialty_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Emergency Medicine',
			[`specialty_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoracic Surgery',
			[`specialty_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Occupational Medicine',
			[`specialty_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapy',
			[`specialty_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Infectious Diseases',
			[`specialty_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Pediatric Ophthalmology',
			[`specialty_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Speech Therapy',
			[`specialty_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Pediatric Plastic Surgery',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physical Medicine and Rehabilitation',
			[`specialty_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oral Surgery',
			[`specialty_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammology',
			[`specialty_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Oncologic Surgery',
			[`specialty_${DoctorSpecialty.DENTISTRY}`]: 'Dentistry',
			[`specialty_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergology',
			[`specialty_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunology',
			[`specialty_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Ophthalmic Surgery',
			[`specialty_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopathy',
			[`specialty_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hyperbaric Medicine',
			[`specialty_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]:
				'Pathological Anatomy',
			[`specialty_${DoctorSpecialty.PODIATRY}`]: 'Podiatry',
			[`specialty_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichology',
			[`specialty_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]:
				'Pediatric Dentistry',
			[`specialty_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuclear Medicine',
			[`specialty_${DoctorSpecialty.GENETICS}`]: 'Medical Genetics',
			[`specialty_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Surgery',
			[`specialty_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maxillofacial Surgery',
			[`specialty_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Cardiac Surgery',

			[`doctor_${DoctorSpecialty.CARDIOLOGY}`]: 'Cardiologist',
			[`doctors_${DoctorSpecialty.CARDIOLOGY}`]: 'Cardiologists',

			[`doctor_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'Internal Medicine Doctor',
			[`doctors_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'Internal Medicine Doctors',

			[`doctor_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Surgeon',
			[`doctors_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Surgeons',

			[`doctor_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatrician',
			[`doctors_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatricians',

			[`doctor_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Gynecologist',
			[`doctors_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Gynecologists',

			[`doctor_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Ophthalmologist',
			[`doctors_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Ophthalmologists',

			[`doctor_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerologist',
			[`doctors_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerologists',

			[`doctor_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologist',
			[`doctors_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologists',

			[`doctor_${DoctorSpecialty.UROLOGY}`]: 'Urologist',
			[`doctors_${DoctorSpecialty.UROLOGY}`]: 'Urologists',

			[`doctor_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologist',
			[`doctors_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologists',

			[`doctor_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Otorhinolaryngologist',
			[`doctors_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Otorhinolaryngologists',

			[`doctor_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endocrinologist',
			[`doctors_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endocrinologists',

			[`doctor_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologist',
			[`doctors_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologists',

			[`doctor_${DoctorSpecialty.PULMONOLOGY}`]: 'Pulmonologist',
			[`doctors_${DoctorSpecialty.PULMONOLOGY}`]: 'Pulmonologists',

			[`doctor_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematologist',
			[`doctors_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematologists',

			[`doctor_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatologist',
			[`doctors_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatologists',

			[`doctor_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopedic and Traumatology Doctor',
			[`doctors_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopedic and Traumatology Doctors',

			[`doctor_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastic Surgeon',
			[`doctors_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastic Surgeons',

			[`doctor_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesthesiologist',
			[`doctors_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesthesiologists',

			[`doctor_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Family Doctor',
			[`doctors_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Family Doctors',

			[`doctor_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiatrist',
			[`doctors_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiatrists',

			[`doctor_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychologist',
			[`doctors_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Pediatric Cardiologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Pediatric Cardiologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Pediatric Surgeon',
			[`doctors_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Pediatric Surgeons',

			[`doctor_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]:
				'Pediatric Neurologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]:
				'Pediatric Neurologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Pediatric Pulmonologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Pediatric Pulmonologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Pediatric Gastroenterologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Pediatric Gastroenterologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Pediatric Endocrinologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Pediatric Endocrinologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Pediatric Hematologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Pediatric Hematologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Pediatric Allergologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Pediatric Allergologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENT}`]:
				'Pediatric Otorhinolaryngologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENT}`]:
				'Pediatric Otorhinolaryngologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Pediatric Orthopedist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Pediatric Orthopedists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Pediatric Urologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Pediatric Urologists',

			[`doctor_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vascular Surgeon (Phlebologist)',
			[`doctors_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vascular Surgeons (Phlebologists)',

			[`doctor_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endocrine Surgeon',
			[`doctors_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endocrine Surgeons',

			[`doctor_${DoctorSpecialty.PROCTOLOGY}`]: 'Proctologist',
			[`doctors_${DoctorSpecialty.PROCTOLOGY}`]: 'Proctologists',

			[`doctor_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynecologic Oncologist',
			[`doctors_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynecologic Oncologists',

			[`doctor_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproductive Medicine Doctor',
			[`doctors_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproductive Medicine Doctors',

			[`doctor_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Clinical Biochemist',
			[`doctors_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Clinical Biochemists',

			[`doctor_${DoctorSpecialty.MICROBIOLOGY}`]: 'Microbiologist',
			[`doctors_${DoctorSpecialty.MICROBIOLOGY}`]: 'Microbiologists',

			[`doctor_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molecular Biologist',
			[`doctors_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molecular Biologists',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Physiatrist',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Physiatrists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Pediatric Physiatrist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Pediatric Physiatrists',

			[`doctor_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Aesthetic Medicine Doctor',
			[`doctors_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Aesthetic Medicine Doctors',

			[`doctor_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'General Medicine Doctor',
			[`doctors_${DoctorSpecialty.GENERAL_MEDICINE}`]:
				'General Medicine Doctors',

			[`doctor_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrologist',
			[`doctors_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrologists',

			[`doctor_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurosurgeon',
			[`doctors_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurosurgeons',

			[`doctor_${DoctorSpecialty.ONCOLOGY}`]: 'Oncologist',
			[`doctors_${DoctorSpecialty.ONCOLOGY}`]: 'Oncologists',

			[`doctor_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Emergency Medicine Doctor',
			[`doctors_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Emergency Medicine Doctors',

			[`doctor_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoracic Surgeon',
			[`doctors_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoracic Surgeons',

			[`doctor_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Occupational Medicine Doctor',
			[`doctors_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Occupational Medicine Doctors',

			[`doctor_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapist',
			[`doctors_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapists',

			[`doctor_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Infectious Disease Doctor',
			[`doctors_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Infectious Disease Doctors',

			[`doctor_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologist',
			[`doctors_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Pediatric Ophthalmologist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Pediatric Ophthalmologists',

			[`doctor_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Speech Therapist',
			[`doctors_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Speech Therapists',

			[`doctor_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologist',
			[`doctors_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Pediatric Plastic Surgeon',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Pediatric Plastic Surgeons',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physical Medicine and Rehabilitation Doctor',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physical Medicine and Rehabilitation Doctors',

			[`doctor_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oral Surgeon',
			[`doctors_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oral Surgeons',

			[`doctor_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammologist',
			[`doctors_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammologists',

			[`doctor_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Oncologic Surgeon',
			[`doctors_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Oncologic Surgeons',

			[`doctor_${DoctorSpecialty.DENTISTRY}`]: 'Dentist',
			[`doctors_${DoctorSpecialty.DENTISTRY}`]: 'Dentists',

			[`doctor_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergologist',
			[`doctors_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergologists',

			[`doctor_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunologist',
			[`doctors_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunologists',

			[`doctor_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Ophthalmic Surgeon',
			[`doctors_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Ophthalmic Surgeons',

			[`doctor_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopath',
			[`doctors_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopaths',

			[`doctor_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hyperbaric Medicine Doctor',
			[`doctors_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hyperbaric Medicine Doctors',

			[`doctor_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Pathologist',
			[`doctors_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Pathologists',

			[`doctor_${DoctorSpecialty.PODIATRY}`]: 'Podiatrist',
			[`doctors_${DoctorSpecialty.PODIATRY}`]: 'Podiatrists',

			[`doctor_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichologist',
			[`doctors_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichologists',

			[`doctor_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Pediatric Dentist',
			[`doctors_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Pediatric Dentists',

			[`doctor_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuclear Medicine Doctor',
			[`doctors_${DoctorSpecialty.NUCLEAR_MEDICINE}`]:
				'Nuclear Medicine Doctors',

			[`doctor_${DoctorSpecialty.GENETICS}`]: 'Medical Geneticist',
			[`doctors_${DoctorSpecialty.GENETICS}`]: 'Medical Geneticists',

			[`doctor_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Surgeon',
			[`doctors_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Surgeons',

			[`doctor_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maxillofacial Surgeon',
			[`doctors_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maxillofacial Surgeons',

			[`doctor_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Cardiac Surgeon',
			[`doctors_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Cardiac Surgeons',
		},
		ru: {
			Specialty: 'Специальность',
			AnySpecialty: 'Любая специальность',
			SearchSpecialty: 'Поиск специальности',
			NotFound: 'Специальность не найдена',

			[`specialty_${DoctorSpecialty.CARDIOLOGY}`]: 'Кардиология',
			[`doctor_${DoctorSpecialty.CARDIOLOGY}`]: 'Кардиолог',
			[`doctors_${DoctorSpecialty.CARDIOLOGY}`]: 'Кардиологи',

			[`specialty_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Внутренние болезни',
			[`doctor_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'Врач внутренней медицины',
			[`doctors_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'Врачи внутренней медицины',

			[`specialty_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Общая хирургия',
			[`doctor_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Хирург',
			[`doctors_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Хирурги',

			[`specialty_${DoctorSpecialty.PEDIATRICS}`]: 'Педиатрия',
			[`doctor_${DoctorSpecialty.PEDIATRICS}`]: 'Педиатр',
			[`doctors_${DoctorSpecialty.PEDIATRICS}`]: 'Педиатры',

			[`specialty_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]:
				'Гинекология и акушерство',
			[`doctor_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Гинеколог',
			[`doctors_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Гинекологи',

			[`specialty_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Офтальмология',
			[`doctor_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Офтальмолог',
			[`doctors_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Офтальмологи',

			[`specialty_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Дерматовенерология',
			[`doctor_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Дерматовенеролог',
			[`doctors_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Дерматовенерологи',

			[`specialty_${DoctorSpecialty.NEUROLOGY}`]: 'Неврология',
			[`doctor_${DoctorSpecialty.NEUROLOGY}`]: 'Невролог',
			[`doctors_${DoctorSpecialty.NEUROLOGY}`]: 'Неврологи',

			[`specialty_${DoctorSpecialty.UROLOGY}`]: 'Урология',
			[`doctor_${DoctorSpecialty.UROLOGY}`]: 'Уролог',
			[`doctors_${DoctorSpecialty.UROLOGY}`]: 'Урологи',

			[`specialty_${DoctorSpecialty.RADIOLOGY}`]: 'Радиология',
			[`doctor_${DoctorSpecialty.RADIOLOGY}`]: 'Радиолог',
			[`doctors_${DoctorSpecialty.RADIOLOGY}`]: 'Радиологи',

			[`specialty_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Оториноларингология',
			[`doctor_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'Оториноларинголог',
			[`doctors_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'Оториноларингологи',

			[`specialty_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Эндокринология',
			[`doctor_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Эндокринолог',
			[`doctors_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Эндокринологи',

			[`specialty_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Гастроэнтерология',
			[`doctor_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Гастроэнтеролог',
			[`doctors_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Гастроэнтерологи',

			[`specialty_${DoctorSpecialty.PULMONOLOGY}`]: 'Пульмонология',
			[`doctor_${DoctorSpecialty.PULMONOLOGY}`]: 'Пульмонолог',
			[`doctors_${DoctorSpecialty.PULMONOLOGY}`]: 'Пульмонологи',

			[`specialty_${DoctorSpecialty.HEMATOLOGY}`]: 'Гематология',
			[`doctor_${DoctorSpecialty.HEMATOLOGY}`]: 'Гематолог',
			[`doctors_${DoctorSpecialty.HEMATOLOGY}`]: 'Гематологи',

			[`specialty_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Ревматология',
			[`doctor_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Ревматолог',
			[`doctors_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Ревматологи',

			[`specialty_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Травматология и ортопедия',
			[`doctor_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Травматолог и ортопед',
			[`doctors_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Травматологи и ортопеды',

			[`specialty_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Пластическая хирургия',
			[`doctor_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Пластический хирург',
			[`doctors_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Пластические хирурги',

			[`specialty_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Анестезиология',
			[`doctor_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Анестезиолог',
			[`doctors_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Анестезиологи',

			[`specialty_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Семейная медицина',
			[`doctor_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Семейный врач',
			[`doctors_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Семейные врачи',

			[`specialty_${DoctorSpecialty.PSYCHIATRY}`]: 'Психиатрия',
			[`doctor_${DoctorSpecialty.PSYCHIATRY}`]: 'Психиатр',
			[`doctors_${DoctorSpecialty.PSYCHIATRY}`]: 'Психиатры',

			[`specialty_${DoctorSpecialty.PSYCHOLOGY}`]: 'Психология',
			[`doctor_${DoctorSpecialty.PSYCHOLOGY}`]: 'Психолог',
			[`doctors_${DoctorSpecialty.PSYCHOLOGY}`]: 'Психологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Детская кардиология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Детский кардиолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Детские кардиологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Детская хирургия',
			[`doctor_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Детский хирург',
			[`doctors_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Детские хирурги',

			[`specialty_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]:
				'Детская неврология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Детский невролог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Детские неврологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Детская пульмонология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Детский пульмонолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Детские пульмонологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Детская гастроэнтерология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Детский гастроэнтеролог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Детские гастроэнтерологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Детская эндокринология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Детский эндокринолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Детские эндокринологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Детская гематология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Детский гематолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Детские гематологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Детская аллергология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]: 'Детский аллерголог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Детские аллергологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_ENT}`]:
				'Детская оториноларингология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Детский оториноларинголог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENT}`]:
				'Детские оториноларингологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Детская ортопедия',
			[`doctor_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Детский ортопед',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Детские ортопеды',

			[`specialty_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Детская урология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Детский уролог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Детские урологи',

			[`specialty_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Сосудистая хирургия (флебология)',
			[`doctor_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Сосудистый хирург (флеболог)',
			[`doctors_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Сосудистые хирурги (флебологи)',

			[`specialty_${DoctorSpecialty.ENDOCRINE_SURGERY}`]:
				'Эндокринная хирургия',
			[`doctor_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Эндокринный хирург',
			[`doctors_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Эндокринные хирурги',

			[`specialty_${DoctorSpecialty.PROCTOLOGY}`]: 'Проктология',
			[`doctor_${DoctorSpecialty.PROCTOLOGY}`]: 'Проктолог',
			[`doctors_${DoctorSpecialty.PROCTOLOGY}`]: 'Проктологи',

			[`specialty_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Гинекологическая онкология',
			[`doctor_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Гинекологический онколог',
			[`doctors_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Гинекологические онкологи',

			[`specialty_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Репродуктивная медицина',
			[`doctor_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Репродуктивный врач',
			[`doctors_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Репродуктивные врачи',

			[`specialty_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Клиническая биохимия',
			[`doctor_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Клинический биохимик',
			[`doctors_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Клинические биохимики',

			[`specialty_${DoctorSpecialty.MICROBIOLOGY}`]: 'Микробиология',
			[`doctor_${DoctorSpecialty.MICROBIOLOGY}`]: 'Микробиолог',
			[`doctors_${DoctorSpecialty.MICROBIOLOGY}`]: 'Микробиологи',

			[`specialty_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]:
				'Молекулярная биология',
			[`doctor_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Молекулярный биолог',
			[`doctors_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Молекулярные биологи',

			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Физиатрия',
			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Физиолог',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Физиологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Детская физиатрия',
			[`doctor_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Детский физиолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Детские физиологи',

			[`specialty_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Эстетическая медицина',
			[`doctor_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Врач эстетической медицины',
			[`doctors_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Врачи эстетической медицины',

			[`specialty_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Общая медицина',
			[`doctor_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Врач общей медицины',
			[`doctors_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Врачи общей медицины',

			[`specialty_${DoctorSpecialty.NEPHROLOGY}`]: 'Нефрология',
			[`doctor_${DoctorSpecialty.NEPHROLOGY}`]: 'Нефролог',
			[`doctors_${DoctorSpecialty.NEPHROLOGY}`]: 'Нефрологи',

			[`specialty_${DoctorSpecialty.NEUROSURGERY}`]: 'Нейрохирургия',
			[`doctor_${DoctorSpecialty.NEUROSURGERY}`]: 'Нейрохирург',
			[`doctors_${DoctorSpecialty.NEUROSURGERY}`]: 'Нейрохирурги',

			[`specialty_${DoctorSpecialty.ONCOLOGY}`]: 'Онкология',
			[`doctor_${DoctorSpecialty.ONCOLOGY}`]: 'Онколог',
			[`doctors_${DoctorSpecialty.ONCOLOGY}`]: 'Онкологи',

			[`specialty_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Неотложная медицина',
			[`doctor_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Врач неотложной медицины',
			[`doctors_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Врачи неотложной медицины',

			[`specialty_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Торакальная хирургия',
			[`doctor_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Торакальный хирург',
			[`doctors_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Торакальные хирурги',

			[`specialty_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'Медицина труда',
			[`doctor_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Врач медицины труда',
			[`doctors_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Врачи медицины труда',

			[`specialty_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Психотерапия',
			[`doctor_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Психотерапевт',
			[`doctors_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Психотерапевты',

			[`specialty_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Инфекционные болезни',
			[`doctor_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Врач инфекционных болезней',
			[`doctors_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Врачи инфекционных болезней',

			[`specialty_${DoctorSpecialty.NEONATOLOGY}`]: 'Неонатология',
			[`doctor_${DoctorSpecialty.NEONATOLOGY}`]: 'Неонатолог',
			[`doctors_${DoctorSpecialty.NEONATOLOGY}`]: 'Неонатологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Детская офтальмология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Детский офтальмолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Детские офтальмологи',

			[`specialty_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Логопедия',
			[`doctor_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Логопед',
			[`doctors_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Логопеды',

			[`specialty_${DoctorSpecialty.PERINATOLOGY}`]: 'Перинатология',
			[`doctor_${DoctorSpecialty.PERINATOLOGY}`]: 'Перинатолог',
			[`doctors_${DoctorSpecialty.PERINATOLOGY}`]: 'Перинатологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Детская пластическая хирургия',
			[`doctor_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Детский пластический хирург',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Детские пластические хирурги',

			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Физикальная медицина и реабилитация',
			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Физиотерапевт',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Физиотерапевты',

			[`specialty_${DoctorSpecialty.ORAL_SURGERY}`]:
				'Хирургическая стоматология',
			[`doctor_${DoctorSpecialty.ORAL_SURGERY}`]: 'Стоматолог-хирург',
			[`doctors_${DoctorSpecialty.ORAL_SURGERY}`]: 'Стоматологи-хирурги',

			[`specialty_${DoctorSpecialty.MAMMOLOGY}`]: 'Маммология',
			[`doctor_${DoctorSpecialty.MAMMOLOGY}`]: 'Маммолог',
			[`doctors_${DoctorSpecialty.MAMMOLOGY}`]: 'Маммологи',

			[`specialty_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Онкохирургия',
			[`doctor_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Онкохирург',
			[`doctors_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Онкохирурги',

			[`specialty_${DoctorSpecialty.DENTISTRY}`]: 'Стоматология',
			[`doctor_${DoctorSpecialty.DENTISTRY}`]: 'Стоматолог',
			[`doctors_${DoctorSpecialty.DENTISTRY}`]: 'Стоматологи',

			[`specialty_${DoctorSpecialty.ALLERGOLOGY}`]: 'Аллергология',
			[`doctor_${DoctorSpecialty.ALLERGOLOGY}`]: 'Аллерголог',
			[`doctors_${DoctorSpecialty.ALLERGOLOGY}`]: 'Аллергологи',

			[`specialty_${DoctorSpecialty.IMMUNOLOGY}`]: 'Иммунология',
			[`doctor_${DoctorSpecialty.IMMUNOLOGY}`]: 'Иммунолог',
			[`doctors_${DoctorSpecialty.IMMUNOLOGY}`]: 'Иммунологи',

			[`specialty_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Офтальмохирургия',
			[`doctor_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Офтальмолог-хирург',
			[`doctors_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Офтальмологи-хирурги',

			[`specialty_${DoctorSpecialty.OSTEOPATHY}`]: 'Остеопатия',
			[`doctor_${DoctorSpecialty.OSTEOPATHY}`]: 'Остеопат',
			[`doctors_${DoctorSpecialty.OSTEOPATHY}`]: 'Остеопаты',

			[`specialty_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Гипербарическая медицина',
			[`doctor_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Врач гипербарической медицины',
			[`doctors_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Врачи гипербарической медицины',

			[`specialty_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]:
				'Патологическая анатомия',
			[`doctor_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Патологоанатом',
			[`doctors_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Патологоанатомы',

			[`specialty_${DoctorSpecialty.PODIATRY}`]: 'Подология',
			[`doctor_${DoctorSpecialty.PODIATRY}`]: 'Подолог',
			[`doctors_${DoctorSpecialty.PODIATRY}`]: 'Подологи',

			[`specialty_${DoctorSpecialty.TRICHOLOGY}`]: 'Трихология',
			[`doctor_${DoctorSpecialty.TRICHOLOGY}`]: 'Трихолог',
			[`doctors_${DoctorSpecialty.TRICHOLOGY}`]: 'Трихологи',

			[`specialty_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]:
				'Детская стоматология',
			[`doctor_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Детский стоматолог',
			[`doctors_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Детские стоматологи',

			[`specialty_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Ядерная медицина',
			[`doctor_${DoctorSpecialty.NUCLEAR_MEDICINE}`]:
				'Специалист по ядерной медицине',
			[`doctors_${DoctorSpecialty.NUCLEAR_MEDICINE}`]:
				'Специалисты по ядерной медицине',

			[`specialty_${DoctorSpecialty.GENETICS}`]: 'Медицинская генетика',
			[`doctor_${DoctorSpecialty.GENETICS}`]: 'Генетик',
			[`doctors_${DoctorSpecialty.GENETICS}`]: 'Генетики',

			[`specialty_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Абдоминальная хирургия',
			[`doctor_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Абдоминальный хирург',
			[`doctors_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Абдоминальные хирурги',

			[`specialty_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Челюстно-лицевая хирургия',
			[`doctor_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Челюстно-лицевой хирург',
			[`doctors_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Челюстно-лицевые хирурги',

			[`specialty_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Кардиохирургия',
			[`doctor_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Кардиохирург',
			[`doctors_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Кардиохирурги',
		},
		sr: {
			Specialty: 'Specijalnost',
			AnySpecialty: 'Bilo koja specijalnost',
			SearchSpecialty: 'Pretraga specijalnosti',
			NotFound: 'Nije pronađena specijalnost',

			[`specialty_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Opšta hirurgija',
			[`specialty_${DoctorSpecialty.PEDIATRICS}`]: 'Pedijatrija',
			[`specialty_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]:
				'Ginekologija i akušerstvo',
			[`specialty_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Oftalmologija',
			[`specialty_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerologija',
			[`specialty_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologija',
			[`specialty_${DoctorSpecialty.UROLOGY}`]: 'Urologija',
			[`specialty_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologija',
			[`specialty_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Otorinolaringologija',
			[`specialty_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinologija',
			[`specialty_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologija',
			[`specialty_${DoctorSpecialty.PULMONOLOGY}`]: 'Pneumoftiziologija',
			[`specialty_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematologija',
			[`specialty_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Reumatologija',
			[`specialty_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Traumatologija i ortopedija',
			[`specialty_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastična hirurgija',
			[`specialty_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziologija',
			[`specialty_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Porodična medicina',
			[`specialty_${DoctorSpecialty.PSYCHIATRY}`]: 'Psihijatrija',
			[`specialty_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psihologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Dečja kardiologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Dečja hirurgija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Dečja neurologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Dečja pulmologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Dečja gastroenterologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Dečja endokrinologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Dečja hematologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Dečja alergologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENT}`]:
				'Dečja otorinolaringologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Dečja ortopedija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Dečja urologija',
			[`specialty_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vaskularna hirurgija (flebologija)',
			[`specialty_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrina hirurgija',
			[`specialty_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktologija',
			[`specialty_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]: 'Onkogineologija',
			[`specialty_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproduktivna medicina',
			[`specialty_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinička biohemija',
			[`specialty_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiologija',
			[`specialty_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]:
				'Molekularna biologija',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Fizijatrija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Dečja fizijatrija',
			[`specialty_${DoctorSpecialty.AESTHETIC_MEDICINE}`]: 'Estetska medicina',
			[`specialty_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Opšta medicina',
			[`specialty_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefrologija',
			[`specialty_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurohirurgija',
			[`specialty_${DoctorSpecialty.ONCOLOGY}`]: 'Onkologija',
			[`specialty_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Urgentna medicina',
			[`specialty_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Torakalna hirurgija',
			[`specialty_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'Medicina rada',
			[`specialty_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psihoterapija',
			[`specialty_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Infektivne bolesti',
			[`specialty_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Dečja oftalmologija',
			[`specialty_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logopedija',
			[`specialty_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologija',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Dečja plastična hirurgija',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fizikalna medicina i rehabilitacija',
			[`specialty_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralna hirurgija',

			[`specialty_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiologija',
			[`doctor_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiolog',
			[`doctors_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiolozi',

			[`specialty_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Interna medicina',
			[`doctor_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Lekar interne medicine',
			[`doctors_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'Lekari interne medicine',

			[`doctor_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Hirurg',
			[`doctors_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Hirurzi',

			[`doctor_${DoctorSpecialty.PEDIATRICS}`]: 'Pedijatar',
			[`doctors_${DoctorSpecialty.PEDIATRICS}`]: 'Pedijatri',

			[`doctor_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Ginekolog',
			[`doctors_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Ginekolozi',

			[`doctor_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Oftalmolog',
			[`doctors_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Oftalmolozi',

			[`doctor_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerolog',
			[`doctors_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatovenerolozi',

			[`doctor_${DoctorSpecialty.NEUROLOGY}`]: 'Neurolog',
			[`doctors_${DoctorSpecialty.NEUROLOGY}`]: 'Neurolozi',

			[`doctor_${DoctorSpecialty.UROLOGY}`]: 'Urolog',
			[`doctors_${DoctorSpecialty.UROLOGY}`]: 'Urolozi',

			[`doctor_${DoctorSpecialty.RADIOLOGY}`]: 'Radiolog',
			[`doctors_${DoctorSpecialty.RADIOLOGY}`]: 'Radiolozi',

			[`doctor_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'Otorinolaringolog',
			[`doctors_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'Otorinolaringolozi',

			[`doctor_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinolog',
			[`doctors_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinolozi',

			[`doctor_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterolog',
			[`doctors_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterolozi',

			[`doctor_${DoctorSpecialty.PULMONOLOGY}`]: 'Pulmolog',
			[`doctors_${DoctorSpecialty.PULMONOLOGY}`]: 'Pulmolozi',

			[`doctor_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematolog',
			[`doctors_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematolozi',

			[`doctor_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Reumatolog',
			[`doctors_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Reumatolozi',

			[`doctor_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Traumatolog i ortoped',
			[`doctors_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Traumatolozi i ortopedi',

			[`doctor_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastični hirurg',
			[`doctors_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastični hirurzi',

			[`doctor_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziolog',
			[`doctors_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziolozi',

			[`doctor_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Porodični lekar',
			[`doctors_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Porodični lekari',

			[`doctor_${DoctorSpecialty.PSYCHIATRY}`]: 'Psihijatar',
			[`doctors_${DoctorSpecialty.PSYCHIATRY}`]: 'Psihijatri',

			[`doctor_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psiholog',
			[`doctors_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psiholozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Dečji kardiolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Dečji kardiolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Dečji hirurg',
			[`doctors_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Dečji hirurzi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Dečji neurolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Dečji neurolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]: 'Dečji pulmolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]: 'Dečji pulmolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Dečji gastroenterolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Dečji gastroenterolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Dečji endokrinolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Dečji endokrinolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Dečji hematolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Dečji hematolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]: 'Dečji alergolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]: 'Dečji alergolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Dečji otorinolaringolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Dečji otorinolaringolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Dečji ortoped',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Dečji ortopedi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Dečji urolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Dečji urolozi',

			[`doctor_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vaskularni hirurg (flebolog)',
			[`doctors_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Vaskularni hirurzi (flebolozi)',

			[`doctor_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrini hirurg',
			[`doctors_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrini hirurzi',

			[`doctor_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktolog',
			[`doctors_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktolozi',

			[`doctor_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]: 'Onkogineolog',
			[`doctors_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]: 'Onkoginekolozi',

			[`doctor_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Lekar reproduktivne medicine',
			[`doctors_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Lekari reproduktivne medicine',

			[`doctor_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinički biohemičar',
			[`doctors_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinički biohemičari',

			[`doctor_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiolog',
			[`doctors_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiolozi',

			[`doctor_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molekularni biolog',
			[`doctors_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molekularni biolozi',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Fizijatar',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Fizijatri',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Dečji fizijatar',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Dečji fizijatri',

			[`doctor_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Lekar estetske medicine',
			[`doctors_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Lekari estetske medicine',

			[`doctor_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Lekar opšte medicine',
			[`doctors_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Lekari opšte medicine',

			[`doctor_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefrolog',
			[`doctors_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefrolozi',

			[`doctor_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurohirurg',
			[`doctors_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurohirurzi',

			[`doctor_${DoctorSpecialty.ONCOLOGY}`]: 'Onkolog',
			[`doctors_${DoctorSpecialty.ONCOLOGY}`]: 'Onkolozi',

			[`doctor_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Lekar urgentne medicine',
			[`doctors_${DoctorSpecialty.EMERGENCY_MEDICINE}`]:
				'Lekari urgentne medicine',

			[`doctor_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Torakalni hirurg',
			[`doctors_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Torakalni hirurzi',

			[`doctor_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Lekar medicine rada',
			[`doctors_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'Lekari medicine rada',

			[`doctor_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psihoterapeut',
			[`doctors_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psihoterapeuti',

			[`doctor_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Lekar infektivnih bolesti',
			[`doctors_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Lekari infektivnih bolesti',

			[`doctor_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatolog',
			[`doctors_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]: 'Dečji oftalmolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Dečji oftalmolozi',

			[`doctor_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logoped',
			[`doctors_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logopedi',

			[`doctor_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatolog',
			[`doctors_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatolozi',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Dečji plastični hirurg',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Dečji plastični hirurzi',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fizijatar',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fizijatri',

			[`doctor_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralni hirurg',
			[`doctors_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralni hirurzi',

			[`specialty_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamologija',
			[`doctor_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamolog',
			[`doctors_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamolozi',

			[`specialty_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkološka hirurgija',
			[`doctor_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkološki hirurg',
			[`doctors_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkološki hirurzi',

			[`specialty_${DoctorSpecialty.DENTISTRY}`]: 'Stomatologija',
			[`doctor_${DoctorSpecialty.DENTISTRY}`]: 'Stomatolog',
			[`doctors_${DoctorSpecialty.DENTISTRY}`]: 'Stomatolozi',

			[`specialty_${DoctorSpecialty.ALLERGOLOGY}`]: 'Alergologija',
			[`doctor_${DoctorSpecialty.ALLERGOLOGY}`]: 'Alergolog',
			[`doctors_${DoctorSpecialty.ALLERGOLOGY}`]: 'Alergolozi',

			[`specialty_${DoctorSpecialty.IMMUNOLOGY}`]: 'Imunologija',
			[`doctor_${DoctorSpecialty.IMMUNOLOGY}`]: 'Imunolog',
			[`doctors_${DoctorSpecialty.IMMUNOLOGY}`]: 'Imunolozi',

			[`specialty_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]:
				'Oftalmološka hirurgija',
			[`doctor_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Oftalmolog-hirurg',
			[`doctors_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Oftalmolozi-hirurzi',

			[`specialty_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopatija',
			[`doctor_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopat',
			[`doctors_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopati',

			[`specialty_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hiperbarična medicina',
			[`doctor_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Lekar hiperbaričke medicine',
			[`doctors_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Lekari hiperbaričke medicine',

			[`specialty_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]:
				'Patološka anatomija',
			[`doctor_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Patohistolog',
			[`doctors_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Patohistolozi',

			[`specialty_${DoctorSpecialty.PODIATRY}`]: 'Podologija',
			[`doctor_${DoctorSpecialty.PODIATRY}`]: 'Podolog',
			[`doctors_${DoctorSpecialty.PODIATRY}`]: 'Podolozi',

			[`specialty_${DoctorSpecialty.TRICHOLOGY}`]: 'Trihologija',
			[`doctor_${DoctorSpecialty.TRICHOLOGY}`]: 'Triholog',
			[`doctors_${DoctorSpecialty.TRICHOLOGY}`]: 'Triholozi',

			[`specialty_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]:
				'Dečja stomatologija',
			[`doctor_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Dečji stomatolog',
			[`doctors_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Dečji stomatolozi',

			[`specialty_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuklearna medicina',
			[`doctor_${DoctorSpecialty.NUCLEAR_MEDICINE}`]:
				'Lekar nuklearne medicine',
			[`doctors_${DoctorSpecialty.NUCLEAR_MEDICINE}`]:
				'Lekari nuklearne medicine',

			[`specialty_${DoctorSpecialty.GENETICS}`]: 'Medicinska genetika',
			[`doctor_${DoctorSpecialty.GENETICS}`]: 'Genetičar',
			[`doctors_${DoctorSpecialty.GENETICS}`]: 'Genetičari',

			[`specialty_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinalna hirurgija',
			[`doctor_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinalni hirurg',
			[`doctors_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinalni hirurzi',

			[`specialty_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maksilofacijalna hirurgija',
			[`doctor_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maksilofacijalni hirurg',
			[`doctors_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Maksilofacijalni hirurzi',

			[`specialty_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kardiohirurgija',
			[`doctor_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kardiohirurg',
			[`doctors_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kardiohirurzi',
		},
		de: {
			Specialty: 'Fachrichtung',
			AnySpecialty: 'Beliebige Fachrichtung',
			SearchSpecialty: 'Fachrichtung suchen',
			NotFound: 'Fachrichtung nicht gefunden',

			[`specialty_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiologie',
			[`specialty_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Innere Medizin',
			[`specialty_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Allgemeine Chirurgie',
			[`specialty_${DoctorSpecialty.PEDIATRICS}`]: 'Pädiatrie',
			[`specialty_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]:
				'Gynäkologie und Geburtshilfe',
			[`specialty_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Augenheilkunde',
			[`specialty_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatologie',
			[`specialty_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologie',
			[`specialty_${DoctorSpecialty.UROLOGY}`]: 'Urologie',
			[`specialty_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologie',
			[`specialty_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]:
				'Hals-Nasen-Ohren-Heilkunde',
			[`specialty_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinologie',
			[`specialty_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologie',
			[`specialty_${DoctorSpecialty.PULMONOLOGY}`]: 'Pneumologie',
			[`specialty_${DoctorSpecialty.HEMATOLOGY}`]: 'Hämatologie',
			[`specialty_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatologie',
			[`specialty_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopädie und Traumatologie',
			[`specialty_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastische Chirurgie',
			[`specialty_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anästhesiologie',
			[`specialty_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Allgemeinmedizin',
			[`specialty_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiatrie',
			[`specialty_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Kinderkardiologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Kinderchirurgie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Kinderneurologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Kinderpneumologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Kindergastroenterologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Kinderendokrinologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Kinderhämatologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Kinderallergologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Kinder-HNO',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Kinderorthopädie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Kinderurologie',
			[`specialty_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Gefäßchirurgie (Phlebologie)',
			[`specialty_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrine Chirurgie',
			[`specialty_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktologie',
			[`specialty_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynäkologische Onkologie',
			[`specialty_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproduktionsmedizin',
			[`specialty_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinische Biochemie',
			[`specialty_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiologie',
			[`specialty_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molekularbiologie',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE}`]:
				'Physikalische Medizin',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Kinderphysikalische Medizin',
			[`specialty_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Ästhetische Medizin',
			[`specialty_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Allgemeine Medizin',
			[`specialty_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrologie',
			[`specialty_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurochirurgie',
			[`specialty_${DoctorSpecialty.ONCOLOGY}`]: 'Onkologie',
			[`specialty_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Notfallmedizin',
			[`specialty_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoraxchirurgie',
			[`specialty_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'Arbeitsmedizin',
			[`specialty_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapie',
			[`specialty_${DoctorSpecialty.INFECTIOUS_DISEASES}`]: 'Infektiologie',
			[`specialty_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Kinderaugenheilkunde',
			[`specialty_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logopädie',
			[`specialty_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Kinderplastische Chirurgie',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physikalische Medizin und Rehabilitation',
			[`specialty_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralchirurgie',
			[`specialty_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammologie',
			[`specialty_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]:
				'Onkologische Chirurgie',
			[`specialty_${DoctorSpecialty.DENTISTRY}`]: 'Zahnmedizin',
			[`specialty_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergologie',
			[`specialty_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunologie',
			[`specialty_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Augenchirurgie',
			[`specialty_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopathie',
			[`specialty_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]: 'Hyperbare Medizin',
			[`specialty_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]:
				'Pathologische Anatomie',
			[`specialty_${DoctorSpecialty.PODIATRY}`]: 'Podologie',
			[`specialty_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichologie',
			[`specialty_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]:
				'Kinderzahnheilkunde',
			[`specialty_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuklearmedizin',
			[`specialty_${DoctorSpecialty.GENETICS}`]: 'Medizinische Genetik',
			[`specialty_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Viszeralchirurgie',
			[`specialty_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Mund-Kiefer-Gesichtschirurgie',
			[`specialty_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Herzchirurgie',

			[`doctor_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiologe',
			[`doctors_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiologen',

			[`doctor_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Internist',
			[`doctors_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'Internisten',

			[`doctor_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Chirurg',
			[`doctors_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Chirurgen',

			[`doctor_${DoctorSpecialty.PEDIATRICS}`]: 'Kinderarzt',
			[`doctors_${DoctorSpecialty.PEDIATRICS}`]: 'Kinderärzte',

			[`doctor_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Gynäkologe',
			[`doctors_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Gynäkologen',

			[`doctor_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Augenarzt',
			[`doctors_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Augenärzte',

			[`doctor_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatologe',
			[`doctors_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatologen',

			[`doctor_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologe',
			[`doctors_${DoctorSpecialty.NEUROLOGY}`]: 'Neurologen',

			[`doctor_${DoctorSpecialty.UROLOGY}`]: 'Urologe',
			[`doctors_${DoctorSpecialty.UROLOGY}`]: 'Urologen',

			[`doctor_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologe',
			[`doctors_${DoctorSpecialty.RADIOLOGY}`]: 'Radiologen',

			[`doctor_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'HNO-Arzt',
			[`doctors_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'HNO-Ärzte',

			[`doctor_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinologe',
			[`doctors_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinologen',

			[`doctor_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologe',
			[`doctors_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologen',

			[`doctor_${DoctorSpecialty.PULMONOLOGY}`]: 'Pneumologe',
			[`doctors_${DoctorSpecialty.PULMONOLOGY}`]: 'Pneumologen',

			[`doctor_${DoctorSpecialty.HEMATOLOGY}`]: 'Hämatologe',
			[`doctors_${DoctorSpecialty.HEMATOLOGY}`]: 'Hämatologen',

			[`doctor_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatologe',
			[`doctors_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Rheumatologen',

			[`doctor_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopäde und Traumatologe',
			[`doctors_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Orthopäden und Traumatologen',

			[`doctor_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastischer Chirurg',
			[`doctors_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastische Chirurgen',

			[`doctor_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anästhesiologe',
			[`doctors_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anästhesiologen',

			[`doctor_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Hausarzt',
			[`doctors_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Hausärzte',

			[`doctor_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiater',
			[`doctors_${DoctorSpecialty.PSYCHIATRY}`]: 'Psychiater',

			[`doctor_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychologe',
			[`doctors_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psychologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Kinderkardiologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Kinderkardiologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Kinderchirurg',
			[`doctors_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Kinderchirurgen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Kinderneurologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Kinderneurologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]: 'Kinderpneumologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]: 'Kinderpneumologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Kindergastroenterologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Kindergastroenterologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Kinderendokrinologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Kinderendokrinologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Kinderhämatologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]: 'Kinderhämatologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]: 'Kinderallergologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Kinderallergologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Kinder-HNO-Arzt',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Kinder-HNO-Ärzte',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Kinderorthopäde',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Kinderorthopäden',

			[`doctor_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Kinderurologe',
			[`doctors_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Kinderurologen',

			[`doctor_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Gefäßchirurg (Phlebologe)',
			[`doctors_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Gefäßchirurgen (Phlebologen)',

			[`doctor_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokriner Chirurg',
			[`doctors_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrine Chirurgen',

			[`doctor_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktologe',
			[`doctors_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktologen',

			[`doctor_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynäkologischer Onkologe',
			[`doctors_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Gynäkologische Onkologen',

			[`doctor_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproduktionsmediziner',
			[`doctors_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Reproduktionsmediziner',

			[`doctor_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinischer Biochemiker',
			[`doctors_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Klinische Biochemiker',

			[`doctor_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiologe',
			[`doctors_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiologen',

			[`doctor_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molekularbiologe',
			[`doctors_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Molekularbiologen',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE}`]:
				'Physikalischer Mediziner',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE}`]:
				'Physikalische Mediziner',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Kinderphysikalischer Mediziner',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Kinderphysikalische Mediziner',

			[`doctor_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Ästhetischer Mediziner',
			[`doctors_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Ästhetische Mediziner',

			[`doctor_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Allgemeinmediziner',
			[`doctors_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Allgemeinmediziner',

			[`doctor_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrologe',
			[`doctors_${DoctorSpecialty.NEPHROLOGY}`]: 'Nephrologen',

			[`doctor_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurochirurg',
			[`doctors_${DoctorSpecialty.NEUROSURGERY}`]: 'Neurochirurgen',

			[`doctor_${DoctorSpecialty.ONCOLOGY}`]: 'Onkologe',
			[`doctors_${DoctorSpecialty.ONCOLOGY}`]: 'Onkologen',

			[`doctor_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Notfallmediziner',
			[`doctors_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Notfallmediziner',

			[`doctor_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoraxchirurg',
			[`doctors_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Thoraxchirurgen',

			[`doctor_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'Arbeitsmediziner',
			[`doctors_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'Arbeitsmediziner',

			[`doctor_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapeut',
			[`doctors_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psychotherapeuten',

			[`doctor_${DoctorSpecialty.INFECTIOUS_DISEASES}`]: 'Infektiologe',
			[`doctors_${DoctorSpecialty.INFECTIOUS_DISEASES}`]: 'Infektiologen',

			[`doctor_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologe',
			[`doctors_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]: 'Kinderaugenarzt',
			[`doctors_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Kinderaugenärzte',

			[`doctor_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logopäde',
			[`doctors_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Logopäden',

			[`doctor_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologe',
			[`doctors_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Kinderplastischer Chirurg',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Kinderplastische Chirurgen',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physikalischer Mediziner und Rehabilitationsarzt',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Physikalische Mediziner und Rehabilitationsärzte',

			[`doctor_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralchirurg',
			[`doctors_${DoctorSpecialty.ORAL_SURGERY}`]: 'Oralchirurgen',

			[`doctor_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammologe',
			[`doctors_${DoctorSpecialty.MAMMOLOGY}`]: 'Mammologen',

			[`doctor_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkologischer Chirurg',
			[`doctors_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]:
				'Onkologische Chirurgen',

			[`doctor_${DoctorSpecialty.DENTISTRY}`]: 'Zahnarzt',
			[`doctors_${DoctorSpecialty.DENTISTRY}`]: 'Zahnärzte',

			[`doctor_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergologe',
			[`doctors_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allergologen',

			[`doctor_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunologe',
			[`doctors_${DoctorSpecialty.IMMUNOLOGY}`]: 'Immunologen',

			[`doctor_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Augenchirurg',
			[`doctors_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Augenchirurgen',

			[`doctor_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopath',
			[`doctors_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopathen',

			[`doctor_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hyperbare Medizin Arzt',
			[`doctors_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hyperbare Medizin Ärzte',

			[`doctor_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Pathologe',
			[`doctors_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Pathologen',

			[`doctor_${DoctorSpecialty.PODIATRY}`]: 'Podologe',
			[`doctors_${DoctorSpecialty.PODIATRY}`]: 'Podologen',

			[`doctor_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichologe',
			[`doctors_${DoctorSpecialty.TRICHOLOGY}`]: 'Trichologen',

			[`doctor_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Kinderzahnarzt',
			[`doctors_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Kinderzahnärzte',

			[`doctor_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuklearmediziner',
			[`doctors_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nuklearmediziner',

			[`doctor_${DoctorSpecialty.GENETICS}`]: 'Humangenetiker',
			[`doctors_${DoctorSpecialty.GENETICS}`]: 'Humangenetiker',

			[`doctor_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]: 'Viszeralchirurg',
			[`doctors_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Viszeralchirurgen',

			[`doctor_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Mund-Kiefer-Gesichtschirurg',
			[`doctors_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Mund-Kiefer-Gesichtschirurgen',

			[`doctor_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Herzchirurg',
			[`doctors_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Herzchirurgen',
		},
		tr: {
			Specialty: 'Uzmanlık',
			AnySpecialty: 'Herhangi bir uzmanlık',
			SearchSpecialty: 'Uzmanlık ara',
			NotFound: 'Uzmanlık bulunamadı',

			[`specialty_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiyoloji',
			[`specialty_${DoctorSpecialty.INTERNAL_MEDICINE}`]: 'İç Hastalıkları',
			[`specialty_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Genel Cerrahi',
			[`specialty_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatri',
			[`specialty_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Kadın Doğum',
			[`specialty_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Göz Hastalıkları',
			[`specialty_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatoloji',
			[`specialty_${DoctorSpecialty.NEUROLOGY}`]: 'Nöroloji',
			[`specialty_${DoctorSpecialty.UROLOGY}`]: 'Üroloji',
			[`specialty_${DoctorSpecialty.RADIOLOGY}`]: 'Radyoloji',
			[`specialty_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'Kulak Burun Boğaz',
			[`specialty_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinoloji',
			[`specialty_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenteroloji',
			[`specialty_${DoctorSpecialty.PULMONOLOGY}`]: 'Göğüs Hastalıkları',
			[`specialty_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematoloji',
			[`specialty_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Romatoloji',
			[`specialty_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Ortopedi ve Travmatoloji',
			[`specialty_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastik Cerrahi',
			[`specialty_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziyoloji',
			[`specialty_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Aile Hekimliği',
			[`specialty_${DoctorSpecialty.PSYCHIATRY}`]: 'Psikiyatri',
			[`specialty_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psikoloji',
			[`specialty_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Çocuk Kardiyolojisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Çocuk Cerrahisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Çocuk Nörolojisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Çocuk Göğüs Hastalıkları',
			[`specialty_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Çocuk Gastroenterolojisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Çocuk Endokrinolojisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Çocuk Hematolojisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]: 'Çocuk Allerji',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Çocuk KBB',
			[`specialty_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Çocuk Ortopedisi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Çocuk Ürolojisi',
			[`specialty_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Damar Cerrahisi (Fleboloji)',
			[`specialty_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrin Cerrahisi',
			[`specialty_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktoloji',
			[`specialty_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Jinekolojik Onkoloji',
			[`specialty_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]: 'Üreme Tıbbı',
			[`specialty_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]: 'Tıbbi Biyokimya',
			[`specialty_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiyoloji',
			[`specialty_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Moleküler Biyoloji',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Fizik Tedavi',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Çocuk Fizik Tedavisi',
			[`specialty_${DoctorSpecialty.AESTHETIC_MEDICINE}`]: 'Estetik Tıp',
			[`specialty_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Genel Tıp',
			[`specialty_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefroloji',
			[`specialty_${DoctorSpecialty.NEUROSURGERY}`]: 'Beyin Cerrahisi',
			[`specialty_${DoctorSpecialty.ONCOLOGY}`]: 'Onkoloji',
			[`specialty_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Acil Tıp',
			[`specialty_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Göğüs Cerrahisi',
			[`specialty_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'İş Sağlığı',
			[`specialty_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psikoterapi',
			[`specialty_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Enfeksiyon Hastalıkları',
			[`specialty_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatoloji',
			[`specialty_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Çocuk Göz Hastalıkları',
			[`specialty_${DoctorSpecialty.SPEECH_THERAPY}`]:
				'Dil ve Konuşma Terapisi',
			[`specialty_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatoloji',
			[`specialty_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Çocuk Plastik Cerrahisi',
			[`specialty_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fiziksel Tıp ve Rehabilitasyon',
			[`specialty_${DoctorSpecialty.ORAL_SURGERY}`]: 'Ağız Cerrahisi',
			[`specialty_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamoloji',
			[`specialty_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkolojik Cerrahi',
			[`specialty_${DoctorSpecialty.DENTISTRY}`]: 'Diş Hekimliği',
			[`specialty_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allerji',
			[`specialty_${DoctorSpecialty.IMMUNOLOGY}`]: 'İmmünoloji',
			[`specialty_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Göz Cerrahisi',
			[`specialty_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopati',
			[`specialty_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]: 'Hiperbarik Tıp',
			[`specialty_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]:
				'Patolojik Anatomi',
			[`specialty_${DoctorSpecialty.PODIATRY}`]: 'Podiyatri',
			[`specialty_${DoctorSpecialty.TRICHOLOGY}`]: 'Trikoloji',
			[`specialty_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]:
				'Çocuk Diş Hekimliği',
			[`specialty_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nükleer Tıp',
			[`specialty_${DoctorSpecialty.GENETICS}`]: 'Tıbbi Genetik',
			[`specialty_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Cerrahi',
			[`specialty_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Çene ve Yüz Cerrahisi',
			[`specialty_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kalp Cerrahisi',

			[`doctor_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiyolog',
			[`doctors_${DoctorSpecialty.CARDIOLOGY}`]: 'Kardiyologlar',

			[`doctor_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'İç Hastalıkları Doktoru',
			[`doctors_${DoctorSpecialty.INTERNAL_MEDICINE}`]:
				'İç Hastalıkları Doktorları',

			[`doctor_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Cerrah',
			[`doctors_${DoctorSpecialty.GENERAL_SURGERY}`]: 'Cerrahlar',

			[`doctor_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatrist',
			[`doctors_${DoctorSpecialty.PEDIATRICS}`]: 'Pediatristler',

			[`doctor_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Jinekolog',
			[`doctors_${DoctorSpecialty.GYNECOLOGY_OBSTETRICS}`]: 'Jinekologlar',

			[`doctor_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Göz Doktoru',
			[`doctors_${DoctorSpecialty.OPHTHALMOLOGY}`]: 'Göz Doktorları',

			[`doctor_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatolog',
			[`doctors_${DoctorSpecialty.DERMATOVENEROLOGY}`]: 'Dermatologlar',

			[`doctor_${DoctorSpecialty.NEUROLOGY}`]: 'Nörolog',
			[`doctors_${DoctorSpecialty.NEUROLOGY}`]: 'Nörologlar',

			[`doctor_${DoctorSpecialty.UROLOGY}`]: 'Ürolog',
			[`doctors_${DoctorSpecialty.UROLOGY}`]: 'Ürologlar',

			[`doctor_${DoctorSpecialty.RADIOLOGY}`]: 'Radyolog',
			[`doctors_${DoctorSpecialty.RADIOLOGY}`]: 'Radyologlar',

			[`doctor_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'KBB Doktoru',
			[`doctors_${DoctorSpecialty.OTORHINOLARYNGOLOGY}`]: 'KBB Doktorları',

			[`doctor_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinolog',
			[`doctors_${DoctorSpecialty.ENDOCRINOLOGY}`]: 'Endokrinologlar',

			[`doctor_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterolog',
			[`doctors_${DoctorSpecialty.GASTROENTEROLOGY}`]: 'Gastroenterologlar',

			[`doctor_${DoctorSpecialty.PULMONOLOGY}`]: 'Göğüs Hastalıkları Doktoru',
			[`doctors_${DoctorSpecialty.PULMONOLOGY}`]:
				'Göğüs Hastalıkları Doktorları',

			[`doctor_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematoloji Doktoru',
			[`doctors_${DoctorSpecialty.HEMATOLOGY}`]: 'Hematoloji Doktorları',

			[`doctor_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Romatolog',
			[`doctors_${DoctorSpecialty.RHEUMATOLOGY}`]: 'Romatologlar',

			[`doctor_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Ortopedi ve Travmatoloji Doktoru',
			[`doctors_${DoctorSpecialty.ORTHOPEDICS_TRAUMATOLOGY}`]:
				'Ortopedi ve Travmatoloji Doktorları',

			[`doctor_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastik Cerrah',
			[`doctors_${DoctorSpecialty.PLASTIC_SURGERY}`]: 'Plastik Cerrahlar',

			[`doctor_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziyolog',
			[`doctors_${DoctorSpecialty.ANESTHESIOLOGY}`]: 'Anesteziyologlar',

			[`doctor_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Aile Hekimi',
			[`doctors_${DoctorSpecialty.FAMILY_MEDICINE}`]: 'Aile Hekimleri',

			[`doctor_${DoctorSpecialty.PSYCHIATRY}`]: 'Psikiyatrist',
			[`doctors_${DoctorSpecialty.PSYCHIATRY}`]: 'Psikiyatristler',

			[`doctor_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psikolog',
			[`doctors_${DoctorSpecialty.PSYCHOLOGY}`]: 'Psikologlar',

			[`doctor_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]: 'Çocuk Kardiyoloğu',
			[`doctors_${DoctorSpecialty.PEDIATRIC_CARDIOLOGY}`]:
				'Çocuk Kardiyologları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Çocuk Cerrahı',
			[`doctors_${DoctorSpecialty.PEDIATRIC_SURGERY}`]: 'Çocuk Cerrahları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Çocuk Nöroloğu',
			[`doctors_${DoctorSpecialty.PEDIATRIC_NEUROLOGY}`]: 'Çocuk Nörologları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Çocuk Göğüs Hastalıkları Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PULMONOLOGY}`]:
				'Çocuk Göğüs Hastalıkları Doktorları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Çocuk Gastroenteroloğu',
			[`doctors_${DoctorSpecialty.PEDIATRIC_GASTROENTEROLOGY}`]:
				'Çocuk Gastroenterologları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Çocuk Endokrinoloğu',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENDOCRINOLOGY}`]:
				'Çocuk Endokrinologları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Çocuk Hematoloji Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_HEMATOLOGY}`]:
				'Çocuk Hematoloji Doktorları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Çocuk Allerji Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ALLERGOLOGY}`]:
				'Çocuk Allerji Doktorları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Çocuk KBB Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ENT}`]: 'Çocuk KBB Doktorları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]: 'Çocuk Ortopedisti',
			[`doctors_${DoctorSpecialty.PEDIATRIC_ORTHOPEDICS}`]:
				'Çocuk Ortopedistleri',

			[`doctor_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Çocuk Üroloğu',
			[`doctors_${DoctorSpecialty.PEDIATRIC_UROLOGY}`]: 'Çocuk Ürologları',

			[`doctor_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Damar Cerrahı (Flebolog)',
			[`doctors_${DoctorSpecialty.VASCULAR_SURGERY}`]:
				'Damar Cerrahları (Flebologlar)',

			[`doctor_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrin Cerrahı',
			[`doctors_${DoctorSpecialty.ENDOCRINE_SURGERY}`]: 'Endokrin Cerrahları',

			[`doctor_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktolog',
			[`doctors_${DoctorSpecialty.PROCTOLOGY}`]: 'Proktologlar',

			[`doctor_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]: 'Jinekolojik Onkolog',
			[`doctors_${DoctorSpecialty.GYNECOLOGIC_ONCOLOGY}`]:
				'Jinekolojik Onkologlar',

			[`doctor_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Üreme Tıbbı Doktoru',
			[`doctors_${DoctorSpecialty.REPRODUCTIVE_MEDICINE}`]:
				'Üreme Tıbbı Doktorları',

			[`doctor_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]: 'Tıbbi Biyokimyager',
			[`doctors_${DoctorSpecialty.CLINICAL_BIOCHEMISTRY}`]:
				'Tıbbi Biyokimyagerler',

			[`doctor_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiolog',
			[`doctors_${DoctorSpecialty.MICROBIOLOGY}`]: 'Mikrobiyologlar',

			[`doctor_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Moleküler Biyolog',
			[`doctors_${DoctorSpecialty.MOLECULAR_BIOLOGY}`]: 'Moleküler Biyologlar',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE}`]: 'Fizik Tedavi Doktoru',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE}`]:
				'Fizik Tedavi Doktorları',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Çocuk Fizik Tedavi Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PHYSICAL_MEDICINE}`]:
				'Çocuk Fizik Tedavi Doktorları',

			[`doctor_${DoctorSpecialty.AESTHETIC_MEDICINE}`]: 'Estetik Tıp Doktoru',
			[`doctors_${DoctorSpecialty.AESTHETIC_MEDICINE}`]:
				'Estetik Tıp Doktorları',

			[`doctor_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Genel Tıp Doktoru',
			[`doctors_${DoctorSpecialty.GENERAL_MEDICINE}`]: 'Genel Tıp Doktorları',

			[`doctor_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefrolog',
			[`doctors_${DoctorSpecialty.NEPHROLOGY}`]: 'Nefrologlar',

			[`doctor_${DoctorSpecialty.NEUROSURGERY}`]: 'Beyin Cerrahı',
			[`doctors_${DoctorSpecialty.NEUROSURGERY}`]: 'Beyin Cerrahları',

			[`doctor_${DoctorSpecialty.ONCOLOGY}`]: 'Onkolog',
			[`doctors_${DoctorSpecialty.ONCOLOGY}`]: 'Onkologlar',

			[`doctor_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Acil Tıp Doktoru',
			[`doctors_${DoctorSpecialty.EMERGENCY_MEDICINE}`]: 'Acil Tıp Doktorları',

			[`doctor_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Göğüs Cerrahı',
			[`doctors_${DoctorSpecialty.THORACIC_SURGERY}`]: 'Göğüs Cerrahları',

			[`doctor_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]: 'İş Sağlığı Doktoru',
			[`doctors_${DoctorSpecialty.OCCUPATIONAL_MEDICINE}`]:
				'İş Sağlığı Doktorları',

			[`doctor_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psikoterapist',
			[`doctors_${DoctorSpecialty.PSYCHOTHERAPY}`]: 'Psikoterapistler',

			[`doctor_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Enfeksiyon Hastalıkları Doktoru',
			[`doctors_${DoctorSpecialty.INFECTIOUS_DISEASES}`]:
				'Enfeksiyon Hastalıkları Doktorları',

			[`doctor_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatolog',
			[`doctors_${DoctorSpecialty.NEONATOLOGY}`]: 'Neonatologlar',

			[`doctor_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Çocuk Göz Doktoru',
			[`doctors_${DoctorSpecialty.PEDIATRIC_OPHTHALMOLOGY}`]:
				'Çocuk Göz Doktorları',

			[`doctor_${DoctorSpecialty.SPEECH_THERAPY}`]: 'Dil ve Konuşma Terapisti',
			[`doctors_${DoctorSpecialty.SPEECH_THERAPY}`]:
				'Dil ve Konuşma Terapistleri',

			[`doctor_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinatalog',
			[`doctors_${DoctorSpecialty.PERINATOLOGY}`]: 'Perinataloglar',

			[`doctor_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Çocuk Plastik Cerrahı',
			[`doctors_${DoctorSpecialty.PEDIATRIC_PLASTIC_SURGERY}`]:
				'Çocuk Plastik Cerrahları',

			[`doctor_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fiziksel Tıp ve Rehabilitasyon Doktoru',
			[`doctors_${DoctorSpecialty.PHYSICAL_MEDICINE_REHABILITATION}`]:
				'Fiziksel Tıp ve Rehabilitasyon Doktorları',

			[`doctor_${DoctorSpecialty.ORAL_SURGERY}`]: 'Ağız Cerrahı',
			[`doctors_${DoctorSpecialty.ORAL_SURGERY}`]: 'Ağız Cerrahları',

			[`doctor_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamolog',
			[`doctors_${DoctorSpecialty.MAMMOLOGY}`]: 'Mamologlar',

			[`doctor_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkolojik Cerrah',
			[`doctors_${DoctorSpecialty.ONCOLOGIC_SURGERY}`]: 'Onkolojik Cerrahlar',

			[`doctor_${DoctorSpecialty.DENTISTRY}`]: 'Diş Hekimi',
			[`doctors_${DoctorSpecialty.DENTISTRY}`]: 'Diş Hekimleri',

			[`doctor_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allerji Uzmanı',
			[`doctors_${DoctorSpecialty.ALLERGOLOGY}`]: 'Allerji Uzmanları',

			[`doctor_${DoctorSpecialty.IMMUNOLOGY}`]: 'İmmünolog',
			[`doctors_${DoctorSpecialty.IMMUNOLOGY}`]: 'İmmünologlar',

			[`doctor_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Göz Cerrahı',
			[`doctors_${DoctorSpecialty.OPHTHALMIC_SURGERY}`]: 'Göz Cerrahları',

			[`doctor_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopat',
			[`doctors_${DoctorSpecialty.OSTEOPATHY}`]: 'Osteopatlar',

			[`doctor_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hiperbarik Tıp Doktoru',
			[`doctors_${DoctorSpecialty.HYPERBARIC_MEDICINE}`]:
				'Hiperbarik Tıp Doktorları',

			[`doctor_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Patolog',
			[`doctors_${DoctorSpecialty.PATHOLOGICAL_ANATOMY}`]: 'Patologlar',

			[`doctor_${DoctorSpecialty.PODIATRY}`]: 'Podiyatrist',
			[`doctors_${DoctorSpecialty.PODIATRY}`]: 'Podiyatristler',

			[`doctor_${DoctorSpecialty.TRICHOLOGY}`]: 'Trikolog',
			[`doctors_${DoctorSpecialty.TRICHOLOGY}`]: 'Trikologlar',

			[`doctor_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Çocuk Diş Hekimi',
			[`doctors_${DoctorSpecialty.PEDIATRIC_DENTISTRY}`]: 'Çocuk Diş Hekimleri',

			[`doctor_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nükleer Tıp Doktoru',
			[`doctors_${DoctorSpecialty.NUCLEAR_MEDICINE}`]: 'Nükleer Tıp Doktorları',

			[`doctor_${DoctorSpecialty.GENETICS}`]: 'Tıbbi Genetik Uzmanı',
			[`doctors_${DoctorSpecialty.GENETICS}`]: 'Tıbbi Genetik Uzmanları',

			[`doctor_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Cerrah',
			[`doctors_${DoctorSpecialty.GASTROINTESTINAL_SURGERY}`]:
				'Gastrointestinal Cerrahlar',

			[`doctor_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Çene ve Yüz Cerrahı',
			[`doctors_${DoctorSpecialty.MAXILLOFACIAL_SURGERY}`]:
				'Çene ve Yüz Cerrahları',

			[`doctor_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kalp Cerrahı',
			[`doctors_${DoctorSpecialty.CARDIAC_SURGERY}`]: 'Kalp Cerrahları',
		},
	},
};
