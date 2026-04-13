// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/medication/models/day_of_week.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final int? medicationId;

  const AddEditMedicationScreen({super.key, this.medicationId});

  @override
  State<AddEditMedicationScreen> createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditMode = false;
  late Medication _medication;
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _remainingDosesController = TextEditingController();

  // UI Colors
  static const _darkBackgroundColor = Color(0xFF121212);
  static const _cardBackgroundColor = Color(0xFF1E1E1E);
  static const _whiteTextColor = Colors.white;
  static const _blueAccentColor = Colors.blue;
  static const _subtleBorderColor = Colors.white24;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.medicationId != null;
    if (_isEditMode) {
      _loadMedicationData();
    } else {
      _medication = _createNewMedication();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMedicationData() async {
    final existingMed = Provider.of<MedicationProvider>(context, listen: false)
        .getMedication(widget.medicationId!);
    if (existingMed != null) {
      setState(() {
        _medication = existingMed;
        _nameController.text = _medication.name;
        _dosageController.text = _medication.dosage.toString();
        _remainingDosesController.text = _medication.remainingDoses.toString();
        _isLoading = false;
      });
    } else {
      // Handle error or medication not found
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.pop(); // or show an error message
      }
    }
  }

  Medication _createNewMedication() {
    return Medication(
      id: DateTime.now().millisecondsSinceEpoch,
      name: '',
      dosage: 1.0,
      unit: 'pill',
      stock: 30,
      scheduleType: MedicationScheduleType.daily,
      times: [const TimeOfDay(hour: 8, minute: 0)],
      startDate: DateTime.now(),
      remainingDoses: 30,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _remainingDosesController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final provider = Provider.of<MedicationProvider>(context, listen: false);
      final finalMedication = _medication.copyWith(
        name: _nameController.text,
        dosage: double.tryParse(_dosageController.text) ?? 1.0,
        remainingDoses: int.tryParse(_remainingDosesController.text) ?? 30,
        stock: int.tryParse(_remainingDosesController.text) ?? 30,
      );

      if (_isEditMode) {
        provider.updateMedication(finalMedication);
      } else {
        provider.addMedication(finalMedication);
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackgroundColor,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Medication' : 'Add Medication',
            style: const TextStyle(color: _whiteTextColor)),
        backgroundColor: _darkBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _whiteTextColor),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: AbsorbPointer(
                  absorbing: _isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildTextField(_nameController, 'Name', 'Enter medication name'),
                      const SizedBox(height: 16),
                      _buildTextField(_dosageController, 'Dosage', 'e.g., 1, 250', keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildUnitDropdown(),
                      const SizedBox(height: 16),
                      _buildTextField(_remainingDosesController, 'Stock', 'e.g., 30',
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildScheduleTypeDropdown(),
                      const SizedBox(height: 16),
                      if (_medication.scheduleType == MedicationScheduleType.specificDays)
                        _buildDaySelector(),
                      _buildTimeSelector(),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _blueAccentColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Save', style: TextStyle(color: _whiteTextColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _whiteTextColor),
      decoration: _inputDecoration(label, hint),
      validator: (value) => value == null || value.isEmpty ? 'Please enter a value' : null,
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _medication.unit,
      items: ['pill', 'mg', 'ml', 'spray'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            _medication = _medication.copyWith(unit: newValue);
          });
        }
      },
      decoration: _inputDecoration('Unit', ''),
      dropdownColor: _cardBackgroundColor,
      style: const TextStyle(color: _whiteTextColor),
    );
  }

  Widget _buildScheduleTypeDropdown() {
    return DropdownButtonFormField<MedicationScheduleType>(
      initialValue: _medication.scheduleType,
      items: MedicationScheduleType.values.map((type) {
        return DropdownMenuItem<MedicationScheduleType>(
          value: type,
          child: Text(type.toString().split('.').last),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            _medication = _medication.copyWith(scheduleType: newValue);
          });
        }
      },
      decoration: _inputDecoration('Schedule', ''),
      dropdownColor: _cardBackgroundColor,
      style: const TextStyle(color: _whiteTextColor),
    );
  }

  Widget _buildDaySelector() {
    return Card(
      color: _cardBackgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          children: DayOfWeek.values.map((day) {
            final isSelected = _medication.daysOfWeek?.contains(day) ?? false;
            return FilterChip(
              label: Text(day.toString().split('.').last.substring(0, 3)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final currentDays = _medication.daysOfWeek?.toList() ?? [];
                  if (selected) {
                    currentDays.add(day);
                  } else {
                    currentDays.remove(day);
                  }
                  _medication = _medication.copyWith(daysOfWeek: currentDays);
                });
              },
              backgroundColor: _darkBackgroundColor,
              selectedColor: _blueAccentColor,
              labelStyle: const TextStyle(color: _whiteTextColor),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Times', style: TextStyle(color: _whiteTextColor, fontSize: 16)),
        ..._medication.times.asMap().entries.map((entry) {
          int idx = entry.key;
          TimeOfDay time = entry.value;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.alarm, color: _whiteTextColor),
            title: Text(time.format(context), style: const TextStyle(color: _whiteTextColor)),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () {
                setState(() {
                  final newTimes = List<TimeOfDay>.from(_medication.times);
                  newTimes.removeAt(idx);
                  _medication = _medication.copyWith(times: newTimes);
                });
              },
            ),
            onTap: () async {
              final newTime = await showTimePicker(context: context, initialTime: time);
              if (newTime != null) {
                setState(() {
                  final newTimes = List<TimeOfDay>.from(_medication.times);
                  newTimes[idx] = newTime;
                  _medication = _medication.copyWith(times: newTimes);
                });
              }
            },
          );
        }),
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.add, color: _blueAccentColor),
            label: const Text('Add Time', style: TextStyle(color: _blueAccentColor)),
            onPressed: () async {
              final newTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (newTime != null) {
                setState(() {
                   final newTimes = List<TimeOfDay>.from(_medication.times);
                  newTimes.add(newTime);
                  _medication = _medication.copyWith(times: newTimes);
                });
              }
            },
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: _cardBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _subtleBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _subtleBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _blueAccentColor, width: 2),
      ),
    );
  }
}
