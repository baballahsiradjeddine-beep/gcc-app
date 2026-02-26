import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/app_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/features/challanges/data/challenge_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';

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

    // Game state tracking
    final matchRef = FirebaseDatabase.instance.ref('challenges/matches/$matchId');
    final matchData = useState<Map<dynamic, dynamic>?>(null);
    final myEmoji = useState<String>('');
    final opponentEmoji = useState<String>('');
    final isConnected = useState<bool>(true);
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(seconds: 5)));

    useEffect(() => confettiController.dispose, []);

    // Network & disconnect listener
    useEffect(() {
      final connectedSub = FirebaseDatabase.instance.ref('.info/connected').onValue.listen((event) {
        isConnected.value = event.snapshot.value == true;
      });
      return connectedSub.cancel;
    }, []);

    // Stream for match updates
    useEffect(() {
      final statusRef = matchRef.child('players/$myUid/status');
      statusRef.onDisconnect().set('disconnected');
      statusRef.set('playing');

      final sub = matchRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          matchData.value = data;
        }
      });

      return () {
         sub.cancel();
         
         Future.microtask(() async {
            // First cancel the onDisconnect for status to not overwrite our intentional operations
            await statusRef.onDisconnect().cancel();
            
            final snap = await matchRef.get();
            if (snap.exists) {
                final map = snap.value as Map<dynamic, dynamic>;
                final isBot = map['isBotMatch'] == true;
                
                if (isBot) {
                   // Clean up bot match immediately on unmount
                   await matchRef.onDisconnect().cancel();
                   await matchRef.remove();
                } else {
                   // Tell opponent we left
                   await statusRef.set('disconnected');
                   
                   // Check if we are the last one out
                   final p = map['players'] as Map<dynamic, dynamic>? ?? {};
                   bool allDoneOrGone = true;
                   for (var val in p.values) {
                      if (val['uid'] != myUid && val['status'] == 'playing') {
                          allDoneOrGone = false;
                      }
                   }
                   if (allDoneOrGone) {
                       await matchRef.remove();
                   }
                }
            }
         });
      };
    }, []);

    if (matchData.value == null || myUid == null) {
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = matchData.value!;
    final players = data['players'] as Map<dynamic, dynamic>;
    final questions = data['questions'] as List<dynamic>;
    final currentIndex = data['currentQuestionIndex'] as int;

    // Identify Opponent and Me
    Map<dynamic, dynamic>? myData;
    Map<dynamic, dynamic>? opponentData;
    
    players.forEach((key, value) {
      if (key == myUid) {
        myData = value;
      } else {
        opponentData = value;
      }
    });

    if (myData == null || opponentData == null) {
      return const AppScaffold(
        body: Center(child: Text('خطأ في تحميل المتنافسين')),
      );
    }

    final isBotMatch = data['isBotMatch'] == true;
    final currentQuestion = currentIndex < questions.length ? questions[currentIndex] : null;

    final opponentStatus = opponentData!['status'];
    final isOpponentDisconnected = opponentStatus == 'disconnected';

    // Check if finished
    final isFinished = currentIndex >= questions.length || data['status'] == 'finished' || isOpponentDisconnected;
    final isWinner = (myData!['score'] ?? 0) > (opponentData!['score'] ?? 0);

    useEffect(() {
       if (isFinished && isWinner) {
          confettiController.play();
       }
       return null;
    }, [isFinished]);

    // Simulated Bot logic hook (only runs if it's a bot match and not finished)
    useEffect(() {
      if (isBotMatch && !isFinished && currentQuestion != null) {
        // Evaluate bot answer delay
        final delay = 3 + ((currentQuestion['question']?.toString().length ?? 20) % 5).toInt();
        final botTimer = Future.delayed(Duration(seconds: delay), () {
          // Check if question index didn't change while waiting
          matchRef.child('currentQuestionIndex').get().then((snap) {
            if (snap.value == currentIndex) {
              // Bot answers correctly 70% of the time
              final isCorrect = (DateTime.now().millisecond % 10) < 7;
              if (isCorrect) {
                 final newScore = (opponentData!['score'] ?? 0) + 10;
                 matchRef.child('players/${opponentData!['uid']}/score').set(newScore);
                 // Move to next question
                 matchRef.child('currentQuestionIndex').set(currentIndex + 1);
              }
            }
          });
        });
        return () => botTimer.ignore();
      }
      return null;
    }, [currentIndex]);


    final selectedOption = useState<dynamic>(null);
    final isOptionCorrect = useState<bool?>(null);

    // Reset state when next question appears
    useEffect(() {
       selectedOption.value = null;
       isOptionCorrect.value = null;
       return null;
    }, [currentIndex]);

    void handleAnswer(bool isCorrect, dynamic optionId) async {
       if (selectedOption.value != null) return;
       
       selectedOption.value = optionId;
       isOptionCorrect.value = isCorrect;
       
       // Haptic and Sound Feedback
       if (isCorrect) {
          HapticFeedback.lightImpact(); // Winner tap
       } else {
          HapticFeedback.heavyImpact(); // Wrong buzz
       }

       // Visual delay so player sees where they were wrong
       Future.delayed(const Duration(milliseconds: 1500), () async {
          final snap = await matchRef.child('currentQuestionIndex').get();
          if (snap.value == currentIndex) {
             if (isCorrect) {
                final newScore = (myData!['score'] ?? 0) + 10;
                await matchRef.child('players/$myUid/score').set(newScore);
             }
             await matchRef.child('currentQuestionIndex').set(currentIndex + 1);
          }
       });
    }

    void handleSendEmoji(String emoji) async {
       await matchRef.child('players/$myUid/emoji').set(emoji);
       // hide emoji after 3 seconds
       Future.delayed(const Duration(seconds: 3), () async {
          final snap = await matchRef.child('players/$myUid/emoji').get();
          if (snap.value == emoji) {
            await matchRef.child('players/$myUid/emoji').set('');
          }
       });
       if (context.mounted) {
         context.pop();
       }
    }

    void showChatSheet() {
      final emojis = ['😂', '😢', '😡', '👏', '🔥', '👍', '👎', '🤯'];
      showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: emojis.map((e) => GestureDetector(
              onTap: () => handleSendEmoji(e),
              child: Text(e, style: TextStyle(fontSize: 40.sp)),
            )).toList(),
          ),
        ),
      );
    }

    void handleSubmitFinalResult() async {
      try {
        final currentMatchData = matchData.value;
        if (currentMatchData == null) return;
        
        final players = currentMatchData['players'] as Map<dynamic, dynamic>;
        final myInfo = players[myUid] as Map<dynamic, dynamic>?;
        final opInfo = players.entries.firstWhere((e) => e.key != myUid).value as Map<dynamic, dynamic>?;

        final myScore = matchData.value!['players'][myUid]['score'] ?? 0;
        final opScore = opInfo?['score'] ?? 0;
        final isWinner = myScore > opScore;
        
        debugPrint('--- SUBMITTING CHALLENGE RESULT ---');
        debugPrint('UnitId: $unitId, IsWinner: $isWinner, Points: $myScore');
        
        final challengeRepo = ref.read(challengeRepositoryProvider);
        final result = await challengeRepo.submitResult(
          unitId: unitId,
          isWinner: isWinner,
          pointsGained: myScore,
        );
        
        debugPrint('Challenge submission response: $result');

        // FORCE REFRESH USER DATA to see updated points
        ref.invalidate(userNotifierProvider);

        matchRef.child('status').set('finished');
        if (context.mounted) {
           context.pop();
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('انتهى التحدي! نتيجة: $myScore')));
        }
      } catch (e) {
        debugPrint('Error submitting result: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في حفظ النتيجة: $e')));
      }
    }


    Future<bool> showExitConfirmDialog() async {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('هل أنت متأكد من الخروج؟ 🏃‍♂️', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          content: Text('أكمل المنافسة يا بطل! لم يتبقَ الكثير، لا تدع خصمك يسرق النقاط مجاناً! 😡', style: TextStyle(fontSize: 16.sp)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
             TextButton(
               onPressed: () => Navigator.of(context).pop(false), 
               child: Text('أتراجع 💪', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp))
             ),
             TextButton(
               onPressed: () => Navigator.of(context).pop(true), 
               child: Text('خروج وإنسحاب', style: TextStyle(color: Colors.red, fontSize: 14.sp))
             ),
          ]
        ),
      ) ?? false;
    }

    return PopScope(
      canPop: isFinished,
      onPopInvoked: (didPop) async {
         if (didPop) return;
         final shouldExit = await showExitConfirmDialog();
         if (shouldExit && context.mounted) {
             context.pop();
         }
      },
      child: AppScaffold(
        topSafeArea: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.pink, Colors.blue, Colors.green, Colors.yellow, Colors.orange],
            ),
            Positioned.fill(
              child: Column(
                children: [
          // Connection Warning Header
          if (!isConnected.value)
             Container(
               width: double.infinity,
               color: Colors.orange,
               padding: EdgeInsets.symmetric(vertical: 6.h),
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                     8.horizontalSpace,
                     Text('هنالك ضعف في الاتصال، جاري المحاولة...', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ]
               )
             ),
             
          // Header / Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Me
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                         radius: 30,
                         backgroundImage: CachedNetworkImageProvider(myData!['avatar'] ?? ''),
                         onBackgroundImageError: (_, __) => const Icon(Icons.person),
                      ),
                      if (myData!['emoji'] != null && myData!['emoji'].toString().isNotEmpty)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Text(myData!['emoji'], style: TextStyle(fontSize: 20.sp)),
                          ),
                        ),
                    ],
                  ),
                  Text(myData!['name'] ?? 'أنا', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text(myData!['score'].toString(), style: TextStyle(color: Colors.green, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              // VS
              Text('VS', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.pink)),
              // Opponent
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                       CircleAvatar(
                         radius: 30,
                         backgroundColor: Colors.blueAccent,
                         backgroundImage: opponentData!['avatar'] != null && opponentData!['avatar'].isNotEmpty 
                                          ? CachedNetworkImageProvider(opponentData!['avatar']) 
                                          : null,
                         child: (opponentData!['avatar'] == null || opponentData!['avatar'].isEmpty) ? const Icon(Icons.android, color: Colors.white) : null,
                      ),
                      if (opponentData!['emoji'] != null && opponentData!['emoji'].toString().isNotEmpty)
                        Positioned(
                          top: -10,
                          left: -10,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: Text(opponentData!['emoji'], style: TextStyle(fontSize: 20.sp)),
                          ),
                        ),
                    ],
                  ),
                  Text(opponentData!['name'] ?? 'الخصم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text(opponentData!['score'].toString(), style: TextStyle(color: Colors.red, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          
          20.verticalSpace,
          const Divider(),
          if (!isFinished)
             TweenAnimationBuilder<double>(
               key: ValueKey(currentIndex),
               tween: Tween<double>(begin: 1.0, end: 0.0),
               duration: const Duration(seconds: 15),
               onEnd: () {
                  if (selectedOption.value == null && !isFinished) {
                      handleAnswer(false, 'timeout'); // Time is up!
                  }
               },
               builder: (context, value, _) {
                  return LinearProgressIndicator(
                     value: value,
                     backgroundColor: Colors.grey[200],
                     color: value > 0.3 ? Colors.green : Colors.red,
                     minHeight: 8.h,
                  );
               },
             ),
          15.verticalSpace,

          // Main Play Area
          Expanded(
            child: isFinished
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isWinner || isOpponentDisconnected)
                       Lottie.network(
                         'https://fonts.gstatic.com/s/i/short-term/release/googlesymbols/celebration/default/24px.svg', // Fallback or use a valid lottie
                         width: 150.w,
                         height: 150.h,
                         errorBuilder: (context, error, stackTrace) => Icon(Icons.emoji_events, size: 100.sp, color: Colors.amber),
                       ),
                    Text(
                      isOpponentDisconnected 
                        ? '🏆 المنافس هرب ولم يستطع مقاومتك! هههه 😂'
                        : (isWinner ? '🏆 لقد فزت!' : '😔 حظ أوفر المرة القادمة'),
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: isOpponentDisconnected ? Colors.orange : (isWinner ? Colors.green : Colors.black)),
                      textAlign: TextAlign.center,
                    ),
                    20.verticalSpace,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      onPressed: handleSubmitFinalResult,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                        child: Text('العودة وحفظ النتيجة', style: TextStyle(color: Colors.white, fontSize: 18.sp)),
                      ),
                    ),
                  ],
              )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('السؤال ${currentIndex + 1} / ${questions.length}', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                    20.verticalSpace,
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10)]
                      ),
                      child: Text(
                        currentQuestion?['question'] ?? 'جاري التحميل...',
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    40.verticalSpace,
                    // Answer Options or True/False
                    if (currentQuestion?['question_type'] == 'multiple_choices') ...[
                      ...(currentQuestion?['options'] ?? []).map<Widget>((opt) {
                         Color? btnColor;
                         // Logic for Coloring Buttons after Answer Selection
                         if (selectedOption.value == opt['id']) {
                             btnColor = isOptionCorrect.value == true ? Colors.green : Colors.red;
                         } else if (selectedOption.value != null && opt['is_correct'] == 1) {
                             btnColor = Colors.green; // Highlight the real correct answer
                         } else if (selectedOption.value != null) {
                             btnColor = Colors.grey; 
                         }

                         return Padding(
                           padding: const EdgeInsets.only(bottom: 15),
                           child: btnColor == null ? SmallButton(
                             text: opt['text'],
                             width: double.infinity,
                             height: 50.h,
                             onPressed: () => handleAnswer(opt['is_correct'] == 1, opt['id']),
                           ) : SmallButton(
                             text: opt['text'],
                             width: double.infinity,
                             height: 50.h,
                             color: btnColor,
                             onPressed: () => handleAnswer(opt['is_correct'] == 1, opt['id']),
                           ),
                         );
                      }).toList(),
                    ] else if (currentQuestion?['question_type'] == 'true_or_false') ...[
                       Builder(builder: (context) {
                         final isCorrectTrue = (currentQuestion!['correct_answer'] ?? 1) == 1;
                         Color trueColor = Colors.green;
                         if (selectedOption.value == 'true') {
                             trueColor = isOptionCorrect.value == true ? Colors.green : Colors.red;
                         } else if (selectedOption.value != null && isCorrectTrue) {
                             trueColor = Colors.green;
                         } else if (selectedOption.value != null) {
                             trueColor = Colors.grey;
                         }
                         
                         Color falseColor = Colors.red;
                         if (selectedOption.value == 'false') {
                             falseColor = isOptionCorrect.value == true ? Colors.green : Colors.red;
                         } else if (selectedOption.value != null && !isCorrectTrue) {
                             falseColor = Colors.green;
                         } else if (selectedOption.value != null) {
                             falseColor = Colors.grey;
                         }

                         return Column(children: [
                            SmallButton(text: 'صحيح', color: trueColor, width: double.infinity, height: 60.h, onPressed: () => handleAnswer(isCorrectTrue, 'true')),
                            15.verticalSpace,
                            SmallButton(text: 'خطأ', color: falseColor, width: double.infinity, height: 60.h, onPressed: () => handleAnswer(!isCorrectTrue, 'false')),
                         ]);
                       }),
                    ] else ...[
                       const Text('نوع سؤال غير مدعوم في المعركة', style: TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              ),
            if (!isFinished)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Colors.amber, size: 40),
                  onPressed: showChatSheet,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
