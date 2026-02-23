
class RegisterRequestModel {
  String username;
  String email;
  String password;

  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "name": username,
      "email": email,
      "password": password,
    };
  }
}

class VerifyEmailRequest {
  String email;

  VerifyEmailRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
    };
  }
}

class CheckPhoneRequestModel {
  String phone;

  CheckPhoneRequestModel({
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "phone": phone,
    };
  }
}

class CreateAccountRequestModel {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final int age;
  final int wilaya;
  final int commune;
  final int filliere;
  final int knowOption;

  CreateAccountRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.age,
    required this.wilaya,
    required this.commune,
    required this.filliere,
    required this.knowOption,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "password_confirmation": password,
      "name": fullName,
      "phone_number": phoneNumber,
      "age": age,
      "wilaya_id": wilaya,
      "commune_id": commune,
      "division_id": filliere,
      // "know_option": knowOption.value,
      'referral_source_id': knowOption,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
      "password_confirmation": password,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "age": age,
      "wilaya": wilaya,
      "commune": commune,
      "filliere": filliere,
      "referral_source_id": knowOption,
    };
  }
}
