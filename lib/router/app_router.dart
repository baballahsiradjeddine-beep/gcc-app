import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/features/auth/presentation/verify-email/verify_email_screen.dart';
import 'package:tayssir/features/leaderboard/leaderboard_screen.dart';
import 'package:tayssir/features/notifications/presentation/notifications_screen.dart';
import 'package:tayssir/features/settings/contact_us/contact_us_screen.dart';
// import 'package:tayssir/features/settings/notifications/notifications_view.dart'
//     show NotificationScreen;
import 'package:tayssir/features/settings/security/change_email/change_email_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/chargily/chargily_init_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/chargily/chargily_web_view_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/subscription_options_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/paper/subscription_paper_screen.dart';
import 'package:tayssir/features/subscriptions/presentation/payments_methodes_screen.dart';
import 'package:tayssir/features/auth/presentation/auth_screen.dart';
import 'package:tayssir/features/auth/presentation/forget-password/forget_password_screen.dart';
import 'package:tayssir/features/auth/presentation/login/login_screen.dart';
import 'package:tayssir/features/auth/presentation/register/register_screen.dart';
import 'package:tayssir/features/exercice/presentation/exercice_result_screen.dart';
import 'package:tayssir/features/exercice/presentation/exercice_screen.dart';
import 'package:tayssir/features/exercice/presentation/post_exercise_screen.dart';
import 'package:tayssir/features/home/presentation/home_screen.dart';
import 'package:tayssir/features/profile/profile_screen.dart';
import 'package:tayssir/features/profile/achievement_log_screen.dart';
// import 'package:tayssir/features/settings/notifications/notifications_view.dart';
import 'package:tayssir/features/settings/security/security_screen.dart';
import 'package:tayssir/features/tools/bacs/bacs_screen.dart';
import 'package:tayssir/features/tools/grade_calc/grade_calculator_screen.dart';
import 'package:tayssir/features/tools/pomodoro/pomodoro_screen.dart';
import 'package:tayssir/features/splash/splash_screen.dart';
import 'package:tayssir/features/tools/card_swipper/card_swipper_screen.dart';
import 'package:tayssir/features/tools/common/pdf_content_screen.dart';
import 'package:tayssir/features/tools/resumes/resumes_screen.dart';
import 'package:tayssir/router/app_transitions.dart';

import '../common/coming_soon_screen.dart';
import '../features/chapters/chapters_screen.dart';
import '../features/settings/security/reset_password_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/subscriptions/presentation/card/subscription_card_screen.dart';
import '../features/tools/tools_screen.dart';
import '../features/units/units_screen.dart';
import 'package:tayssir/features/streaks/presentation/streak_screen.dart';
import 'package:tayssir/features/challanges/challenges_screen.dart';
import 'package:tayssir/features/challanges/presentation/matchmaking_screen.dart';
import 'package:tayssir/features/challanges/presentation/arena_screen.dart';
import 'bottom_navigation/main_scaffold.dart';
import 'not_found_screen.dart';
import 'routes_service.dart';

