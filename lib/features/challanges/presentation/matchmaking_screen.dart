import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/app_button.dart';
import 'package:tayssir/features/challanges/data/matchmaking_service.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';

class MatchmakingScreen extends HookConsumerWidget {
  final int unitId;
  final String courseTitle;
  final String? initialSearchMode;
  final String? invitationCode;

  const MatchmakingScreen({
    super.key,
    required this.unitId,
    required this.courseTitle,
    this.initialSearchMode,
    this.invitationCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusText = useState<String>('');
    final error = useState<String?>(null);
    final isSoundOn = ref.watch(isSoundEnabledProvider);
    final searchMode = useState<String>(initialSearchMode ?? 'initial'); 
    final privateCode = useState<String?>(invitationCode);
    final codeController = useTextEditingController();

    void goToArena(String id) {
      if (!context.mounted) return;
      context.pushReplacementNamed(
        AppRoutes.challengeArena.name,
        extra: {
          'matchId': id,
          'unitId': unitId,
          'courseTitle': courseTitle,
        },
      );
    }

    useEffect(() {
      if (searchMode.value == 'create_private' && privateCode.value != null) {
        final db = FirebaseDatabase.instance.ref();
        db.child('challenges/private_codes/${privateCode.value}').get().then((snap) {
          if (snap.exists) {
            final mid = snap.value as String;
            final sub = db.child('challenges/matches/$mid/status').onValue.listen((event) {
              if (event.snapshot.value == 'starting') {
                if (isSoundOn) SoundService.playMatchFound();
                goToArena(mid);
              }
            });
            return sub.cancel;
          }
        });
      }
      return null;
    }, [searchMode.value, privateCode.value]);

    Future<void> startRandomSearch() async {
      searchMode.value = 'random';
      statusText.value = 'جاري البحث عن خصم قوي...';
      try {
        final service = ref.read(matchmakingServiceProvider);
        final id = await service.findMatchOrJoinQueue(unitId, courseTitle);
        if (id != null) {
          if (isSoundOn) SoundService.playMatchFound();
          statusText.value = 'تم العثور على خصم! ⚔️';
          await Future.delayed(const Duration(seconds: 1));
          goToArena(id);
        }
      } catch (e) {
        error.value = 'حدث خطأ أثناء البحث: $e';
      }
    }

    Future<void> handleCreatePrivate() async {
      searchMode.value = 'create_private';
      try {
        final service = ref.read(matchmakingServiceProvider);
        final code = await service.createPrivateMatch(unitId, courseTitle);
        privateCode.value = code;
      } catch (e) {
        error.value = 'خطأ في إنشاء الغرفة: $e';
      }
    }

    Future<void> handleJoinPrivate() async {
      if (codeController.text.length < 4) return;
      try {
        statusText.value = 'جاري الانضمام للغرفة...';
        final service = ref.read(matchmakingServiceProvider);
        final id = await service.joinPrivateMatch(codeController.text);
        if (id != null) {
           if (isSoundOn) SoundService.playMatchFound();
           goToArena(id);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        onPopInvoked: (didPop) {
          if (didPop) ref.read(matchmakingServiceProvider).cancelSearch();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF0B1120),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0B1120),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(Icons.arrow_back, color: Colors.white)),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    _buildVisualHeader(),
                    40.verticalSpace,
                    if (error.value != null)
                      _buildErrorState(context, error.value!)
                    else if (searchMode.value == 'initial')
                      _buildInitialState(startRandomSearch, handleCreatePrivate,
                          () => searchMode.value = 'join_private')
                    else if (searchMode.value == 'random')
                      _buildLoadingState(statusText.value)
                    else if (searchMode.value == 'create_private')
                      _buildPrivateCreatedState(privateCode.value)
                    else if (searchMode.value == 'join_private')
                      _buildJoinPrivateState(codeController, handleJoinPrivate,
                          () => searchMode.value = 'initial'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVisualHeader() {
    return Column(
      children: [
        SvgPicture.asset(SVGs.titoBoarding, height: 180.h)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOut),
        25.verticalSpace,
        Text(
          "الاستعداد للمعركة ⚔️",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState(VoidCallback onRandom, VoidCallback onCreate, VoidCallback onJoin) {
    return Column(
      children: [
        Text(
          "اختر كيف تريد مواجهة منافسك اليوم",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 15.sp,
            fontFamily: 'SomarSans',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        40.verticalSpace,
        _buildPremiumMenuButton(
          "بحث عشوائي (1 ضد 1) 🚀",
          [const Color(0xFF1CB0F6), const Color(0xFF00C6E0)],
          onRandom,
        ),
        20.verticalSpace,
        _buildPremiumMenuButton(
          "تحدي صديق مقرب 🤝",
          [const Color(0xFFEC4899), const Color(0xFFF43F5E)],
          onCreate,
        ),
        25.verticalSpace,
        TextButton(
          onPressed: onJoin,
          child: Text(
            "لديك كود تحدي؟ انضم هنا 🔑",
            style: TextStyle(
              color: const Color(0xFF00C6E0),
              fontWeight: FontWeight.w900,
              fontFamily: 'SomarSans',
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPremiumMenuButton(String label, List<Color> gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 62.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Shine effect
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(begin: const Offset(1, 1), end: const Offset(0.98, 0.98), duration: 200.ms, curve: Curves.easeOut);
  }

  Widget _buildLoadingState(String text) {
    return Column(
      children: [
        const CircularProgressIndicator(color: Color(0xFF00C6E0)),
        25.verticalSpace,
        Text(text, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPrivateCreatedState(String? code) {
    return Column(
      children: [
        Text(
          "كود الغرفة الخاص بك 🗝️",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 16.sp,
            fontFamily: 'SomarSans',
            fontWeight: FontWeight.bold,
          ),
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 25.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF00C6E0).withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C6E0).withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: Text(
            code ?? "....",
            style: TextStyle(
              color: const Color(0xFF00C6E0),
              fontSize: 52.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 12,
              fontFamily: 'SomarSans',
            ),
          ),
        ),
        30.verticalSpace,
        Text(
          "أرسل هذا الكود لمنافسك وانتظره هنا...",
          style: TextStyle(
            color: Colors.white38,
            fontStyle: FontStyle.italic,
            fontFamily: 'SomarSans',
            fontSize: 13.sp,
          ),
          textAlign: TextAlign.center,
        ),
        40.verticalSpace,
        const CircularProgressIndicator(strokeWidth: 3, color: Color(0xFFEC4899))
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 2000.ms),
      ],
    );
  }

  Widget _buildJoinPrivateState(TextEditingController controller, VoidCallback onJoin, VoidCallback onBack) {
    return Column(
      children: [
        Text(
          "أدخل كود التحدي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
          ),
        ),
        10.verticalSpace,
        Text(
          "المكون من 4 أرقام",
          style: TextStyle(color: Colors.white38, fontSize: 14.sp, fontFamily: 'Cairo'),
        ),
        30.verticalSpace,
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF00C6E0),
            fontSize: 40.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 15,
            fontFamily: 'SomarSans',
          ),
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: InputDecoration(
            hintText: "0000",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.05)),
            filled: true,
            fillColor: const Color(0xFF1E293B),
            counterText: "",
            contentPadding: EdgeInsets.symmetric(vertical: 20.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Color(0xFF00C6E0), width: 2),
            ),
          ),
        ),
        35.verticalSpace,
        _buildPremiumMenuButton(
          "انطلاق! ⚔️",
          [const Color(0xFF00C6E0), const Color(0xFF1CB0F6)],
          onJoin,
        ),
        20.verticalSpace,
        TextButton(
          onPressed: onBack,
          child: Text(
            "تراجع",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14.sp,
              fontFamily: 'SomarSans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String msg) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 50),
        15.verticalSpace,
        Text(msg, style: const TextStyle(color: Colors.white70, fontFamily: 'SomarSans'), textAlign: TextAlign.center),
        20.verticalSpace,
        SmallButton(text: "العودة", onPressed: () => context.pop()),
      ],
    );
  }
}

