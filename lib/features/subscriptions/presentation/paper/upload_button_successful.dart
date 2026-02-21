import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadButtonSuccessful extends StatelessWidget {
  const UploadButtonSuccessful({
    super.key,
    required this.filename,
    required this.fileSize,
  });

  final String filename;
  final double fileSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(Icons.check, color: Colors.white, size: 20.w),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تم الرفع بنجاح",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[800],
                  ),
                ),
                Text(
                  "$filename • ${(fileSize / 1024).toStringAsFixed(0)} كيلوبايت",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
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
