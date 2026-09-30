import 'package:flutter/material.dart';

import 'package:interactions/app/theme/app_colors.dart';

/// Display is Instrument Serif. Everything else is Inter.
abstract final class AppType {
  static const date = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 1.2,
    letterSpacing: 0.2,
    color: AppColors.inkFaint,
  );
  static const display = TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: 60,
    height: 1,
    letterSpacing: -1.2,
    color: AppColors.ink,
  );
  static const subtitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16.5,
    height: 1.45,
    color: AppColors.inkSoft,
  );
  static const label = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.2,
    letterSpacing: 0.1,
    color: AppColors.ink,
  );
  static const labelMuted = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 1.2,
    color: AppColors.inkFaint,
  );
  static const ghostNumber = TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: 148,
    height: 0.9,
    letterSpacing: -4,
    color: AppColors.ghost,
  );
  static const emptyTitle = TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: 32,
    height: 1.05,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
  static const emptyBody = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 15.5,
    height: 1.5,
    color: AppColors.inkSoft,
  );
  static const number = TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: 28,
    height: 1,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
  static const rowTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 17,
    height: 1.2,
    letterSpacing: -0.2,
    color: AppColors.ink,
  );
  static const rowNote = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.35,
    color: AppColors.inkSoft,
  );
}
