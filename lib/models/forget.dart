class ForgotPassword {
  String email;
  String token;

  ForgotPassword(this.email, this.token);

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'token': token,
    };
  }

  factory ForgotPassword.fromMap(Map<String, dynamic> map) {
    return ForgotPassword(
      map['email'],
      map['token'],
    );
  }
}
