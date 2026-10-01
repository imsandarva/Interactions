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
  static const scrim = Color(0xFF1C1A17);
  static const thumb = Color(0xFFFFFCF8);
  static const thumbShadow = Color(0x241C1A17);
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
  static const question = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 17.5,
    height: 1.25,
    letterSpacing: -0.25,
  );
  static const moodWord = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 32,
    height: 1.05,
    letterSpacing: -0.7,
  );
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 1.2,
    letterSpacing: -0.1,
  );
  static const captionOn = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.2,
    letterSpacing: -0.15,
  );
}
