import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/auth_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/sign_in_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/cubit/sign_up_cubit.dart';
import 'package:wifi_led_esp8266/ui/auth/widgets/back_to_sign_in_button.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';
import 'package:wifi_led_esp8266/utils/validators.dart';
import 'package:wifi_led_esp8266/utils/venezuela.dart';
import 'package:wifi_led_esp8266/widgets/form_dropdown_with_text.dart';
import 'package:wifi_led_esp8266/widgets/form_input.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late final textTheme = Theme.of(context).textTheme;
  late final size = MediaQuery.of(context).size;

  /// Email input controller.
  final emailController = TextEditingController();
  get email => emailController.text;

  /// Email input controller.
  final nameController = TextEditingController();
  get name => nameController.text;

  // Phone Number
  final phoneNumberController = TextEditingController();
  get phoneNumber => phoneNumberController.text;
  String prefixPhoneNumberSelected = Venezuela.phoneNumberPrefixes.first;

  /// Password input controller.
  final passwordController = TextEditingController();
  get password => passwordController.text;

  /// Confirm Password input controller.
  final confirmPasswordController = TextEditingController();
  get confirmPassword => confirmPasswordController.text;

  /// Form Key
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return BlocProvider(
      create: (context) => SignUpCubit(context.read()),
      child: BlocConsumer<SignUpCubit, SignUpFormState>(
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
          return Container(
            margin: EdgeInsets.only(bottom: bottomInsets),
            child: PhysicalModel(
              color: Consts.darkSystem.shade300,
              elevation: 50,
              // width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Consts.defaultPadding * 2,
                ),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: Consts.defaultPadding * 2),
                          Icon(
                            Icons.ac_unit_outlined,
                            size: 150,
                            color: Consts.lightSystem.shade100,
                          ),
                          const SizedBox(height: Consts.defaultPadding * 2),
                          emailInput(),
                          const SizedBox(height: Consts.defaultPadding),
                          nameInput(),
                          const SizedBox(height: Consts.defaultPadding),
                          phoneNumberInput(),
                          const SizedBox(height: Consts.defaultPadding),
                          passwordInput(),
                          const SizedBox(height: Consts.defaultPadding),
                          confirmPasswordInput(),
                          const SizedBox(height: Consts.defaultPadding),
                          ElevatedButton(
                            onPressed: _onPressedSignUp(context),
                            child: Text(
                              'REGISTRARSE',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Consts.primary.shade400,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .copyWith(
                                  backgroundColor: MaterialStateProperty.all(
                                      Consts.lightSystem.shade100),
                                ),
                          ),
                          const SizedBox(height: Consts.defaultPadding),
                          const BackToSignInButton(),
                          const SizedBox(height: Consts.defaultPadding * 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Function()? _onPressedSignUp(BuildContext context) {
    if (_signUpFormKey.currentState == null) return null;

    if (!_signUpFormKey.currentState!.validate()) return null;

    return () async {
      print('button sign up');
      _signUp(context);
    };
  }

  void _signUp(BuildContext context) async {
    await futureLoadingIndicator(
      context,
      context.read<SignUpCubit>().signUp(
            email: email,
            password: password,
            name: name,
            phone: prefixPhoneNumberSelected + phoneNumber,
          ),
      // timeoutAt: const Duration(seconds: 20),
    ).then((_errorMessage) async {
      print('error message $_errorMessage');
      if (_errorMessage != null) {
        await onDialogMessage(
          context: context,
          title: 'Hubo un problema...',
          message: _errorMessage,
          warning: true,
          warningCallback: () {
            _signUp(context);
          },
        );
      } else {
        await onDialogMessage(
          context: context,
          title: '¡Registro exitoso!',
          message: 'Ahora puedes iniciar sesión',
        );
        // context.read<AuthCubit>().goTo(AuthState.SIGNIN);
      }
    });
  }

  FormInput emailInput() {
    return FormInput(
      title: 'Correo electrónico',
      controller: emailController,
      // titleColor: Consts.primary,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.mail_outline),
        fillColor: Colors.white,
        hintText: 'Ingrese su correo electrónico',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.error,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
      onChanged: (_) => setState(() => {}),
    );
  }

  FormInput nameInput() {
    return FormInput(
      title: 'Nombre',
      controller: nameController,
      // titleColor: Consts.primary,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.mail_outline),
        fillColor: Colors.white,
        hintText: 'Ingrese su nombre',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.error,
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmpty,
      onChanged: (_) => setState(() => {}),
    );
  }

  Widget phoneNumberInput() {
    return FormDropdownWithText(
      controller: phoneNumberController,
      value: prefixPhoneNumberSelected,
      itemOptions: Venezuela.phoneNumberPrefixes,
      dropdownDecoration: const InputDecoration(hintText: "-"),
      textInputDecoration: const InputDecoration(
        hintText: 'Ingrese su número celular',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
        LengthLimitingTextInputFormatter(7),
      ],
      title: "Número celular",
      onChanged: (value) {
        setState(() {
          prefixPhoneNumberSelected = value ?? "V";
        });
      },
      onChangedText: (_) => setState(() {}),
      keyboardType: TextInputType.phone,
      validator: Validators.validatePhone,
    );
  }

  FormInput passwordInput() {
    return FormInput(
      title: 'Contraseña',
      controller: passwordController,
      // titleColor: Consts.neutral.shade700,
      obscureText: true,
      decoration: InputDecoration(
        fillColor: Colors.white,
        // prefixIcon: Icon(Icons.lock_outline),
        hintText: 'Ingrese contraseña',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.error,
        ),
      ),
      validator: Validators.validatePassword,
      onChanged: (_) => setState(() => {}),
    );
  }

  FormInput confirmPasswordInput() {
    return FormInput(
      title: 'Confirmar contraseña',
      controller: confirmPasswordController,
      // titleColor: Consts.neutral.shade700,
      obscureText: true,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock_outline),
        fillColor: Colors.white,
        hintText: 'Confirme su contraseña',
        errorStyle: textTheme.bodyMedium?.copyWith(
          color: Consts.error,
        ),
      ),
      validator: validateConfirmPassword,
      onChanged: (_) => setState(() => {}),
    );
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null) {
      return "Este campo es requerido";
    }

    if (confirmPassword.isEmpty) {
      return "Este campo es requerido";
    }

    if (confirmPassword != password) {
      return "Las contraseñas deben coincidir";
    }

    return null;
  }
}
