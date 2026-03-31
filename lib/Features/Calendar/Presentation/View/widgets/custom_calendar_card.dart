import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CustomCalendarCard extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final List<String> Function(DateTime day) eventLoader;

  const CustomCalendarCard({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.onDaySelected,
    required this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.appThemeColors.surfaceColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          eventLoader: eventLoader,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: context.appThemeColors.textDark,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: context.appThemeColors.textLight,
              size: 28.sp,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: context.appThemeColors.textLight,
              size: 28.sp,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: context.appThemeColors.textLight,
            ),
            weekendStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: context.appThemeColors.textLight,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            defaultTextStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.appThemeColors.textDark,
            ),
            weekendTextStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: context.appThemeColors.textDark,
            ),
            todayDecoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            selectedTextStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            markerMargin: EdgeInsets.only(top: 6.h),
          ),
          rowHeight: 48.h,
        ),
      ),
    );
  }
}