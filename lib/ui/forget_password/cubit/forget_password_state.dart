part of 'forget_password_cubit.dart';

enum ForgetPasswordStep { email, code, newPassword, success }

/// {@template forget_password}
/// ForgetPasswordState description
/// {@endtemplate}
class ForgetPasswordState extends Equatable {
  /// {@macro forget_password}
  const ForgetPasswordState({
    this.customProperty = 'Default Value',
    this.step = ForgetPasswordStep.email,
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.code = const NonEmpty.pure(),
    this.newPassword = const Password.pure(),
    this.newPasswordConfirm = const NonEmpty.pure(),
    this.errorMessage = '',
    this.message = '',
  });

  /// A description for customProperty
  final String customProperty;
  final ForgetPasswordStep step;
  final FormzStatus status;
  final Email email;
  final NonEmpty code;
  final Password newPassword;
  final NonEmpty newPasswordConfirm;
  final String errorMessage;
  final String message;

  @override
  List<Object?> get props => [
        customProperty,
        step,
        status,
        email,
        code,
        newPassword,
        newPasswordConfirm,
        errorMessage,
        message,
      ];

  /// Creates a copy of the current ForgetPasswordState with property changes
  ForgetPasswordState copyWith({
    String? customProperty,
    NonEmpty? code,
    NonEmpty? newPasswordConfirm,
    Password? newPassword,
    ForgetPasswordStep? step,
    Email? email,
    FormzStatus? status,
    String? errorMessage,
    String? message,
  }) {
    return ForgetPasswordState(
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      newPasswordConfirm: newPasswordConfirm ?? this.newPasswordConfirm,
      customProperty: customProperty ?? this.customProperty,
      email: email ?? this.email,
      step: step ?? this.step,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
    );
  }
}

/// {@template forget_password_initial}
/// The initial state of ForgetPasswordState
/// {@endtemplate}
class ForgetPasswordInitial extends ForgetPasswordState {
  /// {@macro forget_password_initial}
  const ForgetPasswordInitial() : super();
}
