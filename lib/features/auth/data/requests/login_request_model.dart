class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
    };
  }

  LoginRequestModel copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
