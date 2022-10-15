import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/ui/home/home.dart';
import 'package:wifi_led_esp8266/ui/navigation/navigation.dart';

/// {@template navigation_body}
/// Body of the NavigationPage.
///
/// Add what it does
/// {@endtemplate}
class NavigationBody extends StatelessWidget {
  /// {@macro navigation_body}
  const NavigationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: IndexedStack(
                children: const [
                  HomePage(),
                  Center(
                    child: Text('profile'),
                  )
                ],
                index: state,
              ),
            ),
            const CustomNavigationBar(),
          ],
        );
      },
    );
  }
}
