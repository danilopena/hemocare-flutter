class AuthErrors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Email já está em uso na aplicação. Tente redefinir a senha!";
      case 'ERROR_INVALID_EMAIL':
        return "The email address is badly formatted.";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";

      case 'ERROR_WRONG_PASSWORD':
        return "Sua senha está incorreta";
      case 'ERROR_USER_NOT_FOUND':
        return "Não foi possível encontrar um usuário com esse email";
      default:
        return "An error has occurred";
    }
  }
}
