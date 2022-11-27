import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/ui/cloud/bloc/cloud_message_bloc/cloud_messages_bloc.dart';
import 'package:wifi_led_esp8266/ui/home/widgets/notification_snackbar.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider(
          create: (context) => CloudMessagesBloc(
            context.read(),
            context.read(),
          ),
          lazy: false,
        ),
      ],
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
    final textTheme = Theme.of(context).textTheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<CloudMessagesBloc, CloudMessagesState>(
          listenWhen: (previous, current) =>
              previous != current && current.deviceMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                MessageSnackbar(
                  textTheme: textTheme,
                  title: state.deviceMessage!.title,
                  body: state.deviceMessage!.message,
                ),
              );
          },
        ),
        BlocListener<CloudMessagesBloc, CloudMessagesState>(
          listenWhen: (previous, current) =>
              previous != current && current.errorMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                NotificationSnackBar(
                  textTheme: textTheme,
                  title: state.errorMessage!.title,
                  body: state.errorMessage!.message,
                ),
              );
          },
        ),
      ],
      child: const NavigationBody(),
    );
  }
}
