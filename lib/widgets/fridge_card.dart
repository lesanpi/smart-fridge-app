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
    final alert = (fridge.temperature >= fridge.minTemperature &&
        fridge.temperature <= fridge.maxTemperature);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(Radius.circular(
          Consts.defaultBorderRadius * 3,
        )),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(
            Consts.defaultBorderRadius * 3,
          )),
          child: Container(
            // width: w,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              // color: Colors.white,
              color: !alert ? Consts.error.withOpacity(0.1) : null,
              borderRadius: const BorderRadius.all(Radius.circular(
                Consts.defaultBorderRadius * 3,
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
              padding: const EdgeInsets.symmetric(
                  vertical: Consts.defaultPadding / 2),
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        fridge.name,
                        style: textTheme.headline2?.copyWith(
                          color: Consts.neutral.shade600,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "${fridge.temperature.round()}°C",
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: textTheme.headline1?.copyWith(
                      color: alert
                          ? Consts.neutral.shade800
                          : Consts.error.shade400,
                    ),
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
