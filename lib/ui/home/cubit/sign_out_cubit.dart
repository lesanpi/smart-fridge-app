import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';

class SignOutCubit extends Cubit<void> {
  SignOutCubit(this._authUseCase) : super(null);
  final AuthUseCase _authUseCase;

  Future<void> signOut() async {
    _authUseCase.signOut();
    await Future.delayed(const Duration(seconds: 1));
    emit(null);
  }
}
