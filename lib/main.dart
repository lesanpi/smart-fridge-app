import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'package:wifi_led_esp8266/pages/splash_screen.dart';
import 'package:wifi_led_esp8266/repositories/local_repository.dart';
import 'utils/utils.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

void setSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setSystemUI();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => LocalRepository()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.accent,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
