import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Features/Home/Presentation/Manager/Task_cubit/task_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskCubit>(); // جلب الـ Cubit للوصول لبيانات المستخدم
   final String fullname= '${cubit.firstName} ${cubit.lastName}'.trim(); // بناء الاسم الكامل من الاسم الأول والأخير
    return Column(
      children: [
        // Avatar with Edit Badge
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderColor.withOpacity(0.5), width: 2),
                image: const DecorationImage(
                  // صورة مؤقتة، لاحقاً تأتي من الـ API
                  image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Edit Badge
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
            ),
          ],
        ),
        AppSpacing.gapV16,
        // Name
        Text(
          fullname.isNotEmpty ? fullname : 'Guest User', 
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        AppSpacing.gapV4,
        // Email
        Text(
          'alex.j@example.com',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textLight),
        ),
      ],
    );
  }
}