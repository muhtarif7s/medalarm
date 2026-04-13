// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';

enum DoseFilter { all, taken, skipped, upcoming }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DoseFilter _selectedFilter = DoseFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoseProvider>(context, listen: false).loadAllDoses();
    });
  }

  List<Dose> _getFilteredDoses(List<Dose> doses) {
    switch (_selectedFilter) {
      case DoseFilter.taken:
        return doses.where((d) => d.status == DoseStatus.taken).toList();
      case DoseFilter.skipped:
        return doses.where((d) => d.status == DoseStatus.missed).toList();
      case DoseFilter.upcoming:
        return doses.where((d) => d.status == DoseStatus.pending).toList();
      case DoseFilter.all:
        return doses;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('History', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Consumer<DoseProvider>(
              builder: (context, doseProvider, child) {
                if (doseProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (doseProvider.groupedDosesByDay.isEmpty) {
                  return const EmptyState(
                    icon: Icons.history,
                    title: 'No History',
                    message: 'No medication history found.',
                  );
                }

                final medicationProvider =
                    Provider.of<MedicationProvider>(context, listen: false);
                final filteredGroupedDoses = doseProvider.groupedDosesByDay.map(
                  (date, doses) => MapEntry(
                    date,
                    _getFilteredDoses(doses),
                  ),
                )..removeWhere((key, value) => value.isEmpty);

                if (filteredGroupedDoses.isEmpty) {
                  return const EmptyState(
                    icon: Icons.history,
                    title: 'No Doses',
                    message: 'No doses match the selected filter.',
                  );
                }

                return ListView.builder(
                  itemCount: filteredGroupedDoses.keys.length,
                  itemBuilder: (context, index) {
                    final date = filteredGroupedDoses.keys.elementAt(index);
                    final dosesForDay = filteredGroupedDoses[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            DateFormat.yMMMMEEEEd().format(date),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...dosesForDay.map((dose) {
                          final medication = medicationProvider
                              .getMedication(dose.medicationId);
                          return ListTile(
                            leading: const Icon(Icons.medication,
                                color: Colors.white70),
                            title: Text(
                                medication?.name ?? 'Unknown Medication',
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(DateFormat.jm().format(dose.time),
                                style: const TextStyle(color: Colors.white70)),
                            trailing: Text(
                              dose.status.name,
                              style: TextStyle(
                                  color: _getStatusColor(dose.status),
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        children: DoseFilter.values.map((filter) {
          return FilterChip(
            label:
                Text(filter.name[0].toUpperCase() + filter.name.substring(1)),
            selected: _selectedFilter == filter,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              }
            },
            backgroundColor: const Color(0xFF1E1E1E),
            selectedColor: Colors.blue,
            labelStyle: const TextStyle(color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return Colors.green;
      case DoseStatus.missed:
        return Colors.red;
      case DoseStatus.pending:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
