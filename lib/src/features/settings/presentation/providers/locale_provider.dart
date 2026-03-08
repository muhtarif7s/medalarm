import 'package:flutter/material.dart';

abstract class LocaleProvider extends ChangeNotifier {
  Locale? get locale;
  void setLocale(Locale locale);
  String getLangName(String langCode);
}
