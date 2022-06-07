/// String validators for text inputs of different types.
class Validators {
  /// Checks if the input is a valid email address.
  static final emailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final String emailErrorMessage = "Correo electrónico inválido";

  /// Checks if the input is a valid name.
  static final RegExp nameValidator = RegExp(r'^[a-zA-Z ]+$');
  static const String nameErrorMessage =
      "Nombre inválido. El nombre solo puede contener letras.";

  /// Checks if the input is a valid password.
  static final RegExp passwordValidator =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static const String passwordErrorMessage =
      "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number and one special character";

  /// VE phone validator with no extension. Checks if the input is a valid phone number from
  /// Venezuela.
  ///
  /// Valid formats: 04141234567, 4141234567
  static final phoneValidatorVE = RegExp(r"^[0-9]{7}$");

  /// Validate email. In case of error returns the appropiate error message
  static String? validateEmail(String? email) {
    if (email == null) return null;

    if (email.isEmpty) {
      // If email is empty.
      return 'Ingrese su correo electrónico';
    }

    if (!Validators.emailValidator.hasMatch(email)) {
      // If the email is not valid.
      return 'Correo electrónico inválido';
    }

    return null;
  }

  /// Validate the text.
  /// In case of error, returns a error message
  static String? validateEmpty(String? text) {
    if (text == null) {
      return null;
    }

    if (text.isEmpty) {
      return 'Este campo es obligatorio';
    }

    return null;
  }

  /// Validates the phoneNumberVe.
  /// In case of error returns the appropiate error message
  static String? validatePhone(String? phone) {
    if (phone == null) {
      return null;
    }

    if (phone.isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (!Validators.phoneValidatorVE.hasMatch(phone)) {
      return 'Número de teléfono inválido';
    }

    return null;
  }

  /// Validates the password.
  /// In case of error returns the appropiate error message
  static String? validatePassword(String? password) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    return null;
  }

  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return "Seleccione una opción";
    }

    return null;
  }

  static final String phoneErrorMessage = "Número de telefono inválido";
}
