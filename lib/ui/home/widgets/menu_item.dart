import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class ElevatedMenuItem extends StatelessWidget {
  const ElevatedMenuItem({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(Consts.defaultBorderRadius * 5),
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Consts.primary.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.borderRadius * 2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Consts.defaultPadding / 2,
              // horizontal: Consts.defaultPadding / 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  title,
                  style: textTheme.headline5?.copyWith(
                    color: Consts.fontDark,
                    fontWeight: FontWeight.w600,
                    // fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Consts.fontDark,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinedMenuItem extends StatelessWidget {
  const OutlinedMenuItem({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Widget icon;
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    final outlinedButtonTheme = Theme.of(context).outlinedButtonTheme.style;

    return AspectRatio(
      aspectRatio: 1,
      child: OutlinedButton(
        onPressed: onPressed,
        style: outlinedButtonTheme?.copyWith(
          // backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(Consts.defaultBorderRadius * 5),
            ),
          ),
          overlayColor:
              MaterialStateProperty.all(Consts.primary.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Consts.defaultPadding / 2,
            // horizontal: Consts.defaultPadding / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                title,
                style: textTheme.headline5?.copyWith(
                  color: Consts.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Consts.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
