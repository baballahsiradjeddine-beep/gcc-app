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
  DatabaseReference? _currentQueueRef;
  StreamSubscription? _queueSub;
  Timer? _botTimer;

  MatchmakingService(this._ref);

  Future<void> cancelSearch() async {
    _botTimer?.cancel();
    _botTimer = null;
    _queueSub?.cancel();
    _queueSub = null;
    
    if (_currentQueueRef != null) {
      await _currentQueueRef!.onDisconnect().cancel();
      await _currentQueueRef!.remove();
      _currentQueueRef = null;
    }
  }

  // Generate a random 4-digit code
  String _generateCode() {
    final rnd = Random();
    return (rnd.nextInt(9000) + 1000).toString();
  }

  Future<String> createPrivateMatch(int unitId, String courseTitle) async {
     final user = _ref.read(userNotifierProvider).value;
     if (user == null) throw Exception('User not logged in');
     final String myUid = user.id.toString();

     final code = _generateCode();
     final matchRef = _db.child('challenges/matches').push();
     final matchId = matchRef.key!;

     final challengeRepo = _ref.read(challengeRepositoryProvider);
     final questionsData = await challengeRepo.getQuestions(unitId);
     final questionsList = questionsData['questions'] as List<dynamic>;

     await matchRef.set({
        'status': 'waiting_for_opponent',
        'courseTitle': courseTitle,
        'unitId': unitId,
        'isPrivate': true,
        'inviteCode': code,
        'players': {
          myUid: {
            'uid': myUid,
            'name': user.name,
            'avatar': user.completeProfilePic,
            'score': 0,
            'status': 'ready',
            'emoji': '',
          },
        },
        'questions': questionsList,
        'currentQuestionIndex': 0,
        'createdAt': ServerValue.timestamp,
     });

     // Map code to matchId for quick lookup
     await _db.child('challenges/private_codes/$code').set(matchId);
     // Clean up if creator disconnects before anyone joins
     await _db.child('challenges/private_codes/$code').onDisconnect().remove();
     await matchRef.onDisconnect().remove();

     return code;
  }

  Future<String?> joinPrivateMatch(String code) async {
     final user = _ref.read(userNotifierProvider).value;
     if (user == null) throw Exception('User not logged in');
     final String myUid = user.id.toString();

     final codeSnap = await _db.child('challenges/private_codes/$code').get();
     if (!codeSnap.exists) {
        throw Exception('الكود غير صحيح أو انتهت صلاحيته');
     }

     final matchId = codeSnap.value as String;
     final matchRef = _db.child('challenges/matches/$matchId');
     final matchSnap = await matchRef.get();

     if (!matchSnap.exists) {
        throw Exception('المباراة لم تعد موجودة');
     }

     final data = matchSnap.value as Map<dynamic, dynamic>;
     if (data['players'].length >= 2) {
        throw Exception('هذه الغرفة مكتملة بالفعل');
     }

     // Join match
     await matchRef.child('players/$myUid').set({
        'uid': myUid,
        'name': user.name,
        'avatar': user.completeProfilePic,
        'score': 0,
        'status': 'ready',
        'emoji': '',
     });

     await matchRef.update({
        'status': 'starting',
     });

     // Remove the code since match started
     await _db.child('challenges/private_codes/$code').remove();
     await matchRef.onDisconnect().cancel(); // Don't remove anymore, match is live

     return matchId;
  }

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
    _currentQueueRef = myQueueRef;
    
    // Immediately tell Firebase to remove me if network drops
    await myQueueRef.onDisconnect().remove();

    await myQueueRef.set({
      'uid': myUid,
      'name': user.name,
      'avatar': user.completeProfilePic ?? '',
      'joinedAt': ServerValue.timestamp,
    });

    // Wait for match or timeout (Ghost mode after 10-15s)
    final completer = Completer<String?>();
    final responseRef = _db.child('challenges/queue_responses/${myQueueRef.key}');
    
    _queueSub = responseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        if (data['matchId'] != null) {
          _queueSub?.cancel();
          responseRef.remove();
          completer.complete(data['matchId'] as String);
        }
      }
    });

    // Timeout for Bot Match (10 seconds)
    _botTimer = Timer(const Duration(seconds: 10), () async {
      if (!completer.isCompleted) {
        _queueSub?.cancel();
        _currentQueueRef?.onDisconnect().cancel();
        myQueueRef.remove();
        _currentQueueRef = null;
        
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
    final matchRef = _db.child('challenges/matches').push();
    final matchId = matchRef.key!;
    final challengeRepo = _ref.read(challengeRepositoryProvider);
    
    // Safety net: if app crashes during bot match, completely wipe the match!
    await matchRef.onDisconnect().remove();

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

    await matchRef.set({
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
    }).timeout(const Duration(seconds: 3), onTimeout: () {
      throw Exception('Firebase Realtime Database is not enabled or missing from config.');
    });
    return matchId;
  }
}
