// final googleServiceProvider = Provider<GoogleService>((ref) {
//   return GoogleService(ref.watch(googleSingInProvider));
// });

// class GoogleService {
//   GoogleService(this._googleSignIn);

//   final GoogleSignIn _googleSignIn;

//   Future<GoogleSignInAccount?> signIn() async {
//     try {
//       return await _googleSignIn.signIn();
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//     } catch (e) {
//       // throw AppException(
//         // type: AppExceptionType.googleSignOut,
//         // error: e,
//         // stackTrace: st,
//       // );
//     }
//   }
// }
