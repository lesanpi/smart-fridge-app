import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class CustomTheme {
  static TextStyle _workSans = const TextStyle(fontFamily: 'Work Sans Regular');
  static TextStyle _workSansBold =
      const TextStyle(fontFamily: 'Work Sans Bold');
  static TextStyle _workSansMedium =
      const TextStyle(fontFamily: 'Work Sans Medium');

  static RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Consts.defaultBorderRadius),
  );

  static UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(
      width: 0,
      color: Consts.primary,
    ),
  );

  static OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 0,
      color: Colors.white,
    ),
    borderRadius:
        BorderRadius.all(Radius.circular(Consts.defaultBorderRadius * 2)),
    // gapPadding: 0,
  );

  static ThemeData mainTheme = ThemeData(
    primarySwatch: Consts.primary,
    colorScheme: ColorScheme(
      primary: Consts.primary,
      primaryVariant: Consts.primary[400]!,
      secondary: Consts.secondary,
      secondaryVariant: Consts.secondary[400]!,
      surface: Consts.bg100,
      background: Consts.bg100,
      error: Consts.error,
      onPrimary: Consts.textWh,
      onSecondary: Consts.textWh,
      onSurface: Consts.textBl,
      onBackground: Consts.textBl,
      onError: Consts.textWh,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Consts.bg100,
    textTheme: TextTheme(
      headline1: _workSansBold.copyWith(
        fontSize: 36.0,
        letterSpacing: 0.0,
      ),
      headline2: _workSansBold.copyWith(
        fontSize: 24.0,
        letterSpacing: 0.0,
      ),
      headline3: _workSans.copyWith(
        fontSize: 22.0,
        letterSpacing: 0.0,
      ),
      headline4: _workSans.copyWith(
        fontSize: 20.0,
        letterSpacing: 0.0,
      ),
      headline5: _workSans.copyWith(
        fontSize: 18.0,
        letterSpacing: 0.0,
      ),
      headline6: _workSans.copyWith(
        fontSize: 16.0,
        letterSpacing: 0.0,
      ),
      subtitle1: _workSans,
      subtitle2: _workSans,
      bodyText1: _workSansBold.copyWith(
        // fontSize: 16.0,
        height: 1.5,
      ),
      bodyText2: _workSans.copyWith(
        // fontSize: 16.0,
        height: 1.5,
      ),
      button: _workSans.copyWith(fontSize: 16.0),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Consts.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle().copyWith(
        color: Consts.neutral[400],
        fontSize: 14,
      ),
      hintStyle: TextStyle().copyWith(
        color: Consts.neutral[400],
        fontSize: 14,
      ),
      border: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      fillColor: Consts.neutral[200],
      filled: true,
      isCollapsed: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: Consts.defaultPadding / 2,
        horizontal: Consts.defaultPadding / 2,
      ),
    ),
    primaryIconTheme: IconThemeData(color: Consts.textWh),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Consts.secondary[40],
      selectionHandleColor: Consts.secondary,
      cursorColor: Colors.black,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: Consts.secondary),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Consts.primary.shade400,
          width: 1.0,
        ),
        primary: Consts.primary.shade400,
        shape: _buttonShape,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: _buttonShape,
        primary: Consts.primary.shade400,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith(
          (states) => Consts.primary.shade400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.defaultBorderRadius),
        side: BorderSide(),
      ),
    ),
  );
}
