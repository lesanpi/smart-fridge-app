import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/utils/utils.dart';

class Thermostat extends StatelessWidget {
  const Thermostat({Key? key, required this.temperature}) : super(key: key);
  final double temperature;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final containerSize = size.width * 2 / 3;

    return PhysicalModel(
      elevation: 10,
      color: Colors.black12,
      shape: BoxShape.circle,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // boxShadow: [
          //   BoxShadow(
          //     color: Color.fromRGBO(0, 0, 0, 0.2),
          //     blurRadius: 35,
          //     offset: const Offset(0, 15),
          //   )
          // ],
          gradient: LinearGradient(colors: [
            Consts.primary,
            Consts.primary.shade100,
            Consts.primary.shade700,
            Consts.primary.shade500,
            Consts.primary,
            Consts.primary.shade200,
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Container(
            decoration: BoxDecoration(
              color: Consts.lightSystem.shade300.withOpacity(0.95),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Stack(
                children: [
                  Text(
                    temperature == 404
                        ? "--  "
                        : "${temperature.floorToDouble()}  ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Positioned(
                    right: 0,
                    child: Text(
                      "°C",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
