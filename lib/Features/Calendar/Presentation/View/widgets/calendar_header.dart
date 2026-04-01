import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  String _currentMonthYear() {
    final now = DateTime.now();
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: context.appThemeColors.textDark,
                ),
              ),
              Text(
                _currentMonthYear(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: context.appThemeColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
