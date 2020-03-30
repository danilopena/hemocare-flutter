import 'package:localstorage/localstorage.dart';

class LocalStorageWrapper {
  final LocalStorage localStorage = new LocalStorage('hemocare');

  save(String key, String value) async {
    localStorage.setItem(key, value);
    print("Item ${localStorage.getItem(key)} saved");
  }

  String retrieve(String key) {
    String data = localStorage.getItem(key);
    return data;
  }
}
