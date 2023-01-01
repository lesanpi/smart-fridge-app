import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    // final outlinedButtonStyle = Theme.of(context).outlinedButtonTheme.style;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Consts.error,
        side: const BorderSide(
          color: Consts.error,
          width: 1.0,
        ),
        shape: CustomTheme.buttonShape,
      ),
      onPressed: () async {
        context.read<LocalConnectionBloc>().add(LocalConnectionDisconnect());
        Navigator.maybePop(context);

        if (onTap != null) {
          onTap!();
        }
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: Consts.defaultPadding),
        child: Text("DESCONECTARSE"),
      ),
    );
  }
}
