import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/exceptions/auth_exception.dart';
import 'package:wifi_led_esp8266/models/email.dart';
import 'package:wifi_led_esp8266/models/non_empty.dart';
import 'package:wifi_led_esp8266/models/password.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpInitial());
  final AuthRepository _authRepository;

  /// Password changed
  FutureOr<void> passwordChanged(String value) {
    final password = Password.dirty(value: value);
    emit(
      state.copyWith(
        password: password,
        samePassword: password.value == state.confirmPassword.value,
        status: Formz.validate([
          password,
          state.email,
          state.name,
        ]),
      ),
    );
  }

  /// Confirm password changed
  FutureOr<void> confirmPasswordChanged(String value) {
    final confirmPassword = NonEmpty.dirty(value: value);
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        samePassword: state.password.value == confirmPassword.value,
        status: Formz.validate([
          state.password,
          state.email,
          state.name,
        ]),
        // status: Formz.validate([password]),
      ),
    );
  }

  /// Name changed
  FutureOr<void> nameChanged(String value) {
    final name = NonEmpty.dirty(value: value);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          state.password,
          state.email,
          name,
        ]),
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
        status: Formz.validate([
          state.password,
          email,
          state.name,
        ]),
      ),
    );
  }

  FutureOr<void> signUp() async {
    if (state.status.isInvalid) {
      log('❌invalid form', name: 'SignUpCubit.signUp');
      return;
    }

    log('loading...', name: 'SignUpCubit.signUp');

    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.signUp(
        email: state.email.value,
        password: state.password.value,
        // TODO: phone
        phone: '04149137341',
        name: state.name.value,
      );
      emit(state.copyWith(
        status: FormzStatus.submissionSuccess,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: "No se pudo completar tu registro",
      ));
    }
  }
}
