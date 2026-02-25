import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/app_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/features/challanges/data/challenge_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    // Stream for match updates
    useEffect(() {
      final sub = matchRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<dynamic, dynamic>;
          matchData.value = data;
        }
      });
      return sub.cancel;
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

    // Check if finished
    final isFinished = currentIndex >= questions.length || data['status'] == 'finished';

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


    void handleAnswer(bool isCorrect) async {
       if (isCorrect) {
          final newScore = (myData!['score'] ?? 0) + 10;
          await matchRef.child('players/$myUid/score').set(newScore);
          await matchRef.child('currentQuestionIndex').set(currentIndex + 1);
       } else {
          // Penalty or just move info
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('إجابة خاطئة! حاول التركيز')));
       }
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
        final myScore = myData!['score'] ?? 0;
        final opScore = opponentData!['score'] ?? 0;
        final isWinner = myScore > opScore;
        final challengeRepo = ref.read(challengeRepositoryProvider);
        await challengeRepo.submitResult(
          unitId: unitId,
          isWinner: isWinner,
          pointsGained: myScore,
        );
        matchRef.child('status').set('finished');
        if (context.mounted) {
           context.pop();
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('انتهى التحدي! نتيجة: $myScore')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ في حفظ النتيجة: $e')));
      }
    }


    return AppScaffold(
      topSafeArea: true,
      body: Column(
        children: [
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
          20.verticalSpace,

          // Main Play Area
          Expanded(
            child: isFinished
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (myData!['score'] ?? 0) > (opponentData!['score'] ?? 0) ? '🏆 لقد فزت!' : '😔 حظ أوفر المرة القادمة',
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                    ),
                    20.verticalSpace,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
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
                         return Padding(
                           padding: const EdgeInsets.only(bottom: 15),
                           child: SmallButton(
                             text: opt['text'],
                             width: double.infinity,
                             height: 50.h,
                             onPressed: () => handleAnswer(opt['is_correct'] == 1),
                           ),
                         );
                      }).toList(),
                    ] else if (currentQuestion?['question_type'] == 'true_or_false') ...[
                       // Typically option format might be the same or we just check direct boolean logic
                       SmallButton(text: 'صحيح', color: Colors.green, width: double.infinity, height: 60.h, onPressed: () {
                         final isCorrect = (currentQuestion!['correct_answer'] ?? 1) == 1;
                         handleAnswer(isCorrect);
                       }),
                       15.verticalSpace,
                       SmallButton(text: 'خطأ', color: Colors.red, width: double.infinity, height: 60.h, onPressed: () {
                         final isCorrect = (currentQuestion!['correct_answer'] ?? 0) == 0;
                         handleAnswer(isCorrect);
                       }),
                    ] else ...[
                       Text('نوع سؤال غير مدعوم في المعركة', style: TextStyle(color: Colors.red)),
                    ]
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
    );
  }
}
