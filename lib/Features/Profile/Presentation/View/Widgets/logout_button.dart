import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          // TODO: Trigger AuthCubit to logout
        },
        icon: Icon(Icons.logout_rounded, color: const Color(0xFFE53935), size: 24.sp),
        label: Text(
          'Log Out',
          style: TextStyle(
            fontSize: 16.sp, 
            fontWeight: FontWeight.bold, 
            color: const Color(0xFFE53935), // لون أحمر مخصص
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        ),
      ),
    );
  }
}