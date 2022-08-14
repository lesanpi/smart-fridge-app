import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/sign_in_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/view/sign_in_page.dart';
import 'package:wifi_led_esp8266/ui/auth/view/sign_up_page.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';
import 'package:wifi_led_esp8266/utils/validators.dart';
import 'package:wifi_led_esp8266/widgets/form_input.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final textTheme = Theme.of(context).textTheme;
  late final size = MediaQuery.of(context).size;
  late Widget _cardContent = const SizedBox.shrink();

  final Duration duration = const Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          onAuthStateChanged(state);
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            // backgroundColor: Theme.of(context).primaryColorDark,
            body: SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    const SignInPage(),
                    Positioned(
                      bottom: 0,
                      height: 80,
                      width: size.width,
                      child: Material(
                        elevation: 100,
                        // shadowColor: Colors.black,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Consts.fontDark,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      top: state == AuthState.SIGNIN
                          ? size.height
                          : size.height * 0.1,
                      height: size.height * 0.9,
                      width: size.width,
                      child: AnimatedSwitcher(
                        duration: duration,
                        child: _cardContent,
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1.0),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                      duration: duration,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onAuthStateChanged(AuthState state) {
    // print(state);
    if (state == AuthState.SIGNIN) {
      _cardContent = const SizedBox.shrink();
    } else if (state == AuthState.SIGNUP) {
      _cardContent = const SignUpPage();
    } else if (state == AuthState.RECOVER) {
      // _cardContent = RecoverPasswordWidget();
    }

    setState(() {});
  }
}
