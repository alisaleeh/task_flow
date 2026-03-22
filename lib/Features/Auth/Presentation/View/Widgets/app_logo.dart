import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskflow/Core/Constants/app_images.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100.w,
        height: 100.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: SvgPicture.asset(
            AppImages.logo,
            width: 100.w,
            height: 100.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
