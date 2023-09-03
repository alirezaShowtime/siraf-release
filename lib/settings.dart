import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  Future<bool> showNotification() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_showNotification") ?? true;
  }

  Future<bool> darkMode() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_darkMode") ?? false;
  }

  void setShowNotification(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_showNotification", value);
  }

  void setDarkMode(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_darkMode", value);
  }
}
