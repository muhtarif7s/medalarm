import 'package:flutter/material.dart';
import 'package:myapp/src/features/statistics/presentation/widgets/monthly_overview.dart';
import 'package:myapp/src/features/statistics/presentation/widgets/most_skipped.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('Monthly Overview'),
                  subtitle: MonthlyOverview(),
                ),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.warning_amber_rounded),
                  title: Text('Most Skipped'),
                  subtitle: MostSkipped(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
