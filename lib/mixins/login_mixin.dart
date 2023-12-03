mixin class LoginMixin {
  RegExp emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp nameReg = RegExp(r"^[A-Za-z]+(?:\s+[A-Za-z]+)*$");
  RegExp accountNumberReg = RegExp(r"^[0-9]+$");

  String emailDB = ''; // get the email from DB
  String passwordDB = ''; // get the password from DB

  String? emailValidator(String? typedEmail) {
    if (typedEmail == null || typedEmail.isEmpty) {
      return 'Veuillez saisir votre adresse email';
    } else if (!emailReg.hasMatch(typedEmail)) {
      return 'Entrer une adresse email valide';
    }

    return null;
  }

  String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }
}
