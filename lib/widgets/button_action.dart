import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';

class ButtonAction extends StatelessWidget {
  ButtonAction({
    Key? key,
    required this.onTap,
    required this.selected,
    required this.iconData,
    this.description = '',
  }) : super(key: key);

  bool selected;
  final VoidCallback onTap;
  final IconData iconData;
  final String description;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(60),
          onTap: onTap,
          child: PhysicalModel(
            color: Colors.black12,
            shape: BoxShape.circle,
            elevation: 3,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 60,
              height: 60,
              child: Icon(
                iconData,
                color: selected ? Colors.white : Consts.primary,
                size: 30,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Consts.primary : Colors.white,
              ),
            ),
          ),
        ),
        // const SizedBox(height: Consts.defaultPadding / 4),
        TextButton(
          onPressed: onTap,
          child: Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
                // fontWeight: FontWeight.w600,
                ),
          ),
        )
      ],
    );
  }
}
