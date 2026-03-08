import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/app_scaffold.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/divisions/divisions.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/utils/extensions/context.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/common/core/custom_app_bar.dart';

import '../../common/forms/drop_down/taysir_drop_down.dart';
import '../../constants/strings.dart';
import '../../providers/user/user_notifier.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/resources.dart';
import '../../services/geo/geo_service.dart';
import '../../services/image_picker/image_picker_service.dart';
import '../auth/presentation/login/custom_text_form_field.dart';
import '../../common/blur_overlay_widget.dart';
import '../../services/actions/snack_bar_service.dart';
import '../../common/push_buttons/rounded_pushable_button.dart';
import '../../services/user/update_user_request.dart';
import 'profile_controller.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);
    final user = userAsync.valueOrNull;

    if (user == null) {
      return const AppScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final nameController = useTextEditingController(text: user.name);
    final ageController = useTextEditingController(text: user.age.toString());
    final phoneController =
        useTextEditingController(text: user.phoneNumber ?? '');
    final wilayas = ref.watch(wilayasProvider).asData?.value ?? [];
    final wilaya = useState<Wilaya>(user.wilaya ?? (wilayas.isNotEmpty ? wilayas.first : Wilaya(number: 0, name: '')));

    final communes = ref
            .watch(communesProvider(
              wilaya.value.number,
            ))
            .asData
            ?.value ??
        [];
    final commune = useState<Commune?>(user.commune);

    final division = useState<DivisionModel?>(user.division);
    final localImage = useState<File?>(null);
    final isShowOverlay = useState(false);

    final currentUserSubscription = user.subscriptions.isNotEmpty ? user.subscriptions.first : null;

    ref.listen<ProfileState>(profileControllerProvider, (prev, next) {
      if (next.isCompleted && !prev!.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          SnackBarService.showSuccessSnackBar('تم تحديث المعلومات بنجاح',
              context: context);
          // context.pop();
        });
      }
    });
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlurOverlayWidget(
      hasTopSafeArea: false,
      onPopScope: isShowOverlay.value
          ? () {
              isShowOverlay.value = false;
              localImage.value = null;
            }
          : null,
      overlayContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (localImage.value != null)
            PushableImageButton(
              image: FileImage(localImage.value!),
              size: 300,
              borderRadius: 50.r,
              topColor: const Color(0xFF00B4D8),
              bottomColor: const Color(0xFF0077B6),
              elevation: 20,
              borderWidth: 10,
              borderColor: const Color(0xFF00B4D8),
              onPressed: () {},
            ),
          20.verticalSpace,
          BigButton(
              text: 'تأكيد الحجم',
              onPressed: () {
                isShowOverlay.value = false;
              }),
        ],
      ),
      showOverlay: isShowOverlay.value,
      child: AppScaffold(
        topSafeArea: true,
        extendBody: true,
        paddingX: 0,
        paddingB: 0,
        bodyBackgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () async => ref.invalidate(userNotifierProvider),
          color: const Color(0xFF00B4D8),
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ],
                stops: [0.0, 0.05], // Fade the top 5%
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // 1. Integrated Header (Back Button + Title) that scrolls away
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Title on the RIGHT (First in RTL)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppStrings.personalInformations,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : AppColors.textBlack,
                                fontFamily: 'SomarSans',
                              ),
                            ),
                          8.horizontalSpace,
                          const Icon(Icons.person_outline_rounded, color: Color(0xFF00B4D8)),
                        ],
                      ),

                      const Spacer(),

                      // Custom Back Button on the LEFT (Second in RTL)
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) context.pop();
                        },
                        icon: Container(
                          width: 44.sp,
                          height: 44.sp,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.black.withOpacity(0.05),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded, // Arabic RTL Back Arrow
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // Badge & Profile Section
                      _buildProfileHeader(context, user, localImage)
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
                      25.verticalSpace,
                      
                      // Stats Cards (Subscription Only)
                      if (user.subscriptions.isNotEmpty) 
                        _buildStatsCards(context, user, currentUserSubscription)
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .scale(begin: const Offset(0.95, 0.95)),
                      
                      30.verticalSpace,

                      // Form Fields
                      _buildFormFields(
                        context, 
                        ref,
                        nameController: nameController,
                        ageController: ageController,
                        phoneController: phoneController,
                        wilaya: wilaya,
                        commune: commune,
                        division: division,
                        wilayas: wilayas,
                        communes: communes,
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05, end: 0),

                      40.verticalSpace,

                      // Save Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: BigButton(
                          text: 'حفظ التغييرات اللآن 🚀',
                          onPressed: ref.watch(profileControllerProvider).isLoading
                              ? null
                              : () {
                                  if (commune.value == null || division.value == null) {
                                    SnackBarService.showErrorSnackBar('يرجى ملء جميع الحقول المطلوبة', context: context);
                                    return;
                                  }
                                  ref
                                      .read(profileControllerProvider.notifier)
                                      .updateUser(UpdateUserRequest(
                                        name: nameController.text,
                                        age: int.tryParse(ageController.text) ?? 18,
                                        phoneNumber: phoneController.text,
                                        image: localImage.value,
                                        wilayaId: wilaya.value.number,
                                        communeId: commune.value!.number,
                                        devisionId: division.value!.id,
                                      ));
                                },
                        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.elasticOut),
                      ),
                      
                      120.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildProfileHeader(BuildContext context, dynamic user, ValueNotifier<File?> localImage) {
    final badgeIconUrl = user.badge?.completeIconUrl;
    final badgeColor = user.badge?.color;
    final themeColor = badgeColor != null
        ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
        : const Color(0xFF00B4D8);

    return Hero(
      tag: 'profile_badge',
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShieldBadge(
            localAvatarImage: localImage.value != null ? FileImage(localImage.value!) : null,
            userAvatarUrl: localImage.value == null ? user.completeProfilePic : null,
            badgeIconUrl: badgeIconUrl,
            themeColor: themeColor,
            width: 140.sp,
            height: 175.sp,
            avatarPaddingTop: 35.sp,
            avatarSize: 120.sp,
          ),
          Positioned(
            bottom: 5.h,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final resultImage = await ImagePickerService.pickImage();
                if (resultImage != null) {
                  localImage.value = resultImage;
                }
              },
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B4D8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                  ],
                ),
                child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20.sp),
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(delay: 2.seconds, duration: 1.seconds),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, dynamic user, dynamic subscription) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      child: _StatCard(
        title: "نوع الاشتراك الحالي",
        value: subscription?.name ?? 'عادي',
        icon: Icons.workspace_premium_rounded,
        gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
        isDark: isDark,
      ),
    );
  }

  Widget _buildFormFields(
    BuildContext context, 
    WidgetRef ref, {
    required TextEditingController nameController,
    required TextEditingController ageController,
    required TextEditingController phoneController,
    required ValueNotifier<Wilaya> wilaya,
    required ValueNotifier<Commune?> commune,
    required ValueNotifier<DivisionModel?> division,
    required List<Wilaya> wilayas,
    required List<Commune> communes,
  }) {
    return Column(
      children: [
        CustomTextFormField(
          controller: nameController,
          labelText: AppStrings.name,
          suffix: const Icon(Icons.person_outline_rounded, color: Color(0xFF00B4D8)),
        ),
        16.verticalSpace,
        CustomTextFormField(
          controller: ageController,
          labelText: "العمر",
          keyboardType: TextInputType.number,
          suffix: const Icon(Icons.cake_outlined, color: Color(0xFF00B4D8)),
        ),
        16.verticalSpace,
        CustomTextFormField(
          controller: phoneController,
          labelText: AppStrings.phoneNumber,
          keyboardType: TextInputType.phone,
          suffix: const Icon(Icons.phone_outlined, color: Color(0xFF00B4D8)),
        ),
        16.verticalSpace,
        TayssirDropDown<Wilaya>(
          selectedItem: wilaya.value,
          items: ref.watch(wilayasProvider).isLoading ? [] : wilayas,
          onChanged: (value) {
            if (value == wilaya.value) return;
            wilaya.value = value!;
            commune.value = null;
          },
          hintText: AppStrings.wilaya,
          iconPath: SVGs.icBuilding,
        ),
        16.verticalSpace,
        TayssirDropDown<Commune>(
          selectedItem: commune.value,
          items: ref.watch(communesProvider(wilaya.value.number)).isLoading ? [] : communes,
          onChanged: (value) {
            commune.value = value;
          },
          hintText: AppStrings.dairaOrCommune,
          iconPath: SVGs.icCommune,
        ),
        16.verticalSpace,
        TayssirDropDown<DivisionModel>(
          selectedItem: division.value,
          items: ref.watch(divisionsProvider).valueOrNull ?? [],
          onChanged: (value) {
            division.value = value;
          },
          hintText: AppStrings.speciality,
          iconPath: SVGs.icSpecitlity,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final bool isDark;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon on the RIGHT (First in RTL)
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, color: Colors.white, size: 22.sp),
          ),
          16.horizontalSpace,
          
          // Texts on the LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.textBlack,
                    fontFamily: 'SomarSans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                2.verticalSpace,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontFamily: 'SomarSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
