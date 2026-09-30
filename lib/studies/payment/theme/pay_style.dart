import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';

/// Warm paper, one muted sage accent. No pure black or pure white.
abstract final class PayColors {
  static const paper = AppColors.paper;
  static const ink = AppColors.ink;
  static const inkSoft = AppColors.inkSoft;
  static const inkFaint = AppColors.inkFaint;
  static const line = AppColors.line;
  static const sheet = Color(0xFFFFFCF8);
  static const recess = Color(0xFFE4DED6);
  static const tint = Color(0xFFF3EEE7);
  static const inkPressed = Color(0xFF2C2926);
  static const sage = Color(0xFF5E6D55);
  static const sageWash = Color(0xFFE4EDE1);
  static const onInk = AppColors.paper;
}

abstract final class PayType {
  static const pill = TextStyle(
    inherit: false,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1,
    letterSpacing: -0.2,
    color: PayColors.onInk,
    decoration: TextDecoration.none,
  );
  static const title = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.15,
    letterSpacing: -0.6,
    color: PayColors.ink,
  );
  static const price = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.05,
    letterSpacing: -0.6,
    fontFeatures: [FontFeature.tabularFigures()],
    color: PayColors.ink,
  );
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.35,
    letterSpacing: -0.2,
    color: PayColors.inkSoft,
  );
  static const bodyInk = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.35,
    letterSpacing: -0.2,
    color: PayColors.ink,
  );
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.35,
    letterSpacing: 0.05,
    color: PayColors.inkFaint,
  );
  static const tag = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.2,
    letterSpacing: 1.4,
    color: PayColors.inkSoft,
  );
  static const planName = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.2,
    letterSpacing: -0.2,
    color: PayColors.ink,
  );
  static const badge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.1,
    letterSpacing: -0.1,
    color: PayColors.sage,
  );
  static const studioTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 28,
    height: 1.15,
    letterSpacing: -0.5,
    color: PayColors.ink,
  );
}
