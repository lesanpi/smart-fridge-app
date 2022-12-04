import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/models/email.dart';
import 'package:wifi_led_esp8266/models/non_empty.dart';
import 'package:wifi_led_esp8266/models/password.dart';
part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._authRepository)
      : super(const ForgetPasswordState());
  final AuthRepository _authRepository;

  /// New Password changed
  FutureOr<void> passwordChanged(String value) {
    final newPassword = Password.dirty(value: value);
    emit(
      state.copyWith(
        newPassword: newPassword,
        status: Formz.validate([newPassword]),
      ),
    );
  }

  FutureOr<void> passwordConfirmChanged(String value) {
    final newPasswordConfirm = NonEmpty.dirty(value: value);
    emit(
      state.copyWith(
        newPasswordConfirm: newPasswordConfirm,
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

  /// Code changed
  FutureOr<void> codeChanged(String value) async {
    final code = NonEmpty.dirty(value: value);
    emit(
      state.copyWith(
        code: code,
      ),
    );

    if (state.code.value.length != 6) return null;

    verifyCode();
  }

  FutureOr<void> verifyCode() async {
    if (state.code.value.length != 6) return;
    if (state.step != ForgetPasswordStep.code) return;

    log('Verifying code', name: 'ForgetPasswordCubit');
    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));

    // await Future<void>.delayed(const Duration(seconds: 3));
    try {
      bool success = await _authRepository.verifyCode(
        email: state.email.value,
        code: state.code.value,
      );
      if (success) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            step: ForgetPasswordStep.newPassword,
            message:
                'Código verificado correctamente. Indique su nueva contraseña',
          ),
        );
        emit(state.copyWith(status: FormzStatus.pure));
      } else {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Código inválido',
        ));
        emit(state.copyWith(status: FormzStatus.pure));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Error al intentar verificar código',
      ));
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }

  FutureOr<void> emailSubmitted() async {
    if (state.email.invalid) return null;
    log('Submitting mail', name: 'ForgetPasswordCubit');

    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));

    try {
      bool success = await _authRepository.sendVerifyCode(
        email: state.email.value,
      );
      if (success) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            step: ForgetPasswordStep.code,
            message:
                'Se ha enviado un código de verificación a su correo electrónico.',
          ),
        );
        emit(state.copyWith(status: FormzStatus.pure));
      } else {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Error al enviar código de verificación',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Error al enviar código de verificación',
      ));
    }
    // await Future<void>.delayed(const Duration(seconds: 3));
    // emit(state.copyWith(
    //   status: FormzStatus.pure,
    //   step: ForgetPasswordStep.code,
    // ));
  }

  FutureOr<void> backButtonPressed() {
    // if (state.step == ForgetPasswordStep.newPassword) {
    //   emit(
    //     state.copyWith(step: ForgetPasswordStep.code),
    //   );
    //   return null;
    // }
    if (state.step == ForgetPasswordStep.code) {
      emit(
        state.copyWith(step: ForgetPasswordStep.email),
      );
      return null;
    }
    if (state.step == ForgetPasswordStep.email) return null;
  }

  FutureOr<void> changePasswordPressed() async {
    if (state.newPassword.invalid) return null;
    if (state.newPasswordConfirm.invalid) return null;
    log('changePasswordPressed', name: 'ForgetPasswordCubit');

    emit(state.copyWith(
      status: FormzStatus.submissionInProgress,
    ));

    try {
      bool success = await _authRepository.changePassword(
        password: state.newPassword.value,
        code: state.code.value,
      );
      if (success) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
            step: ForgetPasswordStep.success,
            message: 'Tu nueva contraseña ha sido guardada con éxito',
          ),
        );
      } else {
        emit(state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: 'Error al intentar guardar tu nueva contraseña',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: FormzStatus.submissionFailure,
        errorMessage: 'Error al intentar guardar tu nueva contraseña',
      ));
    }
    emit(state.copyWith(status: FormzStatus.pure));
  }
}
