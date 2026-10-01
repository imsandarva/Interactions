import 'package:flutter/widgets.dart';

import 'package:interactions/app/theme/app_colors.dart';

/// Warm paper, the shared clay accent, one dark invitation.
abstract final class FeedbackColors {
  static const paper = AppColors.paper;
  static const ink = AppColors.ink;
  static const inkSoft = AppColors.inkSoft;
  static const inkFaint = AppColors.inkFaint;
  static const accent = AppColors.accent;
  static const onInk = AppColors.paper;
  static const inkPressed = Color(0xFF2C2926);
  static const lift = Color(0x141C1A17);
  static const glow = Color(0x2EB08968);
  static const glowFade = Color(0x00B08968);
}

abstract final class FeedbackType {
  static const mark = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 1.2,
    letterSpacing: 0.2,
    color: FeedbackColors.inkFaint,
  );
  static const headline = TextStyle(
    fontFamily: 'Instrument Serif',
    fontSize: 56,
    height: 0.92,
    letterSpacing: -1.4,
    color: FeedbackColors.ink,
  );
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 1.45,
    letterSpacing: -0.15,
    color: FeedbackColors.inkSoft,
  );
  static const action = TextStyle(
    inherit: false,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 17,
    height: 1,
    letterSpacing: -0.25,
    color: FeedbackColors.onInk,
    decoration: TextDecoration.none,
  );
}
