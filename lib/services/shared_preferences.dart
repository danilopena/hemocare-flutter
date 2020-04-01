import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWrapper {
  SharedPreferences preferences;

  initialize() async {
    this.preferences = await SharedPreferences.getInstance();
    print("La preferencia la respuesta: ${this.preferences}");
  }

  save(String key, String value) async {
    await this.preferences.setString(key, value);
    print("Item ${this.preferences.getString(key)} saved");
  }

  String retrieve(String key) {
    String data = this.preferences.getString(key);
    return data;
  }
}
