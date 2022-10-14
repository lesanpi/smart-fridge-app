part of 'login_cubit.dart';

/// {@template login}
/// LoginState description
/// {@endtemplate}
class LoginState extends Equatable {
  /// {@macro login}
  const LoginState({
    this.status = FormzStatus.pure,
    this.email = const Email.pure(),
    this.password = const NonEmpty.pure(),
    this.errorMessage = '',
  });

  /// Status
  final FormzStatus status;

  /// Email
  final Email email;

  /// Password
  final NonEmpty password;

  /// Error messsage
  final String errorMessage;

  @override
  List<Object> get props => [
        email,
        status,
        password,
        errorMessage,
      ];

  /// Creates a copy of the current LoginState with property changes
  LoginState copyWith({
    FormzStatus? status,
    Email? email,
    NonEmpty? password,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// {@template login_initial}
/// The initial state of LoginState
/// {@endtemplate}
class LoginInitial extends LoginState {
  /// {@macro login_initial}
  const LoginInitial() : super();
}
