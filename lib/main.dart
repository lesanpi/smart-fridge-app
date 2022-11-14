import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/push_notifications_service.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/data/use_cases/fridge_use_case.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';
import 'package:wifi_led_esp8266/firebase_options.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();

  runApp(const SmartFridgeApp());
}

void setSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.white,
      // systemNavigationBarColor: Consts.darkSystem.shade300,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      // systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class SmartFridgeApp extends StatefulWidget {
  const SmartFridgeApp({Key? key}) : super(key: key);

  @override
  State<SmartFridgeApp> createState() => _SmartFridgeAppState();
}

class _SmartFridgeAppState extends State<SmartFridgeApp> {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late final textTheme = Theme.of(context).textTheme;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setSystemUI();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => LocalRepository(),
          lazy: false,
        ),
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => PersistentStorageRepository()),
        RepositoryProvider(
            create: (context) => AuthUseCase(context.read(), context.read())),
        RepositoryProvider(
          create: (context) => CloudRepository(context.read()),
          lazy: false,
        ),
        RepositoryProvider(
          create: (context) =>
              SetupUseCase(context.read(), context.read(), context.read()),
          lazy: false,
        ),
        RepositoryProvider(
          create: (context) => FridgeUseCase(context.read(), context.read()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.mainTheme,
        home: const SplashPage(),
        scaffoldMessengerKey: messengerKey,
      ),
    );
  }
}
