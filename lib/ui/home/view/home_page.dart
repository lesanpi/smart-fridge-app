import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/push_notifications_service.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/ui/cloud/view/cloud_page.dart';
import 'package:wifi_led_esp8266/ui/home/cubit/sign_out_cubit.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/notification_snackbar.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/widgets.dart';
import 'package:wifi_led_esp8266/ui/local/view/local_page.dart';
import 'package:wifi_led_esp8266/ui/login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final textTheme = Theme.of(context).textTheme;
  late final size = MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    PushNotificationService.notificationMessagesStream.listen((event) {
      log('Notification received ${event.body}');

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          NotificationSnackBar(
            textTheme: textTheme,
            title: event.title,
            body: event.body,
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => SignOutCubit(context.read()),
      child: Scaffold(
        // backgroundColor: Consts.lightSystem.shade300,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          title: Text(
            'Mi menú',
            style: textTheme.headline5?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          leadingWidth: 0,
          leading: const SizedBox(width: Consts.defaultPadding / 2),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Consts.defaultPadding / 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Consts.defaultPadding),
                const HelloMessage(),
                const SizedBox(height: Consts.defaultPadding),
                Text(
                  'Mi menú',
                  style: textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Consts.defaultPadding / 2),
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
                    Spacer(),
                  ],
                ),
                const SizedBox(height: Consts.defaultPadding / 2),
              ],
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
        color: Consts.fontDark,
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
      child: AspectRatio(
        aspectRatio: 1,
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
        color: Consts.fontDark,
        // color: Consts.accent,
      ),
    );
  }
}
