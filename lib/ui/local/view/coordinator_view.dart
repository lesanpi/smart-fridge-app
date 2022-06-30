import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/connection_info.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridges_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/fridges_empty.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';
import '../local.dart';

class CoordinatorView extends StatelessWidget {
  const CoordinatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => FridgesCubit(context.read())..init(),
      child: BlocBuilder<ConnectionCubit, ConnectionInfo?>(
        builder: (context, connectionInfo) {
          return BlocConsumer<FridgesCubit, List<FridgeState>>(
            listener: (context, fridgeList) {},
            builder: (context, fridgeList) {
              print('fridgelist');
              print(fridgeList.map((e) => e.toJson()).toList());

              if (fridgeList.isEmpty) return const FridgesEmpty();

              return Column(
                children: [
                  const SizedBox(height: Consts.defaultPadding),
                  Text(
                    connectionInfo!.ssid,
                    style: textTheme.headline2,
                  ),
                  Text("Coordinador: ${connectionInfo.id}"),
                  const SizedBox(height: Consts.defaultPadding),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return FridgeCard(
                            onTap: () => {}, fridge: fridgeList[index]);
                      },
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: Consts.defaultPadding),
                      itemCount: fridgeList.length,
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Consts.defaultPadding),
                    child: DisconnectButton(),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
