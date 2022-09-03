import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/sign_in_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/widgets/open_sign_up_form_button.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';
import 'package:wifi_led_esp8266/utils/validators.dart';
import 'package:wifi_led_esp8266/widgets/form_input.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final textTheme = Theme.of(context).textTheme;

  /// Email input controller.
  final emailController = TextEditingController();
  get email => emailController.text;

  /// Password input controller.
  final passwordController = TextEditingController();
  get password => passwordController.text;

  /// Form Key
  final _signInFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Consts.lightSystem.shade300,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Consts.accent.shade400,
        centerTitle: true,
        title: Text(
          'Iniciar sesión',
          style: textTheme.headline5?.copyWith(
            color: Consts.neutral.shade100,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => SignInCubit(context.read()),
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state == SignInState.existingUser) {
              print('correct auth');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Consts.defaultPadding * 2,
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _signInFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.ac_unit_outlined,
                          size: 150,
                          color: Consts.accent,
                        ),
                        const SizedBox(height: Consts.defaultPadding * 2),
                        emailInput(),
                        const SizedBox(height: Consts.defaultPadding),
                        passwordInput(),
                        const SizedBox(height: Consts.defaultPadding / 2),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                letterSpacing: -0.02,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Consts.defaultPadding / 2),
                        Row(
                          children: [
                            const Expanded(child: OpenSignUpFormButton()),
                            const SizedBox(width: Consts.defaultPadding),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _onSignInPressed(context),
                                child: Text(
                                  "INGRESAR",
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Function()? _onSignInPressed(BuildContext context) {
    if (_signInFormKey.currentState == null) return null;

    if (!_signInFormKey.currentState!.validate()) return null;

    return () async {
      print('button sign in');
      _signIn(context);
    };
  }

  void _signIn(BuildContext context) async {
    await futureLoadingIndicator(
      context,
      context.read<SignInCubit>().signIn(email: email, password: password),
    ).then((_errorMessage) async {
      if (_errorMessage != null) {
        await onDialogMessage(
          context: context,
          title: 'Hubo un problema...',
          message: _errorMessage,
          warning: true,
          warningCallback: () {
            _signIn(context);
          },
        );
      }
    });
  }

  FormInput emailInput() {
    return FormInput(
      title: 'Correo electrónico',
      controller: emailController,
      titleColor: Consts.neutral.shade700,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.mail_outline),
        hintText: 'Ingrese su correo electrónico',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.primary.shade400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Consts.accent),
          borderRadius: BorderRadius.circular(Consts.borderRadius),
        ),
        // hoverColor: Colors.yellow,
        // focusColor: Colors.yellow,
      ),
      keyboardType: TextInputType.emailAddress,
      // validator: Validators.validateEmail,
      onChanged: (_) => setState(() => {}),
    );
  }

  FormInput passwordInput() {
    return FormInput(
      title: 'Contraseña',
      controller: passwordController,
      titleColor: Consts.neutral.shade700,
      obscureText: true,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock_outline),
        hintText: 'Ingrese contraseña',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.primary.shade400,
        ),
      ),
      // validator: Validators.validatePassword,
      onChanged: (_) => setState(() => {}),
    );
  }
}