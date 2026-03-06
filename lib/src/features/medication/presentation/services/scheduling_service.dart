import 'package:myapp/src/features/medication/data/models/medication.dart';

class SchedulingService {
  static DateTime? calculateNextDoseTime(Medication medication) {
    // This is a simplified scheduling logic. In a real-world application, this would be much more complex, 
    // handling different schedules (e.g., daily, weekly, specific days of the week), multiple doses per day, etc.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.add(const Duration(days: 1));
  }
}
