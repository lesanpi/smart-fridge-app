import 'dart:convert';
import 'dart:developer';

import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';
import 'package:wifi_led_esp8266/models/auth_user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthRepository {
  AuthUser? _user;

  AuthUser? get currentUser => _user;
  set currentUser(AuthUser? user) => {_user = user};

  /// Verify with the backend the current user,
  /// using the [token] in the persistent storage
  Future<AuthUser?> getCurrentUser(String? token) async {
    if (token != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final jsonData = jsonEncode({'fcmToken': fcmToken});

      final url = Uri.parse(Consts.httpLink + '/api/user');
      final Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.post(url, body: jsonData, headers: headers);

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
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final jsonData = jsonEncode(
        {'email': email, 'password': password, 'fcmToken': fcmToken});
    final response =
        await http.post(url, body: jsonData, headers: Consts.headers);

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
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

    final fcmToken = await FirebaseMessaging.instance.getToken();

    final url = Uri.parse(Consts.httpLink + '/api/users');
    final jsonData = jsonEncode({
      'email': email,
      'name': name,
      'phone': phone,
      'password': password,
      'fcmToken': fcmToken
    });

    final response = await http.post(
      url,
      body: jsonData,
      headers: Consts.headers,
    );

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
      throw AuthException(error: AuthErrorCode.notAuth, message: body["error"]);
    }
  }

  Future<bool> sendVerifyCode({
    required String email,
  }) async {
    final url = Uri.parse(Consts.httpLink + '/api/password/reset');
    final jsonData = jsonEncode({
      'email': email,
    });

    final response = await http.post(
      url,
      body: jsonData,
      headers: Consts.headers,
    );
    log(response.body, name: 'AuthRepository.sendVerifyCode');

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception('An error occurred');
    }
    return body['success'] as bool;
  }

  Future<bool> verifyCode({
    required String email,
    required String code,
  }) async {
    log(
      'Verifing code: $code, with email $email',
      name: 'AuthRepository.verifyCode',
    );
    final url = Uri.parse(Consts.httpLink + '/api/password/validate');
    final jsonData = jsonEncode({
      'email': email,
      'token': code,
    });

    final response = await http.post(
      url,
      body: jsonData,
      headers: Consts.headers,
    );
    log(response.body, name: 'AuthRepository.verifyCode');

    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception('An error occurred');
    }
    return body['success'] as bool;
  }

  Future<bool> changePassword({
    required String password,
    required String code,
  }) async {
    final url = Uri.parse(Consts.httpLink + '/api/password/change');
    final jsonData = jsonEncode({
      'password': password,
      'token': code,
    });

    final response = await http.post(
      url,
      body: jsonData,
      headers: Consts.headers,
    );

    log(response.body, name: 'AuthRepository.changePassword');
    final body = jsonDecode(response.body);
    final statusCode = response.statusCode;

    if (statusCode != 200) {
      throw Exception('An error occurred');
    }
    return body['success'] as bool;
  }

  /// Set the [currentUser] to null
  void signOut() => {currentUser = null};
}
