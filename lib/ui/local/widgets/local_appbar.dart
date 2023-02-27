import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/models.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/widgets/custom_back_button.dart';

class LocalAppBar extends StatelessWidget {
  const LocalAppBar({Key? key, this.onBack}) : super(key: key);
  final VoidCallback? onBack;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      // backgroundColor: Consts.lightSystem.shade300,
      leading: const CustomBackButton(),
      centerTitle: true,
      title: BlocBuilder<LocalConnectionBloc, LocalConnectionState>(
        builder: (context, connectionInfo) {
          return Text(
            connectionInfo.connectionInfo != null
                ? "✅ Conectado"
                : "🔌 Desconectado",
            style: TextStyle(
              color: Consts.neutral.shade700,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
      actions: [
        BlocBuilder<FridgeStateCubit, FridgeState?>(
          builder: (context, fridge) {
            if (fridge == null) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: () {
                context.read<FridgeStateCubit>().toggleMuted();
              },
              tooltip: 'Apagar o encender las alarmas sonoras',
              icon: !(fridge.muted)
                  ? const Icon(
                      Icons.mic,
                      color: Consts.primary,
                    )
                  : const Icon(
                      Icons.mic_off,
                      color: Consts.error,
                    ),
            );
          },
        )
      ],
    );
  }
}
