import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  Future<bool> showNumberPhoneForConsultant() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_showNumberPhoneForConsultant") ?? true;
  }

  Future<bool> showNotification() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_showNotification") ?? true;
  }

  Future<bool> darkMode() async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_darkMode") ?? false;
  }

  void setShowNumberPhoneForConsultant(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_showNumberPhoneForConsultant", value);
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
