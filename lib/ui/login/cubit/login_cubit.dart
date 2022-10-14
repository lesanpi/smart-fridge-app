import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';
import 'package:wifi_led_esp8266/models/email.dart';
import 'package:wifi_led_esp8266/models/non_empty.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authUseCase) : super(const LoginInitial());
  final AuthUseCase _authUseCase;

  /// Password changed
  FutureOr<void> passwordChanged(String value) {
    final password = NonEmpty.dirty(value: value);
    emit(
      state.copyWith(
        password: password,
        // status: Formz.validate([password]),
      ),
    );
  }

  /// Email changed
  FutureOr<void> emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email]),
      ),
    );
  }

  /// Login button pressed
  FutureOr<void> loginButtonPressed() async {
    if (state.status.isPure) return;
    if (state.email.pure) return;
    if (state.password.value.isEmpty) return;

    if (state.status.isInvalid) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final authUser = await _authUseCase.signIn(
        email: state.email.value,
        password: state.password.value,
      );
      if (authUser != null) {
        return emit(state.copyWith(status: FormzStatus.submissionSuccess));
      }

      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Error al iniciar sesión',
      ));
    } on AuthException catch (e) {
      if (e.error == AuthErrorCode.notAuth) {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Correo electrónico o contraseña incorrecta',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Error al iniciar sesión',
      ));
    }

    emit(state.copyWith(
      status: Formz.validate([state.email]),
      errorMessage: '',
    ));
  }
}
