import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static Future<bool> showNumberPhoneForAgent() async {
    var pref = await SharedPreferences.getInstance();

    return await pref.getBool("settings_showNumberPhoneForAgent") ?? true;
  }

  static Future<bool> showNotification() async {
    var pref = await SharedPreferences.getInstance();

    return await pref.getBool("settings_showNotification") ?? true;
  }

  static Future<bool> darkMode() async {
    var pref = await SharedPreferences.getInstance();

    return await pref.getBool("settings_darkMode") ?? false;
  }

  static void setShowNumberPhoneForAgent(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_showNumberPhoneForAgent", value);
  }

  static void setShowNotification(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_showNotification", value);
  }

  static void setDarkMode(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_darkMode", value);
  }

  static void toggleShowNumberPhoneForAgent() async =>
      setShowNumberPhoneForAgent(!(await showNumberPhoneForAgent()));

  static void toggleShowNotification() async =>
      setShowNotification(!(await showNotification()));

  static void toggleDarkMode() async => setDarkMode(!(await darkMode()));
}
