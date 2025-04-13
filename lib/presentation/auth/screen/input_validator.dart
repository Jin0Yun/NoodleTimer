class InputValidator {
  static String? validateEmail(String email) {
    final isValid = email.contains('@') && email.contains('.');
    return isValid ? null : '이메일 형식이 올바르지 않습니다.';
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
}