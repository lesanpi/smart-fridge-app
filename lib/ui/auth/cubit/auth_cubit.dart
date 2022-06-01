import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  SIGNUP,
  SIGNIN,
  RECOVER,
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.SIGNIN);

  void goTo(AuthState authState) {
    print('Go to $authState');
    emit(authState);

  }
}
