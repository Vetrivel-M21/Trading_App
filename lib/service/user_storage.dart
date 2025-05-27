import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String clientIdKey = 'client_id';

  static Future<void> saveClientId(String clientId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(clientIdKey, clientId);
  }

  static Future<String?> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(clientIdKey);
  }

  static Future<void> clearClientId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(clientIdKey);
  }
}
