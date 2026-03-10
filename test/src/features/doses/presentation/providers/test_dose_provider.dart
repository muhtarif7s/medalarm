// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'test_dose_provider.mocks.dart';

@GenerateMocks([DoseScheduleRepository, MedicationProvider])
void main() {
  group('DoseProvider', () {
    late DoseProvider doseProvider;
    late MockDoseScheduleRepository mockDoseScheduleRepository;
    late MockMedicationProvider mockMedicationProvider;

    setUp(() {
      mockDoseScheduleRepository = MockDoseScheduleRepository();
      mockMedicationProvider = MockMedicationProvider();
      doseProvider =
          DoseProvider(mockDoseScheduleRepository, mockMedicationProvider);
    });

    test('loadDosesForDay loads doses for the selected day', () async {
      // GIVEN
      final date = DateTime.now();
      final expectedDoses = [
        DoseSchedule(
          id: 1,
          medicationId: 1,
          scheduledTime: date,
          status: DoseStatus.pending,
        ),
      ];
      when(mockDoseScheduleRepository.getDoseSchedulesForDay(date))
          .thenAnswer((_) async => expectedDoses);

      // WHEN
      await doseProvider.loadDosesForDay(date);

      // THEN
      expect(doseProvider.doses, expectedDoses);
      verify(mockDoseScheduleRepository.getDoseSchedulesForDay(date));
    });

    test('takeDose updates the dose status and reloads medications and doses', () async {
      // GIVEN
      final dose = DoseSchedule(
        id: 1,
        medicationId: 1,
        scheduledTime: DateTime.now(),
        status: DoseStatus.pending,
      );
      when(mockDoseScheduleRepository.updateDoseScheduleStatus(dose.id!, DoseStatus.taken))
          .thenAnswer((_) async => Future.value());
      when(mockMedicationProvider.loadMedications()).thenAnswer((_) async => Future.value());
      when(mockDoseScheduleRepository.getDoseSchedulesForDay(dose.scheduledTime))
          .thenAnswer((_) async => []);

      // WHEN
      await doseProvider.takeDose(dose);

      // THEN
      verify(mockDoseScheduleRepository.updateDoseScheduleStatus(dose.id!, DoseStatus.taken));
      verify(mockMedicationProvider.loadMedications());
      verify(mockDoseScheduleRepository.getDoseSchedulesForDay(dose.scheduledTime));
    });
  });
}
