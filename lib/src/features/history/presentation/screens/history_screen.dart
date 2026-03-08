import 'package:flutter/material.dart';
import 'package:myapp/src/features/history/presentation/widgets/history_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _filter == 'all',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filter = 'all';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Taken'),
                    selected: _filter == 'taken',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filter = 'taken';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Skipped'),
                    selected: _filter == 'skipped',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filter = 'skipped';
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Upcoming'),
                    selected: _filter == 'upcoming',
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _filter = 'upcoming';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: HistoryList(filter: _filter),
          ),
        ],
      ),
    );
  }
}
