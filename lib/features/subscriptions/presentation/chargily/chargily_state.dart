import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChargilyResponse {
  success,
  failure,
  pending,
}

class ChargilyState {
  final AsyncValue<void> status;
  final String? url;
  final ChargilyResponse response;

  const ChargilyState({
    required this.status,
    this.url,
    this.response = ChargilyResponse.pending,
  });

  ChargilyState copyWith({
    AsyncValue<void>? status,
    String? url,
    ChargilyResponse? response,
  }) {
    return ChargilyState(
      status: status ?? this.status,
      url: url ?? this.url,
      response: response ?? this.response,
    );
  }
}
