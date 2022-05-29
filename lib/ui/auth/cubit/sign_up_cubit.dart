import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';

enum SignUpFormState { none, registered }

class SignUpCubit extends Cubit<SignUpFormState> {
  SignUpCubit(this._authRepository) : super(SignUpFormState.none);
  final AuthRepository _authRepository;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      _authRepository.signUp(
        email: email,
        password: password,
        name: name,
      );
      return null;
    } on AuthException catch (e) {
      print("error");
      return e.message;
    }
    return "No se pudo completar tu registro";
  }
}
