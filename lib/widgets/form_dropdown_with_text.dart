import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_led_esp8266/consts.dart';

class FormDropdownWithText extends StatelessWidget {
  // For title
  final String title;
  final Color titleColor;
  final FontWeight titleWeight;
  // For Dropdown
  final String? value;
  final List<String> itemOptions;
  final Function(String?)? onChanged;
  final Function(String?)? onChangedText;
  final String? Function(String?)? validator;

  // For text input
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  // Decoration
  final InputDecoration? dropdownDecoration;
  final InputDecoration? textInputDecoration;

  final TextInputType? keyboardType;

  const FormDropdownWithText({
    Key? key,
    required this.controller,
    required this.value,
    required this.itemOptions,
    this.onChanged,
    this.onChangedText,
    required this.title,
    this.titleColor = Consts.primary,
    this.titleWeight = FontWeight.w700,
    this.validator,
    this.dropdownDecoration,
    this.textInputDecoration,
    this.keyboardType,
    this.inputFormatters,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField(
                value: value,
                items:
                    itemOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onChanged,
                elevation: 2,
                decoration: dropdownDecoration,
                icon: const Icon(Icons.keyboard_arrow_down),
                // validator: validator,
              ),
            ),
            const SizedBox(width: Consts.defaultPadding / 2),
            Expanded(
              flex: 5,
              child: Material(
                elevation: 2.0,
                borderRadius: Consts.inputBorderRadius,
                shadowColor: Colors.black.withOpacity(0.0),
                color: Colors.transparent,
                child: TextFormField(
                  keyboardType: keyboardType,
                  controller: controller,
                  obscureText: false,
                  decoration: textInputDecoration,
                  inputFormatters: [
                    if (inputFormatters != null) ...inputFormatters!,
                  ],

                  /// Validator function that validates the conditions of the field
                  /// and returns the correct error message
                  validator: validator,
                  onChanged: onChangedText,

                  /// [AutovalidateMode.onUserInteraction] in TextFormField allow validate text on every user interaction
                  /// and display the appropiate error message
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
