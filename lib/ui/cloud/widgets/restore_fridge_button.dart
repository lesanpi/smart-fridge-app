import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/theme.dart';
import 'package:wifi_led_esp8266/ui/cloud/cloud.dart';
import 'package:wifi_led_esp8266/widgets/future_loading_indicator.dart';

class RestoreFridgeButton extends StatelessWidget {
  const RestoreFridgeButton({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // final outlinedButtonStyle = Theme.of(context).outlinedButtonTheme.style;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Consts.error.shade400,
        // side: BorderSide(
        //   color: Consts.error.shade400,
        //   width: 1.0,
        // ),
        shape: CustomTheme.buttonShape,
      ),
      onPressed: () async {
        await onDialogMessage(
          warning: true,
          context: context,
          title:
              '¿Estás seguro que deseas restaurar de fábrica el controlador?',
          message:
              'Esta acción borrará todos los datos guardados y hará que el controlador vuelva a modo configuración',
          warningCallback: () {
            context.read<FridgeStateCubit>().restoreFactory();
            Navigator.pop(context);
          },
          warningButtonText: 'CONTINUAR',
        );
      },
      child: const Text("RESTAURAR DE FÁBRICA"),
    );
  }
}
