import 'package:flutter/material.dart';

class MonALocale {
  // to prevent initialization
  MonALocale._();

  // list of codes of the supported languages in project MonA
  static const List<String> supportedLanguageCodes = [
    "EN",
    "DE",
    "EL",
    "IT",
    "NL",
  ];

  // list of supported locales in project MonA
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('de', ''),
    Locale('el', ''),
    Locale('it', ''),
    Locale('nl', ''),
  ];

  // mapping of codes and locales
  static const Map<String, Locale> codeLocaleMapping = {
    "EN": Locale('en', 'US'),
    "DE": Locale('de', ''),
    "EL": Locale('el', ''),
    "IT": Locale('it', ''),
    "NL": Locale('nl', ''),
  };
}

class MonALocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    // return if the given locale is not in supported list of locales
    if (!MonALocale.supportedLocales.contains(locale)) return;

    // else set the locale and notify
    _locale = locale;
    notifyListeners();
  }
}
