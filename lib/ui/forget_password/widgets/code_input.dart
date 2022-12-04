import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:wifi_led_esp8266/consts.dart';
import 'package:wifi_led_esp8266/ui/forget_password/cubit/cubit.dart';

class ForgetPasswordCodeInput extends StatelessWidget {
  const ForgetPasswordCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.poppins(
        fontSize: 20,
        color: const Color.fromRGBO(70, 69, 66, 1),
      ),
      decoration: BoxDecoration(
        color: Consts.primary.shade100,
        // color: const Color.fromRGBO(232, 235, 241, 0.37),

        borderRadius: BorderRadius.circular(24),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(137, 146, 160, 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      separator: const SizedBox(width: 16),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
              offset: Offset(0, 3),
              blurRadius: 16,
            )
          ],
        ),
      ),
      onChanged: context.read<ForgetPasswordCubit>().codeChanged,
      showCursor: true,
      cursor: cursor,
    );
  }
}
