import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/utils/utils.dart';

class ButtonAction extends StatelessWidget {
  ButtonAction(
      {Key? key,
      required this.onTap,
      required this.selected,
      required this.iconData})
      : super(key: key);

  bool selected;
  final VoidCallback onTap;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 60,
        child: Icon(
          iconData,
          color: selected ? Colors.white : darkGreen,
          size: 30,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 35,
                offset: const Offset(0, 15),
              ),
            ],
            color: selected ? darkGreen : Colors.white),
      ),
    );
  }
}
