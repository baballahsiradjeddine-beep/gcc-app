import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/app_buttons/app_button.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/features/challanges/data/matchmaking_service.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/resources/resources.dart';

class MatchmakingScreen extends HookConsumerWidget {
  final int unitId;
  final String courseTitle;
  final String? initialSearchMode;
  final String? invitationCode;

  const MatchmakingScreen({
    super.key,
    required this.unitId,
    required this.courseTitle,
    this.initialSearchMode,
    this.invitationCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusText = useState<String>('');
    final matchId = useState<String?>(null);
    final error = useState<String?>(null);
    final searchMode = useState<String>(initialSearchMode ?? 'initial'); // initial, random, create_private, join_private
    final privateCode = useState<String?>(invitationCode);
    final codeController = useTextEditingController();

    void goToArena(String id) {
       if (!context.mounted) return;
       context.pushReplacementNamed(
          AppRoutes.challengeArena.name,
          extra: {
            'matchId': id,
            'unitId': unitId,
            'courseTitle': courseTitle,
          },
       );
    }

    // Listener for Private match starting (for the creator)
    useEffect(() {
       if (searchMode.value == 'create_private' && privateCode.value != null) {
          final db = FirebaseDatabase.instance.ref();
          // We need matchId to listen. Let's find it.
          db.child('challenges/private_codes/${privateCode.value}').get().then((snap) {
             if (snap.exists) {
                final mid = snap.value as String;
                final sub = db.child('challenges/matches/$mid/status').onValue.listen((event) {
                    if (event.snapshot.value == 'starting') {
                        goToArena(mid);
                    }
                });
                return sub.cancel;
             }
          });
       }
       return null;
    }, [searchMode.value, privateCode.value]);

    Future<void> startRandomSearch() async {
       searchMode.value = 'random';
       statusText.value = 'جاري البحث عن خصم قوي...';
       try {
         final service = ref.read(matchmakingServiceProvider);
         final id = await service.findMatchOrJoinQueue(unitId, courseTitle);
         if (id != null) {
           statusText.value = 'تم العثور على خصم! ⚔️';
           await Future.delayed(const Duration(seconds: 1));
           goToArena(id);
         }
       } catch (e) {
         if (e is DioException && e.response?.data != null) {
            error.value = e.response?.data['message'] ?? 'حدث خطأ في جلب الأسئلة من السيرفر';
         } else {
            error.value = 'حدث خطأ أثناء البحث: $e';
         }
       }
    }

    Future<void> handleCreatePrivate() async {
       searchMode.value = 'create_private';
       try {
          final service = ref.read(matchmakingServiceProvider);
          final code = await service.createPrivateMatch(unitId, courseTitle);
          privateCode.value = code;
       } catch (e) {
          if (e is DioException && e.response?.data != null) {
             error.value = e.response?.data['message'] ?? 'فشل إنشاء الغرفة: خطأ من السيرفر';
          } else {
             error.value = 'خطأ في إنشاء الغرفة: $e';
          }
       }
    }

    Future<void> handleJoinPrivate() async {
       if (codeController.text.length < 4) return;
       try {
          statusText.value = 'جاري الانضمام للغرفة...';
          final service = ref.read(matchmakingServiceProvider);
          final id = await service.joinPrivateMatch(codeController.text);
          if (id != null) {
             goToArena(id);
          }
       } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
       }
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(matchmakingServiceProvider).cancelSearch();
      },
      child: AppScaffold(
        topSafeArea: true,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                SVGs.titoBoarding,
                height: 150.h,
              ),
              30.verticalSpace,
              
              if (error.value != null) ...[
                 Text(error.value!, style: TextStyle(color: Colors.red, fontSize: 16.sp), textAlign: TextAlign.center),
                 20.verticalSpace,
                 SmallButton(text: 'إعادة المحاولة', onPressed: () => context.pop()),
              ]
              else if (searchMode.value == 'initial') ...[
                 Text('جاهز للتحدي؟ 🔥', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
                 10.verticalSpace,
                 Text('اختر طريقة اللعب المفضلة لديك', style: TextStyle(color: Colors.grey[600])),
                 40.verticalSpace,
                 
                 SmallButton(
                   text: '🚀 بحث عشوائي (1 ضد 1)', 
                   width: double.infinity,
                   onPressed: startRandomSearch,
                 ),
                 15.verticalSpace,
                 SmallButton(
                   text: '🤝 تحدي صديق (عبر كود)', 
                   color: Colors.blue,
                   width: double.infinity,
                   onPressed: handleCreatePrivate,
                 ),
                 15.verticalSpace,
                 TextButton(
                   onPressed: () => searchMode.value = 'join_private',
                   child: Text('لديك كود تحدي؟ أدخله هنا', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
                 ),
              ]
              else if (searchMode.value == 'random') ...[
                 const CircularProgressIndicator(color: Colors.pink),
                 20.verticalSpace,
                 Text(statusText.value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              ]
              else if (searchMode.value == 'create_private') ...[
                 if (privateCode.value == null)
                    const CircularProgressIndicator()
               else ...[
                  Text('كود التحدي الخاص بك هو:', style: TextStyle(fontSize: 18.sp)),
                  10.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                    decoration: BoxDecoration(
                       color: Colors.grey[100],
                       borderRadius: BorderRadius.circular(15),
                       border: Border.all(color: Colors.pink.withOpacity(0.3))
                    ),
                    child: Text(
                      privateCode.value!, 
                      style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.bold, letterSpacing: 8, color: Colors.pink)
                    ),
                  ),
                  20.verticalSpace,
                  Text('أرسل هذا الكود لصديقك لينضم إليك!', style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
                  30.verticalSpace,
                  const CircularProgressIndicator(strokeWidth: 2),
                  10.verticalSpace,
                  Text('في انتظار انضمام المنافس...', style: TextStyle(fontStyle: FontStyle.italic)),
               ]
            ]
            else if (searchMode.value == 'join_private') ...[
               Text('أدخل كود التحدي 🔑', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
               20.verticalSpace,
               TextField(
                 controller: codeController,
                 textAlign: TextAlign.center,
                 keyboardType: TextInputType.number,
                 maxLength: 4,
                 style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, letterSpacing: 10),
                 decoration: InputDecoration(
                    hintText: '0000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                 ),
               ),
               20.verticalSpace,
               SmallButton(text: 'انطلاق! ⚔️', width: double.infinity, onPressed: handleJoinPrivate),
               TextButton(onPressed: () => searchMode.value = 'initial', child: Text('تراجع')),
            ]
          ],
        ),
      ),
    ),
    ),
    );
  }
}
