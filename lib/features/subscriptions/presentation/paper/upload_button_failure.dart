import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadButtonFailure extends StatelessWidget {
  const UploadButtonFailure({
    super.key,
    required this.onTap,
    required this.filename,
  });

  final VoidCallback onTap;
  final String filename;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.error, color: Colors.white, size: 20.w),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "فشل الرفع",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[800],
                  ),
                ),
                Text(
                  "الملف كبير جداً. الحد الأقصى ١٠ ميجا.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.refresh, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
