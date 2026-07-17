export default {
	messages: {
		'en': {
			MyClinics: 'My Clinics',
			AddClinic: 'Add clinic',
			NoClinics: "You don't have any clinics yet",
			NoClinicsDesc:
				'Create a clinic page: add the address, contacts, working hours and services. After publishing, patients will find it in search.',
			CreateFirstClinic: 'Create clinic',

			StatusDraft: 'Draft',
			StatusDraftDesc:
				'The clinic is not published. Only you can see its page. Fill in the details and publish it.',
			StatusPublished: 'Published',
			StatusPublishedDesc:
				'The clinic is visible to patients in search and on the clinic page.',
			StatusPendingVerification: 'Under review',
			StatusPendingVerificationDesc:
				'The clinic is being reviewed by the administrator. It will be visible to patients after approval.',
			StatusRejected: 'Rejected',
			StatusRejectedDesc:
				'Publication was rejected by the administrator. Edit the details and publish again.',

			BtnPublish: 'Publish',
			BtnHide: 'Hide',
			BtnView: 'View page',
			BtnEdit: 'Edit',
			ConfirmPublish:
				'Publish the clinic? It will appear in search and become visible to patients.',
			ConfirmHide:
				"Hide the clinic? Patients won't be able to find it, the page will return 404.",
			StatusUpdated: 'Clinic status updated',
			ErrorUpdatingStatus: 'Failed to update status',
			ErrorClinicIncomplete:
				'Fill in the name, address and pick a point on the map before publishing',

			CreateClinicTitle: 'New clinic',
			EditClinicTitle: 'Edit clinic',
			BtnSave: 'Save changes',
			BtnCreate: 'Create clinic',
			BtnCancel: 'Cancel',
			ClinicCreated: 'Clinic created as a draft',
			ClinicSaved: 'Clinic updated',
			ErrorSaving: 'Failed to save changes',

			SectionMain: 'Basic information',
			FieldName: 'Name',
			FieldClinicTypes: 'Clinic type',
			FieldClinicTypesPlaceholder: 'Select types',
			FieldCity: 'City',
			FieldCityPlaceholder: 'Select city',
			FieldAddress: 'Address',
			FieldTown: 'Town / district',
			FieldPostalCode: 'Postal code',

			SectionLogo: 'Logo',
			ChangeLogo: 'Change logo',
			RemoveLogo: 'Remove logo',
			LogoUpdated: 'Logo uploaded',

			SectionLocation: 'Location on the map',
			MapPickerHint: 'Click on the map to set the clinic location',
			CoordinatesSet: 'Point: {lat}, {lng}',
			CoordinatesNotSet: 'Point not set',
			ClearPoint: 'Clear point',

			SectionContacts: 'Contacts',
			FieldPhone: 'Phone',
			FieldEmail: 'Email',
			FieldWebsite: 'Website',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Assistance languages',
			FieldLanguagesPlaceholder: 'Select languages',

			SectionWorkingHours: 'Working hours',
			SectionDescription: 'Description',
			MarkdownHint: 'Use the toolbar buttons to format text',

			ValidationNameRequired: 'Name (SR) is required',
			ValidationCityRequired: 'Select a city',
			ValidationLanguagesRequired: 'Select at least one language',
			ValidationAddressRequired: 'Address (SR) is required',
			ValidationPostalCodeRequired: 'Postal code is required',
			ValidationContactRequired: 'Add at least one contact',
			ContactsRequiredHint: 'at least one is required',

			OwnerBanner: 'This is your clinic',
			OwnerBannerManage: 'Manage',
			DraftNotice:
				'The clinic is not published — only you can see this page.',
		},
		'ru': {
			MyClinics: 'Мои клиники',
			AddClinic: 'Добавить клинику',
			NoClinics: 'У вас пока нет клиник',
			NoClinicsDesc:
				'Создайте страницу клиники: добавьте адрес, контакты, график работы и услуги. После публикации пациенты найдут её в поиске.',
			CreateFirstClinic: 'Создать клинику',

			StatusDraft: 'Черновик',
			StatusDraftDesc:
				'Клиника не опубликована. Её страницу видите только вы. Заполните данные и опубликуйте.',
			StatusPublished: 'Опубликована',
			StatusPublishedDesc:
				'Клиника видна пациентам в поиске и на странице клиники.',
			StatusPendingVerification: 'На проверке',
			StatusPendingVerificationDesc:
				'Клинику проверяет администратор. После подтверждения она станет видна пациентам.',
			StatusRejected: 'Отклонена',
			StatusRejectedDesc:
				'Публикация отклонена администратором. Отредактируйте данные и опубликуйте снова.',

			BtnPublish: 'Опубликовать',
			BtnHide: 'Скрыть',
			BtnView: 'Открыть страницу',
			BtnEdit: 'Редактировать',
			ConfirmPublish:
				'Опубликовать клинику? Она появится в поиске и станет видна пациентам.',
			ConfirmHide:
				'Скрыть клинику? Пациенты не смогут её найти, страница будет отдавать 404.',
			StatusUpdated: 'Статус клиники обновлён',
			ErrorUpdatingStatus: 'Не удалось обновить статус',
			ErrorClinicIncomplete:
				'Перед публикацией заполните название, адрес и поставьте точку на карте',

			CreateClinicTitle: 'Новая клиника',
			EditClinicTitle: 'Редактирование клиники',
			BtnSave: 'Сохранить',
			BtnCreate: 'Создать клинику',
			BtnCancel: 'Отмена',
			ClinicCreated: 'Клиника создана как черновик',
			ClinicSaved: 'Клиника обновлена',
			ErrorSaving: 'Не удалось сохранить изменения',

			SectionMain: 'Основная информация',
			FieldName: 'Название',
			FieldClinicTypes: 'Тип клиники',
			FieldClinicTypesPlaceholder: 'Выберите типы',
			FieldCity: 'Город',
			FieldCityPlaceholder: 'Выберите город',
			FieldAddress: 'Адрес',
			FieldTown: 'Район / населённый пункт',
			FieldPostalCode: 'Почтовый индекс',

			SectionLogo: 'Логотип',
			ChangeLogo: 'Изменить логотип',
			RemoveLogo: 'Удалить логотип',
			LogoUpdated: 'Логотип загружен',

			SectionLocation: 'Расположение на карте',
			MapPickerHint: 'Кликните по карте, чтобы указать расположение клиники',
			CoordinatesSet: 'Точка: {lat}, {lng}',
			CoordinatesNotSet: 'Точка не указана',
			ClearPoint: 'Убрать точку',

			SectionContacts: 'Контакты',
			FieldPhone: 'Телефон',
			FieldEmail: 'Email',
			FieldWebsite: 'Сайт',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Языки сопровождения',
			FieldLanguagesPlaceholder: 'Выберите языки',

			SectionWorkingHours: 'График работы',
			SectionDescription: 'Описание',
			MarkdownHint: 'Используйте панель кнопок для форматирования текста',

			ValidationNameRequired: 'Название (SR) обязательно',
			ValidationCityRequired: 'Выберите город',
			ValidationLanguagesRequired: 'Выберите хотя бы один язык',
			ValidationAddressRequired: 'Адрес (SR) обязателен',
			ValidationPostalCodeRequired: 'Почтовый индекс обязателен',
			ValidationContactRequired: 'Укажите хотя бы один контакт',
			ContactsRequiredHint: 'минимум один — обязателен',

			OwnerBanner: 'Это ваша клиника',
			OwnerBannerManage: 'Управление',
			DraftNotice:
				'Клиника не опубликована — эту страницу видите только вы.',
		},
		'sr': {
			MyClinics: 'Moje klinike',
			AddClinic: 'Dodaj kliniku',
			NoClinics: 'Još nemate nijednu kliniku',
			NoClinicsDesc:
				'Kreirajte stranicu klinike: dodajte adresu, kontakte, radno vrijeme i usluge. Nakon objavljivanja pacijenti će je pronaći u pretrazi.',
			CreateFirstClinic: 'Kreiraj kliniku',

			StatusDraft: 'Nacrt',
			StatusDraftDesc:
				'Klinika nije objavljena. Njenu stranicu vidite samo vi. Popunite podatke i objavite je.',
			StatusPublished: 'Objavljena',
			StatusPublishedDesc:
				'Klinika je vidljiva pacijentima u pretrazi i na stranici klinike.',
			StatusPendingVerification: 'Na provjeri',
			StatusPendingVerificationDesc:
				'Kliniku pregleda administrator. Nakon odobrenja biće vidljiva pacijentima.',
			StatusRejected: 'Odbijena',
			StatusRejectedDesc:
				'Objavljivanje je odbio administrator. Izmijenite podatke i objavite ponovo.',

			BtnPublish: 'Objavi',
			BtnHide: 'Sakrij',
			BtnView: 'Otvori stranicu',
			BtnEdit: 'Izmijeni',
			ConfirmPublish:
				'Objaviti kliniku? Pojaviće se u pretrazi i biće vidljiva pacijentima.',
			ConfirmHide:
				'Sakriti kliniku? Pacijenti je neće moći pronaći, stranica će vraćati 404.',
			StatusUpdated: 'Status klinike ažuriran',
			ErrorUpdatingStatus: 'Nije uspjelo ažuriranje statusa',
			ErrorClinicIncomplete:
				'Prije objavljivanja popunite naziv, adresu i postavite tačku na mapi',

			CreateClinicTitle: 'Nova klinika',
			EditClinicTitle: 'Izmjena klinike',
			BtnSave: 'Sačuvaj',
			BtnCreate: 'Kreiraj kliniku',
			BtnCancel: 'Otkaži',
			ClinicCreated: 'Klinika je kreirana kao nacrt',
			ClinicSaved: 'Klinika ažurirana',
			ErrorSaving: 'Nije uspjelo čuvanje promjena',

			SectionMain: 'Osnovne informacije',
			FieldName: 'Naziv',
			FieldClinicTypes: 'Tip klinike',
			FieldClinicTypesPlaceholder: 'Izaberite tipove',
			FieldCity: 'Grad',
			FieldCityPlaceholder: 'Izaberite grad',
			FieldAddress: 'Adresa',
			FieldTown: 'Naselje / dio grada',
			FieldPostalCode: 'Poštanski broj',

			SectionLogo: 'Logotip',
			ChangeLogo: 'Promijeni logotip',
			RemoveLogo: 'Ukloni logotip',
			LogoUpdated: 'Logotip otpremljen',

			SectionLocation: 'Lokacija na mapi',
			MapPickerHint: 'Kliknite na mapu da označite lokaciju klinike',
			CoordinatesSet: 'Tačka: {lat}, {lng}',
			CoordinatesNotSet: 'Tačka nije postavljena',
			ClearPoint: 'Ukloni tačku',

			SectionContacts: 'Kontakti',
			FieldPhone: 'Telefon',
			FieldEmail: 'Email',
			FieldWebsite: 'Veb-sajt',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Jezici podrške',
			FieldLanguagesPlaceholder: 'Izaberite jezike',

			SectionWorkingHours: 'Radno vrijeme',
			SectionDescription: 'Opis',
			MarkdownHint: 'Koristite dugmad na traci za formatiranje teksta',

			ValidationNameRequired: 'Naziv (SR) je obavezan',
			ValidationCityRequired: 'Izaberite grad',
			ValidationLanguagesRequired: 'Izaberite najmanje jedan jezik',
			ValidationAddressRequired: 'Adresa (SR) je obavezna',
			ValidationPostalCodeRequired: 'Poštanski broj je obavezan',
			ValidationContactRequired: 'Navedite najmanje jedan kontakt',
			ContactsRequiredHint: 'najmanje jedan je obavezan',

			OwnerBanner: 'Ovo je vaša klinika',
			OwnerBannerManage: 'Upravljanje',
			DraftNotice:
				'Klinika nije objavljena — ovu stranicu vidite samo vi.',
		},
		'sr-cyrl': {
			MyClinics: 'Моје клинике',
			AddClinic: 'Додај клинику',
			NoClinics: 'Још немате ниједну клинику',
			NoClinicsDesc:
				'Креирајте страницу клинике: додајте адресу, контакте, радно вријеме и услуге. Након објављивања пацијенти ће је пронаћи у претрази.',
			CreateFirstClinic: 'Креирај клинику',

			StatusDraft: 'Нацрт',
			StatusDraftDesc:
				'Клиника није објављена. Њену страницу видите само ви. Попуните податке и објавите је.',
			StatusPublished: 'Објављена',
			StatusPublishedDesc:
				'Клиника је видљива пацијентима у претрази и на страници клинике.',
			StatusPendingVerification: 'На провјери',
			StatusPendingVerificationDesc:
				'Клинику прегледа администратор. Након одобрења биће видљива пацијентима.',
			StatusRejected: 'Одбијена',
			StatusRejectedDesc:
				'Објављивање је одбио администратор. Измијените податке и објавите поново.',

			BtnPublish: 'Објави',
			BtnHide: 'Сакриј',
			BtnView: 'Отвори страницу',
			BtnEdit: 'Измијени',
			ConfirmPublish:
				'Објавити клинику? Појавиће се у претрази и биће видљива пацијентима.',
			ConfirmHide:
				'Сакрити клинику? Пацијенти је неће моћи пронаћи, страница ће враћати 404.',
			StatusUpdated: 'Статус клинике ажуриран',
			ErrorUpdatingStatus: 'Није успјело ажурирање статуса',
			ErrorClinicIncomplete:
				'Прије објављивања попуните назив, адресу и поставите тачку на мапи',

			CreateClinicTitle: 'Нова клиника',
			EditClinicTitle: 'Измјена клинике',
			BtnSave: 'Сачувај',
			BtnCreate: 'Креирај клинику',
			BtnCancel: 'Откажи',
			ClinicCreated: 'Клиника је креирана као нацрт',
			ClinicSaved: 'Клиника ажурирана',
			ErrorSaving: 'Није успјело чување промјена',

			SectionMain: 'Основне информације',
			FieldName: 'Назив',
			FieldClinicTypes: 'Тип клинике',
			FieldClinicTypesPlaceholder: 'Изаберите типове',
			FieldCity: 'Град',
			FieldCityPlaceholder: 'Изаберите град',
			FieldAddress: 'Адреса',
			FieldTown: 'Насеље / дио града',
			FieldPostalCode: 'Поштански број',

			SectionLogo: 'Логотип',
			ChangeLogo: 'Промијени логотип',
			RemoveLogo: 'Уклони логотип',
			LogoUpdated: 'Логотип отпремљен',

			SectionLocation: 'Локација на мапи',
			MapPickerHint: 'Кликните на мапу да означите локацију клинике',
			CoordinatesSet: 'Тачка: {lat}, {lng}',
			CoordinatesNotSet: 'Тачка није постављена',
			ClearPoint: 'Уклони тачку',

			SectionContacts: 'Контакти',
			FieldPhone: 'Телефон',
			FieldEmail: 'Email',
			FieldWebsite: 'Веб-сајт',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Језици подршке',
			FieldLanguagesPlaceholder: 'Изаберите језике',

			SectionWorkingHours: 'Радно вријеме',
			SectionDescription: 'Опис',
			MarkdownHint: 'Користите дугмад на траци за форматирање текста',

			ValidationNameRequired: 'Назив (SR) је обавезан',
			ValidationCityRequired: 'Изаберите град',
			ValidationLanguagesRequired: 'Изаберите најмање један језик',
			ValidationAddressRequired: 'Адреса (SR) је обавезна',
			ValidationPostalCodeRequired: 'Поштански број је обавезан',
			ValidationContactRequired: 'Наведите најмање један контакт',
			ContactsRequiredHint: 'најмање један је обавезан',

			OwnerBanner: 'Ово је ваша клиника',
			OwnerBannerManage: 'Управљање',
			DraftNotice:
				'Клиника није објављена — ову страницу видите само ви.',
		},
		'de': {
			MyClinics: 'Meine Kliniken',
			AddClinic: 'Klinik hinzufügen',
			NoClinics: 'Sie haben noch keine Kliniken',
			NoClinicsDesc:
				'Erstellen Sie eine Klinikseite: Adresse, Kontakte, Öffnungszeiten und Leistungen. Nach der Veröffentlichung finden Patienten sie in der Suche.',
			CreateFirstClinic: 'Klinik erstellen',

			StatusDraft: 'Entwurf',
			StatusDraftDesc:
				'Die Klinik ist nicht veröffentlicht. Nur Sie sehen ihre Seite. Füllen Sie die Daten aus und veröffentlichen Sie sie.',
			StatusPublished: 'Veröffentlicht',
			StatusPublishedDesc:
				'Die Klinik ist für Patienten in der Suche und auf der Klinikseite sichtbar.',
			StatusPendingVerification: 'In Prüfung',
			StatusPendingVerificationDesc:
				'Die Klinik wird vom Administrator überprüft. Nach der Genehmigung wird sie für Patienten sichtbar.',
			StatusRejected: 'Abgelehnt',
			StatusRejectedDesc:
				'Die Veröffentlichung wurde vom Administrator abgelehnt. Bearbeiten Sie die Daten und veröffentlichen Sie erneut.',

			BtnPublish: 'Veröffentlichen',
			BtnHide: 'Verstecken',
			BtnView: 'Seite öffnen',
			BtnEdit: 'Bearbeiten',
			ConfirmPublish:
				'Klinik veröffentlichen? Sie erscheint in der Suche und wird für Patienten sichtbar.',
			ConfirmHide:
				'Klinik verstecken? Patienten können sie nicht finden, die Seite gibt 404 zurück.',
			StatusUpdated: 'Klinikstatus aktualisiert',
			ErrorUpdatingStatus: 'Status konnte nicht aktualisiert werden',
			ErrorClinicIncomplete:
				'Füllen Sie vor der Veröffentlichung Name und Adresse aus und setzen Sie einen Punkt auf der Karte',

			CreateClinicTitle: 'Neue Klinik',
			EditClinicTitle: 'Klinik bearbeiten',
			BtnSave: 'Speichern',
			BtnCreate: 'Klinik erstellen',
			BtnCancel: 'Abbrechen',
			ClinicCreated: 'Klinik als Entwurf erstellt',
			ClinicSaved: 'Klinik aktualisiert',
			ErrorSaving: 'Änderungen konnten nicht gespeichert werden',

			SectionMain: 'Grundinformationen',
			FieldName: 'Name',
			FieldClinicTypes: 'Kliniktyp',
			FieldClinicTypesPlaceholder: 'Typen auswählen',
			FieldCity: 'Stadt',
			FieldCityPlaceholder: 'Stadt auswählen',
			FieldAddress: 'Adresse',
			FieldTown: 'Ort / Stadtteil',
			FieldPostalCode: 'Postleitzahl',

			SectionLogo: 'Logo',
			ChangeLogo: 'Logo ändern',
			RemoveLogo: 'Logo entfernen',
			LogoUpdated: 'Logo hochgeladen',

			SectionLocation: 'Standort auf der Karte',
			MapPickerHint:
				'Klicken Sie auf die Karte, um den Standort der Klinik festzulegen',
			CoordinatesSet: 'Punkt: {lat}, {lng}',
			CoordinatesNotSet: 'Punkt nicht gesetzt',
			ClearPoint: 'Punkt entfernen',

			SectionContacts: 'Kontakte',
			FieldPhone: 'Telefon',
			FieldEmail: 'E-Mail',
			FieldWebsite: 'Website',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Betreuungssprachen',
			FieldLanguagesPlaceholder: 'Sprachen auswählen',

			SectionWorkingHours: 'Öffnungszeiten',
			SectionDescription: 'Beschreibung',
			MarkdownHint:
				'Verwenden Sie die Symbolleiste zum Formatieren des Textes',

			ValidationNameRequired: 'Name (SR) ist erforderlich',
			ValidationCityRequired: 'Wählen Sie eine Stadt',
			ValidationLanguagesRequired: 'Wählen Sie mindestens eine Sprache',
			ValidationAddressRequired: 'Adresse (SR) ist erforderlich',
			ValidationPostalCodeRequired: 'Postleitzahl ist erforderlich',
			ValidationContactRequired: 'Geben Sie mindestens einen Kontakt an',
			ContactsRequiredHint: 'mindestens einer ist erforderlich',

			OwnerBanner: 'Dies ist Ihre Klinik',
			OwnerBannerManage: 'Verwalten',
			DraftNotice:
				'Die Klinik ist nicht veröffentlicht — nur Sie sehen diese Seite.',
		},
		'tr': {
			MyClinics: 'Kliniklerim',
			AddClinic: 'Klinik ekle',
			NoClinics: 'Henüz bir kliniğiniz yok',
			NoClinicsDesc:
				'Bir klinik sayfası oluşturun: adres, iletişim bilgileri, çalışma saatleri ve hizmetleri ekleyin. Yayınlandıktan sonra hastalar onu aramada bulacaktır.',
			CreateFirstClinic: 'Klinik oluştur',

			StatusDraft: 'Taslak',
			StatusDraftDesc:
				'Klinik yayınlanmadı. Sayfasını yalnızca siz görüyorsunuz. Bilgileri doldurun ve yayınlayın.',
			StatusPublished: 'Yayında',
			StatusPublishedDesc:
				'Klinik, arama sonuçlarında ve klinik sayfasında hastalar tarafından görülebilir.',
			StatusPendingVerification: 'İnceleniyor',
			StatusPendingVerificationDesc:
				'Klinik yönetici tarafından inceleniyor. Onaydan sonra hastalar tarafından görülebilecek.',
			StatusRejected: 'Reddedildi',
			StatusRejectedDesc:
				'Yayınlama yönetici tarafından reddedildi. Bilgileri düzenleyip tekrar yayınlayın.',

			BtnPublish: 'Yayınla',
			BtnHide: 'Gizle',
			BtnView: 'Sayfayı aç',
			BtnEdit: 'Düzenle',
			ConfirmPublish:
				'Klinik yayınlansın mı? Aramada görünecek ve hastalar tarafından görülebilecek.',
			ConfirmHide:
				'Klinik gizlensin mi? Hastalar onu bulamayacak, sayfa 404 döndürecek.',
			StatusUpdated: 'Klinik durumu güncellendi',
			ErrorUpdatingStatus: 'Durum güncellenemedi',
			ErrorClinicIncomplete:
				'Yayınlamadan önce adı, adresi doldurun ve haritada bir nokta seçin',

			CreateClinicTitle: 'Yeni klinik',
			EditClinicTitle: 'Kliniği düzenle',
			BtnSave: 'Kaydet',
			BtnCreate: 'Klinik oluştur',
			BtnCancel: 'İptal',
			ClinicCreated: 'Klinik taslak olarak oluşturuldu',
			ClinicSaved: 'Klinik güncellendi',
			ErrorSaving: 'Değişiklikler kaydedilemedi',

			SectionMain: 'Temel bilgiler',
			FieldName: 'Ad',
			FieldClinicTypes: 'Klinik türü',
			FieldClinicTypesPlaceholder: 'Türleri seçin',
			FieldCity: 'Şehir',
			FieldCityPlaceholder: 'Şehir seçin',
			FieldAddress: 'Adres',
			FieldTown: 'Semt / mahalle',
			FieldPostalCode: 'Posta kodu',

			SectionLogo: 'Logo',
			ChangeLogo: 'Logoyu değiştir',
			RemoveLogo: 'Logoyu kaldır',
			LogoUpdated: 'Logo yüklendi',

			SectionLocation: 'Haritadaki konum',
			MapPickerHint:
				'Kliniğin konumunu belirlemek için haritaya tıklayın',
			CoordinatesSet: 'Nokta: {lat}, {lng}',
			CoordinatesNotSet: 'Nokta belirlenmedi',
			ClearPoint: 'Noktayı kaldır',

			SectionContacts: 'İletişim',
			FieldPhone: 'Telefon',
			FieldEmail: 'E-posta',
			FieldWebsite: 'Web sitesi',
			FieldFacebook: 'Facebook',
			FieldInstagram: 'Instagram',
			FieldTelegram: 'Telegram',
			FieldWhatsapp: 'WhatsApp',
			FieldViber: 'Viber',

			FieldLanguages: 'Destek dilleri',
			FieldLanguagesPlaceholder: 'Dilleri seçin',

			SectionWorkingHours: 'Çalışma saatleri',
			SectionDescription: 'Açıklama',
			MarkdownHint:
				'Metni biçimlendirmek için araç çubuğu düğmelerini kullanın',

			ValidationNameRequired: 'Ad (SR) gereklidir',
			ValidationCityRequired: 'Bir şehir seçin',
			ValidationLanguagesRequired: 'En az bir dil seçin',
			ValidationAddressRequired: 'Adres (SR) zorunludur',
			ValidationPostalCodeRequired: 'Posta kodu zorunludur',
			ValidationContactRequired: 'En az bir iletişim bilgisi girin',
			ContactsRequiredHint: 'en az biri zorunludur',

			OwnerBanner: 'Bu sizin kliniğiniz',
			OwnerBannerManage: 'Yönet',
			DraftNotice:
				'Klinik yayınlanmadı — bu sayfayı yalnızca siz görüyorsunuz.',
		},
	},
};
