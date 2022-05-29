import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorageRepository {
  void updateToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      prefs.setString('token', token);
    } else {
      prefs.remove("token");
    }
  }

  Future<String?> getCurrentToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get("token") as String?;
  }
}
