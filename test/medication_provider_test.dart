import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'medication_provider_test.mocks.dart';

@GenerateMocks([MedicationRepository, DoseScheduleRepository])
void main() {
  late MedicationProvider medicationProvider;
  late MockMedicationRepository mockMedicationRepository;
  late MockDoseScheduleRepository mockDoseScheduleRepository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({'lastReset': DateTime.now().toIso8601String().substring(0, 10)});
    mockMedicationRepository = MockMedicationRepository();
    mockDoseScheduleRepository = MockDoseScheduleRepository();
    medicationProvider = MedicationProvider(
      mockMedicationRepository,
      mockDoseScheduleRepository,
    );
  });

  final medication = Medication(
    id: 1,
    name: 'Aspirin',
    dosage: 10,
    unit: 'mg',
    scheduleType: MedicationScheduleType.daily,
    times: [const TimeOfDay(hour: 8, minute: 0)],
    startDate: DateTime.now(),
    remainingDoses: 10,
    stock: 10,
  );

  test('loadMedications should fetch medications from the repository', () async {
    when(mockMedicationRepository.getAllMedications())
        .thenAnswer((_) async => [medication]);
    when(mockDoseScheduleRepository.getDoseSchedulesForMedication(any))
        .thenAnswer((_) async => []);

    await medicationProvider.loadMedications();

    expect(medicationProvider.medications, [medication]);
    verify(mockMedicationRepository.getAllMedications()).called(1);
    verify(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).called(1);
  });

  test('addMedication should add a medication and reload medications', () async {
    when(mockMedicationRepository.addMedication(any)).thenAnswer((_) async => 1);
    when(mockMedicationRepository.getAllMedications()).thenAnswer((_) async => [medication]);
    when(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).thenAnswer((_) async => []);

    await medicationProvider.addMedication(medication);

    verify(mockMedicationRepository.addMedication(any)).called(1);
    verify(mockMedicationRepository.getAllMedications()).called(1);
    verify(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).called(1);
    expect(medicationProvider.medications.length, 1);
  });

  test('updateMedication should update a medication and reload medications', () async {
    final updatedMedication = medication.copyWith(name: 'Aspirin Plus');
    when(mockMedicationRepository.updateMedication(any)).thenAnswer((_) async {});
    when(mockMedicationRepository.getAllMedications()).thenAnswer((_) async => [updatedMedication]);
    when(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).thenAnswer((_) async => []);

    await medicationProvider.updateMedication(updatedMedication);

    verify(mockMedicationRepository.updateMedication(any)).called(1);
    verify(mockMedicationRepository.getAllMedications()).called(1);
    verify(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).called(1);
    expect(medicationProvider.medications[0].name, 'Aspirin Plus');
  });

  test('deleteMedication should delete a medication and reload medications', () async {
    when(mockMedicationRepository.deleteMedication(any)).thenAnswer((_) async {});
    when(mockMedicationRepository.getAllMedications()).thenAnswer((_) async => []);
    when(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).thenAnswer((_) async => []);

    await medicationProvider.deleteMedication(medication.id!);

    verify(mockMedicationRepository.deleteMedication(any)).called(1);
    verify(mockMedicationRepository.getAllMedications()).called(1);
    expect(medicationProvider.medications, isEmpty);
  });
}
