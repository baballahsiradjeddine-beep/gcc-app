import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';
import 'package:tayssir/features/home/presentation/view_style.dart';
import 'package:tayssir/providers/data/models/material_model.dart';
import 'package:tayssir/providers/data/data_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayssir/features/home/presentation/widgets/course_widget.dart';
import 'package:tayssir/router/app_router.dart';
import 'package:tayssir/common/tito_advice_widget.dart';
import 'package:tayssir/utils/extensions/strings.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tayssir/features/home/presentation/widgets/courses_list_view.dart';

class ChallengesScreen extends HookConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewStyle = useState<ViewStyle>(ViewStyle.list);
    final courses = ref.watch(dataProvider).contentData.modules;

    return AppScaffold(
      topSafeArea: true,
      appBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: const CustomAppBar(),
      ),
      isScroll: true,
      paddingX: 0,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(dataProvider.notifier).refreshData();
        },
        child: Column(
          children: [
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const TitoAdviceWidget(
                text: "اختر مادة للبحث عن خصم مناسب والبدء في التحدي! 🔥",
                isHorizontal: true,
              ),
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ساحة التحديات :',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => context.push('/challanges/social'),
                    icon: Row(
                      children: [
                        Text('الأصدقاء ', style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                        Icon(Icons.people, color: Colors.pink, size: 24.sp),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: courses.isEmpty
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 0.w),
                            height: 110.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: HomeListView<MaterialModel>(
                        items: courses,
                        itemBuilder: (course) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: CardWidget(
                            title: course.title,
                            subTitle: "تحدَّ أصدقاءك في ${course.title}",
                            onPressed: () {
                              final units = ref.read(dataProvider).contentData.units.where((u) => u.materialId == course.id).toList();
                              if (units.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد محاور في هذه المادة للتحدي.')));
                                return;
                              }
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('اختر المحور للتحدي ⚔️', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.pink)),
                                      20.verticalSpace,
                                      ...units.map((u) => Card(
                                        child: ListTile(
                                          title: Text(u.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                          onTap: () {
                                            context.pop(); // close bottom sheet
                                            context.pushNamed(AppRoutes.challengeMatchmaking.name, extra: {
                                              'unitId': u.id,
                                              'courseTitle': course.title,
                                            });
                                          },
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                            imageList: course.imageList,
                            imageGrid: course.imageGrid,
                            startColor: Color(course.gradiantColorStart.toHexColor),
                            endColor: Color(course.gradiantColorEnd.toHexColor),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
