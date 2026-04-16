import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/shared/widgets/action_button.dart';
import 'package:myapp/src/shared/widgets/custom_card.dart';
import 'package:myapp/src/shared/widgets/loading_shimmer.dart';
import 'package:myapp/src/shared/widgets/section_header.dart';
import 'package:myapp/src/shared/widgets/timeline_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final medicationProvider =
          Provider.of<MedicationProvider>(context, listen: false);
      final doseProvider = Provider.of<DoseProvider>(context, listen: false);
      await Future.wait([
        medicationProvider.loadMedications(),
        doseProvider.loadDosesForDay(DateTime.now()),
      ]);
    } catch (e) {
      debugPrint('Error loading home screen data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MedAlarm',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final medications = Provider.of<MedicationProvider>(context, listen: false).medications;
              showSearch(context: context, delegate: _MedicationSearchDelegate(medications, context));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('Statistics'),
                        onTap: () { Navigator.pop(context); GoRouter.of(context).go('/statistics'); },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () { Navigator.pop(context); GoRouter.of(context).go('/settings'); },
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Header
                _buildGreetingHeader(context),

                const SizedBox(height: 24),

                // Next Dose Card
                _buildNextDoseSection(context),

                const SizedBox(height: 24),

                // Today's Timeline
                _buildTimelineSection(context),

                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context),

                const SizedBox(height: 24),

                // Medications Overview
                _buildMedicationsOverview(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push('/add-medication'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGreetingHeader(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = _getGreeting();

    return CustomCard(
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.waving_hand,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Stay on top of your medication schedule',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDoseSection(BuildContext context) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        if (doseProvider.isLoading) {
          return const LoadingCard();
        }

        final nextDose = doseProvider.doses
            .where((d) =>
                d.status == DoseStatus.pending &&
                d.time.isAfter(DateTime.now()))
            .firstOrNull;

        if (nextDose == null) {
          return CustomCard(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All caught up!',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        'No upcoming doses for today',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Consumer<MedicationProvider>(
          builder: (context, medicationProvider, child) {
            final medication =
                medicationProvider.getMedication(nextDose.medicationId);

            return CustomCard(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Next Dose',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    medication?.name ?? 'Unknown Medication',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '${medication?.dosage ?? 0} ${medication?.unit ?? ''}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.jm().format(nextDose.time),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    label: 'Take Dose',
                    icon: Icons.check,
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      await doseProvider.takeDose(nextDose);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: const Text('Dose marked as taken'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Today\'s Timeline',
          trailing: TextButton(
            onPressed: () => GoRouter.of(context).go('/history'),
            child: const Text('View All'),
          ),
        ),
        const SizedBox(height: 16),
        Consumer<DoseProvider>(
          builder: (context, doseProvider, child) {
            if (doseProvider.isLoading) {
              return const LoadingTimeline();
            }

            final doses = doseProvider.doses.take(5).toList(); // Show first 5

            if (doses.isEmpty) {
              return CustomCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.timeline,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No doses scheduled',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Add medications to see your timeline',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Consumer<MedicationProvider>(
              builder: (context, medicationProvider, child) {
                return Column(
                  children: doses.map((dose) {
                    final medication =
                        medicationProvider.getMedication(dose.medicationId);
                    final isCompleted = dose.status == DoseStatus.taken;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TimelineItem(
                        time: DateFormat.jm().format(dose.time),
                        title: medication?.name ?? 'Unknown',
                        subtitle:
                            '${medication?.dosage ?? 0} ${medication?.unit ?? ''}',
                        icon:
                            isCompleted ? Icons.check_circle : Icons.medication,
                        iconColor: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        isCompleted: isCompleted,
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick Actions'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                label: 'Add Medication',
                icon: Icons.add,
                onPressed: () => GoRouter.of(context).push('/add-medication'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                label: 'View History',
                icon: Icons.history,
                onPressed: () => GoRouter.of(context).go('/history'),
                isOutlined: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicationsOverview(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, medicationProvider, child) {
        if (medicationProvider.isLoading) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoadingShimmer(width: 150, height: 24),
              SizedBox(height: 16),
              LoadingCard(),
              SizedBox(height: 12),
              LoadingCard(),
            ],
          );
        }

        final medications = medicationProvider.medications.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Your Medications',
              subtitle: '${medicationProvider.medications.length} active',
              trailing: TextButton(
                onPressed: () => GoRouter.of(context).push('/medications'),
                child: const Text('View All'),
              ),
            ),
            const SizedBox(height: 16),
            if (medications.isEmpty)
              CustomCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.medication,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No medications added yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first medication',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...medications.map((medication) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomCard(
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.medication,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          medication.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        subtitle: Text(
                          '${medication.dosage} ${medication.unit} • ${medication.scheduleType}',
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          GoRouter.of(context)
                              .push('/medicine-details/${medication.id}');
                        },
                      ),
                    ),
                  )),
          ],
        );
      },
    );
  }
}

class _MedicationSearchDelegate extends SearchDelegate<void> {
  final List<Medication> medications;
  final BuildContext parentContext;

  _MedicationSearchDelegate(this.medications, this.parentContext);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    final results = medications
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (results.isEmpty) {
      return const Center(child: Text('No medications found'));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.medication),
        title: Text(results[i].name),
        subtitle: Text('${results[i].dosage} ${results[i].unit}'),
        onTap: () {
          close(parentContext, null);
          GoRouter.of(parentContext).push('/medicine-details/${results[i].id}');
        },
      ),
    );
  }
}
