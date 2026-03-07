// ignore_for_file: unused_catch_stack, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:tayssir/common/data/configs.dart';
import 'package:tayssir/providers/google/google_sign_in.dart';
import 'package:tayssir/providers/token/token_controller.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../debug/app_logger.dart';
import '../features/onboarding/onboarding_notifier.dart';
import '../providers/auth/auth_notifier.dart';
import '../providers/divisions/divisions.dart';
import '../providers/settings/settings_provider.dart';
import '../services/geo/geo_service.dart';
import '../utils/enums/auth_state.dart';
import 'package:tayssir/providers/app_assets/app_assets_provider.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:tayssir/features/home/presentation/subscribe_section.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final routesServiceProvider = Provider<RoutesManager>((ref) {
  return RoutesManager(ref);
});

class RoutesManager {
  RoutesManager(this.ref) {
    init();
  }

  final Ref ref;

  final List<String> loginRoutes = [
    '/login',
    '/register',
    // '/startup',
    '/welcome',
    '/forgetPassword',
    '/verify-email',
  ];

  final List<String> homeRoutes = [
    '/home',
    '/tools',
    '/leaderboard',
    '/challanges',
    '/settings',
    '/subscriptions',
    // '/subscriptions/paper',
    // '/subscriptions/card',
    // '/subscriptions/chargily-init',
  ];

  final isLoading = ValueNotifier<bool>(false);
  final authState = ValueNotifier<AuthStatus>(AuthStatus.unknown);
  final updateCheck = ValueNotifier<bool>(false);
  final isEmailVerified = ValueNotifier<bool>(false);
  final isOnboardingComplete = ValueNotifier<bool>(false);
  final isReadyForTour = ValueNotifier<bool>(false);
  // final shouldWatchBoarding = ValueNotifier<bool>(false);
  init() {
    ref.listen(
        authNotifierProvider.select(
          (value) => value.status,
        ), (prev, next) {
      // if (prev == null) return;
      if (prev == next) return;
      AppLogger.logInfo('Auth state changed from $prev to $next');
      authState.value = next;
    }, fireImmediately: true);

    ref.listen(initialLoadProvider, (prev, next) {
      isLoading.value = next is AsyncLoading;
    }, fireImmediately: true);

    ref.listen(waitingUpdateProvider, (prev, next) {
      updateCheck.value = next;
    }, fireImmediately: true);

    ref.listen(userNotifierProvider, (prev, next) {
      if (next.asData == null || next.asData!.value == null) {
        isEmailVerified.value = false;
        return;
      }
      isEmailVerified.value = next.asData!.value!.isEmailVerified;
    }, fireImmediately: true);

    ref.listen(onboardingProvider, (prev, next) {
      isOnboardingComplete.value = next.isCompleted;
      isReadyForTour.value = next.isReadyForTour;
    }, fireImmediately: true);

    // ref.listen(onBoardingControllerProvider, (prev, next) {
    //   shouldWatchBoarding.value = !next.isComplete;
    // });
  }

  void redirectLog(String path, String destination) {
    AppLogger.logDebug('''
    redirecting from : -> $path
    isLoading : ${isLoading.value}
    authState : ${authState.value}
    redirecting-to : $destination
''');
  }

  FutureOr<String?> onRedirect(
      BuildContext context, GoRouterState state) async {
    final path = state.uri.path;
    
    // Log every redirect attempt for debugging
    AppLogger.logDebug('--- REDIRECT CHECK: path=$path, loading=${isLoading.value}, auth=${authState.value}, readyForTour=${isReadyForTour.value}, onboardDone=${isOnboardingComplete.value}');

    if (isLoading.value || authState.value == AuthStatus.unknown) {
      if (path == '/startup') return null;
      redirectLog(path, '/startup');
      return "/startup";
    }
    final isLoggedIn = authState.value == AuthStatus.authenticated;

    // Logged-in users skip onboarding entirely
    if (isLoggedIn) {
      if ((loginRoutes.contains(path) || path == '/startup' || path == '/onboarding') &&
          !homeRoutes.contains(path)) {
        if (!isEmailVerified.value) {
          redirectLog(path, '/verify-email');
          return '/verify-email';
        }
        redirectLog(path, '/home');
        return '/home';
      } else {
        redirectLog(path, 'NAN');
        return null;
      }
    } else {
      // Not logged in
      if (!isOnboardingComplete.value) {
        if (!isReadyForTour.value) {
          // Allow login routes even during onboarding
          if (loginRoutes.contains(path)) return null;

          // Haven't given name+division yet → go to onboarding
          if (path != '/onboarding') {
            redirectLog(path, '/onboarding');
            return '/onboarding';
          }
          return null;
        } else {
          // Name+division done → allow home for real tour. Block onboarding page.
          if (path == '/onboarding' || path == '/startup') {
            redirectLog(path, '/home');
            return '/home';
          }
          // Keep them in home routes during tour, redirect from login routes
          if (loginRoutes.contains(path) && path != '/welcome') {
            redirectLog(path, '/home');
            return '/home';
          }
          return null;
        }
      }
      // Onboarding fully complete but not logged in → welcome
      if ((path == '/startup' || homeRoutes.contains(path)) &&
          !loginRoutes.contains(path)) {
        redirectLog(path, '/welcome');
        return '/welcome';
      }
    }
    redirectLog(path, 'NAN');
    return null;
  }

