import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
    final doseProvider = Provider.of<DoseProvider>(context, listen: false);
    await medicationProvider.loadMedications();
    await doseProvider.loadDosesForDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              backgroundColor: const Color(0xFF121212),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Good morning, User!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/home_background.jpg', // Placeholder image
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDoseStats(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildNextDoseCard(context),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Today\'s Timeline',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildTodaysTimeline(context),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  'Your Medications',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildMedicationList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseStats(BuildContext context) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        final doses = doseProvider.doses;
        final totalDoses = doses.length;
        final takenDoses = doses.where((d) => d.status == DoseStatus.taken).length;
        final missedDoses = doses.where((d) => d.status == DoseStatus.missed).length;

        return Card(
          color: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Total Doses', totalDoses.toString()),
                _buildStatColumn('Taken', takenDoses.toString()),
                _buildStatColumn('Missed', missedDoses.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNextDoseCard(BuildContext context) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        final nextDose = doseProvider.doses
            .where((d) => d.status == DoseStatus.pending && d.time.isAfter(DateTime.now()))
            .firstOrNull;

        if (nextDose == null) {
          return const Card(
            color: Color(0xFF1E1E1E),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No upcoming doses for today.', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        return Consumer<MedicationProvider>(
          builder: (context, medicationProvider, child) {
            final medication = medicationProvider.getMedication(nextDose.medicationId);
            return Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.white24),
              ),
              child: ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.blue, size: 40),
                title: Text('Next Dose: ${medication?.name ?? 'Unknown'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat.jm().format(nextDose.time), style: const TextStyle(color: Colors.white70)),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await doseProvider.takeDose(nextDose);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Take'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTodaysTimeline(BuildContext context) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        if (doseProvider.isLoading) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        }

        final doses = doseProvider.doses;

        if (doses.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.timeline,
              title: 'No Doses Today',
              message: 'You have no medication scheduled for today.',
            ),
          );
        }

        return Consumer<MedicationProvider>(
          builder: (context, medicationProvider, child) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final dose = doses[index];
                  final medication = medicationProvider.getMedication(dose.medicationId);
                  return ListTile(
                    leading: const Icon(Icons.medication_outlined, color: Colors.white70),
                    title: Text(medication?.name ?? 'Unknown Medication', style: const TextStyle(color: Colors.white)),
                    subtitle: Text(DateFormat.jm().format(dose.time), style: const TextStyle(color: Colors.white70)),
                    trailing: dose.status == DoseStatus.pending
                        ? ElevatedButton(
                            onPressed: () async {
                              await doseProvider.takeDose(dose);
                            },
                            child: const Text('Take'),
                          )
                        : Text(dose.status.name, style: TextStyle(color: _getStatusColor(dose.status), fontWeight: FontWeight.bold)),
                  );
                },
                childCount: doses.length,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMedicationList(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, medicationProvider, child) {
        if (medicationProvider.isLoading) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        }

        final medications = medicationProvider.medications;

        if (medications.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              icon: Icons.medication,
              title: 'No Medications',
              message: 'Add a medication to get started.',
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final Medication medication = medications[index];
              return Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  title: Text(medication.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('${medication.dosage} ${medication.unit}', style: const TextStyle(color: Colors.white70)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white),
                  onTap: () {
                    GoRouter.of(context).push('/medication-details/${medication.id}');
                  },
                ),
              );
            },
            childCount: medications.length,
          ),
        );
      },
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
