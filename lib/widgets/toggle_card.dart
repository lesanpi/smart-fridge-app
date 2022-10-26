import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class ToggleCard extends StatelessWidget {
  const ToggleCard({
    super.key,
    required this.onChanged,
    required this.value,
    required this.text,
  });

  final Function(bool) onChanged;
  final bool value;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.8),
          ),
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
                      Spacer(),
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
                    Spacer(),
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
