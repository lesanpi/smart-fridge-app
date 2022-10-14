import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/data/use_cases/auth_use_case.dart';
import 'package:wifi_led_esp8266/ui/auth/auth.dart';
import 'package:wifi_led_esp8266/ui/cloud/view/cloud_page.dart';
import 'package:wifi_led_esp8266/ui/home/cubit/sign_out_cubit.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/menu_item.dart';
import 'package:wifi_led_esp8266/ui/local/view/local_page.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';
import 'package:wifi_led_esp8266/ui/setup/setup.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => SignOutCubit(context.read()),
      child: Scaffold(
        // backgroundColor: Consts.lightSystem.shade300,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          elevation: 5,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SetupPage(),
                transitionDuration: const Duration(milliseconds: 500),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          icon: Icon(
            Icons.add,
          ),
          label: Text("Configurar nuevo dispositivo"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Consts.defaultPadding * 2,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Consts.defaultPadding * 6),
                    const HelloMessage(),
                    const SizedBox(height: Consts.defaultPadding * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Expanded(child: InternetFridgesButton()),
                        SizedBox(width: Consts.defaultPadding),
                        Expanded(child: LocalFridgesButton()),
                      ],
                    ),
                    const SizedBox(height: Consts.defaultPadding),
                    Row(
                      children: const [
                        Expanded(child: SignOutButton()),
                        SizedBox(width: Consts.defaultPadding),
                        Expanded(child: EditProfileButton())
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InternetFridgesButton extends StatelessWidget {
  const InternetFridgesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedMenuItem(
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const CloudPage(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      title: "Neveras",
      description: "(Internet)",
      icon: const Icon(
        Icons.wifi,
        size: 60,
      ),
    );
  }
}

class LocalFridgesButton extends StatelessWidget {
  const LocalFridgesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedMenuItem(
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LocalPage(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      title: "Neveras",
      description: "(Wifi Local)",
      icon: const Icon(
        Icons.home_filled,
        size: 60,
        color: Consts.primary,
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutCubit, void>(
      listener: (context, state) async {
        await Navigator.pushAndRemoveUntil(
            context, LoginPage.route(), ModalRoute.withName('/'));
      },
      child: OutlinedMenuItem(
        onPressed: () => context.read<SignOutCubit>().signOut(),
        title: "Cerrar",
        description: "sesión",
        icon: const Icon(
          Icons.logout,
          size: 60,
          color: Consts.primary,
        ),
      ),
    );
  }
}

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedMenuItem(
      onPressed: () => {},
      title: "Editar",
      description: "perfil",
      icon: const Icon(
        Icons.person,
        size: 60,
        // color: Consts.accent,
      ),
    );
  }
}

class HelloMessage extends StatelessWidget {
  const HelloMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authUser = RepositoryProvider.of<AuthUseCase>(context).currentUser;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bienvenido,",
          style: textTheme.headline5?.copyWith(
            fontWeight: FontWeight.w700,
            color: Consts.fontDark,
          ),
        ),
        Text(
          authUser != null ? authUser.name : "",
          style: textTheme.headline4?.copyWith(
            fontWeight: FontWeight.w700,
            color: Consts.primary,
            height: 1,
          ),
        ),
      ],
    );
  }
}
