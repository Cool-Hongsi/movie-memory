import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/const_config/const_config.dart';

class AppConfigModel with ChangeNotifier {
  Locale _appLocale = Locale(kDefaultLang['DefaultLanguage']);

  Locale get appLocal => _appLocale ?? Locale(kDefaultLang['DefaultLanguage']);

  AppConfigModel() {
    fetchLocale();
  }

  Future<void> fetchLocale() async {
    print("Call fetchLocale()");
    
    var prefs = await SharedPreferences.getInstance();

    if (prefs.getString('language_code') == null) {
      _appLocale = Locale(kDefaultLang['DefaultLanguage']);
      return null;
    }

    _appLocale = Locale(prefs.getString('language_code'));

    return null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();

    if (_appLocale == type) {
      return;
    }

    if (type == Locale(kKoLang['DefaultLanguage'])) { // Korean
      _appLocale = Locale(kKoLang['DefaultLanguage']);
      await prefs.setString('language_code', kKoLang['DefaultLanguage']);
      await prefs.setString('countryCode', kKoLang['DefaultCountryCode']);
    }
    else if (type == Locale(kCnLang['DefaultLanguage'])){ // Chinese
      _appLocale = Locale(kCnLang['DefaultLanguage']);
      await prefs.setString('language_code', kCnLang['DefaultLanguage']);
      await prefs.setString('countryCode', kCnLang['DefaultCountryCode']);
    }    
    else {
      _appLocale = Locale(kDefaultLang['DefaultLanguage']); // English
      await prefs.setString('language_code', kDefaultLang['DefaultLanguage']);
      await prefs.setString('countryCode', kDefaultLang['DefaultCountryCode']);
    }
    notifyListeners();
  }

}