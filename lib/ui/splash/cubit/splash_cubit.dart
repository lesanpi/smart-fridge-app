import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';

enum SplashState { loading, none, existingUser }

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.authUseCase) : super(SplashState.loading);
  AuthUseCase authUseCase;

  /// Method called when the App starts. Verifies and get the current user, then emit a [SplashState]
  /// to navigate to the [HomePage] or the [AuthPage]
  /// according if the user exist or not
  void init() async {
    await authUseCase.initializeAuth();
    // print("Splash User email: ${user?.email}");
    bool result = await authUseCase.validateLogin();
    if (result) {
      emit(SplashState.existingUser);
    } else {
      emit(SplashState.none);
    }
  }
}
