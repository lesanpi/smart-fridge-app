import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/bluetooth_repository.dart';
import 'package:wifi_led_esp8266/data/repositories/repositories.dart';
import 'package:wifi_led_esp8266/data/use_cases/uses_cases.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/splash/splash.dart';

void main() {
  runApp(const SmartFridgeApp());
}

void setSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.white,
      // systemNavigationBarColor: Consts.darkSystem.shade300,
      systemNavigationBarColor: Consts.lightSystem.shade300,
      systemNavigationBarIconBrightness: Brightness.dark,
      // systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class SmartFridgeApp extends StatelessWidget {
  const SmartFridgeApp({Key? key}) : super(key: key);

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
        RepositoryProvider(create: (_) => BluetoothRepository()),
        RepositoryProvider(
            create: (context) => AuthUseCase(context.read(), context.read())),
        RepositoryProvider(
          create: (context) => CloudRepository(context.read()),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.mainTheme,
        home: const SplashPage(),
      ),
    );
  }
}
