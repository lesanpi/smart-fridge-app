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
    required String phone,
    required String name,
  }) async {
    print("Haciendo el sign up");
    // await Future.delayed(const Duration(seconds: 1));
    try {
      print('sign up');
      await _authRepository.signUp(
        email: email,
        password: password,
        phone: phone,
        name: name,
      );
      return null;
      print('salio del sign up');
    } on AuthException catch (e) {
      print('auth exception cubit');

      return e.message;
    } catch (e) {
      print('exception cubit');
      print(e.runtimeType);
      print('e');

      return "No se pudo completar tu registro";
    }
  }
}
