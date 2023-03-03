import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  Future<bool> showNumberPhoneForAgent() async {
    var pref = await SharedPreferences.getInstance();

    var v = pref.getBool("settings_showNumberPhoneForAgent") ?? true;
    print("settings_showNumberPhoneForAgent $v");

    return v;
  }

  Future<bool> showNotification() async {
    var pref = await SharedPreferences.getInstance();

    var v =  pref.getBool("settings_showNotification") ?? true;
    print("settings_showNotification $v");
    return v;
  }

  Future<bool> darkMode() async {
    var pref = await SharedPreferences.getInstance();

    var v = pref.getBool("settings_darkMode") ?? false;

    print("settings_darkMode $v");

    return v;
  }

  void setShowNumberPhoneForAgent(bool value) async {
    var pref = await SharedPreferences.getInstance();

    await pref.setBool("settings_showNumberPhoneForAgent", value);
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
