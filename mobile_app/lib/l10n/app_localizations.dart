import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
    Locale('sk')
  ];

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @removing.
  ///
  /// In en, this message translates to:
  /// **'Removing...'**
  String get removing;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// No description provided for @accessControl.
  ///
  /// In en, this message translates to:
  /// **'Access Control'**
  String get accessControl;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @yourAccessKeys.
  ///
  /// In en, this message translates to:
  /// **'Your Access Keys'**
  String get yourAccessKeys;

  /// No description provided for @loadingKeys.
  ///
  /// In en, this message translates to:
  /// **'Loading keys...'**
  String get loadingKeys;

  /// No description provided for @totalAccessKeysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} access key} other{Total {count} access keys}}'**
  String totalAccessKeysCount(int count);

  /// No description provided for @errorDuringLoadingKeys.
  ///
  /// In en, this message translates to:
  /// **'Error loading keys'**
  String get errorDuringLoadingKeys;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @buildings.
  ///
  /// In en, this message translates to:
  /// **'Buildings'**
  String get buildings;

  /// No description provided for @building.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get building;

  /// No description provided for @areas.
  ///
  /// In en, this message translates to:
  /// **'Areas'**
  String get areas;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @keys.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get keys;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @gate.
  ///
  /// In en, this message translates to:
  /// **'Gate'**
  String get gate;

  /// No description provided for @turnstile.
  ///
  /// In en, this message translates to:
  /// **'Turnstile'**
  String get turnstile;

  /// No description provided for @ramp.
  ///
  /// In en, this message translates to:
  /// **'Ramp'**
  String get ramp;

  /// No description provided for @nfcScanPrompt.
  ///
  /// In en, this message translates to:
  /// **'Hold iPhone near the device'**
  String get nfcScanPrompt;

  /// No description provided for @scanningCompleted.
  ///
  /// In en, this message translates to:
  /// **'Scanning complete'**
  String get scanningCompleted;

  /// No description provided for @tagId.
  ///
  /// In en, this message translates to:
  /// **'Tag ID: {tagId}'**
  String tagId(String tagId);

  /// No description provided for @unlockingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Unlocking successful!'**
  String get unlockingSuccessful;

  /// No description provided for @unlockingFailed.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have sufficient rights to unlock...'**
  String get unlockingFailed;

  /// No description provided for @unlockingFailedReason.
  ///
  /// In en, this message translates to:
  /// **'If you believe this is an error, please contact your administrator.'**
  String get unlockingFailedReason;

  /// No description provided for @tapToScanNfcCard.
  ///
  /// In en, this message translates to:
  /// **'Tap to scan NFC chip'**
  String get tapToScanNfcCard;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Access Cards'**
  String get cards;

  /// No description provided for @accountsManagement.
  ///
  /// In en, this message translates to:
  /// **'Accounts Management'**
  String get accountsManagement;

  /// No description provided for @accessesManagement.
  ///
  /// In en, this message translates to:
  /// **'Accesses Management'**
  String get accessesManagement;

  /// No description provided for @companyManagement.
  ///
  /// In en, this message translates to:
  /// **'Company Management'**
  String get companyManagement;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @enterCorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get enterCorrectEmail;

  /// No description provided for @emailIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsMandatory;

  /// No description provided for @enterCorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password'**
  String get enterCorrectPassword;

  /// No description provided for @passwordIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsMandatory;

  /// No description provided for @accountRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get accountRole;

  /// No description provided for @companyOwner.
  ///
  /// In en, this message translates to:
  /// **'Company Owner'**
  String get companyOwner;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @demoAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo accounts for testing'**
  String get demoAccountsTitle;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @myProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfileTitle;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get createdAt;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFound;

  /// No description provided for @errorDuringLoadingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error loading account'**
  String get errorDuringLoadingAccount;

  /// No description provided for @accountRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account {accountEmail} was successfully removed'**
  String accountRemovedSuccessfully(String accountEmail);

  /// No description provided for @errorDuringRemovingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error removing account'**
  String get errorDuringRemovingAccount;

  /// No description provided for @removeAccount.
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get removeAccount;

  /// No description provided for @removeAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this account?'**
  String get removeAccountConfirmation;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @accountId.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get accountId;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @companyId.
  ///
  /// In en, this message translates to:
  /// **'Company ID'**
  String get companyId;

  /// No description provided for @companyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Info'**
  String get companyInfoTitle;

  /// No description provided for @noCompanyFound.
  ///
  /// In en, this message translates to:
  /// **'Company not found'**
  String get noCompanyFound;

  /// No description provided for @companyCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Company creation date'**
  String get companyCreatedDate;

  /// No description provided for @companyStatisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Company Statistics'**
  String get companyStatisticsTitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutContent;

  /// No description provided for @accessSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search keys, buildings, devices...'**
  String get accessSearchPlaceholder;

  /// No description provided for @noKeys.
  ///
  /// In en, this message translates to:
  /// **'No keys'**
  String get noKeys;

  /// No description provided for @noKeysDescription.
  ///
  /// In en, this message translates to:
  /// **'You currently don\'t have access to any keys.\nContact your administrator to be granted access.'**
  String get noKeysDescription;

  /// No description provided for @unlocks.
  ///
  /// In en, this message translates to:
  /// **'Unlocks'**
  String get unlocks;

  /// No description provided for @keyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Key Info'**
  String get keyInfoTitle;

  /// No description provided for @locationInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationInfoTitle;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get noAccounts;

  /// No description provided for @addAccountsUsingButtonBelow.
  ///
  /// In en, this message translates to:
  /// **'Add a new account using the button below'**
  String get addAccountsUsingButtonBelow;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @addAccountPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'The account will be created without a password. The user must set it on first login.'**
  String get addAccountPasswordHint;

  /// No description provided for @errorDuringAccountCreation.
  ///
  /// In en, this message translates to:
  /// **'Error creating account'**
  String get errorDuringAccountCreation;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account successfully created'**
  String get accountCreatedSuccessfully;

  /// No description provided for @addKey.
  ///
  /// In en, this message translates to:
  /// **'Add Key'**
  String get addKey;

  /// No description provided for @addKeysUsingButtonBelow.
  ///
  /// In en, this message translates to:
  /// **'Add your first key using the + button'**
  String get addKeysUsingButtonBelow;

  /// No description provided for @selectDevices.
  ///
  /// In en, this message translates to:
  /// **'Select Devices'**
  String get selectDevices;

  /// No description provided for @noDevicesForSelectedCompany.
  ///
  /// In en, this message translates to:
  /// **'No devices for this company'**
  String get noDevicesForSelectedCompany;

  /// No description provided for @addBuildingFirst.
  ///
  /// In en, this message translates to:
  /// **'Add a building for this company first'**
  String get addBuildingFirst;

  /// No description provided for @selectBuilding.
  ///
  /// In en, this message translates to:
  /// **'Select Building'**
  String get selectBuilding;

  /// No description provided for @errorNoCompanyId.
  ///
  /// In en, this message translates to:
  /// **'Error: Company ID is not available'**
  String get errorNoCompanyId;

  /// No description provided for @editAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Edit Access Key'**
  String get editAccessKey;

  /// No description provided for @addNewAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Add New Access Key'**
  String get addNewAccessKey;

  /// No description provided for @accessKeyName.
  ///
  /// In en, this message translates to:
  /// **'Access Key Name'**
  String get accessKeyName;

  /// No description provided for @enterAccessKeyName.
  ///
  /// In en, this message translates to:
  /// **'Enter access key name'**
  String get enterAccessKeyName;

  /// No description provided for @accessKeyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Access key name is required'**
  String get accessKeyNameRequired;

  /// No description provided for @accessKeyNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Access key name must be at least 2 characters'**
  String get accessKeyNameTooShort;

  /// No description provided for @accessibleDevices.
  ///
  /// In en, this message translates to:
  /// **'Accessible Devices'**
  String get accessibleDevices;

  /// No description provided for @editingAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Editing access key...'**
  String get editingAccessKey;

  /// No description provided for @addingAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Adding access key...'**
  String get addingAccessKey;

  /// No description provided for @addAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Add Access Key'**
  String get addAccessKey;

  /// No description provided for @accessKeyUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Access key successfully updated'**
  String get accessKeyUpdatedSuccessfully;

  /// No description provided for @accessKeyAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Access key successfully added'**
  String get accessKeyAddedSuccessfully;

  /// No description provided for @accessKeyUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Access key update failed'**
  String get accessKeyUpdateFailed;

  /// No description provided for @accessKeyAdditionFailed.
  ///
  /// In en, this message translates to:
  /// **'Access key addition failed'**
  String get accessKeyAdditionFailed;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected: {count}'**
  String selectedCount(int count);

  /// No description provided for @addArea.
  ///
  /// In en, this message translates to:
  /// **'Add Area'**
  String get addArea;

  /// No description provided for @addBuilding.
  ///
  /// In en, this message translates to:
  /// **'Add Building'**
  String get addBuilding;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @companyInfo.
  ///
  /// In en, this message translates to:
  /// **'Company Info'**
  String get companyInfo;

  /// No description provided for @noOwners.
  ///
  /// In en, this message translates to:
  /// **'No owners'**
  String get noOwners;

  /// No description provided for @noOwnersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contact support to add the first owner'**
  String get noOwnersSubtitle;

  /// No description provided for @editCompany.
  ///
  /// In en, this message translates to:
  /// **'Edit Company'**
  String get editCompany;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// No description provided for @companyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Company name is required'**
  String get companyNameRequired;

  /// No description provided for @companyNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Company name must be at least 2 characters'**
  String get companyNameTooShort;

  /// No description provided for @editingCompany.
  ///
  /// In en, this message translates to:
  /// **'Editing company...'**
  String get editingCompany;

  /// No description provided for @updatedCompanySuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Company successfully updated'**
  String get updatedCompanySuccessfully;

  /// No description provided for @errorDuringUpdatingCompany.
  ///
  /// In en, this message translates to:
  /// **'Error updating company'**
  String get errorDuringUpdatingCompany;

  /// No description provided for @areaInfo.
  ///
  /// In en, this message translates to:
  /// **'Area Info'**
  String get areaInfo;

  /// No description provided for @editArea.
  ///
  /// In en, this message translates to:
  /// **'Edit Area'**
  String get editArea;

  /// No description provided for @areaName.
  ///
  /// In en, this message translates to:
  /// **'Area Name'**
  String get areaName;

  /// No description provided for @enterAreaName.
  ///
  /// In en, this message translates to:
  /// **'Enter area name'**
  String get enterAreaName;

  /// No description provided for @areaNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Area name is required'**
  String get areaNameRequired;

  /// No description provided for @areaNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Area name must be at least 2 characters'**
  String get areaNameTooShort;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter location'**
  String get enterLocation;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get locationRequired;

  /// No description provided for @locationTooShort.
  ///
  /// In en, this message translates to:
  /// **'Location must be at least 2 characters'**
  String get locationTooShort;

  /// No description provided for @editingArea.
  ///
  /// In en, this message translates to:
  /// **'Editing area...'**
  String get editingArea;

  /// No description provided for @addingArea.
  ///
  /// In en, this message translates to:
  /// **'Adding area...'**
  String get addingArea;

  /// No description provided for @updatedAreaSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Area successfully updated'**
  String get updatedAreaSuccessfully;

  /// No description provided for @addedAreaSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Area successfully added'**
  String get addedAreaSuccessfully;

  /// No description provided for @errorDuringUpdatingArea.
  ///
  /// In en, this message translates to:
  /// **'Error updating area'**
  String get errorDuringUpdatingArea;

  /// No description provided for @errorDuringAddingArea.
  ///
  /// In en, this message translates to:
  /// **'Error adding area'**
  String get errorDuringAddingArea;

  /// No description provided for @noAreas.
  ///
  /// In en, this message translates to:
  /// **'No areas'**
  String get noAreas;

  /// No description provided for @companyHasNoAreas.
  ///
  /// In en, this message translates to:
  /// **'This company has no areas'**
  String get companyHasNoAreas;

  /// No description provided for @buildingInfo.
  ///
  /// In en, this message translates to:
  /// **'Building Info'**
  String get buildingInfo;

  /// No description provided for @editBuilding.
  ///
  /// In en, this message translates to:
  /// **'Edit Building'**
  String get editBuilding;

  /// No description provided for @buildingName.
  ///
  /// In en, this message translates to:
  /// **'Building Name'**
  String get buildingName;

  /// No description provided for @enterBuildingName.
  ///
  /// In en, this message translates to:
  /// **'Enter building name'**
  String get enterBuildingName;

  /// No description provided for @buildingNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Building name is required'**
  String get buildingNameRequired;

  /// No description provided for @buildingNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Building name must be at least 2 characters'**
  String get buildingNameTooShort;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @addressTooShort.
  ///
  /// In en, this message translates to:
  /// **'Address must be at least 5 characters'**
  String get addressTooShort;

  /// No description provided for @editingBuilding.
  ///
  /// In en, this message translates to:
  /// **'Editing building...'**
  String get editingBuilding;

  /// No description provided for @addingBuilding.
  ///
  /// In en, this message translates to:
  /// **'Adding building...'**
  String get addingBuilding;

  /// No description provided for @updatedBuildingSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Building successfully updated'**
  String get updatedBuildingSuccessfully;

  /// No description provided for @addedBuildingSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Building successfully added'**
  String get addedBuildingSuccessfully;

  /// No description provided for @errorDuringUpdatingBuilding.
  ///
  /// In en, this message translates to:
  /// **'Error updating building'**
  String get errorDuringUpdatingBuilding;

  /// No description provided for @errorDuringAddingBuilding.
  ///
  /// In en, this message translates to:
  /// **'Error adding building'**
  String get errorDuringAddingBuilding;

  /// No description provided for @noBuildings.
  ///
  /// In en, this message translates to:
  /// **'No buildings'**
  String get noBuildings;

  /// No description provided for @areaHasNoBuildings.
  ///
  /// In en, this message translates to:
  /// **'This area has no buildings'**
  String get areaHasNoBuildings;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// No description provided for @editDevice.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get editDevice;

  /// No description provided for @addMultipleDevices.
  ///
  /// In en, this message translates to:
  /// **'Add Multiple Devices'**
  String get addMultipleDevices;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @prefix.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get prefix;

  /// No description provided for @enterDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Enter device name'**
  String get enterDeviceName;

  /// No description provided for @enterMultipleDevicesPrefix.
  ///
  /// In en, this message translates to:
  /// **'E.g. Room_'**
  String get enterMultipleDevicesPrefix;

  /// No description provided for @deviceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Device name is required'**
  String get deviceNameRequired;

  /// No description provided for @multipleDevicesPrefixRequired.
  ///
  /// In en, this message translates to:
  /// **'Prefix is required'**
  String get multipleDevicesPrefixRequired;

  /// No description provided for @deviceNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Device name must be at least 2 characters'**
  String get deviceNameTooShort;

  /// No description provided for @deviceCount.
  ///
  /// In en, this message translates to:
  /// **'Device Count'**
  String get deviceCount;

  /// No description provided for @enterDeviceCount.
  ///
  /// In en, this message translates to:
  /// **'Enter device count'**
  String get enterDeviceCount;

  /// No description provided for @deviceCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Device count is required'**
  String get deviceCountRequired;

  /// No description provided for @deviceCountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Device count must be at least 1'**
  String get deviceCountMustBePositive;

  /// No description provided for @deviceCountMax100.
  ///
  /// In en, this message translates to:
  /// **'Count must not exceed 100'**
  String get deviceCountMax100;

  /// No description provided for @indexingLength.
  ///
  /// In en, this message translates to:
  /// **'Indexing Length'**
  String get indexingLength;

  /// No description provided for @indexingLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Fixed number of digits (1-5)'**
  String get indexingLengthHint;

  /// No description provided for @indexingLengthRequired.
  ///
  /// In en, this message translates to:
  /// **'Indexing length is required'**
  String get indexingLengthRequired;

  /// No description provided for @indexingLengthMustBeBetween1And5.
  ///
  /// In en, this message translates to:
  /// **'Indexing length must be between 1 and 5'**
  String get indexingLengthMustBeBetween1And5;

  /// No description provided for @deviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceType;

  /// No description provided for @editingDevice.
  ///
  /// In en, this message translates to:
  /// **'Editing device...'**
  String get editingDevice;

  /// No description provided for @addingDevice.
  ///
  /// In en, this message translates to:
  /// **'Adding device...'**
  String get addingDevice;

  /// No description provided for @addingMultipleDevices.
  ///
  /// In en, this message translates to:
  /// **'Adding devices...'**
  String get addingMultipleDevices;

  /// No description provided for @updatedDeviceSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device successfully updated'**
  String get updatedDeviceSuccessfully;

  /// No description provided for @addedDeviceSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Device successfully added'**
  String get addedDeviceSuccessfully;

  /// No description provided for @addedXDevicesSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} devices created with prefix {prefix}'**
  String addedXDevicesSuccessfully(int count, String prefix);

  /// No description provided for @errorDuringUpdatingDevice.
  ///
  /// In en, this message translates to:
  /// **'Error updating device'**
  String get errorDuringUpdatingDevice;

  /// No description provided for @errorDuringAddingDevice.
  ///
  /// In en, this message translates to:
  /// **'Error adding device'**
  String get errorDuringAddingDevice;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices'**
  String get noDevices;

  /// No description provided for @buildingHasNoDevices.
  ///
  /// In en, this message translates to:
  /// **'This building has no devices'**
  String get buildingHasNoDevices;

  /// No description provided for @selectArea.
  ///
  /// In en, this message translates to:
  /// **'Select Area'**
  String get selectArea;

  /// No description provided for @selectDevice.
  ///
  /// In en, this message translates to:
  /// **'Select Device'**
  String get selectDevice;

  /// No description provided for @selectCompanyFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an owner from the list to see areas'**
  String get selectCompanyFirst;

  /// No description provided for @selectAreaFirst.
  ///
  /// In en, this message translates to:
  /// **'Select an area from the list to see buildings'**
  String get selectAreaFirst;

  /// No description provided for @selectBuildingFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a building from the list to see devices'**
  String get selectBuildingFirst;

  /// No description provided for @noBuildingSelected.
  ///
  /// In en, this message translates to:
  /// **'No building selected'**
  String get noBuildingSelected;

  /// No description provided for @accessKeys.
  ///
  /// In en, this message translates to:
  /// **'Access Keys'**
  String get accessKeys;

  /// No description provided for @errorDuringAddingAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Error adding access key'**
  String get errorDuringAddingAccessKey;

  /// No description provided for @errorDuringRemovingAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Error removing access key'**
  String get errorDuringRemovingAccessKey;

  /// No description provided for @errorDuringUpdatingAccessKeyValidity.
  ///
  /// In en, this message translates to:
  /// **'Error updating access key validity'**
  String get errorDuringUpdatingAccessKeyValidity;

  /// No description provided for @noAccessKeys.
  ///
  /// In en, this message translates to:
  /// **'No access keys'**
  String get noAccessKeys;

  /// No description provided for @addNewAccessKeys.
  ///
  /// In en, this message translates to:
  /// **'Add new access keys'**
  String get addNewAccessKeys;

  /// No description provided for @assignedDevices.
  ///
  /// In en, this message translates to:
  /// **'{count} devices'**
  String assignedDevices(int count);

  /// No description provided for @assignAccessKey.
  ///
  /// In en, this message translates to:
  /// **'Assign access key'**
  String get assignAccessKey;

  /// No description provided for @noAvailableAccessKeys.
  ///
  /// In en, this message translates to:
  /// **'No available access keys'**
  String get noAvailableAccessKeys;

  /// No description provided for @allAccessKeysAssigned.
  ///
  /// In en, this message translates to:
  /// **'All access keys are already assigned to this account'**
  String get allAccessKeysAssigned;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @validFrom.
  ///
  /// In en, this message translates to:
  /// **'Valid from'**
  String get validFrom;

  /// No description provided for @validTo.
  ///
  /// In en, this message translates to:
  /// **'Valid to'**
  String get validTo;

  /// No description provided for @accessValidity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get accessValidity;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @deviceCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} device} other{{count} devices}}'**
  String deviceCountLabel(int count);

  /// No description provided for @totalAccountsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} account} other{Total {count} accounts}}'**
  String totalAccountsCount(int count);

  /// No description provided for @totalCompaniesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} company} other{Total {count} companies}}'**
  String totalCompaniesCount(int count);

  /// No description provided for @totalAreasCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} area} other{Total {count} areas}}'**
  String totalAreasCount(int count);

  /// No description provided for @totalBuildingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} building} other{Total {count} buildings}}'**
  String totalBuildingsCount(int count);

  /// No description provided for @totalDevicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Total {count} device} other{Total {count} devices}}'**
  String totalDevicesCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en', 'sk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
    case 'sk':
      return AppLocalizationsSk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
