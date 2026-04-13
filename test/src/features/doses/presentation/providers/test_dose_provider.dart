import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';

class MockDoseRepository extends Mock implements DoseRepository {}

@GenerateMocks([DoseRepository])
void main() {
  group('DoseProvider', () {
    late DoseProvider doseProvider;
    late MockDoseRepository mockDoseRepository;

    setUp(() {
      mockDoseRepository = MockDoseRepository();
      doseProvider = DoseProvider(mockDoseRepository);
    });

    test('loadDosesForDay loads doses for the selected day', () async {
      // GIVEN
      final date = DateTime.now();
      final expectedDoses = [
        Dose(
          id: 1,
          medicationId: 1,
          time: date,
          status: DoseStatus.pending,
        ),
      ];
      when(mockDoseRepository.getDosesForDay(date))
          .thenAnswer((_) async => expectedDoses);

      // WHEN
      await doseProvider.loadDosesForDay(date);

      // THEN
      expect(doseProvider.doses, expectedDoses);
      verify(mockDoseRepository.getDosesForDay(date));
    });

    test('takeDose updates the dose status and reloads medications and doses',
        () async {
      // GIVEN
      final dose = Dose(
        id: 1,
        medicationId: 1,
        time: DateTime.now(),
        status: DoseStatus.pending,
      );
      when(mockDoseRepository
              .updateDose(dose.copyWith(status: DoseStatus.taken)))
          .thenAnswer((_) async => Future.value());
      when(mockDoseRepository.getDosesForDay(dose.time))
          .thenAnswer((_) async => []);

      // WHEN
      await doseProvider.takeDose(dose);

      // THEN
      verify(mockDoseRepository
          .updateDose(dose.copyWith(status: DoseStatus.taken)));
      verify(mockDoseRepository.getDosesForDay(dose.time));
    });
  });
}
