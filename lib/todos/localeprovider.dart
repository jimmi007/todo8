import 'package:flutter/material.dart';

import 'package:todo/l10n/l10n.dart'; // Assuming L10n contains supported locales

class LocaleProvider extends ChangeNotifier {
  // Initial locale, defaulting to English.
  Locale _locale = Locale('en');

  // Getter to access the current locale.
  Locale get locale => _locale;

  // Setter to change the locale.
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return; // Check if the locale is supported

    _locale = locale;
    notifyListeners(); // Notify all listeners to update the UI.
  }

  // Method to clear the locale (optional, for resetting to default).
  void clearLocale() {
    _locale = Locale('en');
    notifyListeners(); // Reset to default language and notify listeners.
  }
}
