import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/ui/navigation/navigation.dart';

/// {@template navigation_page}
/// A description for NavigationPage
/// {@endtemplate}
class NavigationPage extends StatelessWidget {
  /// {@macro navigation_page}
  const NavigationPage({super.key});

  /// The static route for NavigationPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const NavigationPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const Scaffold(
        body: NavigationView(),
      ),
    );
  }
}

/// {@template navigation_view}
/// Displays the Body of NavigationView
/// {@endtemplate}
class NavigationView extends StatelessWidget {
  /// {@macro navigation_view}
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationBody();
  }
}
