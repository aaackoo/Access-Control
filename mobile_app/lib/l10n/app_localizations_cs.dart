// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Potvrdit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get and => 'a';

  @override
  String get or => 'nebo';

  @override
  String get add => 'Přidat';

  @override
  String get close => 'Zavřít';

  @override
  String get delete => 'Smazat';

  @override
  String get remove => 'Odstranit';

  @override
  String get edit => 'Upravit';

  @override
  String get save => 'Uložit';

  @override
  String get create => 'Vytvořit';

  @override
  String get refresh => 'Obnovit';

  @override
  String get error => 'Chyba';

  @override
  String get loading => 'Načítám...';

  @override
  String get removing => 'Odstraňuji...';

  @override
  String get updating => 'Aktualizuji...';

  @override
  String get errorLoadingData => 'Chyba načítání dat';

  @override
  String get more => 'dalších';

  @override
  String get accessControl => 'Správa přístupů';

  @override
  String get welcome => 'Vítejte';

  @override
  String get yourAccessKeys => 'Vaše přístupové klíče';

  @override
  String get loadingKeys => 'Načítám klíče...';

  @override
  String totalAccessKeysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count klíčů',
      few: 'Celkem $count klíče',
      one: 'Celkem $count klíč',
    );
    return '$_temp0';
  }

  @override
  String get errorDuringLoadingKeys => 'Chyba při načítávání klíčů';

  @override
  String get companies => 'Společnosti';

  @override
  String get company => 'Společnost';

  @override
  String get buildings => 'Budovy';

  @override
  String get building => 'Budova';

  @override
  String get areas => 'Oblasti';

  @override
  String get area => 'Oblast';

  @override
  String get devices => 'Zařízení';

  @override
  String get device => 'Zařízení';

  @override
  String get role => 'Role';

  @override
  String get keys => 'Klíče';

  @override
  String get key => 'Klíč';

  @override
  String get id => 'ID';

  @override
  String get name => 'Název';

  @override
  String get state => 'Stav';

  @override
  String get type => 'Typ';

  @override
  String get door => 'Dveře';

  @override
  String get gate => 'Brána';

  @override
  String get turnstile => 'Turniket';

  @override
  String get ramp => 'Rampa';

  @override
  String get nfcScanPrompt => 'Přiložte iPhone k zařízení';

  @override
  String get scanningCompleted => 'Skenování dokončeno';

  @override
  String tagId(String tagId) {
    return 'Tag ID: $tagId';
  }

  @override
  String get unlockingSuccessful => 'Odemykání úspěšné!';

  @override
  String get unlockingFailed => 'Nemáte dostatečná oprávnění k odemknutí...';

  @override
  String get unlockingFailedReason =>
      'Pokud si myslíte, že se jedná o chybu, kontaktujte prosím administrátora.';

  @override
  String get tapToScanNfcCard => 'Klepnutím naskenujte čip';

  @override
  String get home => 'Domů';

  @override
  String get cards => 'Přístupové karty';

  @override
  String get accountsManagement => 'Správa účtů';

  @override
  String get accessesManagement => 'Správa přístupů';

  @override
  String get companyManagement => 'Správa společnosti';

  @override
  String get loginTitle => 'Přihlášení';

  @override
  String get loginSubtitle => 'Zadejte své přihlašovací údaje';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get passwordHint => 'Heslo';

  @override
  String get loginButton => 'Přihlásit se';

  @override
  String get enterCorrectEmail => 'Zadejte platnou e-mailovou adresu';

  @override
  String get emailIsMandatory => 'E-mail je povinný';

  @override
  String get enterCorrectPassword => 'Zadejte platné heslo';

  @override
  String get passwordIsMandatory => 'Heslo je povinné';

  @override
  String get accountRole => 'Role';

  @override
  String get companyOwner => 'Vlastník společnosti';

  @override
  String get manager => 'Manažer';

  @override
  String get user => 'Uživatel';

  @override
  String get demoAccountsTitle => 'Demo účty pro testování';

  @override
  String get notLoggedIn => 'Nejste přihlášen';

  @override
  String get myProfileTitle => 'Můj profil';

  @override
  String get createdAt => 'Vytvořeno dne';

  @override
  String get lastModified => 'Naposledy upraveno';

  @override
  String get accountNotFound => 'Účet nenalezen';

  @override
  String get errorDuringLoadingAccount => 'Chyba při načítání účtu';

  @override
  String accountRemovedSuccessfully(String accountEmail) {
    return 'Účet $accountEmail byl úspěšně odstraněn';
  }

  @override
  String get errorDuringRemovingAccount => 'Chyba při odstraňování účtu';

  @override
  String get removeAccount => 'Odstranit účet';

  @override
  String get removeAccountConfirmation =>
      'Opravdu chcete odstranit tento účet?';

  @override
  String get thisActionCannotBeUndone => 'Tuto akci nelze vrátit zpět.';

  @override
  String get accountInfo => 'Informace o účtu';

  @override
  String get accountId => 'ID účtu';

  @override
  String get email => 'E-mail';

  @override
  String get companyId => 'ID společnosti';

  @override
  String get companyInfoTitle => 'Informace o společnosti';

  @override
  String get noCompanyFound => 'Firma nenalezena';

  @override
  String get companyCreatedDate => 'Datum založení společnosti';

  @override
  String get companyStatisticsTitle => 'Statistiky společnosti';

  @override
  String get signOut => 'Odhlásit se';

  @override
  String get signOutContent => 'Opravdu se chcete odhlásit?';

  @override
  String get accessSearchPlaceholder => 'Hledat klíče, budovy, zařízení...';

  @override
  String get noKeys => 'Žádné klíče';

  @override
  String get noKeysDescription =>
      'Momentálně nemáte přístup k žádným klíčům.\nKontaktujte svého správce pro přidělení přístupu.';

  @override
  String get unlocks => 'Odemyká';

  @override
  String get keyInfoTitle => 'Informace o klíči';

  @override
  String get locationInfoTitle => 'Lokalita';

  @override
  String get noAccounts => 'Žádné účty';

  @override
  String get addAccountsUsingButtonBelow =>
      'Přidejte nový účet pomocí tlačítka níže';

  @override
  String get addAccount => 'Přidat účet';

  @override
  String get addAccountPasswordHint =>
      'Účet bude vytvořen bez hesla. Uživatel si ho musí nastavit při prvním přihlášení.';

  @override
  String get errorDuringAccountCreation => 'Chyba při vytváření účtu';

  @override
  String get accountCreatedSuccessfully => 'Účet byl úspěšně vytvořen';

  @override
  String get addKey => 'Přidat klíč';

  @override
  String get addKeysUsingButtonBelow => 'Přidejte první klíč pomocí tlačítka +';

  @override
  String get selectDevices => 'Vybrat zařízení';

  @override
  String get noDevicesForSelectedCompany =>
      'Žádná zařízení pro tuto společnost';

  @override
  String get addBuildingFirst => 'Nejprve přidejte budovu pro tuto společnost';

  @override
  String get selectBuilding => 'Vyberte budovu';

  @override
  String get errorNoCompanyId => 'Chyba: ID společnosti není k dispozici';

  @override
  String get editAccessKey => 'Upravit přístupový klíč';

  @override
  String get addNewAccessKey => 'Přidat nový přístupový klíč';

  @override
  String get accessKeyName => 'Název přístupového klíče';

  @override
  String get enterAccessKeyName => 'Zadejte název přístupového klíče';

  @override
  String get accessKeyNameRequired => 'Název přístupového klíče je povinný';

  @override
  String get accessKeyNameTooShort =>
      'Název přístupového klíče musí mít alespoň 2 znaky';

  @override
  String get accessibleDevices => 'Dostupná zařízení';

  @override
  String get editingAccessKey => 'Upravuji přístupový klíč...';

  @override
  String get addingAccessKey => 'Přidávám přístupový klíč...';

  @override
  String get addAccessKey => 'Přidat přístupový klíč';

  @override
  String get accessKeyUpdatedSuccessfully =>
      'Přístupový klíč byl úspěšně aktualizován';

  @override
  String get accessKeyAddedSuccessfully => 'Přístupový klíč byl úspěšně přidán';

  @override
  String get accessKeyUpdateFailed => 'Aktualizace přístupového klíče selhala';

  @override
  String get accessKeyAdditionFailed => 'Přidání přístupového klíče selhalo';

  @override
  String selectedCount(int count) {
    return 'Vybráno: $count';
  }

  @override
  String get addArea => 'Přidat oblast';

  @override
  String get addBuilding => 'Přidat budovu';

  @override
  String get addDevice => 'Přidat zařízení';

  @override
  String get companyInfo => 'Informace o společnosti';

  @override
  String get noOwners => 'Žádní vlastníci';

  @override
  String get noOwnersSubtitle =>
      'Pro přidání prvního vlastníka kontaktujte podporu';

  @override
  String get editCompany => 'Upravit společnost';

  @override
  String get companyName => 'Název společnosti';

  @override
  String get enterCompanyName => 'Zadejte název společnosti';

  @override
  String get companyNameRequired => 'Název společnosti je povinný';

  @override
  String get companyNameTooShort =>
      'Název společnosti musí mít alespoň 2 znaky';

  @override
  String get editingCompany => 'Upravuji společnost...';

  @override
  String get updatedCompanySuccessfully => 'Společnost byla úspěšně upravena';

  @override
  String get errorDuringUpdatingCompany => 'Chyba při aktualizaci společnosti';

  @override
  String get areaInfo => 'Informace o oblasti';

  @override
  String get editArea => 'Upravit oblast';

  @override
  String get areaName => 'Název oblasti';

  @override
  String get enterAreaName => 'Zadejte název oblasti';

  @override
  String get areaNameRequired => 'Název oblasti je povinný';

  @override
  String get areaNameTooShort => 'Název oblasti musí mít alespoň 2 znaky';

  @override
  String get location => 'Lokalita';

  @override
  String get enterLocation => 'Zadejte lokaci';

  @override
  String get locationRequired => 'Lokalita je povinná';

  @override
  String get locationTooShort => 'Lokalita musí mít alespoň 2 znaky';

  @override
  String get editingArea => 'Upravuji oblast...';

  @override
  String get addingArea => 'Přidávám oblast...';

  @override
  String get updatedAreaSuccessfully => 'Oblast byla úspěšně upravena';

  @override
  String get addedAreaSuccessfully => 'Oblast byla úspěšně přidána';

  @override
  String get errorDuringUpdatingArea => 'Chyba při aktualizaci oblasti';

  @override
  String get errorDuringAddingArea => 'Chyba při přidávání oblasti';

  @override
  String get noAreas => 'Žádné oblasti';

  @override
  String get companyHasNoAreas => 'Tato společnost nemá žádné oblasti';

  @override
  String get buildingInfo => 'Informace o budově';

  @override
  String get editBuilding => 'Upravit budovu';

  @override
  String get buildingName => 'Název budovy';

  @override
  String get enterBuildingName => 'Zadejte název budovy';

  @override
  String get buildingNameRequired => 'Název budovy je povinný';

  @override
  String get buildingNameTooShort => 'Název budovy musí mít alespoň 2 znaky';

  @override
  String get address => 'Adresa';

  @override
  String get enterAddress => 'Zadejte adresu';

  @override
  String get addressRequired => 'Adresa je povinná';

  @override
  String get addressTooShort => 'Adresa musí mít alespoň 5 znaků';

  @override
  String get editingBuilding => 'Upravuji budovu...';

  @override
  String get addingBuilding => 'Přidávám budovu...';

  @override
  String get updatedBuildingSuccessfully => 'Budova byla úspěšně upravena';

  @override
  String get addedBuildingSuccessfully => 'Budova byla úspěšně přidána';

  @override
  String get errorDuringUpdatingBuilding => 'Chyba při aktualizaci budovy';

  @override
  String get errorDuringAddingBuilding => 'Chyba při přidávání budovy';

  @override
  String get noBuildings => 'Žádné budovy';

  @override
  String get areaHasNoBuildings => 'Tato oblast nemá žádné budovy';

  @override
  String get deviceInfo => 'Informace o zařízení';

  @override
  String get editDevice => 'Upravit zařízení';

  @override
  String get addMultipleDevices => 'Přidat více zařízení';

  @override
  String get deviceName => 'Název zařízení';

  @override
  String get prefix => 'Prefix';

  @override
  String get enterDeviceName => 'Zadejte název zařízení';

  @override
  String get enterMultipleDevicesPrefix => 'Např. Pokoj_';

  @override
  String get deviceNameRequired => 'Název zařízení je povinný';

  @override
  String get multipleDevicesPrefixRequired => 'Prefix je povinný';

  @override
  String get deviceNameTooShort => 'Název zařízení musí mít alespoň 2 znaky';

  @override
  String get deviceCount => 'Počet zařízení';

  @override
  String get enterDeviceCount => 'Zadejte počet zařízení';

  @override
  String get deviceCountRequired => 'Počet zařízení je povinný';

  @override
  String get deviceCountMustBePositive => 'Počet zařízení musí být alespoň 1';

  @override
  String get deviceCountMax100 => 'Počet nesmí přesáhnout 100';

  @override
  String get indexingLength => 'Délka číslování';

  @override
  String get indexingLengthHint => 'Pevný počet číslic (1-5)';

  @override
  String get indexingLengthRequired => 'Délka číslování je povinná';

  @override
  String get indexingLengthMustBeBetween1And5 =>
      'Délka číslování musí být mezi 1 a 5';

  @override
  String get deviceType => 'Typ zařízení';

  @override
  String get editingDevice => 'Upravuji zařízení...';

  @override
  String get addingDevice => 'Přidávám zařízení...';

  @override
  String get addingMultipleDevices => 'Přidávám zařízení...';

  @override
  String get updatedDeviceSuccessfully => 'Zařízení bylo úspěšně upraveno';

  @override
  String get addedDeviceSuccessfully => 'Zařízení bylo úspěšně přidáno';

  @override
  String addedXDevicesSuccessfully(int count, String prefix) {
    return 'Vytvořeno $count zařízení s prefixem $prefix';
  }

  @override
  String get errorDuringUpdatingDevice => 'Chyba při aktualizaci zařízení';

  @override
  String get errorDuringAddingDevice => 'Chyba při přidávání zařízení';

  @override
  String get noDevices => 'Žádná zařízení';

  @override
  String get buildingHasNoDevices => 'Tato budova nemá žádná zařízení';

  @override
  String get selectArea => 'Vyberte oblast';

  @override
  String get selectDevice => 'Vyberte zařízení';

  @override
  String get selectCompanyFirst =>
      'Pro zobrazení oblastí vyberte vlastníka ze seznamu';

  @override
  String get selectAreaFirst => 'Pro zobrazení budov vyberte oblast ze seznamu';

  @override
  String get selectBuildingFirst =>
      'Pro zobrazení zařízení vyberte budovu ze seznamu';

  @override
  String get noBuildingSelected => 'Není vybrána budova';

  @override
  String get accessKeys => 'Přístupové klíče';

  @override
  String get errorDuringAddingAccessKey => 'Chyba při přidávání klíče';

  @override
  String get errorDuringRemovingAccessKey => 'Chyba při odebírání klíče';

  @override
  String get errorDuringUpdatingAccessKeyValidity =>
      'Chyba při aktualizaci platnosti';

  @override
  String get noAccessKeys => 'Žádná přístupová klíče';

  @override
  String get addNewAccessKeys => 'Přidat nové klíče';

  @override
  String assignedDevices(int count) {
    return '$count zařízení';
  }

  @override
  String get assignAccessKey => 'Přidat klíč';

  @override
  String get noAvailableAccessKeys => 'Žádné dostupné klíče';

  @override
  String get allAccessKeysAssigned =>
      'Všechny klíče jsou již přirazena tomuto účtu';

  @override
  String get active => 'Aktivní';

  @override
  String get inactive => 'Neaktivní';

  @override
  String get validFrom => 'Platné od';

  @override
  String get validTo => 'Platné do';

  @override
  String get accessValidity => 'Platnost';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get unknownError => 'Neznámá chyba';

  @override
  String deviceCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zařízení',
      few: '$count zařízení',
      one: '$count zařízení',
    );
    return '$_temp0';
  }

  @override
  String totalAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count účtů',
      few: 'Celkem $count účty',
      one: 'Celkem $count účet',
    );
    return '$_temp0';
  }

  @override
  String totalCompaniesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count společností',
      few: 'Celkem $count společnosti',
      one: 'Celkem $count společnost',
    );
    return '$_temp0';
  }

  @override
  String totalAreasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count oblastí',
      few: 'Celkem $count oblasti',
      one: 'Celkem $count oblast',
    );
    return '$_temp0';
  }

  @override
  String totalBuildingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count budov',
      few: 'Celkem $count budovy',
      one: 'Celkem $count budova',
    );
    return '$_temp0';
  }

  @override
  String totalDevicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkem $count zařízení',
      few: 'Celkem $count zařízení',
      one: 'Celkem $count zařízení',
    );
    return '$_temp0';
  }
}
