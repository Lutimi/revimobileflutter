class Validators {
  // Crear regExp

  //Nombres maximo 30 letras
  static final RegExp _nameRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  // Email:
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  // Password:
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  // isValidName
  static isValidName(String name) {
    return _nameRegExp.hasMatch(name);
  }

  // isValidEmail
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  // isValidPassword
  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