enum AppRoutes {
  splash,
  home,
  login,
  units,
  chapters,
  exercices,
  tools,
  leaderboard,
  challanges,
  challengeMatchmaking,
  challengeArena,
  settings,
  register,
  welcome,
  results,
  forgetPassword,
  profile,
  midResults,
  pomodoro,
  gradeCalculator,
  resumes,
  bacaluratSolutions,
  notifcations,
  security,
  changeUserInfo,
  subCard,
  subscriptions,
  aboutUs,
  version,
  contactUs,
  subscriptionOptions,
  resetPassword,
  postExercise,
  changeEmail,
  cardSwipper,
  pdfContent,
  bacs,
  verifyEmail,
  subscriptionPaper,
  chargilyWebView,
  chargilyInit,
  streak,
  achievementLog,
}

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.onDispose(() {
    AppLogger.logDebug('disposing app router');
  });
  final routesManager = ref.watch(routesServiceProvider);
  return GoRouter(
    debugLogDiagnostics: false,
    redirect: routesManager.onRedirect,
    errorBuilder: (context, state) {
      return const NotFoundScreen();
    },
    refreshListenable: Listenable.merge(routesManager.refreshables),
    initialLocation: '/startup',
    routes: [
      TayssirCustomGoRoute(
        name: AppRoutes.splash.name,
        path: '/startup',
        pageBuilder: (context, state) {
          return const SplashScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/tools',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const ToolsScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    );
                  },
                  routes: [
                    TayssirCustomGoRoute(
                      path: 'pomodoro',
                      name: AppRoutes.pomodoro.name,
                      pageBuilder: (context, state) {
                        return const PomodoroScreen();
                      },
                      transitionType: TransitionType.sharedAxis,
                      slideDirection: SlideDirection.left,
                      duration: const Duration(milliseconds: 600),
                    ),
                    TayssirCustomGoRoute(
                      path: 'grade-calc',
                      name: AppRoutes.gradeCalculator.name,
                      pageBuilder: (context, state) {
                        return const GradeCalculatorScreen();
                      },
                      transitionType: TransitionType.sharedAxis,
                      slideDirection: SlideDirection.left,
                      duration: const Duration(milliseconds: 600),
                    ),
                    TayssirCustomGoRoute(
                      name: AppRoutes.cardSwipper.name,
                      path: '/card-swipper',
                      pageBuilder: (context, state) {
                        return const CardSwipperScreen();
                      },
                      transitionType: TransitionType.sharedAxis,
                      slideDirection: SlideDirection.left,
                      duration: const Duration(milliseconds: 300),
                    ),
                    TayssirCustomGoRoute(
                      name: AppRoutes.resumes.name,
                      path: '/resumes',
                      pageBuilder: (context, state) {
                        return const ResumesScreen();
                      },
                      routes: [
                        TayssirCustomGoRoute(
                          name: AppRoutes.pdfContent.name,
                          path: 'content',
                          pageBuilder: (context, state) {
                            final data = state.extra! as Map<String, dynamic>;
                            return PdfContentScreen(
                              pdfUrl: data['pdfUrl'],
                            );
                          },
                        )
                      ],
                      transitionType: TransitionType.sharedAxis,
                      slideDirection: SlideDirection.left,
                      duration: const Duration(milliseconds: 300),
                    ),
                    TayssirCustomGoRoute(
                      name: AppRoutes.bacs.name,
                      path: '/bacs',
                      pageBuilder: (context, state) {
                        return const BacsScreen();
                      },
                      routes: const [
                        // TayssirCustomGoRoute(
                        //   name: AppRoutes.pdfContent.name,
                        //   path: 'content',
                        //   pageBuilder: (context, state) {
                        //     final data = state.extra! as Map<String, dynamic>;
                        //     return PdfContentScreen(
                        //       pdfUrl: data['pdfUrl'],
                        //     );
                        //   },
                        // )
                      ],
                      transitionType: TransitionType.sharedAxis,
                      slideDirection: SlideDirection.left,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/leaderboard',
                  builder: (BuildContext context, GoRouterState state) =>
                      const LeaderboardScreen()),
            ],
          ),
          StatefulShellBranch(
            // navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                name: AppRoutes.home.name,
                path: '/home',
                routes: [
                  TayssirCustomGoRoute(
                    path: 'units/:courseId',
                    name: AppRoutes.units.name,
                    pageBuilder: (context, state) {
                      final courseId = state.pathParameters['courseId'];
                      return UnitsScreen(
                        courseId: int.parse(courseId!),
                      );
                    },
                    transitionType: TransitionType.sharedAxis,
                    duration: const Duration(milliseconds: 500),
                  ),
                ],
                pageBuilder: (context, state) {
                  return const MaterialPage(
                    child: HomeScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/challanges',
                name: AppRoutes.challanges.name,
                pageBuilder: (context, state) => CupertinoPage(
                  key: state.pageKey,
                  child: const ChallengesScreen(),
                ),
                routes: [
                  TayssirCustomGoRoute(
                    name: AppRoutes.challengeMatchmaking.name,
                    path: 'matchmaking',
                    pageBuilder: (context, state) {
                      final data = state.extra! as Map<String, dynamic>;
                      return MatchmakingScreen(
                        unitId: data['unitId'] as int,
                        courseTitle: data['courseTitle'] as String,
                      );
                    },
                    transitionType: TransitionType.sharedAxis,
                    duration: const Duration(milliseconds: 300),
                  ),
                  TayssirCustomGoRoute(
                    name: AppRoutes.challengeArena.name,
                    path: 'arena',
                    pageBuilder: (context, state) {
                      final data = state.extra! as Map<String, dynamic>;
                      return ArenaScreen(
                        matchId: data['matchId'] as String,
                        unitId: data['unitId'] as int,
                        courseTitle: data['courseTitle'] as String,
                      );
                    },
                    transitionType: TransitionType.sharedAxis,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
                // TayssirCustomGoRoute(
                // path: '/challanges',
                // name: AppRoutes.challanges.name,
                // pageBuilder: (context, state) {
                // return const ComingSoonScreen();
                // },
                // transitionType: TransitionType.sharedAxis,
                // duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/settings',
                  name: AppRoutes.settings.name,
                  routes: [
                    // notifications
                    // TayssirCustomGoRoute(
                    //   path: 'notifications',
                    //   name: AppRoutes.notifcations.name,
                    //   pageBuilder: (context, state) {
                    //     return const NotificationScreen();
                    //   },
                    //   transitionType: TransitionType.sharedAxis,
                    //   duration: const Duration(milliseconds: 300),
                    // ),
                    TayssirCustomGoRoute(
                      path: 'security',
                      name: AppRoutes.security.name,
                      pageBuilder: (context, state) {
                        return const SecurityScreen();
                      },
                      transitionType: TransitionType.sharedAxis,
                      duration: const Duration(milliseconds: 300),
                    ),
                    TayssirCustomGoRoute(
                      path: 'contact-us',
                      name: AppRoutes.contactUs.name,
                      pageBuilder: (context, state) {
                        return const ContactUsScreen();
                      },
                      transitionType: TransitionType.sharedAxis,
                      duration: const Duration(milliseconds: 300),
                    ),
                    // TayssirCustomGoRoute(
                    //   path: 'about-us',
                    //   name: AppRoutes.aboutUs.name,
                    //   pageBuilder: (context, state) {
                    //     return const NotificationScreen();
                    //   },
                    //   transitionType: TransitionType.sharedAxis,
                    //   slideDirection: SlideDirection.right,
                    //   duration: const Duration(milliseconds: 300),
                    // ),
                    // TayssirCustomGoRoute(
                    //   path: 'version',
                    //   name: AppRoutes.version.name,
                    //   pageBuilder: (context, state) {
                    //     return const NotificationScreen();
                    //   },
                    //   transitionType: TransitionType.sharedAxis,
                    //   duration: const Duration(milliseconds: 300),
                    // )
                  ],
                  builder: (BuildContext context, GoRouterState state) =>
                      const SettingsScreen()),
            ],
          ),
        ],
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.exercices.name,
        path: '/exercices',
        pageBuilder: (context, state) {
          return const ExerciceScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.chapters.name,
        path: '/chapters/:unitId',
        pageBuilder: (context, state) {
          final unitId = state.pathParameters['unitId'];
          return ChaptersScreen(
            unitId: int.parse(unitId!),
          );
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.login.name,
        path: '/login',
        pageBuilder: (context, state) {
          return const LoginScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.resetPassword.name,
        path: '/reset-password',
        pageBuilder: (context, state) {
          return const ResetPasswordScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.changeEmail.name,
        path: '/change-email',
        pageBuilder: (context, state) {
          return const ChangeEmailScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.results.name,
        path: '/results',
        pageBuilder: (context, state) {
          return const ExerciceResultScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.midResults.name,
        path: '/mid-results',
        pageBuilder: (context, state) {
          return const MidResultScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.register.name,
        path: '/register',
        pageBuilder: (context, state) {
          return const RegisterScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.verifyEmail.name,
        path: '/verify-email',
        pageBuilder: (context, state) {
          return const VerifyEmailScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.welcome.name,
        path: '/welcome',
        pageBuilder: (context, state) {
          return const AuthScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.forgetPassword.name,
        path: '/forget-password',
        pageBuilder: (context, state) {
          return const ForgetPasswordView();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
          name: AppRoutes.subscriptionOptions.name,
          path: '/sub-options',
          pageBuilder: (context, state) {
            return const SubscriptionOptionsScreen();
          },
          transitionType: TransitionType.sharedAxis,
          duration: const Duration(milliseconds: 300),
          routes: [
            TayssirCustomGoRoute(
                name: AppRoutes.subscriptions.name,
                path: 'subscriptions',
                pageBuilder: (context, state) {
                  final data = state.extra! as Map<String, dynamic>;

                  return SubscriptionsScreen(
                    subscription: data['subscription'],
                  );
                },
                transitionType: TransitionType.sharedAxis,
                duration: const Duration(milliseconds: 300),
                routes: [
                  TayssirCustomGoRoute(
                    name: AppRoutes.subCard.name,
                    path: 'card',
                    pageBuilder: (context, state) {
                      final data = state.extra! as Map<String, dynamic>;

                      return SubscriptionCardScreen(
                        subscription: data['subscription'],
                      );
                    },
                    transitionType: TransitionType.sharedAxis,
                    duration: const Duration(milliseconds: 300),
                  ),
                  TayssirCustomGoRoute(
                    name: AppRoutes.subscriptionPaper.name,
                    path: 'paper',
                    pageBuilder: (context, state) {
                      final data = state.extra! as Map<String, dynamic>;

                      return SubscriptionPaperScreen(
                        subscription: data['subscription'],
                      );
                    },
                    transitionType: TransitionType.sharedAxis,
                    duration: const Duration(milliseconds: 300),
                  ),
                ]),
          ]),
      TayssirCustomGoRoute(
        name: AppRoutes.profile.name,
        path: '/profile',
        pageBuilder: (context, state) {
          return const ProfileScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.notifcations.name,
        path: '/notifications',
        pageBuilder: (context, state) {
          return const NotificationsScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.chargilyWebView.name,
        path: '/chargily',
        pageBuilder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          final checkoutUrl = data['checkoutUrl'] as String;

          return CheckoutWebView(
            checkoutUrl: checkoutUrl,
          );
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.chargilyInit.name,
        path: '/chargily-init',
        pageBuilder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          final subscription = data['subscription'];

          return ChargilyInitScreen(
            subscription: subscription,
          );
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.streak.name,
        path: '/streak',
        pageBuilder: (context, state) {
          final data = state.extra! as Map<String, dynamic>;
          final streak = data['streak'];
          final unitId = data['unitId'] as int;

          return StreakScreen(
            streak: streak,
            unitId: unitId,
          );
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
      TayssirCustomGoRoute(
        name: AppRoutes.achievementLog.name,
        path: '/achievement-log',
        pageBuilder: (context, state) {
          return const AchievementLogScreen();
        },
        transitionType: TransitionType.sharedAxis,
        duration: const Duration(milliseconds: 300),
      ),
    ],
  );
});
