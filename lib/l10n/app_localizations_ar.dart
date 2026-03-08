// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get helloWorld => 'مرحباً بالعالم!';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageName => 'العربية';

  @override
  String get appearance => 'المظهر';

  @override
  String get about => 'حول';

  @override
  String get themeMode => 'وضع السمة';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get couldNotLaunchUrl => 'تعذر فتح الرابط';

  @override
  String get oneTime => 'لمرة واحدة';

  @override
  String get daily => 'يومي';

  @override
  String get weekdays => 'أيام الأسبوع';

  @override
  String get interval => 'فترة';

  @override
  String get dateTime => 'التاريخ والوقت';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get deleteMedication => 'حذف الدواء';

  @override
  String get saveMedication => 'حفظ الدواء';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get pleaseEnterName => 'الرجاء إدخال اسم';

  @override
  String get dosage => 'الجرعة';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get unitExample => 'الوحدة (مثلاً، ملغ، حبة)';

  @override
  String get pleaseEnterUnit => 'الرجاء إدخال وحدة';

  @override
  String get scheduleType => 'نوع الجدول';

  @override
  String get daysOfTheWeek => 'أيام الأسبوع';

  @override
  String get intervalHours => 'الفاصل (بالساعات)';

  @override
  String get times => 'الأوقات';

  @override
  String get addTime => 'إضافة وقت';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDateOptional => 'تاريخ الانتهاء (اختياري)';

  @override
  String get notSet => 'لم يتم تعيينه';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get medicationHistory => 'سجل الأدوية';

  @override
  String get noDoseHistoryYet => 'لا يوجد سجل للجرعات حتى الآن.';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'الأمس';

  @override
  String get taken => 'تم أخذها';

  @override
  String get skipped => 'تم تخطيها';

  @override
  String get pending => 'معلقة';

  @override
  String oneTimeDose(Object date, Object time) {
    return 'جرعة لمرة واحدة في $date الساعة $time';
  }

  @override
  String dailyDose(Object time) {
    return 'يوميًا في $time';
  }

  @override
  String specificDaysDose(Object days, Object time) {
    return '$days في $time';
  }

  @override
  String intervalDose(Object interval, Object time) {
    return 'كل $interval ساعات في $time';
  }

  @override
  String medicationDosage(Object dosage, Object unit) {
    return '$dosage $unit';
  }

  @override
  String doseAtTime(Object dosage, Object time, Object unit) {
    return '$dosage $unit في $time';
  }

  @override
  String startDateLabel(Object date) {
    return 'البداية: $date';
  }

  @override
  String endDateLabel(Object date) {
    return 'النهاية: $date';
  }

  @override
  String get mondayShort => 'إثن';

  @override
  String get tuesdayShort => 'ثلا';

  @override
  String get wednesdayShort => 'أرب';

  @override
  String get thursdayShort => 'خمي';

  @override
  String get fridayShort => 'جمعة';

  @override
  String get saturdayShort => 'سبت';

  @override
  String get sundayShort => 'أحد';

  @override
  String get noMedicationsYet => 'لا توجد أدوية حتى الآن.';

  @override
  String get addMedicationToGetStarted => 'أضف دواء للبدء.';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'هل أنت متأكد أنك تريد حذف هذا الدواء؟';

  @override
  String get doseHistory => 'سجل الجرعات';

  @override
  String get noDoseHistoryAvailable => 'لا يوجد سجل جرعات متاح.';

  @override
  String get scheduled => 'مجدول';

  @override
  String get duration => 'المدة';

  @override
  String get start => 'البداية';

  @override
  String get end => 'النهاية';

  @override
  String get ongoing => 'مستمر';

  @override
  String onDays(Object days, Object time) {
    return 'في أيام $days الساعة $time';
  }

  @override
  String get noDosesInCategory => 'لا توجد جرعات في هذه الفئة.';

  @override
  String get status => 'الحالة';

  @override
  String get confirmAction => 'تأكيد الإجراء';

  @override
  String areYouSureYouWantToMarkThisDoseAs(Object status) {
    return 'هل أنت متأكد أنك تريد تحديد هذه الجرعة بأنها $status؟';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String get markAsTaken => 'وضع علامة كـ تم أخذها';

  @override
  String get markAsSkipped => 'وضع علامة كـ تم تخطيها';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get loading => '...';

  @override
  String get pleaseAddTime => 'يرجى إضافة وقت';

  @override
  String get clear => 'مسح';

  @override
  String get pleaseEnterDosage => 'الرجاء إدخال جرعة';

  @override
  String get pills => 'حبات';

  @override
  String get yourMedications => 'أدويتك';

  @override
  String get take => 'خذ';
}
