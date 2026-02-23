import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/resources/resources.dart';
import 'package:tayssir/router/routes_service.dart';
import 'router/app_router.dart';

void initImages(context) async {
  await precacheImage(const AssetImage(Images.subBg), context);
}

final waitingUpdateProvider = StateProvider<bool>((ref) {
  return false;
});

class Tayssir extends ConsumerWidget {
  const Tayssir({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    initImages(context);
    final router = ref.watch(appRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (_, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MaterialApp.router(
            routerConfig: router,
            title: 'BAYAN E-LEARNING',
            builder: DevicePreview.appBuilder,
            // builder: (context, child) {
            //   return UpgradeAlert(
            //     navigatorKey: router.routerDelegate.navigatorKey,
            //     showReleaseNotes: false,
            //     showIgnore: false,
            //     onLater: () {
            //       print('later');
            //       // ref.read(waitingUpdateProvider.notifier).state = true;
            //       return false;
            //     },
            //     onUpdate: () {
            //       print('update');
            //       // ref.read(waitingUpdateProvider.notifier).state = true;
            //       return false;
            //     },
            //     upgrader: Upgrader(
            //       countryCode: 'SA',
            //       languageCode: 'ar',
            //       debugDisplayAlways: false,
            //       willDisplayUpgrade: (
            //           {required display, installedVersion, versionInfo}) {
            //         print('willDisplayUpgrade: $display');
            //         // ref.read(waitingUpdateProvider.notifier).state = !display;
            //       },
            //       // willDisplayUpgrade: () {
            //       //   ref.read(waitingUpdateProvider.notifier).state = true;
            //       //   return false;
            //       // },

            //       // debugDisplayAlways: false,
            //       // canDismissDialog: false,
            //       // shouldPopScope: false,
            //       // showIgnore: false,
            //       // showLater: false,
            //       // showIgnoreOption: false,
            //       // dialogStyle: UpgradeDialogStyle.material,
            //       // dialogStyleMaterial: UpgradeDialogStyle.material,
            //       // dialogStyleCupertino: UpgradeDialogStyle.cupertino,
            //     ),
            //     child: child ?? const Text('child'),
            //   );
            // },

            locale: const Locale('ar'),
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                fontFamily: 'SomarSans',
                scaffoldBackgroundColor: Colors.white),
          ),
        );
      },
    );
  }
}
