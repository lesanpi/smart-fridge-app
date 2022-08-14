/* --------------------------- Swatches and colors -------------------------- */
import 'package:flutter/material.dart';

class Consts {
/* ------------------------- Application parameters ------------------------- */
  // static const httpLink = "http://192.168.18.3:3001";
  static const httpLink = "http://192.168.1.102:3001";
  static const mqttCloudUrl =
      "b18bfec2abdc420f99565f02ebd1fa05.s2.eu.hivemq.cloud";
  static const mqttDefaultCoordinatorIp = "192.168.0.1";
  static const mqttDefaultIps = "192.168.0.1";
  // static const httpLink = "http://192.168.2.108:3001";
  // static const algoliaAppId = "TYPWAL4JZU";
  // static const algoliaApiKey = "858e43b0d195cc08b91edbbc6222f4f8";
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
/* -------------------------------------------------------------------------- */

/* ------------------------- Algolia Search Indexes ------------------------- */
  // static const productsIndex = "products";
  // static const usersIndex = "users";
  // static const ordersIndex = "orders";
  // static const categoriesIndex = "categories";
/* -------------------------------------------------------------------------- */

/* ---------------------------- Theme parameters ---------------------------- */
  static const int _kPrimaryPrim = 0xFF4dd0e1;
  static const MaterialColor primary = MaterialColor(_kPrimaryPrim, {
    50: Color(0xFFe0f7fa),
    100: Color(0xFFb2ebf2),
    200: Color(0xFF80deea),
    300: Color(_kPrimaryPrim),
    400: Color(0xFF26c6da),
    500: Color(0xFF00bcd4),
    600: Color(0xFF00acc1),
    700: Color(0xFF0097a7),
    800: Color(0xFF00838f),
    900: Color(0xFF006064),
  });

  static const int _kSecondaryPrim = 0xFF4dd0e1;
  static const MaterialColor secondary = MaterialColor(_kPrimaryPrim, {
    50: Color(0xFFe0f7fa),
    100: Color(0xFFb2ebf2),
    200: Color(0xFF80deea),
    300: Color(_kPrimaryPrim),
    400: Color(0xFF26c6da),
    500: Color(0xFF00bcd4),
    600: Color(0xFF00acc1),
    700: Color(0xFF0097a7),
    800: Color(0xFF00838f),
    900: Color(0xFF006064),
  });

  static const int _kNeutralPrim = 0xFFF7F8F9;
  static const MaterialColor neutral = const MaterialColor(_kNeutralPrim, {
    100: Color(_kNeutralPrim),
    200: Color(0xFFE8EBED),
    300: Color(0xFFC9CDD2),
    400: Color(0xFF9EA4AA),
    500: Color(0xFF72787F),
    600: Color(0xFF454C53),
    700: Color(0xFF26282B),
    800: Color(0xFF292727),
  });

  static const int _kSuccessPrim = 0xFF3D9B52;
  static const MaterialColor success = const MaterialColor(_kSuccessPrim, {
    100: Color(0xFFD0ECD6),
    200: Color(0xFF67C57C),
    300: Color(_kSuccessPrim),
    400: Color(0xFF00831D),
  });

  static const int _kWarningPrim = 0xFFF8BF29;
  static const MaterialColor warning = const MaterialColor(_kWarningPrim, {
    100: Color(0xFFFFF0CB),
    200: Color(0xFFFFD462),
    300: Color(_kWarningPrim),
    400: Color(0xFFE7A700),
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
}
