import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:flutter/material.dart';

import 'medication_provider_test.mocks.dart';

@GenerateMocks([MedicationRepository, DoseScheduleRepository])
void main() {
  group('MedicationProvider', () {
    late MockMedicationRepository mockMedicationRepository;
    late MockDoseScheduleRepository mockDoseScheduleRepository;
    late MedicationProvider medicationProvider;

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      mockDoseScheduleRepository = MockDoseScheduleRepository();
      when(mockMedicationRepository.allMedications).thenAnswer((_) => Stream.value([]));
      when(mockMedicationRepository.fetchAllMedications()).thenAnswer((_) async {});
      medicationProvider = MedicationProvider(mockMedicationRepository, mockDoseScheduleRepository);
    });

    test('should load medications from the repository', () async {
      // Arrange
      final medications = [
        Medication(
          id: 1,
          name: 'Medication 1',
          dosage: 1.0,
          unit: 'mg',
          scheduleType: MedicationScheduleType.daily,
          times: const [TimeOfDay(hour: 8, minute: 0)],
          stock: 10,
          remainingDoses: 10,
          startDate: DateTime.now(),
        ),
        Medication(
          id: 2,
          name: 'Medication 2',
          dosage: 2.0,
          unit: 'mg',
          scheduleType: MedicationScheduleType.daily,
          times: const [TimeOfDay(hour: 8, minute: 0)],
          stock: 20,
          remainingDoses: 20,
          startDate: DateTime.now(),
        ),
      ];
      when(mockMedicationRepository.allMedications).thenAnswer((_) => Stream.value(medications));
      // Re-initialize the provider to pick up the new stub.
      medicationProvider = MedicationProvider(mockMedicationRepository, mockDoseScheduleRepository);


      // Act
      // The medications are loaded in the constructor, so no need to call loadMedications()
      
      // We need to wait for the stream to emit and the provider to notify listeners.
      await Future.delayed(Duration.zero);

      // Assert
      expect(medicationProvider.medications, medications);
    });
  });
}
