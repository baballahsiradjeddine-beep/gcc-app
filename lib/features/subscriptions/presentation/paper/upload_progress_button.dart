import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class UploadProgressButton extends HookWidget {
  const UploadProgressButton({
    super.key,
    required this.filename,
    this.current = 0,
    this.total = 100,
    required this.onStop,
  });

  final double current;
  final double total;
  final String filename;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: LiquidLinearProgressIndicator(
          value: current / total,
          valueColor: AlwaysStoppedAnimation(Colors.blue.withOpacity(0.2)),
          borderColor: Colors.white,
          borderWidth: 1,
          backgroundColor: Colors.white,
          borderRadius: 12.r,
          direction: Axis.horizontal,
          center: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.upload_file, size: 20.w),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "جاري رفع المستند",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: current / total,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                      ),
                      Text(
                        "${(current).toStringAsFixed(0)}% اكتمل",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onStop,
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
