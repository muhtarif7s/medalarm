import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';

class DoseProvider with ChangeNotifier {
  final DoseRepository _doseRepository;

  DoseProvider(this._doseRepository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Dose> _doses = [];
  List<Dose> get doses => _doses;

  final Map<DateTime, List<Dose>> _groupedDosesByDay = {};
  Map<DateTime, List<Dose>> get groupedDosesByDay => _groupedDosesByDay;


  Future<void> loadDosesForDay(DateTime date) async {
    _isLoading = true;
    notifyListeners();
    _doses = await _doseRepository.getDosesForDay(date);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAllDoses() async {
    _isLoading = true;
    notifyListeners();
    final allDoses = await _doseRepository.getAllDoses();
    _groupDosesByDay(allDoses);
    _isLoading = false;
    notifyListeners();
  }

  void _groupDosesByDay(List<Dose> doses) {
    _groupedDosesByDay.clear();
    for (final dose in doses) {
      final date = DateTime(dose.time.year, dose.time.month, dose.time.day);
      if (_groupedDosesByDay.containsKey(date)) {
        _groupedDosesByDay[date]!.add(dose);
      } else {
        _groupedDosesByDay[date] = [dose];
      }
    }
  }


  Future<void> takeDose(Dose dose) async {
    final updatedDose = dose.copyWith(status: DoseStatus.taken);
    await _doseRepository.updateDose(updatedDose);
    await loadDosesForDay(dose.time);
  }

  Future<void> updateDoseStatus(Dose dose, DoseStatus status) async {
    final updatedDose = dose.copyWith(status: status);
    await _doseRepository.updateDose(updatedDose);
    await loadDosesForDay(dose.time);
  }
}
