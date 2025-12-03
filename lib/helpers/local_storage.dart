import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedUidKey = 'saved_uid';

  // Save remember me preference
  static Future<void> setRememberMe(bool remember, String? email, String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, remember);

    if (remember && email != null && uid != null) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedUidKey, uid);
    } else {
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedUidKey);
    }
  }

  // Get remember me preference
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // Get saved email
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedEmailKey);
  }

  // Get saved UID
  static Future<String?> getSavedUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_savedUidKey);
  }

  // Clear saved credentials
  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedUidKey);
  }
}