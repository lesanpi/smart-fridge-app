import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/model/fridge_info.dart';

class FridgeCard extends StatelessWidget {
  const FridgeCard({
    Key? key,
    required this.onTap,
    required this.fridge,
  }) : super(key: key);

  final FridgeInfo fridge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Container(
          width: w,
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(50)), // 70
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 25,
                offset: const Offset(2, 15),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "#${fridge.deviceId}",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade400,
                  fontSize: 20,
                ),
              ),
              Text(
                fridge.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  fontSize: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
