class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequest({required this.oldPassword, required this.newPassword});
  //to map
  Map<String, dynamic> toMap() {
    return {
      'current_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPassword,
    };
  }
}
