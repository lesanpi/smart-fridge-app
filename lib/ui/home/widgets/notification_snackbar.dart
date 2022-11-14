import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class NotificationSnackBar extends SnackBar {
  NotificationSnackBar({
    required this.textTheme,
    required this.title,
    required this.body,
    super.key,
  }) : super(
          backgroundColor: Consts.error.shade100,
          duration: const Duration(seconds: 8),
          content: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Consts.fontDark,
                    height: 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                ),
                const SizedBox(height: Consts.defaultPadding / 4),
                Text(
                  body,
                  style: textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Consts.fontDark,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        );

  final TextTheme textTheme;
  final String title;
  final String body;
}
