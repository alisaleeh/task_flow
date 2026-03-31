import 'package:flutter/material.dart';

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textDark;
  final Color textLight;
  final Color borderColor;

  const AppThemeColors({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textDark,
    required this.textLight,
    required this.borderColor,
  });

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textDark,
    Color? textLight,
    Color? borderColor,
  }) {
    return AppThemeColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textDark: textDark ?? this.textDark,
      textLight: textLight ?? this.textLight,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) return this;

    return AppThemeColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}

extension AppThemeColorsContext on BuildContext {
  AppThemeColors get appThemeColors =>
      Theme.of(this).extension<AppThemeColors>()!;
}

