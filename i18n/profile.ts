/**
 * Profile Page Translations
 * Все тексты для страницы профиля пользователя
 */

export default {
	messages: {
		en: {
			// Headers and general
			profileTitle: 'User Profile',
			onMainPage: 'Home',
			adminPanel: 'Admin Panel',
			logout: 'Logout',
			administrator: 'Administrator',
			user: 'User',
			cancel: 'Cancel',
			save: 'Save',
			currentSession: 'Current',

			// Profile editing
			editName: 'Name',
			editEmail: 'Email',

			// OAuth accounts
			linkedAccounts: 'Linked Accounts',
			linkedAccountsDescription: 'Manage your login methods',
			connected: 'Connected',
			notConnected: 'Not connected',
			primary: 'Primary',
			unlink: 'Unlink',
			link: 'Link',
			setPrimary: 'Set as primary',

			// Profile details
			email: 'Email',
			firstName: 'First name',
			lastName: 'Last name',
			locale: 'Locale',
			username: 'Username',
			emailVerified: 'Email verified',
			telegramId: 'ID',

			// Confirm modals
			confirmUnlinkGoogle: 'Are you sure you want to unlink your Google account?',
			confirmUnlinkTelegram: 'Are you sure you want to unlink your Telegram account?',
			confirmDeleteSession: 'Are you sure you want to end this session?',
			confirmLogoutAll: 'Are you sure you want to logout from all other devices?',

			// Success messages
			accountUnlinked: 'Account unlinked successfully',
			primaryProviderUpdated: 'Primary profile updated',
			passwordChanged: 'Password changed successfully',
			sessionDeleted: 'Session ended',
			allSessionsDeleted: 'All other sessions ended',
			nameUpdated: 'Name updated successfully',
			emailChangeSent: 'Confirmation email sent to new address',

			// Error messages
			errorUnlinkAccount: 'Failed to unlink account',
			errorUpdatePriority: 'Error updating priority',
			errorChangePassword: 'Error changing password',
			errorDeleteSession: 'Failed to end session',
			errorLogoutAll: 'Failed to end sessions',
			errorUpdateName: 'Error updating name',
			errorRequestEmailChange: 'Error requesting email change',

			// Security
			security: 'Security',
			securityDescription: 'Manage password and active sessions',
			password: 'Password',
			changePassword: 'Change',
			setPassword: 'Set',
			changePasswordTitle: 'Change Password',
			setPasswordTitle: 'Set password for login',
			activeSessions: 'Active Sessions',
			activeDevicesCount: 'Total active devices',
			logoutAll: 'Logout all',
			currentSessionLabel: 'Current session',
			otherDevice: 'Other device',
			created: 'Created',
			expires: 'Expires',
			terminate: 'Terminate',

			// Password change form
			currentPassword: 'Current password',
			newPassword: 'New password',
			confirmPassword: 'Confirm password',
			currentPasswordPlaceholder: 'Enter current password',
			newPasswordPlaceholder: 'At least 8 characters, 1 number and 1 letter',
			confirmPasswordPlaceholder: 'Enter password again',
			allFieldsRequired: 'Fill in all fields',
			passwordsNotMatch: 'Passwords do not match',

			// Login history
			loginHistory: 'Login History',
			loginHistoryDescription: 'Recent logins to your account',
			showAll: 'Show all',
			loginHistoryEmpty: 'Login history is empty',
			loginVia: 'Login via',
			logins: 'logins',
			ipAddress: 'IP address',
			userAgent: 'User Agent',
			loginMethod: 'Login method',
			device: 'Device',

			// Devices
			unknownDevice: 'Unknown device',
			mobileDevice: '📱 Mobile device',
			tablet: '📱 Tablet',
			computer: '💻 Computer',

			// Login methods
			emailMethod: 'Email',
			googleMethod: 'Google',
			telegramMethod: 'Telegram',

			// Name editing
			editNameTitle: 'Edit Name',
			nameLabel: 'Name',
			namePlaceholder: 'Enter new name',
			nameEmpty: 'Name cannot be empty',

			// Email editing
			editEmailTitle: 'Change Email',
			emailChangeNote: 'A confirmation email will be sent to the new address. Email will change only after confirmation.',
			newEmailLabel: 'New email',
			newEmailPlaceholder: 'Enter new email',
			sendEmail: 'Send email',
			enterNewEmail: 'Enter new email',
		},

		ru: {
			// Заголовки и общее
			profileTitle: 'Профиль пользователя',
			onMainPage: 'На главную',
			adminPanel: 'Админ-панель',
			logout: 'Выйти',
			administrator: 'Администратор',
			user: 'Пользователь',
			cancel: 'Отмена',
			save: 'Сохранить',
			currentSession: 'Текущая',

			// Редактирование профиля
			editName: 'Имя',
			editEmail: 'Email',

			// OAuth аккаунты
			linkedAccounts: 'Привязанные аккаунты',
			linkedAccountsDescription: 'Управляйте способами входа в систему',
			connected: 'Подключен',
			notConnected: 'Не подключен',
			primary: 'Основной',
			unlink: 'Отвязать',
			link: 'Привязать',
			setPrimary: 'Сделать основным',

			// Детали профиля
			email: 'Email',
			firstName: 'Имя',
			lastName: 'Фамилия',
			locale: 'Локаль',
			username: 'Username',
			emailVerified: 'Email подтвержден',
			telegramId: 'ID',

			// Confirm модалки
			confirmUnlinkGoogle: 'Вы уверены, что хотите отвязать Google аккаунт?',
			confirmUnlinkTelegram: 'Вы уверены, что хотите отвязать Telegram аккаунт?',
			confirmDeleteSession: 'Вы уверены, что хотите завершить эту сессию?',
			confirmLogoutAll: 'Вы уверены, что хотите выйти из всех других устройств?',

			// Сообщения успеха
			accountUnlinked: 'Аккаунт успешно отвязан',
			primaryProviderUpdated: 'Приоритетный профиль обновлен',
			passwordChanged: 'Пароль успешно изменен',
			sessionDeleted: 'Сессия завершена',
			allSessionsDeleted: 'Все остальные сессии завершены',
			nameUpdated: 'Имя успешно обновлено',
			emailChangeSent: 'Письмо с подтверждением отправлено на новый email',

			// Сообщения ошибок
			errorUnlinkAccount: 'Не удалось отвязать аккаунт',
			errorUpdatePriority: 'Ошибка при обновлении приоритета',
			errorChangePassword: 'Ошибка при изменении пароля',
			errorDeleteSession: 'Не удалось завершить сессию',
			errorLogoutAll: 'Не удалось завершить сессии',
			errorUpdateName: 'Ошибка при обновлении имени',
			errorRequestEmailChange: 'Ошибка при запросе смены email',

			// Безопасность
			security: 'Безопасность',
			securityDescription: 'Управление паролем и активными сессиями',
			password: 'Пароль',
			changePassword: 'Изменить',
			setPassword: 'Установить',
			changePasswordTitle: 'Изменить пароль',
			setPasswordTitle: 'Установить пароль для входа',
			activeSessions: 'Активные сессии',
			activeDevicesCount: 'Всего активных устройств',
			logoutAll: 'Выйти из всех',
			currentSessionLabel: 'Текущая сессия',
			otherDevice: 'Другое устройство',
			created: 'Создана',
			expires: 'Истекает',
			terminate: 'Завершить',

			// Форма смены пароля
			currentPassword: 'Текущий пароль',
			newPassword: 'Новый пароль',
			confirmPassword: 'Повторите пароль',
			currentPasswordPlaceholder: 'Введите текущий пароль',
			newPasswordPlaceholder: 'Минимум 8 символов, 1 цифра и 1 буква',
			confirmPasswordPlaceholder: 'Введите пароль еще раз',
			allFieldsRequired: 'Заполните все поля',
			passwordsNotMatch: 'Пароли не совпадают',

			// История входов
			loginHistory: 'История входов',
			loginHistoryDescription: 'Последние входы в ваш аккаунт',
			showAll: 'Показать все',
			loginHistoryEmpty: 'История входов пуста',
			loginVia: 'Вход через',
			logins: 'входов',
			ipAddress: 'IP адрес',
			userAgent: 'User Agent',
			loginMethod: 'Метод входа',
			device: 'Устройство',

			// Устройства
			unknownDevice: 'Неизвестное устройство',
			mobileDevice: '📱 Мобильное устройство',
			tablet: '📱 Планшет',
			computer: '💻 Компьютер',

			// Методы входа
			emailMethod: 'Email',
			googleMethod: 'Google',
			telegramMethod: 'Telegram',

			// Редактирование имени
			editNameTitle: 'Изменить имя',
			nameLabel: 'Имя',
			namePlaceholder: 'Введите новое имя',
			nameEmpty: 'Имя не может быть пустым',

			// Редактирование email
			editEmailTitle: 'Изменить email',
			emailChangeNote: 'На новый email будет отправлено письмо с подтверждением. Email изменится только после подтверждения.',
			newEmailLabel: 'Новый email',
			newEmailPlaceholder: 'Введите новый email',
			sendEmail: 'Отправить письмо',
			enterNewEmail: 'Введите новый email',
		},

		sr: {
			// Naslovi i opšte
			profileTitle: 'Korisnički profil',
			onMainPage: 'Početna',
			adminPanel: 'Admin panel',
			logout: 'Odjava',
			administrator: 'Administrator',
			user: 'Korisnik',
			cancel: 'Otkaži',
			save: 'Sačuvaj',
			currentSession: 'Trenutna',

			// Uređivanje profila
			editName: 'Ime',
			editEmail: 'Email',

			// OAuth nalozi
			linkedAccounts: 'Povezani nalozi',
			linkedAccountsDescription: 'Upravljajte načinima prijavljivanja',
			connected: 'Povezano',
			notConnected: 'Nije povezano',
			primary: 'Primarni',
			unlink: 'Odvoji',
			link: 'Poveži',
			setPrimary: 'Postavi kao primarni',

			// Detalji profila
			email: 'Email',
			firstName: 'Ime',
			lastName: 'Prezime',
			locale: 'Jezik',
			username: 'Korisničko ime',
			emailVerified: 'Email potvrđen',
			telegramId: 'ID',

			// Potvrde u modalima
			confirmUnlinkGoogle: 'Da li ste sigurni da želite da odvojite Google nalog?',
			confirmUnlinkTelegram: 'Da li ste sigurni da želite da odvojite Telegram nalog?',
			confirmDeleteSession: 'Da li ste sigurni da želite da završite ovu sesiju?',
			confirmLogoutAll: 'Da li ste sigurni da želite da se odjavite sa svih drugih uređaja?',

			// Poruke o uspehu
			accountUnlinked: 'Nalog uspešno odvojen',
			primaryProviderUpdated: 'Primarni profil ažuriran',
			passwordChanged: 'Lozinka uspešno promenjena',
			sessionDeleted: 'Sesija završena',
			allSessionsDeleted: 'Sve ostale sesije završene',
			nameUpdated: 'Ime uspešno ažurirano',
			emailChangeSent: 'Email sa potvrdom poslat na novu adresu',

			// Poruke o greškama
			errorUnlinkAccount: 'Neuspešno odvajanje naloga',
			errorUpdatePriority: 'Greška pri ažuriranju prioriteta',
			errorChangePassword: 'Greška pri promeni lozinke',
			errorDeleteSession: 'Neuspešno završavanje sesije',
			errorLogoutAll: 'Neuspešno završavanje sesija',
			errorUpdateName: 'Greška pri ažuriranju imena',
			errorRequestEmailChange: 'Greška pri zahtevanju promene email-a',

			// Bezbednost
			security: 'Bezbednost',
			securityDescription: 'Upravljanje lozinkom i aktivnim sesijama',
			password: 'Lozinka',
			changePassword: 'Promeni',
			setPassword: 'Postavi',
			changePasswordTitle: 'Promena lozinke',
			setPasswordTitle: 'Postavite lozinku za prijavu',
			activeSessions: 'Aktivne sesije',
			activeDevicesCount: 'Ukupno aktivnih uređaja',
			logoutAll: 'Odjavi sve',
			currentSessionLabel: 'Trenutna sesija',
			otherDevice: 'Drugi uređaj',
			created: 'Kreirana',
			expires: 'Ističe',
			terminate: 'Završi',

			// Forma za promenu lozinke
			currentPassword: 'Trenutna lozinka',
			newPassword: 'Nova lozinka',
			confirmPassword: 'Potvrdite lozinku',
			currentPasswordPlaceholder: 'Unesite trenutnu lozinku',
			newPasswordPlaceholder: 'Najmanje 8 karaktera, 1 broj i 1 slovo',
			confirmPasswordPlaceholder: 'Unesite lozinku ponovo',
			allFieldsRequired: 'Popunite sva polja',
			passwordsNotMatch: 'Lozinke se ne poklapaju',

			// Istorija prijavljivanja
			loginHistory: 'Istorija prijavljivanja',
			loginHistoryDescription: 'Nedavne prijave na vaš nalog',
			showAll: 'Prikaži sve',
			loginHistoryEmpty: 'Istorija prijavljivanja je prazna',
			loginVia: 'Prijava preko',
			logins: 'prijava',
			ipAddress: 'IP adresa',
			userAgent: 'User Agent',
			loginMethod: 'Metod prijavljivanja',
			device: 'Uređaj',

			// Uređaji
			unknownDevice: 'Nepoznat uređaj',
			mobileDevice: '📱 Mobilni uređaj',
			tablet: '📱 Tablet',
			computer: '💻 Računar',

			// Metodi prijavljivanja
			emailMethod: 'Email',
			googleMethod: 'Google',
			telegramMethod: 'Telegram',

			// Uređivanje imena
			editNameTitle: 'Izmeni ime',
			nameLabel: 'Ime',
			namePlaceholder: 'Unesite novo ime',
			nameEmpty: 'Ime ne može biti prazno',

			// Uređivanje email-a
			editEmailTitle: 'Izmeni email',
			emailChangeNote: 'Email sa potvrdom će biti poslat na novu adresu. Email će se promeniti samo nakon potvrde.',
			newEmailLabel: 'Novi email',
			newEmailPlaceholder: 'Unesite novi email',
			sendEmail: 'Pošalji email',
			enterNewEmail: 'Unesite novi email',
		},

		de: {
			// Überschriften und Allgemeines
			profileTitle: 'Benutzerprofil',
			onMainPage: 'Startseite',
			adminPanel: 'Admin-Panel',
			logout: 'Abmelden',
			administrator: 'Administrator',
			user: 'Benutzer',
			cancel: 'Abbrechen',
			save: 'Speichern',
			currentSession: 'Aktuell',

			// Profil bearbeiten
			editName: 'Name',
			editEmail: 'E-Mail',

			// OAuth-Konten
			linkedAccounts: 'Verknüpfte Konten',
			linkedAccountsDescription: 'Verwalten Sie Ihre Anmeldemethoden',
			connected: 'Verbunden',
			notConnected: 'Nicht verbunden',
			primary: 'Primär',
			unlink: 'Trennen',
			link: 'Verknüpfen',
			setPrimary: 'Als primär festlegen',

			// Profildetails
			email: 'E-Mail',
			firstName: 'Vorname',
			lastName: 'Nachname',
			locale: 'Sprache',
			username: 'Benutzername',
			emailVerified: 'E-Mail bestätigt',
			telegramId: 'ID',

			// Bestätigungsmodale
			confirmUnlinkGoogle: 'Möchten Sie Ihr Google-Konto wirklich trennen?',
			confirmUnlinkTelegram: 'Möchten Sie Ihr Telegram-Konto wirklich trennen?',
			confirmDeleteSession: 'Möchten Sie diese Sitzung wirklich beenden?',
			confirmLogoutAll: 'Möchten Sie sich wirklich von allen anderen Geräten abmelden?',

			// Erfolgsmeldungen
			accountUnlinked: 'Konto erfolgreich getrennt',
			primaryProviderUpdated: 'Primäres Profil aktualisiert',
			passwordChanged: 'Passwort erfolgreich geändert',
			sessionDeleted: 'Sitzung beendet',
			allSessionsDeleted: 'Alle anderen Sitzungen beendet',
			nameUpdated: 'Name erfolgreich aktualisiert',
			emailChangeSent: 'Bestätigungs-E-Mail an neue Adresse gesendet',

			// Fehlermeldungen
			errorUnlinkAccount: 'Konto konnte nicht getrennt werden',
			errorUpdatePriority: 'Fehler beim Aktualisieren der Priorität',
			errorChangePassword: 'Fehler beim Ändern des Passworts',
			errorDeleteSession: 'Sitzung konnte nicht beendet werden',
			errorLogoutAll: 'Sitzungen konnten nicht beendet werden',
			errorUpdateName: 'Fehler beim Aktualisieren des Namens',
			errorRequestEmailChange: 'Fehler bei der Anforderung der E-Mail-Änderung',

			// Sicherheit
			security: 'Sicherheit',
			securityDescription: 'Passwort und aktive Sitzungen verwalten',
			password: 'Passwort',
			changePassword: 'Ändern',
			setPassword: 'Festlegen',
			changePasswordTitle: 'Passwort ändern',
			setPasswordTitle: 'Passwort für die Anmeldung festlegen',
			activeSessions: 'Aktive Sitzungen',
			activeDevicesCount: 'Gesamt aktive Geräte',
			logoutAll: 'Alle abmelden',
			currentSessionLabel: 'Aktuelle Sitzung',
			otherDevice: 'Anderes Gerät',
			created: 'Erstellt',
			expires: 'Läuft ab',
			terminate: 'Beenden',

			// Passwortänderungsformular
			currentPassword: 'Aktuelles Passwort',
			newPassword: 'Neues Passwort',
			confirmPassword: 'Passwort bestätigen',
			currentPasswordPlaceholder: 'Aktuelles Passwort eingeben',
			newPasswordPlaceholder: 'Mindestens 8 Zeichen, 1 Zahl und 1 Buchstabe',
			confirmPasswordPlaceholder: 'Passwort erneut eingeben',
			allFieldsRequired: 'Alle Felder ausfüllen',
			passwordsNotMatch: 'Passwörter stimmen nicht überein',

			// Anmeldeverlauf
			loginHistory: 'Anmeldeverlauf',
			loginHistoryDescription: 'Letzte Anmeldungen in Ihrem Konto',
			showAll: 'Alle anzeigen',
			loginHistoryEmpty: 'Anmeldeverlauf ist leer',
			loginVia: 'Anmeldung über',
			logins: 'Anmeldungen',
			ipAddress: 'IP-Adresse',
			userAgent: 'User Agent',
			loginMethod: 'Anmeldemethode',
			device: 'Gerät',

			// Geräte
			unknownDevice: 'Unbekanntes Gerät',
			mobileDevice: '📱 Mobilgerät',
			tablet: '📱 Tablet',
			computer: '💻 Computer',

			// Anmeldemethoden
			emailMethod: 'E-Mail',
			googleMethod: 'Google',
			telegramMethod: 'Telegram',

			// Namen bearbeiten
			editNameTitle: 'Name bearbeiten',
			nameLabel: 'Name',
			namePlaceholder: 'Neuen Namen eingeben',
			nameEmpty: 'Name darf nicht leer sein',

			// E-Mail bearbeiten
			editEmailTitle: 'E-Mail ändern',
			emailChangeNote: 'Eine Bestätigungs-E-Mail wird an die neue Adresse gesendet. Die E-Mail wird erst nach Bestätigung geändert.',
			newEmailLabel: 'Neue E-Mail',
			newEmailPlaceholder: 'Neue E-Mail eingeben',
			sendEmail: 'E-Mail senden',
			enterNewEmail: 'Neue E-Mail eingeben',
		},

		tr: {
			// Başlıklar ve genel
			profileTitle: 'Kullanıcı Profili',
			onMainPage: 'Ana Sayfa',
			adminPanel: 'Yönetici Paneli',
			logout: 'Çıkış Yap',
			administrator: 'Yönetici',
			user: 'Kullanıcı',
			cancel: 'İptal',
			save: 'Kaydet',
			currentSession: 'Mevcut',

			// Profil düzenleme
			editName: 'İsim',
			editEmail: 'E-posta',

			// OAuth hesapları
			linkedAccounts: 'Bağlı Hesaplar',
			linkedAccountsDescription: 'Giriş yöntemlerinizi yönetin',
			connected: 'Bağlı',
			notConnected: 'Bağlı değil',
			primary: 'Birincil',
			unlink: 'Bağlantıyı Kes',
			link: 'Bağla',
			setPrimary: 'Birincil olarak ayarla',

			// Profil detayları
			email: 'E-posta',
			firstName: 'Ad',
			lastName: 'Soyad',
			locale: 'Dil',
			username: 'Kullanıcı adı',
			emailVerified: 'E-posta doğrulandı',
			telegramId: 'ID',

			// Onay modalları
			confirmUnlinkGoogle: 'Google hesabınızın bağlantısını kesmek istediğinizden emin misiniz?',
			confirmUnlinkTelegram: 'Telegram hesabınızın bağlantısını kesmek istediğinizden emin misiniz?',
			confirmDeleteSession: 'Bu oturumu sonlandırmak istediğinizden emin misiniz?',
			confirmLogoutAll: 'Diğer tüm cihazlardan çıkış yapmak istediğinizden emin misiniz?',

			// Başarı mesajları
			accountUnlinked: 'Hesap bağlantısı başarıyla kesildi',
			primaryProviderUpdated: 'Birincil profil güncellendi',
			passwordChanged: 'Şifre başarıyla değiştirildi',
			sessionDeleted: 'Oturum sonlandırıldı',
			allSessionsDeleted: 'Diğer tüm oturumlar sonlandırıldı',
			nameUpdated: 'İsim başarıyla güncellendi',
			emailChangeSent: 'Yeni adrese onay e-postası gönderildi',

			// Hata mesajları
			errorUnlinkAccount: 'Hesap bağlantısı kesilemedi',
			errorUpdatePriority: 'Öncelik güncellenirken hata oluştu',
			errorChangePassword: 'Şifre değiştirilirken hata oluştu',
			errorDeleteSession: 'Oturum sonlandırılamadı',
			errorLogoutAll: 'Oturumlar sonlandırılamadı',
			errorUpdateName: 'İsim güncellenirken hata oluştu',
			errorRequestEmailChange: 'E-posta değişikliği istenirken hata oluştu',

			// Güvenlik
			security: 'Güvenlik',
			securityDescription: 'Şifre ve aktif oturumları yönet',
			password: 'Şifre',
			changePassword: 'Değiştir',
			setPassword: 'Ayarla',
			changePasswordTitle: 'Şifre Değiştir',
			setPasswordTitle: 'Giriş için şifre ayarla',
			activeSessions: 'Aktif Oturumlar',
			activeDevicesCount: 'Toplam aktif cihaz',
			logoutAll: 'Tümünü çıkış yap',
			currentSessionLabel: 'Mevcut oturum',
			otherDevice: 'Diğer cihaz',
			created: 'Oluşturuldu',
			expires: 'Sona eriyor',
			terminate: 'Sonlandır',

			// Şifre değiştirme formu
			currentPassword: 'Mevcut şifre',
			newPassword: 'Yeni şifre',
			confirmPassword: 'Şifreyi onayla',
			currentPasswordPlaceholder: 'Mevcut şifrenizi girin',
			newPasswordPlaceholder: 'En az 8 karakter, 1 sayı ve 1 harf',
			confirmPasswordPlaceholder: 'Şifreyi tekrar girin',
			allFieldsRequired: 'Tüm alanları doldurun',
			passwordsNotMatch: 'Şifreler eşleşmiyor',

			// Giriş geçmişi
			loginHistory: 'Giriş Geçmişi',
			loginHistoryDescription: 'Hesabınıza son girişler',
			showAll: 'Tümünü göster',
			loginHistoryEmpty: 'Giriş geçmişi boş',
			loginVia: 'Giriş yöntemi',
			logins: 'giriş',
			ipAddress: 'IP adresi',
			userAgent: 'User Agent',
			loginMethod: 'Giriş yöntemi',
			device: 'Cihaz',

			// Cihazlar
			unknownDevice: 'Bilinmeyen cihaz',
			mobileDevice: '📱 Mobil cihaz',
			tablet: '📱 Tablet',
			computer: '💻 Bilgisayar',

			// Giriş yöntemleri
			emailMethod: 'E-posta',
			googleMethod: 'Google',
			telegramMethod: 'Telegram',

			// İsim düzenleme
			editNameTitle: 'İsmi Düzenle',
			nameLabel: 'İsim',
			namePlaceholder: 'Yeni isim girin',
			nameEmpty: 'İsim boş olamaz',

			// E-posta düzenleme
			editEmailTitle: 'E-postayı Değiştir',
			emailChangeNote: 'Yeni adrese bir onay e-postası gönderilecektir. E-posta sadece onaydan sonra değişecektir.',
			newEmailLabel: 'Yeni e-posta',
			newEmailPlaceholder: 'Yeni e-posta girin',
			sendEmail: 'E-posta gönder',
			enterNewEmail: 'Yeni e-posta girin',
		},

		'sr-cyrl': {
			// Наслови и опште
			profileTitle: 'Кориснички профил',
			onMainPage: 'Почетна',
			adminPanel: 'Админ панел',
			logout: 'Одјава',
			administrator: 'Администратор',
			user: 'Корисник',
			cancel: 'Откажи',
			save: 'Сачувај',
			currentSession: 'Тренутна',

			// Уређивање профила
			editName: 'Име',
			editEmail: 'Емаил',

			// OAuth налози
			linkedAccounts: 'Повезани налози',
			linkedAccountsDescription: 'Управљајте начинима пријављивања',
			connected: 'Повезано',
			notConnected: 'Није повезано',
			primary: 'Примарни',
			unlink: 'Одвоји',
			link: 'Повежи',
			setPrimary: 'Постави као примарни',

			// Детаљи профила
			email: 'Емаил',
			firstName: 'Име',
			lastName: 'Презиме',
			locale: 'Језик',
			username: 'Корисничко име',
			emailVerified: 'Емаил потврђен',
			telegramId: 'ИД',

			// Потврде у модалима
			confirmUnlinkGoogle: 'Да ли сте сигурни да желите да одвојите Гоогле налог?',
			confirmUnlinkTelegram: 'Да ли сте сигурни да желите да одвојите Телеграм налог?',
			confirmDeleteSession: 'Да ли сте сигурни да желите да завршите ову сесију?',
			confirmLogoutAll: 'Да ли сте сигурни да желите да се одјавите са свих других уређаја?',

			// Поруке о успеху
			accountUnlinked: 'Налог успешно одвојен',
			primaryProviderUpdated: 'Примарни профил ажуриран',
			passwordChanged: 'Лозинка успешно промењена',
			sessionDeleted: 'Сесија завршена',
			allSessionsDeleted: 'Све остале сесије завршене',
			nameUpdated: 'Име успешно ажурирано',
			emailChangeSent: 'Емаил са потврдом послат на нову адресу',

			// Поруке о грешкама
			errorUnlinkAccount: 'Неуспешно одвајање налога',
			errorUpdatePriority: 'Грешка при ажурирању приоритета',
			errorChangePassword: 'Грешка при промени лозинке',
			errorDeleteSession: 'Неуспешно завршавање сесије',
			errorLogoutAll: 'Неуспешно завршавање сесија',
			errorUpdateName: 'Грешка при ажурирању имена',
			errorRequestEmailChange: 'Грешка при захтевању промене емаила',

			// Безбедност
			security: 'Безбедност',
			securityDescription: 'Управљање лозинком и активним сесијама',
			password: 'Лозинка',
			changePassword: 'Промени',
			setPassword: 'Постави',
			changePasswordTitle: 'Промена лозинке',
			setPasswordTitle: 'Поставите лозинку за пријаву',
			activeSessions: 'Активне сесије',
			activeDevicesCount: 'Укупно активних уређаја',
			logoutAll: 'Одјави све',
			currentSessionLabel: 'Тренутна сесија',
			otherDevice: 'Други уређај',
			created: 'Креирана',
			expires: 'Истиче',
			terminate: 'Заврши',

			// Форма за промену лозинке
			currentPassword: 'Тренутна лозинка',
			newPassword: 'Нова лозинка',
			confirmPassword: 'Потврдите лозинку',
			currentPasswordPlaceholder: 'Унесите тренутну лозинку',
			newPasswordPlaceholder: 'Најмање 8 карактера, 1 број и 1 слово',
			confirmPasswordPlaceholder: 'Унесите лозинку поново',
			allFieldsRequired: 'Попуните сва поља',
			passwordsNotMatch: 'Лозинке се не поклапају',

			// Историја пријављивања
			loginHistory: 'Историја пријављивања',
			loginHistoryDescription: 'Недавне пријаве на ваш налог',
			showAll: 'Прикажи све',
			loginHistoryEmpty: 'Историја пријављивања је празна',
			loginVia: 'Пријава преко',
			logins: 'пријава',
			ipAddress: 'ИП адреса',
			userAgent: 'Усер Агент',
			loginMethod: 'Метод пријављивања',
			device: 'Уређај',

			// Уређаји
			unknownDevice: 'Непознат уређај',
			mobileDevice: '📱 Мобилни уређај',
			tablet: '📱 Таблет',
			computer: '💻 Рачунар',

			// Методи пријављивања
			emailMethod: 'Емаил',
			googleMethod: 'Гоогле',
			telegramMethod: 'Телеграм',

			// Уређивање имена
			editNameTitle: 'Измени име',
			nameLabel: 'Име',
			namePlaceholder: 'Унесите ново име',
			nameEmpty: 'Име не може бити празно',

			// Уређивање емаила
			editEmailTitle: 'Измени емаил',
			emailChangeNote: 'Емаил са потврдом ће бити послат на нову адресу. Емаил ће се променити само након потврде.',
			newEmailLabel: 'Нови емаил',
			newEmailPlaceholder: 'Унесите нови емаил',
			sendEmail: 'Пошаљи емаил',
			enterNewEmail: 'Унесите нови емаил',
		},
	},
};
