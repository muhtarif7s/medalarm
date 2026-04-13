import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final langCode = sharedPreferences.getString('langCode');
    if (langCode != null) {
      state = Locale(langCode);
    } else {
      state = const Locale('en');
    }
  }

  Future<void> setLocale(Locale locale) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('langCode', locale.languageCode);
    state = locale;
  }
}

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final langCode = sharedPreferences.getString('langCode');
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('langCode', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  String getLangName(String langCode) {
    switch (langCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
