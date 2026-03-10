// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/profile_provider.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';

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
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await medicationProvider.loadMedications();
    await doseProvider.loadDosesForDay(DateTime.now());
    await profileProvider.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Good morning, ${Provider.of<ProfileProvider>(context).profile?.name ?? 'User'}!',
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
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Today\'s Timeline',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            _buildTodaysTimeline(context),
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

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Total Doses', totalDoses.toString()),
                _buildStatColumn('Taken', takenDoses.toString()),
                _buildStatColumn('Missed', (totalDoses - takenDoses).toString()),
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
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  Widget _buildTodaysTimeline(BuildContext context) {
    return Consumer2<DoseProvider, MedicationProvider>(
      builder: (context, doseProvider, medicationProvider, child) {
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

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final dose = doses[index];
              final medication = medicationProvider.getMedicationById(dose.medicationId.toString());
              return ListTile(
                leading: const Icon(Icons.medication_outlined),
                title: Text(medication?.name ?? 'Unknown Medication'),
                subtitle: Text(DateFormat.jm().format(dose.scheduledTime)),
                trailing: dose.status == DoseStatus.pending
                    ? ElevatedButton(
                        onPressed: () async {
                          await doseProvider.takeDose(dose);
                          await _loadData(); // Refresh data after taking a dose
                        },
                        child: const Text('Take'),
                      )
                    : Text(dose.status.name, style: TextStyle(color: _getStatusColor(dose.status))),
              );
            },
            childCount: doses.length,
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
