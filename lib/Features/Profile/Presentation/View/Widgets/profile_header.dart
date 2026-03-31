import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskflow/Core/Constants/app_colors.dart';
import 'package:taskflow/Core/Constants/app_spacing.dart';
import 'package:taskflow/Core/Utils/service_locator.dart';
import 'package:taskflow/Features/Auth/Data/Data_sources/local_data_source.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadFromAuthCache();
  }

  Future<void> _loadFromAuthCache() async {
    final user = await getIt<AuthLocalDataSource>().getCachedUser();
    if (!mounted) return;
    setState(() {
      if (user != null) {
        _firstName = user.firstname;
        _lastName = user.lastname;
        _email = user.email;
        final url = user.profileImageUrl?.trim();
        _profileImageUrl = (url != null && url.isNotEmpty) ? url : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '$_firstName $_lastName'.trim();
    final displayName = fullName.isNotEmpty ? fullName : 'Guest User';

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.appThemeColors.borderColor.withOpacity(0.5),
                  width: 2,
                ),
                image: _profileImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_profileImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: _profileImageUrl == null
                    ? context.appThemeColors.borderColor.withOpacity(0.2)
                    : null,
              ),
              child: _profileImageUrl == null
                  ? Icon(
                      Icons.person_rounded,
                      size: 48.sp,
                      color: context.appThemeColors.textLight,
                    )
                  : null,
            ),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.appThemeColors.backgroundColor,
                  width: 2,
                ),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 14.sp),
            ),
          ],
        ),
        AppSpacing.gapV16,
        Text(
          displayName,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: context.appThemeColors.textDark,
          ),
        ),
        AppSpacing.gapV4,
        Text(
          _email.isNotEmpty ? _email : '—',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: context.appThemeColors.textLight,
          ),
        ),
      ],
    );
  }
}
