// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get and => 'and';

  @override
  String get or => 'or';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get create => 'Create';

  @override
  String get refresh => 'Refresh';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get removing => 'Removing...';

  @override
  String get updating => 'Updating...';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get more => 'more';

  @override
  String get accessControl => 'Access Control';

  @override
  String get welcome => 'Welcome';

  @override
  String get yourAccessKeys => 'Your Access Keys';

  @override
  String get loadingKeys => 'Loading keys...';

  @override
  String totalAccessKeysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count access keys',
      one: 'Total $count access key',
    );
    return '$_temp0';
  }

  @override
  String get errorDuringLoadingKeys => 'Error loading keys';

  @override
  String get companies => 'Companies';

  @override
  String get company => 'Company';

  @override
  String get buildings => 'Buildings';

  @override
  String get building => 'Building';

  @override
  String get areas => 'Areas';

  @override
  String get area => 'Area';

  @override
  String get devices => 'Devices';

  @override
  String get device => 'Device';

  @override
  String get role => 'Role';

  @override
  String get keys => 'Keys';

  @override
  String get key => 'Key';

  @override
  String get id => 'ID';

  @override
  String get name => 'Name';

  @override
  String get state => 'State';

  @override
  String get type => 'Type';

  @override
  String get door => 'Door';

  @override
  String get gate => 'Gate';

  @override
  String get turnstile => 'Turnstile';

  @override
  String get ramp => 'Ramp';

  @override
  String get nfcScanPrompt => 'Hold iPhone near the device';

  @override
  String get scanningCompleted => 'Scanning complete';

  @override
  String tagId(String tagId) {
    return 'Tag ID: $tagId';
  }

  @override
  String get unlockingSuccessful => 'Unlocking successful!';

  @override
  String get unlockingFailed =>
      'You don\'t have sufficient rights to unlock...';

  @override
  String get unlockingFailedReason =>
      'If you believe this is an error, please contact your administrator.';

  @override
  String get tapToScanNfcCard => 'Tap to scan NFC chip';

  @override
  String get home => 'Home';

  @override
  String get cards => 'Access Cards';

  @override
  String get accountsManagement => 'Accounts Management';

  @override
  String get accessesManagement => 'Accesses Management';

  @override
  String get companyManagement => 'Company Management';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginSubtitle => 'Enter your credentials';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailHint => 'email@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Log in';

  @override
  String get enterCorrectEmail => 'Enter a valid email address';

  @override
  String get emailIsMandatory => 'Email is required';

  @override
  String get enterCorrectPassword => 'Enter a valid password';

  @override
  String get passwordIsMandatory => 'Password is required';

  @override
  String get accountRole => 'Role';

  @override
  String get companyOwner => 'Company Owner';

  @override
  String get manager => 'Manager';

  @override
  String get user => 'User';

  @override
  String get demoAccountsTitle => 'Demo accounts for testing';

  @override
  String get notLoggedIn => 'Not logged in';

  @override
  String get myProfileTitle => 'My Profile';

  @override
  String get createdAt => 'Created on';

  @override
  String get lastModified => 'Last modified';

  @override
  String get accountNotFound => 'Account not found';

  @override
  String get errorDuringLoadingAccount => 'Error loading account';

  @override
  String accountRemovedSuccessfully(String accountEmail) {
    return 'Account $accountEmail was successfully removed';
  }

  @override
  String get errorDuringRemovingAccount => 'Error removing account';

  @override
  String get removeAccount => 'Remove Account';

  @override
  String get removeAccountConfirmation =>
      'Are you sure you want to remove this account?';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get accountId => 'Account ID';

  @override
  String get email => 'E-mail';

  @override
  String get companyId => 'Company ID';

  @override
  String get companyInfoTitle => 'Company Info';

  @override
  String get noCompanyFound => 'Company not found';

  @override
  String get companyCreatedDate => 'Company creation date';

  @override
  String get companyStatisticsTitle => 'Company Statistics';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutContent => 'Are you sure you want to sign out?';

  @override
  String get accessSearchPlaceholder => 'Search keys, buildings, devices...';

  @override
  String get noKeys => 'No keys';

  @override
  String get noKeysDescription =>
      'You currently don\'t have access to any keys.\nContact your administrator to be granted access.';

  @override
  String get unlocks => 'Unlocks';

  @override
  String get keyInfoTitle => 'Key Info';

  @override
  String get locationInfoTitle => 'Location';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get addAccountsUsingButtonBelow =>
      'Add a new account using the button below';

  @override
  String get addAccount => 'Add Account';

  @override
  String get addAccountPasswordHint =>
      'The account will be created without a password. The user must set it on first login.';

  @override
  String get errorDuringAccountCreation => 'Error creating account';

  @override
  String get accountCreatedSuccessfully => 'Account successfully created';

  @override
  String get addKey => 'Add Key';

  @override
  String get addKeysUsingButtonBelow => 'Add your first key using the + button';

  @override
  String get selectDevices => 'Select Devices';

  @override
  String get noDevicesForSelectedCompany => 'No devices for this company';

  @override
  String get addBuildingFirst => 'Add a building for this company first';

  @override
  String get selectBuilding => 'Select Building';

  @override
  String get errorNoCompanyId => 'Error: Company ID is not available';

  @override
  String get editAccessKey => 'Edit Access Key';

  @override
  String get addNewAccessKey => 'Add New Access Key';

  @override
  String get accessKeyName => 'Access Key Name';

  @override
  String get enterAccessKeyName => 'Enter access key name';

  @override
  String get accessKeyNameRequired => 'Access key name is required';

  @override
  String get accessKeyNameTooShort =>
      'Access key name must be at least 2 characters';

  @override
  String get accessibleDevices => 'Accessible Devices';

  @override
  String get editingAccessKey => 'Editing access key...';

  @override
  String get addingAccessKey => 'Adding access key...';

  @override
  String get addAccessKey => 'Add Access Key';

  @override
  String get accessKeyUpdatedSuccessfully => 'Access key successfully updated';

  @override
  String get accessKeyAddedSuccessfully => 'Access key successfully added';

  @override
  String get accessKeyUpdateFailed => 'Access key update failed';

  @override
  String get accessKeyAdditionFailed => 'Access key addition failed';

  @override
  String selectedCount(int count) {
    return 'Selected: $count';
  }

  @override
  String get addArea => 'Add Area';

  @override
  String get addBuilding => 'Add Building';

  @override
  String get addDevice => 'Add Device';

  @override
  String get companyInfo => 'Company Info';

  @override
  String get noOwners => 'No owners';

  @override
  String get noOwnersSubtitle => 'Contact support to add the first owner';

  @override
  String get editCompany => 'Edit Company';

  @override
  String get companyName => 'Company Name';

  @override
  String get enterCompanyName => 'Enter company name';

  @override
  String get companyNameRequired => 'Company name is required';

  @override
  String get companyNameTooShort =>
      'Company name must be at least 2 characters';

  @override
  String get editingCompany => 'Editing company...';

  @override
  String get updatedCompanySuccessfully => 'Company successfully updated';

  @override
  String get errorDuringUpdatingCompany => 'Error updating company';

  @override
  String get areaInfo => 'Area Info';

  @override
  String get editArea => 'Edit Area';

  @override
  String get areaName => 'Area Name';

  @override
  String get enterAreaName => 'Enter area name';

  @override
  String get areaNameRequired => 'Area name is required';

  @override
  String get areaNameTooShort => 'Area name must be at least 2 characters';

  @override
  String get location => 'Location';

  @override
  String get enterLocation => 'Enter location';

  @override
  String get locationRequired => 'Location is required';

  @override
  String get locationTooShort => 'Location must be at least 2 characters';

  @override
  String get editingArea => 'Editing area...';

  @override
  String get addingArea => 'Adding area...';

  @override
  String get updatedAreaSuccessfully => 'Area successfully updated';

  @override
  String get addedAreaSuccessfully => 'Area successfully added';

  @override
  String get errorDuringUpdatingArea => 'Error updating area';

  @override
  String get errorDuringAddingArea => 'Error adding area';

  @override
  String get noAreas => 'No areas';

  @override
  String get companyHasNoAreas => 'This company has no areas';

  @override
  String get buildingInfo => 'Building Info';

  @override
  String get editBuilding => 'Edit Building';

  @override
  String get buildingName => 'Building Name';

  @override
  String get enterBuildingName => 'Enter building name';

  @override
  String get buildingNameRequired => 'Building name is required';

  @override
  String get buildingNameTooShort =>
      'Building name must be at least 2 characters';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter address';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get addressTooShort => 'Address must be at least 5 characters';

  @override
  String get editingBuilding => 'Editing building...';

  @override
  String get addingBuilding => 'Adding building...';

  @override
  String get updatedBuildingSuccessfully => 'Building successfully updated';

  @override
  String get addedBuildingSuccessfully => 'Building successfully added';

  @override
  String get errorDuringUpdatingBuilding => 'Error updating building';

  @override
  String get errorDuringAddingBuilding => 'Error adding building';

  @override
  String get noBuildings => 'No buildings';

  @override
  String get areaHasNoBuildings => 'This area has no buildings';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get editDevice => 'Edit Device';

  @override
  String get addMultipleDevices => 'Add Multiple Devices';

  @override
  String get deviceName => 'Device Name';

  @override
  String get prefix => 'Prefix';

  @override
  String get enterDeviceName => 'Enter device name';

  @override
  String get enterMultipleDevicesPrefix => 'E.g. Room_';

  @override
  String get deviceNameRequired => 'Device name is required';

  @override
  String get multipleDevicesPrefixRequired => 'Prefix is required';

  @override
  String get deviceNameTooShort => 'Device name must be at least 2 characters';

  @override
  String get deviceCount => 'Device Count';

  @override
  String get enterDeviceCount => 'Enter device count';

  @override
  String get deviceCountRequired => 'Device count is required';

  @override
  String get deviceCountMustBePositive => 'Device count must be at least 1';

  @override
  String get deviceCountMax100 => 'Count must not exceed 100';

  @override
  String get indexingLength => 'Indexing Length';

  @override
  String get indexingLengthHint => 'Fixed number of digits (1-5)';

  @override
  String get indexingLengthRequired => 'Indexing length is required';

  @override
  String get indexingLengthMustBeBetween1And5 =>
      'Indexing length must be between 1 and 5';

  @override
  String get deviceType => 'Device Type';

  @override
  String get editingDevice => 'Editing device...';

  @override
  String get addingDevice => 'Adding device...';

  @override
  String get addingMultipleDevices => 'Adding devices...';

  @override
  String get updatedDeviceSuccessfully => 'Device successfully updated';

  @override
  String get addedDeviceSuccessfully => 'Device successfully added';

  @override
  String addedXDevicesSuccessfully(int count, String prefix) {
    return '$count devices created with prefix $prefix';
  }

  @override
  String get errorDuringUpdatingDevice => 'Error updating device';

  @override
  String get errorDuringAddingDevice => 'Error adding device';

  @override
  String get noDevices => 'No devices';

  @override
  String get buildingHasNoDevices => 'This building has no devices';

  @override
  String get selectArea => 'Select Area';

  @override
  String get selectDevice => 'Select Device';

  @override
  String get selectCompanyFirst => 'Select an owner from the list to see areas';

  @override
  String get selectAreaFirst => 'Select an area from the list to see buildings';

  @override
  String get selectBuildingFirst =>
      'Select a building from the list to see devices';

  @override
  String get noBuildingSelected => 'No building selected';

  @override
  String get accessKeys => 'Access Keys';

  @override
  String get errorDuringAddingAccessKey => 'Error adding access key';

  @override
  String get errorDuringRemovingAccessKey => 'Error removing access key';

  @override
  String get errorDuringUpdatingAccessKeyValidity =>
      'Error updating access key validity';

  @override
  String get noAccessKeys => 'No access keys';

  @override
  String get addNewAccessKeys => 'Add new access keys';

  @override
  String assignedDevices(int count) {
    return '$count devices';
  }

  @override
  String get assignAccessKey => 'Assign access key';

  @override
  String get noAvailableAccessKeys => 'No available access keys';

  @override
  String get allAccessKeysAssigned =>
      'All access keys are already assigned to this account';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get validFrom => 'Valid from';

  @override
  String get validTo => 'Valid to';

  @override
  String get accessValidity => 'Validity';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get retry => 'Retry';

  @override
  String get unknownError => 'Unknown error';

  @override
  String deviceCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices',
      one: '$count device',
    );
    return '$_temp0';
  }

  @override
  String totalAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count accounts',
      one: 'Total $count account',
    );
    return '$_temp0';
  }

  @override
  String totalCompaniesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count companies',
      one: 'Total $count company',
    );
    return '$_temp0';
  }

  @override
  String totalAreasCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count areas',
      one: 'Total $count area',
    );
    return '$_temp0';
  }

  @override
  String totalBuildingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count buildings',
      one: 'Total $count building',
    );
    return '$_temp0';
  }

  @override
  String totalDevicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total $count devices',
      one: 'Total $count device',
    );
    return '$_temp0';
  }
}
