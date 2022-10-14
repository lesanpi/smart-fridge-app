import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  signUp,
  signIn,
  RECOVER,
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.signIn);

  void goTo(AuthState authState) {
    emit(authState);
  }
}
