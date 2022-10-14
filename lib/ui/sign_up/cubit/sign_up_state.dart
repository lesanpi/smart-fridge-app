part of 'sign_up_cubit.dart';

/// {@template sign_up}
/// SignUpState description
/// {@endtemplate}
class SignUpState extends Equatable {
  /// {@macro sign_up}
  const SignUpState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const NonEmpty.pure(),
    this.name = const NonEmpty.pure(),
    this.errorMessage = '',
    this.samePassword = false,
  });

  /// Status
  final FormzStatus status;

  /// Email
  final Email email;

  /// Password
  final Password password;

  /// Confirm password
  final NonEmpty confirmPassword;

  /// Name
  final NonEmpty name;

  /// Same password;
  final bool samePassword;

  /// Error messsage
  final String errorMessage;

  @override
  List<Object> get props => [
        errorMessage,
        status,
        email,
        name,
        password,
        confirmPassword,
        errorMessage,
      ];

  /// Creates a copy of the current SignUpState with property changes
  SignUpState copyWith({
    FormzStatus? status,
    Email? email,
    Password? password,
    NonEmpty? confirmPassword,
    NonEmpty? name,
    String? errorMessage,
    bool? samePassword,
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      samePassword: samePassword ?? this.samePassword,
      name: name ?? this.name,
    );
  }
}

/// {@template sign_up_initial}
/// The initial state of SignUpState
/// {@endtemplate}
class SignUpInitial extends SignUpState {
  /// {@macro sign_up_initial}
  const SignUpInitial() : super();
}
