class InputValidator {
  static String? validateEmail(String email) {
    final isValid = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    return isValid.hasMatch(email) ? null : '이메일 형식이 올바르지 않습니다.';
  }
  
  static String? validatePassword(String password) {
    final isValid = password.length >= 8;
    return isValid ? null : '8자 이상 입력해주세요.';
  }

  static String? validatePasswordConfirmation(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return '비밀번호 확인을 입력해주세요.';
    return password.trim() == confirmPassword.trim()
        ? null
        : '비밀번호가 일치하지 않습니다.';
  }

  static String? validateLoginInputs(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return '이메일과 비밀번호를 입력해주세요.';
    }

    final emailValidation = validateEmail(email);
    if (emailValidation != null) {
      return emailValidation;
    }

    return null;
  }
}