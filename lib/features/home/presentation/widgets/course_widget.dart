import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tayssir/features/tools/common/models/tool_model.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardWidget extends ConsumerWidget {
  const CardWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.startColor,
    required this.endColor,
    this.imageList = '',
    this.imageGrid = '',
    this.isGrid = false,
    this.isLocked = false,
    this.toolImage,
    this.isStartBottomColor = true,
  });

  final bool isLocked;
  final String title;
  final String subTitle;
  final Function onPressed;
  final Color startColor;
  final Color endColor;
  final bool isGrid;
  final String imageList;
  final String imageGrid;
  // Optional fields for ToolsScreen compatibility
  final ToolImage? toolImage;
  final bool isStartBottomColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGrid) {
      return _buildGridCard(context, ref);
    } else {
      return _buildListCard(context, ref);
    }
  }

  Widget _buildGridCard(BuildContext context, WidgetRef ref) {
    // Default to math image if empty
    final String actualGridImage = imageGrid.isNotEmpty ? imageGrid : 'modules/images_grid/math.png';
    final String fullImageUrl = actualGridImage.startsWith('http') 
        ? actualGridImage 
        : 'https://gcc.tayssir-bac.com/storage/${actualGridImage.replaceAll(RegExp(r'^/'), '')}';

    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          ref.read(specialEffectServiceProvider).playEffects();
          onPressed();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Decorative Circle (Right Top)
              Positioned(
                right: -20.w,
                top: -20.h,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Image (Vertically Centered on the LEFT)
              Positioned(
                left: -22.w, // Brought back inside from -45.w
                top: 0,
                bottom: 0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: fullImageUrl,
                    height: 105.h,
                    width: 105.h,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) => Text(
                      _getEmojiForSubject(title),
                      style: TextStyle(fontSize: 75.sp),
                    ),
                  ),
                ),
              ),

              // Content Layer (Texts and Button - Constrained to the RIGHT)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h), // Less overall padding for more space
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 88.w, // Wider width to prevent excessive wrapping
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Right in RTL
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          maxLines: 2, // Allow max 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp, // Slightly smaller
                            fontWeight: FontWeight.w900,
                            fontFamily: 'SomarSans',
                            height: 1.1,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              subTitle.replaceAll('<br>', ' ').replaceAll('<br class="br-hide">', ' '), // Use spaces instead of forced breaks
                              textAlign: TextAlign.start,
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis, // Elegantly clip if too long
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 11.sp, // Slightly tweaked for better fit
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SomarSans',
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                        // Action Button (Explicitly in the Right)
                        Align(
                          alignment: Alignment.centerRight, 
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isLocked ? "قريباً" : "إبدأ الآن",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp, // Decreased as requested
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SomarSans',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context, WidgetRef ref) {
    // Default to math image if empty
    final String actualListImage = imageList.isNotEmpty ? imageList : 'modules/images_list/math.png';
    final String fullImageUrl = actualListImage.startsWith('http') 
        ? actualListImage 
        : 'https://gcc.tayssir-bac.com/storage/${actualListImage.replaceAll(RegExp(r'^/'), '')}';

    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          ref.read(specialEffectServiceProvider).playEffects();
          onPressed();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 118.h, // Decreased as requested
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Decorative Circle
              Positioned(
                right: -30.w,
                top: -30.h,
                child: Container(
                  width: 110.w,
                  height: 110.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.only(right: 20.w, left: 5.w, top: 10.h, bottom: 10.h), // Reduced vertical padding from 14.h to 10.h
                child: Row(
                  children: [
                    // Content (Strictly Right side in RTL Row)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Start is RIGHT in RTL
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SomarSans',
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            subTitle.replaceAll('<br>', ' ').replaceAll('<br class="br-hide">', ' '),
                            textAlign: TextAlign.start,
                            maxLines: 2, // Allow 2 lines instead of 1
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13.sp, // Reduced slightly to accommodate 2 lines gracefully
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SomarSans',
                              height: 1.2,
                            ),
                          ),
                          10.verticalSpace,
                          // Action Button
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 7.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(color: Colors.white.withOpacity(0.35)),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              isLocked ? "قريباً" : "إبدأ الآن",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp, // Decreased as requested
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SomarSans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    16.horizontalSpace,

                    // Image (Strictly Left side in RTL Row)
                    CachedNetworkImage(
                      imageUrl: fullImageUrl,
                      height: 105.h,
                      width: 105.h,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => Text(
                        _getEmojiForSubject(title),
                        style: TextStyle(fontSize: 90.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEmojiForSubject(String title) {
    if (title.contains('رياضيات')) return '👩‍🎤';
    if (title.contains('اجتماعيات')) return '🧑‍🏫';
    if (title.contains('إنجليزية')) return '🧕';
    if (title.contains('عربية')) return '🕌';
    if (title.contains('فرنسية')) return '🇫🇷';
    if (title.contains('علوم')) return '🔬';
    if (title.contains('فيزياء')) return '🧪';
    if (title.contains('فلسفة')) return '🤔';
    if (title.contains('إسلامية')) return '🌙';
    return '🤖';
  }
}
