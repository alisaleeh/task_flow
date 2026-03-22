import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';

class CustomCalendarCard extends StatefulWidget {
  const CustomCalendarCard({super.key});

  @override
  State<CustomCalendarCard> createState() => _CustomCalendarCardState();
}

class _CustomCalendarCardState extends State<CustomCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // تحديد اليوم الحالي كافتراضي
  }

  // محاكاة جلب الأحداث (Events) لرسم النقاط البرتقالية تحت الأيام
  List<String> _getEventsForDay(DateTime day) {
    // كود وهمي: نضع نقطة برتقالية تحت الأيام التي تقبل القسمة على 5 أو 8
    if (day.day % 5 == 0 || day.day % 8 == 0) {
      return ['Task']; 
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(16.w), // تقليل الـ padding قليلاً لأن الحزمة تأخذ مساحة
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA), // لون خلفية التقويم
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          
          // 👈 هنا يتم تغيير حالة اليوم المحدد
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // TODO: استدعاء Cubit لجلب مهام اليوم المحدد
              // context.read<TasksCubit>().fetchTasksForDate(selectedDay);
            }
          },
          
          eventLoader: _getEventsForDay, // دالة تحميل النقاط
          
          // --- 🎨 تنسيق الهيدر (الشهر والأسهم) ---
          headerStyle: HeaderStyle(
            formatButtonVisible: false, // إخفاء زر تغيير شكل التقويم (أسبوع/شهر)
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16.sp, 
              fontWeight: FontWeight.bold, 
              color: AppColors.textDark,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textLight, size: 28.sp),
            rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textLight, size: 28.sp),
          ),
          
          // --- 🎨 تنسيق أيام الأسبوع (SUN, MON...) ---
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.textLight),
            weekendStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.textLight),
          ),
          
          // --- 🎨 تنسيق الأيام والنقاط ---
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false, // إخفاء أيام الشهر السابق/التالي
            
            // تصميم اليوم العادي
            defaultTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textDark),
            weekendTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textDark),
            
            // تصميم اليوم الحالي (بدون تحديد)
            todayDecoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
            
            // تصميم اليوم المحدد (Shadow + Orange)
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
            selectedTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white),
            
            // تصميم النقاط السفلية (Markers)
            markersMaxCount: 1, // إظهار نقطة واحدة كحد أقصى حتى لو كان هناك 10 مهام
            markerDecoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            markerMargin: EdgeInsets.only(top: 6.h), // مسافة النقطة عن الرقم
          ),
          
          // إجبار صفوف التقويم على أخذ الارتفاع المناسب (لحماية التصميم من التشوه)
          rowHeight: 48.h,
        ),
      ),
    );
  }
}