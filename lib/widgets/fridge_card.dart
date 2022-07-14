import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';

class FridgeCard extends StatelessWidget {
  const FridgeCard({
    Key? key,
    required this.onTap,
    required this.fridge,
  }) : super(key: key);

  final FridgeState fridge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(
          Consts.defaultBorderRadius * 8,
        )),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(
            Consts.defaultBorderRadius * 8,
          )),
          child: Container(
            // width: w,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(
                Consts.defaultBorderRadius * 8,
              )), // 70
              // boxShadow: [
              //   BoxShadow(
              //     color: Color.fromRGBO(0, 0, 0, 0.2),
              //     blurRadius: 10,
              //     offset: const Offset(2, 10),
              //   )
              // ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: Consts.defaultPadding),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#${fridge.id}",
                        style: textTheme.titleSmall?.copyWith(
                          color: Consts.neutral.shade400,
                        ),
                      ),
                      Text(
                        fridge.name,
                        style: textTheme.headline2?.copyWith(
                          color: Consts.primary.shade400,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "${fridge.temperature}°C",
                    style: textTheme.headline1?.copyWith(
                        color: fridge.temperature >= fridge.minTemperature &&
                                fridge.temperature <= fridge.maxTemperature
                            ? Consts.neutral.shade800
                            : Consts.error),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
