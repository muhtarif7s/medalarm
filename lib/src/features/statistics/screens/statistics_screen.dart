// Flutter imports:
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBackgroundColor = Color(0xFF121212);
    const cardBackgroundColor = Color(0xFF1E1E1E);
    const whiteTextColor = Colors.white;
    const subtleBorderColor = Colors.white24;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Statistics', style: TextStyle(color: whiteTextColor)),
        backgroundColor: darkBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMonthlyOverviewCard(cardBackgroundColor, subtleBorderColor),
            const SizedBox(height: 20),
            _buildMostSkippedCard(cardBackgroundColor, subtleBorderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyOverviewCard(Color cardColor, Color borderColor) {
    // Placeholder data
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Overview',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Placeholder for a chart
            Center(
              child: Text(
                'Chart will be displayed here',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMostSkippedCard(Color cardColor, Color borderColor) {
    // Placeholder data
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Skipped',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Placeholder for most skipped medications
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.medication, color: Colors.red, size: 40),
              title: Text('Metformin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Skipped 5 times this month', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
