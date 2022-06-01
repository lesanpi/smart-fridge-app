import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/local/view/disconnect_button.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Consts.defaultPadding * 3,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: Consts.primary,
            ),
            SizedBox(height: Consts.defaultPadding),
            Text(
              "Sin datos",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Consts.defaultPadding / 2),
            DisconnectButton(),
          ],
        ),
      ),
    );
  }
}
