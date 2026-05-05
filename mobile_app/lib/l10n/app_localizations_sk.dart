// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Potvrdiť';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get yes => 'Áno';

  @override
  String get no => 'Nie';

  @override
  String get and => 'a';

  @override
  String get or => 'alebo';

  @override
  String get add => 'Pridať';

  @override
  String get close => 'Zatvoriť';

  @override
  String get delete => 'Vymazať';

  @override
  String get remove => 'Odstrániť';

  @override
  String get edit => 'Upraviť';

  @override
  String get save => 'Uložiť';

  @override
  String get create => 'Vytvoriť';

  @override
  String get refresh => 'Obnoviť';

  @override
  String get error => 'Chyba';

  @override
  String get loading => 'Načítavam...';

  @override
  String get removing => 'Odstraňujem...';

  @override
  String get updating => 'Aktualizujem...';

  @override
  String get errorLoadingData => 'Chyba načítania dát';

  @override
  String get more => 'ďalších';

  @override
  String get accessControl => 'Správa prístupov';

  @override
  String get welcome => 'Vitajte';

  @override
  String get yourAccessKeys => 'Vaše prístupové kľúče';

  @override
  String get loadingKeys => 'Načítavam kľúče...';

  @override
  String totalAccessKeysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count kľúčov',
      few: 'Celkom $count kľúče',
      one: 'Celkom $count kľúč',
    );
    return '$_temp0';
  }

  @override
  String get errorDuringLoadingKeys => 'Chyba pri načítavaní kľúčov';

  @override
  String get companies => 'Spoločnosti';

  @override
  String get company => 'Spoločnosť';

  @override
  String get buildings => 'Budovy';

  @override
  String get building => 'Budova';

  @override
  String get areas => 'Oblasti';

  @override
  String get area => 'Oblasť';

  @override
  String get devices => 'Zariadenia';

  @override
  String get device => 'Zariadenie';

  @override
  String get role => 'Rola';

  @override
  String get keys => 'Kľúče';

  @override
  String get key => 'Kľúč';

  @override
  String get id => 'ID';

  @override
  String get name => 'Názov';

  @override
  String get state => 'Stav';

  @override
  String get type => 'Typ';

  @override
  String get door => 'Dvere';

  @override
  String get gate => 'Brána';

  @override
  String get turnstile => 'Turniket';

  @override
  String get ramp => 'Rampa';

  @override
  String get nfcScanPrompt => 'Priložte iPhone k zariadeniu';

  @override
  String get scanningCompleted => 'Skenovanie dokončené';

  @override
  String tagId(String tagId) {
    return 'Tag ID: $tagId';
  }

  @override
  String get unlockingSuccessful => 'Odomykanie úspešné!';

  @override
  String get unlockingFailed => 'Nemáte dostačné práva na odomknutie...';

  @override
  String get unlockingFailedReason =>
      'Ak si myslíte, že sa jedná o chybu, prosím kontaktujte administrátora.';

  @override
  String get tapToScanNfcCard => 'Kliknite pre skenovanie čipu';

  @override
  String get home => 'Domov';

  @override
  String get cards => 'Prístupové Karty';

  @override
  String get accountsManagement => 'Správa účtov';

  @override
  String get accessesManagement => 'Správa prístupov';

  @override
  String get companyManagement => 'Správa spoločnosti';

  @override
  String get loginTitle => 'Prihlásenie';

  @override
  String get loginSubtitle => 'Zadajte svoje prihlasovacie údaje';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get passwordLabel => 'Heslo';

  @override
  String get passwordHint => 'Heslo';

  @override
  String get loginButton => 'Prihlásiť sa';

  @override
  String get enterCorrectEmail => 'Zadajte platnú e-mailovú adresu';

  @override
  String get emailIsMandatory => 'E-mail je povinný';

  @override
  String get enterCorrectPassword => 'Zadajte platné heslo';

  @override
  String get passwordIsMandatory => 'Heslo je povinné';

  @override
  String get accountRole => 'Rola';

  @override
  String get companyOwner => 'Majiteľ spoločnosti';

  @override
  String get manager => 'Manažér';

  @override
  String get user => 'Používateľ';

  @override
  String get demoAccountsTitle => 'Demo účty pre testovanie';

  @override
  String get notLoggedIn => 'Nie ste prihlásený';

  @override
  String get myProfileTitle => 'Môj profil';

  @override
  String get createdAt => 'Vytvorený dňa';

  @override
  String get lastModified => 'Naposledy upravený';

  @override
  String get accountNotFound => 'Účet nenájdený';

  @override
  String get errorDuringLoadingAccount => 'Chyba pri načítaní účtu';

  @override
  String accountRemovedSuccessfully(String accountEmail) {
    return 'Účet $accountEmail bol úspešne odstránený';
  }

  @override
  String get errorDuringRemovingAccount => 'Chyba pri odstraňovaní účtu';

  @override
  String get removeAccount => 'Odstrániť účet';

  @override
  String get removeAccountConfirmation => 'Naozaj chcete odstrániť tento účet?';

  @override
  String get thisActionCannotBeUndone => 'Táto akcia sa nedá vrátiť späť.';

  @override
  String get accountInfo => 'Informácie o účte';

  @override
  String get accountId => 'ID účtu';

  @override
  String get email => 'E-mail';

  @override
  String get companyId => 'ID spoločnosti';

  @override
  String get companyInfoTitle => 'Informácie o spoločnosti';

  @override
  String get noCompanyFound => 'Firma nenájdená';

  @override
  String get companyCreatedDate => 'Dátum založenia spoločnosti';

  @override
  String get companyStatisticsTitle => 'Štatistiky spoločnosti';

  @override
  String get signOut => 'Odhlásiť sa';

  @override
  String get signOutContent => 'Naozaj sa chcete odhlásiť?';

  @override
  String get accessSearchPlaceholder => 'Vyhľadať kľúče, budovy, zariadenia...';

  @override
  String get noKeys => 'Žiadne kľúče';

  @override
  String get noKeysDescription =>
      'Momentálne nemáte prístup k žiadnym kľúčom.\nKontaktujte svojho správcu pre pridelenie prístupu.';

  @override
  String get unlocks => 'Odomyká';

  @override
  String get keyInfoTitle => 'Informácie o kľúči';

  @override
  String get locationInfoTitle => 'Lokalita';

  @override
  String get noAccounts => 'Žiadne účty';

  @override
  String get addAccountsUsingButtonBelow =>
      'Pridajte nový účet pomocou tlačidla nižšie';

  @override
  String get addAccount => 'Pridať účet';

  @override
  String get addAccountPasswordHint =>
      'Účet bude vytvorený bez hesla. Používateľ si ho musí nastaviť pri prvom prihlásení.';

  @override
  String get errorDuringAccountCreation => 'Chyba pri vytváraní účtu';

  @override
  String get accountCreatedSuccessfully => 'Účet bol úspešne vytvorený';

  @override
  String get addKey => 'Pridať kľúč';

  @override
  String get addKeysUsingButtonBelow => 'Pridajte prvý kľúč pomocou tlačidla +';

  @override
  String get selectDevices => 'Vybrať zariadenia';

  @override
  String get noDevicesForSelectedCompany =>
      'Žiadne zariadenia pre túto spoločnosť';

  @override
  String get addBuildingFirst => 'Najprv pridajte budovu pre túto spoločnosť';

  @override
  String get selectBuilding => 'Vyberte budovu';

  @override
  String get errorNoCompanyId => 'Chyba: ID spoločnosti nie je k dispozícii';

  @override
  String get editAccessKey => 'Upraviť prístupový kľúč';

  @override
  String get addNewAccessKey => 'Pridať nový prístupový kľúč';

  @override
  String get accessKeyName => 'Názov prístupového kľúča';

  @override
  String get enterAccessKeyName => 'Zadajte názov prístupového kľúča';

  @override
  String get accessKeyNameRequired => 'Názov prístupového kľúča je povinný';

  @override
  String get accessKeyNameTooShort =>
      'Názov prístupového kľúča musí mať aspoň 2 znaky';

  @override
  String get accessibleDevices => 'Dostupné zariadenia';

  @override
  String get editingAccessKey => 'Upravujem prístupový kľúč...';

  @override
  String get addingAccessKey => 'Pridávam prístupový kľúč...';

  @override
  String get addAccessKey => 'Pridať prístupový kľúč';

  @override
  String get accessKeyUpdatedSuccessfully =>
      'Prístupový kľúč bol úspešne aktualizovaný';

  @override
  String get accessKeyAddedSuccessfully =>
      'Prístupový kľúč bol úspešne pridaný';

  @override
  String get accessKeyUpdateFailed => 'Aktualizácia prístupového kľúča zlyhala';

  @override
  String get accessKeyAdditionFailed => 'Pridanie prístupového kľúča zlyhalo';

  @override
  String selectedCount(int count) {
    return 'Vybrané: $count';
  }

  @override
  String get addArea => 'Pridať oblasť';

  @override
  String get addBuilding => 'Pridať budovu';

  @override
  String get addDevice => 'Pridať zariadenie';

  @override
  String get companyInfo => 'Informácie o spoločnosti';

  @override
  String get noOwners => 'Žiadni majitelia';

  @override
  String get noOwnersSubtitle =>
      'Pre pridanie prvého majiteľa kontaktujte podporu';

  @override
  String get editCompany => 'Upraviť spoločnosť';

  @override
  String get companyName => 'Názov spoločnosti';

  @override
  String get enterCompanyName => 'Zadajte názov spoločnosti';

  @override
  String get companyNameRequired => 'Názov spoločnosti je povinný';

  @override
  String get companyNameTooShort => 'Názov spoločnosti musí mať aspoň 2 znaky';

  @override
  String get editingCompany => 'Upravujem spoločnosť...';

  @override
  String get updatedCompanySuccessfully => 'Spoločnosť bola úspešne upravená';

  @override
  String get errorDuringUpdatingCompany => 'Chyba pri aktualizácii spoločnosti';

  @override
  String get areaInfo => 'Informácie o oblasti';

  @override
  String get editArea => 'Upraviť oblasť';

  @override
  String get areaName => 'Názov oblasti';

  @override
  String get enterAreaName => 'Zadajte názov oblasti';

  @override
  String get areaNameRequired => 'Názov oblasti je povinný';

  @override
  String get areaNameTooShort => 'Názov oblasti musí mať aspoň 2 znaky';

  @override
  String get location => 'Lokalita';

  @override
  String get enterLocation => 'Zadajte lokáciu';

  @override
  String get locationRequired => 'Lokalita je povinná';

  @override
  String get locationTooShort => 'Lokalita musí mať aspoň 2 znaky';

  @override
  String get editingArea => 'Upravujem oblasť...';

  @override
  String get addingArea => 'Pridávam oblasť...';

  @override
  String get updatedAreaSuccessfully => 'Oblasť bola úspešne upravená';

  @override
  String get addedAreaSuccessfully => 'Oblasť bola úspešne pridaná';

  @override
  String get errorDuringUpdatingArea => 'Chyba pri aktualizácii oblasti';

  @override
  String get errorDuringAddingArea => 'Chyba pri pridávaní oblasti';

  @override
  String get noAreas => 'Žiadne oblasti';

  @override
  String get companyHasNoAreas => 'Táto spoločnosť nemá žiadne oblasti';

  @override
  String get buildingInfo => 'Informácie o budove';

  @override
  String get editBuilding => 'Upraviť budovu';

  @override
  String get buildingName => 'Názov budovy';

  @override
  String get enterBuildingName => 'Zadajte názov budovy';

  @override
  String get buildingNameRequired => 'Názov budovy je povinný';

  @override
  String get buildingNameTooShort => 'Názov budovy musí mať aspoň 2 znaky';

  @override
  String get address => 'Adresa';

  @override
  String get enterAddress => 'Zadajte adresu';

  @override
  String get addressRequired => 'Adresa je povinná';

  @override
  String get addressTooShort => 'Adresa musí mať aspoň 5 znakov';

  @override
  String get editingBuilding => 'Upravujem budovu...';

  @override
  String get addingBuilding => 'Pridávam budovu...';

  @override
  String get updatedBuildingSuccessfully => 'Budova bola úspešne upravená';

  @override
  String get addedBuildingSuccessfully => 'Budova bola úspešne pridaná';

  @override
  String get errorDuringUpdatingBuilding => 'Chyba pri aktualizácii budovy';

  @override
  String get errorDuringAddingBuilding => 'Chyba pri pridávaní budovy';

  @override
  String get noBuildings => 'Žiadne budovy';

  @override
  String get areaHasNoBuildings => 'Táto oblasť nemá žiadne budovy';

  @override
  String get deviceInfo => 'Informácie o zariadení';

  @override
  String get editDevice => 'Upraviť zariadenie';

  @override
  String get addMultipleDevices => 'Pridať viac zariadení';

  @override
  String get deviceName => 'Názov zariadenia';

  @override
  String get prefix => 'Prefix';

  @override
  String get enterDeviceName => 'Zadajte názov zariadenia';

  @override
  String get enterMultipleDevicesPrefix => 'Napr. Izba_';

  @override
  String get deviceNameRequired => 'Názov zariadenia je povinný';

  @override
  String get multipleDevicesPrefixRequired => 'Prefix je povinný';

  @override
  String get deviceNameTooShort => 'Názov zariadenia musí mať aspoň 2 znaky';

  @override
  String get deviceCount => 'Počet zariadení';

  @override
  String get enterDeviceCount => 'Zadajte počet zariadení';

  @override
  String get deviceCountRequired => 'Počet zariadení je povinný';

  @override
  String get deviceCountMustBePositive => 'Počet zariadení musí byť aspoň 1';

  @override
  String get deviceCountMax100 => 'Počet nesmie presiahnuť 100';

  @override
  String get indexingLength => 'Dĺžka číslovania';

  @override
  String get indexingLengthHint => 'Pevný počet číslic (1-5)';

  @override
  String get indexingLengthRequired => 'Dĺžka číslovania je povinná';

  @override
  String get indexingLengthMustBeBetween1And5 =>
      'Dĺžka číslovania musí byť medzi 1 a 5';

  @override
  String get deviceType => 'Typ zariadenia';

  @override
  String get editingDevice => 'Upravujem zariadenie...';

  @override
  String get addingDevice => 'Pridávam zariadenie...';

  @override
  String get addingMultipleDevices => 'Pridávam zariadenia...';

  @override
  String get updatedDeviceSuccessfully => 'Zariadenie bolo úspešne upravené';

  @override
  String get addedDeviceSuccessfully => 'Zariadenie bolo úspešne pridané';

  @override
  String addedXDevicesSuccessfully(int count, String prefix) {
    return 'Vytvorených $count zariadení s prefixom $prefix';
  }

  @override
  String get errorDuringUpdatingDevice => 'Chyba pri aktualizácii zariadenia';

  @override
  String get errorDuringAddingDevice => 'Chyba pri pridávaní zariadenia';

  @override
  String get noDevices => 'Žiadne zariadenia';

  @override
  String get buildingHasNoDevices => 'Táto oblasť nemá žiadne zariadenia';

  @override
  String get selectArea => 'Vyberte oblasť';

  @override
  String get selectDevice => 'Vyberte zariadenie';

  @override
  String get selectCompanyFirst =>
      'Pre zobrazenie oblastí vyberte majiteľa zo zoznamu';

  @override
  String get selectAreaFirst =>
      'Pre zobrazenie budov vyberte oblasť zo zoznamu';

  @override
  String get selectBuildingFirst =>
      'Pre zobrazenie zariadení vyberte budovu zo zoznamu';

  @override
  String get noBuildingSelected => 'Nie je vybraná budova';

  @override
  String get accessKeys => 'Prístupové kľúče';

  @override
  String get errorDuringAddingAccessKey => 'Chyba pri pridávaní kľúča';

  @override
  String get errorDuringRemovingAccessKey => 'Chyba pri odoberaní kľúča';

  @override
  String get errorDuringUpdatingAccessKeyValidity =>
      'Chyba pri aktualizácii platnosti';

  @override
  String get noAccessKeys => 'Žiadne prístupové kľúče';

  @override
  String get addNewAccessKeys => 'Pridajte nové kľúče';

  @override
  String assignedDevices(int count) {
    return '$count zariadení';
  }

  @override
  String get assignAccessKey => 'Priradiť kľúč';

  @override
  String get noAvailableAccessKeys => 'Žiadne dostupné kľúče';

  @override
  String get allAccessKeysAssigned =>
      'Všetky kľúče sú už priradené tomuto účtu';

  @override
  String get active => 'Aktívny';

  @override
  String get inactive => 'Neaktívny';

  @override
  String get validFrom => 'Platný od';

  @override
  String get validTo => 'Platný do';

  @override
  String get accessValidity => 'Platnosť';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get retry => 'Skúsiť znovu';

  @override
  String get unknownError => 'Neznáma chyba';

  @override
  String deviceCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zariadení',
      few: '$count zariadenia',
      one: '$count zariadenie',
    );
    return '$_temp0';
  }

  @override
  String totalAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count účtov',
      few: 'Celkom $count účty',
      one: 'Celkom $count účet',
    );
    return '$_temp0';
  }

  @override
  String totalCompaniesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count spoločností',
      few: 'Celkom $count spoločnosti',
      one: 'Celkom $count spoločnosť',
    );
    return '$_temp0';
  }

  @override
  String totalAreasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count oblastí',
      few: 'Celkom $count oblasti',
      one: 'Celkom $count oblasť',
    );
    return '$_temp0';
  }

  @override
  String totalBuildingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count budov',
      few: 'Celkom $count budovy',
      one: 'Celkom $count budova',
    );
    return '$_temp0';
  }

  @override
  String totalDevicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Celkom $count zariadení',
      few: 'Celkom $count zariadenia',
      one: 'Celkom $count zariadenie',
    );
    return '$_temp0';
  }
}
