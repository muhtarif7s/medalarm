import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/day_of_week.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:provider/provider.dart';

class AddEditMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  State<AddEditMedicationScreen> createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends State<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _dosage;
  late String _unit;
  late int _stock;
  late MedicationScheduleType _scheduleType;
  late List<TimeOfDay> _times;
  late int? _interval;
  late List<DayOfWeek>? _daysOfWeek;
  late DateTime _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _name = widget.medication?.name ?? '';
    _dosage = widget.medication?.dosage ?? 0.0;
    _unit = widget.medication?.unit ?? '';
    _stock = widget.medication?.stock ?? 0;
    _scheduleType = widget.medication?.scheduleType ?? MedicationScheduleType.daily;
    _times = widget.medication?.times ?? [TimeOfDay.now()];
    _interval = widget.medication?.interval;
    _daysOfWeek = widget.medication?.daysOfWeek;
    _startDate = widget.medication?.startDate ?? DateTime.now();
    _endDate = widget.medication?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication == null ? l10n.addMedication : l10n.editMedication),
        actions: [
          if (widget.medication != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
        ],
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
                decoration: InputDecoration(labelText: l10n.medicationName),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterName;
                  }
                  return null;
                },
                onSaved: (value) => _name = value ?? '',
              ),
              TextFormField(
                initialValue: _dosage.toString(),
                decoration: InputDecoration(labelText: l10n.dosage),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return l10n.invalidNumber;
                  }
                  return null;
                },
                onSaved: (value) => _dosage = double.tryParse(value ?? '0.0') ?? 0.0,
              ),
              TextFormField(
                initialValue: _unit,
                decoration: InputDecoration(labelText: l10n.unitExample),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterUnit;
                  }
                  return null;
                },
                onSaved: (value) => _unit = value ?? '',
              ),
              TextFormField(
                initialValue: _stock.toString(),
                decoration: InputDecoration(labelText: l10n.stock),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return l10n.invalidNumber;
                  }
                  return null;
                },
                onSaved: (value) => _stock = int.tryParse(value ?? '0') ?? 0,
              ),
              DropdownButtonFormField<MedicationScheduleType>(
                initialValue: _scheduleType,
                items: [
                  DropdownMenuItem(
                    value: MedicationScheduleType.daily,
                    child: Text(l10n.daily),
                  ),
                  DropdownMenuItem(
                    value: MedicationScheduleType.specificDays,
                    child: Text(l10n.specificDaysInWeek),
                  ),
                  DropdownMenuItem(
                    value: MedicationScheduleType.interval,
                    child: Text(l10n.interval),
                  ),
                ],
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _scheduleType = value ?? MedicationScheduleType.daily;
                    });
                  }
                },
              ),
              if (_scheduleType == MedicationScheduleType.specificDays)
                _buildDaysOfWeekSelector(),
              if (_scheduleType == MedicationScheduleType.interval)
                TextFormField(
                  initialValue: _interval?.toString() ?? '',
                  decoration: InputDecoration(labelText: l10n.intervalHours),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return l10n.invalidNumber;
                    }
                    return null;
                  },
                  onSaved: (value) => _interval = int.tryParse(value ?? '0'),
                ),
              _buildTimesList(),
              const SizedBox(height: 16),
              _buildStartDateSelector(),
              const SizedBox(height: 16),
              _buildEndDateSelector(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMedication,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildDaysOfWeekSelector() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.daysOfTheWeek, style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: 8,
          children: DayOfWeek.values.map((day) {
            return ChoiceChip(
              label: Text(day.toString().split('.').last),
              selected: _daysOfWeek?.contains(day) ?? false,
              onSelected: (selected) {
                if (mounted) {
                  setState(() {
                    if (selected) {
                      _daysOfWeek = [...?_daysOfWeek, day];
                    } else {
                      _daysOfWeek = _daysOfWeek?.where((d) => d != day).toList();
                    }
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimesList() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.times, style: Theme.of(context).textTheme.titleMedium),
        ..._times.asMap().entries.map((entry) {
          final index = entry.key;
          final time = entry.value;
          return Row(
            children: [
              Expanded(
                child: Text(time.format(context)),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final newTime = await showTimePicker(context: context, initialTime: time);
                  if (newTime != null) {
                    if (mounted) {
                      setState(() {
                        _times[index] = newTime;
                      });
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      _times.removeAt(index);
                    });
                  }
                },
              ),
            ],
          );
        }),
        TextButton(
          onPressed: () async {
            final newTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (newTime != null) {
              if (mounted) {
                setState(() {
                  _times.add(newTime);
                });
              }
            }
          },
          child: Text(l10n.addTime),
        ),
      ],
    );
  }

  Widget _buildStartDateSelector() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text('${l10n.startDate}: ${DateFormat.yMd().format(_startDate)}'),
        ),
        TextButton(
          onPressed: () async {
            final newDate = await showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (newDate != null) {
              if (mounted) {
                setState(() {
                  _startDate = newDate;
                });
              }
            }
          },
          child: const Text('Select'),
        ),
      ],
    );
  }

  Widget _buildEndDateSelector() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text('${l10n.endDateOptional}: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : l10n.notSet}'),
        ),
        TextButton(
          onPressed: () async {
            final newDate = await showDatePicker(
              context: context,
              initialDate: _endDate ?? _startDate,
              firstDate: _startDate,
              lastDate: DateTime(2100),
            );
            if (newDate != null) {
              if (mounted) {
                setState(() {
                  _endDate = newDate;
                });
              }
            }
          },
          child: const Text('Select'),
        ),
        if (_endDate != null)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (mounted) {
                setState(() {
                  _endDate = null;
                });
              }
            },
          ),
      ],
    );
  }

  void _saveMedication() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final l10n = AppLocalizations.of(context)!;
      final provider = Provider.of<MedicationProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      try {
        final medication = Medication(
          id: widget.medication?.id,
          name: _name,
          dosage: _dosage,
          unit: _unit,
          stock: _stock,
          scheduleType: _scheduleType,
          times: _times,
          interval: _interval,
          daysOfWeek: _daysOfWeek,
          startDate: _startDate,
          endDate: _endDate,
          remainingDoses: widget.medication?.remainingDoses ?? _stock,
        );
        if (widget.medication == null) {
          await provider.addMedication(medication);
        } else {
          await provider.updateMedication(medication);
        }

        navigator.pop();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('${l10n.failedToSaveMedication} $e')),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedication),
        content: Text(l10n.thisActionCannotBeUndone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (widget.medication?.id != null) {
                  await provider.deleteMedication(widget.medication!.id!);
                }
                navigator.pop();
                navigator.pop();
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('${l10n.failedToDeleteMedication} $e')),
                );
              }
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
