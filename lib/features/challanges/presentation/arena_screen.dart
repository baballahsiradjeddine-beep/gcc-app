import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/features/challanges/data/challenge_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'dart:ui';

class ArenaScreen extends HookConsumerWidget {
  final String matchId;
  final int unitId;
  final String courseTitle;

  const ArenaScreen({
    super.key,
    required this.matchId,
    required this.unitId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).value;
    final myUid = user?.id.toString();

    final matchRef = FirebaseDatabase.instance.ref('challenges/matches/$matchId');
    final matchData = useState<Map<dynamic, dynamic>?>(null);
    final isConnected = useState<bool>(true);
    final isSubmitting = useState<bool>(false);
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(seconds: 5)));

    useEffect(() => confettiController.dispose, []);

    useEffect(() {
      final connectedSub = FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
        isConnected.value = event.snapshot.value == true;
      });
      return connectedSub.cancel;
    }, []);

    useEffect(() {
      final statusRef = matchRef.child('players/$myUid/status');
      statusRef.onDisconnect().set('disconnected');
      statusRef.set('playing');

      final sub = matchRef.onValue.listen((event) {
        if (event.snapshot.exists && event.snapshot.value != null) {
          matchData.value = event.snapshot.value as Map<dynamic, dynamic>;
        }
      });

      return () {
        sub.cancel();
        Future.microtask(() async {
          await statusRef.onDisconnect().cancel();
          final snap = await matchRef.get();
          if (snap.exists) {
            final map = snap.value as Map<dynamic, dynamic>;
            if (map['isBotMatch'] == true) {
              await matchRef.remove();
            } else {
              await statusRef.set('disconnected');
              final p = map['players'] as Map<dynamic, dynamic>? ?? {};
              bool allDoneOrGone = true;
              for (var val in p.values) {
                if (val['uid'] != myUid && val['status'] == 'playing') allDoneOrGone = false;
              }
              if (allDoneOrGone) await matchRef.remove();
            }
          }
        });
      };
    }, []);

    if (matchData.value == null || myUid == null) {
      return const Scaffold(backgroundColor: Color(0xFF111827), body: Center(child: CircularProgressIndicator()));
    }

    final data = matchData.value!;
    final players = (data['players'] as Map<dynamic, dynamic>?) ?? {};
    final questions = (data['questions'] as List<dynamic>?) ?? [];
    final currentIndex = (data['currentQuestionIndex'] as int?) ?? 0;

    Map? myInfo, opInfo;
    players.forEach((k, v) => k == myUid ? myInfo = v : opInfo = v);

    if (myInfo == null || opInfo == null) {
      return const Scaffold(body: Center(child: Text('خطأ في تحميل المتنافسين')));
    }

    final isFinished = (questions.isNotEmpty && currentIndex >= questions.length) || data['status'] == 'finished' || opInfo!['status'] == 'disconnected';
    final isWinner = (myInfo!['score'] ?? 0) > (opInfo!['score'] ?? 0);

    useEffect(() {
      if (isFinished && isWinner) confettiController.play();
      return null;
    }, [isFinished]);

    final selectedOption = useState<dynamic>(null);
    final isOptionCorrect = useState<bool?>(null);

    useEffect(() {
      selectedOption.value = null;
      isOptionCorrect.value = null;
      return null;
    }, [currentIndex]);

    void handleAnswer(bool isCorrect, dynamic optionId) async {
      if (selectedOption.value != null) return;
      selectedOption.value = optionId;
      isOptionCorrect.value = isCorrect;
      isCorrect ? HapticFeedback.lightImpact() : HapticFeedback.heavyImpact();

      Future.delayed(const Duration(milliseconds: 1500), () async {
        final snap = await matchRef.child('currentQuestionIndex').get();
        if (snap.value == currentIndex) {
          if (isCorrect) await matchRef.child('players/$myUid/score').set((myInfo!['score'] ?? 0) + 10);
          await matchRef.child('currentQuestionIndex').set(currentIndex + 1);
        }
      });
    }
    void _submitResult(int score, bool winner) async {
      if (isSubmitting.value) return;
      isSubmitting.value = true;
      try {
        await ref
            .read(challengeRepositoryProvider)
            .submitResult(unitId: unitId, isWinner: winner, pointsGained: score);

        await ref.read(userNotifierProvider.notifier).getUser();
        await matchRef.child('status').set('finished');

        if (context.mounted) {
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ أثناء حفظ النتيجة: $e')),
          );
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1120),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B1120), Color(0xFF0F172A)],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildBattleHeader(myInfo!, opInfo!),
                if (!isFinished) _buildTimer(currentIndex, handleAnswer),
                Expanded(
                  child: isFinished
                      ? _buildFinishedState(isWinner, opInfo!['status'] == 'disconnected',
                          myInfo!['score'] ?? 0, ref, matchRef, isSubmitting.value, _submitResult)
                      : _buildQuestionArea(questions[currentIndex], currentIndex, questions.length,
                          handleAnswer, selectedOption.value, isOptionCorrect.value),
                ),
                if (!isFinished) 
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20.h),
                    child: _buildEmojiPicker(matchRef, myUid),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattleHeader(Map myInfo, Map opInfo) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 5.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildPlayerProfile(myInfo, isMe: true)),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      "VS",
                      style: TextStyle(
                        color: const Color(0xFFF43F5E),
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                        fontFamily: 'SomarSans',
                        letterSpacing: 1.5,
                      ),
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 2.seconds),
                  10.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        "${(myInfo['score'] ?? 0) + (opInfo['score'] ?? 0)}", // Just for UI, following exercice.html style
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SomarSans',
                        ),
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.diamond_outlined, // Sketch logo equivalent
                        color: const Color(0xFF00B4D8),
                        size: 20.sp,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: _buildPlayerProfile(opInfo, isMe: false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerProfile(Map? info, {required bool isMe}) {
    final name = info?['name'] ?? 'لاعب';
    final score = info?['score'] ?? 0;
    final pic = info?['avatar'] ?? info?['avatar_url'] ?? '';
    final emoji = info?['emoji'] ?? '';
    final badgeIconUrl = info?['badgeIconUrl'];
    final badgeColorStr = info?['badgeColor'];
    final themeColor = badgeColorStr != null 
        ? Color(int.parse(badgeColorStr.replaceAll('#', '0xFF'))) 
        : (isMe ? const Color(0xFF00B4D8) : const Color(0xFFF43F5E));

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            ShieldBadge(
              userAvatarUrl: pic,
              badgeIconUrl: badgeIconUrl,
              themeColor: themeColor,
              width: 100.w,
              height: 100.w,
              avatarPaddingTop: 22.w,
              avatarSize: 52.w,
            ),
            if (emoji.isNotEmpty)
              Positioned(
                top: -15.h,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 32.sp),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1), duration: 400.ms, curve: Curves.elasticOut)
                    .shake(duration: 500.ms)
                    .then(delay: 1.5.seconds)
                    .fadeOut(duration: 500.ms),
              ),
          ],
        ),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'SomarSans',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "$score",
          style: TextStyle(
            color: themeColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'SomarSans',
          ),
        ),
      ],
    );
  }

  Widget _buildHexagonAvatar(dynamic pic, Color color) {
    return Container(
      width: 70.w,
      height: 75.h,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        shape: const HexagonShapeBorder(),
        shadows: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: const ShapeDecoration(
          color: Color(0xFF1E293B),
          shape: HexagonShapeBorder(),
        ),
        child: ClipPath(
          clipper: _HexagonClipper(),
          child: CachedNetworkImage(
            imageUrl: pic.toString().startsWith('http')
                ? pic.toString()
                : 'https://api.dicebear.com/7.x/avataaars/svg?seed=Felix',
            fit: BoxFit.cover,
            errorWidget: (c, e, s) => const Icon(Icons.person, color: Colors.white10),
          ),
        ),
      ),
    );
  }


  Widget _buildTimer(int index, Function handleAnswer) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            key: ValueKey(index),
            tween: Tween(begin: 1.0, end: 0.0),
            duration: const Duration(seconds: 15),
            onEnd: () => handleAnswer(false, 'timeout'),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white.withOpacity(0.05),
              color: value > 0.4
                  ? const Color(0xFF00C6E0)
                  : (value > 0.2 ? Colors.orange : Colors.red),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          4.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white24, size: 14),
              Text("أسرع! الوقت ينفذ", style: TextStyle(color: Colors.white24, fontSize: 10.sp, fontFamily: 'SomarSans')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionArea(Map q, int current, int total, Function handleAnswer, dynamic selected, bool? isCorrect) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: const Color(0xFF00B4D8), size: 16.sp),
                      4.horizontalSpace,
                      Text(
                        "سؤال ${current + 1} من $total",
                        style: TextStyle(color: const Color(0xFF00B4D8), fontSize: 13.sp, fontWeight: FontWeight.bold, fontFamily: 'SomarSans'),
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    q['question_type'] == 'multiple_choices' ? 'اختر الإجابة الصحيحة' : 'أجب بصحيح أو خطأ',
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w900, fontFamily: 'SomarSans'),
                  ),
                ],
              ),
              Text("🐬", style: TextStyle(fontSize: 35.sp)),
            ],
          ).animate(key: ValueKey('header_$current')).fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutBack),
          
          if (q['question_type'] == 'true_false') ...[
             15.verticalSpace,
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("🐬", style: TextStyle(fontSize: 45.sp)),
                  10.horizontalSpace,
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Text(
                      "قم بالتركيز\nقبل الإختيار",
                      style: TextStyle(color: const Color(0xFFCBD5E1), fontSize: 12.sp, fontWeight: FontWeight.w700, fontFamily: 'SomarSans'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
             ).animate(key: ValueKey('tf_$current')).fadeIn(duration: 400.ms, delay: 100.ms),
          ],
          
          15.verticalSpace,
          Text(
            q['question'] ?? '',
            style: TextStyle(
              color: const Color(0xFFCBD5E1),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'SomarSans',
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ).animate(key: ValueKey('qtext_$current')).fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutBack),
          30.verticalSpace,
          ..._buildOptions(q, handleAnswer, selected, isCorrect),
        ],
      ),
    );
  }

  List<Widget> _buildOptions(Map q, Function handleAnswer, dynamic selected, bool? isCorrect) {
    if (q['question_type'] == 'multiple_choices') {
      return (q['options'] as List).map<Widget>((opt) {
        bool isSelected = selected == opt['id'];
        bool isRightAnswer = isSelected && isCorrect == true;
        bool isWrongAnswer = isSelected && isCorrect == false;
        bool shouldShowGreen = selected != null && opt['is_correct'] == 1;

        return _buildOptionButton(
          opt['text'], isSelected, isRightAnswer, isWrongAnswer, shouldShowGreen, 
          () => handleAnswer(opt['is_correct'] == 1, opt['id'])
        );
      }).toList();
    } else {
      final bool correctIsTrue = (q['correct_answer'] ?? 1) == 1;
      return [
        Row(
          children: [
            _buildTrueFalseOption('صحيح', 'true', selected, isCorrect, correctIsTrue, handleAnswer, const Color(0xFF10B981)),
            15.horizontalSpace,
            _buildTrueFalseOption('خطأ', 'false', selected, isCorrect, !correctIsTrue, handleAnswer, const Color(0xFFF43F5E)),
          ]
        )
      ];
    }
  }

  Widget _buildOptionButton(
      String text, bool isSelected, bool isRightAnswer, bool isWrongAnswer, bool shouldShowGreen, VoidCallback onTap) {
      
    Color borderColor = const Color(0xFF334155);
    Color bgColor = const Color(0xFF1E293B);
    Color textColor = const Color(0xFFE2E8F0);
    
    if (isRightAnswer || shouldShowGreen) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withOpacity(0.1); 
        textColor = const Color(0xFF10B981);
    } else if (isWrongAnswer) {
        borderColor = const Color(0xFFF43F5E);
        bgColor = const Color(0xFFF43F5E).withOpacity(0.1);
        textColor = const Color(0xFFF43F5E);
    } else if (isSelected) {
        borderColor = const Color(0xFF00B4D8);
        bgColor = const Color(0xFF0C4A6E).withOpacity(0.4);
        textColor = const Color(0xFF00B4D8);
    }
    
    Widget indicator;
    if (isRightAnswer || shouldShowGreen) {
       indicator = Container(
         width: 22.w, height: 22.w,
         decoration: BoxDecoration(color: const Color(0xFF10B981), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF10B981), width: 2)),
         child: const Icon(Icons.check, size: 14, color: Colors.white),
       );
    } else if (isWrongAnswer) {
       indicator = Container(
         width: 22.w, height: 22.w,
         decoration: BoxDecoration(color: const Color(0xFFF43F5E), shape: BoxShape.circle, border: Border.all(color: const Color(0xFFF43F5E), width: 2)),
         child: const Icon(Icons.close, size: 14, color: Colors.white),
       );
    } else if (isSelected) {
       indicator = Container(
         width: 22.w, height: 22.w,
         decoration: BoxDecoration(color: const Color(0xFF00B4D8), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00B4D8), width: 2)),
         child: Container(margin: EdgeInsets.all(4.w), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
       );
    } else {
       indicator = Container(
         width: 22.w, height: 22.w,
         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF475569), width: 2)),
       );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 2 : 1),
        boxShadow: [
          if (isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen)
            BoxShadow(color: borderColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 0))
          else
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SomarSans',
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                indicator,
              ],
            ),
          ),
        ),
      ),
    ).animate(target: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02));
  }

  Widget _buildTrueFalseOption(String text, String id, dynamic selected, bool? isCorrect,
      bool isProperAns, Function handleAnswer, Color themeColor) {
    bool isSelected = selected == id;
    bool isRightAnswer = isSelected && isCorrect == true;
    bool isWrongAnswer = isSelected && isCorrect == false;
    bool shouldShowGreen = selected != null && isProperAns;

    Color borderColor = const Color(0xFF334155);
    Color bgColor = const Color(0xFF1E293B);
    Color textColor = const Color(0xFFE2E8F0);
    
    if (isRightAnswer || shouldShowGreen) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withOpacity(0.1); 
        textColor = const Color(0xFF10B981);
    } else if (isWrongAnswer) {
        borderColor = const Color(0xFFF43F5E);
        bgColor = const Color(0xFFF43F5E).withOpacity(0.1);
        textColor = const Color(0xFFF43F5E);
    } else if (isSelected) {
        borderColor = themeColor;
        bgColor = themeColor.withOpacity(0.1);
        textColor = themeColor;
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor, width: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 2 : 1),
          boxShadow: [
            if (isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen)
              BoxShadow(color: borderColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 0))
            else
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => handleAnswer(isProperAns, id),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ),
            ),
          ),
        ),
      ).animate(target: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.03, 1.03)),
    );
  }

  Widget _buildFinishedState(bool winner, bool ranAway, int score, WidgetRef ref,
      DatabaseReference matchRef, bool loading, Function(int, bool) onSubmit) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.network(
          winner || ranAway
              ? 'https://assets10.lottiefiles.com/packages/lf20_myejig9v.json'
              : 'https://assets5.lottiefiles.com/packages/lf20_ghp9v42x.json',
          height: 180.h,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 180.h,
              alignment: Alignment.center,
              child: Icon(
                winner || ranAway ? Icons.emoji_events : Icons.sentiment_very_dissatisfied,
                size: 100.sp,
                color: winner || ranAway ? Colors.amber : Colors.white24,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
          },
        ),
        Text(
            ranAway
                ? "🏆 المنافس انسحب! فوز ساحق!"
                : (winner ? "تهانينا! أنت البطل 🏆" : "حظ ممتع المرة القادمة ⚔️"),
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'SomarSans'),
            textAlign: TextAlign.center),
        30.verticalSpace,
        if (loading)
          const CircularProgressIndicator(color: Colors.pink)
        else
          Container(
            width: double.infinity,
            height: 60.h,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF43F5E)],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(color: const Color(0xFFEC4899).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => onSubmit(score, winner),
                child: Center(
                  child: Text(
                    "حفظ النتيجة والعودة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }



  Widget _buildEmojiPicker(DatabaseReference matchRef, String uid) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 40.w, right: 40.w),
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['😂', '🔥', '💪', '😱', '🥳'].map((e) {
          return InkWell(
            onTap: () {
              matchRef.child('players/$uid/emoji').set(e);
              Future.delayed(const Duration(seconds: 3), () => matchRef.child('players/$uid/emoji').set(''));
            },
            child: Text(e, style: TextStyle(fontSize: 26.sp))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 2.seconds),
          );
        }).toList(),
      ),
    );
  }
}

class HexagonShapeBorder extends ShapeBorder {
  const HexagonShapeBorder();
  @override EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
  @override Path getInnerPath(Rect rect, {TextDirection? textDirection}) => getOuterPath(rect, textDirection: textDirection);
  @override Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.moveTo(rect.center.dx, rect.top);
    path.lineTo(rect.right, rect.top + rect.height * 0.25);
    path.lineTo(rect.right, rect.bottom - rect.height * 0.25);
    path.lineTo(rect.center.dx, rect.bottom);
    path.lineTo(rect.left, rect.bottom - rect.height * 0.25);
    path.lineTo(rect.left, rect.top + rect.height * 0.25);
    path.close();
    return path;
  }
  @override void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
  @override ShapeBorder scale(double t) => this;
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.25);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.75);
    path.lineTo(0, size.height * 0.25);
    path.close();
    return path;
  }
  @override bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
