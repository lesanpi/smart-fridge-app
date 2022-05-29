import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/model/auth_user.dart';

class AuthUseCase {
  AuthUseCase(this._authRepository, this._persistentStorageRepository);

  final AuthRepository _authRepository;
  final PersistentStorageRepository _persistentStorageRepository;
  String? _token;

  AuthUser? get currentUser => _authRepository.currentUser;

  /// Validates if the current user is not null
  Future<bool> validateLogin() async {
    final user = _authRepository.currentUser;
    print("user ${user?.email}");
    return user != null;
  }

  /// Get the user from the backen using the [_token]
  /// and updates the [_authRepository.currentUser]
  Future<AuthUser?> getCurrentUser() async {
    /// TODO: get current user
    return await _authRepository.getCurrentUser(_token);
  }

  /// Sign in using the [email] and [password] and
  /// save the new [_token] in persistent storage
  Future<AuthUser?> signIn(
      {required String email, required String password}) async {
    print('sign in use case');

    _token = await _authRepository.signInWithEmailAndPassword(
        email: email, password: password);
    _persistentStorageRepository.updateToken(_token);
    await getCurrentUser();

    return currentUser;
  }

  /// Deletes the [_token] in the persistent storage
  /// and set user to null in the [_authRepository]
  Future<void> signOut() async {
    /// TODO: sign out from auth repository
    _persistentStorageRepository.updateToken(null);
    _authRepository.signOut();
  }

  /// Get the token in the persistent storage and
  /// retrieve the current user using the [_token]
  Future initializeAuth() async {
    _token = await _persistentStorageRepository.getCurrentToken();
    await getCurrentUser();
  }
}
