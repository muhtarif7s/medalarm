import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/dose_history_list.dart';

class MedicationDetailScreen extends StatefulWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  State<MedicationDetailScreen> createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load doses for this specific medication
    Future.microtask(() {
      if (mounted) {
        Provider.of<DoseProvider>(context, listen: false)
            .loadDosesForMedication(widget.medication.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.goNamed('editMedication', extra: widget.medication),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            Text('Dose History',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Consumer<DoseProvider>(
              builder: (context, doseProvider, child) {
                if (doseProvider.doses.isEmpty) {
                  return const Center(
                      child: Text('No dose history available.'));
                }
                return DoseHistoryList(doses: doseProvider.doses);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.medical_services,
                '${widget.medication.dosage} ${widget.medication.unit}'),
            const Divider(height: 24),
            _buildScheduleInfo(),
            const Divider(height: 24),
            _buildDateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.schedule, 'Scheduled', isHeader: true),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40), // Indent details
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Type: ${widget.medication.scheduleType.name}'),
              if (widget.medication.scheduleType ==
                  MedicationScheduleType.weekdays)
                Text(
                    'Days: ${widget.medication.weekdays?.join(', ') ?? 'N/A'}'),
              if (widget.medication.scheduleType ==
                  MedicationScheduleType.interval)
                Text('Every ${widget.medication.interval} hours'),
              Text(
                  'Times: ${widget.medication.times.map((t) => t.format(context)).join(', ')}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(Icons.date_range, 'Duration', isHeader: true),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Start: ${DateFormat.yMMMd().format(widget.medication.startDate)}'),
              Text(widget.medication.endDate != null
                  ? 'End: ${DateFormat.yMMMd().format(widget.medication.endDate!)}'
                  : 'Ongoing'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isHeader = false}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 16),
        Text(
          text,
          style: isHeader
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
