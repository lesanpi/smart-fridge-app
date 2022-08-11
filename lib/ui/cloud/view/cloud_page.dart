import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/cloud_repository.dart';
import 'package:wifi_led_esp8266/models/fridge_state.dart';
import 'package:wifi_led_esp8266/ui/cloud/bloc/connection_bloc.dart';
import 'package:wifi_led_esp8266/ui/cloud/view/fridge_page.dart';
import 'package:wifi_led_esp8266/ui/cloud/widgets/disconnect_button.dart';
import 'package:wifi_led_esp8266/ui/cloud/widgets/fridges_empty.dart';
import 'package:wifi_led_esp8266/widgets/widgets.dart';

import '../cloud.dart';

class CloudPage extends StatelessWidget {
  const CloudPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FridgeStateCubit(context.read())..init(),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CloudFridgesCubit(context.read())..init(),
        ),
        BlocProvider(
          create: (context) =>
              CloudConnectionBloc(context.read(), context.read())
                ..add(CloudConnectionInit()),
        ),
      ],
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CloudAppBar(),
        ),
        backgroundColor: Consts.lightSystem.shade300,
        body: const SafeArea(
          child: CloudView(),
        ),
      ),
    );
  }
}

class CloudView extends StatelessWidget {
  const CloudView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<CloudConnectionBloc, CloudConnectionState>(
      listener: (context, state) {},
      builder: (context, state) {
        print(state);
        // print('fridgelist');
        // print(fridgeList.map((e) => e.toJson()).toList());
        if (state is CloudConnectionDisconnected ||
            state is CloudConnectionErrorOnConnection) {
          return const DisconnectedView();
        }

        if (state is CloudConnectionWaiting) {
          return const FridgesEmpty();
        }

        if (state is CloudConnectionLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
                const SizedBox(height: Consts.defaultPadding * 2),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1000),
                  duration: const Duration(seconds: 1000),
                  builder: (context, value, _) {
                    final dotsNum = (value.toInt()) % 4;
                    return Text(
                      'Cargando${'.' * dotsNum}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Consts.neutral.shade700,
                        fontSize: 25,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }

        if (state is CloudConnectionEmpty) return const FridgesEmpty();

        return Column(
          children: [
            const SizedBox(height: Consts.defaultPadding),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return FridgeCard(
                    onTap: () async {
                      await context
                          .read<CloudFridgesCubit>()
                          .selectedFridge(state.fridgesStates[index])
                          .then((value) async {
                        await Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const FridgePage(),
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              final tween = Tween(begin: begin, end: end);
                              final offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                        RepositoryProvider.of<CloudRepository>(context)
                            .unselectFridge();
                      });
                    },
                    fridge: state.fridgesStates[index],
                  );
                },
                separatorBuilder: (_, __) =>
                    const SizedBox(height: Consts.defaultPadding),
                itemCount: state.fridgesStates.length,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Consts.defaultPadding),
              child: CloudDisconnectButton(),
            ),
          ],
        );
      },
    );
  }
}

// class FridgeView extends StatelessWidget {
//   const FridgeView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;

//     return BlocConsumer<FridgeStateCubit, FridgeState?>(
//       listener: (context, fridge) {},
//       builder: (context, fridge) {
//         if (fridge == null) {
//           return const NoDataView();
//         }
//         return Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   fridge.id,
//                   style: textTheme.headline2,
//                 ),
//                 Text(fridge.id),
//                 const SizedBox(height: Consts.defaultPadding * 2),
//                 Thermostat(temperature: fridge.temperature),
//                 const SizedBox(height: Consts.defaultPadding * 2),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ButtonAction(
//                       onTap: () {
//                         // localRepository.toggleLight(widget.fridgeState.id);
//                       },
//                       selected: fridge.light,
//                       iconData: Icons.lightbulb,
//                       description: 'Luz',
//                     ),
//                     const SizedBox(
//                       width: Consts.defaultPadding,
//                     ),
//                     ButtonAction(
//                       onTap: () {},
//                       selected: fridge.compressor,
//                       iconData: Icons.ac_unit_outlined,
//                       description: 'Compresor',
//                     ),
//                     const SizedBox(
//                       width: Consts.defaultPadding,
//                     ),
//                     ButtonAction(
//                       onTap: () {},
//                       selected: fridge.door,
//                       iconData: Icons.door_front_door_outlined,
//                       description: 'Puerta',
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: Consts.defaultPadding * 2),
//                 ExitButton(
//                   onTap: () => context.read<FridgeStateCubit>().disconnect(),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
