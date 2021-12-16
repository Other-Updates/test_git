import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Language {
  static String getLocalLanguage(SharedPreferences prefs, String name) {
    // return prefs?.getString("language_contents");
    if (prefs?.getString("language_contents") != null) {
      var data = jsonDecode(prefs?.getString("language_contents"));
      return data != null ? data[name] : ' ';
    } else {
      return name;
    }
  }

  static String getStringValue(SharedPreferences prefs, String name) {
    if (prefs?.getString(name) != null) {
      return prefs?.getString(name);
    } else {
      return "";
    }
  }

}


