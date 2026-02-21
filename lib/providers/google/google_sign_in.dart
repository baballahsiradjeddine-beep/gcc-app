import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tayssir/debug/app_logger.dart';

// final googleSingInProvider = Provider<GoogleSignIn>((ref) {
//   // return GoogleSignIn(
//   //     // scopes: [
//   //     //   'email',
//   //     //   'https://www.googleapis.com/auth/contacts.readonly',
//   //     // ],
//   //     // serverClientId:
//   //         // '34775432019-6keeakgsqf091lqarurquh2clajupr29.apps.googleusercontent.com'
//   //     // clientId:
//   //     //     '594498276721-nj874cp1pgnmupr0ae2m5154gajb06r1.apps.googleusercontent.com',
//   //     );
//   final instance = GoogleSignIn.instance;
// });

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

final googleSignInInitProvider = FutureProvider<void>((ref) async {
  final googleSignIn = ref.watch(googleSignInProvider);

  await googleSignIn.initialize(
      // clientId:
      // '1022116659256-uocbgik318fprp46ia796oa0er1j612m.apps.googleusercontent.com',
      // clientId: '1022116659256-pd4r9adh4k78lbpeq8ajfmrtv2cmeu9p.apps.googleusercontent.com',
      clientId:
          '1022116659256-tai28noddt51mq6e9b2sfp97i6uemn2v.apps.googleusercontent.com',
      serverClientId:
          '1022116659256-8mom6d6d8l9ls18j3k63vn2t5smr2hrl.apps.googleusercontent.com');

  googleSignIn.authenticationEvents.listen((event) {
    // Handle authentication events
    // AppLogger.logInfo(
    //     'Google Sign-In event: ${event}, user: ${event.user?.email}');
  }).onError((error) {
    // Handle authentication errors
  });
});
