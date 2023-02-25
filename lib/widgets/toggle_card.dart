import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class ToggleCard extends StatelessWidget {
  const ToggleCard({
    super.key,
    required this.onChanged,
    required this.value,
    required this.text,
    this.tooltipText,
  });

  final Function(bool) onChanged;
  final bool value;
  final String text;
  final String? tooltipText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            if (tooltipText != null)
              IconButton(
                splashRadius: 10,
                tooltip: tooltipText,
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  color: Consts.fontDark,
                ),
              )
          ],
        ),
        const SizedBox(height: Consts.defaultPadding / 2),
        Container(
          height: 100,
          // elevation: 3,
          decoration: BoxDecoration(
            color: Consts.primary.withOpacity(0.3),
            borderRadius: const BorderRadius.all(
                Radius.circular(Consts.borderRadius * 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Consts.defaultPadding / 2,
              horizontal: Consts.defaultPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.light_mode_sharp,
                          size: 40,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      // Spacer()
                    ],
                  ),
                ),
                Column(
                  children: [
                    Switch(value: value, onChanged: onChanged),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CheckCard extends StatelessWidget {
  const CheckCard({
    super.key,
    required this.value,
    required this.text,
    required this.messageTrue,
    required this.messageFalse,
    this.tooltipText,
  });

  final bool value;
  final String text;
  final String messageTrue;
  final String messageFalse;
  final String? tooltipText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            if (tooltipText != null)
              IconButton(
                splashRadius: 10,
                tooltip: tooltipText,
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  color: Consts.fontDark,
                ),
              )
          ],
        ),
        const SizedBox(height: Consts.defaultPadding / 2),
        Container(
          height: 170,
          // elevation: 3,
          decoration: BoxDecoration(
            color: !value
                ? Consts.primary.withOpacity(0.1)
                : Consts.error.shade100,
            borderRadius: const BorderRadius.all(
                Radius.circular(Consts.borderRadius * 3)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Consts.defaultPadding / 2,
              horizontal: Consts.defaultPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        !value ? Icons.check_circle : Icons.error_rounded,
                        size: 40,
                        color: !value ? Consts.primary.shade300 : Consts.error,
                      ),
                      const SizedBox(height: Consts.defaultPadding / 4),

                      Expanded(
                        child: Text(
                          !value ? messageTrue : messageFalse,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                      // Spacer()
                    ],
                  ),
                ),
                Column(
                  children: const [],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
