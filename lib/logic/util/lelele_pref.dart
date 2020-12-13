
import 'package:shared_preferences/shared_preferences.dart';

///
/// Shared Preferenceを管理する
///
///
class LeLeLePref {

  static SharedPreferences _prefs;

  LeLeLePref() {

    init();
  }


  void init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  void setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  void setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  dynamic getValue(String key) {
    return _prefs.get(key);
  }

}