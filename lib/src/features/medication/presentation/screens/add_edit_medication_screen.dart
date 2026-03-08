import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as date_picker;
import 'package:toggle_switch/toggle_switch.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  State<AddEditMedicationScreen> createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dosageController;
  late TextEditingController _unitController;
  late TextEditingController _intervalController;

  late MedicationScheduleType _scheduleType;
  late List<TimeOfDay> _times;
  late List<int> _weekdays;
  late DateTime _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final initialMed = widget.medication;

    _nameController = TextEditingController(text: initialMed?.name);
    _dosageController = TextEditingController(text: initialMed?.dosage.toString());
    _unitController = TextEditingController(text: initialMed?.unit);
    _intervalController = TextEditingController(text: initialMed?.interval?.toString() ?? '24');

    _scheduleType = initialMed?.scheduleType ?? MedicationScheduleType.daily;
    _times = initialMed?.times ?? []; // Start with an empty list for new medications
    _weekdays = initialMed?.weekdays ?? [];
    _startDate = initialMed?.startDate ?? DateTime.now();
    _endDate = initialMed?.endDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Ensure there's at least one time for daily/weekday schedules
      if ((_scheduleType == MedicationScheduleType.daily || _scheduleType == MedicationScheduleType.weekdays) && _times.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.pleaseAddTime)),
        );
        return;
      }

      final medication = Medication(
        id: widget.medication?.id,
        name: _nameController.text,
        dosage: double.parse(_dosageController.text),
        unit: _unitController.text,
        scheduleType: _scheduleType,
        times: _times,
        weekdays: _scheduleType == MedicationScheduleType.weekdays ? _weekdays : null,
        interval: _scheduleType == MedicationScheduleType.interval ? int.parse(_intervalController.text) : null,
        startDate: _startDate,
        endDate: _endDate,
      );

      final provider = Provider.of<MedicationProvider>(context, listen: false);
      if (widget.medication == null) {
        provider.addMedication(medication);
      } else {
        provider.updateMedication(medication);
      }
      context.pop();
    }
  }

  void _deleteMedication() {
    if (widget.medication != null) {
      Provider.of<MedicationProvider>(context, listen: false).deleteMedication(widget.medication!.id!);
      context.go('/'); // Use go to reset the navigation stack after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditMode = widget.medication != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(isEditMode ? l10n.editMedication : l10n.addMedication),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmationDialog,
              tooltip: l10n.deleteMedication,
            ),
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: _saveForm,
            tooltip: l10n.saveMedication,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMedicationDetails(l10n),
              const SizedBox(height: 24),
              _buildScheduleTypeSelector(l10n),
              const SizedBox(height: 16),
              _buildScheduleDetails(l10n),
              const SizedBox(height: 24),
              _buildDatePickers(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationDetails(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: l10n.medicationName, border: const OutlineInputBorder()),
          validator: (value) => value == null || value.isEmpty ? l10n.pleaseEnterName : null,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(labelText: l10n.dosage, border: const OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => value == null || double.tryParse(value) == null ? l10n.invalidNumber : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _unitController,
                decoration: InputDecoration(labelText: l10n.unitExample, border: const OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? l10n.pleaseEnterUnit : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleTypeSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.scheduleType, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<MedicationScheduleType>(
          initialValue: _scheduleType,
          items: [
            DropdownMenuItem(value: MedicationScheduleType.daily, child: Text(l10n.daily)),
            DropdownMenuItem(value: MedicationScheduleType.weekdays, child: Text(l10n.weekdays)),
            DropdownMenuItem(value: MedicationScheduleType.interval, child: Text(l10n.interval)),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _scheduleType = value;
              });
            }
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildScheduleDetails(AppLocalizations l10n) {
    switch (_scheduleType) {
      case MedicationScheduleType.daily:
        return _buildTimesList(l10n, title: l10n.times);
      case MedicationScheduleType.weekdays:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySelector(l10n),
            const SizedBox(height: 16),
            _buildTimesList(l10n, title: l10n.times),
          ],
        );
      case MedicationScheduleType.interval:
        return _buildIntervalPicker(l10n);
    }
  }

  Widget _buildDaySelector(AppLocalizations l10n) {
    final days = [
      l10n.mondayShort,
      l10n.tuesdayShort,
      l10n.wednesdayShort,
      l10n.thursdayShort,
      l10n.fridayShort,
      l10n.saturdayShort,
      l10n.sundayShort
    ];

    // Correctly build the list of active border colors
    List<List<Color>> activeBgColors = [];
    for (int i = 0; i < 7; i++) {
      if (_weekdays.contains(i + 1)) {
        activeBgColors.add([Theme.of(context).colorScheme.primary]);
      } else {
        activeBgColors.add([Colors.grey[300]!]); // Inactive color
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.daysOfTheWeek, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ToggleSwitch(
          minWidth: 50.0,
          cornerRadius: 20.0,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[300],
          inactiveFgColor: Colors.black,
          initialLabelIndex: null, // No initial selection
          activeBgColors: activeBgColors,
          labels: days,
          onToggle: (index) {
            if (index == null) return;
            setState(() {
              final day = index + 1; // 1 for Monday, ..., 7 for Sunday
              if (_weekdays.contains(day)) {
                _weekdays.remove(day);
              } else {
                _weekdays.add(day);
                _weekdays.sort();
              }
            });
          },
        ),
      ],
    );
  }


  Widget _buildTimesList(AppLocalizations l10n, {required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8.0,
          children: List<Widget>.generate(_times.length, (int index) {
            return Chip(
              label: Text(_times[index].format(context)),
              onDeleted: () {
                setState(() {
                  _times.removeAt(index);
                });
              },
            );
          }),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add_circle_outline),
          label: Text(l10n.addTime),
          onPressed: () async {
            final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (picked != null && !_times.contains(picked)) {
              setState(() {
                _times.add(picked);
                // Optional: sort times
                _times.sort((a, b) => (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute));
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildIntervalPicker(AppLocalizations l10n) {
    return TextFormField(
      controller: _intervalController,
      decoration: InputDecoration(labelText: l10n.intervalHours, border: const OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
          return l10n.invalidNumber;
        }
        return null;
      },
    );
  }

  Widget _buildDatePickers(AppLocalizations l10n) {
    final dateFormat = DateFormat.yMMMd(l10n.localeName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.startDate, style: Theme.of(context).textTheme.titleMedium),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () => _pickDate(true),
              label: Text(dateFormat.format(_startDate)),
            ),
            const SizedBox(height: 16),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.endDateOptional, style: Theme.of(context).textTheme.titleMedium),
            if (_endDate != null)
              TextButton.icon(
                icon: const Icon(Icons.clear, size: 18),
                label: Text(l10n.clear),
                onPressed: () => setState(() => _endDate = null),
              )
          ],
        ),
        TextButton.icon(
          icon: const Icon(Icons.calendar_today_outlined),
          onPressed: () => _pickDate(false),
          label: Text(_endDate != null ? dateFormat.format(_endDate!) : l10n.notSet),
        ),
      ],
    );
  }

  Future<void> _pickDate(bool isStartDate) async {
    final DateTime? picked = await date_picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2000),
      maxTime: DateTime(2101),
      currentTime: isStartDate ? _startDate : (_endDate ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate)) {
            _endDate = _startDate; // Ensure end date is not before start date
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteMedication),
          content: SingleChildScrollView(child: ListBody(children: <Widget>[Text(l10n.thisActionCannotBeUndone)])),
          actions: <Widget>[
            TextButton(child: Text(l10n.cancel), onPressed: () => Navigator.of(context).pop()),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: Text(l10n.delete),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMedication();
              },
            ),
          ],
        );
      },
    );
  }
}
