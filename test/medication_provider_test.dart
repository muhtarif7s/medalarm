import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';

import 'medication_provider_test.mocks.dart';

@GenerateMocks([MedicationRepository])
void main() {
  group('MedicationProvider', () {
    late MedicationProvider medicationProvider;
    late MockMedicationRepository mockMedicationRepository;

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      medicationProvider = MedicationProvider();
    });

    test('loadMedications should fetch medications from the repository', () async {
      // Arrange
      final medications = [
        Medication(
          id: 1,
          name: 'Med 1',
          dosage: 10,
          unit: 'mg',
          scheduleType: MedicationScheduleType.daily,
          startDate: DateTime.now(),
          times: [const TimeOfDay(hour: 10, minute: 0)],
        )
      ];
      when(mockMedicationRepository.getAll()).thenAnswer((_) async => medications);

      // Act
      await medicationProvider.loadMedications();

      // Assert
      expect(medicationProvider.medications, medications);
      verify(mockMedicationRepository.getAll());
    });

    test('addMedication should add a medication and notify listeners', () async {
      // Arrange
      final medication = Medication(
        name: 'Med 2',
        dosage: 20,
        unit: 'mg',
        scheduleType: MedicationScheduleType.daily,
        startDate: DateTime.now(),
        times: [const TimeOfDay(hour: 10, minute: 0)],
      );
      final newMedication = Medication(
        id: 2,
        name: 'Med 2',
        dosage: 20,
        unit: 'mg',
        scheduleType: MedicationScheduleType.daily,
        startDate: DateTime.now(),
        times: [const TimeOfDay(hour: 10, minute: 0)],
      );
      when(mockMedicationRepository.insert(medication)).thenAnswer((_) async => newMedication.id!);

      // Act
      await medicationProvider.addMedication(medication);

      // Assert
      expect(medicationProvider.medications.length, 1);
      expect(medicationProvider.medications.first.name, 'Med 2');
      verify(mockMedicationRepository.insert(medication));
    });
  });
}
