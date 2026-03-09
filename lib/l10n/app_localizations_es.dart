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
  String get pleaseEnterName => 'Por favor, ingrese un nombre';

  @override
  String get dosage => 'Dosis';

  @override
  String get pleaseEnterDosage => 'Por favor, ingrese una dosis';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get unitExample => 'Unidad (ej. mg, pastilla)';

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
  String get intervalHours => 'Intervalo (horas)';

  @override
  String get daysOfTheWeek => 'Días de la semana';

  @override
  String get times => 'Horas';

  @override
  String get addTime => 'Agregar hora';

  @override
  String get startDate => 'Fecha de inicio';

  @override
  String get endDateOptional => 'Fecha de finalización (Opcional)';

  @override
  String get notSet => 'No establecido';

  @override
  String get home => 'Inicio';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Ajustes';

  @override
  String get medications => 'Medicamentos';

  @override
  String get noMedications => 'No hay medicamentos todavía.';

  @override
  String get addYourFirstMedication => 'Agrega tu primer medicamento';

  @override
  String get dosesFor => 'Dosis para';

  @override
  String get noDoses => 'No hay dosis programadas para este día.';

  @override
  String get all => 'Todo';

  @override
  String get taken => 'Tomada';

  @override
  String get missed => 'Omitidas';

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
  String get noRecords => 'No hay registros.';

  @override
  String get pleaseEnterAValidDosage => 'Por favor, ingrese una dosis válida';

  @override
  String get pleaseEnterAValidStock => 'Por favor, ingrese existencias válidas';

  @override
  String get failedToSaveMedication => 'Error al guardar el medicamento:';

  @override
  String get failedToDeleteMedication => 'Error al eliminar el medicamento:';

  @override
  String get yourMedications => 'Tus Medicamentos';

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
  String get markAsTaken => 'Marcar como tomada';

  @override
  String get markAsSkipped => 'Marcar como omitida';

  @override
  String get markAsPending => 'Marcar como pendiente';

  @override
  String get helloWorld => '¡Hola Mundo!';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String get areYouSureYouWantToDeleteThisMedication =>
      '¿Estás seguro de que quieres eliminar este medicamento?';

  @override
  String get noDosesInCategory => 'No hay dosis en esta categoría.';

  @override
  String get status => 'Estado';

  @override
  String get confirmAction => 'Confirmar acción';

  @override
  String areYouSureYouWantToMarkThisDoseAs(String status) {
    return '¿Estás seguro de que quieres marcar esta dosis como $status?';
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
}
