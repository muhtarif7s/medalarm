// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addMedication => 'Add Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get pleaseEnterName => 'Please enter a medication name';

  @override
  String get dosage => 'Dosage';

  @override
  String get pleaseEnterDosage => 'Please enter a dosage';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get unitExample => 'Unit (e.g., mg, ml)';

  @override
  String get pleaseEnterUnit => 'Please enter a unit';

  @override
  String get stock => 'Stock';

  @override
  String get invalidStock => 'Invalid stock';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get daily => 'Daily';

  @override
  String get specificDaysInWeek => 'Specific days in week';

  @override
  String get interval => 'Interval';

  @override
  String get intervalHours => 'Interval in hours';

  @override
  String get daysOfTheWeek => 'Days of the week';

  @override
  String get times => 'Times';

  @override
  String get addTime => 'Add Time';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDateOptional => 'End Date (Optional)';

  @override
  String get notSet => 'Not set';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get medications => 'Medications';

  @override
  String get noMedications => 'No medications added yet.';

  @override
  String get addYourFirstMedication => 'Add your first medication';

  @override
  String get dosesFor => 'Doses for';

  @override
  String get noDoses => 'No doses scheduled for this day.';

  @override
  String get all => 'All';

  @override
  String get taken => 'Taken';

  @override
  String get missed => 'Missed';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get noRecords => 'No records found.';

  @override
  String get pleaseEnterAValidDosage => 'Please enter a valid dosage';

  @override
  String get pleaseEnterAValidStock => 'Please enter a valid stock';

  @override
  String get failedToSaveMedication => 'Failed to save medication:';

  @override
  String get failedToDeleteMedication => 'Failed to delete medication:';

  @override
  String get yourMedications => 'Your Medications';

  @override
  String get noMedicationsYet => 'No medications yet.';

  @override
  String get addMedicationToGetStarted => 'Add a medication to get started.';

  @override
  String get take => 'Take';

  @override
  String get historyScreenTitle => 'Dose History';

  @override
  String get noDoseHistoryAvailable => 'No dose history available.';

  @override
  String doseAt(String time) {
    return 'Dose at $time';
  }

  @override
  String doseDetails(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String get markAsTaken => 'Mark as Taken';

  @override
  String get markAsSkipped => 'Mark as Skipped';

  @override
  String get markAsPending => 'Mark as Pending';

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Are you sure you want to delete this medication?';

  @override
  String get noDosesInCategory => 'No doses in this category.';

  @override
  String get status => 'Status';

  @override
  String get confirmAction => 'Confirm Action';

  @override
  String areYouSureYouWantToMarkThisDoseAs(String status) {
    return 'Are you sure you want to mark this dose as $status?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String dailyDose(String time) {
    return 'Daily at $time';
  }

  @override
  String specificDaysDose(String days, String time) {
    return 'On $days at $time';
  }

  @override
  String intervalDose(String interval, String time) {
    return 'Every $interval hours, at $time';
  }

  @override
  String oneTimeDose(String date, String time) {
    return 'One-time dose on $date at $time';
  }

  @override
  String medicationDosage(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String doseAtTime(String dosage, String unit, String time) {
    return '$dosage $unit at $time';
  }

  @override
  String startDateLabel(String date) {
    return 'Start: $date';
  }

  @override
  String endDateLabel(String date) {
    return 'End: $date';
  }

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get duration => 'Duration';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get ongoing => 'Ongoing';

  @override
  String onDays(String days, String time) {
    return 'On $days at $time';
  }

  @override
  String get arabic => 'Arabic';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseAddTime => 'Please add a time';

  @override
  String get clear => 'Clear';

  @override
  String get pills => 'pills';

  @override
  String get oneTime => 'One-time';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get dateTime => 'Date and Time';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get medicationHistory => 'Medication History';

  @override
  String get noDoseHistoryYet => 'No dose history yet.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get pending => 'Pending';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get appVersion => 'App Version';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get appearance => 'Appearance';

  @override
  String get about => 'About';

  @override
  String get languageName => 'English';

  @override
  String get couldNotLaunchUrl => 'Could not launch URL';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get security => 'Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get doseNotifications => 'Dose Notifications';

  @override
  String get reminders => 'Reminders';

  @override
  String get help => 'Help';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get version => 'Version';

  @override
  String get statistics => 'Statistics';

  @override
  String get schedule => 'Schedule';

  @override
  String get endDate => 'End Date';

  @override
  String get on => 'On';

  @override
  String get every => 'Every';

  @override
  String get hours => 'hours';
}
