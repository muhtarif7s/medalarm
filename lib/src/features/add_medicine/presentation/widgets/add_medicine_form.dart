import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/frequency_selector.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/start_date_selector.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/time_selector.dart';
import 'package:myapp/src/services/database_service.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({super.key});

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _unitController = TextEditingController();

  MedicationScheduleType _scheduleType = MedicationScheduleType.daily;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();

  final DatabaseService _dbService = SqfliteDatabaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      final newMedication = Medication(
        name: _nameController.text,
        dosage: double.parse(_dosageController.text),
        unit: _unitController.text,
        scheduleType: _scheduleType,
        times: [_selectedTime],
        startDate: _selectedDate,
      );
      await _dbService.insertMedication(newMedication);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.medicationName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: l10n.dosage,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterDosage;
                }
                if (double.tryParse(value) == null) {
                  return l10n.invalidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unitController,
              decoration: InputDecoration(
                labelText: l10n.unitExample,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterUnit;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FrequencySelector(
              onChanged: (frequency) {
                setState(() {
                  _scheduleType = MedicationScheduleType.values.byName(frequency);
                });
              },
            ),
            const SizedBox(height: 16),
            TimeSelector(
              onChanged: (time) {
                setState(() {
                  _selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 16),
            StartDateSelector(
              onChanged: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMedication,
                child: Text(l10n.saveMedication),
              ),
            )
          ],
        ),
      ),
    );
  }
}
