import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/services/dose_service.dart';

import 'dose_service_test.mocks.dart';

@GenerateMocks([DoseRepository, MedicationRepository, BuildContext, NavigatorObserver])
void main() {
  late DoseService doseService;
  late MockDoseRepository mockDoseRepository;
  late MockMedicationRepository mockMedicationRepository;

  setUp(() {
    mockDoseRepository = MockDoseRepository();
    mockMedicationRepository = MockMedicationRepository();
    doseService = DoseService(
      doseRepository: mockDoseRepository,
      medicationRepository: mockMedicationRepository,
    );
  });

  test('takeDose decreases stock and updates dose status', () async {
    final dose = Dose(
      id: 1,
      medicationId: 1,
      time: DateTime.now(),
      status: DoseStatus.pending,
    );
    final medication = Medication(
      id: 1,
      name: 'Test Medication',
      dosage: 1,
      unit: 'pill',
      stock: 10,
      scheduleType: MedicationScheduleType.daily,
      times: [const TimeOfDay(hour: 8, minute: 0)],
      startDate: DateTime.now(),
      remainingDoses: 1,
      takenToday: false,
    );

    when(mockDoseRepository.getDose(1)).thenAnswer((_) async => dose);
    when(mockMedicationRepository.getMedication(1))
        .thenAnswer((_) async => medication);
    when(mockDoseRepository.updateDoseStatus(1, DoseStatus.taken))
        .thenAnswer((_) async => Future.value());
    when(mockMedicationRepository.updateMedication(any))
        .thenAnswer((_) async => Future.value());

    await doseService.takeDose(1, MockBuildContext());

    verify(mockDoseRepository.updateDoseStatus(1, DoseStatus.taken)).called(1);
    final captured = verify(mockMedicationRepository.updateMedication(captureAny)).captured;
    final updatedMedication = captured.first as Medication;
    expect(updatedMedication.stock, 9);
    expect(updatedMedication.takenToday, true);
    expect(updatedMedication.remainingDoses, 0);
  });
}
