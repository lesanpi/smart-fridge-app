import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/data/repositories/cloud_repository.dart';
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
          create: (context) =>
              FridgeStateCubit(context.read(), context.read())..init(),
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
      child: const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: CloudAppBar(),
        ),
        // backgroundColor: Consts.lightSystem.shade300,
        body: SafeArea(
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
          return const Center(
            child: LoadingMessage(),
          );
        }

        if (state is CloudConnectionEmpty) return const FridgesEmpty();

        if (state.fridgesStates.isEmpty) {
          return const FridgesEmpty();
        }
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
              padding: EdgeInsets.symmetric(
                vertical: Consts.defaultPadding,
                horizontal: Consts.defaultPadding,
              ),
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
