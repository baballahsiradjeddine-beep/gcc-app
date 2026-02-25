import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/features/challanges/data/matchmaking_service.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/resources.dart';

class MatchmakingScreen extends HookConsumerWidget {
  final int unitId;
  final String courseTitle;

  const MatchmakingScreen({
    super.key,
    required this.unitId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusText = useState<String>('جاري البحث عن خصم قوي...');
    final matchId = useState<String?>(null);
    final error = useState<String?>(null);

    useEffect(() {
      Future.microtask(() async {
        try {
          final service = ref.read(matchmakingServiceProvider);
          final id = await service.findMatchOrJoinQueue(unitId, courseTitle);
          if (id != null) {
            statusText.value = 'تم العثور على خصم! ⚔️';
            matchId.value = id;
            await Future.delayed(const Duration(seconds: 1));
            if (context.mounted) {
              context.pushReplacementNamed(
                AppRoutes.challengeArena.name,
                extra: {
                  'matchId': id,
                  'unitId': unitId,
                  'courseTitle': courseTitle,
                },
              );
            }
          }
        } catch (e) {
          error.value = 'حدث خطأ أثناء البحث عن خصم: \n$e';
        }
      });
      return null;
    }, []);

    return AppScaffold(
      topSafeArea: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SVGs.titoBoarding,
              height: 180.h,
            ),
            40.verticalSpace,
            if (error.value == null) ...[
              const CircularProgressIndicator(color: Colors.pink),
              20.verticalSpace,
              Text(
                statusText.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                error.value!,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('الرجوع'),
              )
            ],
          ],
        ),
      ),
    );
  }
}
