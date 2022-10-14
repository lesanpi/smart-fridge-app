import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalid,
}

/// Email representation class which extends [FormzInput] and provides
/// validation logic.
class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  String? _errorMessages(EmailValidationError? error) {
    if (error == null) {
      return null;
    }
    switch (error) {
      case EmailValidationError.empty:
        return 'Campo obligatorio';
      case EmailValidationError.invalid:
        return 'Este email no es válido';
    }
  }

  String? get errorMessage => _errorMessages(error);

  @override
  EmailValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return EmailValidationError.empty;
    }

    if (!RegExp(_emailPattern).hasMatch(value)) {
      return EmailValidationError.invalid;
    }

    return null;
  }

  static const String _emailPattern =
      r'^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$';
}
