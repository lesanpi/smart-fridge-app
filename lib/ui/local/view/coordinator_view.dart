import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/cubit/fridges_cubit.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/fridges_empty.dart';
import '../local.dart';

class CoordinatorView extends StatelessWidget {
  const CoordinatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FridgesCubit, List<FridgeState>>(
      builder: (context, fridgeList) {
        if (fridgeList.isEmpty) return const FridgesEmpty();

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return const SizedBox.shrink();
                },
                separatorBuilder: (_, __) =>
                    const SizedBox(height: Consts.defaultPadding),
                itemCount: 1,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: Consts.defaultPadding),
                child: DisconnectButton(),
              ),
            ),
          ],
        );
      },
    );
  }
}
