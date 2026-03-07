// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tayssir/providers/user/user_notifier.dart';
import 'package:tayssir/resources/colors/app_colors.dart';
import 'package:tayssir/services/actions/dialog_service.dart';

class FilterSection<T> extends ConsumerWidget {
  final List<T> items;
  final bool isPremium;
  final Function(T) onItemPressed;
  // final String Function(T) itemLabelExtractor;
  // final int Function(T) itemIdExtractor;
  final Function onClearAllSelected;
  final String allLabel;
  final Color filterColor;
  final bool Function(T) selectionExtractor;
  final Function(T) getLabel;
  final bool isAllOptionsPressed;
  final double padding;
  final Color? labelColor;

  const FilterSection({
    super.key,
    required this.items,
    required this.isPremium,
    required this.onItemPressed,
    // required this.itemLabelExtractor,
    // required this.itemIdExtractor,
    required this.onClearAllSelected,
    required this.selectionExtractor,
    required this.isAllOptionsPressed,
    required this.getLabel,
    this.allLabel = 'الكل',
    this.filterColor = Colors.blue,
    this.padding = 8,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).requireValue;
    final isSubscribed = user!.isSub;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 37.h,
      margin: EdgeInsets.only(
        bottom: 8.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: padding.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length + 1,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (context, index) {
          final isAllChip = index == 0;
          final isSelected = isAllChip
              ? isAllOptionsPressed
              : selectionExtractor(items[index - 1]);
          final chipText = isAllChip ? allLabel : getLabel(items[index - 1]);

          return GestureDetector(
            onTap: () {
              if (isAllChip) {
                return;
              } else {
                if (isPremium && !isSubscribed) {
                  DialogService.showNeedSubscriptionDialog(context);
                } else {
                  return;
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 1.h),
                      child: Stack(
                        children: [
                          FilterChip(
                            label: FittedBox(
                              child: Text(
                                chipText,
                                style: TextStyle(
                                  color: isSelected
                                      ? labelColor ?? Colors.white
                                      : Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            selectedColor: filterColor,
                            backgroundColor: Colors.grey.shade100,
                            shadowColor: filterColor.withOpacity(0.3),
                            elevation: isSelected ? 3 : 0,
                            pressElevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 2.h),
                            onSelected: (_) {
                              if (isAllChip) {
                                onClearAllSelected();
                              } else {
                                if (isPremium && !isSubscribed) {
                                  DialogService.showNeedSubscriptionDialog(
                                      context);
                                } else {
                                  onItemPressed(items[index - 1]);
                                }
                              }
                            },
                          ),
                          if (!isAllChip && isPremium && !isSubscribed)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 1.5, sigmaY: 1.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.borderColor.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
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
        },
      ),
    );
  }
}
