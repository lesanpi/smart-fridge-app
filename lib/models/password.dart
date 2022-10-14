import 'package:formz/formz.dart';

enum PasswordValidationError { invalid, empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty({String value = ''}) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (!RegExp(_pattern).hasMatch(value)) {
      return PasswordValidationError.invalid;
    }

    return null;
  }

  /// At least 8 characters, at least one letter (lower and uppercase), one
  /// number and one special character.
  static const String _pattern =
      r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=.\-_*])([a-zA-Z0-9@#$%^&+=*.\-_]){8,}$';
}
