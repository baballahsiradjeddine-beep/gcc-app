import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tayssir/common/custom_cached_image.dart';
import 'package:tayssir/debug/app_logger.dart';
import 'package:tayssir/providers/special_effect/special_effect_provider.dart';

import '../../../../common/push_buttons/pushable_button.dart';
import '../../../../common/app_buttons/app_button.dart';

class ToolImage {
  final String grid;
  final String list;

  const ToolImage({
    required this.grid,
    required this.list,
  });
}

//TODO:THIS NEED to be refectored in the future to a better widget , because i kept adding things to it and now it become bad
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
    this.toolImage,
    this.isLocked = false,
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
  final ToolImage? toolImage;
  final bool isStartBottomColor;
  _buildContent() {
    if (isGrid) {
      return Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (imageList.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      subTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                    12.verticalSpace,
                    SmallButton(
                      text: isLocked ? 'قريباً' : 'إبدأ الآن',
                      onPressed: () {
                        if (isLocked) {
                          return;
                        }
                        onPressed();
                      },
                      color: endColor,
                    ),
                    12.verticalSpace,
                  ],
                ),
              ),
            if (imageList.isEmpty)
              SizedBox(
                width: 0.25.sw,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      subTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                    ),
                    12.verticalSpace,
                    SmallButton(
                      text: isLocked ? 'قريباً' : 'إبدأ الآن',
                      onPressed: () {
                        if (isLocked) {
                          return;
                        }
                        onPressed();
                      },
                      color: endColor,
                    ),
                    12.verticalSpace,
                  ],
                ),
              ),
            if (imageList.isNotEmpty)
              Expanded(child: CustomCachedImage(imageUrl: imageGrid)),
          ],
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  5.verticalSpace,
                  Text(
                    subTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  10.verticalSpace,
                  SmallButton(
                    text: isLocked ? 'قريباً' : 'إبدأ الآن',
                    onPressed: () {
                      if (isLocked) {
                        return;
                      }
                      AppLogger.logInfo('CardWidget onPressed');
                      onPressed();
                    },
                    color: endColor,
                    width: 100.w,
                  ),
                ],
              ),
            ),
          ),
          if (imageList.isNotEmpty)
            Expanded(
              flex: 2,
              child: CustomCachedImage(imageUrl: imageList),
            ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgetSize = isGrid ? 110.h : 110.h;
    return Container(
      margin: EdgeInsets.only(
        bottom: isGrid ? 20.h : 10.h,
      ),
      child: PushableButton(
        height: widgetSize,

        elevation: 4,
        // disabledAnimation: true,
        onPressed: () {
          if (isLocked) {
            return;
          }
          ref.read(specialEffectServiceProvider).playEffects();

          onPressed();
        },
        useHslBottom: true,
        borderRadius: 10,
        hslColor: HSLColor.fromColor(
          isStartBottomColor ? startColor : endColor,
        ),
        hasBorder: false,
        child: Container(
            height: widgetSize,
            decoration: BoxDecoration(
                image: toolImage != null
                    ? DecorationImage(
                        image: isGrid
                            ? AssetImage(toolImage!.grid)
                            : AssetImage(toolImage!.list),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    startColor,
                    endColor,
                  ],
                )),
            padding: EdgeInsets.fromLTRB(
              0,
              isGrid ? 0.h : 0.h,
              10,
              0,
            ),
            child: _buildContent()),
      ),
    );
  }
}
