// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get pleaseEnterName => 'الرجاء إدخال اسم';

  @override
  String get dosage => 'الجرعة';

  @override
  String get pleaseEnterDosage => 'الرجاء إدخال جرعة';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get unitExample => 'الوحدة (مثل ملغ، حبة)';

  @override
  String get pleaseEnterUnit => 'الرجاء إدخال وحدة';

  @override
  String get stock => 'المخزون';

  @override
  String get invalidStock => 'مخزون غير صالح';

  @override
  String get saveMedication => 'حفظ الدواء';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get deleteMedication => 'حذف الدواء';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get daily => 'يوميًا';

  @override
  String get specificDaysInWeek => 'أيام محددة في الأسبوع';

  @override
  String get interval => 'فاصل زمني';

  @override
  String get intervalHours => 'الفاصل الزمني (بالساعات)';

  @override
  String get daysOfTheWeek => 'أيام الأسبوع';

  @override
  String get times => 'الأوقات';

  @override
  String get addTime => 'إضافة وقت';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDateOptional => 'تاريخ الانتهاء (اختياري)';

  @override
  String get notSet => 'غير محدد';

  @override
  String get home => 'الرئيسية';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get medications => 'الأدوية';

  @override
  String get noMedications => 'لا توجد أدوية حتى الآن.';

  @override
  String get addYourFirstMedication => 'أضف دوائك الأول';

  @override
  String get dosesFor => 'جرعات لـ';

  @override
  String get noDoses => 'لا توجد جرعات مجدولة لهذا اليوم.';

  @override
  String get all => 'الكل';

  @override
  String get taken => 'تم تناولها';

  @override
  String get missed => 'الفائتة';

  @override
  String get theme => 'السمة';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get noRecords => 'لا توجد سجلات.';

  @override
  String get pleaseEnterAValidDosage => 'يرجى إدخال جرعة صالحة';

  @override
  String get pleaseEnterAValidStock => 'يرجى إدخال مخزون صالح';

  @override
  String get failedToSaveMedication => 'فشل حفظ الدواء:';

  @override
  String get failedToDeleteMedication => 'فشل حذف الدواء:';

  @override
  String get yourMedications => 'أدويتك';

  @override
  String get noMedicationsYet => 'لا توجد أدوية بعد.';

  @override
  String get addMedicationToGetStarted => 'أضف دواء للبدء.';

  @override
  String get take => 'تناول';

  @override
  String get historyScreenTitle => 'سجل الجرعات';

  @override
  String get noDoseHistoryAvailable => 'لا يوجد سجل جرعات متاح.';

  @override
  String doseAt(String time) {
    return 'جرعة في $time';
  }

  @override
  String doseDetails(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String get markAsTaken => 'وضع علامة كـ تم تناولها';

  @override
  String get markAsSkipped => 'وضع علامة كـ تم تخطيها';

  @override
  String get markAsPending => 'وضع علامة كـ معلقة';

  @override
  String get helloWorld => 'مرحبًا بالعالم!';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      'هل أنت متأكد أنك تريد حذف هذا الدواء؟';

  @override
  String get noDosesInCategory => 'لا توجد جرعات في هذه الفئة.';

  @override
  String get status => 'الحالة';

  @override
  String get confirmAction => 'تأكيد الإجراء';

  @override
  String areYouSureYouWantToMarkThisDoseAs(String status) {
    return 'هل أنت متأكد أنك تريد تحديد هذه الجرعة كـ $status؟';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String dailyDose(String time) {
    return 'يوميًا في الساعة $time';
  }

  @override
  String specificDaysDose(String days, String time) {
    return 'في أيام $days الساعة $time';
  }

  @override
  String intervalDose(String interval, String time) {
    return 'كل $interval ساعات, في $time';
  }
}
