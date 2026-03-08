import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final String filter;

  const HistoryList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    // This will be implemented later
    return Center(
      child: Text('History list with filter: $filter'),
    );
  }
}
