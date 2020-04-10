import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWrapper {
  SharedPreferences preferences;

  initialize() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  save(String key, String value) async {
    await this.preferences.setString(key, value);
  }

  String retrieve(String key) {
    String data = this.preferences.getString(key);
    return data;
  }
}
