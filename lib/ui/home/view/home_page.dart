import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/auth_repository.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/menu_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authUser =
        RepositoryProvider.of<AuthRepository>(context).currentUser!;

    return Scaffold(
      backgroundColor: Consts.lightSystem.shade300,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenido,",
                      style: textTheme.headline1,
                    ),
                    Text(
                      authUser.name,
                      style: textTheme.headline1?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Consts.primary,
                      ),
                    ),
                  ],
                ),
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
    );
  }
}

class InternetFridgesButton extends StatelessWidget {
  const InternetFridgesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedMenuItem(
      onPressed: () => {},
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
      onPressed: () => {},
      title: "Neveras",
      description: "(Wifi Local)",
      icon: const Icon(
        Icons.home_filled,
        size: 60,
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedMenuItem(
      onPressed: () => {},
      title: "Cerrar",
      description: "sesión",
      icon: const Icon(
        Icons.logout,
        size: 60,
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
      ),
    );
  }
}
