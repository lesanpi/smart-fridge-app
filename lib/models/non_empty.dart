import 'package:formz/formz.dart';

enum NonEmptyValidationError { empty }

class NonEmpty extends FormzInput<String, NonEmptyValidationError> {
  const NonEmpty.pure({String initial = ''}) : super.pure(initial);

  const NonEmpty.dirty({String value = ''}) : super.dirty(value);

  @override
  NonEmptyValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : NonEmptyValidationError.empty;
  }
}
