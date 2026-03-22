import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';

class AccountSettingsSection extends StatefulWidget {
  const AccountSettingsSection({super.key});

  @override
  State<AccountSettingsSection> createState() => _AccountSettingsSectionState();
}

class _AccountSettingsSectionState extends State<AccountSettingsSection> {
  bool isDarkMode = false; // Ephemeral State

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACCOUNT SETTINGS',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.textLight, letterSpacing: 1.2),
          ),
          AppSpacing.gapV16,
          
          _SettingItemTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            trailing: Icon(Icons.chevron_right, color: AppColors.textLight, size: 24.sp),
            onTap: () {},
          ),
          AppSpacing.gapV12,
          _SettingItemTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            trailing: Icon(Icons.chevron_right, color: AppColors.textLight, size: 24.sp),
            onTap: () {},
          ),
          AppSpacing.gapV12,
          _SettingItemTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: CupertinoSwitch( // 👈 زر التشغيل الخاص بـ iOS كما في التصميم
              value: isDarkMode,
              activeColor: AppColors.primaryOrange,
              onChanged: (value) {
                setState(() => isDarkMode = value);
              },
            ),
            onTap: () {
              setState(() => isDarkMode = !isDarkMode);
            },
          ),
          AppSpacing.gapV12,
          _SettingItemTile(
            icon: Icons.shield_outlined,
            title: 'Security',
            trailing: Icon(Icons.chevron_right, color: AppColors.textLight, size: 24.sp),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ويدجت مساعدة مسؤولة عن رسم سطر الإعدادات الواحد
class _SettingItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  const _SettingItemTile({
    required this.icon,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            // أيقونة بخلفية رمادية/زرقاء فاتحة
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8), // لون الخلفية للأيقونة
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.textDark, size: 22.sp),
            ),
            AppSpacing.gapH16,
            // العنوان
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textDark),
              ),
            ),
            // العنصر الأخير (سهم أو سويتش)
            trailing,
          ],
        ),
      ),
    );
  }
}