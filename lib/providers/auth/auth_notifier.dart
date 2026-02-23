import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/auth/auth_state.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import '../../utils/enums/auth_state.dart';
import '../data/data_provider.dart';
import '../user/user_model.dart';

extension UserStateChecks on AsyncValue<UserModel?> {
  bool get isValidUserTransition {
    return asData?.value != null && !asData!.value!.isEmpty;
  }

  bool get shouldSkipStateUpdate {
    return isLoading || hasError;
  }

  bool get isNotValid {
    return !hasData || value == null || value!.isEmpty;
  }

  bool get hasData => asData != null;

  bool get validUserValue {
    return value != null && !value!.isEmpty;
  }

  bool get canGetData {
    return validUserValue && value!.isEmailVerified;
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  // final Ref ref;
  final Ref ref;
  AuthNotifier(this.ref)
      : super(
          const AuthState(status: AuthStatus.unknown, isLoading: false),
        ) {
    AppLogger.logInfo("Auth Notifier Initialized");
    _init();
  }
  void checkAuthState() {
    if (ref.watch(userNotifierProvider).isValidUserTransition) {
      setAuthenticated();
    } else {
      setUnauthenticated();
    }
  }

  Future<void> _init() async {
    ref.listen(
      userNotifierProvider,
      (prv, next) async {
        AppLogger.logInfo("Auth Listener Triggered");
        // AppLogger.logInfo("Previous User: ${prv?.asData?.value}");
        // AppLogger.logInfo("Next User: ${next.asData?.value}");
        // AppLogger.logInfo("Next isLoading: ${next.isLoading}");
        // AppLogger.logInfo("Next hasError: ${next.hasError}");
        // AppLogger.logInfo("Next isNotValid: ${next.isNotValid}");
        // AppLogger.logInfo("Next validUserValue: ${next.validUserValue}");
        // AppLogger.logInfo("Current Auth Status: ${state.status}");
        if (prv != null &&
            prv.asData != null &&
            prv.asData!.value != null &&
            !prv.asData!.value!.isEmpty &&
            !prv.asData!.value!.isEmailVerified &&
            next.asData != null &&
            next.asData!.value != null &&
            !next.asData!.value!.isEmpty &&
            next.asData!.value!.isEmailVerified) {
          AppLogger.logInfo("User just verified his email");
          ref.read(dataProvider.notifier).getData();
          return;
        }

        if (prv != null &&
            prv.asData != null &&
            prv.asData!.value != null &&
            !prv.asData!.value!.isEmpty &&
            next.asData != null &&
            next.asData!.value != null &&
            !next.asData!.value!.isEmpty) {
          AppLogger.logInfo("User is already authenticated");
          return;
        }

        if (next.shouldSkipStateUpdate) {
          return;
        }
        if (next.isNotValid) {
          setUnauthenticated();
          return;
        }
        if (next.validUserValue) {
          setLoading();
          if (next.canGetData) ref.read(dataProvider.notifier).getData();
          setAuthenticated();
          return;
        }
        setUnauthenticated();
        return;
      },
    );
  }

  void setAuthenticated() {
    if (state.status == AuthStatus.authenticated) return;

    state = state.copyWith(status: AuthStatus.authenticated, isLoading: false);
  }

  void setUnauthenticated() {
    if (state.status == AuthStatus.unauthenticated) return;
    // AppLogger.sendLog(
    // email: ref.watch(userNotifierProvider).requireValue!.email,
    // content: 'User made a transition to unauthenticated state',
    // );
    state =
        state.copyWith(status: AuthStatus.unauthenticated, isLoading: false);
  }

  void setLoading() {
    state = state.copyWith(isLoading: true);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  AppLogger.logInfo("Auth Notifier Provider Initialized");
  return AuthNotifier(ref);
});
