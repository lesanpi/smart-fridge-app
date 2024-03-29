import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_led_esp8266/models/auth_user.dart';

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

  void updateUserData(AuthUser? authUser) async {
    final prefs = await SharedPreferences.getInstance();
    if (authUser != null) {
      prefs.setString('userData', authUserToJson(authUser));
    } else {
      prefs.remove("userData");
    }
  }

  Future<AuthUser?> getCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final stringAuthUser = prefs.get("userData") as String?;
    // print(stringAuthUser);
    if (stringAuthUser != null) {
      return authUserFromJsonStorage(stringAuthUser);
    }

    return null;
  }
}
