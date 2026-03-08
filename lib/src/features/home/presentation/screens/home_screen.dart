import 'package:flutter/material.dart';
import 'package:myapp/src/features/home/presentation/widgets/daily_stats_card.dart';
import 'package:myapp/src/features/home/presentation/widgets/header_section.dart';
import 'package:myapp/src/features/home/presentation/widgets/medicine_cards.dart';
import 'package:myapp/src/features/home/presentation/widgets/next_dose_card.dart';
import 'package:myapp/src/features/home/presentation/widgets/quick_actions.dart';
import 'package:myapp/src/features/home/presentation/widgets/smart_alerts.dart';
import 'package:myapp/src/features/home/presentation/widgets/timeline.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implement refresh functionality
        },
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(),
                SizedBox(height: 16),
                DailyStatsCard(),
                SizedBox(height: 16),
                NextDoseCard(),
                SizedBox(height: 16),
                Timeline(),
                SizedBox(height: 16),
                MedicineCards(),
                SizedBox(height: 16),
                QuickActions(),
                SizedBox(height: 16),
                SmartAlerts(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
