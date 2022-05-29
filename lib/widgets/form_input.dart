import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_led_esp8266/consts.dart';

class FormInput extends StatelessWidget {
  /// Input title displayed on above [TextField]
  final String title;
  final TextEditingController controller;

  /// Whether to hide the text being edited (e.g., for passwords).
  ///
  /// When this is set to true, all the characters in the text field are replaced by [obscuringCharacter].
  ///
  /// Defaults to false. Cannot be null.
  final bool obscureText;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;

  /// Function that validates the input and returns the correct error message
  final String? Function(String?)? validator;

  /// Function executed when the value changes
  final Function(String?)? onChanged;

  /// Optional input validation and formatting overrides.
  ///
  /// Formatters are run in the provided order when the text input changes.
  /// When this parameter changes, the new formatters will not be applied until
  /// the next time the user inserts or deletes text.
  final List<TextInputFormatter>? inputFormatters;

  final Color titleColor;
  final FontWeight titleWeight;
  final TextAlign textAlign;
  const FormInput({
    required this.title,
    required this.controller,
    this.decoration,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.obscureText = false,
    this.titleColor = Consts.primary,
    this.titleWeight = FontWeight.w600,
    this.textAlign = TextAlign.left,
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: titleWeight,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: Consts.defaultPadding / 2),

        /// The TextFormField unlike the TextField can accept a validor
        /// that returns the appropiate error message
        Material(
          elevation: 2.0,
          borderRadius: Consts.inputBorderRadius,
          shadowColor: Colors.black.withOpacity(0.0),
          color: Colors.transparent,
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            obscureText: obscureText,
            decoration: decoration,
            onChanged: onChanged,
            inputFormatters: [
              if (inputFormatters != null) ...inputFormatters!,
            ],
            textAlign: textAlign,

            /// Validator function that validates the conditions of the field
            /// and returns the correct error message
            validator: validator,

            /// [AutovalidateMode.onUserInteraction] in TextFormField allow validate text on every user interaction
            /// and display the appropiate error message
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
