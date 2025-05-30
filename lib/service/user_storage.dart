import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const String clientIdKey = 'client_id';
  static const String clientPassKey = 'client_pass';
  static const String userNameKey = 'user_name';

  static Future<void> saveClientId(String clientData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(clientIdKey, clientData);
  }

  static Future<String?> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(clientIdKey);
  }

  static Future<void> clearClientId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(clientIdKey);
  }

  static Future<void> saveClientPass(String clientData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(clientPassKey, clientData.toString());
  }

  static Future<String?> getClientPass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(clientPassKey);
  }

  static Future<void> clearClientPass() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(clientPassKey);
  }
   static Future<void> saveUserName(String clientData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, clientData.toString());
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static Future<void> clearUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userNameKey);
  }
}
