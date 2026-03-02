import 'dart:convert';

class TokensModel {
  final String? accessToken;
  final String? refreshToken;

  TokensModel({
    this.accessToken,
    this.refreshToken,
  });

  factory TokensModel.empty() {
    return TokensModel(accessToken: null, refreshToken: null);
  }

  TokensModel copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return TokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory TokensModel.fromMap(Map<String, dynamic> map) {
    return TokensModel(
      accessToken: map['token'],
      refreshToken: map['refresh_token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TokensModel.fromJson(String source) =>
      TokensModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'TokensModel(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TokensModel &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
