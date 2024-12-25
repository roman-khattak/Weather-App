import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  final String lastCityKey = "lastCity";

  Future<void> saveLastCity(String city) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(lastCityKey, city); // Use proper key-value pair
  }

  Future<String> getLastCity() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(lastCityKey) ?? "Peshawar"; // Default to "Peshawar"
  }
}
