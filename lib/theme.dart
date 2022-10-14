import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static TextStyle _workSans = const TextStyle(fontFamily: 'Work Sans Regular');
  static TextStyle _workSansBold =
      const TextStyle(fontFamily: 'Work Sans Bold');
  static TextStyle _workSansMedium =
      const TextStyle(fontFamily: 'Work Sans Medium');

  static RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
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
    // primarySwatch: Consts.primary,

    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Consts.primary,
      accentColor: Consts.accent,
      backgroundColor: Consts.background,
      errorColor: Consts.error,
      cardColor: Consts.background.shade100,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    textTheme: GoogleFonts.poppinsTextTheme()
        .copyWith(bodyLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600))
        .apply(bodyColor: Consts.fontDark),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Consts.primary,
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //   hintStyle: TextStyle(
    //     color: Consts.neutral.shade500,
    //   ),
    //   labelStyle: TextStyle(
    //     color: Consts.neutral.shade500,
    //   ),
    //   border: OutlineInputBorder(
    //     borderSide: BorderSide(color: Consts.accent.shade400),
    //     borderRadius: BorderRadius.circular(Consts.borderRadius),
    //   ),
    //   enabledBorder: outlineInputBorder,
    //   focusedBorder: outlineInputBorder,
    //   fillColor: Consts.neutral[200],
    //   filled: true,
    //   isCollapsed: true,
    //   isDense: true,
    //   contentPadding: const EdgeInsets.symmetric(
    //     vertical: Consts.defaultPadding / 2,
    //     horizontal: Consts.defaultPadding / 2,
    //   ),
    // ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Consts.accent.shade400),
        borderRadius: BorderRadius.circular(Consts.borderRadius),
      ),
      hintStyle: TextStyle(
        color: Consts.neutral.shade500,
      ),
      labelStyle: TextStyle(
        color: Consts.neutral.shade500,
      ),
      focusColor: Consts.accent,
    ),
    primaryIconTheme: IconThemeData(color: Consts.textWh),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Consts.accent,
      selectionHandleColor: Consts.accent,
      cursorColor: Colors.black,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Consts.accent,
    ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //   style: OutlinedButton.styleFrom(
    //     side: BorderSide(
    //       color: Consts.primary.shade400,
    //       width: 1.0,
    //     ),
    //     primary: Consts.primary.shade400,
    //     shape: buttonShape,
    //   ),
    // ),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     shape: buttonShape,
    //     primary: Consts.primary.shade400,
    //   ),
    // ),
    sliderTheme: SliderThemeData(
      // overlayColor: Consts.accent,
      activeTrackColor: Consts.primary,
      thumbColor: Consts.primary.shade400,
      trackHeight: 15,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Consts.fontWhite,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
        primary: Consts.accent,
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: Consts.defaultPadding,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.borderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: Consts.primary,
        ),
        side: const BorderSide(color: Consts.primary),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: Consts.defaultPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.borderRadius),
        ),
      ),
    ),

    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: Consts.primary,
          width: 2,
        ),
      ),
      // overlayColor: MaterialStateProperty.all(Consts.primary),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Consts.primary,
        fontSize: 16,
      ),
      labelColor: Consts.primary,
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFFc6c6c6),
        fontSize: 16,
      ),
      unselectedLabelColor: Color(0xFFc6c6c6),
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
