// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageName => 'English';

  @override
  String get appearance => 'Appearance';

  @override
  String get about => 'About';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get appVersion => 'App Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get couldNotLaunchUrl => 'Could not launch URL';

  @override
  String get oneTime => 'One-time';

  @override
  String get daily => 'Daily';

  @override
  String get weekdays => 'Weekdays';

  @override
  String get interval => 'Interval';

  @override
  String get dateTime => 'Date & Time';

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
  String get editMedication => 'Edit Medication';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get deleteMedication => 'Delete Medication';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get dosage => 'Dosage';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get unitExample => 'Unit (e.g., mg, pill)';

  @override
  String get pleaseEnterUnit => 'Please enter a unit';

  @override
  String get scheduleType => 'Schedule Type';

  @override
  String get daysOfTheWeek => 'Days of the Week';

  @override
  String get intervalHours => 'Interval (hours)';

  @override
  String get times => 'Times';

  @override
  String get addTime => 'Add Time';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDateOptional => 'End Date (Optional)';

  @override
  String get notSet => 'Not Set';

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get medicationHistory => 'Medication History';

  @override
  String get noDoseHistoryYet => 'No dose history yet.';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get taken => 'Taken';

  @override
  String get skipped => 'Skipped';

  @override
  String get pending => 'Pending';

  @override
  String oneTimeDose(Object date, Object time) {
    return 'One-time dose on $date at $time';
  }

  @override
  String dailyDose(Object time) {
    return 'Daily at $time';
  }

  @override
  String specificDaysDose(Object days, Object time) {
    return '$days at $time';
  }

  @override
  String intervalDose(Object interval, Object time) {
    return 'Every $interval hours at $time';
  }

  @override
  String medicationDosage(Object dosage, Object unit) {
    return '$dosage $unit';
  }

  @override
  String doseAtTime(Object dosage, Object time, Object unit) {
    return '$dosage $unit at $time';
  }

  @override
  String startDateLabel(Object date) {
    return 'Start: $date';
  }

  @override
  String endDateLabel(Object date) {
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
  String get noMedicationsYet => 'No medications yet.';

  @override
  String get addMedicationToGetStarted => 'Add a medication to get started.';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'Are you sure you want to delete this medication?';

  @override
  String get doseHistory => 'Dose History';

  @override
  String get noDoseHistoryAvailable => 'No dose history available.';

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
  String onDays(Object days, Object time) {
    return 'On $days at $time';
  }

  @override
  String get noDosesInCategory => 'No doses in this category.';

  @override
  String get status => 'Status';

  @override
  String get confirmAction => 'Confirm Action';

  @override
  String areYouSureYouWantToMarkThisDoseAs(Object status) {
    return 'Are you sure you want to mark this dose as $status?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get markAsTaken => 'Mark as Taken';

  @override
  String get markAsSkipped => 'Mark as Skipped';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get loading => '...';
}
