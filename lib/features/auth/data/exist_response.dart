class ExistResponse {
  final bool exists;
  final String message;

  ExistResponse({required this.exists, required this.message});

  factory ExistResponse.fromMap(Map<String, dynamic> map) {
    return ExistResponse(
      exists: map['exists'],
      message: map['message'],
    );
  }
}