  List<ChangeNotifier> get refreshables =>
      [isLoading, authState, isEmailVerified, isOnboardingComplete, isReadyForTour];
}

Future<AuthStatus> waitForAuthState(Ref ref) async {
  final completer = Completer<AuthStatus>();
  AppLogger.logInfo('waiting for auth state...');
  ref.read(tokenProvider.notifier).getTokens();
  ref.listen<AuthStatus>(
      authNotifierProvider.select(
        (value) => value.status,
      ), (previous, next) {
    AppLogger.logInfo('auth state changed to $next');
    if (completer.isCompleted) return;
    if (next != AuthStatus.unknown && !completer.isCompleted) {
      completer.complete(next);
    }
  }, fireImmediately: true);
  return completer.future;
}

final internetStatusProvider = FutureProvider<bool>((ref) async {
  final status = await InternetConnection().hasInternetAccess;
  return status;
});

Future<bool> waitForInternetConnection() async {
  final completer = Completer<bool>();

  bool hasConnection = await InternetConnection().hasInternetAccess;
  if (hasConnection) {
    completer.complete(true);
  } else {
    // show snackbar
    // SnackBarService.showErrorSnackBar(
    // 'لا توجد إشارة إنترنت',
    // );
    final subscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected && !completer.isCompleted) {
        AppLogger.logDebug('Internet connection established');
        completer.complete(true);
      } else {
        AppLogger.logInfo(
          'Internet connection lost, showing snackbar',
        );
        SnackBarService.showErrorSnackBar(
          'لا توجد إشارة إنترنت',
        );
      }
    });

    completer.future.then((_) {
      subscription.cancel();
    });
  }

  return completer.future;
}

final waitingUpdateProvider = StateProvider<bool>((ref) => false);

Future<bool> checkForUpdate() async {
  final completer = Completer<bool>();

  try {
    final info = await InAppUpdate.checkForUpdate();
    AppLogger.logInfo('Update info: $info');

    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      AppLogger.logInfo('Update available: ${info.availableVersionCode}');
      SnackBarService.showSuccessSnackBar('Updater');
      await InAppUpdate.performImmediateUpdate();

      completer.complete(true);
    } else {
      AppLogger.logInfo('No update available');
      completer.complete(false);
    }
  } catch (e) {
    AppLogger.logError('Error checking for update: $e');
    completer.complete(false);
  }

  return completer.future;
}

// final internetConnectionProvider = Provider<InternetConnectionStatus>((ref) {
//   final notifier = ValueNotifier<InternetConnectionStatus>(InternetConnectionStatus.disconnected);
//   InternetConnectionCheckerPlus().onStatusChange.listen((status) {
//     notifier.value = status;
//   });
//   return notifier.value;
// });

// final internetConnectionChecker = FutureProvider<bool>((ref) async {
//   final completer = Completer<bool>();

//   final checkConnection = () async {
//     final hasConnection = await InternetConnectionCheckerPlus().hasConnection;
//     return hasConnection;
//   };

//   bool connected = await checkConnection();
//   if (connected) {
//     completer.complete(true);
//   } else {
//     // Listen for connection changes
//     final subscription = InternetConnectionCheckerPlus().onStatusChange.listen((status) {
//       if (status == InternetConnectionStatus.connected && !completer.isCompleted) {
//         completer.complete(true);
//       }
//     });

//     // Ensure subscription is cancelled when no longer needed
//     completer.future.then((_) {
//       subscription.cancel();
//     });
//   }

