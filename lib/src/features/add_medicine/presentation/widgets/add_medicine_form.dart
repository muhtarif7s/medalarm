import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/frequency_selector.dart';
import 'package:myapp/src/features/add_medicine/presentation/widgets/start_date_selector.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';

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
  final _stockController = TextEditingController();

  MedicationScheduleType _scheduleType = MedicationScheduleType.daily;
  DateTime _selectedDate = DateTime.now();
  final List<TimeOfDay> _times = [const TimeOfDay(hour: 8, minute: 0)];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveMedication() async {
    if (_formKey.currentState?.validate() ?? false) {
      final l10n = AppLocalizations.of(context)!;
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      try {
        final dosage = double.tryParse(_dosageController.text);
        final stock = int.tryParse(_stockController.text);

        if (dosage == null) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.pleaseEnterAValidDosage)),
          );
          return;
        }

        if (stock == null) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.pleaseEnterAValidStock)),
          );
          return;
        }

        final newMedication = Medication(
          name: _nameController.text,
          dosage: dosage,
          unit: _unitController.text,
          stock: stock,
          times: _times,
          scheduleType: _scheduleType,
          startDate: _selectedDate,
          remainingDoses: stock,
        );
        await Provider.of<MedicationProvider>(context, listen: false).addMedication(newMedication);
        navigator.pop();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('${l10n.failedToSaveMedication} $e')),
        );
      }
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
                filled: true,
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
                filled: true,
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
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterUnit;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: l10n.stock,
                border: const OutlineInputBorder(),
                filled: true,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || int.tryParse(value) == null) {
                  return l10n.invalidNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FrequencySelector(
              onChanged: (frequency) {
                if (mounted) {
                  setState(() {
                    _scheduleType = MedicationScheduleType.values.byName(frequency);
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            StartDateSelector(
              onChanged: (date) {
                if (mounted) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
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
