import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/services/database_service.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/screens/medication_details_screen.dart';

class MedicineCards extends StatefulWidget {
  const MedicineCards({super.key});

  @override
  State<MedicineCards> createState() => _MedicineCardsState();
}

class _MedicineCardsState extends State<MedicineCards> {
  final DatabaseService _dbService = SqfliteDatabaseService();
  late Future<List<Medication>> _medicationsFuture;

  @override
  void initState() {
    super.initState();
    _medicationsFuture = _dbService.getMedications();
  }

  void _takeDose(Medication medication) async {
    final newDose = Dose(
        medicationId: medication.id!,
        time: DateTime.now(),
        status: DoseStatus.taken);
    await _dbService.insertDose(newDose);

    final updatedMedication =
        medication.copyWith(dosage: medication.dosage - 1);
    await _dbService.updateMedication(updatedMedication);

    setState(() {
      _medicationsFuture = _dbService.getMedications();
    });
  }

  void _navigateToDetails(Medication medication) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationDetailsScreen(medication: medication),
      ),
    ).then((_) {
      setState(() {
        _medicationsFuture = _dbService.getMedications();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.yourMedications,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: FutureBuilder<List<Medication>>(
            future: _medicationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text(l10n.noMedicationsYet));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final medication = snapshot.data![index];
                  return _buildMedicineCard(medication);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineCard(Medication medication) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _navigateToDetails(medication),
      child: Card(
        child: SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.medication, size: 40),
                const SizedBox(height: 8),
                Text(medication.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${medication.dosage} ${medication.unit}',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _takeDose(medication),
                  child: Text(l10n.take),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
