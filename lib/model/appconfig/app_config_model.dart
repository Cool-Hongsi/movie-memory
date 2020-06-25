import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const/const_config/const_config.dart';

class AppConfigModel with ChangeNotifier {
  String language;
  String unit;  // imperial , metric
  bool isInit = false;

  AppConfigModel() {
    // print('Call AppConfig');
    getAppConfig();
  }

  Future<bool> getAppConfig() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      language = prefs.getString("language") ?? kDefaultAppConfig['DefaultLanguage'];
      unit = prefs.getString("unit") ?? kDefaultAppConfig['DefaultUnit'];
      isInit = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  // This is called when config has been changed.
  // For example, Language or unit is changed, then call this to apply.
  Future<Map> loadAppConfig() async {
    try {
      if (!isInit) {
        await getAppConfig();
      }
      return null;
    } catch(e) {
      notifyListeners();
      return null;
    }
  }
}