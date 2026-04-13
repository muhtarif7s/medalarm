import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/models/day_of_week.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:provider/provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  State<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState
    extends State<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late double _dosage;
  late String _unit;
  late int _stock;
  late MedicationScheduleType _scheduleType;
  late DateTime _startDate;
  late DateTime? _endDate;
  late List<TimeOfDay> _times;
  late List<DayOfWeek> _daysOfWeek;
  late int _interval;
  late int _remainingDoses;

  @override
  void initState() {
    super.initState();
    _name = widget.medication?.name ?? '';
    _dosage = widget.medication?.dosage ?? 0.0;
    _unit = widget.medication?.unit ?? 'mg';
    _stock = widget.medication?.stock ?? 0;
    _scheduleType =
        widget.medication?.scheduleType ?? MedicationScheduleType.daily;
    _startDate = widget.medication?.startDate ?? DateTime.now();
    _endDate = widget.medication?.endDate;
    _times = widget.medication?.times ?? [TimeOfDay.now()];
    _daysOfWeek = widget.medication?.daysOfWeek ?? [];
    _interval = widget.medication?.interval ?? 1;
    _remainingDoses = widget.medication?.remainingDoses ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.medication == null ? 'Add Medication' : 'Edit Medication'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medication name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _dosage.toString(),
                      decoration: const InputDecoration(labelText: 'Dosage'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a dosage';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (value) => _dosage = double.parse(value!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _unit,
                      decoration: const InputDecoration(labelText: 'Unit (e.g., mg)'),
                      onSaved: (value) => _unit = value!,
                    ),
                  ),
                ],
              ),
              TextFormField(
                initialValue: _stock.toString(),
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the stock amount';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _stock = int.parse(value!),
              ),
               TextFormField(
                initialValue: _remainingDoses.toString(),
                decoration: const InputDecoration(labelText: 'Remaining Doses'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the remaining doses';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _remainingDoses = int.parse(value!),
              ),
              const SizedBox(height: 20),
              const Text('Schedule'),
              _buildScheduleTypeSelector(),
              if (_scheduleType == MedicationScheduleType.specificDays)
                _buildDaysOfWeekSelector(),
              if (_scheduleType == MedicationScheduleType.interval)
                _buildIntervalSelector(),
              _buildTimesList(),
              const SizedBox(height: 20),
              const Text('Duration'),
              _buildDateRangePicker(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedication,
                child: const Text('Save Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTypeSelector() {
    return DropdownButtonFormField<MedicationScheduleType>(
      initialValue: _scheduleType,
      decoration: const InputDecoration(labelText: 'Schedule Type'),
      items: MedicationScheduleType.values
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type.name),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _scheduleType = value;
          });
        }
      },
    );
  }

  Widget _buildDaysOfWeekSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: DayOfWeek.values.map((day) {
        return ChoiceChip(
          label: Text(day.name.substring(0, 3)),
          selected: _daysOfWeek.contains(day),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _daysOfWeek.add(day);
              } else {
                _daysOfWeek.remove(day);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildIntervalSelector() {
    return TextFormField(
      initialValue: _interval.toString(),
      decoration: const InputDecoration(labelText: 'Interval (in days)'),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an interval';
        }
        if (int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onSaved: (value) => _interval = int.parse(value!),
    );
  }

  Widget _buildTimesList() {
    return Column(
      children: [
        ..._times.asMap().entries.map((entry) {
          int idx = entry.key;
          TimeOfDay time = entry.value;
          return ListTile(
            title: Text(time.format(context)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _times.removeAt(idx);
                });
              },
            ),
            onTap: () async {
              final newTime = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (newTime != null) {
                setState(() {
                  _times[idx] = newTime;
                });
              }
            },
          );
        }),
        TextButton.icon(
          onPressed: () async {
            final newTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (newTime != null) {
              setState(() {
                _times.add(newTime);
              });
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Time'),
        ),
      ],
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime(2023),
              lastDate: DateTime(2025),
            );
            if (pickedDate != null && pickedDate != _startDate) {
              setState(() {
                _startDate = pickedDate;
              });
            }
          },
          child: Text('Start: ${DateFormat.yMd().format(_startDate)}'),
        ),
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _endDate ?? DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime(2025),
            );
            if (pickedDate != null && pickedDate != _endDate) {
              setState(() {
                _endDate = pickedDate;
              });
            }
          },
          child: Text('End: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Not set'}'),
        ),
      ],
    );
  }

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMedication = Medication(
        id: widget.medication?.id,
        name: _name,
        dosage: _dosage,
        unit: _unit,
        stock: _stock,
        scheduleType: _scheduleType,
        times: _times,
        daysOfWeek: _daysOfWeek,
        interval: _interval,
        startDate: _startDate,
        endDate: _endDate,
        remainingDoses: _remainingDoses,
      );

      if (widget.medication == null) {
        Provider.of<MedicationProvider>(context, listen: false)
            .addMedication(newMedication);
      } else {
        Provider.of<MedicationProvider>(context, listen: false)
            .updateMedication(newMedication);
      }

      Navigator.of(context).pop();
    }
  }
}