//   return completer.future;
// });
final initialLoadProvider = FutureProvider<bool>((ref) async {
  try {
    final hasConnection = await waitForInternetConnection();
    if (hasConnection) {
      // try {
      //   final info = await InAppUpdate.checkForUpdate();
      //   AppLogger.logDebug('Update info: $info');
      //   if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      //     AppLogger.logDebug('Update available: ${info.availableVersionCode}');
      //     await InAppUpdate.performImmediateUpdate();
      //   }
      // } catch (e) {
      //   // await InAppUpdate.performImmediateUpdate();
      //   AppLogger.logError('Error checking for update: $e');
      // }
      await checkForUpdate();
      final authState = await waitForAuthState(ref);
      await ref.watch(wilayasProvider.future);
      await ref.watch(divisionsProvider.future);
      await ref.watch(appAssetsProvider.future);
      
      // await ref.watch(subscriptionOptionsProvider.future); //required auth
      await ref.watch(googleSignInInitProvider.future);
      await ref.watch(sharedPreferencesProvider.future);
      await ref.read(settingsNotifierProvider.notifier).getSettings();
      await ref.watch(configsProvider.future);
      
      // Fetch materials/subjects early so they are ready for the Home Screen
      await ref.read(dataProvider.notifier).getData();
      
      // Fetch banners early (only if authenticated)
      if (authState == AuthStatus.authenticated) {
        await ref.watch(bannerItemsProvider.future);
      }
      
      // --- NEW: Deterministic Asset Precaching before Splash finishes ---
      // This ensures that when the user hits the Home page, the images are already in CACHE.
      await _precacheEverything(ref);
      
    } else {
      AppLogger.logInfo('No internet connection, loading in offline mode');
    }

    // await ref.read(dataNotifierProvider.notifier).init();
    return true;
  } catch (e, stackTrace) {
    AppLogger.logError('Error loading content: $e');
    return false;
  }
});

/// Resolves and caches all critical UI images early to prevent 'flicker' or 'pop-in'.
Future<void> _precacheEverything(Ref ref) async {
  try {
    final assetsMap = ref.read(appAssetsProvider).valueOrNull ?? {};
    final materials = ref.read(dataProvider).contentData.modules;
    final user = ref.read(userNotifierProvider).valueOrNull;

    final List<Future> precacheTasks = [];

    // 1. Dynamic App Assets (Heros, Arenas, etc)
    for (final asset in assetsMap.values) {
      if (asset.url.isNotEmpty && !asset.url.toLowerCase().contains('.svg')) {
        final fullUrl = '${asset.url}?${asset.version}';
        precacheTasks.add(_precacheImageProvider(CachedNetworkImageProvider(fullUrl)));
      }
    }

    // 2. Material/Subject Images
    for (final m in materials) {
      final imageUrls = [m.imageList, m.imageGrid];
      for (final rawUrl in imageUrls) {
        if (rawUrl.isNotEmpty) {
          final fullUrl = rawUrl.startsWith('http') 
              ? rawUrl 
              : 'https://gcc.tayssir-bac.com/storage/${rawUrl.replaceAll(RegExp(r'^/'), '')}';
          precacheTasks.add(_precacheImageProvider(CachedNetworkImageProvider(fullUrl)));
        }
      }
    }

    // 3. User Identity (Avatar and Badge)
    if (user != null) {
      if (user.completeProfilePic.isNotEmpty) {
        precacheTasks.add(_precacheImageProvider(CachedNetworkImageProvider(user.completeProfilePic)));
      }
      final badgeIcon = user.badge?.completeIconUrl;
      if (badgeIcon != null && badgeIcon.isNotEmpty) {
        precacheTasks.add(_precacheImageProvider(CachedNetworkImageProvider(badgeIcon)));
      }
    }

    // 4. Banners
    final banners = ref.read(bannerItemsProvider).valueOrNull ?? [];
    for (final b in banners) {
      if (b.image != null && b.image!.isNotEmpty) {
        precacheTasks.add(_precacheImageProvider(CachedNetworkImageProvider(b.image!)));
      }
    }

    // Wait for all downloads to finish (or timeout after 5s to not block splash forever)
    if (precacheTasks.isNotEmpty) {
      AppLogger.logInfo('Precaching ${precacheTasks.length} assets before dashboard entry...');
      await Future.wait(precacheTasks).timeout(const Duration(seconds: 8), onTimeout: () => []);
    }
  } catch (e) {
    AppLogger.logError('Warning: Prefetching assets failed: $e');
  }
}

/// Helper to precache images without a BuildContext
Future<void> _precacheImageProvider(ImageProvider provider) {
  final completer = Completer<void>();
  final stream = provider.resolve(ImageConfiguration.empty);
  late ImageStreamListener listener;
  listener = ImageStreamListener(
    (ImageInfo info, bool syncCall) {
      if (!completer.isCompleted) completer.complete();
      stream.removeListener(listener);
    },
    onError: (dynamic exception, StackTrace? stackTrace) {
      if (!completer.isCompleted) completer.complete();
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future;
}
