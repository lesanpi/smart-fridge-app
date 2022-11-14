import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';

class HelloMessage extends StatelessWidget {
  const HelloMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authUser = RepositoryProvider.of<AuthUseCase>(context).currentUser;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Consts.primary.shade100, width: 2),
        borderRadius:
            const BorderRadius.all(Radius.circular(Consts.borderRadius * 2)),
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Consts.primary.shade100,
          borderRadius:
              const BorderRadius.all(Radius.circular(Consts.borderRadius * 2)),
        ),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 250,
          borderRadius: Consts.borderRadius * 2,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 0,
          linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFffffff).withOpacity(0.1),
                const Color(0xFFFFFFFF).withOpacity(0.05),
              ],
              stops: const [
                0.1,
                1,
              ]),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFffffff).withOpacity(0.5),
              const Color((0xFFFFFFFF)).withOpacity(0.5),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Consts.defaultPadding,
              vertical: Consts.defaultPadding,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bienvenido,",
                    style: textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.w200,
                      color: Consts.fontDark,
                    ),
                  ),
                  Text(
                    authUser != null ? authUser.name : "",
                    style: textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: Consts.defaultPadding / 2),
                  if (authUser != null)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        // color: Colors.black,
                        color: Consts.primary.shade500,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Consts.borderRadius),
                        ),
                      ),
                      child: Text(
                        authUser.email,
                        style: textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          // backgroundColor: Consts.primary,
                          height: 1,
                        ),
                      ),
                    ),
                  const SizedBox(height: Consts.defaultPadding / 2),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      '👋',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
