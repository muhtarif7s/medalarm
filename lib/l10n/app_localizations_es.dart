// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get addMedication => 'Agregar Medicamento';

  @override
  String get medicationName => 'Nombre del Medicamento';

  @override
  String get pleaseEnterName => 'Por favor, ingrese un nombre de medicamento';

  @override
  String get dosage => 'Dosis';

  @override
  String get pleaseEnterDosage => 'Por favor, ingrese una dosis';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get unitExample => 'Unidad (ej. mg, ml)';

  @override
  String get pleaseEnterUnit => 'Por favor, ingrese una unidad';

  @override
  String get stock => 'Existencias';

  @override
  String get invalidStock => 'Existencias inválidas';

  @override
  String get saveMedication => 'Guardar Medicamento';

  @override
  String get editMedication => 'Editar Medicamento';

  @override
  String get deleteMedication => 'Eliminar Medicamento';

  @override
  String get thisActionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get daily => 'Diario';

  @override
  String get specificDaysInWeek => 'Días específicos de la semana';

  @override
  String get interval => 'Intervalo';

  @override
  String get intervalHours => 'Intervalo en horas';

  @override
  String get daysOfTheWeek => 'Días de la semana';

  @override
  String get times => 'Horas';

  @override
  String get addTime => 'Agregar Hora';

  @override
  String get startDate => 'Fecha de Inicio';

  @override
  String get endDateOptional => 'Fecha de Finalización (Opcional)';

  @override
  String get notSet => 'No establecido';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuración';

  @override
  String get medications => 'Medicamentos';

  @override
  String get noMedications => 'No se han agregado medicamentos aún.';

  @override
  String get addYourFirstMedication => 'Agregue su primer medicamento';

  @override
  String get dosesFor => 'Dosis para';

  @override
  String get noDoses => 'No hay dosis programadas para este día.';

  @override
  String get all => 'Todo';

  @override
  String get taken => 'Tomado';

  @override
  String get missed => 'Omitido';

  @override
  String get theme => 'Tema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get system => 'Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get noRecords => 'No se encontraron registros.';

  @override
  String get pleaseEnterAValidDosage => 'Por favor, ingrese una dosis válida';

  @override
  String get pleaseEnterAValidStock => 'Por favor, ingrese existencias válidas';

  @override
  String get failedToSaveMedication => 'Error al guardar el medicamento:';

  @override
  String get failedToDeleteMedication => 'Error al eliminar el medicamento:';

  @override
  String get yourMedications => 'Sus Medicamentos';

  @override
  String get noMedicationsYet => 'Aún no hay medicamentos.';

  @override
  String get addMedicationToGetStarted =>
      'Agregue un medicamento para comenzar.';

  @override
  String get take => 'Tomar';

  @override
  String get historyScreenTitle => 'Historial de Dosis';

  @override
  String get noDoseHistoryAvailable => 'No hay historial de dosis disponible.';

  @override
  String doseAt(String time) {
    return 'Dosis a las $time';
  }

  @override
  String doseDetails(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String get markAsTaken => 'Marcar como Tomado';

  @override
  String get markAsSkipped => 'Marcar como Omitido';

  @override
  String get markAsPending => 'Marcar como Pendiente';

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      '¿Está seguro de que desea eliminar este medicamento?';

  @override
  String get noDosesInCategory => 'No hay dosis en esta categoría.';

  @override
  String get status => 'Estado';

  @override
  String get confirmAction => 'Confirmar Acción';

  @override
  String areYouSureYouWantToMarkThisDoseAs(String status) {
    return '¿Está seguro de que desea marcar esta dosis como $status?';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String dailyDose(String time) {
    return 'Diariamente a las $time';
  }

  @override
  String specificDaysDose(String days, String time) {
    return 'En $days a las $time';
  }

  @override
  String intervalDose(String interval, String time) {
    return 'Cada $interval horas, a las $time';
  }

  @override
  String oneTimeDose(String date, String time) {
    return 'Dosis única el $date a las $time';
  }

  @override
  String medicationDosage(String dosage, String unit) {
    return '$dosage $unit';
  }

  @override
  String doseAtTime(String dosage, String unit, String time) {
    return '$dosage $unit a las $time';
  }

  @override
  String startDateLabel(String date) {
    return 'Inicio: $date';
  }

  @override
  String endDateLabel(String date) {
    return 'Fin: $date';
  }

  @override
  String get mondayShort => 'Lun';

  @override
  String get tuesdayShort => 'Mar';

  @override
  String get wednesdayShort => 'Mié';

  @override
  String get thursdayShort => 'Jue';

  @override
  String get fridayShort => 'Vie';

  @override
  String get saturdayShort => 'Sáb';

  @override
  String get sundayShort => 'Dom';

  @override
  String get scheduled => 'Programado';

  @override
  String get duration => 'Duración';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get ongoing => 'En curso';

  @override
  String onDays(String days, String time) {
    return 'En $days a las $time';
  }

  @override
  String get arabic => 'Árabe';

  @override
  String get loading => 'Cargando...';

  @override
  String get pleaseAddTime => 'Por favor, agregue una hora';

  @override
  String get clear => 'Limpiar';

  @override
  String get pills => 'píldoras';

  @override
  String get oneTime => 'Una vez';

  @override
  String get weekdays => 'Días de la semana';

  @override
  String get dateTime => 'Fecha y Hora';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get medicationHistory => 'Historial de Medicamentos';

  @override
  String get noDoseHistoryYet => 'Aún no hay historial de dosis.';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get pending => 'Pendiente';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get appVersion => 'Versión de la Aplicación';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get appearance => 'Apariencia';

  @override
  String get about => 'Acerca de';

  @override
  String get languageName => 'Español';

  @override
  String get couldNotLaunchUrl => 'No se pudo abrir la URL';

  @override
  String get profile => 'Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get security => 'Seguridad';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get doseNotifications => 'Notificaciones de Dosis';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get help => 'Ayuda';

  @override
  String get termsAndConditions => 'Términos y Condiciones';

  @override
  String get version => 'Versión';

  @override
  String get statistics => 'Estadísticas';

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
