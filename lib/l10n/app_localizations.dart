import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('es')
  ];

  /// Add medication button
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// Medication name text field label
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// Validation error message for medication name
  ///
  /// In en, this message translates to:
  /// **'Please enter a medication name'**
  String get pleaseEnterName;

  /// Dosage text field label
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// Validation error message for dosage
  ///
  /// In en, this message translates to:
  /// **'Please enter a dosage'**
  String get pleaseEnterDosage;

  /// Validation error message for an invalid number
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// Example for unit text field
  ///
  /// In en, this message translates to:
  /// **'Unit (e.g., mg, ml)'**
  String get unitExample;

  /// Validation error message for unit
  ///
  /// In en, this message translates to:
  /// **'Please enter a unit'**
  String get pleaseEnterUnit;

  /// Stock text field label
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// Validation error message for stock
  ///
  /// In en, this message translates to:
  /// **'Invalid stock'**
  String get invalidStock;

  /// Save medication button
  ///
  /// In en, this message translates to:
  /// **'Save Medication'**
  String get saveMedication;

  /// Edit medication screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// Delete medication button
  ///
  /// In en, this message translates to:
  /// **'Delete Medication'**
  String get deleteMedication;

  /// Warning that an action cannot be undone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Daily schedule type
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Specific days in a week schedule type
  ///
  /// In en, this message translates to:
  /// **'Specific days in week'**
  String get specificDaysInWeek;

  /// Interval schedule type
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// Interval in hours
  ///
  /// In en, this message translates to:
  /// **'Interval in hours'**
  String get intervalHours;

  /// Days of the week
  ///
  /// In en, this message translates to:
  /// **'Days of the week'**
  String get daysOfTheWeek;

  /// Times for medication
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// Add time button
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// Start date
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// End date (optional)
  ///
  /// In en, this message translates to:
  /// **'End Date (Optional)'**
  String get endDateOptional;

  /// Not set
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// History screen title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Medications screen title
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// Message when there are no medications
  ///
  /// In en, this message translates to:
  /// **'No medications added yet.'**
  String get noMedications;

  /// Message to prompt user to add their first medication
  ///
  /// In en, this message translates to:
  /// **'Add your first medication'**
  String get addYourFirstMedication;

  /// Doses for a specific day
  ///
  /// In en, this message translates to:
  /// **'Doses for'**
  String get dosesFor;

  /// Message when there are no doses for a specific day
  ///
  /// In en, this message translates to:
  /// **'No doses scheduled for this day.'**
  String get noDoses;

  /// All filter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Taken dose status
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// Missed filter
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missed;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System theme
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Message when there are no records
  ///
  /// In en, this message translates to:
  /// **'No records found.'**
  String get noRecords;

  /// Validation error message for dosage
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid dosage'**
  String get pleaseEnterAValidDosage;

  /// Validation error message for stock
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid stock'**
  String get pleaseEnterAValidStock;

  /// Error message when saving a medication fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save medication:'**
  String get failedToSaveMedication;

  /// Error message when deleting a medication fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete medication:'**
  String get failedToDeleteMedication;

  /// Your medications screen title
  ///
  /// In en, this message translates to:
  /// **'Your Medications'**
  String get yourMedications;

  /// Message when there are no medications
  ///
  /// In en, this message translates to:
  /// **'No medications yet.'**
  String get noMedicationsYet;

  /// Message to prompt user to add a medication
  ///
  /// In en, this message translates to:
  /// **'Add a medication to get started.'**
  String get addMedicationToGetStarted;

  /// Take button
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// Dose history screen title
  ///
  /// In en, this message translates to:
  /// **'Dose History'**
  String get historyScreenTitle;

  /// Message when no dose history is available
  ///
  /// In en, this message translates to:
  /// **'No dose history available.'**
  String get noDoseHistoryAvailable;

  /// Dose at a specific time
  ///
  /// In en, this message translates to:
  /// **'Dose at {time}'**
  String doseAt(String time);

  /// Dose details
  ///
  /// In en, this message translates to:
  /// **'{dosage} {unit}'**
  String doseDetails(String dosage, String unit);

  /// Mark as taken button
  ///
  /// In en, this message translates to:
  /// **'Mark as Taken'**
  String get markAsTaken;

  /// Mark as skipped button
  ///
  /// In en, this message translates to:
  /// **'Mark as Skipped'**
  String get markAsSkipped;

  /// Mark as pending button
  ///
  /// In en, this message translates to:
  /// **'Mark as Pending'**
  String get markAsPending;

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Confirm delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// Confirmation message for deleting a medication
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication?'**
  String get areYouSureYouWantToDeleteThisMedication;

  /// Message when there are no doses in a category
  ///
  /// In en, this message translates to:
  /// **'No doses in this category.'**
  String get noDosesInCategory;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Confirm action dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get confirmAction;

  /// Confirmation message for marking a dose status
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this dose as {status}?'**
  String areYouSureYouWantToMarkThisDoseAs(String status);

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Daily dose
  ///
  /// In en, this message translates to:
  /// **'Daily at {time}'**
  String dailyDose(String time);

  /// Dose on specific days
  ///
  /// In en, this message translates to:
  /// **'On {days} at {time}'**
  String specificDaysDose(String days, String time);

  /// Dose at an interval
  ///
  /// In en, this message translates to:
  /// **'Every {interval} hours, at {time}'**
  String intervalDose(String interval, String time);

  /// One-time dose
  ///
  /// In en, this message translates to:
  /// **'One-time dose on {date} at {time}'**
  String oneTimeDose(String date, String time);

  /// Medication dosage
  ///
  /// In en, this message translates to:
  /// **'{dosage} {unit}'**
  String medicationDosage(String dosage, String unit);

  /// Dose at a specific time
  ///
  /// In en, this message translates to:
  /// **'{dosage} {unit} at {time}'**
  String doseAtTime(String dosage, String unit, String time);

  /// Start date label
  ///
  /// In en, this message translates to:
  /// **'Start: {date}'**
  String startDateLabel(String date);

  /// End date label
  ///
  /// In en, this message translates to:
  /// **'End: {date}'**
  String endDateLabel(String date);

  /// Short name for Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// Short name for Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// Short name for Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// Short name for Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// Short name for Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// Short name for Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// Short name for Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// Scheduled status
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// Duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// End
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Ongoing status
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// On specific days
  ///
  /// In en, this message translates to:
  /// **'On {days} at {time}'**
  String onDays(String days, String time);

  /// Arabic language
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Loading indicator
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Validation error message for time
  ///
  /// In en, this message translates to:
  /// **'Please add a time'**
  String get pleaseAddTime;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Pills
  ///
  /// In en, this message translates to:
  /// **'pills'**
  String get pills;

  /// One-time schedule type
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get oneTime;

  /// Weekdays schedule type
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get weekdays;

  /// Date and time
  ///
  /// In en, this message translates to:
  /// **'Date and Time'**
  String get dateTime;

  /// Monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Medication history screen title
  ///
  /// In en, this message translates to:
  /// **'Medication History'**
  String get medicationHistory;

  /// Message when there is no dose history
  ///
  /// In en, this message translates to:
  /// **'No dose history yet.'**
  String get noDoseHistoryYet;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Pending dose status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// Theme mode setting
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// Appearance setting
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// The name of the language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// Error message when a URL can't be launched
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get couldNotLaunchUrl;

  /// Profile setting
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit profile setting
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Security setting
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Notifications setting
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Dose notifications setting
  ///
  /// In en, this message translates to:
  /// **'Dose Notifications'**
  String get doseNotifications;

  /// Reminders setting
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// Help setting
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Terms and conditions setting
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Version setting
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Statistics screen title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Schedule
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// End Date
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// On
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// Every
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// hours
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;
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
      <String>['ar', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
