import 'package:equatable/equatable.dart';

import '../../utils/enums/auth_state.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final bool isLoading;

  const AuthState({required this.status, this.isLoading = false});

  factory AuthState.empty() {
    return const AuthState(status: AuthStatus.unknown);
  }

  AuthState copyWith({AuthStatus? status, bool? isLoading}) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, isLoading];
}
