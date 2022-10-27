import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/utils/utils.dart';

class Thermostat extends StatelessWidget {
  const Thermostat({Key? key, required this.temperature, this.alert = false})
      : super(key: key);
  final double temperature;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final containerSize = size.width * 2 / 3;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: temperature,
              strokeWidth: 20,
            ),
          ),
          Center(
            child: Text(
              temperature > 100 || temperature < -100
                  ? "--"
                  : "${!(temperature > 100 || temperature < 100) ? '-' : temperature.toInt()} °C",
              style: TextStyle(
                color: alert ? Consts.error : Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
    );
    return SleekCircularSlider(
      min: -100,
      max: 100,
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          progressBarColor: Colors.blueAccent,
          shadowColor: Colors.blue,
          trackColor: Colors.blue.shade100,
        ),
        angleRange: 360,
        startAngle: 0,
        customWidths: CustomSliderWidths(progressBarWidth: 15),
      ),
      initialValue: !(temperature > 100 || temperature < 100) ? 0 : temperature,
      innerWidget: (percentage) {
        return Center(
          child: Text(
            temperature > 100 || temperature < -100
                ? "--"
                : "${!(temperature > 100 || temperature < 100) ? '-' : temperature.toInt()} °C",
            style: TextStyle(
              color: alert ? Consts.error : Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );

    return PhysicalModel(
      elevation: 20,
      color: Colors.white,
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
            Consts.primary.withOpacity(1),
            Colors.blueAccent.shade100.withOpacity(1),
            Colors.lightBlueAccent.shade100.withOpacity(1),
            // Colors.pinkAccent.shade100.withOpacity(1),
            // Colors.purpleAccent.shade200.withOpacity(1),
            Colors.lightBlue.shade400.withOpacity(1),
            Colors.blueAccent.shade400.withOpacity(1),
            Colors.lightBlue.shade400.withOpacity(1),
            Consts.primary.withOpacity(1),
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Stack(
                children: [
                  Text(
                    temperature > 1000 || temperature < -20
                        ? "--  "
                        : "${temperature.toInt()}  ",
                    style: TextStyle(
                      color: alert ? Consts.error : Colors.black,
                      fontSize: 70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Text(
                      "°C",
                      style: TextStyle(
                        color: alert ? Consts.error : Colors.black,
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
