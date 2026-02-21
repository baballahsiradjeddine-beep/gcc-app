class ContactUsModel {
  final String name;
  final String email;
  final String message;

  ContactUsModel(
      {required this.name, required this.email, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'message': message,
    };
  }
}
