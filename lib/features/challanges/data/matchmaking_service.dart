import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tayssir/providers/user/user_notifier.dart';

import 'challenge_repository.dart';

final matchmakingServiceProvider = Provider<MatchmakingService>((ref) {
  return MatchmakingService(ref);
});

class MatchmakingService {
  final Ref _ref;
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  MatchmakingService(this._ref);

  Future<String?> findMatchOrJoinQueue(int unitId, String courseTitle) async {
    final user = _ref.read(userNotifierProvider).value;
    if (user == null) throw Exception('User not logged in');

    final String myUid = user.id.toString();
    final String queuePath = 'challenges/queue/$unitId';
    
    // Check if there's someone in queue
    final snapshot = await _db.child(queuePath).orderByKey().limitToFirst(1).get();
    
    if (snapshot.exists && snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;
      final opponentKey = map.keys.first as String;
      final opponentData = map[opponentKey] as Map<dynamic, dynamic>;
      
      if (opponentData['uid'] != myUid) {
        // Found opponent, remove them from queue and create a match
        await _db.child(queuePath).child(opponentKey).remove();
        
        // Generate match ID
        final matchId = _db.child('challenges/matches').push().key!;
        
        // Fetch questions from backend
        final challengeRepo = _ref.read(challengeRepositoryProvider);
        final questionsData = await challengeRepo.getQuestions(unitId);
        final questionsList = questionsData['questions'] as List<dynamic>;
        
        // Create Match in Firebase
        await _db.child('challenges/matches/$matchId').set({
          'status': 'starting',
          'courseTitle': courseTitle,
          'unitId': unitId,
          'players': {
            myUid: {
              'uid': myUid,
              'name': user.name,
              'avatar': user.completeProfilePic,
              'score': 0,
              'status': 'ready',
              'emoji': '',
            },
            opponentData['uid']: {
              'uid': opponentData['uid'],
              'name': opponentData['name'],
              'avatar': opponentData['avatar'],
              'score': 0,
              'status': 'ready',
              'emoji': '',
            },
          },
          'questions': questionsList,
          'currentQuestionIndex': 0,
          'createdAt': ServerValue.timestamp,
        });

        // Notify opponent that match is found (we can write to a specific user node or they can listen to their queue node)
        // A better way is opponent listens to their queue node `challenges/queue/$unitId/$opponentKey/matchId`
        await _db.child('challenges/queue_responses/$opponentKey').set({
          'matchId': matchId,
        });
        
        return matchId;
      }
    }

    // No opponent found, join queue
    final myQueueRef = _db.child(queuePath).push();
    await myQueueRef.set({
      'uid': myUid,
      'name': user.name,
      'avatar': user.completeProfilePic ?? '',
      'joinedAt': ServerValue.timestamp,
    });

    // Wait for match or timeout (Ghost mode after 10-15s)
    final completer = Completer<String?>();
    final responseRef = _db.child('challenges/queue_responses/${myQueueRef.key}');
    
    StreamSubscription? sub;
    sub = responseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        if (data['matchId'] != null) {
          sub?.cancel();
          responseRef.remove();
          completer.complete(data['matchId'] as String);
        }
      }
    });

    // Timeout for Bot Match (10 seconds)
    Future.delayed(const Duration(seconds: 10), () async {
      if (!completer.isCompleted) {
        sub?.cancel();
        myQueueRef.remove();
        
        try {
          final botMatchId = await _createBotMatch(unitId, courseTitle, myUid, user.name, user.completeProfilePic);
          completer.complete(botMatchId);
        } catch (e) {
          completer.completeError(e);
        }
      }
    });

    return completer.future;
  }

  Future<String> _createBotMatch(int unitId, String courseTitle, String myUid, String? myName, String? myAvatar) async {
    final matchId = _db.child('challenges/matches').push().key!;
    final challengeRepo = _ref.read(challengeRepositoryProvider);
    
    Map<String, dynamic> questionsData;
    try {
      questionsData = await challengeRepo.getQuestions(unitId);
    } catch (e) {
      // Fallback or handle error (e.g. production API not deployed yet)
      questionsData = {
        'questions': [
          {
            'id': 1,
            'question': 'أين تقع عاصمة الجزائر؟',
            'question_type': 'multiple_choices',
            'options': [
               {'id': 1, 'text': 'وهران', 'is_correct': 0},
               {'id': 2, 'text': 'الجزائر العاصمة', 'is_correct': 1},
               {'id': 3, 'text': 'قسنطينة', 'is_correct': 0},
               {'id': 4, 'text': 'عنابة', 'is_correct': 0},
            ]
          },
          {
            'id': 2,
            'question': 'هل 1 + 1 = 2؟',
            'question_type': 'true_or_false',
            'correct_answer': 1,
          }
        ]
      };
    }
    
    final questionsList = questionsData['questions'] as List<dynamic>;
    
    final botNames = ['Tito Bot 🐧', 'Ahmed 🤓', 'Sara 📚', 'Amine ⭐'];
    final botName = botNames[Random().nextInt(botNames.length)];

    await _db.child('challenges/matches/$matchId').set({
      'status': 'starting',
      'courseTitle': courseTitle,
      'unitId': unitId,
      'isBotMatch': true,
      'players': {
        myUid: {
          'uid': myUid,
          'name': myName ?? 'Guest',
          'avatar': myAvatar ?? '',
          'score': 0,
          'status': 'ready',
          'emoji': '',
        },
        'bot_123': {
          'uid': 'bot_123',
          'name': botName,
          'avatar': '',
          'score': 0,
          'status': 'ready',
          'emoji': '',
        },
      },
      'questions': questionsList,
      'currentQuestionIndex': 0,
      'createdAt': ServerValue.timestamp,
    });
    return matchId;
  }
}
