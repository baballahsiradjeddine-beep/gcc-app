import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon,
  });

  final bool isSelected;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        //TODO
        color: isSelected ? const Color(0xffECF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? const Color(0xffBEE0FF) : Colors.grey,
          width: 1.w,
        ),
        boxShadow: const [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.5),
          //   spreadRadius: 1,
          //   blurRadius: 2,
          //   offset: const Offset(0, 1),
          // ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black,
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
