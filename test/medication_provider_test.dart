// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'medication_provider_test.mocks.dart';

@GenerateMocks([MedicationRepository, DoseScheduleRepository],
    customMocks: [MockSpec<DoseRepository>(as: #MockDoseRepositoryForMed)])
void main() {
  group('MedicationProvider', () {
    late MockMedicationRepository mockMedicationRepository;
    late MockDoseScheduleRepository mockDoseScheduleRepository;
    late MedicationProvider medicationProvider;

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      mockDoseScheduleRepository = MockDoseScheduleRepository();
      medicationProvider = MedicationProvider(
          mockMedicationRepository, mockDoseScheduleRepository);
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
      when(mockMedicationRepository.getAllMedicationsOnce())
          .thenAnswer((_) async => medications);
      // Re-initialize the provider to pick up the new stub.
      medicationProvider = MedicationProvider(
          mockMedicationRepository, mockDoseScheduleRepository);

      // Act
      await medicationProvider.loadMedications();

      // Assert
      expect(medicationProvider.medications, medications);
    });
  });
}
