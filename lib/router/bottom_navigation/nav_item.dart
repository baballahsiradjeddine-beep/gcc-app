import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tayssir/common/push_buttons/rounded_pushable_button.dart';

class NavItem extends HookWidget {
  const NavItem(
      {super.key,
      required this.ontap,
      required this.isSelected,
      required this.index,
      required this.icon,
      required this.label});

  final Function(int) ontap;
  final bool isSelected;
  final int index;
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isSelected
          ? PushableImageButton(
              size: 40,
              image: const AssetImage('assets/images/home.png'),
              isCircle: true,
              icon: SvgPicture.asset(
                icon,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                height: 30,
              ),
              borderRadius: 20,
              topColor: const Color(0xff00C4F6),
              bottomColor: const Color(0xff009DC5),
              elevation: 5,
              borderWidth: 0,
              borderColor: Colors.blue,
              onPressed: () {
                ontap(index);
              },
            )
          : GestureDetector(
              onTap: () => ontap(index),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon,
                      colorFilter:
                          const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                      height: 24,
                    ),
                    3.verticalSpace,
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
