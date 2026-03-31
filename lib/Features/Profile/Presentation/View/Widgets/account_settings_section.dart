import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Theme/theme_cubit.dart';
import 'package:taskflow/Core/Theme/theme_state.dart';

class AccountSettingsSection extends StatefulWidget {
  const AccountSettingsSection({super.key});

  @override
  State<AccountSettingsSection> createState() => _AccountSettingsSectionState();
}

class _AccountSettingsSectionState extends State<AccountSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.isDarkMode;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACCOUNT SETTINGS',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: context.appThemeColors.textLight,
                  letterSpacing: 1.2,
                ),
              ),
              AppSpacing.gapV16,
              _SettingItemTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                trailing: CupertinoSwitch(
                  value: isDarkMode,
                  activeColor: AppColors.primaryOrange,
                  onChanged: (value) => context
                      .read<ThemeCubit>()
                      .setDarkMode(value),
                ),
                onTap: () => context.read<ThemeCubit>().toggleDarkMode(),
              ),
            ],
          ),
        );
      },
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
                color: context.appThemeColors.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: context.appThemeColors.borderColor.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: context.appThemeColors.textDark,
                size: 22.sp,
              ),
            ),
            AppSpacing.gapH16,
            // العنوان
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.appThemeColors.textDark,
                ),
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