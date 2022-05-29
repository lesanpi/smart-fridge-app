import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';

enum SignInState { none, existingUser }

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authUseCase) : super(SignInState.none);
  final AuthUseCase _authUseCase;

  Future<String?> signIn(
      {required String email, required String password}) async {
    print('sign in cubit');
    try {
      final result =
          await _authUseCase.signIn(email: email, password: password);
      if (result != null) {
        // Go to IndexPages
        print('existing user');
        emit(SignInState.existingUser);
        return null;
      }

      return 'Error al iniciar sesión';
    } on AuthException catch (e) {
      if (e.error == AuthErrorCode.notAuth) {
        // Show dialog with error
        print('not auth');
        emit(SignInState.none);
        return 'Correo electrónico o contraseña incorrecta';
      }
    } on Exception catch (e) {
      emit(SignInState.none);
      print('sign in error');
      return 'Error al iniciar sesión';
    }
  }
}
