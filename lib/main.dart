import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:tayssir/environment_config.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/utils/svg_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toastification/toastification.dart';

import 'firebase_options.dart';
import 'app.dart';
import 'package:tayssir/services/fcm_service.dart';

initBox() async {
  await GetSecureStorage.init(password: EnvironmentConfig.boxPassword);
}

loadEnv() async {}

preserveSvgCache() async {
  await SvgUtils.precacheSvgPictures([
    SVGs.comingSoon,
    SVGs.tito,
  ]);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FCMService.initialize();
  await initBox();
  await preserveSvgCache();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  TeXRenderingServer.multiTeXView = true;

  await TeXRenderingServer.start();

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(settings: const TalkerRiverpodLoggerSettings()),
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) =>
            const ToastificationWrapper(child: Tayssir()), // Wrap your appx
      ),
    ),
  );
}


// Intro(
//   /// Padding of the highlighted area and the widget
//   padding: const EdgeInsets.all(8),

//   /// Border radius of the highlighted area
//   borderRadius: const BorderRadius.all(Radius.circular(4)),

//   /// The mask color of step page
//   maskColor: const Color.fromRGBO(0, 0, 0, .6),

//   /// Toggle animation
//   noAnimation: false,

//   /// Toggle whether the mask can be closed
//   maskClosable: false,

//   /// Build custom button
//   buttonBuilder: (order) {
//     return IntroButtonConfig(
//       text: order == 3 ? 'Custom Button Text' : 'Next',
//       height: order == 3 ? 48 : null,
//       fontSize: order == 3 ? 24 : null,
//       style: order == 3
//         ? OutlinedButton.styleFrom(
//             backgroundColor: Colors.red,
//         )
//         : null,
//     );
//   },

//   /// High-level widget
//   child: const Tayssir(),
// )