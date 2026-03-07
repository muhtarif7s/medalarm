import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/services/dose_service.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';

import 'medication_provider_test.mocks.dart';

// Generate mocks for MedicationRepository, DoseService, and NotificationService
@GenerateMocks([
  MedicationRepository,
  DoseService,
  NotificationService,
])
void main() {
  group('MedicationProvider', () {
    late MedicationProvider medicationProvider;
    late MockMedicationRepository mockMedicationRepository;
    late MockDoseService mockDoseService;
    late MockNotificationService mockNotificationService;

    setUp(() {
      // Create new mocks for each test
      mockMedicationRepository = MockMedicationRepository();
      mockDoseService = MockDoseService();
      mockNotificationService = MockNotificationService();

      // Setup default stubs for methods that are called but not the focus of the test
      when(mockDoseService.createDosesForMedication(any)).thenAnswer((_) async {});
      when(mockNotificationService.scheduleNotifications(any, any, any))
          .thenAnswer((_) async {});
      when(mockMedicationRepository.getAllMedications()).thenAnswer((_) async => []);

      medicationProvider = MedicationProvider(
        medicationRepository: mockMedicationRepository,
        doseService: mockDoseService,
        notificationService: mockNotificationService,
      );
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
          times: const [TimeOfDay(hour: 10, minute: 0)],
        )
      ];
      // Override the default stub for this specific test
      when(mockMedicationRepository.getAllMedications())
          .thenAnswer((_) async => medications);

      // Act
      await medicationProvider.loadMedications();

      // Assert
      expect(medicationProvider.medications, medications);
      verify(mockMedicationRepository.getAllMedications()).called(1);
    });

    test('addMedication should call dependencies and reload', () async {
      // Arrange
      final medicationToAdd = Medication(
        name: 'Med 2',
        dosage: 20,
        unit: 'mg',
        scheduleType: MedicationScheduleType.daily,
        startDate: DateTime.now(),
        times: const [TimeOfDay(hour: 10, minute: 0)],
      );
      const medicationId = 2;
      final addedMedication = medicationToAdd.copyWith(id: medicationId);

      when(mockMedicationRepository.addMedication(medicationToAdd))
          .thenAnswer((_) async => medicationId);

      // Stub the reload call
      when(mockMedicationRepository.getAllMedications())
          .thenAnswer((_) async => [addedMedication]);

      // Act
      await medicationProvider.addMedication(medicationToAdd);

      // Assert
      // Verify that the correct methods were called on the mocks
      verify(mockMedicationRepository.addMedication(medicationToAdd));
      verify(mockDoseService.createDosesForMedication(addedMedication));
      verify(mockNotificationService.scheduleNotifications(
          addedMedication,
          'Medication Due: ${addedMedication.name}',
          'It\'s time to take your dose of ${addedMedication.name}.'));

      // Verify that medications were reloaded
      verify(mockMedicationRepository.getAllMedications()).called(1);

      // Verify the final state
      expect(medicationProvider.medications.length, 1);
      expect(medicationProvider.medications.first.name, 'Med 2');
    });
  });
}
