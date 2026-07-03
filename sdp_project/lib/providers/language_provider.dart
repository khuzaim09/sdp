import 'package:flutter/material.dart';
import '../core/language_strings.dart';

class LanguageProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;
  bool get isUrdu => _language == AppLanguage.urdu;
  TextDirection get textDirection =>
      _language == AppLanguage.urdu ? TextDirection.rtl : TextDirection.ltr;

  void toggleLanguage() {
    _language = _language == AppLanguage.english
        ? AppLanguage.urdu
        : AppLanguage.english;
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  String tr(String key) {
    return AppStrings.get(key, _language);
  }
}
