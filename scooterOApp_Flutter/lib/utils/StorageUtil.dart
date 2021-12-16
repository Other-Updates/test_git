   import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  StorageUtil._();
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// ----------------------------------------------------------
  /// Generic routine to fetch an application preference
  /// ----------------------------------------------------------
  static Future<String> getItem(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(name) ?? '';
  }

  /// ----------------------------------------------------------
  /// Generic routine to saves an application preference
  /// ----------------------------------------------------------
  static Future<bool> setItem(String name, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(name, value);
  }

  static Future<bool> setBoolItem(String name, value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setBool(name, value);
  }

  static Future<Set<String>> getAll() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getKeys();
  }

  static Future<bool> isPresent(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(name) != null ?true:false;
  }

  static Future<bool> remove(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove(name) != null ?true:false;
  }

  static Future<bool> removeAll() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.clear() == null ?true:false;
  }

  static getLocalLanguage(String name) async {
    final SharedPreferences prefs = await _prefs;
    if(prefs.getString("language_contents") != null){
      var data = jsonDecode(prefs.getString("language_contents"));
      return data != null?data[name]:' ';
    }else{
      return name;
    }
  }


}