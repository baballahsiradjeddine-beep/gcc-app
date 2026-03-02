import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingCompleted = 'onboarding_completed';
const _kOnboardingName = 'onboarding_name';
const _kOnboardingDivision = 'onboarding_division_id';
const _kOnboardingDivisionName = 'onboarding_division_name';
const _kOnboardingTourStep = 'onboarding_tour_step';

/// Tour steps:
/// -1 = not started
///  0 = name + division done → go to real app
///  1 = home tab shown
///  2 = leaderboard tab shown
///  3 = challenges tab shown
///  4 = tools tab shown
///  5 = settings tab shown
///  6 = all tabs done → exercise prompt
///  99 = tour fully complete
class OnboardingState {
  final String? name;
  final int? divisionId;
  final String? divisionName;
  final bool isCompleted;
  final int tourStep;

  const OnboardingState({
    this.name,
    this.divisionId,
    this.divisionName,
    this.isCompleted = false,
    this.tourStep = -1,
  });

  /// True once name + division are set → user can access real app screens
  bool get isReadyForTour =>
      name != null && divisionId != null && tourStep >= 0;

  /// True when the nav tour is fully done
  bool get isTourDone => tourStep >= 6;

  OnboardingState copyWith({
    String? name,
    int? divisionId,
    String? divisionName,
    bool? isCompleted,
    int? tourStep,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      divisionId: divisionId ?? this.divisionId,
      divisionName: divisionName ?? this.divisionName,
      isCompleted: isCompleted ?? this.isCompleted,
      tourStep: tourStep ?? this.tourStep,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kOnboardingCompleted) ?? false;
    final name = prefs.getString(_kOnboardingName);
    final divisionId = prefs.getInt(_kOnboardingDivision);
    final divisionName = prefs.getString(_kOnboardingDivisionName);
    final tourStep = prefs.getInt(_kOnboardingTourStep) ?? -1;
    state = OnboardingState(
      name: name,
      divisionId: divisionId,
      divisionName: divisionName,
      isCompleted: completed,
      tourStep: tourStep,
    );
  }

  Future<void> setName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kOnboardingName, name);
    state = state.copyWith(name: name);
  }

  Future<void> setDivision(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kOnboardingDivision, id);
    await prefs.setString(_kOnboardingDivisionName, name);
    state = state.copyWith(divisionId: id, divisionName: name);
  }

  Future<void> startTour() async {
    final prefs = await SharedPreferences.getInstance();
    // Start tour (step 0 = ready to go to home)
    await prefs.setInt(_kOnboardingTourStep, 0);
    state = state.copyWith(tourStep: 0);
  }

  Future<void> advanceTourStep() async {
    final next = state.tourStep + 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kOnboardingTourStep, next);
    state = state.copyWith(tourStep: next);
  }

  Future<void> setTourStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kOnboardingTourStep, step);
    state = state.copyWith(tourStep: step);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingCompleted, true);
    await prefs.setInt(_kOnboardingTourStep, 99);
    state = state.copyWith(isCompleted: true, tourStep: 99);
  }

  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOnboardingCompleted);
    await prefs.remove(_kOnboardingName);
    await prefs.remove(_kOnboardingDivision);
    await prefs.remove(_kOnboardingDivisionName);
    await prefs.remove(_kOnboardingTourStep);
    state = const OnboardingState();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
  (ref) => OnboardingNotifier(),
);

final isOnboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).isCompleted;
});

final isReadyForTourProvider = Provider<bool>((ref) {
  return ref.watch(onboardingProvider).isReadyForTour;
});
