import 'dart:developer';

import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/auth_user.dart';

class AuthUseCase {
  AuthUseCase(this._authRepository, this._persistentStorageRepository);

  final AuthRepository _authRepository;
  final PersistentStorageRepository _persistentStorageRepository;
  String? _token;
  AuthUser? _authUser;

  AuthUser? get currentUser => _authUser;

  /// Validates if the current user is not null
  Future<bool> validateLogin() async {
    final user = await getCurrentUser();
    // log("user ${user?.email}");
    return user != null;
  }

  /// Get the user from the backen using the [_token]
  /// and updates the [_authRepository.currentUser]
  Future<AuthUser?> getCurrentUser() async {
    // TODO: get current user
    _authUser = await _authRepository.getCurrentUser(_token).then((authUser) {
      _persistentStorageRepository.updateUserData(authUser);
      return authUser;
    }).onError((error, stackTrace) async {
      log('trayendo desde shared preferences por error');

      final AuthUser? authUser =
          await _persistentStorageRepository.getCurrentUserData();
      _authRepository.currentUser = authUser;
      return authUser;
    }).timeout(const Duration(seconds: 15), onTimeout: () async {
      log('[Timeout] trayendo desde shared preferences');
      final AuthUser? authUser =
          await _persistentStorageRepository.getCurrentUserData();
      _authRepository.currentUser = authUser;

      return authUser;
    });

    return _authUser;
  }

  /// Sign in using the [email] and [password] and
  /// save the new [_token] in persistent storage
  Future<AuthUser?> signIn(
      {required String email, required String password}) async {
    log('sign in use case');

    _token = await _authRepository.signInWithEmailAndPassword(
        email: email, password: password);
    final AuthUser? authUser = await getCurrentUser();
    _persistentStorageRepository.updateToken(_token);
    _persistentStorageRepository.updateUserData(authUser);

    return currentUser;
  }

  /// Deletes the [_token] in the persistent storage
  /// and set user to null in the [_authRepository]
  Future<void> signOut() async {
    // TODO: sign out from auth repository
    _token = null;
    _persistentStorageRepository.updateToken(null);
    _persistentStorageRepository.updateUserData(null);
    _authRepository.signOut();
  }

  /// Get the token in the persistent storage and
  /// retrieve the current user using the [_token]
  Future initializeAuth() async {
    _token = await _persistentStorageRepository.getCurrentToken();
    await getCurrentUser();
  }
}
