import 'package:flutter/material.dart';

import 'package:interactions/app/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: AppColors.paper,
      splashFactory: NoSplash.splashFactory,
      highlightColor: const Color(0x00000000),
      colorScheme: const ColorScheme.light(
        surface: AppColors.paper,
        primary: AppColors.ink,
        onSurface: AppColors.ink,
      ),
    );
  }
}
