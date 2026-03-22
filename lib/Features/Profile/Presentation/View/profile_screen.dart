import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Widgets/custom_app_bar.dart';

// استيراد المكونات المجزأة
import 'Widgets/profile_header.dart';
import 'Widgets/task_statistics_card.dart';
import 'Widgets/account_settings_section.dart';
import 'Widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.textDark, size: 28.sp),
            onPressed: () {
              // TODO: Open bottom sheet or menu
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child:  AppSpacing.gapV24),
            
            // 1. صورة الملف الشخصي والاسم
            const SliverToBoxAdapter(child: ProfileHeader()),
            SliverToBoxAdapter(child:  AppSpacing.gapV32),
            
            // 2. بطاقة الإحصائيات (Statistics)
            const SliverToBoxAdapter(child: TaskStatisticsCard()),
            SliverToBoxAdapter(child:  AppSpacing.gapV32),
            
            // 3. قسم الإعدادات (Settings)
            const SliverToBoxAdapter(child: AccountSettingsSection()),
            SliverToBoxAdapter(child:  AppSpacing.gapV40),
            
            // 4. زر تسجيل الخروج
            const SliverToBoxAdapter(child: LogoutButton()),
            
            // مسافة سفلية لحماية المحتوى من الـ Bottom Navigation Bar
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}