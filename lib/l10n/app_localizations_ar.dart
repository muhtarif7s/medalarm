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
  String get pleaseEnterName => 'الرجاء إدخال اسم الدواء';

  @override
  String get dosage => 'الجرعة';

  @override
  String get pleaseEnterDosage => 'يرجى إدخال الجرعة';

  @override
  String get invalidNumber => 'رقم غير صالح';

  @override
  String get unitExample => 'الوحدة (مثل ملجم، مل)';

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
  String get intervalHours => 'الفاصل الزمني بالساعات';

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
  String get notSet => 'لم يتم التعيين';

  @override
  String get home => 'الرئيسية';

  @override
  String get history => 'السجل';

  @override
  String get settings => 'الإعدادات';

  @override
  String get medications => 'الأدوية';

  @override
  String get noMedications => 'لم تتم إضافة أي أدوية حتى الآن.';

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
  String get missed => 'تم تفويتها';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get noRecords => 'لم يتم العثور على سجلات.';

  @override
  String get pleaseEnterAValidDosage => 'الرجاء إدخال جرعة صالحة';

  @override
  String get pleaseEnterAValidStock => 'الرجاء إدخال مخزون صالح';

  @override
  String get failedToSaveMedication => 'فشل حفظ الدواء:';

  @override
  String get failedToDeleteMedication => 'فشل حذف الدواء:';

  @override
  String get yourMedications => 'أدويتك';

  @override
  String get noMedicationsYet => 'لا توجد أدوية حتى الآن.';

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
    return 'يوميًا في $time';
  }

  @override
  String specificDaysDose(String days, String time) {
    return 'في $days في $time';
  }

  @override
  String intervalDose(String interval, String time) {
    return 'كل $interval ساعات، في $time';
  }

  @override
  String oneTimeDose(String date, String time) {
    return 'جرعة لمرة واحدة في $date في $time';
  }

  @override
  String medicationDosage(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String doseAtTime(String dosage, String unit, String time) {
    return '$dosage $unit في $time';
  }

  @override
  String startDateLabel(String date) {
    return 'البداية: $date';
  }

  @override
  String endDateLabel(String date) {
    return 'النهاية: $date';
  }

  @override
  String get mondayShort => 'إث';

  @override
  String get tuesdayShort => 'ثل';

  @override
  String get wednesdayShort => 'أر';

  @override
  String get thursdayShort => 'خم';

  @override
  String get fridayShort => 'جم';

  @override
  String get saturdayShort => 'سب';

  @override
  String get sundayShort => 'أح';

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
  String onDays(String days, String time) {
    return 'في $days في $time';
  }

  @override
  String get arabic => 'العربية';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get pleaseAddTime => 'الرجاء إضافة وقت';

  @override
  String get clear => 'مسح';

  @override
  String get pills => 'حبوب';

  @override
  String get oneTime => 'مرة واحدة';

  @override
  String get weekdays => 'أيام الأسبوع';

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
  String get medicationHistory => 'سجل الأدوية';

  @override
  String get noDoseHistoryYet => 'لا يوجد سجل جرعات حتى الآن.';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'الأمس';

  @override
  String get pending => 'معلقة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get appearance => 'المظهر';

  @override
  String get about => 'حول';

  @override
  String get languageName => 'العربية';

  @override
  String get couldNotLaunchUrl => 'تعذر فتح الرابط';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get security => 'الأمان';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get doseNotifications => 'إشعارات الجرعة';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get help => 'المساعدة';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get version => 'الإصدار';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get schedule => 'جدولة';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get on => 'في';

  @override
  String get every => 'كل';

  @override
  String get hours => 'ساعات';
}
