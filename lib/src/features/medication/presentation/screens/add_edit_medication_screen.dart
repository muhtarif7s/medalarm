import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  State<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
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

  bool get _isEditing => widget.medication != null;

  @override
  void initState() {
    super.initState();

    final initialMed = widget.medication;
    _nameController = TextEditingController(text: initialMed?.name);
    _dosageController =
        TextEditingController(text: initialMed?.dosage.toString());
    _unitController = TextEditingController(text: initialMed?.unit ?? 'mg');
    _intervalController =
        TextEditingController(text: initialMed?.interval?.toString());

    _scheduleType = initialMed?.scheduleType ?? MedicationScheduleType.daily;
    _times = initialMed?.times ?? [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Medication' : 'Add Medication'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteMedication,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                const SizedBox(height: 16.0),
                _buildDosageAndUnitFields(),
                const SizedBox(height: 16.0),
                _buildScheduleTypeSelector(),
                const SizedBox(height: 16.0),
                _buildScheduleDetails(),
                const SizedBox(height: 16.0),
                _buildTimePicker(),
                const SizedBox(height: 16.0),
                _buildDatePickers(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveForm,
        label: const Text('Save Medication'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Medication Name'),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please enter a name' : null,
    );
  }

  Widget _buildDosageAndUnitFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _dosageController,
            decoration: const InputDecoration(labelText: 'Dosage'),
            keyboardType: TextInputType.number,
            validator: (value) =>
                (value == null || double.tryParse(value) == null)
                    ? 'Invalid number'
                    : null,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            controller: _unitController,
            decoration: const InputDecoration(labelText: 'Unit (e.g., mg, ml)'),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Please enter a unit' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTypeSelector() {
    return DropdownButtonFormField<MedicationScheduleType>(
      initialValue: _scheduleType, // بدل value → initialValue [web:67][web:81]
      decoration: const InputDecoration(labelText: 'Schedule Type'),
      items: MedicationScheduleType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _scheduleType = value);
        }
      },
    );
  }

  Widget _buildScheduleDetails() {
    switch (_scheduleType) {
      case MedicationScheduleType.daily:
        return const SizedBox.shrink();
      case MedicationScheduleType.weekdays:
        return _buildWeekdaysPicker();
      case MedicationScheduleType.interval:
        return _buildIntervalPicker();
    }
  }

  Widget _buildWeekdaysPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Days of the week',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8.0,
          children: List.generate(7, (index) {
            final day = index + 1;
            return FilterChip(
              label: Text(
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]),
              selected: _weekdays.contains(day),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _weekdays.add(day);
                  } else {
                    _weekdays.remove(day);
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildIntervalPicker() {
    return TextFormField(
      controller: _intervalController,
      decoration: const InputDecoration(labelText: 'Interval (hours)'),
      keyboardType: TextInputType.number,
      validator: (value) => (value == null || int.tryParse(value) == null)
          ? 'Invalid number'
          : null,
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Times',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          spacing: 8.0,
          children: _times.map((time) {
            return Chip(
              label: Text(time.format(context)),
              onDeleted: () => setState(() => _times.remove(time)),
            );
          }).toList(),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Time'),
          onPressed: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              setState(() => _times.add(time));
            }
          },
        ),
      ],
    );
  }

  Widget _buildDatePickers() {
    return Column(
      children: [
        _buildDatePicker(
          labelText: 'Start Date',
          selectedDate: _startDate,
          onDateSelected: (date) => setState(() => _startDate = date),
        ),
        const SizedBox(height: 16.0),
        _buildDatePicker(
          labelText: 'End Date (Optional)',
          selectedDate: _endDate,
          onDateSelected: (date) => setState(() => _endDate = date),
          isOptional: true,
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String labelText,
    DateTime? selectedDate,
    required ValueChanged<DateTime> onDateSelected,
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}'
                  : 'Not Set',
            ),
            if (isOptional && selectedDate != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _endDate = null),
              )
            else
              const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final medication = Medication(
      id: widget.medication?.id,
      name: _nameController.text,
      dosage: double.parse(_dosageController.text),
      unit: _unitController.text,
      scheduleType: _scheduleType,
      times: _times,
      weekdays:
          _scheduleType == MedicationScheduleType.weekdays ? _weekdays : null,
      interval: _scheduleType == MedicationScheduleType.interval
          ? int.parse(_intervalController.text)
          : null,
      startDate: _startDate,
      endDate: _endDate,
    );

    final provider = Provider.of<MedicationProvider>(
      context,
      listen: false,
    );
    if (_isEditing) {
      provider.updateMedication(medication);
    } else {
      provider.addMedication(medication);
    }

    Navigator.of(context).pop();
  }

  void _deleteMedication() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.medication?.id != null) {
      if (!mounted) return;
      Provider.of<MedicationProvider>(
        context,
        listen: false,
      ).deleteMedication(widget.medication!.id!);
      Navigator.of(context).pop();
    }
  }
}
