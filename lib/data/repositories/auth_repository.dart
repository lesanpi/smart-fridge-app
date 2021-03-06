import 'dart:convert';

import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';
import 'package:wifi_led_esp8266/models/auth_user.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  AuthUser? _user;

  AuthUser? get currentUser => _user;
  set currentUser(AuthUser? user) => {_user = user};

  /// Verify with the backend the current user,
  /// using the [token] in the persistent storage
  Future<AuthUser?> getCurrentUser(String? token) async {
    if (token != null) {
      final url = Uri.parse(Consts.httpLink + '/api/user');
      final Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      };
      final response = await http.post(url, headers: headers);

      print(response.body);
      currentUser = authUserFromJson(response.body);
      return currentUser;
    }

    return null;
  }

  /// Calls the backend and verify the credentials
  /// returns a [token] if results successfull
  /// in other case, throws a [AuthException]
  Future<String?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final url = Uri.parse(Consts.httpLink + '/api/login');

    final jsonData = jsonEncode({'email': email, 'password': password});
    final response =
        await http.post(url, body: jsonData, headers: Consts.headers);

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
      print('error sign in not 200 status');
      throw AuthException(error: AuthErrorCode.notAuth, message: body["error"]);
    }

    final _token = body["token"];
    await getCurrentUser(_token);

    return _token;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) async {
    String? error;
    // TODO: sign up

    print('sign up repository');

    final url = Uri.parse(Consts.httpLink + '/api/users');
    final jsonData = jsonEncode({
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
    });
    print('await response');

    final response = await http.post(
      url,
      body: jsonData,
      headers: Consts.headers,
    );
    print('response $response');

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    print('status');
    print(statusCode);
    print(body);

    if (statusCode != 200) {
      print('error repository not statusCode 200');
      throw AuthException(error: AuthErrorCode.notAuth, message: body["error"]);
    }
  }

  /// Set the [currentUser] to null
  void signOut() => {currentUser = null};
}
