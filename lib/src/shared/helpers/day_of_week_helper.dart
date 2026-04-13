// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/models/day_of_week.dart';

String getLocalizedDayOfWeek(BuildContext context, DayOfWeek day) {
  final l10n = AppLocalizations.of(context)!;
  switch (day) {
    case DayOfWeek.monday:
      return l10n.monday;
    case DayOfWeek.tuesday:
      return l10n.tuesday;
    case DayOfWeek.wednesday:
      return l10n.wednesday;
    case DayOfWeek.thursday:
      return l10n.thursday;
    case DayOfWeek.friday:
      return l10n.friday;
    case DayOfWeek.saturday:
      return l10n.saturday;
    case DayOfWeek.sunday:
      return l10n.sunday;
  }
}
