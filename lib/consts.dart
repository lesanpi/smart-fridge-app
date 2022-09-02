/* --------------------------- Swatches and colors -------------------------- */
import 'package:flutter/material.dart';

class Consts {
/* ------------------------- Application parameters ------------------------- */
  // static const httpLink = "http://192.168.18.3:3001";
  static const httpLink = "https://zona-refri-api.herokuapp.com";
  static const mqttCloudUrl =
      "b18bfec2abdc420f99565f02ebd1fa05.s2.eu.hivemq.cloud";
  static const mqttDefaultCoordinatorIp = "192.168.0.1";
  static const mqttDefaultIps = "192.168.0.1";
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
/* -------------------------------------------------------------------------- */

/* ---------------------------- Theme parameters ---------------------------- */
  static const int _kPrimaryPrim = 0xFF164296;
  static const MaterialColor accent = MaterialColor(_kPrimaryPrim, {
    100: Color(0xFF5F7BB1),
    200: Color(_kPrimaryPrim),
    300: Color(0xFF232E74),
    400: Color(0xFF171E4C),
    700: Color(0xFF171E4C),
  });

  static const int _kAccentPrim = 0xFF07AEC7;
  static const MaterialColor primary = MaterialColor(_kAccentPrim, {
    50: Color(0xFFE5FBFF),
    100: Color(0xFF7CDEEE),
    200: Color(0xFF00C5E4),
    300: Color(_kAccentPrim),
    400: Color(0xFF006271),
    700: Color(0xFF006271),
  });

  static const int _kNeutralPrim = 0xFFF7F8F9;
  static const MaterialColor neutral = MaterialColor(_kNeutralPrim, {
    100: Color(_kNeutralPrim),
    200: Color(0xFFE8EBED),
    300: Color(0xFFC9CDD2),
    400: Color(0xFF9EA4AA),
    500: Color(0xFF72787F),
    600: Color(0xFF454C53),
    700: Color(0xFF26282B),
    800: Color(0xFF292727),
  });

  static const int _kSuccessPrim = 0xFF00831D;
  static const MaterialColor success = MaterialColor(_kSuccessPrim, {
    100: Color(0xFFD0ECD6),
    200: Color(0xFF67C57C),
    300: Color(0xFF3D9B52),
    400: Color(_kSuccessPrim),
  });

  static const int _kInfoPrim = 0xFF64B6F7;
  static const MaterialColor info = MaterialColor(_kInfoPrim, {
    100: Color(0xFFEFF8FE),
    200: Color(_kInfoPrim),
  });

  static const int _kErrorPrim = 0xFFE5483D;
  static const MaterialColor error = const MaterialColor(_kErrorPrim, {
    100: Color(0xFFF8E0DF),
    200: Color(0xFFEA756D),
    300: Color(_kErrorPrim),
    400: Color(0xFFC60D00),
  });

  static const MaterialColor lightSystem = MaterialColor(0xFFF7F8F9, {
    100: Color(0xFFFFFFFF),
    200: Color(0xFFF7F8F9),
    300: Color(0xFFE8EBED),
  });

  static const MaterialColor darkSystem = MaterialColor(0xFFF7F8F9, {
    100: Color(0xFF454C53),
    200: Color(0xFF2F3136),
    300: Color(0xFF26282B),
  });

  static const int _kBackgroundPrim = 0xFFFBFCFC;
  static const MaterialColor background = MaterialColor(_kBackgroundPrim, {
    100: Color(0xFFFFFFFF),
    200: Color(_kBackgroundPrim),
    300: Color(0xFFF7F8FA),
    400: Color(0xFFEBF0F3),
    500: Color(0xFFE0E0E3),
    600: Color(0xFFC5C8CF),
    700: Color(0xFF050710),
  });

// Text colors
  static const Color textBl = const Color(0xFF333333);
  static const Color textWh = const Color(0xFFFEFEFE);

// Background colors
  static const Color bg100 = const Color(0xFFFFFEFE);
  static const Color bg200 = const Color(0xFFFAFBFE);
  static const Color bg300 = const Color(0xFF222222);

  // static Color greyShadow = const Color(0xFFA3A5AB);

/* ------------------------------- Dimensions ------------------------------- */

  static const double defaultPadding = 20.0;
  static const double defaultBorderRadius = 5.0;

  /// Default border radius for the UI elements.
  static const double borderRadius = 8;

  static const Size categoryCardSize = Size(110, 110);

  static const double carouselHeight = 200.0;

  static const BorderRadius inputBorderRadius = BorderRadius.all(
    Radius.circular(Consts.defaultBorderRadius),
  );

  static Gradient primaryGradient = LinearGradient(colors: [
    primary,
    primary.shade100,
    primary.shade700,
    primary.shade500,
    primary,
    primary.shade200,
  ]);

  static const Color fontDark = Color(0xFF1F2D4A);
  static const Color fontDarkGray = Color(0xFF6B7280);
  static const Color fontLightGray = Color(0xFF9A9FA7);
  static const Color fontWhite = Color(0xFFFEFEFE);
}
