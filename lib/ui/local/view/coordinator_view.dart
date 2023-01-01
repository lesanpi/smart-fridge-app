import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/local/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/ui/local/local.dart';
import 'package:wifi_led_esp8266/ui/local/view/fridge_page.dart';
import 'package:wifi_led_esp8266/ui/local/widgets/fridges_empty.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

class CoordinatorView extends StatelessWidget {
  const CoordinatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => FridgesCubit(context.read())..init(),
      lazy: false,
      child: BlocConsumer<LocalConnectionBloc, LocalConnectionState>(
        listener: (context, _) {
          context.read<FridgesCubit>().init();
        },
        builder: (context, localConnection) {
          return BlocConsumer<FridgesCubit, List<FridgeState>>(
            listener: (context, fridgeList) {
              // context.read<FridgesCubit>().init();
            },
            builder: (context, fridgeList) {
              // print('fridgelist');
              // print(fridgeList.map((e) => e.toJson()).toList());

              if (fridgeList.isEmpty) return const FridgesEmpty();

              return Column(
                children: [
                  const SizedBox(height: Consts.defaultPadding),
                  Text(
                    localConnection.connectionInfo!.ssid,
                    style: textTheme.headline2,
                  ),
                  Text("Coordinador: ${localConnection.connectionInfo?.id}"),
                  const SizedBox(height: Consts.defaultPadding),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return FridgeCard(
                            onTap: () async {
                              await context
                                  .read<FridgesCubit>()
                                  .selectedFridge(fridgeList[index])
                                  .then((value) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const FridgePage(),
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      final tween =
                                          Tween(begin: begin, end: end);
                                      final offsetAnimation =
                                          animation.drive(tween);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              });
                            },
                            fridge: fridgeList[index]);
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
