import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/common/core/shield_badge.dart';
import 'package:tayssir/common/app_buttons/big_button.dart';
import 'package:tayssir/common/sliver_scrolling_widget.dart';
import 'package:tayssir/providers/divisions/division_model.dart';
import 'package:tayssir/providers/divisions/divisions.dart';
import 'package:tayssir/providers/user/commune.dart';
import 'package:tayssir/providers/user/wilaya.dart';
import 'package:tayssir/common/push_buttons/rounded_pushable_button.dart';
import 'package:tayssir/services/actions/snack_bar_service.dart';
import 'package:tayssir/services/user/update_user_request.dart';
import 'package:tayssir/utils/extensions/context.dart';

import '../../common/forms/drop_down/taysir_drop_down.dart';
import '../../constants/strings.dart';
import '../../providers/user/user_notifier.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/resources.dart';
import '../../services/geo/geo_service.dart';
import '../../services/image_picker/image_picker_service.dart';
import '../auth/presentation/login/custom_text_form_field.dart';
import '../../common/blur_overlay_widget.dart';
import 'profile_controller.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).requireValue!;

    final nameController = useTextEditingController(text: user.name);
    final ageController = useTextEditingController(text: user.age.toString());
    final phoneController =
        useTextEditingController(text: user.phoneNumber ?? '');
    final wilayas = ref.watch(wilayasProvider).asData?.value ?? [];
    final wilaya = useState<Wilaya>(user.wilaya ?? wilayas.first);

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

    final currentUserSubscription = user.subscriptions.first;

    ref.listen<ProfileState>(profileControllerProvider, (prev, next) {
      if (next.isCompleted && !prev!.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          SnackBarService.showSuccessSnackBar('تم تحديث المعلومات بنجاح',
              context: context);
          // context.pop();
        });
      }
    });
    return BlurOverlayWidget(
      hasTopSafeArea: false,
      onPopScope: isShowOverlay.value
          ? () {
              isShowOverlay.value = false;
              localImage.value = null;
            }
          : null,
      //* TAKE NOTE OF THIS : deperectaed and bad behavior
      //  () {
      //   if (isShowOverlay.value) {
      //     isShowOverlay.value = false;
      //     localImage.value = null;
      //   } else {
      //     if (ref.watch(profileControllerProvider).isCompleted) return;
      //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //       context.pop();
      //     });
      //   }
      // },
      overlayContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (localImage.value != null)
            PushableImageButton(
              image: FileImage(localImage.value!),
              size: 300,
              borderRadius: 50.r,
              topColor: Colors.blue,
              bottomColor: const Color.fromRGBO(25, 118, 210, 1),
              elevation: 20,
              borderWidth: 10,
              borderColor: Colors.blue,
              onPressed: () {},
            ),
          20.verticalSpace,
          BigButton(
              text: 'تأكيد',
              onPressed: () {
                isShowOverlay.value = false;
              }),
        ],
      ),
      showOverlay: isShowOverlay.value,
      child: SliverScrollingWidget(
        children: [
          30.verticalSpace,
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  context.pop();
                },
              ),
              Text(
                AppStrings.personalInformations,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // subscription card based on the user subscription
            ],
          ),
          10.verticalSpace,
          Builder(
            builder: (context) {
              final badgeIconUrl = user.badge?.iconUrl;
              final badgeColor = user.badge?.color;
              final themeColor = badgeColor != null
                  ? Color(int.parse(badgeColor.replaceAll('#', '0xFF')))
                  : const Color(0xFF2DD4BF);

              return Stack(
                children: [
                  ShieldBadge(
                    localAvatarImage: localImage.value != null ? FileImage(localImage.value!) : null,
                    userAvatarUrl: localImage.value == null ? user.completeProfilePic : null,
                    badgeIconUrl: badgeIconUrl,
                    themeColor: themeColor,
                    width: 100,
                    height: 125,
                    avatarPaddingTop: 25,
                    avatarSize: 85,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 15,
                    child: GestureDetector(
                      onTap: () async {
                        final resultImage = await ImagePickerService.pickImage();
                        if (resultImage != null) {
                          localImage.value = resultImage;
                          isShowOverlay.value = true;
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: const Icon(Icons.edit, color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                  if (localImage.value != null)
                    Positioned(
                      top: 5,
                      right: 15,
                      child: GestureDetector(
                        onTap: () {
                          localImage.value = null;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.all(Radius.circular(4))),
                          child: const Icon(Icons.cancel,
                              color: Colors.white, size: 10),
                        ),
                      ),
                    ),
                ],
              );
            }
          ),
          // 10.verticalSpace,
          //iser points
          if (user.subscriptions.isNotEmpty) ...[
            8.verticalSpace,
            Container(
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0.5,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  children: [
                    // Points Section
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 6.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.pink.shade300,
                              Colors.pink.shade400,
                              Colors.pink.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Container(
                            //   width: 24.w,
                            //   height: 24.h,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     gradient: LinearGradient(
                            //       colors: [
                            //         Colors.amber.shade300,
                            //         Colors.orange.shade400,
                            //       ],
                            //       begin: Alignment.topCenter,
                            //       end: Alignment.bottomCenter,
                            //     ),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.amber.withValues(alpha: 0.3),
                            //         blurRadius: 4,
                            //         offset: const Offset(0, 1),
                            //       ),
                            //     ],
                            //   ),
                            //   child: Icon(
                            //     Icons.auto_awesome,
                            //     color: Colors.white,
                            //     size: 12.sp,
                            //   ),
                            // ),
                            // 4.verticalSpace,
                            Text(
                              "${user.points}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              "نقاط",
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    6.horizontalSpace,

                    // Subscription Section
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade300,
                              Colors.purple.shade400,
                              Colors.purple.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.workspace_premium,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                            6.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currentUserSubscription.name,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: 0.2,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "اشتراك نشط",
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.greenAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent
                                        .withValues(alpha: 0.5),
                                    blurRadius: 3,
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          20.verticalSpace,
          CustomTextFormField(
            controller: nameController,
            labelText: AppStrings.name,
            // validator: Validators.validateEmail,
            suffix: const Icon(Icons.person, color: AppColors.primaryColor),
          ),
          20.verticalSpace,
          CustomTextFormField(
            controller: ageController,
            labelText: "العمر",
            keyboardType: TextInputType.phone,
            suffix: const Icon(Icons.cake, color: AppColors.primaryColor),
            // validator: Validators.validatePassword,
          ),
          20.verticalSpace,
          CustomTextFormField(
            controller: phoneController,
            labelText: AppStrings.phoneNumber,
            keyboardType: TextInputType.phone,
            suffix: const Icon(Icons.phone, color: AppColors.primaryColor),
            // validator: Validators.validatePassword,
          ),
          20.verticalSpace,
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
          20.verticalSpace,
          TayssirDropDown<Commune>(
            selectedItem: commune.value,
            items: ref.watch(communesProvider(wilaya.value.number)).isLoading
                ? []
                : communes,
            onChanged: (value) {
              if (value == commune.value) return;
              commune.value = value;
            },
            hintText: AppStrings.dairaOrCommune,
            iconPath: SVGs.icCommune,
          ),
          20.verticalSpace,
          TayssirDropDown<DivisionModel>(
            selectedItem: division.value,
            items: ref.watch(divisionsProvider).requireValue,
            onChanged: (value) {
              division.value = value;
            },
            hintText: AppStrings.speciality,
            iconPath: SVGs.icSpecitlity,
          ),
          const Spacer(),
          if (context.isMediumDevice || context.isSmallDevice) 20.verticalSpace,
          BigButton(
              text: 'حفظ التغييرات',
              onPressed: ref.watch(profileControllerProvider).isLoading
                  ? null
                  : () {
                      ref
                          .read(profileControllerProvider.notifier)
                          .updateUser(UpdateUserRequest(
                            name: nameController.text,
                            // email: user.email,

                            age: int.parse(ageController.text),
                            phoneNumber: phoneController.text,
                            image: localImage.value,
                            wilayaId: wilaya.value.number,
                            communeId: commune.value!.number,
                            devisionId: division.value!.id,
                          ));
                    }),
          20.verticalSpace,
        ],
      ),
    );
  }
}
