import 'package:shared_preferences/shared_preferences.dart';


class PreferencesUtil {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (!_sharedPreferences.containsKey('items')) {
        _sharedPreferences.setStringList('items', List.empty());
    } 
  }


  static List<String> getItems() => _sharedPreferences.getStringList('items')!;

  static void setItems(List<String> itemArray) async => await _sharedPreferences.setStringList('items', itemArray);
}