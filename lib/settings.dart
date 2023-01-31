import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static Future<bool> get showNumberPhoneForAgent async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_showNumberPhoneForAgent") ?? true;
  }

  static Future<bool> get showNotification async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_showNotification") ?? true;
  }

  static Future<bool> get darkMode async {
    var pref = await SharedPreferences.getInstance();

    return pref.getBool("settings_darkMode") ?? false;
  }

  static void setShowNumberPhoneForAgent(bool value) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool("settings_showNumberPhoneForAgent", value);
    });
  }

  static void setShowNotification(bool value) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool("settings_showNotification", value);
    });
  }

  static void setDarkMode(bool value) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool("settings_darkMode", value);
    });
  }

  static void toggleShowNumberPhoneForAgent() async => setShowNumberPhoneForAgent(!(await showNumberPhoneForAgent));

  static void toggleShowNotification() async => setShowNotification(!(await showNotification));

  static void toggleDarkMode() async => setDarkMode(!(await darkMode));
}
