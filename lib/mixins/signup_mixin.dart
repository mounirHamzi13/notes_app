mixin class SignupMixin {
  RegExp emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp nameReg = RegExp(r"^[A-Za-z]+(?:\s+[A-Za-z]+)*$");
  RegExp accountNumberReg = RegExp(r"^[0-9]+$");
  RegExp usernameReg = RegExp(r"^[a-zA-Z0-9_]{3,12}$");

  String? nomValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Veuillez saisir votre nom';
    }
    if (!nameReg.hasMatch(name)) {
      return 'Entrer un nom valide';
    }
    return null;
  }

  String? prenomValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Veuillez saisir votre prenom';
    }
    if (!nameReg.hasMatch(name)) {
      return 'Entrer un prenom valide';
    }
    return null;
  }

  String? emailValidator(String? typedEmail) {
    if (typedEmail == null || typedEmail.isEmpty) {
      return 'Enter your email';
    }
    if (!emailReg.hasMatch(typedEmail)) {
      return 'Unvalid Email adresse ';
    }

    return null;
  }

  String? usernameValidator(String? username) {
    if (username == null || username.isEmpty) {
      return 'Enter a Username';
    }
    if (!usernameReg.hasMatch(username)) {
      return ' Unvalid username';
    }
    return null;
  }

  String? accountNumberValidator(String? accountNumber) {
    if (accountNumber == null || accountNumber.isEmpty) {
      return 'Veuillez saisir votre numéro de compte';
    }
    if (!accountNumberReg.hasMatch(accountNumber)) {
      return 'Entrer un numéro de compte valide';
    }
    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Enter a password';
    }
    if (password.length < 6) {
      return 'password must have at least 6 characters';
    }
    return null;
  }

  String? passwordConfirmationValidator(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}
