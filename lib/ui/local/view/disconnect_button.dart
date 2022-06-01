import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/connection_cubit.dart';

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await context.read<ConnectionCubit>().disconnect();
        Navigator.maybePop(context);

        if (onTap != null) {
          onTap!();
        }
      },
      child: const Text("Desconectarse"),
    );
  }
}
