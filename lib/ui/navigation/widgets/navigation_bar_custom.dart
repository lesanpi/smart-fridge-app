import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/navigation/navigation.dart';
import 'package:wifi_led_esp8266/ui/setup/setup.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<NavigationCubit>(context, listen: true);
    const navigationBarSize = 80.0;
    const buttonSize = 56.0;
    const buttonMargin = 4.0;
    const topMargin = buttonSize / 2 + buttonMargin / 2;
    final canvasColor = Theme.of(context).canvasColor;
    return Container(
      height: navigationBarSize + topMargin,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: topMargin,
            child: Material(
              elevation: 10,
              shadowColor: Colors.black,
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Consts.defaultPadding * 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HomeNavItem(
                      text: 'Menú',
                      iconData: CupertinoIcons.hand_draw,
                      onTap: () => cubit.onChangeTap(0),

                      ///cubit.onChangeTab(0),
                      selected: cubit.state == 0,

                      ///cubit.state == 0,
                    ),
                    _HomeNavItem(
                      text: 'Perfil',
                      iconData: CupertinoIcons.profile_circled,
                      onTap: () => cubit.onChangeTap(1),
                      selected: cubit.state == 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: canvasColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(buttonMargin / 2),
              child: FloatingActionButton(
                tooltip: 'Nuevo dispositivo',
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const SetupPage(),
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
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
                  // pushToPage(context, FriendsSelectionView());
                },
                child: const Icon(Icons.settings),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HomeNavItem extends StatelessWidget {
  const _HomeNavItem({
    required this.iconData,
    required this.text,
    required this.onTap,
    this.selected = false,
  });

  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    const selectedColor = Consts.primary;
    final unselectedColor = Consts.neutral.shade400;
    final color = selected ? selectedColor : unselectedColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          splashRadius: 5,
          iconSize: 40,
          icon: Icon(iconData, color: color),
          onPressed: onTap,
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
