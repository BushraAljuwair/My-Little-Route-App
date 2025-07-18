String? validateFullName(String? value) {
  final RegExp nameRegExp = RegExp(
    r'^[\u0621-\u064Aa-zA-Z]+(?: [\u0621-\u064Aa-zA-Z]+)+$',
  );
  if (value == null || value.isEmpty) {
    return 'The name should not be empty';
  }
  if (!nameRegExp.hasMatch(value)) {
    return "The name must consist of the first and last name.";
  }
  return null;
}

String? validateEmail(String? value) {
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (value == null || value.isEmpty) {
    return 'The email should not be empty';
  }
  if (!emailRegExp.hasMatch(value)) {
    return "Invalid email. Example: name@example.com";
  }
  return null;
}

String? validatePhone(String? value) {
  final RegExp phoneRegExp = RegExp(r'^\d{10}$');  
  if (value == null || value.isEmpty) {
    return 'The phone should not be empty';
  }
  if (!phoneRegExp.hasMatch(value)) {
    return "Invalid phone number, phone number must be 10 digits";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "The password cannot be empty.";
  }
  if (value.length < 8) {
    return "The password must be at least 8 characters long.";
  }
  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    return "Must contain at least one uppercase letter.";
  }
  if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    return "Must contain at least one lowercase letter.";
  }
  if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
    return "Must contain at least one digit.";
  }
  if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
    return "Must contain at least one special character.";
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return "The password cannot be empty.";
  }
  if (value != password) {
    return "Passwords must be same values";
  }

  return validatePassword(value);
}
