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
import 'package:tayssir/services/sounds/sound_manager.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
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
    final isSoundOn = ref.watch(isSoundEnabledProvider);

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
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B1120) : Colors.white,
        body: const Center(child: CircularProgressIndicator(color: Color(0xFF00C6E0)))
      );
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
      if (isFinished && isWinner) {
        confettiController.play();
        if (isSoundOn) {
          SoundService.playLevelComplete();
        }
      }
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
      
      if (isSoundOn) {
        if (isCorrect) {
          SoundService.playSuccess();
        } else {
          SoundService.playError();
        }
      }
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

    final isPrivate = data['isPrivate'] ?? false;
    final messagesMap = (data['messages'] as Map<dynamic, dynamic>?) ?? {};
    final messages = messagesMap.values.toList()
      ..sort((a, b) => (a['timestamp'] ?? 0).compareTo(b['timestamp'] ?? 0));

    // Play sound when new message arrives (not from self)
    useEffect(() {
      if (messages.isNotEmpty && messages.last['uid'] != myUid && isSoundOn) {
        SoundService.playChatPop();
      }
      return null;
    }, [messages.length]);

    void _sendMessage(String text) {
      if (text.trim().isEmpty) return;
      if (isSoundOn) SoundService.playClickPremium();
      final msgRef = matchRef.child('messages').push();
      msgRef.set({
        'uid': myUid,
        'name': user?.name ?? 'Guest',
        'text': text,
        'timestamp': ServerValue.timestamp,
      });
      matchRef.child('players/$myUid/lastMessage').set(text);
      Future.delayed(const Duration(seconds: 4), () {
        matchRef.child('players/$myUid/lastMessage').set('');
      });
    }

    void _showChat() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => _ChallengeChatSheet(
          messages: messages,
          myUid: myUid!,
          onSend: _sendMessage,
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B1120) : Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDark ? const Color(0xFF0B1120) : Colors.white,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildBattleHeader(myInfo!, opInfo!, isDark),
                if (!isFinished) _buildTimer(currentIndex, handleAnswer, isDark),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: isFinished
                        ? _buildFinishedState(isWinner, opInfo!['status'] == 'disconnected',
                            myInfo!['score'] ?? 0, ref, matchRef, isSubmitting.value, _submitResult, isDark)
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: _buildQuestionArea(questions[currentIndex], currentIndex, questions.length,
                                handleAnswer, selectedOption.value, isOptionCorrect.value, isDark),
                          ),
                  ),
                ),
                if (!isFinished) 
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.h),
                    child: _buildEmojiPicker(matchRef, myUid, isPrivate, isSoundOn, _showChat, isDark),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBattleHeader(Map myInfo, Map opInfo, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerProfile(myInfo, isDark, isMe: true),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
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
                    "${(myInfo['score'] ?? 0) + (opInfo['score'] ?? 0)}",
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SomarSans',
                    ),
                  ),
                  4.horizontalSpace,
                  const Text("💎", style: TextStyle(fontSize: 18)),
                ],
              ),
            ],
          ),
          _buildPlayerProfile(opInfo, isDark, isMe: false),
        ],
      ),
    );
  }

  Widget _buildPlayerProfile(Map info, bool isDark, {required bool isMe}) {
    final name = info['name'] ?? 'لاعب';
    final score = info['score'] ?? 0;
    final pic = info['avatar'] ?? info['avatar_url'] ?? '';
    final emoji = info['emoji'] ?? '';
    final lastMessage = info['lastMessage'] ?? '';
    final badgeIconUrl = info['badgeIconUrl'];
    final badgeColorStr = info['badgeColor'];
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
              width: 82.w,
              height: 102.h,
              avatarPaddingTop: 26.h,
              avatarSize: 68.sp,
              avatarOffsetX: -1.5.w,
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
            if (lastMessage.isNotEmpty)
              Positioned(
                bottom: -25.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  constraints: BoxConstraints(maxWidth: 100.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Text(
                    lastMessage,
                    style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ).animate().scale(curve: Curves.elasticOut, duration: 500.ms).then(delay: 3.seconds).fadeOut(),
              ),
          ],
        ),
        Text(
          name,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
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


  Widget _buildTimer(int index, Function handleAnswer, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: TweenAnimationBuilder<double>(
        key: ValueKey(index),
        tween: Tween(begin: 1.0, end: 0.0),
        duration: const Duration(seconds: 15),
        onEnd: () => handleAnswer(false, 'timeout'),
        builder: (context, value, _) => Container(
          height: 12.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: value.clamp(0.01, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF00C6E0), 
                            const Color(0xFF1CB0F6),
                            const Color(0xFF00C6E0).withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C6E0).withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Progress Glow
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: (1 - value) * MediaQuery.of(context).size.width,
                    width: 40.w,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionArea(Map q, int current, int total, Function handleAnswer, dynamic selected, bool? isCorrect, bool isDark) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          // Question Header (Matches QuestionTypeWidget)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("✨", style: TextStyle(fontSize: 14)),
                        8.horizontalSpace,
                        Text(
                          "سؤال ${current + 1} من $total",
                          style: TextStyle(
                            color: const Color(0xFF00B4D8),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SomarSans',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    6.verticalSpace,
                    Text(
                      q['question_type'] == 'multiple_choices' ? 'اختر الإجابة الصحيحة' : 'أجب بصحيح أو خطأ',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'SomarSans',
                      ),
                    ),
                  ],
                ),
              ),
              const Text("🐬", style: TextStyle(fontSize: 40)),
            ],
          ).animate(key: ValueKey('header_$current')).fadeIn(duration: 400.ms).slideX(begin: 0.1, duration: 400.ms, curve: Curves.easeOutBack),
          
          24.verticalSpace,
          
          // Question Card (Matches QuestionSection)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B).withOpacity(0.5) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B).withOpacity(0.8) : const Color(0xFFE2E8F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              q['question'] ?? '',
              style: TextStyle(
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                fontSize: 18.sp,
                fontWeight: FontWeight.normal,
                fontFamily: 'SomarSans',
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
          ).animate(key: ValueKey('qcard_$current')).fadeIn(delay: 200.ms).scale(curve: Curves.easeOutBack),
          
          30.verticalSpace,
          
          // Options Area
          ..._buildOptions(q, handleAnswer, selected, isCorrect, isDark),
          
          20.verticalSpace,
        ],
      ),
    );
  }

  List<Widget> _buildOptions(Map q, Function handleAnswer, dynamic selected, bool? isCorrect, bool isDark) {
    if (q['question_type'] == 'multiple_choices') {
      return (q['options'] as List).map<Widget>((opt) {
        bool isSelected = selected == opt['id'];
        bool isRightAnswer = isSelected && isCorrect == true;
        bool isWrongAnswer = isSelected && isCorrect == false;
        bool shouldShowGreen = selected != null && opt['is_correct'] == 1;

        return _buildOptionButton(
          opt['text'], isSelected, isRightAnswer, isWrongAnswer, shouldShowGreen, 
          () => handleAnswer(opt['is_correct'] == 1, opt['id']), isDark
        );
      }).toList();
    } else {
      final bool correctIsTrue = (q['correct_answer'] ?? 1) == 1;
      return [
        Row(
          children: [
            _buildTrueFalseOption('صحيح', 'true', selected, isCorrect, correctIsTrue, handleAnswer, const Color(0xFF10B981), isDark),
            15.horizontalSpace,
            _buildTrueFalseOption('خطأ', 'false', selected, isCorrect, !correctIsTrue, handleAnswer, const Color(0xFFF43F5E), isDark),
          ]
        )
      ];
    }
  }

  Widget _buildOptionButton(
      String text, bool isSelected, bool isRightAnswer, bool isWrongAnswer, bool shouldShowGreen, VoidCallback onTap, bool isDark) {
      
    Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    Color bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color textColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
    
    if (isRightAnswer || shouldShowGreen) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withOpacity(0.12); 
        textColor = const Color(0xFF10B981);
    } else if (isWrongAnswer) {
        borderColor = const Color(0xFFF43F5E);
        bgColor = const Color(0xFFF43F5E).withOpacity(0.12);
        textColor = const Color(0xFFF43F5E);
    } else if (isSelected) {
        borderColor = const Color(0xFF00B4D8);
        bgColor = const Color(0xFF00B4D8).withOpacity(isDark ? 0.15 : 0.08);
        textColor = const Color(0xFF00B4D8);
    }
    
    Widget indicator;
    if (isRightAnswer || shouldShowGreen) {
       indicator = Container(
         width: 22.sp, height: 22.sp,
         decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
         child: Icon(Icons.check, size: 14.sp, color: Colors.white),
       );
    } else if (isWrongAnswer) {
       indicator = Container(
         width: 22.sp, height: 22.sp,
         decoration: const BoxDecoration(color: Color(0xFFF43F5E), shape: BoxShape.circle),
         child: Icon(Icons.close, size: 14.sp, color: Colors.white),
       );
    } else if (isSelected) {
       indicator = Container(
         width: 20.sp, height: 20.sp,
         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF00B4D8), width: 2), color: const Color(0xFF00B4D8)),
         child: Center(child: Container(width: 8.sp, height: 8.sp, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
       );
    } else {
       indicator = Container(
         width: 20.sp, height: 20.sp,
         decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFF475569), width: 2)),
       );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
        gradient: isSelected ? LinearGradient(
          colors: [
            isDark ? const Color(0xFF0C4A6E).withOpacity(0.4) : const Color(0xFFBAE6FD).withOpacity(0.3), 
            isDark ? const Color(0xFF1E293B) : Colors.white
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ) : null,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: borderColor,
          width: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen)
            BoxShadow(color: borderColor.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 4))
          else
            BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                      fontFamily: 'SomarSans',
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                12.horizontalSpace,
                indicator,
              ],
            ),
          ),
        ),
      ),
    ).animate(target: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02));
  }

  Widget _buildTrueFalseOption(String text, String id, dynamic selected, bool? isCorrect,
      bool isProperAns, Function handleAnswer, Color themeColor, bool isDark) {
    bool isSelected = selected == id;
    bool isRightAnswer = isSelected && isCorrect == true;
    bool isWrongAnswer = isSelected && isCorrect == false;
    bool shouldShowGreen = selected != null && isProperAns;

    Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    Color bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color textColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
    
    if (isRightAnswer || shouldShowGreen) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withOpacity(0.12); 
        textColor = const Color(0xFF10B981);
    } else if (isWrongAnswer) {
        borderColor = const Color(0xFFF43F5E);
        bgColor = const Color(0xFFF43F5E).withOpacity(0.12);
        textColor = const Color(0xFFF43F5E);
    } else if (isSelected) {
        borderColor = themeColor;
        bgColor = themeColor.withOpacity(isDark ? 0.15 : 0.08);
        textColor = themeColor;
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? null : (isDark ? const Color(0xFF1E293B) : Colors.white),
          gradient: isSelected ? LinearGradient(
            colors: [
              themeColor.withOpacity(isDark ? 0.2 : 0.1), 
              isDark ? const Color(0xFF1E293B) : Colors.white
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ) : null,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: borderColor,
            width: isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected || isRightAnswer || isWrongAnswer || shouldShowGreen)
              BoxShadow(color: borderColor.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 4))
            else
              BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () => handleAnswer(isProperAns, id),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
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
      DatabaseReference matchRef, bool loading, Function(int, bool) onSubmit, bool isDark) {
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
                color: winner || ranAway ? Colors.amber : (isDark ? Colors.white24 : Colors.black12),
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
          },
        ),
        Text(
            ranAway
                ? "🏆 المنافس انسحب! فوز ساحق!"
                : (winner ? "تهانينا! أنت البطل 🏆" : "حظ ممتع المرة القادمة ⚔️"),
            style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
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



  Widget _buildEmojiPicker(DatabaseReference matchRef, String uid, bool isPrivate, bool isSoundOn, VoidCallback onChat, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, left: 30.w, right: 30.w),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (isPrivate)
            IconButton(
              onPressed: onChat,
              icon: Icon(Icons.chat_bubble_outline, color: isDark ? Colors.white : const Color(0xFF1E293B), size: 22.sp),
              padding: EdgeInsets.zero,
            ),
          if (isPrivate) Container(width: 1, height: 20, color: isDark ? Colors.white10 : Colors.black12),
          ...['😂', '🔥', '💪', '😱', '🥳'].map((e) {
            return InkWell(
              onTap: () {
                if (isSoundOn) SoundService.playClickPremium();
                matchRef.child('players/$uid/emoji').set(e);
                Future.delayed(const Duration(seconds: 3), () => matchRef.child('players/$uid/emoji').set(''));
              },
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(e, style: TextStyle(fontSize: 24.sp))
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 2.seconds),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _ChallengeChatSheet extends HookWidget {
  final List<dynamic> messages;
  final String myUid;
  final Function(String) onSend;

  const _ChallengeChatSheet({required this.messages, required this.myUid, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (scrollController.hasClients) {
           scrollController.jumpTo(scrollController.position.maxScrollExtent);
         }
      });
      return null;
    }, [messages.length]);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 0.7.sh,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          15.verticalSpace,
          Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(10))),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("دردشة الأصدقاء 💬", style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B), fontSize: 18.sp, fontWeight: FontWeight.w900, fontFamily: 'SomarSans')),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final m = messages[i];
                final isMe = m['uid'] == myUid;
                return Align(
                  alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF00B4D8).withOpacity(isDark ? 0.2 : 0.1) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(color: isMe ? const Color(0xFF00B4D8).withOpacity(0.3) : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        if (!isMe) Text(m['name'] ?? '', style: TextStyle(color: const Color(0xFFF43F5E), fontSize: 10.sp, fontWeight: FontWeight.bold)),
                        Text(m['text'] ?? '', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B), fontSize: 13.sp, fontFamily: 'SomarSans')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
                    decoration: InputDecoration(
                      hintText: "اكتب رسالة...",
                      hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26, fontSize: 14.sp),
                      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r), 
                        borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05))
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r), 
                        borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05))
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    ),
                    onSubmitted: (val) {
                      onSend(val);
                      controller.clear();
                    },
                  ),
                ),
                10.horizontalSpace,
                IconButton(
                  onPressed: () {
                    onSend(controller.text);
                    controller.clear();
                  },
                  icon: const Icon(Icons.send_rounded, color: Color(0xFFEC4899)),
                )
              ],
            ),
          ),
        ],
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
